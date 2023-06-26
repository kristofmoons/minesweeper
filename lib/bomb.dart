import 'package:flutter/material.dart';

class MyBomb extends StatelessWidget {
  bool revealed;
  final function;

  MyBomb({required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.grey[800],
            child: Center(child: Text('x')),
          )),
    );
  }
}
