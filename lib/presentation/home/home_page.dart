import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/presentation/core/app_color/app_color.dart';
import 'package:alarm_app/presentation/core/app_padding/app_padding.dart';
import 'package:alarm_app/presentation/core/app_permission/app_permiossion.dart';
import 'package:alarm_app/presentation/core/app_sized_box/app_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<List<AlarmSettings>> alarms = ValueNotifier([]);
  StreamSubscription<AlarmSettings>? ringSubscription;
  StreamSubscription<int>? updateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppAlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AppAlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }
    unawaited(loadAlarms());
    ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    updateSubscription ??= Alarm.updateStream.stream.listen((_) {
      unawaited(loadAlarms());
    });
  }

  Future<void> loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    alarms.value = [...updatedAlarms];
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    unawaited(loadAlarms());
  }

  Future<void> navigateToAlarmSettingsPage(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return AlarmSettingsPage(alarmSettings: settings);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ringSubscription?.cancel();
    updateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alarm',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: alarms,
        builder: (context, value, child) {
          return value.isNotEmpty
              ? ListView.separated(
                  itemCount: value.length,
                  padding: kPaddingAll15,
                  separatorBuilder: (context, index) => kHeight15,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlarmDetailsPage(
                                alarmIndex: index, alarm: alarms.value[index]),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'alarm_$index',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutQuint,
                          height: 100.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kBorderColor),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - value) * 20),
                                      child: Text(
                                        TimeOfDay(
                                          hour:
                                              alarms.value[index].dateTime.hour,
                                          minute: alarms
                                              .value[index].dateTime.minute,
                                        ).format(context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              trailing: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.scale(
                                      scale: value,
                                      child: Switch(
                                        value: true,
                                        onChanged: (value) {
                                          Alarm.stop(alarms.value[index].id)
                                              .then((_) {
                                            unawaited(loadAlarms());
                                          });
                                        },
                                        activeColor: kSuccessColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No alarms set',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecondaryColor,
        onPressed: () {
          navigateToAlarmSettingsPage(null);
        },
        child: const Icon(
          Icons.alarm,
          color: kWhiteColor,
        ),
      ),
    );
  }
}

class AlarmDetailsPage extends StatelessWidget {
  final int alarmIndex;
  final AlarmSettings alarm;

  const AlarmDetailsPage({
    super.key,
    required this.alarm,
    required this.alarmIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alarm Details',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'alarm_$alarmIndex',
          child: Container(
            width: double.infinity,
            padding: kPaddingAll15,
            margin: kPaddingAll15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: kBorderColor),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Alarm set for ${TimeOfDay.fromDateTime(alarm.dateTime).format(context)}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  kHeight15,
                  Text(
                    alarm.loopAudio ? 'Loop audio: On' : 'Loop audio: Off',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kHeight15,
                  Text(
                    alarm.vibrate ? 'Vibrate: On' : 'Vibrate: Off',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kHeight15,
                  Text(
                    'Volume: ${alarm.volume ?? 0.5}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kHeight15,
                  Text(
                    'Fade duration: ${alarm.fadeDuration}s',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kHeight15,
                  Text(
                    'Audio: ${alarm.assetAudioPath.split('/').last.replaceAll('.mp3', '')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  kHeight15,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet<bool?>(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        builder: (context) {
                          return AlarmSettingsPage(alarmSettings: alarm);
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: kPaddingAll15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Text(
                        'Edit Alarm',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: kWhiteColor,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlarmSettingsPage extends StatefulWidget {
  const AlarmSettingsPage({
    super.key,
    this.alarmSettings,
  });

  final AlarmSettings? alarmSettings;

  @override
  State<AlarmSettingsPage> createState() => _AlarmSettingsPageState();
}

class _AlarmSettingsPageState extends State<AlarmSettingsPage> {
  late ValueNotifier<bool> loading;
  late ValueNotifier<bool> creating;
  late ValueNotifier<DateTime> selectedDateTime;
  late ValueNotifier<bool> loopAudio;
  late ValueNotifier<bool> vibrate;
  late ValueNotifier<double?> volume;
  late ValueNotifier<double> fadeDuration;
  late ValueNotifier<String> assetAudio;

  @override
  void initState() {
    super.initState();

    creating = ValueNotifier(widget.alarmSettings == null);

    if (creating.value) {
      selectedDateTime =
          ValueNotifier(DateTime.now().add(const Duration(minutes: 1)));
      selectedDateTime.value =
          selectedDateTime.value.copyWith(second: 0, millisecond: 0);
      loopAudio = ValueNotifier(true);
      vibrate = ValueNotifier(true);
      volume = ValueNotifier(null);
      fadeDuration = ValueNotifier(0);
      assetAudio = ValueNotifier('assets/audio/marimba.mp3');
    } else {
      selectedDateTime = ValueNotifier(widget.alarmSettings!.dateTime);
      loopAudio = ValueNotifier(widget.alarmSettings!.loopAudio);
      vibrate = ValueNotifier(widget.alarmSettings!.vibrate);
      volume = ValueNotifier(widget.alarmSettings!.volume);
      fadeDuration = ValueNotifier(widget.alarmSettings!.fadeDuration);
      assetAudio = ValueNotifier(widget.alarmSettings!.assetAudioPath);
    }

    loading = ValueNotifier(false);
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.value.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'today';
      case 1:
        return 'tomorrow';
      case 2:
        return 'after tomorrow';
      default:
        return 'in $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
      context: context,
    );

    if (res != null) {
      final now = DateTime.now();
      selectedDateTime.value = now.copyWith(
        hour: res.hour,
        minute: res.minute,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      if (selectedDateTime.value.isBefore(now)) {
        selectedDateTime.value =
            selectedDateTime.value.add(const Duration(days: 1));
      }
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating.value
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime.value,
      loopAudio: loopAudio.value,
      vibrate: vibrate.value,
      volume: volume.value,
      fadeDuration: fadeDuration.value,
      assetAudioPath: assetAudio.value,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: 'Alarm example',
        body:
            'Your alarm set for ${TimeOfDay.fromDateTime(selectedDateTime.value).format(context)} is ringing',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading.value) return;
    loading.value = true;
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res && mounted) Navigator.pop(context, true);
      loading.value = false;
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ModalRoute.of(context)!.animation!,
      builder: (context, child) {
        final value = ModalRoute.of(context)!.animation!.value;
        return Transform.translate(
          offset: Offset(0, (1 - value) * 200),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: saveAlarm,
                        child: Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  kHeight10,
                  Text(
                    'You are setting alarm for ${getDay()}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: kErrorColor.withOpacity(0.8),
                        ),
                  ),
                  GestureDetector(
                    onTap: pickTime,
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ValueListenableBuilder<DateTime>(
                        valueListenable: selectedDateTime,
                        builder: (context, dateTime, child) {
                          return Text(
                            TimeOfDay.fromDateTime(dateTime).format(context),
                            style: Theme.of(context).textTheme.bodyLarge,
                          );
                        },
                      ),
                    ),
                  ),
                  // Loop alarm audio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loop alarm audio',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: loopAudio,
                        builder: (context, value, child) {
                          return Switch(
                            value: value,
                            onChanged: (value) => loopAudio.value = value,
                            activeColor: Colors.blue,
                          );
                        },
                      ),
                    ],
                  ),
                  kHeight10,
                  // Vibration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vibration',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: vibrate,
                        builder: (context, value, child) {
                          return Switch(
                            value: value,
                            onChanged: (value) => vibrate.value = value,
                            activeColor: kInfoColor,
                          );
                        },
                      ),
                    ],
                  ),
                  kHeight10,
                  // Sound
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sound',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: assetAudio,
                        builder: (context, value, child) {
                          return DropdownButton(
                            value: value,
                            items: [
                              'assets/audio/marimba.mp3',
                              'assets/audio/nokia.mp3',
                              'assets/audio/mozart.mp3',
                              'assets/audio/star_wars.mp3',
                              'assets/audio/one_piece.mp3',
                            ]
                                .map((audio) => DropdownMenuItem<String>(
                                      value: audio,
                                      child: Text(
                                        audio
                                            .split('/')
                                            .last
                                            .replaceAll('.mp3', ''),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) => assetAudio.value = value!,
                          );
                        },
                      ),
                    ],
                  ),
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Custom volume',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ValueListenableBuilder<double?>(
                        valueListenable: volume,
                        builder: (context, value, child) {
                          return Switch(
                            value: value != null,
                            onChanged: (value) =>
                                volume.value = value ? 0.5 : null,
                            activeColor: kInfoColor,
                          );
                        },
                      ),
                    ],
                  ),
                  ValueListenableBuilder<double?>(
                    valueListenable: volume,
                    builder: (context, value, child) {
                      if (value != null) {
                        return SizedBox(
                          height: 30.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                value > 0.7
                                    ? Icons.volume_up_rounded
                                    : value > 0.1
                                        ? Icons.volume_down_rounded
                                        : Icons.volume_mute_rounded,
                              ),
                              Expanded(
                                child: Slider(
                                  value: value!,
                                  onChanged: (value) => volume.value = value,
                                  activeColor: kInfoColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  kHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fade duration',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ValueListenableBuilder<double>(
                        valueListenable: fadeDuration,
                        builder: (context, value, child) {
                          return DropdownButton<double>(
                            value: value,
                            items: List.generate(
                              6,
                              (index) => DropdownMenuItem<double>(
                                value: index * 3.0,
                                child: Text('${index * 3}s',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                            ),
                            onChanged: (value) => fadeDuration.value = value!,
                          );
                        },
                      ),
                    ],
                  ),
                  if (!creating.value)
                    TextButton(
                      onPressed: deleteAlarm,
                      child: Text(
                        'Delete Alarm',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AlarmRingScreen extends StatelessWidget {
  const AlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Your alarm set for ${TimeOfDay.fromDateTime(alarmSettings.dateTime).format(context)} is ringing...',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) {
                      if (context.mounted) Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id).then((_) {
                      if (context.mounted) Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
