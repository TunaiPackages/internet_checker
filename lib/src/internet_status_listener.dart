import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:internet_checker/internet_checker.dart';
import 'package:internet_checker/src/internet_status.dart';

class InternetStatusListener extends StatefulWidget {
  final Widget Function(BuildContext context, InternetStatus status) builder;
  final void Function(InternetStatus status) onInternetStatusChange;
  const InternetStatusListener({
    super.key,
    required this.builder,
    required this.onInternetStatusChange,
  });

  @override
  State<InternetStatusListener> createState() => _InternetStatusListenerState();
}

class _InternetStatusListenerState extends State<InternetStatusListener> {
  final InternetChecker internetChecker = InternetChecker();
  late final StreamSubscription<InternetStatus> internetStatusSubs;

  @override
  void initState() {
    super.initState();
    internetStatusSubs = internetChecker.internetStatusStream.listen((event) {
      widget.onInternetStatusChange(event);
    });
  }

  @override
  void dispose() {
    internetStatusSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: internetChecker.internetStatusStream,
      builder: (context, snapshot) {
        return widget.builder(context, internetChecker.internetStatus);
      },
    );
  }
}
