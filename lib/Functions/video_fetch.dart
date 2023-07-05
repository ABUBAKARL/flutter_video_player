import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoFetch {
  List<String> videoFormatExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.wmv',
    '.flv',
    '.mov',
    '.webm',
    '.mpg',
    '.mpeg',
    '.3gp',
    '.m4v',
    '.ogv',
    '.divx',
    '.vob',
    '.rm',
    '.rmvb',
    '.swf',
    '.asf',
    '.mpg2',
    '.mpg4',
    '.m2v',
    '.mpeg2',
    '.mpeg4',
    '.h264',
    '.h265',
    '.ts',
    '.mts',
    '.m2ts',
    '.mxf',
    '.qt',
    '.f4v',
    '.amv',
    '.drc',
    '.gvi',
    '.k3g',
    '.m2p',
    '.mp2',
    '.mpe',
    '.m4p',
    '.mpg1',
    '.ogm',
    '.ogx',
    '.srt',
    '.viv',
    '.yuv'
  ];
  late List<File> videoFiles;
  late Directory externalDir;
  Future getStoragePermission() async {
    PermissionStatus storagepermission = await Permission.storage.request();
    if (storagepermission.isGranted) {
      debugPrint("Permission Granted");
    } else {
      openAppSettings();
    }
  }

  Future<List<File>> GetDir() async {
    videoFiles = [];

    externalDir = (await getExternalStorageDirectory())!;
    List<FileSystemEntity> directories =
        externalDir.parent.parent.parent.parent.listSync();
    FileSystemEntity i;
    while (true) {
      if (directories.isEmpty) {
        break;
      } else {
        i = directories[directories.length - 1];
        if (i.statSync().type == FileSystemEntityType.file) {
          for (var extension in videoFormatExtensions) {
            if (".${i.path.split(".").last}" == extension) {
              videoFiles.add(File(i.path));
              break;
            }
          }
        } else if (i.statSync().type == FileSystemEntityType.directory) {
          if (i.path.split("/").last == "obb" ||
              i.path.split("/").last.startsWith(".") ||
              i.path.split("/").last == "data") {
          } else if (Directory(i.path).listSync().isNotEmpty) {
            directories.addAll(
              Directory(i.path).listSync(),
            );
          }
        }
      }
      directories.remove(i);
    }
    return videoFiles;
  }
}
