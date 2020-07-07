import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'open.dart';
import 'main_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {//开屏图
    return MaterialApp(
      title: 'Open_page',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: OpenPage(),
      routes: <String, WidgetBuilder>{
        '/MainPage':(context)=>MainPage()
      }
    );
  }
}
