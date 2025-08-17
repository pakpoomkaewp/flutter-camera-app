import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class GalleryProvider extends ChangeNotifier {
  List<File> _images = [];
  bool _isLoading = false;
  String? _error;

  List<File> get images => _images;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasImages => _images.isNotEmpty;

  GalleryProvider() {
    loadImages();
  }

  /// Load all images from the application documents directory
  Future<void> loadImages() async {
    _setLoading(true);
    _error = null;

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> entities = appDir.listSync();
      final List<File> imageFiles = entities
          .where((entity) => entity is File && entity.path.endsWith('.jpg'))
          .map((entity) => entity as File)
          .toList();

      // Sort by date, newest first
      imageFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      _images = imageFiles;
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load images: ${e.toString()}';
      _setLoading(false);
    }
  }

  /// Refresh the gallery (reload images)
  Future<void> refreshGallery() async {
    await loadImages();
  }

  /// Add a new image to the gallery
  void addImage(File imageFile) {
    // Insert at the beginning since we want newest first
    _images.insert(0, imageFile);
    notifyListeners();
  }

  /// Remove an image from the gallery
  Future<bool> removeImage(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      _images.remove(imageFile);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete image: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Get image at specific index
  File? getImageAt(int index) {
    if (index >= 0 && index < _images.length) {
      return _images[index];
    }
    return null;
  }

  /// Get total number of images
  int get imageCount => _images.length;

  /// Clear all images (useful for testing or reset)
  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Private method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
