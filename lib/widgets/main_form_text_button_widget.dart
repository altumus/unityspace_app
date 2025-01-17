import 'package:flutter/material.dart';

class MainFormTextButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MainFormTextButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(40, 40)),
        overlayColor: MaterialStateProperty.all<Color>(Colors.white10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
