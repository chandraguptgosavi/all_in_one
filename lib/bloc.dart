

import 'dart:async';
import 'dart:convert';
import 'package:all_in_one_sample/values.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Bloc {

  final _listController = StreamController<List>();
  Stream<List> get listStream => _listController.stream;
  
  final _favoritesController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get favoritesStream => _favoritesController.stream;
  final List<String> favorites = [];

  Bloc._(){
    _updateList();
  }

  factory Bloc.init(){
   return Bloc._();
  }

  void initFavorites(){
    _favoritesController.add(favorites);
  }

  void updateFavorites(String favorite){
    favorites.contains(favorite) ? favorites.remove(favorite) : favorites.add(favorite);
    _favoritesController.add(favorites);
  }

  Future<void> _updateList() async {
    List list;
    // Runs in another Isolate
    list = await compute(_getData, Strings.url);
    _listController.add(list);
  }

  void dispose(){
    _listController.close();
    _favoritesController.close();
  }
}

// Background work
  Future<List> _getData(String url) async {
    final response = await get(url);
    return json.decode(response.body);
  }