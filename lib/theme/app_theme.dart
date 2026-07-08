import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF3182CE);
  static const Color primaryContainer = Color(0xFFBEE3F8);
  static const Color onPrimaryContainer = Color(0xFF2A4365);
  static const Color secondary = Color(0xFF4A5568);
  static const Color secondaryContainer = Color(0xFFE2E8F0);
  static const Color tertiary = Color(0xFF805AD5);
  static const Color error = Color(0xFFE53E3E);
  static const Color errorContainer = Color(0xFFFED7D7);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFEDF2F7);
  static const Color onBackground = Color(0xFF1A202C);
  static const Color surface = Color(0xFFEDF2F7);
  static const Color onSurface = Color(0xFF1A202C);
  static const Color onSurfaceVariant = Color(0xFF4A5568);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerLow = Color(0xFFF7FAFC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFCBD5E0);
  static const Color outline = Color(0xFF718096);
  static const Color outlineVariant = Color(0xFFA0AEC0);

  static ThemeData get theme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        error: error,
        onError: onError,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
      ),
      scaffoldBackgroundColor: background,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.literata(color: onSurface),
        titleLarge: GoogleFonts.literata(color: onSurface, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.nunitoSans(color: onSurface),
        bodyMedium: GoogleFonts.nunitoSans(color: onSurfaceVariant),
        labelLarge: GoogleFonts.nunitoSans(color: onSurface, fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }
}
