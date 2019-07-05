import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cloud_space/detailPage.dart';

class MyUploadsPage extends StatefulWidget {
  @override
  _MyUploadsPageState createState() => _MyUploadsPageState();
}

class _MyUploadsPageState extends State<MyUploadsPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("images")
              .onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                map.forEach((dynamic, v) => print(v["link"]));
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (2*itemWidth / itemHeight),
                      crossAxisSpacing: 4,
                      crossAxisCount: 2),
                  itemCount: map.values.toList().length,
                  padding: EdgeInsets.all(6.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GridTile(
                        child: InkResponse(
                          onTap: (){
                            Navigator.push(context, CupertinoPageRoute(
                            builder: (context) => DetailPage(url : map.values.toList()[index]["link"].toString())
                          ));
                          },
                          child: SizedBox.expand(
                              child: Image.network(
                                map.values.toList()[index]["link"],
                                fit: BoxFit.fill,
                              ),
                            ),

                        ),
                    ) ;
                    },
                );
              } else {
                return Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("No uploads found!",style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                    ),)
                  ],
                  ),
                );
              }
            }
            ),
        ),
      ),
    );
  }

}

