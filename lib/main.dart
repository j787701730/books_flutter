import 'package:books_flutter/pages/book1.dart';
import 'package:books_flutter/pages/css3.dart';
import 'package:books_flutter/pages/es6.dart';
import 'package:books_flutter/pages/js_fun.dart';
import 'package:books_flutter/pages/python.dart';
import 'package:flutter/material.dart';

import 'books.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text('版权归作者所有。本人只是调用接口。'),
            ),
          ),
          Wrap(
            children: books.map<Widget>((book) {
              return Container(
                width: (width - 20) / 4,
                child: GestureDetector(
                  onTap: () {
                    switch (book['id']) {
                      case '1':
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new Book1({'book': book})),
                        );
                        break;
                      case '2':
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new ES6({'book': book})),
                        );
                        break;
                      case '3':
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new JSFun({'book': book})),
                        );
                        break;
                      case '4':
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new Css3({'book': book})),
                        );
                        break;
                      case '5':
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new Python({'book': book})),
                        );
                        break;
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: (width - 20) / 4,
                        height: (width - 20) / 4 * 1.2,
                        child: book['image'] == ''
                            ? Image.asset('images/Books.webp')
                            : Image.network(
                                book['image'],
                                fit: BoxFit.fill,
                              ),
                      ),
                      Container(
                        height: 44,
                        child: Text(
                          book['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
