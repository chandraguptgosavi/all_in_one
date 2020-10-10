import 'package:all_in_one_sample/home.dart';
import 'package:all_in_one_sample/theme.dart';
import 'package:all_in_one_sample/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String DARK_THEME = 'dark_theme';

SharedPreferences pref;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        pref = await SharedPreferences.getInstance();
        if (pref.getBool(DARK_THEME) != null) {
          Provider.of<AppTheme>(context, listen: false).isDark =
              pref.getBool(DARK_THEME);
        }
      }),
      builder: (_, __) {
        return Consumer<AppTheme>(
          builder: (_, appTheme, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Strings.app_name,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              darkTheme: ThemeData.dark(),
              themeMode: _getThemeMode(appTheme),
              home: MyHomePage(),
            );
          },
        );
      },
    );
  }

  ThemeMode _getThemeMode(AppTheme appTheme) {
    ThemeMode themeMode;
    if (appTheme.isDark == null) {
      themeMode = ThemeMode.system;
    }
    switch (appTheme.isDark) {
      case true:
        themeMode = ThemeMode.dark;
        break;
      case false:
        themeMode = ThemeMode.light;
        break;
    }
    return themeMode;
  }
}