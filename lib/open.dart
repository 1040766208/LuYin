import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class OpenPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<OpenPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
        "assets/images/open.jpg",
        fit:BoxFit.cover,
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown();
  }
  void countDown(){
    var _duration = Duration(seconds: 3);
    Future.delayed(_duration,MainPage);
  }
  void MainPage(){
    Navigator.of(context).pushReplacementNamed('/MainPage');
  }
}

