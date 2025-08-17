import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
// 📦 USING BARREL EXPORT: Import all providers with one line
import 'package:flutter_camera_app/providers/providers.dart';
import 'gallery_screen.dart';

// 💭 COMPARISON:
// Before (direct imports): Would need individual imports for each provider
//   import 'package:flutter_camera_app/providers/gallery_provider.dart';
//   import 'package:flutter_camera_app/providers/user_provider.dart';     // if existed
//   import 'package:flutter_camera_app/providers/settings_provider.dart'; // if existed
//
// After (barrel import): One line imports everything from providers folder
//   import 'package:flutter_camera_app/providers/providers.dart';
//
// 🎯 RESULT: Cleaner code, easier maintenance, better scalability

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      // Handle case where no cameras are available
      print("No cameras found");
      return;
    }

    _controller = CameraController(
      _cameras![0], // Use the first available camera (usually the back one)
      ResolutionPreset.high,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    // IMPORTANT: Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null || !_controller!.value.isInitialized) {
      // Show a loading indicator while the camera is initializing
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GalleryScreen()),
              );
            },
          ),
        ],
      ),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      return;
    }
    try {
      final XFile picture = await _controller!.takePicture();
      print('Picture saved to ${picture.path}');

      // 1. Get the application's private documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // 2. Create a unique filename
      final String filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = path.join(appDir.path, filename);

      // 3. Copy the file to the new path
      await picture.saveTo(newPath);

      print('Picture saved permanently to $newPath');

      // 4. Add the new image to the gallery provider
      final File newImageFile = File(newPath);
      if (mounted) {
        context.read<GalleryProvider>().addImage(newImageFile);
      }

      // Optional: Show a confirmation to the user
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Photo saved!')));
      }
    } catch (e) {
      print('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving photo: $e')));
      }
    }
  }
}
