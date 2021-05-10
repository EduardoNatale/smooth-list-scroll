import 'package:flutter/material.dart';
import 'package:smooth_list_scroll/smooth_item_entity.dart';
import 'package:smooth_list_scroll/smooth_paint.dart';

class SmoothItem extends StatelessWidget {
  final double controlValue;
  final double height;
  final SmoothItemEntity smoothItem;

  const SmoothItem({
    Key key,
    this.controlValue,
    this.smoothItem,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SmoothPaint(
        controlValue: controlValue,
        color: smoothItem.color,
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        alignment: Alignment.center,
        child: Icon(
          smoothItem.icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
