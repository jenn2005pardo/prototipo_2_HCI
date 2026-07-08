import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class ProtocolPanel extends StatelessWidget {
  const ProtocolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gavel, color: AppTheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Protocolo de Apagado', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Siga la secuencia estricta para apagar.', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Consumer<GameProvider>(
                builder: (context, game, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: game.timeLeft <= 10 ? AppTheme.errorContainer : AppTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: game.timeLeft <= 10 ? AppTheme.error : AppTheme.tertiary),
                        const SizedBox(width: 8),
                        Text('${game.timeLeft}s', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: game.timeLeft <= 10 ? AppTheme.error : AppTheme.onSurface)),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildStep(context, 1, 'Detener las turbinas de generación eléctrica.'),
                _buildStep(context, 2, 'Ventilar el contenido radiactivo.'),
                _buildStep(context, 3, 'Evacuar agua caliente e ingresar agua fría.'),
                _buildStep(context, 4, 'Apagar el reactor.'),
                const SizedBox(height: 24),
                _buildScramButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, int step, String label) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final isCompleted = game.isStepCompleted(step);
        // Desbloqueado visualmente si es el actual o si ya lo completó
        // Aunque si lo completó, el botón ya no hace nada.
        final opacity = (isCompleted || game.isStepUnlocked(step)) ? 1.0 : 0.5;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Opacity(
            opacity: opacity,
            child: Row(
              children: [
                InkWell(
                  onTap: () => game.hintUseControls(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppTheme.primaryContainer : (game.isStepUnlocked(step) ? AppTheme.primary : AppTheme.surfaceContainer),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isCompleted ? '✓' : step.toString(),
                      style: TextStyle(
                        color: isCompleted ? AppTheme.onPrimaryContainer : (game.isStepUnlocked(step) ? AppTheme.onError : AppTheme.onSurfaceVariant),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => game.hintUseControls(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCompleted ? AppTheme.primaryContainer.withOpacity(0.1) : AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isCompleted ? AppTheme.primary.withOpacity(0.3) : AppTheme.outlineVariant.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isCompleted ? AppTheme.primary : AppTheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScramButton(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final isUnlocked = game.isStepUnlocked(5); // SCRAM is step 5
        
        return Column(
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.3,
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: isUnlocked ? () => game.pressScram(context) : () {
                      // Heurística 9: Mensaje de error al presionar el SCRAM antes de tiempo
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: const Text('ERROR: Debe completar los pasos 1 al 4 antes de usar el botón de Emergencia.'),
                              backgroundColor: Colors.red.shade900,
                          )
                      );
                  },
                  icon: const Icon(Icons.warning, size: 30),
                  label: const Text('BOTÓN SCRAM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: AppTheme.onError,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('PASO 5: REQUIERE COMPLETAR PASOS 1-4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant)),
          ],
        );
      },
    );
  }
}
