import 'package:flutter/material.dart';

class SmoothPaint extends CustomPainter {
  final Color color;
  final double controlValue;

  SmoothPaint({
    @required this.color,
    @required this.controlValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.lineTo(0, 0);
    path.quadraticBezierTo(
      size.width / 2,
      -controlValue,
      size.width,
      0,
    );
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - controlValue,
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
