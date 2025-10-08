import 'package:car_convoy_app/themes/app_colors.dart';
import 'package:flutter/material.dart';

class RecenterButton extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const RecenterButton({
    super.key,
    required this.isVisible,
    required this.onPressed,
  });

  @override
  State<RecenterButton> createState() => _RecenterButtonState();
}

class _RecenterButtonState extends State<RecenterButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      child: AnimatedOpacity(
        opacity: widget.isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 100),
        // The button is only interactive when visible.
        child: IgnorePointer(
          ignoring: !widget.isVisible,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}
