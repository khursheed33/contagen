import 'package:contagen/providers/courseProvider.dart';
import 'package:contagen/screens/saveToCustomFolder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<CourseProvider>(
            create: (ctx) => CourseProvider(),
          ),
        ],
        child: SaveFileToCustomFolder(),
      ),
    );
  }
}
