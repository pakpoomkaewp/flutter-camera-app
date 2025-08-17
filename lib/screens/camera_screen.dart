import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      // TODO: Navigate to a new screen to display the picture and save it.
      print('Picture saved to ${picture.path}');
    } catch (e) {
      print('Error taking picture: $e');
    }
  }
}
