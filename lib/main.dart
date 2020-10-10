import 'package:all_in_one_sample/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:all_in_one_sample/bloc.dart';
import 'package:all_in_one_sample/theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppTheme(),
        ),
        Provider(
          create: (_) => Bloc.init(),
        )
      ],
      child: MyApp(),
    ),
  );
}





