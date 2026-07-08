import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class TelemetryPanel extends StatelessWidget {
  const TelemetryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Telemetría del Núcleo', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildTempCard(context)),
              const SizedBox(width: 24),
              Expanded(child: _buildWaterCard(context)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
            child: Row(
                children: [
                    Expanded(flex: 2, child: _buildEnergyCard(context)),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildGraphicCard(context)),
                ]
            )
        )
      ],
    );
  }

  Widget _buildTempCard(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final isCritical = game.temperature > 400;
        final color = isCritical ? AppTheme.error : AppTheme.primary;
        
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
            children: [
              Row(
                children: [
                  Icon(Icons.thermostat, color: color),
                  const SizedBox(width: 8),
                  const Text('TEMPERATURA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.onSurfaceVariant)),
                ],
              ),
              const Spacer(),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: game.temperature / 600, // Max 600
                          strokeWidth: 12,
                          backgroundColor: AppTheme.surfaceContainer,
                          color: color,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${game.temperature.toInt()}°C', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
                          if (isCritical) const Text('CRÍTICO', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nominal 350°C', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                  Text('Peligro >400°C', style: TextStyle(fontSize: 12, color: isCritical ? AppTheme.error : AppTheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaterCard(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
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
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('NIVEL DE AGUA REFRIGERANTE', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.outlineVariant, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: (game.waterLevel / 100) * 150, // Escala relativa
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${game.waterLevel.toInt()}%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => game.addWater(context),
                              icon: const Icon(Icons.add),
                              label: const Text('+ Agua Fría'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade100, foregroundColor: Colors.blue.shade900),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => game.ventWater(context),
                              icon: const Icon(Icons.remove),
                              label: const Text('- Agua Caliente'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100, foregroundColor: Colors.orange.shade900),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnergyCard(BuildContext context) {
      return Consumer<GameProvider>(
          builder: (context, game, child) {
              return Container(
                  decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const Icon(Icons.electric_bolt, color: Colors.amber, size: 40),
                          const SizedBox(height: 8),
                          const Text('ENERGÍA GENERADA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.onSurfaceVariant)),
                          const SizedBox(height: 16),
                          Text('${game.mweGenerated} MWe', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.onSurface)),
                      ]
                  )
              );
          }
      );
  }

  Widget _buildGraphicCard(BuildContext context) {
      return Container(
          decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
              image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1542382156909-9ae37b3f56fd?auto=format&fit=crop&q=80'), // Imagen referencial abstracta/industrial
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              )
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Text('DIAGRAMA DEL NÚCLEO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white70)),
                  const Spacer(),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              _buildAnimatedIcon(Icons.cyclone, Colors.blueAccent),
                              const Icon(Icons.arrow_right_alt, color: Colors.white54, size: 40),
                              _buildAnimatedIcon(Icons.precision_manufacturing, Colors.greenAccent),
                              const Icon(Icons.arrow_right_alt, color: Colors.white54, size: 40),
                              _buildAnimatedIcon(Icons.power, Colors.amberAccent),
                          ]
                      ),
                    ),
                  ),
                  const Spacer(),
              ]
          )
      );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
      return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          builder: (context, double value, child) {
              return Opacity(
                  opacity: value,
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 2),
                          color: Colors.black45
                      ),
                      child: Icon(icon, color: color, size: 40),
                  )
              );
          }
      );
  }
}
