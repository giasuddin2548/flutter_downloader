
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  static Future<void> init(FlutterLocalNotificationsPlugin localNotificationsPlugin)async{
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =DarwinInitializationSettings (
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS,);
    await localNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



   Future<void> showDownloadNotification({required FlutterLocalNotificationsPlugin plugin,required int maxProgress,required int progress,required String title, required int id})async{


    AndroidNotificationDetails androidPlatformChannelSpecifics =  AndroidNotificationDetails(
      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
      showProgress: true,
      onlyAlertOnce: true,
      maxProgress:maxProgress ,
      progress: progress,


    );
    DarwinNotificationDetails iosPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,


    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    plugin.show(id, title, title, platformChannelSpecifics);

  }



  Future<void> showDownloadCompleted({required FlutterLocalNotificationsPlugin plugin,required int maxProgress,required int progress,required String title, required int id})async{


    AndroidNotificationDetails androidPlatformChannelSpecifics =  AndroidNotificationDetails(

      'channel ID',
      'channel name',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,

    );
    DarwinNotificationDetails iosPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,


    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    clearNotification(plugin);
    plugin.show(id, title, title, platformChannelSpecifics);

  }







  static void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('Checker:__ ${StackTrace.current} Method Called');
  }




  static void clearNotification(FlutterLocalNotificationsPlugin plugin)async{
    await plugin.cancelAll();
  }

  static void clearOnlyOneNotification(int counter, FlutterLocalNotificationsPlugin plugin)async {
    await plugin.cancel(counter);
  }




}