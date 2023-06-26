import 'package:flutter/material.dart';

/// Widget representing a number box.
class MyNumberBox extends StatelessWidget {
  /// The child content of the box.
  final child;

  /// Flag indicating whether the box is revealed.
  final bool revealed;

  /// Callback function to be executed on tap.
  final VoidCallback? function;

  /// Constructs a MyNumberBox instance.
  ///
  /// The [child] parameter represents the child content of the box.
  /// The [revealed] parameter indicates whether the box is revealed.
  /// The [function] parameter is an optional callback function to be executed on tap.
  MyNumberBox({this.child, required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text(
              revealed ? (child == 0 ? '' : child.toString()) : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: child == 1
                    ? Colors.blue
                    : child == 2
                        ? Colors.green
                        : child == 3
                            ? Colors.red
                            : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
