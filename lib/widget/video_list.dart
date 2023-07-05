import 'dart:io';
import 'package:flutter/material.dart';
import '../pages/video_view.dart';

class VideoList extends StatefulWidget {
  final List<File> videoList;
  const VideoList({super.key, required this.videoList});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.videoList.length,
        itemBuilder: (BuildContext context, int index) {
          final videoName =
              widget.videoList[index].path.split("/").last.split(".").first;
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VideoView(
                        video: File(
                          widget.videoList[index].path,
                        ),
                      );
                    },
                  ),
                );
                // print(Video_name);
              },
              title: Text(
                videoName,
              ),
            ),
          );
        },
      ),
    );
  }
}
