import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textml/widgets/image_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  String? pickedImagePath;
  bool isImagePicked = false;

  // function to picked image
  void _pickedImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImagePath = pickedImage.path;
      isImagePicked = true;
    });
  }

  // show bottonsheet to pick image
  void _chooseImageSourceModel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  "Chose from gallery",
                ),
                leading: const Icon(Icons.photo_library),
                onTap: () {
                  Navigator.pop(context);
                  _pickedImage(source: ImageSource.gallery);
                },
              ),
              ListTile(
                title: const Text(
                  "Chose from camera",
                ),
                leading: const Icon(Icons.photo_library),
                onTap: () {
                  Navigator.pop(context);
                  _pickedImage(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ML Text Recogition"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ImagePreview(
                  imagePath: null,
                ),
              ),
              if (!isImagePicked)
                ElevatedButton(
                  onPressed: _chooseImageSourceModel,
                  child: const Text("Pick an image"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
