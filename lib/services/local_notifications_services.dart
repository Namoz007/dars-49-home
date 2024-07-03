import 'dart:io';

import 'package:dars_49/services/motivation_words_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;

class LocalNotificationsServices {
  static final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
  static bool notificationEnabled = false;

  static void requestPermission() async {
    // Birinchi dasturimiz qaysi qurilmada run bo'layotganini tekshiramiz
    if (Platform.isIOS || Platform.isMacOS) {
      // Agar IOS bo'lsa unda
      // shu kod orqali notification'ga ruxsat so'raymiz
      notificationEnabled = await _localNotificationPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      // Agar MacOS bo'lsa unda
      // bu kod orqali notification'ga ruxsat so'raymiz
      await _localNotificationPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      // Agar Android qurilma bo'lsa unda
      // bu kod orqali android notification sozlamasini olamiz
      final androidImplementation =
          _localNotificationPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // va bu yerda darhol xabarnomasiga ruxsat so'raymiz
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      // bu yerda esa rejali xabarnomaga ruxsat so'raymiz
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();
      // bu yerda o'zgaruvchiga belgilab qo'yapmiz foydalanuvchi ruxsat berdimi yoki yo'q
      notificationEnabled = grantedNotificationPermission ?? false;
      notificationEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> init() async {

     final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    const iosInit = DarwinInitializationSettings();

    const notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    _localNotificationPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await _localNotificationPlugin.initialize(notificationInit);
  }

  static void showScheduleNotification() async {
    const androidDetails = AndroidNotificationDetails(
        "goodChanelId", "goodChanelName",
        importance: Importance.max,
        priority: Priority.high,
        sound: UriAndroidNotificationSound("notifications"));

    const iosDetails = DarwinNotificationDetails(
      sound: "notificationl.aiff",
    );

    const notificationsDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationPlugin.zonedSchedule(
        0,
        "Birinchi notification",
        "Salom sizga daxxuya pul tushdi",
        tz.TZDateTime.now(tz.local).add(
          const Duration(seconds: 5),
        ),
        notificationsDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void showNotification() async {
    const androidDetails = AndroidNotificationDetails(
        "goodChanelId", "goodChanelName",
        importance: Importance.max,
        priority: Priority.high,
        sound: UriAndroidNotificationSound("notifications"));

    const iosDetails = DarwinNotificationDetails(
      sound: "notificationl.aiff",
    );

    const notificationsDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotificationPlugin.show(0, "Birinchi notification",
        "Salom sizga daxxuya pul tushdi", notificationsDetails);
  }

  static void dayNotification() async {
    final _motivationServices = MotivationWordsServices();
    const androidDetails = AndroidNotificationDetails(
        "goodChanelId", "goodChanelName",
        importance: Importance.max,
        priority: Priority.high,);

    const iosDetails = DarwinNotificationDetails();

    const notificationsDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    String motivation = await _motivationServices.getMotivations();

    _localNotificationPlugin.show(0, "Ertalapki motivatsiya",
        motivation, notificationsDetails);
  }

  static void todoNotification(String title,String description) async {
    final _motivationServices = MotivationWordsServices();
    const androidDetails = AndroidNotificationDetails(
      "goodChanelId", "goodChanelName",
      importance: Importance.max,
      priority: Priority.high,);

    const iosDetails = DarwinNotificationDetails();

    const notificationsDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    _localNotificationPlugin.show(0, title,
        description, notificationsDetails);
  }

}
