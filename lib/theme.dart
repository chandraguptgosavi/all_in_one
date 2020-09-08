
import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier{

  bool _isDark;

  bool get isDark => _isDark;

  set isDark(bool val){
    _isDark = val;
    notifyListeners();
  }
}