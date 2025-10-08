import 'package:flutter/material.dart';
import 'package:car_convoy_app/themes/app_colors.dart';

class BottomAppButtonWidget extends StatefulWidget {
  final String buttonName;
  final IconData iconName;
  final VoidCallback? onPressed;
  final bool isSelected;

  const BottomAppButtonWidget({
    super.key,
    required this.buttonName,
    required this.iconName,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  State<BottomAppButtonWidget> createState() => _BottomAppButtonWidgetState();
}

class _BottomAppButtonWidgetState extends State<BottomAppButtonWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color currentColor = widget.isSelected
        ? AppColors.primary
        : _isPressed
        ? AppColors.primaryLight
        : _isHovered
        ? AppColors.primary
        : AppColors.textOnPrimary.withOpacity(0.8);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.iconName, color: currentColor, size: 28),
              const SizedBox(height: 4),
              Text(
                widget.buttonName,
                style: TextStyle(
                  color: currentColor,
                  fontSize: 12,
                  fontWeight: widget.isSelected || _isPressed
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
