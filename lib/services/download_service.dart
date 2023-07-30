
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:download/model/DataModel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'notification_service.dart';
FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
class DownloadService{
  NotificationService notificationService;
  DownloadService(this.notificationService);
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Future<void> manualDownloaderDirectOpen(DownloadData data) async {
    var url='https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf';
    final  directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf";
    print('Download-Start:');
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes), onReceiveProgress: (count, total)async{
      print('Downloading->$count');
    });

    if(response.statusCode==200){
      Fluttertoast.showToast(msg: "Download Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }else{
      Fluttertoast.showToast(msg: "Download Failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }
    print('Download-Response: $response');
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    print('Download-Path:${file.path}');
    OpenFile.open(file.path);
  }
  Future<void> manualDownloadAndSave(DownloadData data) async {
    var url='https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf';
    final  directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf";
    print('Download-Path:->$filePath');
    print('Download-Start:');
    var response=await Dio().download(url, filePath, onReceiveProgress: (count, total){
      print('Downloading->$count');
    });
    if(response.statusCode==200){
      Fluttertoast.showToast(msg: "Download Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }else{
      Fluttertoast.showToast(msg: "Download Failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }

  }
  Future<void> downloadWithNotification(DownloadData d) async {

    var url='https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf';
    final  directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf";
    print('Download-Path:->$filePath');
    print('Download-Start:');
    var response=await Dio().download(url, filePath, onReceiveProgress: (count, total){
      notificationService.showDownloadNotification(plugin: plugin, maxProgress: total, progress: count, title: d.fileName, id: d.id);
    });
    if(response.statusCode==200){
      Fluttertoast.showToast(msg: "Download Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }else{
      Fluttertoast.showToast(msg: "Download Failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    }
  }


  @pragma('vm:entry-point')
  Future<void> downloadWithNotificationIsolation(DownloadData d) async {
    final receiverPort=ReceivePort();
    try{
      await Isolate.spawn(_downloadWithNotificationIsolation, [receiverPort.sendPort, d]);

    }catch(e){
      print(e);
    }
    final response=await receiverPort.first as String;

    Fluttertoast.showToast(msg: response, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
  ///  notificationService.showDownloadCompleted(plugin: plugin, maxProgress: 0, progress: 0, title: d.fileName, id: 2);

    // OpenFile.open(response);
    // print('Download Result-> $response');

  }

  @pragma('vm:entry-point')
  void _downloadWithNotificationIsolation(List<dynamic> args) async {
    var myMax=0;
    var myMin=0;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    SendPort sendPort=args[0];
    var d=args[1] as DownloadData;
    final  directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.pdf";
    print('Download-Path:->$filePath');
    print('Download-Start:');
    var response=await Dio().download(d.url, filePath, onReceiveProgress: (count, total){
      myMax=total;
      myMin=count;
      notificationService.showDownloadNotification(plugin: plugin, maxProgress: total, progress: count, title: d.fileName, id: d.id);
    });
    if(response.statusCode==200){


      Isolate.exit(sendPort, "Download Successful");

    }else{
      Isolate.exit(sendPort, "Download Failed");
    }


  }




}