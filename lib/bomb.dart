import 'package:flutter/material.dart';

/// Widget representing a bomb box.
class MyBomb extends StatelessWidget {
  /// Flag indicating whether the bomb is revealed.
  final bool revealed;

  /// Callback function to be executed on tap.
  final Function? function;

  /// Constructs a MyBomb instance.
  ///
  /// The [revealed] parameter indicates whether the bomb is revealed.
  /// The [function] parameter is an optional callback function to be executed on tap.
  MyBomb({required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: revealed ? Colors.red[800] : Colors.grey[400],
        ),
      ),
    );
  }
}
