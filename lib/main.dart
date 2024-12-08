import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'domain/core/notification/app_notification.dart';
import 'presentation/core/app_widget.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeNotifications();
  await Alarm.init();
  runApp(const AppWidget());
}