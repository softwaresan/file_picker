import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FilePick extends StatelessWidget {
  FilePickerResult? result;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Picker"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('myFiles')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('err ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Text('no Data');
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              snapshot.data!.docs[index].data()["name"],
                              style: TextStyle(
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 1,
                            color: Colors.grey,
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      ),
                    );
                  }
                }),
            Spacer(),
            ElevatedButton(
                onPressed: () async {
                  result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    file = File(result!.files.single.path!);
                  } else {
                    // User canceled the picker
                  }
                },
                child: Text("pick file")),
            ElevatedButton(
                onPressed: () async {
                  String name = result!.files.single.name;
                  final imageRef =
                      FirebaseStorage.instance.ref().child("myFiles/${name}");
                  await imageRef.putFile(file!);
                  imageRef.getDownloadURL().then((value) {
                    return FirebaseFirestore.instance
                        .collection("myFiles")
                        .add({"image": value, "name": name});
                  });
                },
                child: Text("upload file"))
          ],
        ),
      ),
    );
  }
}
