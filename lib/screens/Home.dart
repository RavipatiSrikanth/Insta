import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/login.dart';
import 'package:insta/screens/upload_status.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseuser) {
      if (firebaseuser == null) {
        // user not logged in
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      } else {
        // user alredy logged in
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login())));
              }),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('statuses').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.data.docs.length == 0) {
              return Center(child: Text('No Data'));
            }

            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            snapshot.data.docs[index]['title'],
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            snapshot.data.docs[index]['desc'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          snapshot.data.docs[index]['imageURL'],
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UploadStatus()));
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
