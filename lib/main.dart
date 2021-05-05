import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:random_color/random_color.dart';
import 'package:sprung/sprung.dart';

List<Item> icons = [
  Item(icon: Icons.opacity),
  Item(
    icon: Icons.bolt,
  ),
  Item(
    icon: Icons.science,
  ),
  Item(
    icon: Icons.lightbulb,
  ),
  Item(
    icon: Icons.work,
  ),
  Item(
    icon: Icons.gavel,
  ),
  Item(
    icon: Icons.label,
  ),
  Item(
    icon: Icons.hourglass_bottom,
  ),
  Item(
    icon: Icons.bolt,
  ),
  Item(
    icon: Icons.science,
  ),
  Item(
    icon: Icons.lightbulb,
  ),
];

class Item {
  Color color;
  IconData icon;

  Item({
    @required this.icon,
  }) {
    color = RandomColor().randomColor(
      colorBrightness: ColorBrightness.light,
      colorSaturation: ColorSaturation.mediumSaturation,
      colorHue: ColorHue.multiple(
        colorHues: [
          ColorHue.blue,
          ColorHue.green,
          ColorHue.pink,
          ColorHue.purple,
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmoothListScroll(),
    );
  }
}

class SmoothListScroll extends StatefulWidget {
  SmoothListScroll({Key key}) : super(key: key);

  @override
  _SmoothListScrollState createState() => _SmoothListScrollState();
}

class _SmoothListScrollState extends State<SmoothListScroll>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  double value = 0;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          value = _animation.value;
        });
      });
  }

  void runAnimation() {
    _animation = _animationController.drive(
      Tween<double>(begin: value, end: 0),
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, 5);

    _animationController.animateWith(simulation);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          onPointerDown: (_) {
            _animationController.stop();
          },
          onPointerMove: (details) {
            if (value >= -30 && value <= 30) {
              value += details.delta.dy * .1;
              setState(() {});
            } else if (value < -30 || value > 30) {
              if (value < 0)
                value = -30;
              else
                value = 30;
            }
          },
          onPointerUp: (_) {
            runAnimation();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: icons.asMap().entries.map<Widget>(
                (entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return GestureDetector(
                    onTap: () {
                      if (index == currentIndex)
                        currentIndex = -1;
                      else
                        currentIndex = index;
                      setState(() {});
                    },
                    child: CustomPaint(
                      painter: Smooth(
                        slasticValue: value,
                        color: item.color,
                      ),
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: 48,
                          end: (index == currentIndex) ? 60 : 48,
                        ),
                        curve: Sprung.underDamped,
                        duration: Duration(milliseconds: 300),
                        builder: (_, padding, __) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: padding,
                            ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class Smooth extends CustomPainter {
  final Color color;
  final double slasticValue;

  Smooth({
    @required this.color,
    @required this.slasticValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.lineTo(0, 0);
    path.quadraticBezierTo(
      size.width / 2,
      -slasticValue,
      size.width,
      0,
    );
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - slasticValue,
      0,
      size.height,
    );
    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
