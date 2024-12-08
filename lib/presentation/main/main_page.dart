import 'package:alarm_app/presentation/timer/timer_page.dart';
import 'package:flutter/material.dart';

import '../core/app_color/app_color.dart';
import '../home/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex.value == 1) {
          // If the current tab is Profile (Tab 1), switch to Home (Tab 0)
          selectedIndex.value = 0;
          return false; // Prevent exiting the app
        } else {
          // If already on Home (Tab 0), show exit confirmation
          final shouldExit = await _showExitConfirmationDialog(context);
          return shouldExit;
        }
      },
      child: Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, index, child) {
            return IndexedStack(
              index: index,
              children: const [
                HomePage(),
                TimerPage(),
              ],
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, index, child) {
            return BottomNavigationBar(
              backgroundColor: kPrimaryColor,
              fixedColor: kSecondaryColor,
              currentIndex: index, // Current selected index
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer),
                  label: 'Timer',
                ),
              ],
              onTap: (value) {
                selectedIndex.value = value; // Update the selected index
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kWhiteColor,
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: kErrorColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Exit',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: kSuccessColor,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false; // Return false if dialog is dismissed without selection
  }
}
