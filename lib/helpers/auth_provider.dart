import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Auth {
  SignIn,
  SignUp,
}

class AuthProvider extends ChangeNotifier {
  bool? _isLoading;
  late FirebaseAuth firebaseAuth;
  //GoogleSignIn _googleSignIn;

  bool get isLoading => _isLoading!;
  set isLoading(bool? value) {
    _isLoading = value;
    notifyListeners();
  }

  // OR await (_googleSignIn.isSignedIn()
  Future<bool> isAuth() async {
    return firebaseAuth.currentUser != null;
  }

  AuthProvider() {
    firebaseAuth = FirebaseAuth.instance;
    _isLoading = false;
  }

  // Future<String> googleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //     return error.toString();
  //   }

  //   /// [todo] save user credentials.
  //   return 'success';
  // }

  Future<String?> authenticate(Map<String, String> data,
      {Auth state = Auth.SignIn}) async {
    UserCredential user;
    if (state == Auth.SignUp) {
      if (data['password'] != data['repassword'])
        return 'Password doesn\'t match';
    }

    if (!data.containsKey('email') || data['email']!.isEmpty)
      return 'Please enter your email';
    if (!data.containsKey('password') || data['password']!.isEmpty)
      return 'Please enter your password';
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(data['email']!)) return 'Please enter a valid email address';

    try {
      if (state == Auth.SignIn)
        user = await firebaseAuth.signInWithEmailAndPassword(
            email: data['email']!, password: data['password']!);
      else {
        user = await firebaseAuth.createUserWithEmailAndPassword(
            email: data['email']!, password: data['password']!);
        user.user!.updateProfile(displayName: data['username']);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set(
          {'email': data['email'], 'name': data['username']},
        );
      }
    } catch (e) {
      /// [todo] parse error message.

    }

    /// [todo] save user credentials.
    return 'success';
  }
}
