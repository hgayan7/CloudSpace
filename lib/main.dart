import 'package:flutter/material.dart';
import 'package:flutter_cloud_space/uploadPage.dart';
import 'package:flutter_cloud_space/myUploadsPage.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CloudSpace",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("CloudSpace"),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: <Widget>[
                Tab(text: "Upload",),
                Tab(text: "My Uploads",)
              ],
            ),

          ),
          body: TabBarView(
            children: <Widget>[
              UploadPage(),
              MyUploadsPage()
            ],
          ),
        ),
      ),
    );
  }
}
