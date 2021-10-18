import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class ProfileWithFrame extends StatefulWidget {
  const ProfileWithFrame({Key? key}) : super(key: key);

  @override
  _ProfileWithFrameState createState() => _ProfileWithFrameState();
}

class _ProfileWithFrameState extends State<ProfileWithFrame> {
  File? _imageFile;
  String? _savePath;
  bool _isSaving = false;
  Future<void> pickImage() async {
    final ImagePicker _pick = ImagePicker();
    final XFile? _pickedFile = await _pick.pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedFile != null) {
      print("PICKED::${_pickedFile.path}");
      setState(() {
        _imageFile = File(_pickedFile.path);
      });
    }
  }

  Future<String> saveImageToCustomFolder() async {
    setState(() {
      _isSaving = true;
    });
    const folderName = "InstaApp Images";
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

  ScreenshotController _screenshotController = ScreenshotController();

  final _listOfFrames = [
    'https://cdn.pixabay.com/photo/2016/05/25/13/31/circle-1414809_960_720.png',
    Colors.black,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.indigo,
    Colors.yellow,
    Colors.deepPurple,
    Colors.brown,
    'https://cdn.pixabay.com/photo/2016/04/15/22/37/flourish-1332132_960_720.png',
    'https://cdn.pixabay.com/photo/2017/09/21/20/28/crown-of-thorns-2773399_960_720.png',
    'https://cdn.pixabay.com/photo/2017/02/15/20/43/vintage-2069826_960_720.png',
    'https://cdn.pixabay.com/photo/2012/04/18/18/53/circle-37563_960_720.png',
    'https://cdn.pixabay.com/photo/2021/08/19/03/13/flowers-6556904_960_720.png'
  ];

  int? currentIndex;
  void updateFrame(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void clearBadges() {
    setState(() {
      iconIndex = null;
    });
  }

  final List<Map<String, dynamic>>? _icons = [
    {'icon': Icons.remove_circle_rounded, 'color': Colors.green},
    {'icon': Icons.verified_outlined, 'color': Colors.red},
    {'icon': Icons.verified_rounded, 'color': Colors.pink},
  ];
  int? iconIndex;
  void updateIcon(int index) {
    setState(() {
      iconIndex = index;
      // outlineWidth = selectedIndex + 1 * 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        height: 130,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            bottomSheet: TabBar(
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(Icons.filter_frames_rounded
                      // color: Colors.black,
                      ),
                  text: 'Frames',
                ),
                Tab(
                  icon: Icon(Icons.verified_rounded
                      // color: Colors.black,
                      ),
                  text: 'Badges',
                ),
              ],
            ),
            body: TabBarView(
                // controller: _controller,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    //  height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: GenerateFrames(
                        indexHandler: updateFrame,
                        listOfFrames: _listOfFrames,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    //  height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: GenerateIcons(
                        iconHandler: updateIcon,
                        icons: _icons,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DP CREATOR',
                  style: TextStyle(
                      letterSpacing: 2,
                      // fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                _isSaving
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : ElevatedButton(
                        onPressed: saveImageToCustomFolder,
                        child: Text('Save'),
                      )
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.pink, Colors.indigo]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 0, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF5E35B1),
                  ),
                ),
                onPressed: pickImage,
                child: Text("Select Image"),
              ),
            ),

            Screenshot(
              controller: _screenshotController,
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Theme.of(context).canvasColor,
                backgroundImage: (currentIndex != null &&
                        _listOfFrames[currentIndex!].runtimeType == String)
                    ? NetworkImage(
                        _listOfFrames[currentIndex!].toString(),
                      )
                    : null,
                child: Stack(children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: (currentIndex != null &&
                              _listOfFrames[currentIndex!].runtimeType !=
                                  String)
                          ? Border.all(
                              color: _listOfFrames[currentIndex!] as Color,
                              width: 10.0,
                            )
                          : Border.all(
                              color: Theme.of(context).canvasColor,
                              width: 0.00),
                      borderRadius: BorderRadius.circular(100),
                      image: _imageFile == null
                          ? DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2012/04/28/18/22/family-43873_960_720.png'),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: FileImage(_imageFile!),
                            ),
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.008,
                    child: iconIndex == null
                        ? Icon(
                            Icons.do_disturb_alt_rounded,
                          )
                        : Icon(_icons![iconIndex!]['icon'],
                            color: _icons![iconIndex!]['color']),
                  )
                ]),
              ),
            ),
            // :
            //  CircleAvatar(
            //       backgroundColor: Colors.black12,
            //             backgroundImage: AssetImage('assets/blank1.png',),
            //             radius: 120,
            //            // child: Text('select image'),
            //     ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class GenerateIcons extends StatelessWidget {
  final Function(int index)? iconHandler;
  final List<Map<String, dynamic>>? icons;
  GenerateIcons({
    Key? key,
    @required this.iconHandler,
    @required this.icons,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: icons!.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                iconHandler!(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                child: Icon(
                  icons![index]['icon'],
                  color: icons![index]['color'],
                ),
              ),
            );
          }),
    );
  }
}

class GenerateFrames extends StatelessWidget {
  final Function(int index)? indexHandler;
  final List<dynamic>? listOfFrames;
  GenerateFrames({
    Key? key,
    @required this.indexHandler,
    @required this.listOfFrames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 30,
        child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: listOfFrames?.length,
      itemBuilder: (ctx, index) {
        print("FRAME:RUNTYPE:${listOfFrames![index].runtimeType}");
        return GestureDetector(
            onTap: () {
              indexHandler!(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              child: listOfFrames![index].runtimeType != String
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: listOfFrames![index] as Color, width: 5),
                          borderRadius: BorderRadius.circular(100)),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        listOfFrames![index].toString(),
                      ),
                    ),
            ));
      },
    ));
  }
}
