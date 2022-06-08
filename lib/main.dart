import 'package:camera/camera.dart';
import 'package:colud_photo/Album/AlbumPage.dart';
import 'package:colud_photo/Camera/Camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//カメラリスト
List<CameraDescription>? cameras;

Future<void> main() async {
  // イニシャライズしてからアプリを表示する
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 利用可能なカメラの取得
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: MyHomePageState(),
    );
  }
}

class MyHomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            // タイトルを中央寄せ
            centerTitle: true,
            title: Text('🌤️もくもくフォト🌧',
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(),
            ),
            elevation: 0),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 580,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  color: Colors.grey[100],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 58),
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 210,
                      width: 260,
                      child: TextButton(
                          child: Center(
                            child: Text('写真を撮る'),
                          ),
                          // Within the `FirstRoute` widget
                          onPressed: () {
                            // カメラページに画面遷移
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage()),
                            );
                          }),
                    ),
                  ),
                  SizedBox(height: 70),
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 210,
                      width: 260,
                      child: TextButton(
                        child: Center(
                          child: Text('アルバム'),
                        ),
                        onPressed: () {
                          // アルバムページに画面遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
