import 'package:flutter/material.dart';

class MyNumberBox extends StatelessWidget {
  final child;

  MyNumberBox({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.grey[400],
          child: Center(child: Text(child.toString())),
        ));
  }
}
