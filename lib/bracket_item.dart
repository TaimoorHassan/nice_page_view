import 'dart:math';

import 'package:flutter/material.dart';

class BracketItem extends StatelessWidget {
  const BracketItem(
      {super.key,
      required this.data,
      required this.column,
      required this.row,
      required this.centerPoint,
      required this.visibleColumn,
      required this.columnWidth});
  final Map<String, dynamic> data;
  final int column;
  final int row;
  final double centerPoint;
  final double visibleColumn;
  final double columnWidth;

  double get myHorizontalOffset {
    return visibleColumn * columnWidth;
  }

  double get percentageOfMyVisibility {
    var endVisibilityOffset = (visibleColumn * columnWidth) + columnWidth;

    // print({
    //   'endVisibilityOffset': endVisibilityOffset,
    //   'myHorizontalOffset': myHorizontalOffset,
    //   'columnWidth': columnWidth,
    //   'visibleColumn': visibleColumn,
    //   'centerPoint': centerPoint,

    // });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    var c = percentageOfMyVisibility;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width - 100,
            // width: ,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text("${data['name']}"),
                      Text(
                        '${(data['fighters'] as List).length}',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("${data['name']}"),
                      Text(
                        '${(data['fighters'] as List).length}',
                      ),
                    ],
                  ),
                  Text('Distance :  ${(myHorizontalOffset).toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          child: (row < ((8 ~/ (1 << column) / 2))) ? CustomPaintedLines() : null,
          width: 30,
        )
      ],
    );
  }
}

// draw a path like the letter T

class CustomPaintedLines extends StatelessWidget {
  const CustomPaintedLines({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomPainter(),
    );
  }
}

// Create a custom painter
class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw a T Shape path
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    var path = Path();
    // path.moveTo(0, 0);
    // path.lineTo(size.width, size.height );

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
