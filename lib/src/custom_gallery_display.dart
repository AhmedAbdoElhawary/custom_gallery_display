import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:custom_gallery_display/src/camera_display.dart';
import 'package:custom_gallery_display/src/images_view_page.dart';
import 'package:custom_gallery_display/src/utilities/enum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomGalleryDisplay extends StatefulWidget {
  final DisplaySource displaySource;
  final bool multiSelection;
  final GalleryDisplaySettings? galleryDisplaySettings;
  final AsyncValueSetter<SelectedImagesDetails> onDone;
  final PickerSource pickerSource;
  final bool cropImage;
  final bool showImagePreview;

  const CustomGalleryDisplay.normalDisplay({
    this.displaySource = DisplaySource.gallery,
    this.multiSelection = false,
    this.galleryDisplaySettings,
    this.pickerSource = PickerSource.image,
    required this.onDone,
    super.key,
  })  : showImagePreview = false,
        cropImage = false;
  const CustomGalleryDisplay.instagramDisplay({
    this.displaySource = DisplaySource.gallery,
    this.multiSelection = false,
    this.galleryDisplaySettings,
    this.pickerSource = PickerSource.image,
    this.cropImage = true,
    required this.onDone,
    super.key,
  }) : showImagePreview = true;

  @override
  CustomGalleryDisplayState createState() => CustomGalleryDisplayState();
}

class CustomGalleryDisplayState extends State<CustomGalleryDisplay>
    with TickerProviderStateMixin {
  final pageController = ValueNotifier(PageController());
  final clearVideoRecord = ValueNotifier(false);
  final redDeleteText = ValueNotifier(false);
  final selectedPage = ValueNotifier(SelectedPage.left);
  ValueNotifier<List<File>> multiSelectedImage = ValueNotifier([]);
  final multiSelectionMode = ValueNotifier(false);
  final showDeleteText = ValueNotifier(false);
  final selectedVideo = ValueNotifier(false);
  final ValueNotifier<File?> videoRecordFile = ValueNotifier(null);

  bool showGallery = true;
  ValueNotifier<File?> selectedCameraImage = ValueNotifier(null);
  late bool cropImage;
  late AppTheme appTheme;
  late TabsTexts tapsNames;
  late bool showImagePreview;

  final isImagesReady = ValueNotifier(false);
  final currentPage = ValueNotifier(0);
  final lastPage = ValueNotifier(0);

  late Color whiteColor;
  late Color blackColor;
  late GalleryDisplaySettings imagePickerDisplay;

  late bool enableCamera;
  late bool enableVideo;

  late bool showInternalVideos;
  late bool showInternalImages;
  AsyncValueSetter<SelectedImagesDetails>? sendRequestFunction;
  late SliverGridDelegateWithFixedCrossAxisCount gridDelegate;
  late bool showTabBar;
  late bool cameraVideoOnlyEnabled;
  late bool showAllTabs;

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  _initializeVariables() {
    imagePickerDisplay =
        widget.galleryDisplaySettings ?? GalleryDisplaySettings();
    appTheme = imagePickerDisplay.appTheme ?? AppTheme();
    tapsNames = imagePickerDisplay.tabsTexts ?? TabsTexts();
    cropImage = widget.cropImage;
    showImagePreview = cropImage || widget.showImagePreview;
    gridDelegate = imagePickerDisplay.gridDelegate;

    showInternalImages = widget.pickerSource != PickerSource.video;
    showInternalVideos = widget.pickerSource != PickerSource.image;
    sendRequestFunction = widget.onDone;
    showGallery = widget.displaySource != DisplaySource.camera;
    bool notGallery = widget.displaySource != DisplaySource.gallery;

    enableCamera = showInternalImages && notGallery;
    enableVideo = showInternalVideos && notGallery;
    bool cameraAndVideoEnabled = enableCamera && enableVideo;

    showTabBar = (cameraAndVideoEnabled) ||
        (showGallery && enableVideo) ||
        (showGallery && enableCamera);

    cameraVideoOnlyEnabled =
        cameraAndVideoEnabled && widget.displaySource == DisplaySource.camera;
    showAllTabs = cameraAndVideoEnabled && showGallery;
    whiteColor = appTheme.primaryColor;
    blackColor = appTheme.focusColor;
  }

  @override
  void dispose() {
    showDeleteText.dispose();
    selectedVideo.dispose();
    selectedPage.dispose();
    selectedCameraImage.dispose();
    pageController.dispose();
    clearVideoRecord.dispose();
    redDeleteText.dispose();
    multiSelectionMode.dispose();
    multiSelectedImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return tabController();
  }

  Widget tapBarMessage(bool isThatDeleteText) {
    Color deleteColor = redDeleteText.value ? Colors.red : appTheme.focusColor;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () async {
            if (isThatDeleteText) {
              setState(() {
                if (!redDeleteText.value) {
                  redDeleteText.value = true;
                } else {
                  selectedCameraImage.value = null;
                  clearVideoRecord.value = true;
                  showDeleteText.value = false;
                  redDeleteText.value = false;
                  videoRecordFile.value = null;
                }
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isThatDeleteText)
                Icon(Icons.arrow_back_ios_rounded,
                    color: deleteColor, size: 15),
              Text(
                isThatDeleteText
                    ? tapsNames.deletingText
                    : tapsNames.limitingText,
                style: TextStyle(
                    fontSize: 14,
                    color: deleteColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget clearSelectedImages() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () async {
            setState(() {
              multiSelectionMode.value = !multiSelectionMode.value;
              multiSelectedImage.value.clear();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tapsNames.clearImagesText,
                style: TextStyle(
                    fontSize: 14,
                    color: appTheme.focusColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  replacingDeleteWidget(bool showDeleteText) {
    this.showDeleteText.value = showDeleteText;
  }

  moveToVideo() {
    setState(() {
      selectedPage.value = SelectedPage.right;
      selectedVideo.value = true;
    });
  }

  DefaultTabController tabController() {
    return DefaultTabController(
        length: 2, child: Material(color: whiteColor, child: safeArea()));
  }

  SafeArea safeArea() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ValueListenableBuilder(
              valueListenable: pageController,
              builder: (context, PageController pageControllerValue, child) =>
                  PageView(
                controller: pageControllerValue,
                dragStartBehavior: DragStartBehavior.start,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (showGallery) imagesViewPage(),
                  if (enableCamera || enableVideo) cameraPage(),
                ],
              ),
            ),
          ),
          if (multiSelectedImage.value.length < 10) ...[
            ValueListenableBuilder(
              valueListenable: multiSelectionMode,
              builder: (context, bool multiSelectionModeValue, child) {
                if (enableVideo || enableCamera) {
                  if (!showImagePreview) {
                    if (multiSelectionModeValue) {
                      return clearSelectedImages();
                    } else {
                      return buildTabBar();
                    }
                  } else {
                    return Visibility(
                      visible: !multiSelectionModeValue,
                      child: buildTabBar(),
                    );
                  }
                } else {
                  return multiSelectionModeValue
                      ? clearSelectedImages()
                      : const SizedBox();
                }
              },
            )
          ] else ...[
            tapBarMessage(false)
          ],
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> cameraPage() {
    return ValueListenableBuilder(
      valueListenable: selectedVideo,
      builder: (context, bool selectedVideoValue, child) => CustomCameraDisplay(
        appTheme: appTheme,
        selectedCameraImage: selectedCameraImage,
        tapsNames: tapsNames,
        enableCamera: enableCamera,
        enableVideo: enableVideo,
        videoRecordFile: videoRecordFile,
        replacingTabBar: replacingDeleteWidget,
        sendRequestFunction: sendRequestFunction,
        clearVideoRecord: clearVideoRecord,
        redDeleteText: redDeleteText,
        moveToVideoScreen: moveToVideo,
        selectedVideo: selectedVideoValue,
      ),
    );
  }

  void clearMultiImages() {
    setState(() {
      multiSelectedImage.value.clear();
      multiSelectionMode.value = false;
    });
  }

  ImagesViewPage imagesViewPage() {
    return ImagesViewPage(
      appTheme: appTheme,
      clearMultiImages: clearMultiImages,
      gridDelegate: gridDelegate,
      multiSelectionMode: multiSelectionMode,
      blackColor: blackColor,
      showImagePreview: showImagePreview,
      tabsTexts: tapsNames,
      multiSelectedImages: multiSelectedImage,
      whiteColor: whiteColor,
      cropImage: cropImage,
      sendRequestFunction: sendRequestFunction,
      multiSelection: widget.multiSelection,
      showInternalVideos: showInternalVideos,
      showInternalImages: showInternalImages,
    );
  }

  ValueListenableBuilder<bool> buildTabBar() {
    return ValueListenableBuilder(
      valueListenable: showDeleteText,
      builder: (context, bool showDeleteTextValue, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeInOutQuart,
        child: showTabBar
            ? (showDeleteTextValue ? tapBarMessage(true) : tabBar())
            : const SizedBox(),
      ),
    );
  }

  Widget tabBar() {
    double widthOfScreen = MediaQuery.of(context).size.width;
    int divideNumber = showAllTabs ? 3 : 2;
    double widthOfTab = widthOfScreen / divideNumber;
    return ValueListenableBuilder(
      valueListenable: selectedPage,
      builder: (context, SelectedPage selectedPageValue, child) {
        Color photoColor =
            selectedPageValue == SelectedPage.center ? blackColor : Colors.grey;
        return Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Row(
              children: [
                if (showGallery) galleryTabBar(widthOfTab, selectedPageValue),
                if (enableCamera) photoTabBar(widthOfTab, photoColor),
                if (enableVideo) videoTabBar(widthOfTab),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutQuad,
              right: selectedPageValue == SelectedPage.center
                  ? widthOfTab
                  : (selectedPageValue == SelectedPage.right
                      ? 0
                      : (divideNumber == 2 ? widthOfTab : widthOfScreen / 1.5)),
              child: Container(height: 1, width: widthOfTab, color: blackColor),
            ),
          ],
        );
      },
    );
  }

  GestureDetector galleryTabBar(
      double widthOfTab, SelectedPage selectedPageValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          centerPage(numPage: 0, selectedPage: SelectedPage.left);
        });
      },
      child: SizedBox(
        width: widthOfTab,
        height: 40,
        child: Center(
          child: Text(
            tapsNames.galleryText,
            style: TextStyle(
                color: selectedPageValue == SelectedPage.left
                    ? blackColor
                    : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  GestureDetector photoTabBar(double widthOfTab, Color textColor) {
    return GestureDetector(
      onTap: () => centerPage(
          numPage: cameraVideoOnlyEnabled ? 0 : 1,
          selectedPage:
              cameraVideoOnlyEnabled ? SelectedPage.left : SelectedPage.center),
      child: SizedBox(
        width: widthOfTab,
        height: 40,
        child: Center(
          child: Text(
            tapsNames.photoText,
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  centerPage({required int numPage, required SelectedPage selectedPage}) {
    if (!enableVideo && numPage == 1) selectedPage = SelectedPage.right;

    setState(() {
      this.selectedPage.value = selectedPage;
      pageController.value.animateToPage(numPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuad);
      selectedVideo.value = false;
    });
  }

  GestureDetector videoTabBar(double widthOfTab) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            pageController.value.animateToPage(cameraVideoOnlyEnabled ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutQuad);
            selectedPage.value = SelectedPage.right;
            selectedVideo.value = true;
          },
        );
      },
      child: SizedBox(
        width: widthOfTab,
        height: 40,
        child: ValueListenableBuilder(
          valueListenable: selectedVideo,
          builder: (context, bool selectedVideoValue, child) => Center(
            child: Text(
              tapsNames.videoText,
              style: TextStyle(
                  fontSize: 14,
                  color: selectedVideoValue ? blackColor : Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
