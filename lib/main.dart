import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/game_provider.dart';
import 'screens/control_panel_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: const TerraNuclearApp(),
    ),
  );
}

class TerraNuclearApp extends StatelessWidget {
  const TerraNuclearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terra Nuclear',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ControlPanelScreen(),
    );
  }
}
