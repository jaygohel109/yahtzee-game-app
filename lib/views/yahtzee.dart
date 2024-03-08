import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yahtzee Game',
      home: Scaffold(
        body: Center(
          child: YahtzeeGameScreen(),
        ),
      ),
    );
  }
}

class YahtzeeGameScreen extends StatefulWidget {
  const YahtzeeGameScreen({super.key});

  @override
  _YahtzeeGameScreenState createState() => _YahtzeeGameScreenState();
}

class _YahtzeeGameScreenState extends State<YahtzeeGameScreen> {
  late Dice dice;
  late ScoreCard scoreCard;
  int rollsLeft = 3;
  int totalScore = 0;
  Set<ScoreCategory> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    dice = Dice(6);
    scoreCard = ScoreCard();
  }

  void rollDice() {
    setState(() {
      if (rollsLeft > 0 &&
          selectedCategories.length < ScoreCategory.values.length) {
        dice.roll();
        rollsLeft--;
      }
    });
  }

  void toggleDiceHold(int index) {
    setState(() {
      dice.toggleHold(index);
    });
  }

  void selectCategory(ScoreCategory category) {
    if (scoreCard[category] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category already selected!'),
        ),
      );
    }
    if (scoreCard[category] == null) {
      final diceValues = dice.values;
      scoreCard.registerScore(category, diceValues);
      selectedCategories.add(category);

      if (selectedCategories.length == ScoreCategory.values.length) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 227, 203),
                ),
              ),
              content: Text(
                'All categories are selected! Total score is $totalScore',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 227, 203),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 0, 159, 146),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'New Game',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 254, 158, 132),
                    ),
                  ),
                  onPressed: () {
                    scoreCard.clear();
                    selectedCategories.clear();
                    rollsLeft = 3;
                    totalScore = 0; // Reset the total score
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        rollsLeft = 3;
      }

      setState(() {});
    }
    dice.clear();
  }

  void endTurn() {
    for (ScoreCategory category in ScoreCategory.values) {
      if (scoreCard[category] == null) {
        scoreCard.registerScore(category, dice.values);
        break;
      }
    }
    dice.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yahtzee Game'),
        backgroundColor: const Color.fromARGB(255, 0, 118, 108),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 159, 146),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rolls Left: $rollsLeft',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 227, 203),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++)
                  GestureDetector(
                    onTap: () => toggleDiceHold(i),
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: dice.isHeld(i)
                            ? const Color.fromARGB(255, 254, 158, 132)
                            : const Color.fromARGB(255, 255, 227, 203),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${i < dice.values.length ? dice.values[i] ?? '' : ''}',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 107, 166, 179)),
                      ),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: rollsLeft > 0 ? rollDice : null,
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 254, 158, 132),
              ),
              child: const Text(
                'Roll Dice',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 227, 203),
                ),
              ),
            ),
            Text(
              'Total Score: $totalScore',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 227, 203),
              ),
            ),
            const Text(
              'Score Card:',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 227, 203),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: (ScoreCategory.values.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                final categoryIndex1 = index * 2;
                final categoryIndex2 = categoryIndex1 + 1;

                final category1 = categoryIndex1 < ScoreCategory.values.length
                    ? ScoreCategory.values[categoryIndex1]
                    : null;

                final category2 = categoryIndex2 < ScoreCategory.values.length
                    ? ScoreCategory.values[categoryIndex2]
                    : null;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategory(category1),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCategory(category2),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(ScoreCategory? category) {
    if (category == null) {
      return Container();
    }

    final score = scoreCard[category];

    return GestureDetector(
      onTap: () {
        if (score == null) {
          selectCategory(category);
          totalScore = scoreCard.total;
        }
        if (score != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category already selected!'),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: score == null
              ? const Color.fromARGB(255, 255, 227, 203)
              : const Color.fromARGB(255, 254, 158, 132),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              score?.toString() ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
