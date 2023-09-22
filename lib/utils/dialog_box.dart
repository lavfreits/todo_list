import 'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final String? hintText;
  final VoidCallback onSave;

  const DialogBox({
    Key? key,
    required this.controller,
    required this.onCancel,
    required this.onSave,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.purple[300],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  name: 'Cancel',
                  onPressed: () {
                    controller.clear();
                    return Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 6),
                MyButton(
                  name: 'Save',
                  onPressed: onSave,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
