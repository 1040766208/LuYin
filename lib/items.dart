import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'util.dart';
import 'player.dart';

class Items extends StatelessWidget {
  Items({Key key, this.type, this.keyword}) : super(key: key);

  final String type;
  final String keyword;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ItemsPage(
        type: type,
        keyword: keyword,
      ),
    );
  }
}

class ItemsPage extends StatefulWidget {
  ItemsPage({Key key, this.type, this.keyword}) : super(key: key);

  final String type;
  final String keyword;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List _list = List();

  // 页码
  int _page = 1;

  // 每页显示数量
  int _limit = 20;

  // 是否正在请求
  bool _request = false;

  // 是否为最后一页
  bool _isLastPage = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _getList(widget.type, widget.keyword);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getList(widget.type, widget.keyword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("列表"),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: .0),
        controller: _scrollController,
        itemCount: _list == null ? 1 : _list.length + 1,
        itemBuilder: _render,
      ),
    );
  }

  Widget _getMoreWidget() {
    if (_isLastPage) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          "没有更多了",
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: CupertinoActivityIndicator(
          radius: 10.0,
        ),
      );
    }
  }
  Widget __info(){
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          "没有更多了",
          style: TextStyle(color: Colors.grey),
        ),
      );
  }
  // 渲染列表数据
  Widget _render(BuildContext context, int index) {
    if (index < _list.length) {
      if(_list[index]['albumname']==''){
        _list[index]['albumname']="暂无名字";
      }
      return ListTile(
        title: Text(
          "${_list[index]['songname']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: //Text('${_list[index]['singer']['name']}'),
        Text('${_list[index]['singer'][0]['name']}'),
        onTap: () async {
          //await Util.openPage(context, Player(detail: _list[index]));
          await Util.openPage(context, Player(detail: _list[index]));
        },
      );
    }

    return _getMoreWidget();
  }

  Future<Null> _getList(String type, String keyword) async {
    if (!this.mounted) return;
    if (false == _request && false == _isLastPage || _list.length == 0) {
      setState(() {
        _request = true;
        _isLastPage = false;
      });
    }
//    try {
    var url = "http://47.106.68.121:3300/search?key="+keyword+"&pageNo=" + _page.toString();
    await http.get(
        url
      ).then((response) {
        if (response.statusCode == 200) {//链接头部为304
          var data =json.decode(response.body);
          var list = data['data']['list'];
          if(list[8]['albumname']==''){
            print('yes');
          }
          if (list.length > 0) {
            setState(() {
              if (_page == 1 && list.length < _limit) {
                _isLastPage = true;
              }
              _list.addAll(list);
              _page++;
            });
          } else {
            setState(() {
              _isLastPage = true;
            });
          }
        }
      });
//    } catch (e) { //错误溢出
//      await showCupertinoDialog(
//        context: context,
//        builder: (context) {
//          return CupertinoAlertDialog(
//            title: Text('发生错误'),
//            content: Text('资源获取失败'),
//            actions: <Widget>[
//              CupertinoDialogAction(
//                child: const Text('好的'),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//            ],
//          );
//        },
//      );
//    }
  }
}
