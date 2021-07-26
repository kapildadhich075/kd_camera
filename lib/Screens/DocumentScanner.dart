import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kd_camera/Screens/document_crop.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_screen.dart';

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({Key? key}) : super(key: key);

  @override
  _DocumentScannerState createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  bool flash = false;
  CameraController? _cameraController;
  Future<void>? cameraValue;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController!.dispose();
  }

  Widget _cameraPreview() => FutureBuilder(
        future: cameraValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: MediaQuery.of(context).size.width * 16 / 9,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(_cameraController!),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
  void takePhoto(BuildContext context) async {
    final path =
        join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    imageFile = await _cameraController!.takePicture();
    imageFile!.saveTo(path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DocumentCrop(
          path: path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(
          children: [
            Stack(
              children: [
                _cameraPreview(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => CameraScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back,
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
                              ? _cameraController!.setFlashMode(FlashMode.torch)
                              : _cameraController!.setFlashMode(FlashMode.off);
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
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          takePhoto(context);
                        },
                        child: Icon(
                          Icons.panorama_fish_eye_outlined,
                          color: Colors.white,
                          size: 80.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "Tap to Scan",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
