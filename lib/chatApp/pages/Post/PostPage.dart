import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:niqaash/chatApp/models/helper/UIHelper.dart';
import 'package:niqaash/main.dart';

import '../../../constants/constants.dart';
import '../../models/UserModel.dart';

class PostPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const PostPage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? postImg;
  TextEditingController postDescController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
      print("image picked");
      // File? file = File(pickedFile.path);
      // setState(() {
      //   imageFile = file;
      // });
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        print("image cropped");

        postImg = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Post Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                ),
              ],
            ),
          );
        });
  }

  void uploadPost() async {
    String postDesc = postDescController.text.trim();

    postDescController.clear();
    var docsID = uuid.v1();
    if (postDesc != "" && postImg != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("postImg")
          .child(docsID)
          .putFile(postImg!);

      StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((snapshot) {
        double percentage =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
        log(percentage.toString());
        if (percentage >= 100) {
          log(percentage.toString());
          Navigator.pop(context);//////////
        } else {
          log(percentage.toString());
          UIHelper.showLoadingDialog(context, percentage.toString());
        }
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      taskSubscription.cancel();
      var postTime = DateTime.now();
      Map<String, dynamic> postData = {
        "postDesc": postDesc,
        "postImg": downloadUrl,
        "postTime": postTime,
        // "postId": docsID
      };
      // String docID = "";
      FirebaseFirestore.instance.collection("posts").add(postData);
      // .then((DocumentReference doc) => docID = doc.id);
      // FirebaseFirestore.instance
      //     .collection("post")
      //     .doc(docID)
      //     .
      //     .then((DocumentReference doc) => print(doc.id));
      log("Post created!");
    } else {
      UIHelper.showAlertDialog(
          context, "Please fill all the fields!", "Invalid");
      log("Please fill all the fields!");
    }

    setState(() {
      postImg = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Create Post',
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const [
            //     SizedBox(
            //       width: 20,
            //       height: 30,
            //     ),
            //     Center(
            //       child: Text(
            //         'Create Post',
            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //     // const Spacer(),
            //     // ElevatedButton(
            //     //   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            //     //   onPressed: () {},
            //     //   child: const Text('Post'),
            //     // )
            //   ],
            // ),
            // const Divider(
            //   thickness: 1,
            // ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  Image.network(widget.userModel.profilepic ?? Img.niqaashLogo),
              title: Text(widget.userModel.fullname.toString()),
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 5,
              controller: postDescController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write Something....',
                hintStyle: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () async {
                showPhotoOptions();

                // XFile? selectedImage =
                //     await ImagePicker().pickImage(source: ImageSource.gallery);

                // if (selectedImage != null) {
                //   File convertedFile = File(selectedImage.path);
                //   setState(() {
                //     postImg = convertedFile;
                //   });
                //   log("Image selected!");
                // } else {
                //   log("No image selected!");
                // }
              },
              padding: EdgeInsets.zero,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey[200],
                  child: (postImg != null)
                      ? Image.file(
                          postImg!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.add_a_photo),
                ),
              ),

              // CircleAvatar(
              //   radius: 40,
              //   backgroundImage: (postImg != null) ? FileImage(postImg!) : null,
              //   backgroundColor: Colors.grey,
              // ),
            ),
          ],
        ),
      ),
      floatingActionButton: CupertinoButton(
        color: Colors.black,
        onPressed: () {
          uploadPost();
        },
        child: const Text("Upload"),
      ),
    );
  }
}
