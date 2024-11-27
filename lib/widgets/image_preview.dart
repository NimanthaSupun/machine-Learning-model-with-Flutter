import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;
  const ImagePreview({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 228, 224),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 300,
                color: Colors.orangeAccent,
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
            ),
    );
  }
}
