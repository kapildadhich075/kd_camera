import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key, this.path}) : super(key: key);
  final String? path;

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path.toString()))
      ..initialize().then((_) {
        setState(() {});
      });
  }

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
            Container(
              child: Stack(
                children: [
                  Container(
                    child: _controller!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : Container(),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.longestSide / 3,
                    right: MediaQuery.of(context).size.shortestSide / 2.5,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: _controller!.value.isPlaying
                          ? CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 33.0,
                              child: Icon(
                                Icons.pause,
                                size: 50.0,
                                color: Colors.white30,
                              ),
                            )
                          : CircleAvatar(
                              radius: 33.0,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.play_arrow,
                                size: 50.0,
                                color: Colors.white30,
                              ),
                            ),
                    ),
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
