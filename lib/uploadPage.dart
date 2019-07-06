import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}
class _UploadPageState extends State<UploadPage> {

  File file;
  String path;
  bool showProgressBar = false;
  var downloadUrl;
  final databaseRef = FirebaseDatabase.instance.reference().child("images");

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
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: Container(
                child: Column(
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

                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: !checkFile(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height -400,
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
                              uploadToFirebaseStorage(path);
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
            Positioned(
              top: 200,
              left: 5,
              right: 5,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Visibility(
                      visible: showProgressBar,
                      child:  SpinKitFadingFour(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
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
                        openSource("camera");
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
                        openSource("gallery");
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

  void openSource(String source) async{
      try{
        setState(() {
          showProgressBar = true;
        });
        var _file,_path;
        if(source == "gallery") {
          _file = await ImagePicker.pickImage(source: ImageSource.gallery);
          _path = _file.path;
        }else if(source == "camera"){
          _file = await ImagePicker.pickImage(source: ImageSource.camera);
          _path = _file.path;
        }
        setState(() {
          file = _file;
          path = _path;
          showProgressBar = false;
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

  Future<void> uploadToFirebaseStorage(filePath) async{

    setState(() {
      showProgressBar = true;
      path = path.split('/').last;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref().child(path);
    StorageUploadTask uploadTask =  storageReference.putFile(file);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    String uploadTime;
    setState(() {
      downloadUrl = url.toString();
      showProgressBar = false;
      file = null;
      uploadTime = DateTime.now().toString();
    });
    databaseRef.push().set(
        {
              "uploadTime": uploadTime,
              "link": downloadUrl,
        }
    );
    setState(() {
      path = null;

    });

  }
}
