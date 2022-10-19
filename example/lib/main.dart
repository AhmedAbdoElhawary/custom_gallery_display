import 'dart:io';

import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom gallery display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              normal1(context),
              normal2(context),
              normal3(context),
              instagram1(context),
              instagram2(context),
              instagram3(context),
              instagram4(context),
              camera1(context),
              camera2(context),
            ]),
      ),
    );
  }

  ElevatedButton normal1(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.normalDisplay(
                multiSelection: true,
                galleryDisplaySettings: GalleryDisplaySettings(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 1.7,
                      mainAxisSpacing: 1.5),
                  appTheme: AppTheme(
                      focusColor: Colors.black, primaryColor: Colors.white),
                ),
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Normal 1"),
    );
  }

  ElevatedButton normal2(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.normalDisplay(
                displaySource: DisplaySource.both,
                pickerSource: PickerSource.image,
                multiSelection: true,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Normal 2"),
    );
  }

  ElevatedButton normal3(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.normalDisplay(
                displaySource: DisplaySource.both,
                pickerSource: PickerSource.both,
                galleryDisplaySettings: GalleryDisplaySettings(
                    appTheme: AppTheme(
                        focusColor: Colors.black, primaryColor: Colors.white),
                    tabsTexts: _arabicTabsTexts(),
                    gridDelegate: _sliverGrid3Delegate()),
                multiSelection: true,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Normal 3"),
    );
  }

  ElevatedButton instagram1(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.instagramDisplay(
                displaySource: DisplaySource.gallery,
                pickerSource: PickerSource.image,
                multiSelection: true,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Preview 1"),
    );
  }

  ElevatedButton instagram2(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.instagramDisplay(
                displaySource: DisplaySource.both,
                pickerSource: PickerSource.image,
                multiSelection: true,
                cropImage: false,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Preview 2"),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _sliverGrid3Delegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 1.7,
      mainAxisSpacing: 1.5,
      childAspectRatio: .5,
    );
  }

  TabsTexts _arabicTabsTexts() {
    return TabsTexts(
      videoText: "فيديو",
      galleryText: "المعرض",
      deletingText: "حذف",
      noImagesFounded: "لم يتم العثور علي صور",
      acceptAllPermissions: "أقبل جميع الاذونات",
      holdButtonText: "استمر بالضغط علي الزر",
      photoText: "الصور",
      clearImagesText: "الغاء الصور المحدده",
      limitingText: "اقصي حد للصور هو 10",
    );
  }

  TabsTexts _chineseTabsTexts() {
    return TabsTexts(
      videoText: "視頻",
      photoText: "照片",
      galleryText: "畫廊",
      deletingText: "刪除",
      clearImagesText: "清除所選圖像",
      limitingText: "限制為 10 張照片或視頻",
    );
  }

  ElevatedButton instagram3(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.instagramDisplay(
                displaySource: DisplaySource.both,
                pickerSource: PickerSource.both,
                multiSelection: true,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Preview 3"),
    );
  }

  ElevatedButton instagram4(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.instagramDisplay(
                displaySource: DisplaySource.both,
                pickerSource: PickerSource.both,
                multiSelection: true,
                cropImage: false,
                galleryDisplaySettings: GalleryDisplaySettings(
                    appTheme: AppTheme(
                        primaryColor: Colors.black, focusColor: Colors.white),
                    tabsTexts: _chineseTabsTexts()),
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Preview 4"),
    );
  }

  ElevatedButton camera1(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.normalDisplay(
                displaySource: DisplaySource.camera,
                pickerSource: PickerSource.image,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("Camera 1"),
    );
  }

  ElevatedButton camera2(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).push(CupertinoDialogRoute(
            builder: (context) => CustomGalleryDisplay.normalDisplay(
                displaySource: DisplaySource.camera,
                pickerSource: PickerSource.both,
                multiSelection: true,
                onDone: (SelectedImagesDetails details) async {
                  displayDetails(details);
                }),
            context: context));
      },
      child: const Text("camera 2"),
    );
  }

  Future<void> displayDetails(SelectedImagesDetails details) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return DisplayImages(
              selectedBytes: details.selectedFiles,
              details: details,
              aspectRatio: details.aspectRatio);
        },
      ),
    );
  }
}

class DisplayImages extends StatefulWidget {
  final List<SelectedByte> selectedBytes;
  final double aspectRatio;
  final SelectedImagesDetails details;
  const DisplayImages({
    Key? key,
    required this.details,
    required this.selectedBytes,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selected images/videos')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          SelectedByte selectedByte = widget.selectedBytes[index];
          if (!selectedByte.isThatImage) {
            return _DisplayVideo(selectedByte: selectedByte);
          } else {
            return SizedBox(
              width: double.infinity,
              child: Image.file(selectedByte.selectedFile),
            );
          }
        },
        itemCount: widget.selectedBytes.length,
      ),
    );
  }
}

class _DisplayVideo extends StatefulWidget {
  final SelectedByte selectedByte;
  const _DisplayVideo({Key? key, required this.selectedByte}) : super(key: key);

  @override
  State<_DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<_DisplayVideo> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    File file = widget.selectedByte.selectedFile;
    controller = VideoPlayerController.file(file);
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    });
                  },
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1),
          );
        }
      },
    );
  }
}
