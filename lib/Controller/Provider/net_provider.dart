import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class UrlProvider extends ChangeNotifier {
  bool isNet = false;
  double progress = 0;
  bool canGoBack = false;
  bool canGoForward = false;
  int selectedValue = 1;

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  UrlProvider() {
    addNetListener();
  }

  void changeNetConnection(bool isNet) {
    this.isNet = isNet;
    notifyListeners();
  }

  void changeProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  void backForwardStatus(bool canGoBack, bool canGoForward) {
    this.canGoBack = canGoBack;
    this.canGoForward = canGoForward;
    notifyListeners();
  }

  void addNetListener() {
    var listen = Connectivity().onConnectivityChanged.listen((event) {
      connectivityResult = event;
      notifyListeners();
    });
  }

  void radioChange(int v) {
    selectedValue = v;
    notifyListeners();
  }
}
