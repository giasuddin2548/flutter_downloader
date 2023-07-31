import 'dart:io';
import 'dart:ui';

import 'package:download/services/notification_service.dart';
import 'package:download/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:permission_handler/permission_handler.dart';

FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
final navKey =  GlobalKey<NavigatorState>();

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) PathProviderAndroid.registerWith();
  if (Platform.isIOS) PathProviderIOS.registerWith();
  await NotificationService.init(flnp);
  if(Platform.isIOS){
    //print('Checker:__ ${StackTrace.current} Method Called');
    await NotificationService.requestIOSPermissions(flnp);
  }
  var notification=await Permission.notification.request();
  if(notification.isGranted){
    Fluttertoast.showToast(msg:'Notification Permission is Granted' );
  }else{
    Fluttertoast.showToast(msg:'Notification Permission is Declined' );
    await Permission.notification.request();

  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Download',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
