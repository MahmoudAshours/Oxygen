import 'package:flutter/material.dart';
import 'package:oxygen/helpers/auth_provider.dart';
import 'package:oxygen/helpers/color_pallete.dart';
import 'package:oxygen/helpers/strings.dart';
import 'package:oxygen/helpers/utils.dart';
import 'package:oxygen/screens/authentication.dart';
import 'package:oxygen/screens/home.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// [todo] Fetch data and load login or home screen.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(
        Duration(seconds: 2),
        () async {
          bool? isAuth = await Utils.provider(context, listen: false).isAuth();
          print(isAuth);
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    isAuth! ? HomeWidget() : AuthenticationWidget(Auth.SignIn),
              ),
              (Route<dynamic> route) => false);
        },
      );
    });
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        Strings.appName,
                        style: TextStyle(
                          color: Pallete.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Splash screen',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Pallete.primary),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
