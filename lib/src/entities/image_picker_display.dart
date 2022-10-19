import 'package:custom_gallery_display/custom_gallery_display.dart';
import 'package:flutter/material.dart';

/// [GalleryDisplaySettings] When you make ImageSource from the camera these settings will be disabled because they belong to the gallery.
class GalleryDisplaySettings {
  AppTheme? appTheme;
  TabsTexts? tabsTexts;
  SliverGridDelegateWithFixedCrossAxisCount gridDelegate;

  GalleryDisplaySettings({
    this.appTheme,
    this.tabsTexts,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 1.7, mainAxisSpacing: 1.5),
  });
}
