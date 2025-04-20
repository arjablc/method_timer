import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  Duration _remainingDuration = Duration(seconds: 0);
  final _totalDuration = Duration(minutes: 5);
  late DateTime endTime;

  // for the next update timer.
  Duration get _nextTick {
    return _remainingDuration - Duration(seconds: _remainingDuration.inSeconds);
  }

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    final startFrom =
        (_remainingDuration > Duration.zero)
            ? _remainingDuration
            : _totalDuration;
    endTime = DateTime.now().add(startFrom);
    tick();
  }

  void tick() {
    setState(() {});
    _remainingDuration = endTime.difference(DateTime.now());
    if (_remainingDuration > Duration.zero) {
      _timer = Timer(_nextTick, tick);
    } else {
      _stopTimer();
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
    }
  }

  void _pasue() {
    if (!_isRunning) return;
    _isPaused = true;
    _stopTimer();

    setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    _isRunning = false;
    _isPaused = false;
    endTime = DateTime.now().add(_totalDuration);
    _remainingDuration = _totalDuration;
    setState(() {});
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(
                _remainingDuration.inSeconds == 0
                    ? _totalDuration
                    : _remainingDuration,
              ),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isRunning)
                  ElevatedButton(onPressed: _pasue, child: const Text('Pause'))
                else if (_isPaused)
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Resume'),
                  )
                else
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Start'),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
