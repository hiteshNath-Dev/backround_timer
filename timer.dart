import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  Timer? _timer;
  int _seconds = 0;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print('888888888');
    _saveTimer();
    _cancelTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print("*******AppLifecycleState.detached******");
      return;
    }

    if (state == AppLifecycleState.paused) {
      print("*******AppLifecycleState.paused******");

      _saveTimer();
      _cancelTimer();
    }

    if (state == AppLifecycleState.resumed) {
      print("*******AppLifecycleState.resumed******");

      _loadTimer();
    }
  }

  void _loadTimer() {
    setState(() {
      _seconds = box.read('timer') ?? 0;
      print("load _seconds: ----> $_seconds");
    });
    _startTimer();
  }

  void _saveTimer() {
    box.write('timer', _seconds);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Screen'),
      ),
      body: Center(
        child: Text('Timer: $_seconds seconds'),
      ),
    );
  }
}
