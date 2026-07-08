import 'package:flutter/material.dart';
import '../widgets/nav_panel.dart';
import '../widgets/telemetry_panel.dart';
import '../widgets/protocol_panel.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLow,
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.security, color: AppTheme.primary, size: 30),
            const SizedBox(width: 12),
            Text('Terra Nuclear - Central de Control', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primary)),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: AppTheme.primary, size: 10),
                  SizedBox(width: 8),
                  Text('SISTEMA EN LÍNEA', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () => _showHelp(context)),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          if (game.gameState == GameState.lost) {
            return _buildLostScreen(context);
          } else if (game.gameState == GameState.won) {
            return _buildWonScreen(context);
          }
          return Row(
            children: [
              const NavPanel(),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: const TelemetryPanel(),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: const ProtocolPanel(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLostScreen(BuildContext context) {
      return Container(
          color: Colors.red.shade900,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Icon(Icons.warning, color: Colors.white, size: 120),
                  const SizedBox(height: 20),
                  Text('EXPLOSIÓN NUCLEAR', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('No pudiste contener el reactor a tiempo. Los zombies mutaron.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
              ]
          )
      );
  }

  Widget _buildWonScreen(BuildContext context) {
      return Container(
          color: AppTheme.primaryContainer,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Icon(Icons.check_circle, color: AppTheme.onPrimaryContainer, size: 120),
                  const SizedBox(height: 20),
                  Text('SISTEMA APAGADO CON ÉXITO', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Has salvado el mundo. El núcleo está estable.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.onPrimaryContainer)),
              ]
          )
      );
  }

  void _showHelp(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: const Text('Manual de Emergencia'),
              content: const Text('Tienes 30 segundos para detener el reactor.\nSigue estrictamente los pasos del 1 al 5 en el panel de Protocolo de Apagado.\nControla el nivel de agua y la temperatura para evitar una fusión prematura.\n\nHeurísticas aplicadas: Visibilidad del estado, Ayuda y documentación, Reconocimiento antes que recuerdo, etc.'),
              actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))
              ]
          )
      );
  }
}
