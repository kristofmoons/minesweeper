import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberbox.dart';
import 'dart:async';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  var squareStatus = [];
  List<int> bombLocation = [];
  List<bool> flaggedSquares = [];
  bool bombRevealed = false;
  int secondsElapsed = 0;
  Timer? timer;
  bool flagButtonTapped = false;

  @override
  void initState() {
    super.initState();

    // Initialize square status
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
      flaggedSquares.add(false);
    }

    // Generate random bomb locations
    bombLocation = generateRandomBombLocations(
      numberOfBombs: 6,
      totalBoxes: numberOfSquares,
    );

    scanBombs();

    // Start the timer
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Generate a random list of bomb locations
  List<int> generateRandomBombLocations({
    required int numberOfBombs,
    required int totalBoxes,
  }) {
    List<int> bombLocations = [];

    // Create a random number generator
    Random random = Random();

    while (bombLocations.length < numberOfBombs) {
      int randomLocation = random.nextInt(totalBoxes);

      // Ensure the random location is not already in the bombLocations list
      if (!bombLocations.contains(randomLocation)) {
        bombLocations.add(randomLocation);
      }
    }

    return bombLocations;
  }

  /// Restarts the game by resetting the state and regenerating bomb locations.
  void restartGame() {
    setState(() {
      bombRevealed = false;

      // Clear square status
      squareStatus.clear();

      // Initialize square status
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus.add([0, false]);
      }

      // Generate random bomb locations
      bombLocation = generateRandomBombLocations(
        numberOfBombs: 6,
        totalBoxes: numberOfSquares,
      );

      flaggedSquares = List.filled(numberOfSquares, false);

      scanBombs();

      // Reset the timer
      resetTimer();
    });
  }

  /// Resets the timer to 0 seconds.
  void resetTimer() {
    setState(() {
      secondsElapsed = 0;
    });
  }

  /// Starts the timer.
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  /// Reveals the numbers in the neighboring boxes recursively based on the selected box index.
  void revealBoxNumbers(int index) {
// Skip revealing if the square is flagged
    if (flaggedSquares[index]) {
      setState(() {
        flaggedSquares[index] = false;
      });
      return;
    }
// If the flag button is tapped, toggle the flag state of the square
    if (flagButtonTapped) {
      setState(() {
        flaggedSquares[index] = !flaggedSquares[index];
      });
    } else {
      // If the box has a number, mark it as revealed
      if (squareStatus[index][0] != 0) {
        setState(() {
          squareStatus[index][1] = true;
        });
      }
      // If the box has no number, reveal it and recursively reveal neighboring boxes
      else if (squareStatus[index][0] == 0) {
        setState(() {
          squareStatus[index][1] = true;

          // Reveal neighboring boxes in all four directions (left, right, top, bottom)
          if (index % numberInEachRow != 0) {
            // Check and reveal the box to the left
            if (squareStatus[index - 1][0] == 0 &&
                !squareStatus[index - 1][1]) {
              revealBoxNumbers(index - 1);
            } else {
              squareStatus[index - 1][1] = true;
            }
          }
          if ((index + 1) % numberInEachRow != 0) {
            // Check and reveal the box to the right
            if (squareStatus[index + 1][0] == 0 &&
                !squareStatus[index + 1][1]) {
              revealBoxNumbers(index + 1);
            } else {
              squareStatus[index + 1][1] = true;
            }
          }
          if (index >= numberInEachRow) {
            // Check and reveal the box above
            if (squareStatus[index - numberInEachRow][0] == 0 &&
                !squareStatus[index - numberInEachRow][1]) {
              revealBoxNumbers(index - numberInEachRow);
            } else {
              squareStatus[index - numberInEachRow][1] = true;
            }
          }
          if (index < numberOfSquares - numberInEachRow) {
            // Check and reveal the box below
            if (squareStatus[index + numberInEachRow][0] == 0 &&
                !squareStatus[index + numberInEachRow][1]) {
              revealBoxNumbers(index + numberInEachRow);
            } else {
              squareStatus[index + numberInEachRow][1] = true;
            }
          }
        });
      }
    }
  }

  /// Scans the bombs and updates the number of bombs around each square.
  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      // Check square to the left
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // Check square to the top left
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // Check square to the top
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // Check square to the top right
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // Check square to the right
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // Check square to the bottom right
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // Check square to the bottom
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      // Check square to the bottom left
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  /// Shows a dialog indicating that the player has lost the game.
  void playerLost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text(
              'You lost!',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: Icon(Icons.refresh),
            )
          ],
        );
      },
    );
  }

  /// Shows a dialog indicating that the player has won the game.
  void playerWon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text(
              'You won!',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
              onPressed: () {
                restartGame();
                Navigator.pop(context);
              },
              child: Icon(Icons.refresh),
            )
          ],
        );
      },
    );
  }

  /// Checks if the player has won the game.
  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (!squareStatus[i][1]) {
        unrevealedBoxes++;
      }
    }

    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header Section
          Container(
            height: 150,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Bomb Counter
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocation.length.toString(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "BOMB",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Settings Icon
                GestureDetector(
                  onTap: () {
                    // Add your settings functionality here
                  },
                  child: Card(
                    child: Icon(Icons.settings, color: Colors.white, size: 50),
                    color: Colors.grey[700],
                  ),
                ),
                // Refresh Button
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white, size: 50),
                    color: Colors.grey[700],
                  ),
                ),
                // Flag Icon
                GestureDetector(
                  onTap: () {
                    setState(() {
                      flagButtonTapped =
                          !flagButtonTapped; // Toggle the tapped state
                    });
                    // Add your flag functionality here
                  },
                  child: Card(
                    child: Icon(Icons.flag, color: Colors.white, size: 50),
                    color: flagButtonTapped
                        ? Colors.green
                        : Colors.grey[
                            700], // Set background color based on tapped state
                  ),
                ),
                // Time Counter
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'TIME',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Game Grid
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInEachRow,
              ),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  // Render Bomb Box
                  return MyBomb(
                    revealed: bombRevealed,
                    function: () {
                      setState(() {
                        bombRevealed = true;
                      });
                      playerLost();
                    },
                  );
                } else {
                  // Render Number Box
                  return MyNumberBox(
                    child: squareStatus[index][0],
                    revealed: squareStatus[index][1],
                    flagged: flaggedSquares[index],
                    function: () {
                      revealBoxNumbers(index);
                      checkWinner();
                    },
                  );
                }
              },
            ),
          ),

          // Footer Section
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text('Created by: Kristof Moons'),
          ),
        ],
      ),
    );
  }
}
