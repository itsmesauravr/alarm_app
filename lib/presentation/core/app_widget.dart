import 'package:alarm_app/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main/main_page.dart';
import 'app_theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      enableScaleText: () => true,
      enableScaleWH: () => true,
      ensureScreenSize: true,
      fontSizeResolver: (fontSize, instance) => fontSize * 1,
      minTextAdapt: true,
      rebuildFactor: (old, data) => old != data,
      splitScreenMode: false,
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alarm App',
        theme: appThemeData[AppTheme.light],
        home: const MainPage(),
      ),
    );
  }
}
