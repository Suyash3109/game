// import 'dart:html';
// import 'dart:ui';

// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:game/bomb.dart';
import 'package:game/numbered_bo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberofSquares = 9 * 9;

  int numberInEachRow = 9;
  var squareStats = [];

  final List<int> bombLocation = [
    40,
    50,
    9,
    66,
    22,
    11,
  ];

  bool bombsRevealed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < numberofSquares; i++) {
      squareStats.add([0, false]);
    }
    scanBombs();
  }

  void scanBombs() {
    for (int i = 0; i < numberofSquares; i++) {
      int numberOfBombsAround = 0;
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberofSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberofSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberofSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      setState(() {
        squareStats[i][0] = numberOfBombsAround;
      });
    }
  }

  void revealBoxnumbers(int index) {
    if (squareStats[index][0] != 0) {
      setState(() {
        squareStats[index][1] = true;
      });
    } else if (squareStats[index][0] == 0) {
      setState(() {
        squareStats[index][1] = true;

        //reveal left box unless we are currently on the left wall

        if (index % numberInEachRow != 0) {
          if (squareStats[index - 1][0] == 0 &&
              squareStats[index - 1][1] == false) {
            revealBoxnumbers(index - 1);
          }
          squareStats[index - 1][1] = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(children: [
        // game stats and menu
        Container(
          height: 150,
          // color: Colors.grey,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "6",
                  style: TextStyle(fontSize: 40),
                ),
                Text("B O M B"),
              ],
            ),
            Card(
              child: Icon(Icons.refresh_rounded, color: Colors.white, size: 40),
              color: Colors.grey[700],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "0",
                  style: TextStyle(fontSize: 40),
                ),
                Text("T I M E"),
              ],
            ),
          ]),
        ),

        Expanded(
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInEachRow),
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return MyBomb(
                    child: index,
                    revealed: bombsRevealed,
                    function: () {
                      //user taps the bomb, so player looses
                      setState(() {
                        bombsRevealed = true;
                      });
                    },
                  );
                } else {
                  return MyNumberBox(
                    child: squareStats[index][0],
                    revealed: squareStats[index][1],
                    function: () {
                      // reveal current box
                      revealBoxnumbers(index);
                    },
                  );
                }
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Text(
            "C R E A T E D B Y S U Y A S H",
            // style: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}
