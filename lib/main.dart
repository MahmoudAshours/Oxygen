import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/helpers/auth_provider.dart';
import 'package:oxygen/screens/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthProvider? provider;

  @override
  void initState() {
    provider = AuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'Aschente',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(child: SplashWidget()),
        ),
      ),
    );
  }
}
