import 'package:flutter/material.dart';
import 'dart:async';

enum TimerState { stop, start, pause }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  int totalPomodoros = 0;
  late Timer timer;
  TimerState timerState = TimerState.stop;

  late final _timerHandler = {
    TimerState.stop: () => onStopPressed(),
    TimerState.start: () => onStartPressed(),
    TimerState.pause: () => onPausePressed(),
  };

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void callTimerHandler({
    required TimerState toState,
  }) {
    setState(() {
      timerState = toState;
      _timerHandler[timerState]!();
    });
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      timerState = TimerState.start;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      timerState = TimerState.pause;
    });
  }

  void onStopPressed() {
    timer.cancel();
    setState(() {
      timerState = TimerState.stop;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split('.').first.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: IconButton(
                    iconSize: 120,
                    onPressed: () => timerState == TimerState.start
                        ? callTimerHandler(
                            toState: TimerState.pause,
                          )
                        : callTimerHandler(
                            toState: TimerState.start,
                          ),
                    icon: Icon(
                      timerState == TimerState.start
                          ? Icons.pause_circle_outline_outlined
                          : Icons.play_circle_outline,
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                ),
                if (timerState != TimerState.stop)
                  Center(
                    child: IconButton(
                      iconSize: 120,
                      onPressed: () => callTimerHandler(
                        toState: TimerState.stop,
                      ),
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(45)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pomodoro",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 58,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
