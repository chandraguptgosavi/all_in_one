import 'package:all_in_one_sample/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  final List emails;

  EmailPage({Key key, @required this.emails}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.favorites_page),
      ),
      body: ListView.builder(
        itemCount: widget.emails.length,
        itemBuilder: (_, index) => ListTile(title: Text(widget.emails[index])),
      ),
    );
  }
}
