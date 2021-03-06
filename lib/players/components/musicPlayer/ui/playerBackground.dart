// Dart
import 'dart:io';
import 'dart:ui';

// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:image_fade/image_fade.dart';
import 'package:transparent_image/transparent_image.dart';

class PlayerBackground extends StatelessWidget {
  final File backgroundImage;
  final bool enableBlur;
  final double blurIntensity;
  final Widget child;
  final Color backdropColor;
  final double backdropOpacity;
  PlayerBackground({
    @required this.backgroundImage,
    this.enableBlur = true,
    this.blurIntensity = 22.0,
    @required this.child,
    this.backdropColor = Colors.black,
    this.backdropOpacity = 0.4
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: enableBlur ? ImageFade(
            image: backgroundImage.path.isEmpty
              ? MemoryImage(kTransparentImage)
              : FileImage(backgroundImage),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ) : Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          )
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: backdropColor.withOpacity(backdropOpacity),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              tileMode: TileMode.mirror,
              sigmaX: blurIntensity,
              sigmaY: blurIntensity
            ),
            child: Column(
              children: [
                Expanded(child: child),
                Container(height: MediaQuery.of(context).padding.bottom)
              ],
            ),
          ),
        )
      ],
    );
  }
}