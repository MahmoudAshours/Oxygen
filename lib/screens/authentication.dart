import 'package:flutter/material.dart';
import 'package:oxygen/helpers/auth_provider.dart';
import 'package:oxygen/helpers/color_pallete.dart';
import 'package:oxygen/helpers/strings.dart';
import 'package:oxygen/helpers/utils.dart';
import '../main.dart';
import '../widgets/no_glow_behavior.dart';

class AuthenticationWidget extends StatefulWidget {
  final Auth initialAuth;

  const AuthenticationWidget(this.initialAuth);

  @override
  _AuthenticationWidgetState createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  Auth? state;
  late List<String> labels;
  late List<String> mapKeys;
  late Map<String, String> authData;

  @override
  void initState() {
    labels = ['Username', 'Email', 'Password', 'Confirm password'];
    mapKeys = ['username', 'email', 'password', 'repassword'];
    authData = {};
    state = widget.initialAuth;
    super.initState();
  }

  get isSignIn => state == Auth.SignIn;

  void changeAuthState() =>
      setState(() => state = (isSignIn ? Auth.SignUp : Auth.SignIn));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Pallete.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              isSignIn ? Strings.signInMessage : Strings.signUpMessage,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 30),
            Expanded(child: _buildForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          topLeft: Radius.circular(35),
        ),
      ),
      child: ScrollConfiguration(
        behavior: NoGlowBehaviour(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 170,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 60),
                for (int i = 0; i < (isSignIn ? 2 : 4); i++) _buildTextField(i),
                SizedBox(height: 16),
                _buildAuthButton(
                  text: isSignIn ? Strings.signIn : Strings.signUp,
                  fillColor: Pallete.secondary,
                  onTap: () => authenticateUser(),
                ),
                SizedBox(height: 10),
                // _buildAuthButton(
                //   text: 'Google',
                //   fillColor: Color(0xffE64343),
                //   onTap: () => authenticateUser(gmail: true),
                // ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 25),
                    alignment: Alignment.bottomCenter,
                    child: _buildChangeAuth(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticateUser({bool gmail = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Signing you in'),
        content: FutureBuilder(
          future: gmail
              ? Utils.provider(context, listen: false).googleSignIn()
              : Utils.provider(context, listen: false)
                  .authenticate(authData, state: state),
          builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) return Text('Please be patient');
            if (snapshot.data == 'success')
              WidgetsBinding.instance!.addPostFrameCallback((_) =>
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (_) => false));
            return Text('${snapshot.data}');
          },
        ),
      ),
    );
  }

  Widget _buildChangeAuth() {
    return GestureDetector(
      onTap: () => changeAuthState(),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text:
                    isSignIn ? Strings.switchToSignUp : Strings.switchtoSignIn,
                style: TextStyle(color: Colors.grey[200])),
            TextSpan(
                text: '  ${isSignIn ? Strings.signUp : Strings.signIn}',
                style: TextStyle(
                    color: Pallete.secondary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton(
      {Function? onTap, required String text, Color? fillColor}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: fillColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(1, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Pallete.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(int idx) {
    if (isSignIn) idx++;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            labels[idx],
            style: TextStyle(fontSize: 13, color: Pallete.secondary),
          ),
        ),
        SizedBox(height: 1),
        Container(
          height: 45,
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Color(0xffF1F1F2),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(1, 3),
              ),
            ],
          ),
          child: TextFormField(
            obscureText: mapKeys[idx].contains('password'),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 18.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 18.0),
              ),
            ),
            onChanged: (value) => authData[mapKeys[idx]] = value,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
