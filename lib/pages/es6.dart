import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ES6 extends StatefulWidget {
  final props;

  ES6(this.props);

  @override
  _ES6State createState() => _ES6State();
}

class _ES6State extends State<ES6> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMenu();
    _getCurrent();
  }

  String menu = '';
  String content = '';
  String current = 'README.md';
  String prev = '';
  String next = '';
  String title = '';

  _getMenu() async {
    Response response = await Dio().get("http://es6.ruanyifeng.com/sidebar.md");
    if (mounted) {
      setState(() {
        menu = response.data;
      });
    }
  }

  _getContent() async {
    setState(() {
      content = '';
    });
    Response response = await Dio().get("http://es6.ruanyifeng.com/$current");
    if (mounted) {
      setState(() {
        content = response.data;
      });
    }
  }

  _saveCurrent(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('2', val);
  }

  _getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString('2');
    if (key != null) {
      setState(() {
        current = key;
        _getContent();
      });
    } else {
      print('111');
      setState(() {
        current = 'README.md';
        _getContent();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(title == '' ? widget.props['book']['name'] : title),
      ),
      body: content.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Markdown(
              data: '$content',
            ),
      drawer: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        width: width * 2 / 3,
        decoration: BoxDecoration(color: Colors.white),
        child: menu.isEmpty
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : Markdown(
                data: '$menu',
                onTapLink: (href) {
                  setState(() {
                    current = '$href'.replaceAll('#', '') + '.md';
                    _getContent();
                    _saveCurrent('$href'.replaceAll('#', '') + '.md');
                    Navigator.pop(context);
                  });
                },
              ),
      ),
    );
  }
}
