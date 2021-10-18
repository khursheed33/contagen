import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';

class FilterImages extends StatefulWidget {
  const FilterImages({Key? key}) : super(key: key);

  @override
  _FilterImagesState createState() => _FilterImagesState();
}

class _FilterImagesState extends State<FilterImages> {
  File? _imageFile;
  String? _savePath;
  bool _isSaving = false;
  Future getImage(context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _savePath = basename(_imageFile!.path);
      var image = imageLib.decodeImage(await _imageFile!.readAsBytes());
      image = imageLib.copyResize(image!, width: 600);

      Map imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoFilterSelector(
            title: Text("Apply Filter"),
            image: image!,
            filters: presetFiltersList,
            filename: _savePath!,
            loader: Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );
      if (imagefile.containsKey('image_filtered')) {
        setState(() {
          _imageFile = imagefile['image_filtered'];
        });
        print(_imageFile!.path);
      }
    }
  }

  Future<String> saveImageToCustomFolder() async {
    setState(() {
      _isSaving = true;
    });
    const folderName = "Filter Images";
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
      // _screenshotController.captureAndSave(
      //   _savePath!, //set path where screenshot will be saved
      //   fileName: _fileName + '.png',
      // );
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

  // File? _capturedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter And Save"),
        actions: [
          IconButton(
            onPressed: () => saveImageToCustomFolder(),
            icon: Icon(Icons.save_alt),
          ),
          if (_isSaving)
            Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          IconButton(
            onPressed: () => getImage(context),
            icon: Icon(Icons.camera_alt),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        // margin: const EdgeInsets.all(10),
        child: _imageFile == null
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => getImage(context),
                      icon: Icon(
                        Icons.camera_alt,
                        size: 45,
                      ),
                    ),
                    Text("Pick an Image."),
                  ],
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_imageFile!),
                  ),
                ),
              ),
      ),
    );
  }
}
