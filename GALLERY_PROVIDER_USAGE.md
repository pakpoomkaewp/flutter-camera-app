# GalleryProvider Usage

This document shows how to use the `GalleryProvider` in your Flutter Camera App.

## Overview

The `GalleryProvider` is a state management solution using the Provider package that handles:
- Loading images from the device storage
- Managing loading states and error handling
- Adding new images when photos are taken
- Removing images with delete functionality
- Refreshing the gallery

## Basic Usage

### 1. Accessing the Provider

```dart
// Get the provider instance (read-only, doesn't listen to changes)
final galleryProvider = context.read<GalleryProvider>();

// Listen to provider changes and rebuild widget when state changes
Consumer<GalleryProvider>(
  builder: (context, galleryProvider, child) {
    // Your widget that reacts to provider changes
    return Text('Images: ${galleryProvider.imageCount}');
  },
)

// Watch a specific value (rebuilds when this value changes)
final imageCount = context.watch<GalleryProvider>().imageCount;
```

### 2. Available Properties

```dart
final galleryProvider = context.read<GalleryProvider>();

// Get list of image files
List<File> images = galleryProvider.images;

// Check loading state
bool isLoading = galleryProvider.isLoading;

// Check for errors
String? error = galleryProvider.error;

// Check if gallery has images
bool hasImages = galleryProvider.hasImages;

// Get total image count
int count = galleryProvider.imageCount;
```

### 3. Available Methods

```dart
final galleryProvider = context.read<GalleryProvider>();

// Load/refresh images from storage
await galleryProvider.loadImages();
await galleryProvider.refreshGallery(); // Same as loadImages()

// Add a new image (automatically notifies listeners)
galleryProvider.addImage(File('path/to/image.jpg'));

// Remove an image (deletes file and updates list)
bool success = await galleryProvider.removeImage(imageFile);

// Get image at specific index
File? image = galleryProvider.getImageAt(0);

// Clear all images from the list (doesn't delete files)
galleryProvider.clearImages();

// Clear error state
galleryProvider.clearError();
```

## Complete Example

```dart
class GalleryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, galleryProvider, child) {
        if (galleryProvider.isLoading) {
          return CircularProgressIndicator();
        }

        if (galleryProvider.error != null) {
          return Column(
            children: [
              Text('Error: ${galleryProvider.error}'),
              ElevatedButton(
                onPressed: () => galleryProvider.refreshGallery(),
                child: Text('Retry'),
              ),
            ],
          );
        }

        if (!galleryProvider.hasImages) {
          return Text('No images found');
        }

        return GridView.builder(
          itemCount: galleryProvider.imageCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final image = galleryProvider.getImageAt(index);
            return Image.file(image!, fit: BoxFit.cover);
          },
        );
      },
    );
  }
}
```

## Error Handling

The provider includes built-in error handling:

```dart
Consumer<GalleryProvider>(
  builder: (context, galleryProvider, child) {
    if (galleryProvider.error != null) {
      return ErrorWidget(
        error: galleryProvider.error!,
        onRetry: () {
          galleryProvider.clearError();
          galleryProvider.refreshGallery();
        },
      );
    }
    // ... rest of your widget
  },
)
```

## Best Practices

1. **Use Consumer for UI that needs to rebuild**: Wrap widgets that need to react to provider changes with `Consumer<GalleryProvider>`

2. **Use context.read() for actions**: When you need to call methods but don't need to listen to changes, use `context.read<GalleryProvider>()`

3. **Handle loading states**: Always check `isLoading` to show appropriate loading indicators

4. **Handle errors gracefully**: Check for `error` and provide retry mechanisms

5. **Use mounted checks**: When calling provider methods from async functions, check if the widget is still mounted:

```dart
Future<void> deleteImage(File image) async {
  final success = await context.read<GalleryProvider>().removeImage(image);
  if (mounted && !success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete image')),
    );
  }
}
```
