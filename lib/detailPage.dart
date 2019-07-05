import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  final String url;
  DetailPage({Key key, @required this.url}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    widget.url,
                    width: MediaQuery.of(context).size.width ,
                    height: MediaQuery.of(context).size.height -300 ,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: (){
                          downloadImage();
                        },
                        child: Text("Download",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),),
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void downloadImage() async{
    var response = await get(widget.url);
    var directory = await getApplicationDocumentsDirectory();
    File file = new File(
      join(directory.path,widget.url.split("/").last)
    );
    file.writeAsBytesSync(response.bodyBytes);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Image downloaded")));
  }
}

