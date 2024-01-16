import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util.dart';

class UrlProvider extends ChangeNotifier {
  bool isNet = false;
  double progress = 0;
  bool canGoBack = false;
  bool canGoForward = false;

  int? selectedValue=1;

  String currentUrl = "";
  String pageTitle = " ";
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  void changeProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  void backForwardStatus(bool canGoBack, bool canGoForward) {
    this.canGoBack = canGoBack;
    this.canGoForward = canGoForward;
    notifyListeners();
  }

  void radioChange(int v) {
    selectedValue = v;
    notifyListeners();
  }

  Future<void> removeBookmark(int i) async {
    localLink.removeAt(i);
    localLink1.removeAt(i);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('link', localLink);
    prefs.setStringList('link1', localLink1);
    notifyListeners();
  }

  void changeNetConnection(bool isNet) {
    this.isNet = isNet;
    notifyListeners();
  }
}
