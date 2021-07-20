import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:kd_camera/Screens/cameraView.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'VideoView.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  final double iconHeight = 30;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? cameraValue;
  bool isRecording = false;
  XFile? videoFile;
  bool iscameraFront = true;
  bool flash = false;
  double transform = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _controller!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(children: [
          _cameraPreview(),
          Positioned(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.document_scanner_rounded,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flash = !flash;
                      });
                      flash
                          ? _controller!.setFlashMode(FlashMode.torch)
                          : _controller!.setFlashMode(FlashMode.off);
                    },
                    child: flash
                        ? Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 30.0,
                          )
                        : Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 30.0,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171__340.jpg")),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () async {
                          await _controller!.startVideoRecording();
                          setState(() {
                            isRecording = true;
                          });
                        },
                        onLongPressUp: () async {
                          XFile videoPath =
                              await _controller!.stopVideoRecording();
                          setState(() {
                            isRecording = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => VideoView(
                                path: videoPath.path,
                              ),
                            ),
                          );
                        },
                        onTap: () {
                          if (!isRecording) {
                            takePhoto(context);
                          }
                        },
                        child: isRecording
                            ? Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80.0,
                              )
                            : Icon(
                                Icons.panorama_fish_eye_outlined,
                                color: Colors.white,
                                size: 80.0,
                              ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            iscameraFront = !iscameraFront;
                            transform = transform + pi;
                          });
                          int cameraPos = iscameraFront ? 0 : 1;
                          _controller = CameraController(
                              cameras![cameraPos], ResolutionPreset.high);
                          cameraValue = _controller!.initialize();
                        },
                        child: Icon(
                          Icons.flip_camera_android,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Hold for the Video, Tap for the Photo",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _cameraPreview() => FutureBuilder(
        future: cameraValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(_controller!),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

  void takePhoto(BuildContext context) async {
    final path =
        join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    XFile picture = await _controller!.takePicture();
    picture.saveTo(path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => CameraView(
          path: path,
        ),
      ),
    );
  }
}