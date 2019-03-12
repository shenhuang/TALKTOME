import 'package:flutter/material.dart';

import '../components/choose-language.dart';
import '../components/translate-text.dart';
import '../components/list-translate.dart';
import '../components/translate-input.dart';
import '../models/language.dart';

import 'package:http/http.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isTextTouched = false;
  Language _firstLanguage = Language('en', 'English', true, true, true);
  Language _secondLanguage = Language('fr', 'French', true, true, true);
  FocusNode _textFocusNode = FocusNode();
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(() {
        this.setState(() {});
      });
  }

  @override
  void dispose() {
    this._controller.dispose();
    this._textFocusNode.dispose();
    super.dispose();
  }

  _onLanguageChanged(Language firstCode, Language secondCode) {
    this.setState(() {
      this._firstLanguage = firstCode;
      this._secondLanguage = secondCode;
    });
  }

  // Generate animations to enter the text to translate
  _onTextTouched(bool isTouched) {
    Tween _tween = SizeTween(
      begin: Size(0.0, kToolbarHeight),
      end: Size(0.0, 0.0),
    );

    this._animation = _tween.animate(this._controller);

    if (isTouched) {
      FocusScope.of(context).requestFocus(this._textFocusNode);
      this._controller.forward();
    } else {
      FocusScope.of(context).requestFocus(new FocusNode());
      this._controller.reverse();
    }

    this.setState(() {
      this._isTextTouched = isTouched;
    });
  }

  Widget _displaySuggestions() {
    if (this._isTextTouched) {
      return Container(
        color: Colors.black.withOpacity(0.4),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(this._isTextTouched
            ? this._animation.value.height
            : kToolbarHeight),
        child: AppBar(
          title: Text(widget.title),
          elevation: 0.0,
        ),
      ),
      body:
      new Column(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () { Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SecondScreen()),
            );},
            child: const Text('Chat Room'),
          ),
          ChooseLanguage(
            onLanguageChanged: this._onLanguageChanged,
          ),
          Stack(
            children: <Widget>[
              Offstage(
                offstage: this._isTextTouched,
                child: TranslateText(
                  onTextTouched: this._onTextTouched,
                ),
              ),
              Offstage(
                offstage: !this._isTextTouched,
                child: TranslateInput(
                  onCloseClicked: this._onTextTouched,
                  focusNode: this._textFocusNode,
                  firstLanguage: this._firstLanguage,
                  secondLanguage: this._secondLanguage,
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  child: ListTranslate(),
                ),
                this._displaySuggestions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SecondScreenState();
  }
}

class SecondScreenState extends State<SecondScreen> {
  String serverResponse = '';
  String userName = '';
  String chatMessage = '';
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome to Chat Room"),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Expanded(
            child: new Container (
              padding: new EdgeInsets.all(8.0),
              color: new Color(0XFFD6E5FF),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(serverResponse),
                ],
              ),
            ),
          ),
          new Container(
            child: new Row(
              children: [
                Container(
                  width: 70.0,
                  child: new TextField(
                    onChanged:  (text) {
                      userName = text;
                    },
                    decoration: new InputDecoration(
                      filled: true, 
                      fillColor: Colors.grey[300], 
                      hintText: 'Name'),
                    autofocus: true,
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Flexible(
                  child: new TextField(
                    onChanged:  (text) {
                      chatMessage = text;
                    },
                    decoration: new InputDecoration(
                      filled: true, 
                      fillColor: Colors.grey[300], 
                      hintText: 'Enter chat here...'),
                    autofocus: true,
                  ),
                ),
                Container(
                  width: 90.0,
                  child: SimpleDialogOption(
                    onPressed: () {
                      _makeGetRequest();
                    },
                    child: const Text('Send'),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            )
          ),
          bottomBanner,
        ],
      )
    );
  }
  _makeGetRequest() async {
    var url = 'http://localhost:3000';
    post(url, body: userName + ": " + chatMessage)
      .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
          setState(() {
            serverResponse = response.body;
          });
    });
  }
}

Widget bottomBanner = new Container (
  padding: new EdgeInsets.all(8.0),
  color: new Color(0X33000000),
  child: new Text(''),
);