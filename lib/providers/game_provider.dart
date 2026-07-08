import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

enum GameState { playing, won, lost }

class GameProvider extends ChangeNotifier {
  int timeLeft = 30;
  double temperature = 385.0; // °C
  double waterLevel = 85.0; // %
  int currentStep = 1; // 1 to 5
  GameState gameState = GameState.playing;
  Timer? _timer;
  Timer? _tempTimer;

  bool _waterEvacuated = false;
  bool _waterIngressed = false;

  GameProvider() {
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameState != GameState.playing) return;
      
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        _endGame(false); // Lost
      }
    });

    _tempTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (gameState != GameState.playing) return;
      
      final fluctuation = Random().nextInt(5) - 2;
      temperature += fluctuation;
      if (temperature < 350) temperature = 350;
      notifyListeners();
    });
  }

  int get mweGenerated {
    if (gameState != GameState.playing) return 0;
    return (temperature * 2.5).round();
  }

  bool isStepCompleted(int step) => step < currentStep;
  bool isStepUnlocked(int step) => step == currentStep;
  bool isStepBlocked(int step) => step > currentStep;

  void actionStopTurbines(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (currentStep == 1) {
      currentStep++;
      notifyListeners();
    } else if (currentStep < 1) {
      _showError(context, currentStep);
    }
  }

  void actionVent(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (currentStep == 2) {
      currentStep++;
      notifyListeners();
    } else if (currentStep < 2) {
      _showError(context, currentStep);
    }
  }

  void addWater(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (waterLevel < 100) {
      waterLevel += 5;
      temperature -= 10;
      if (waterLevel > 100) waterLevel = 100;
      
      if (currentStep == 3) {
        _waterIngressed = true;
        _checkStep3();
      } else if (currentStep < 3) {
        _showError(context, currentStep);
      }
      notifyListeners();
    }
  }

  void ventWater(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (waterLevel > 0) {
      waterLevel -= 5;
      temperature += 5;
      if (waterLevel < 0) waterLevel = 0;
      
      if (currentStep == 3) {
        _waterEvacuated = true;
        _checkStep3();
      } else if (currentStep < 3) {
        _showError(context, currentStep);
      }
      notifyListeners();
    }
  }

  void _checkStep3() {
    if (_waterEvacuated && _waterIngressed && currentStep == 3) {
      currentStep++;
    }
  }

  void actionTurnOffReactor(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (currentStep == 4) {
      currentStep++;
      notifyListeners();
    } else if (currentStep < 4) {
      _showError(context, currentStep);
    }
  }

  void pressScram(BuildContext context) {
    if (gameState != GameState.playing) return;
    if (currentStep == 5) {
      _endGame(true);
    } else {
      _showError(context, currentStep);
    }
  }

  void hintUseControls(BuildContext context) {
    if (gameState != GameState.playing) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Utilice los controles de la consola para completar este paso.'),
        backgroundColor: Colors.orange.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(BuildContext context, int expectedStep) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SECUENCIA INCORRECTA: Debe completar el paso $expectedStep primero.'),
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _endGame(bool won) {
    gameState = won ? GameState.won : GameState.lost;
    _timer?.cancel();
    _tempTimer?.cancel();
    if (won) {
      temperature = 200;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tempTimer?.cancel();
    super.dispose();
  }
}
