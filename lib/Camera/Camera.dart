import 'package:camera/camera.dart';
import 'package:colud_photo/Camera/CameraDisplay.dart';
import 'package:colud_photo/main.dart';
import 'package:flutter/material.dart';

// 状態が変化するからStatefulWidget
class CameraPage extends StatefulWidget {
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  // デバイスのカメラを制御するコントローラ
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    // コントローラを初期化　　　　　　　　　　　　　　　// 解像度を指定
    _controller = CameraController(cameras![0], ResolutionPreset.max);
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたタイミングで、カメラのコントローラを破棄する
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('⛅️撮影🌤'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        width: 900,
        height: 900,
        // カメラの初期化が完了したら、プレビューを表示
        child: CameraPreview(_controller!),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // ボタンが押された際の処理
        onPressed: () async {
          print('ボタンを押した');
          // デバイスで使用可能なカメラのリストを取得
          final cameras = await availableCameras();
          // 利用可能なカメラの一覧から、指定のカメラを取得する
          final firstCamera = cameras.first;

          final cameraController =
              CameraController(firstCamera, ResolutionPreset.max);
          await cameraController.initialize();
          // 例外処理　想定内のエラーが起きたときに行う処理
          try {
            // カメラで画像を撮影する
            final file = await cameraController.takePicture();
            final filePath = file.path;

            print('撮影完了');
            // 画像を表示する画面に遷移 遷移先に値を渡している
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraDisplay(imgPath: filePath),
                ));
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
