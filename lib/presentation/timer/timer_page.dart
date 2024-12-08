import 'dart:async';
import 'package:alarm_app/presentation/core/app_color/app_color.dart';
import 'package:alarm_app/presentation/core/app_sized_box/app_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/core/notification/app_notification.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _remainingTime = ValueNotifier(0);
  final TextEditingController _durationController = TextEditingController();
  Timer? _timer;
  int _initialDuration = 0;

  @override
  void initState() {
    super.initState();
    enableBackgroundExecution();
  }

  Future<void> enableBackgroundExecution() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Timer App",
      notificationText: "Timer is running in the background",
      enableWifiLock: true,
    );

    bool initialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    if (initialized) {
      await FlutterBackground.enableBackgroundExecution();
    } else {
      debugPrint('Failed to initialize FlutterBackground.');
    }
  }

  void startTimer(int duration) {
    _initialDuration = duration; // Save the total duration
    _remainingTime.value = duration;

    _timer?.cancel(); // Cancel any existing timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        timer.cancel();
        showNotification('Timer Finished', 'Your countdown has ended!');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    FlutterBackground.disableBackgroundExecution();
    _durationController.dispose();
    _remainingTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer Progress Circle
              ValueListenableBuilder<int>(
                valueListenable: _remainingTime,
                builder: (context, value, child) {
                  double progress =
                      _initialDuration > 0 ? value / _initialDuration : 1.0;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: progress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, progress, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 150.h,
                            width: 150.w,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: kGreyColor,
                              color: kSuccessColor,
                            ),
                          ),
                          Text(
                            '$value s',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              kHeight50,
              // Timer Input Field
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  labelText: 'Enter Timer Duration (in seconds)',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  filled: true,
                  fillColor: kGreyColor.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kErrorColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                ),
              ),
              kHeight20,
              // Start Timer Button
              InkWell(
                onTap: () {
                  if (_durationController.text.isNotEmpty) {
                    final int duration =
                        int.tryParse(_durationController.text) ?? 0;
                    if (duration > 0) {
                      startTimer(duration);
                      _durationController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid duration!')),
                      );
                      _durationController.clear();
                    }
                  }
                },
                borderRadius: BorderRadius.circular(15.r),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kInfoColor,
                  ),
                  child: Text('Start Timer',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: kWhiteColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
