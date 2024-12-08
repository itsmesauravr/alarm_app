import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_color/app_color.dart';
import '../app_padding/app_padding.dart';

enum AppTheme { light }

final appThemeData = {
  AppTheme.light: ThemeData(
    scaffoldBackgroundColor: kPrimaryColor,
    primaryColor: kPrimaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      surfaceTintColor: kPrimaryColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      displayLarge: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.normal,
        color: kTextPrimaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
        color: kTextPrimaryColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kPrimaryColor,
      selectedItemColor: kSecondaryColor,
      unselectedItemColor: kBlackColor.withOpacity(0.5),
      elevation: 10,
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: kPrimaryColor,
      textStyle: TextStyle(
        color: kTextPrimaryColor,
        fontSize: 12.sp,
        fontFamily: 'DMSans',
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: kPrimaryColor,
      surfaceTintColor: kPrimaryColor,
      titleTextStyle: TextStyle(
        color: kSecondaryColor,
        fontSize: 18.sp,
        fontFamily: 'DMSans',
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: kTextPrimaryColor.withOpacity(0.8),
        fontSize: 14.sp,
        fontFamily: 'DMSans',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      barrierColor: kBlackColor.withOpacity(0.5),
      actionsPadding: kPaddingAll15,
      insetPadding: kPaddingAll15,
    ),
  ),
};
