import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotificationManager {
  static LocalNotificationManager get instance => _instance!;
  static LocalNotificationManager? _instance;

  static void init() {
    _instance = LocalNotificationManager();
  }

  factory LocalNotificationManager() {
    if (_instance == null)
      _instance = LocalNotificationManager._createInstance();
    return _instance!;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late InitializationSettings initializationSettings;
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();

  LocalNotificationManager._createInstance()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    _initializePlatform();
  }

  void _initializePlatform() {
    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('ic_launcher');

    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
  }

  void setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }


  void setOnNotificationClick(Function(String?) onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // onSelectNotification: (String? payload) async {
        //   onNotificationClick(payload);
        // }

        );
  }

  Future<void> instantShowNotification({
    int id = 0,
    String title = 'Water Drink Reminder',
    String body = 'let\'s get hydrated',
    String? payload,
  }) async {
    var platformChannelSpecifics = _platformSpecifics();

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> repeatNotification({
    int id = 0,
    String title = 'Water Drink Reminder',
    String body = 'let\'s get hydrated',
    String? payload,
  }) async {
    var platformChannelSpecifics = _platformSpecifics();

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.hourly,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  NotificationDetails _platformSpecifics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'water_reminder_notif',
      'water_reminder_notif',
     // 'Channel for Water Reminder notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }
}


class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
