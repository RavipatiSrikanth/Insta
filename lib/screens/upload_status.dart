import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/status_model.dart';

class UploadStatus extends StatefulWidget {
  @override
  _UploadStatusState createState() => _UploadStatusState();
}

class _UploadStatusState extends State<UploadStatus> {
  File _imageFile;
  bool isLoading = false;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _descEditController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Upload Status'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _imageFile == null
                    ? Text('No Image Choosen')
                    : Image.file(
                        _imageFile,
                        width: 150,
                      ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    iconSize: 50,
                    onPressed: () {
                      pickImage();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: _titleEditController,
                    decoration: InputDecoration(
                        hintText: 'Enter Title',
                        labelText: 'Title',
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: _descEditController,
                    decoration: InputDecoration(
                        hintText: 'Enter Description',
                        labelText: 'Description',
                        border: OutlineInputBorder()),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    uploadStatus();
                  },
                  child: Text('Upload Status'),
                  textColor: Colors.white,
                  color: Colors.blue,
                )
              ],
            ),
    );
  }

  Future pickImage() async {
    var file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(file.path);
    });
  }

  uploadStatus() async {
    setState(() {
      isLoading = true;
    });

    var imageUpload = await uploadImage();

    StatusModel statusModel = new StatusModel();

    statusModel.imageURL = imageUpload.toString();
    statusModel.title = _titleEditController.text;
    statusModel.desc = _descEditController.text;

    String docId = FirebaseFirestore.instance.collection("statuses").doc().id;

    statusModel.docid = docId;

    await FirebaseFirestore.instance
        .collection("statuses")
        .doc(statusModel.docid)
        .set(statusModel.toMap());

    Fluttertoast.showToast(msg: 'Status Uploaded');
    Navigator.pop(context);

    setState(() {
      isLoading = false;
    });
  }

  Future<dynamic> uploadImage() async {
    // setState(() {
    //   isLoading = true;
    // });
    var storageReference = FirebaseStorage.instance.ref().child('Statuses');

    var storageUploadTask = await storageReference
        .child("image_" + DateTime.now().toIso8601String())
        .putFile(_imageFile);

    var snapshot = storageUploadTask;

    var downloadURL = await snapshot.ref.getDownloadURL();

    // Fluttertoast.showToast(msg: 'Image Uploaded Successful');

    // setState(() {
    //   isLoading = false;
    // });
    print('downloadURL $downloadURL');
    return downloadURL;
  }
}
