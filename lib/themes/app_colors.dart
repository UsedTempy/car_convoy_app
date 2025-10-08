import 'package:flutter/material.dart';

/// Centralized color scheme for your app.
/// You can import this file anywhere to keep your theme consistent.
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF003E7E);
  static const Color primaryLight = Color(0xFFB3D4FC);

  // Accent and secondary colors
  static const Color secondary = Color(0xFFFFC107);
  static const Color secondaryDark = Color(0xFFFFA000);
  static const Color secondaryLight = Color(0xFFFFECB3);

  // Backgrounds
  static const Color background = Color.fromARGB(255, 50, 50, 50);
  static const Color surface = Color.fromARGB(255, 37, 37, 37);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textInactive = Colors.grey;

  // Other
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);
}
