import 'package:flutter/material.dart';
import 'package:kd_camera/Screens/Camera_home.dart';
import 'package:camera/camera.dart';
import 'package:kd_camera/Screens/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KD_Camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraHome(),
    );
  }
}
