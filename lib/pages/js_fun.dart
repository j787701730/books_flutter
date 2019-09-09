import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JSFun extends StatefulWidget {
  final props;

  JSFun(this.props);

  @override
  _JSFunState createState() => _JSFunState();
}

class _JSFunState extends State<JSFun> {
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
    Response response = await Dio().get("https://llh911001.gitbooks.io/mostly-adequate-guide-chinese/content/search_index.json");
    if (mounted) {
      setState(() {
        menu = response.data['store'];
      });
    }
  }

  _saveCurrent(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('3', val);
  }

  _getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = prefs.getString('3');
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
    Response response = await Dio().get("https://llh911001.gitbooks.io/mostly-adequate-guide-chinese/content/$current");
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
                      .substring(content.indexOf('<section'), content.indexOf('</section>')).replaceAll('src="', 'src="https://llh911001.gitbooks.io/mostly-adequate-guide-chinese/content/'),
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
                        current = '$key';
                        title = menu[key]['title'];
                        _getContent();
                        _saveCurrent('$key');
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
