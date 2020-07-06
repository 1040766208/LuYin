import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'util.dart';
import 'package:http/http.dart' as http;
class Player extends StatelessWidget {
  Player({Key key, this.detail}) : super(key: key);

  final Map detail;

  @override
  Widget build(BuildContext context) {
    return MyPlayerPage(detail: detail);
  }
}

class MyPlayerPage extends StatefulWidget {
  MyPlayerPage({Key key, this.detail}) : super(key: key);

  final Map detail;

  @override
  _MyPlayerPageState createState() => _MyPlayerPageState();
}

class _MyPlayerPageState extends State<MyPlayerPage> {
  // 音乐资源地址
  String _musicResourcesUrl;

  // 音乐图片地址
  String _musicPicUrl;

  // 播放状态
  bool _state = false;

  AudioPlayer audioPlayer = new AudioPlayer();

  @override
  void initState() {
    super.initState();

    _getMusic();

    // 监听播放进度
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('当前播放进度 $p');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Row(
            children: <Widget>[Icon(Icons.arrow_back_ios), Text('Back')],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(widget.detail['songname'].toString()),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.more_horiz),
          onPressed: () {
            _showDialog(context);
          },
        ),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(200.0),
                  boxShadow: const [
                    BoxShadow(blurRadius: 50.0, color: Colors.black26),
                  ],
                ),
                child: ClipOval(
                  child: null == _musicPicUrl && null == _musicResourcesUrl
                      ? Center(
                          child: CupertinoActivityIndicator(radius: 10.0),
                        )
                      : FadeInImage(
                          placeholder: AssetImage(
                            'assets/images/${widget.detail['songname']}.jpg',
                          ),
                          image: NetworkImage(_musicPicUrl),
                        ),
                ),
              ),
            ),
            Center(
              child: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  _state
                      ? CupertinoIcons.pause_solid
                      : CupertinoIcons.play_arrow_solid,
                  size: 70.0,
                ),
                onPressed: _play,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _init() async {
    print(_musicResourcesUrl);
    int result = await audioPlayer.play(_musicResourcesUrl);
    if (result == 1) {
      setState(() {
        _state = true;
      });
    } else {
      //_showBackAlertDialog(context);
    }
  }

  void _play() async {
    setState(() {
      _state = !_state;
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('当前播放状态: $s');
    });

    if (_state) {
      await audioPlayer.resume();
    } else {
      await audioPlayer.pause();
    }
  }

  Future<Null> _getMusic() async {
    if (!mounted) return;
    try {
      // 获取歌曲图片
      var urlImage = 'https://y.gtimg.cn/music/photo_new/T002R300x300M000'+widget.detail['albummid']+'.jpg';
      await http.get(urlImage
      ).then((response) {
        if (response.statusCode.toString() == '200') {
          setState(() {
            _musicPicUrl = urlImage;
            //print(_musicPicUrl);
          });
        } else {
          throw Exception('接口异常');
        }
      });
      // 获取歌曲资源
      var urlPlay = 'http://47.106.68.121:3300/song/urls?id='+widget.detail['songmid'];
      await http.post(
        urlPlay
      ).then((response) {
        if (response.statusCode.toString() == '200') {
          setState(() {
            var data = jsonDecode(response.body);
            //print(urlPlay);
            //print(widget.detail['songmid']);
            //print(data['data'][widget.detail['songmid']]);
            //print(jsonDecode(response.data)[widget.detail['songid']]);
            _musicResourcesUrl = data['data'][widget.detail['songmid']].replaceAll('http://122.226.161.16','https://ws.stream.qqmusic.qq.com/');
            //_musicResourcesUrl= 'https://ws.stream.qqmusic.qq.com/amobile.music.tc.qq.com/M5000039MnYb0qxYhV.mp3?guid=3943563&vkey=7BFC4FDBAD165EFB9A0AB7BBC76DD081638F5DDF45FFE889DF8CB8327DB4C502A274F8F581EB6E541DE1BD524AB886FA841F5DFB3A94A706&uin=1899&fromtag=66';
            print(_musicResourcesUrl);
          });
          _init();
        } else {
          throw Exception('接口异常');
        }
      });
    } catch (e) {
      //_showBackAlertDialog(context);
    }
  }

  _showBackAlertDialog(BuildContext context) async {
    final result = await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('资源获取失败！'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('好的'),
              onPressed: () {
                Navigator.pop(context, 'back');
              },
            ),
          ],
        );
      },
    );
    if (result != null && result == 'back') {
      Navigator.pop(context);
    }
  }

  _showMsgAlertDialog(BuildContext context, {String msg}) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('好的'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) async {
    await showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("More"),
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('复制歌曲ID'),
              onPressed: () {
                Util.copyToClipboard(widget.detail['songid'].toString());
                Navigator.pop(context);
                _showMsgAlertDialog(context, msg: '复制成功');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('复制歌曲名称'),
              onPressed: () {
                Util.copyToClipboard(widget.detail['songname'].toString());
                Navigator.pop(context);
                _showMsgAlertDialog(context, msg: '复制成功');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('复制歌手名称'),
              onPressed: () {
                Util.copyToClipboard(widget.detail['singer'][0]['name'].toString());
                Navigator.pop(context);
                _showMsgAlertDialog(context, msg: '复制成功');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('复制歌曲链接'),
              onPressed: () {
                Util.copyToClipboard(_musicResourcesUrl.toString());
                Navigator.pop(context);
                _showMsgAlertDialog(context, msg: '复制成功');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // 释放播放器
    audioPlayer.release();
    super.dispose();
  }
}
