import 'package:all_in_one_sample/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:all_in_one_sample/bloc.dart';
import 'package:all_in_one_sample/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_in_one_sample/favorites.dart';

const String DARK_THEME = 'dark_theme';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SharedPreferences pref;
  Bloc bloc;

  _getPref() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _getPref();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<Bloc>(context, listen: false);
    final appTheme = Provider.of<AppTheme>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.app_name),
      ),
      body: Center(
        child: StreamBuilder<List>(
          stream: bloc.listStream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text('Email: ${snapshot.data[index]['email']}'),
                    subtitle:
                    Text('Description: ${snapshot.data[index]['body']}'),
                    trailing: StreamBuilder<List<String>>(
                      stream: bloc.favoritesStream,
                      builder: (_, favoritesSnapshot){
                        if(favoritesSnapshot.connectionState == ConnectionState.waiting){
                          bloc.initFavorites();
                        }
                        if(favoritesSnapshot.hasData){
                          final List<String> favorites = favoritesSnapshot.data;
                          return IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: favorites.contains(snapshot.data[index]['email'])
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              bloc.updateFavorites(snapshot.data[index]['email']);
                            },
                          );
                        }
                        return Container(width: 0);
                      },
                    ),
                  );
                });
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: FlutterLogo(
                size: 150,
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.theme,
                    style: TextStyle(fontSize: 18),
                  ),
                  ListTile(
                    title: Text(Strings.light),
                    trailing: Switch(
                      value: _getSwitchValue(appTheme, Strings.light),
                      onChanged: (bool value) async {
                        appTheme.isDark = false;
                        if (appTheme.isDark == false) {
                          await pref.setBool(DARK_THEME, false);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(Strings.dark),
                    trailing: Switch(
                      value: _getSwitchValue(appTheme, Strings.dark),
                      onChanged: (bool value) async {
                        appTheme.isDark = true;
                        if (appTheme.isDark == true) {
                          await pref.setBool(DARK_THEME, true);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(Strings.system),
                    trailing: Switch(
                      value: _getSwitchValue(appTheme, Strings.system),
                      onChanged: (bool value) async {
                        appTheme.isDark = null;
                        if (appTheme.isDark == null) {
                          await pref.setBool(DARK_THEME, null);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _getButton(context, bloc),
    );
  }

  FloatingActionButton _getButton(BuildContext context, Bloc bloc) {
    return FloatingActionButton(
      tooltip: Strings.favorites_page,
      child: const Icon(Icons.bookmark),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return EmailPage(
              emails: bloc.favorites,
            );
          },
        ),
      ),
    );
  }

  _getSwitchValue(AppTheme appTheme, String val) {
    switch(val){
      case Strings.light:
        if(appTheme.isDark == null){
          return false;
        }
        return !appTheme.isDark;
      case Strings.dark:
        if(appTheme.isDark == null){
          return false;
        }
        return appTheme.isDark;
      case Strings.system:
        if(appTheme.isDark == null){
          return true;
        }
        return false;
    }
  }

  @override
  void dispose() {
    if(bloc != null){
      bloc.dispose();
    }
    super.dispose();
  }
}