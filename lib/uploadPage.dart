import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  File file;
  String path;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: Visibility(
          visible: !checkFile(),
          child: FloatingActionButton(
            child: Icon(Icons.flip_to_back,color: Colors.white,),
            elevation: 6,
            onPressed: (){
              setState(() {
                file = null;
              });
            },
            backgroundColor: Colors.black,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: checkFile(),
                  child: IconButton(
                      icon: Icon(Icons.photo),
                      iconSize: 60,
                      splashColor: Colors.white54,
                      onPressed: (){
                        openBottomSheet();
                      },
                    ),
                ),
                Visibility(
                  visible: checkFile(),
                  child: Text("Upload",style: TextStyle(
                    color: Colors.white30,
                    fontSize: 16,
                    letterSpacing: 1
                  ),
                  ),
                ),
                Visibility(
                  visible: !checkFile(),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: checkFile()?null:Image.file(file),
                  ),
                ),
                Visibility(
                    visible: !checkFile(),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                    ),
                ),
                Visibility(
                visible: !checkFile(),
                child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.black,
                      onPressed: (){

                      },
                      child: Text("Upload",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),),
                    )
                ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void openBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
            height: 115,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Camera"),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.white,
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_android),
                      title: Text("Gallery"),
                      onTap: (){
                        openExplorer();
                        Navigator.pop(context);
                      },
                    )
                  ],
                )

            ),
          );
        }
    );
  }

  void openExplorer() async{
      try{
        var _file = await ImagePicker.pickImage(source: ImageSource.gallery);
        var _path = _file.path;
        setState(() {
          file = _file;
          path = _path;
        });
      }catch(e){
        print(e.toString());
      }
  }

  bool checkFile(){
    if(file == null)
      return true;
    else
      return false;
  }

}
