import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class NavPanel extends StatelessWidget {
  const NavPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        border: Border(right: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.3))),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Controles del Sistema', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('ID: REACTOR-04-BRAVO', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
          const SizedBox(height: 32),
          
          _buildActionButton(
            context,
            Icons.wind_power,
            'Detener Turbinas',
            () => context.read<GameProvider>().actionStopTurbines(context),
          ),
          const SizedBox(height: 12),
          
          _buildActionButton(
            context,
            Icons.air,
            'Ventilar Radiactividad',
            () => context.read<GameProvider>().actionVent(context),
          ),
          const SizedBox(height: 12),
          
          _buildActionButton(
            context,
            Icons.power_off,
            'Apagar Reactor',
            () => context.read<GameProvider>().actionTurnOffReactor(context),
          ),
          
          const Spacer(),
          Opacity(
              opacity: 0.5,
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.error, borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Icon(Icons.warning, color: AppTheme.onError),
                          SizedBox(width: 8),
                          Text('SISTEMA SCRAM', style: TextStyle(color: AppTheme.onError, fontWeight: FontWeight.bold)),
                      ]
                  )
              )
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppTheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
