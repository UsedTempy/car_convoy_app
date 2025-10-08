import 'package:flutter/material.dart';
import 'package:car_convoy_app/themes/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final List<Map<String, dynamic>>? buttons;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onSubmitted,
    this.buttons,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {}); // updates UI whenever text changes
    });
  }

  void _clearText() {
    _controller.clear();
    FocusScope.of(context).unfocus(); // unfocuses the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 18.0),
            onSubmitted: (value) {
              if (widget.onSubmitted != null) widget.onSubmitted!(value);
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Search here',
              hintStyle: TextStyle(
                color: AppColors.textInactive, // same as your home text color
                fontSize: 18.0,
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textInactive,
                size: 28,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textInactive,
                        size: 24,
                      ),
                      onPressed: _clearText,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Buttons below search bar
        if (widget.buttons != null && widget.buttons!.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.buttons!.map((btn) {
              final String text = btn['text'] ?? '';
              final IconData? icon = btn['icon'];

              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.textInactive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                ),
                onPressed: btn['onPressed'],
                icon: icon != null
                    ? Icon(icon, size: 20)
                    : const SizedBox.shrink(),
                label: Text(text, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
