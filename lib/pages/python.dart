import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Python extends StatefulWidget {
  final props;

  Python(this.props);

  @override
  _PythonState createState() => _PythonState();
}

class _PythonState extends State<Python> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMenu();
    _getCurrent();
  }

  Map menu = {};
  String content = '';
  String current = './';
  String prev = '';
  String next = '';
  String title = '';

  _getMenu() async {
    Response response =
    await Dio().get("https://www.readwithu.com/search_index.json");
    if (mounted) {
      setState(() {
        menu = response.data['store'];
      });
    }
  }

  _saveCurrent(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('${widget.props['book']['id']}', val);
  }

  _getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString('${widget.props['book']['id']}');
    if (key != null) {
      setState(() {
        current = key;
        _getContent();
      });
    } else {
      setState(() {
        current = './';
        _getContent();
      });
    }
  }

  _getContent() async {
    setState(() {
      content = '';
    });
    Response response =
    await Dio().get("https://www.readwithu.com/$current");
    if (mounted) {
      setState(() {
        content = response.data;
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
          : ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Html(
            data: '$content'
                .substring(content.indexOf('<section'), content.indexOf('</section>')).replaceAll('src="../', 'src="https://waylau.gitbooks.io/Python-tutorial/content/'),
            defaultTextStyle: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
      drawer: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        width: width * 2 / 3,
        decoration: BoxDecoration(color: Colors.white),
        child: menu.isEmpty
            ? Center(
          child: CupertinoActivityIndicator(),
        )
            : ListView(
          children: menu.keys.map<Widget>((key) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  current = key;
                  title = menu[key]['title'];
                  _getContent();
                  _saveCurrent(key);
                });
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(color: key == current ? Colors.blue : Colors.white),
                padding: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: '$key'.contains('/') && '$key'.contains('.html') ? 15 : 0),
                child: Text(
                  '${menu[key]['title']}',
                  style: TextStyle(color: key == current ? Colors.white : Colors.blue),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
