import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class GradientArcLight extends StatefulWidget {
  final List<ButtonData> buttons;
  final int currentIndex;
  final ValueChanged<int> onItemPressed;

  const GradientArcLight(
      {Key? key, required this.buttons, required this.currentIndex, required this.onItemPressed})
      : super(key: key);
  @override
  _GradientArcLightState createState() => _GradientArcLightState();
}

class _GradientArcLightState extends State<GradientArcLight> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.buttons
          .asMap()
          .map((int i, button) => MapEntry(
                i,
                FadeInUp(
                  delay: Duration(milliseconds: i * 200),
                  child: ArclightButton(
                    buttonData: button,
                    onItemPressed: (_) {
                      widget.onItemPressed(i);
                    },
                    selected: i == widget.currentIndex,
                  ),
                ),
              ))
          .values
          .toList(),
    );
  }
}

class ButtonData {
  final text;
  final icon;
  ButtonData(this.text, this.icon);
}

class ArclightButton extends StatefulWidget {
  final ButtonData buttonData;
  final bool selected;
  final ValueChanged<int> onItemPressed;
  const ArclightButton(
      {Key? key, required this.selected, required this.onItemPressed, required this.buttonData})
      : super(key: key);
  @override
  _ArclightButtonState createState() => _ArclightButtonState();
}

class _ArclightButtonState extends State<ArclightButton> {
  Color getColor(Set<MaterialState> states) {
    return Colors.transparent;
  }

  double _radius = 0;
  int _currentIndex = 0;

  _changeColor() {
    widget.onItemPressed(_currentIndex);

    if (_radius == 0) {
      setState(() => _radius = 5);
    } else {
      setState(() => _radius = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrapeziumClipper(),
      child: AnimatedContainer(
        width: 80,
        height: 200,
        duration: Duration(milliseconds: 250),
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith(getColor),
          ),
          onPressed: () => _changeColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.buttonData.text,
              widget.buttonData.icon,
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: RadialGradient(
            radius: widget.selected ? 5 : 0,
            center: Alignment.centerLeft,
            focalRadius: 80,
            colors: [Color(0xffeacf6d), Color(0xff16141e)],
          ),
        ),
      ),
    );
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 10.0);
    path.lineTo(size.height, size.width);
    path.lineTo(1.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
