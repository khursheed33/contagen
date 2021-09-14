import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class SaveFileToCustomFolder extends StatefulWidget {
  const SaveFileToCustomFolder({Key? key}) : super(key: key);

  @override
  _SaveFileToCustomFolderState createState() => _SaveFileToCustomFolderState();
}

class _SaveFileToCustomFolderState extends State<SaveFileToCustomFolder> {
  File? _imageFile;
  String? _savePath;
  bool _isSaving = false;
  Future<void> pickImage() async {
    final ImagePicker _pick = ImagePicker();
    final XFile? _pickedFile = await _pick.pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedFile != null) {
      setState(() {
        _imageFile = File(_pickedFile.path);
      });
    }
  }

  Future<String> saveImageToCustomFolder() async {
    setState(() {
      _isSaving = true;
    });
    const folderName = "AadhaarImage";
    final Directory path = Directory("storage/emulated/0/$folderName");
    final PermissionStatus status = await Permission.storage.status;
    final PermissionStatus extStorage =
        await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!extStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if ((await path.exists())) {
      _savePath = path.path;
      final String _fileName = DateTime.now().toIso8601String();
      // await _imageFile!.copy('$_savePath/$_fileName.png');
      _screenshotController.captureAndSave(
        _savePath!, //set path where screenshot will be saved
        fileName: _fileName + '.png',
      );
      setState(() {
        _isSaving = false;
      });
      return path.path;
    } else {
      path.create();
      _savePath = path.path;
      final String _fileName = DateTime.now().toIso8601String();
      // await _imageFile!.copy('$_savePath/$_fileName.png');

      _screenshotController.captureAndSave(
        _savePath!, //set path where screenshot will be saved
        fileName: _fileName + '.png',
      );
      setState(() {
        _isSaving = false;
      });
      return path.path;
    }
  }

  final _screenshotController = ScreenshotController();
  // File? _capturedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Folder"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: _imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _isSaving
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ElevatedButton(
                      onPressed: pickImage,
                      child: Text("Pick an Image"),
                    ),
              ElevatedButton(
                onPressed: () async {
                  saveImageToCustomFolder();
                  // await _screenshotController
                  //     .capture()
                  //     .then((Uint8List? imageByte) {
                  // if (imageByte != null) {
                  // Save the File

                  // }

                  // });
                },
                child: Text("Save Image"),
              ),
              SizedBox(height: 20),
              // if (_capturedImage != null)
              //   Container(
              //     height: 300,
              //     width: 300,
              //     color: Colors.red,
              //     padding: const EdgeInsets.all(10),
              //     child: Image.asset(_capturedImage!.path),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
