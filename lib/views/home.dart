import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:download/services/download_service.dart';
import 'package:download/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/DataModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  var list=<DownloadData>[];
  var downloadService=DownloadService(NotificationService());

  @override
  void initState() {
    list.clear();
    _dataAdder();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: const Center(child: Text('Download')),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            child: const CircularProgressIndicator(),
          ),
          const Divider(height: 1,),
          Container(
            alignment: Alignment.center,
            height: 60,
            child: const Text("Actions"),
          ),
          const Divider(height: 1,),

          Expanded(child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_,i)=>Column(

              children: [
                SizedBox(
                  // margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width)*0.01, right: (MediaQuery.of(context).size.width)*0.01),
                  height: 60,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: (MediaQuery.of(context).size.width)*0.15,
                        child: Text("${i+1}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                      ),
                      SizedBox(
                        // color: Colors.yellow,
                        width: (MediaQuery.of(context).size.width)*0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(list[i].fileName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
                            Text(list[i].typeOfDownlad, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),

                          ],
                        ),
                      ),
                      Container(
                        //   color: Colors.green,
                        alignment: Alignment.center,
                        width: (MediaQuery.of(context).size.width)*0.15,
                        child: InkWell(
                          onTap: (){

                            var d=list[i];
                            _downloadRequestFile(d);
                          },
                          child: const Icon(Icons.download_for_offline_outlined, size: 40,),
                        ),
                      ),

                    ],

                  ),
                ),
                const Divider(height: 1,),
              ],
            ),

          ))
        ],
      ),
     // floatingActionButton: FloatingActionButton(onPressed: (){}, child: const CircularProgressIndicator(),),
    );
  }


  void _downloadRequestFile(DownloadData d) async{
    bool storage = true;
    bool videos = true;
    bool photos = true;


    if(Platform.isAndroid){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        //videos = await Permission.mediaLibrary.status.isGranted;
        videos = await Permission.videos.status.isGranted;
        photos = await Permission.photos.status.isGranted;
      } else {
        storage = await Permission.storage.status.isGranted;
      }
    }else if(Platform.isIOS){
      storage = await Permission.storage.status.isGranted;
    }




    if (storage) {
      Fluttertoast.showToast(msg:'Storage Permission is Granted' );

      if(d.typeOfDownlad=='Download & Open'){
        await  downloadService.manualDownloaderDirectOpen(d);
      }else if(d.typeOfDownlad=='Download & Save'){
        await  downloadService.manualDownloadAndSave(d);
      }else if(d.typeOfDownlad=='Download With Notification'){
        await  downloadService.downloadWithNotification(d);
      }else if(d.typeOfDownlad=='Download Notification & Isolation'){
        await  downloadService.downloadWithNotificationIsolation(d);
      }





    } else {
      Fluttertoast.showToast(msg:'Storage Permission is Declined' );
    }



  }



  void _dataAdder() {
    list.add(DownloadData(1, 'Statement-1',"Download & Open", 'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
    list.add(DownloadData(2, 'Statement-2',"Download & Save", 'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
    list.add(DownloadData(3, 'Statement-3',"Download With Notification",'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
    list.add(DownloadData(4, 'Statement-4',"Download Notification & Isolation" ,'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
    list.add(DownloadData(5, 'Statement-5',"", 'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
    list.add(DownloadData(6, 'Statement-6',"", 'https://www.ms.sapientia.ro/~manyi/teaching/oop/oop_java.pdf', "https://png.pngtree.com/png-clipart/20220612/original/pngtree-pdf-file-icon-png-png-image_7965915.png"));
  }

}
