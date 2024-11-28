import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textml/widgets/image_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;

  String? pickedImagePath;
  bool isImagePicked = false;

  String recognizedText = "";
  bool isRecognized = false;

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

  // todo: Funtion to process image
  void _processImage() async {
    if (pickedImagePath == null) {
      return;
    }
    setState(() {
      isRecognized = true;
      recognizedText = "";
    });
    try {
      final inputImage = InputImage.fromFilePath(pickedImagePath!);
      final RecognizedText recognizedTextFrommodel =
          await textRecognizer.processImage(inputImage);

      // loop block
      for (TextBlock block in recognizedTextFrommodel.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text} \n";
        }
      }
      print(recognizedText);
    } catch (e) {
      if (!mounted) {
        return;
      }
      print("Error Recognized: $e");
    } finally {
      setState(() {
        isRecognized = false;
      });
    }
  }

  // copy to clickbord
  void _copyToClicpBord() async {
    if (recognizedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: recognizedText));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ML Text Recogition"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImagePreview(
                imagePath: pickedImagePath,
              ),
            ),
            if (!isImagePicked)
              ElevatedButton(
                onPressed: _chooseImageSourceModel,
                child: const Text("Pick an image"),
              ),
            if (isImagePicked)
              ElevatedButton(
                onPressed: isRecognized ? null : _processImage,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Process Image"),
                    if (isRecognized) ...{
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.orange,
                        ),
                      ),
                    }
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recognized Text",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                    ),
                    onPressed: _copyToClicpBord,
                  ),
                ],
              ),
            ),
            if (!isRecognized) ...{
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      recognizedText.isEmpty
                          ? "No text process"
                          : recognizedText,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}
