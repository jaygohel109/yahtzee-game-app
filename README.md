# Yahtzee Game Application

This is a single-player Yahtzee game application developed using Flutter. The game is a dice game where the player rolls five dice up to three times in an attempt to achieve various scoring combinations. The player's score is determined by the sum of the values of the dice when a scoring combination is achieved.

## Overview

The primary objective of this application is to provide a non-trivial, single-page application that employs various stateful widgets and state-management techniques.

## Specifications

The version of Yahtzee implemented is a slightly simplified, single-player version of the game. The player can roll the dice up to three times per turn, choosing a scoring category to end each turn. The game ends when the player has entered a score in each of the 13 categories on the scorecard. Our version does not include the "Yahtzee bonus" rule, which awards additional points for multiple Yahtzees.

## Implementation Details

The application clearly displays the following information at all times:

- The most recently rolled dice faces in the current turn (if any)
- Which dice are currently "held" (if any)
- The next roll number (1-3) of the current turn
- The score corresponding to each used category on the scorecard
- The remaining, unused categories on the scorecard
- The current total score

The application provides the following functionality:

- A mechanism for rolling the dice (e.g., a button), which is disabled when the player has already rolled three times in the current turn
- A mechanism for toggling the "held" state of each die
- A mechanism for selecting a scoring category to end the current turn
- When the game ends, the application displays the final score until the user dismisses it --- after dismissal, the game resets to the initial state and is ready to be played again

## Project Setup

This repository includes a basic Flutter project structure. The `lib/main.dart` file is the entry point of the application. UI-related source files (e.g., custom `Widget`s) are in the `lib/views` directory, data model source files are in the `lib/models` directory, and image files are in the `assets/images` directory. All source files are written in Dart.

## External Packages

The [`provider`](https://pub.dev/packages/provider) and [`collection`](https://pub.dev/packages/collection) packages are included in the `pubspec.yaml` file. `provider` is a state management package used to manage the stateful data, and `collection` provides some helpful data structure related operations.

## Testing

The application has been tested by building and running it as a native macOS or Chrome app. It runs without errors or warnings, and behaves as specified above.

## Author

Jay Gohel

## License

This project is licensed under the [MIT License](LICENSE).