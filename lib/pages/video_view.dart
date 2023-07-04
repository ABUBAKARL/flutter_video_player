import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final File video;
  const VideoView({super.key, required this.video});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController videoPlayerController;
  bool visible = true;
  IconData videostate = Icons.pause_rounded;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(
      File(
        widget.video.path,
      ),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
      ),
    )
      ..initialize().then((value) => {
            setState(() {}),
          })
      ..addListener(() {
        videostate = videoPlayerController.value.isPlaying
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded;
        setState(() {});
      });

    videoPlayerController.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  visible ? visible = false : visible = true;
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AspectRatio(
                      aspectRatio: videoPlayerController.value.size.aspectRatio,
                      child: VideoPlayer(
                        videoPlayerController,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: visible,
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                color: Colors.white,
                                iconSize: 30,
                                onPressed: () {
                                  videoPlayerController.value.isPlaying
                                      ? videoPlayerController.pause()
                                      : videoPlayerController.play();
                                },
                                icon: Icon(videostate),
                              ),
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.green,
                                  value: videoPlayerController
                                      .value.position.inSeconds
                                      .toDouble(),
                                  min: 0,
                                  max: videoPlayerController
                                      .value.duration.inSeconds
                                      .toDouble(),
                                  onChanged: (sliderValue) {
                                    videoPlayerController.seekTo(
                                      Duration(
                                        seconds: sliderValue.toInt(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(
                                "${videoPlayerController.value.position.inMinutes}:${videoPlayerController.value.position.inSeconds % 60}/${videoPlayerController.value.duration.inMinutes}:${videoPlayerController.value.duration.inSeconds % 60}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
