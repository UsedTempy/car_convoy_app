import 'package:car_convoy_app/themes/app_colors.dart';
import 'package:car_convoy_app/widgets/navigation_bar/bottom_app_button_widget.dart';
import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatefulWidget {
  final Function(int)? onTabSelected;
  final int currentIndex;

  const BottomAppBarWidget({
    super.key,
    this.onTabSelected,
    this.currentIndex = 0,
  });

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.surface,
      height: 90,
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomAppButtonWidget(
            buttonName: "Maps",
            iconName: Icons.map_rounded,
            isSelected: widget.currentIndex == 0,
            onPressed: () => widget.onTabSelected?.call(0),
          ),
          BottomAppButtonWidget(
            buttonName: "Chats",
            iconName: Icons.chat,
            isSelected: widget.currentIndex == 1,
            onPressed: () => widget.onTabSelected?.call(1),
          ),
          BottomAppButtonWidget(
            buttonName: "Convoys",
            iconName: Icons.car_crash_rounded,
            isSelected: widget.currentIndex == 2,
            onPressed: () => widget.onTabSelected?.call(2),
          ),
          BottomAppButtonWidget(
            buttonName: "Profile",
            iconName: Icons.supervised_user_circle_outlined,
            isSelected: widget.currentIndex == 3,
            onPressed: () => widget.onTabSelected?.call(3),
          ),
        ],
      ),
    );
  }
}
