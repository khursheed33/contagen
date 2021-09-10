import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<String> createFolder() async {
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
      await _imageFile!.copy('$_savePath/$_fileName.png');
      setState(() {
        _isSaving = false;
      });
      return path.path;
    } else {
      path.create();
      _savePath = path.path;
      final String _fileName = DateTime.now().toIso8601String();
      await _imageFile!.copy('$_savePath/$_fileName.png');
      setState(() {
        _isSaving = false;
      });
      return path.path;
    }
  }

  Future<void> saveImageToCustomFolder() async {
    createFolder().then((value) async {
      print("Folder Created:File Saved Scuccessfully:$_savePath");
    });
  }

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
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: _imageFile == null
                      ? null
                      : DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
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
                onPressed: saveImageToCustomFolder,
                child: Text("Save Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
