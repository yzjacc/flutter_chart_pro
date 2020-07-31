import 'package:flutter/material.dart';
import 'dart:math';

class PieChart extends StatefulWidget {
  final List<BasePieEntity> data;

  PieChart(this.data);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: 320,
      height: 260,
      child: CustomPaint(
        painter: PieChartPainter(widget.data),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  double radius;
  double line1;
  double line2;
  double picWidth = 30;
  int topCount = 3;

  List<BasePieEntity> entities;

  Paint _paint = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0;

  PieChartPainter(entities) {
    this.entities = entities;

    var total = 0.0;

    this.entities.forEach((e) {
      total += e.getData();
    });

    this.entities.forEach((e) {
      e.angle = e.getData() / total * 360;
    });

    _paint.strokeWidth = 2.0;
    _paint.isAntiAlias = true;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < size.height) {
      radius = size.height / 4;
    } else {
      radius = size.width / 4;
    }
    print(radius);

    line1 = radius / 10;
    line2 = radius / 15;

    canvas.translate(size.width / 2, size.height / 3);

    Rect rect = Rect.fromLTRB(-radius, -radius, radius, radius);
    // 设置起始角度
    double currentAngle = -90.0;

    for (var i = 0; i < entities.length; i++) {
      var entity = entities[i];
      _paint.color = entity.getColor();
      canvas.drawArc(rect, (currentAngle * pi / 180), (entity.angle * pi / 180),
          true, _paint);
      if (i < topCount)
        _drawLineAndText(canvas, currentAngle, entity.angle, radius,
            entity.getTitle(), entity.getColor());

      currentAngle += entity.angle;
    }
    canvas.drawArc(
        Rect.fromLTRB(-radius + picWidth, -radius + picWidth, radius - picWidth,
            radius - picWidth),
        0,
        10,
        true,
        _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawLineAndText(Canvas canvas, double currentAngle, double angle,
      double r, String name, Color color) {
    // 绘制横线
    // 1，计算开始坐标和转折点坐标
    var startX = r * (cos((currentAngle + (angle / 2)) * (pi / 180)));
    var startY = r * (sin((currentAngle + (angle / 2)) * (pi / 180)));

    var stopX = (r + line1) * (cos((currentAngle + (angle / 2)) * (pi / 180)));
    var stopY = (r + line1) * (sin((currentAngle + (angle / 2)) * (pi / 180)));
    bool _isRight = stopX - startX > 0;
    bool _isTop = stopY - startY < 0;
    // 2、计算坐标在左边还是在右边，并计算横线结束坐标
    var endX;
    if (_isRight) {
      endX = stopX + line2;
    } else {
      endX = stopX - line2;
    }

    // 3、绘制斜线和横线
    canvas.drawLine(Offset(startX, startY), Offset(stopX, stopY), _paint);
    canvas.drawLine(Offset(stopX, stopY), Offset(endX, stopY), _paint);

    // 4、绘制文字
    // 绘制下方名称
    // 上下间距偏移量
    var offset = 0;
    // 1、测量文字
    var tp = _newVerticalAxisTextPainter(name, color, _isRight);
    tp.layout();

    var w = tp.width;
    // 2、计算文字坐标
    var textStartX;
    if (_isTop) {
      stopY = stopY - 20;
    }
    if (_isRight) {
      if (w > line2) {
        textStartX = (stopX + offset) + 10;
      } else {
        textStartX = (stopX + (line2 - w) / 2) + 10;
      }
    } else {
      if (w > line2) {
        textStartX = (stopX - offset - w) - 10;
      } else {
        textStartX = (stopX - (line2 - w) / 2 - w) - 10;
      }
    }
    tp.paint(canvas, Offset(textStartX, stopY + offset - 10));
  }

  // 文字画笔 风格定义
  TextPainter _newVerticalAxisTextPainter(
      String text, Color color, bool _isRight) {
    return TextPainter(
        textDirection: _isRight ? TextDirection.ltr : TextDirection.rtl,
        maxLines: 3,
        text: TextSpan(
          text: text,
          style: new TextStyle(
            color: color,
            fontSize: 10.0,
            height: 1.6,
          ),
        ));
  }
}

abstract class BasePieEntity {
  String getTitle();

  double getData();

  double angle;

  Color getColor();
}

class PieData extends BasePieEntity {
  final String title;
  final double data;
  final Color color;
  double picWidth = 40;

  PieData(this.title, this.data, this.color, this.picWidth);

  @override
  Color getColor() {
    return color;
  }
    @override
  double getPicWidth() {
    return picWidth;
  }

  @override
  double getData() {
    return data;
  }

  @override
  String getTitle() {
    return title;
  }
}
