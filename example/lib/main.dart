import 'package:flutter/material.dart';
import 'package:example/flutter_chart_pro.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CustomView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 List<PieData> datas = [PieData("TEACHAER TEACHAER", 90.0, Colors.red),
  PieData("TEACHAER ", 90.0, Colors.red),
  PieData("TEACHAER TEACHAER", 90.0, Colors.red),
  PieData("TEACHAER TEACHAER", 90.0, Colors.red),
  PieData("TEACHAER TEACHAER", 90.0, Colors.red),
  PieData("TEACHAER TEACHAER", 90.0, Colors.red),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Container(child:PieChart(datas) ,)

      
    );
  }
}


class PieData extends BasePieEntity {
  final String title;
  final double data;
  final Color color;

  PieData(this.title, this.data, this.color);

  @override
  Color getColor() {
    return color;
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
