import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:smooth_list_scroll/smooth_item.dart';
import 'package:smooth_list_scroll/smooth_item_entity.dart';
import 'package:sprung/sprung.dart';

List<SmoothItemEntity> smoothItems = [
  SmoothItemEntity(
    icon: Icons.opacity,
    color: Colors.blue[300],
  ),
  SmoothItemEntity(
    icon: Icons.bolt,
    color: Colors.teal[700],
  ),
  SmoothItemEntity(
    icon: Icons.science,
    color: Colors.pink[400],
  ),
  SmoothItemEntity(
    icon: Icons.lightbulb,
    color: Colors.green[700],
  ),
  SmoothItemEntity(
    icon: Icons.work,
    color: Colors.orange[700],
  ),
  SmoothItemEntity(
    icon: Icons.gavel,
    color: Colors.blue,
  ),
  SmoothItemEntity(
    icon: Icons.label,
    color: Colors.yellow[700],
  ),
  SmoothItemEntity(
    icon: Icons.hourglass_bottom,
    color: Colors.purple[700],
  ),
  SmoothItemEntity(
    icon: Icons.bolt,
    color: Colors.deepPurple[400],
  ),
];

class SmoothPage extends StatefulWidget {
  SmoothPage({Key key}) : super(key: key);

  @override
  _SmoothPageState createState() => _SmoothPageState();
}

class _SmoothPageState extends State<SmoothPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _animationController;

  Animation<double> _controlAnimation;
  Animation<double> _heightAnimation;

  double controlValue = 0;
  double heightValue = 150;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _animationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          controlValue = _controlAnimation.value;
          if (_scrollController.position.pixels <= 0)
            heightValue = _heightAnimation.value;
        });
      });
  }

  Future runAnimation() async {
    _controlAnimation = _animationController.drive(
      Tween<double>(begin: controlValue, end: 0),
    );
    _heightAnimation = _animationController.drive(
      Tween<double>(begin: 150, end: 160),
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -1);

    _animationController.animateWith(simulation);

    await Future.delayed(Duration(milliseconds: 300));

    _controlAnimation = _animationController.drive(
      Tween<double>(begin: 0, end: 0),
    );
    _heightAnimation = _animationController.drive(
      Tween<double>(begin: 160, end: 150),
    );
    _animationController.animateWith(simulation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
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
            if (controlValue >= -30 && controlValue <= 30) {
              controlValue += details.delta.dy * .3;
              setState(() {});
            } else if (controlValue < -30 || controlValue > 30) {
              if (controlValue < 0)
                controlValue = -30;
              else
                controlValue = 30;
            }
          },
          onPointerUp: (_) {
            runAnimation();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: _buildItems(),
          ),
        ),
      ),
    );
  }

  Widget _buildItems() {
    return Column(
      children: smoothItems.asMap().entries.map<Widget>(
        (entry) {
          final item = entry.value;

          return SmoothItem(
            controlValue: controlValue,
            smoothItem: item,
            height: heightValue,
          );
        },
      ).toList(),
    );
  }
}
