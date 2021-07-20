import 'package:flutter/material.dart';
import 'package:kd_camera/Screens/camera_screen.dart';

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraScreen(),
    );
  }
}
