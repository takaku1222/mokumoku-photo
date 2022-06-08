import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colud_photo/Album/Album.dart';
import 'package:colud_photo/Album/AlbumModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('albums').snapshots();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumModel>(
      create: (_) => AlbumModel()..fetchAlbumModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('🌟アルバム🌟'),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Consumer<AlbumModel>(builder: (context, model, child) {
            final List<Album>? albums = model.albums;

            if (albums == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = albums
                .map(
                  (album) => GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(7.0,7.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if(album.imgURL != null)
                            Container(
                              child: Image.network(album.imgURL!),
                              height: 222,
                            ),
                          Text(album.title),
                          Container(
                            margin: EdgeInsets.all(16.0),
                          )
                        ],
                      ),
                    ),
                    if (album.isDeleteMode)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('消去しますか？'),
                                    content: Text("『${album.title}』を消去しますか？"),
                                    actions: [
                                      TextButton(
                                        child: Text("いいえ"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: Text("はい"),
                                        onPressed: () async {
                                          // modelで消去
                                          await model.delete(album);
                                          Navigator.pop(context);
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text('${album.title}を消去しました'),
                                          );
                                          model.fetchAlbumModel();
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                onLongPress: () {
                  print('a');
                  model.toggleDeleteMode(album.id);
                },
              ),
            ).toList();

            return GridView.count(
              padding: EdgeInsets.all(4.0),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.68,
              children: widgets,
            );
          }),
        ),
      ),
    );
  }
}
