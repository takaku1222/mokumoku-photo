import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colud_photo/Album/Album.dart';
import 'package:flutter/material.dart';

class AlbumModel extends ChangeNotifier {
  List<Album>? albums;

  void fetchAlbumModel() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('albums').get();

    final List<Album> albums = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String? imgURL = data['imgURL'];

      return Album(title, imgURL, id);
    }).toList();

    this.albums = albums;
    notifyListeners();
  }

  void toggleDeleteMode(String id) {
    final album = albums!.firstWhere((album) => album.id == id);
    album.isDeleteMode = !album.isDeleteMode;
    notifyListeners();
  }

  Future<void> delete(Album album) async {
    await FirebaseFirestore.instance
        .collection('albums')
        .doc(album.id)
        .delete();
  }
}
