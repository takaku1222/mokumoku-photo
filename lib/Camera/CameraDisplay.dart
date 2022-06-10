import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colud_photo/Camera/CameraDisplayModel.dart';
import 'package:colud_photo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CameraDisplay extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  final String imgPath;

  CameraDisplay({Key? key, required this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CameraDisplaymodel>(
      create: (_) => CameraDisplaymodel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('🌧追加🌧'),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Consumer<CameraDisplaymodel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: SizedBox(
                              width: 480,
                              height: 520,
                              child: imgPath != null
                                  ? Image.file(File(imgPath))
                                  : Container(
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(hintText: '名前をつける'),
                            // 文字の数の制限
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (text) {
                              model.title = text;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // 追加の処理
                              try {
                                model.startLoading();
                                await model.cameraDisplay(imgPath);
                                final snackBar = const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: const Text('💫写真を追加しました💫'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePageState(),
                                    ));
                              } catch (e) {
                                print(e);
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } finally {
                                model.endLoading();
                              }
                            },
                            child: Text('追加する'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
