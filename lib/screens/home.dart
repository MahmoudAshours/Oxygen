import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oxygen/widgets/gradient_arclight.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [
                  Color(0xff2a1434),
                  Color(0xff160d20),
                  Color(0xff142332)
                ],
              ),
            ),
          ),
          GradientArcLight(
            currentIndex: _selectedIndex,
            onItemPressed: (i) {
              setState(() => _selectedIndex = i);
            },
            buttons: [
              ButtonData(Text('Contest'), FaIcon(FontAwesomeIcons.question)),
              ButtonData(Text('Practice'), FaIcon(FontAwesomeIcons.question)),
              ButtonData(Text('Share'), FaIcon(FontAwesomeIcons.question)),
              ButtonData(Text('Help'), FaIcon(FontAwesomeIcons.question))
            ],
          ),
        ],
      ),
    );
  }
}
