import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraDisplaymodel extends ChangeNotifier {
  String? title;
  bool isLoading = false;

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future cameraDisplay(String imgPath) async {
    if (title == null || title == "") {
      throw 'タイトルが入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('albums').doc();

    final task = await FirebaseStorage.instance
        .ref('albums/${doc.id}')
        .putFile(File(imgPath));
    final imgURL = await task.ref.getDownloadURL();

    // firestoreに追加
    await doc.set({
      'title': title,
      'imgURL': imgURL,
    });
  }
}
