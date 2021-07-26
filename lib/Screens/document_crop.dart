import 'dart:io';

import 'package:flutter/material.dart';

class DocumentCrop extends StatefulWidget {
  const DocumentCrop({Key? key, this.path}) : super(key: key);
  final String? path;
  @override
  _DocumentCropState createState() => _DocumentCropState();
}

class _DocumentCropState extends State<DocumentCrop> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              color: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Container(
                    width: 250.0,
                    child: Text(
                      "${widget.path}",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Image.file(
                  File(
                    widget.path.toString(),
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
