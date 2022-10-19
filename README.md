
<h1 align="left">Custom Gallery Display</h1>

When you try to add a package to select an image from a gallery, you will face a bad user experience because you have a traditional UI of Gallery display.

I have two main views of the gallery to solve this issue:
- It looks like the Instagram gallery.
- It's a grid view of gallery images.

You can even customize a display of a camera to take a photo and video from two perspectives

<p align="left">
  <a href="https://pub.dartlang.org/packages/custom_gallery_display">
    <img src="https://img.shields.io/pub/v/custom_gallery_display.svg"
      alt="Pub Package" />
  </a>
    <a href="LICENSE">
    <img src="https://img.shields.io/apm/l/atomic-design-ui.svg?"
      alt="License: MIT" />
  </a> 
</p>

## Necessary note

#### `CustomGallery` is a page that you need to push to it .It's has scafold, you cannot add it as a widget with another scafold

# Installing

## IOS

\* The camera plugin compiles for any version of iOS, but its functionality
requires iOS 10 or higher. If compiling for iOS 9, make sure to programmatically
check the version of iOS running on the device before using any camera plugin features.
The [device_info_plus](https://pub.dev/packages/device_info_plus) plugin, for example, can be used to check the iOS version.

Add two rows to the `ios/Runner/Info.plist`:

* one with the key `Privacy - Camera Usage Description` and a usage description.
* and one with the key `Privacy - Microphone Usage Description` and a usage description.

If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

## Android

* Change the minimum Android sdk version to 21 (or higher), and compile sdk to 31 (or higher) in your `android/app/build.gradle` file.

```java
    compileSdkVersion 33
    minSdkVersion 21
```

* Add this permission into your AndroidManifest.xml
````xml
<manifest>
    ...
    <application
    ...
    <activity
    ...
    android:requestLegacyExternalStorage="true"
    ...
</activity>
    ...
    </application>
<uses-permission android:name="android.permission.INTERNET"/>
    </manifest>
````

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_gallery_display: [last_version]
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```
$ pub get custom_gallery_display
```

with `Flutter`:

```
$ flutter pub add custom_gallery_display
```

### 3. Import it

In your `Dart` code, you can use:

```dart
import 'package:custom_gallery_display/custom_gallery_display.dart';
```

# Examples
<p>
<img src="https://user-images.githubusercontent.com/88978546/196819458-74246b7d-cc67-4380-9810-622a6c7d10f0.gif"   width="25%" height="50%">

</p>

```dart
    CustomGalleryDisplay.instagramDisplay(
displaySource: DisplaySource.both,
pickerSource: PickerSource.both,
multiSelection: true,
cropImage: true, // It's true by default
galleryDisplaySettings: GalleryDisplaySettings(
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 4,
crossAxisSpacing: 1.7,
mainAxisSpacing: 1.5), // It's true by default
),
onDone: (SelectedImagesDetails details) async {
bool multiSelectionMode = details.multiSelectionMode;
List<SelectedByte> selectedFiles = details.selectedFiles;
double aspectRatio = details.aspectRatio;
});
```

<p>
<img src="https://user-images.githubusercontent.com/88978546/196822436-62b4d961-c459-4a23-92c7-f3321e75e4fe.jpg"    width="25%" height="50%">

</p>


```dart

   CustomGalleryDisplay.normalDisplay(
        multiSelection: true,
        galleryDisplaySettings: GalleryDisplaySettings(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 1.7, mainAxisSpacing: 1.5),
          appTheme:
              AppTheme(focusColor: Colors.black, primaryColor: Colors.white),
        ),
        onDone: (SelectedImagesDetails details) async {
          bool multiSelectionMode = details.multiSelectionMode;
          List<SelectedByte> selectedFiles = details.selectedFiles;
          double aspectRatio = details.aspectRatio;
        });
```
<p>
<img src="https://user-images.githubusercontent.com/88978546/196822357-64206d63-b52a-4816-9b6b-439f423a7131.jpg"   width="25%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/196822364-f948b798-5c32-4fbc-b7e0-aa06b56340c7.jpg"   width="25%" height="50%">

</p>

```dart

    CustomGalleryDisplay.instagramDisplay(
        displaySource: DisplaySource.both,
        pickerSource: PickerSource.both,
        multiSelection: true,
        cropImage: false,
        galleryDisplaySettings: GalleryDisplaySettings(
          appTheme:
              AppTheme(primaryColor: Colors.black, focusColor: Colors.white),
          tabsTexts: TabsTexts(
            videoText: "視頻",
            photoText: "照片",
            galleryText: "畫廊",
            deletingText: "刪除",
            clearImagesText: "清除所選圖像",
            limitingText: "限制為 10 張照片或視頻",
          ),
        ),
        onDone: (SelectedImagesDetails details) async {
          bool multiSelectionMode = details.multiSelectionMode;
          List<SelectedByte> selectedFiles = details.selectedFiles;
          double aspectRatio = details.aspectRatio;
        });
```


<p>
<img src="https://user-images.githubusercontent.com/88978546/196822496-d76c109e-e03a-468e-b998-7bcdb75ff65f.jpg"   width="25%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/196822525-1c7ba574-1b5d-4eb8-a600-a12a6872b00c.jpg"   width="25%" height="50%">
<img src="https://user-images.githubusercontent.com/88978546/196822536-2a429562-bc07-4602-9ef2-4101994cf2e4.jpg"   width="25%" height="50%">


</p>

```dart
    CustomGalleryDisplay.normalDisplay(
        displaySource: DisplaySource.both,
        pickerSource: PickerSource.both,
        galleryDisplaySettings: GalleryDisplaySettings(
          appTheme:
              AppTheme(focusColor: Colors.black, primaryColor: Colors.white),
          tabsTexts: TabsTexts(
            videoText: "فيديو",
            galleryText: "المعرض",
            deletingText: "حذف",
            noImagesFounded: "لم يتم العثور علي صور",
            acceptAllPermissions: "أقبل جميع الاذونات",
            holdButtonText: "استمر بالضغط علي الزر",
            photoText: "الصور",
            clearImagesText: "الغاء الصور المحدده",
            limitingText: "اقصي حد للصور هو 10",
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1.7,
            mainAxisSpacing: 1.5,
            childAspectRatio: .5,
          ),
        ),
        multiSelection: true,
        onDone: (SelectedImagesDetails details) async {
          bool multiSelectionMode = details.multiSelectionMode;
          List<SelectedByte> selectedFiles = details.selectedFiles;
          double aspectRatio = details.aspectRatio;
        });
```
