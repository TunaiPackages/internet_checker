import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_checker/src/internet_status.dart';

class InternetChecker {
  static final InternetChecker _instance = InternetChecker._internal();
  InternetChecker._internal();
  factory InternetChecker() {
    return _instance;
  }
  static Future<void> init() {
    return _instance._init();
  }

  bool debugPrint = false;

  List<ConnectivityResult> _connectivityResults = [];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubs;

  InternetStatus get internetStatus =>
      _checkInternetStatus(_connectivityResults);
  final StreamController<InternetStatus> _internetStatusController =
      StreamController<InternetStatus>.broadcast();
  Stream<InternetStatus> get internetStatusStream =>
      _internetStatusController.stream;

  bool get hasInternet => internetStatus != InternetStatus.disconnected;

  void updateInternetStatus() {
    _internetStatusController.add(internetStatus);
  }

  Future<void> _init() async {
    if (_connectivitySubs != null) {
      // print('InternetChecker already initialized');
      return;
    }
    _connectivitySubs = _connectivity.onConnectivityChanged.listen((event) {
      _connectivityResults = event;
      updateInternetStatus();
      if (debugPrint) {
        print('--> Internet Status Changed : $internetStatus  ');
      }
    });
    _connectivityResults = await _connectivity.checkConnectivity();
    updateInternetStatus();
    if (debugPrint) {
      print('--> Internet Status : $internetStatus');
    }
  }

  InternetStatus _checkInternetStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return InternetStatus.connected;
    } else {
      return InternetStatus.disconnected;
    }
  }
}
