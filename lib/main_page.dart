import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'items.dart';
import 'cupertino_swipe_back_observer.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '鹿音',
      home: MyHomePage(title: '鹿音'),
      navigatorObservers: <NavigatorObserver>[
        CupertinoSwipeBackObserver(),
      ],
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
  String _type = 'netease';

  TextEditingController _textController = TextEditingController();

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    //关于函数
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("鹿音"),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: const Text('关于'),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('本软件'),
                  content: const Text('作者邮箱：1040766208@qq.com\n\nBy:519寝室团体'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: const Text('知道了'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      child: Container(
        child: Column( //按钮
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: _type == 'netease' ? 80.0 : 60.0,
                    height: _type == 'netease' ? 80.0 : 60.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: GestureDetector(
                      child: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundImage:
                        AssetImage('assets/images/netease.jpg'),
                      ),
                      onTap: () {
                        setState(() {
                          _type = 'netease';
                        });
                      },
                    ),
                  ),
                  Container(
                    width: _type == 'tencent' ? 80.0 : 60.0,
                    height: _type == 'tencent' ? 80.0 : 60.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: GestureDetector(
                      child: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundImage:
                        AssetImage('assets/images/tencent.jpg'),
                      ),
                      onTap: () {
                        setState(() {
                          _type = 'tencent';
                        });
                      },
                    ),
                  ),
                  Container(
                    width: _type == 'xiami' ? 80.0 : 60.0,
                    height: _type == 'xiami' ? 80.0 : 60.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: GestureDetector(
                      child: CircleAvatar(
                        foregroundColor: Colors.pink,
                        backgroundImage: AssetImage('assets/images/xiami.jpg'),
                      ),
                      onTap: () {
                        setState(() {
                          _type = 'xiami';
                        });
                      },
                    ),
                  ),
                  Container(
                    width: _type == 'kugou' ? 80.0 : 60.0,
                    height: _type == 'kugou' ? 80.0 : 60.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: GestureDetector(
                      child: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundImage: AssetImage('assets/images/kugou.jpg'),
                      ),
                      onTap: () {
                        setState(() {
                          _type = 'kugou';
                        });
                      },
                    ),
                  ),
                  Container(
                    width: _type == 'baidu' ? 80.0 : 60.0,
                    height: _type == 'baidu' ? 80.0 : 60.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: GestureDetector(
                      child: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundImage: AssetImage('assets/images/baidu.jpg'),
                      ),
                      onTap: () {
                        setState(() {
                          _type = 'baidu';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 0),
                child: CupertinoTextField(
                  cursorColor: Colors.blue,
                  controller: _textController,
                  placeholder: '输入歌曲或歌手名称搜索\\（￣︶￣）/',
                  keyboardType: TextInputType.text,
                  padding: EdgeInsets.all(20.0),
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: const [
                      BoxShadow(blurRadius: 20.0, color: Colors.black26),
                    ],
                  ),
                  onEditingComplete: () {
                    if (_textController.text != '' &&
                        _textController.text != null) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              Items(
                                type: _type,
                                keyword: _textController.text,
                              ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}