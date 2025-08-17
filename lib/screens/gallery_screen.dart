import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_camera_app/providers/gallery_provider.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GalleryProvider>().refreshGallery();
            },
          ),
        ],
      ),
      body: Consumer<GalleryProvider>(
        builder: (context, galleryProvider, child) {
          if (galleryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (galleryProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${galleryProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      galleryProvider.clearError();
                      galleryProvider.refreshGallery();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!galleryProvider.hasImages) {
            return const Center(child: Text('No photos yet. Go take some!'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: galleryProvider.imageCount,
            itemBuilder: (context, index) {
              final File? image = galleryProvider.getImageAt(index);
              if (image == null) return const SizedBox.shrink();

              return GestureDetector(
                onLongPress: () => _showDeleteDialog(context, image),
                child: Image.file(image, fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Photo'),
          content: const Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await context
                    .read<GalleryProvider>()
                    .removeImage(imageFile);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete photo')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
