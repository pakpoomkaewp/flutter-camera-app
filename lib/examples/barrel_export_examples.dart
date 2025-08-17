// =============================================================================
// BARREL EXPORT PATTERN - PRACTICAL EXAMPLES AND DEMONSTRATIONS
// =============================================================================
//
// This file demonstrates how the barrel export pattern works in practice
// with real examples and scenarios you might encounter.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📦 BARREL IMPORT EXAMPLE:
// This single import gives us access to ALL providers in the providers folder
import 'package:flutter_camera_app/providers/providers.dart';

// 🔄 ALTERNATIVE (Direct imports):
// import 'package:flutter_camera_app/providers/gallery_provider.dart';
// import 'package:flutter_camera_app/providers/user_provider.dart';     // (if it existed)
// import 'package:flutter_camera_app/providers/settings_provider.dart'; // (if it existed)

class BarrelExportExamplesWidget extends StatelessWidget {
  const BarrelExportExamplesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barrel Export Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================================
            // EXAMPLE 1: Using imported provider with Consumer
            // =================================================================
            const Text(
              '📦 Example 1: Using Provider from Barrel Import',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This Consumer widget uses GalleryProvider which was imported '
              'through the barrel export (providers.dart).',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Consumer<GalleryProvider>(
                builder: (context, galleryProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Images in Gallery: ${galleryProvider.imageCount}'),
                      Text('Loading: ${galleryProvider.isLoading}'),
                      Text('Has Images: ${galleryProvider.hasImages}'),
                      if (galleryProvider.error != null)
                        Text('Error: ${galleryProvider.error}',
                            style: const TextStyle(color: Colors.red)),
                    ],
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // =================================================================
            // EXAMPLE 2: Using provider methods
            // =================================================================
            const Text(
              '🔧 Example 2: Using Provider Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'These buttons demonstrate calling methods on the provider '
              'that was imported via barrel export.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<GalleryProvider>().refreshGallery(),
                  child: const Text('Refresh Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => context.read<GalleryProvider>().clearError(),
                  child: const Text('Clear Error'),
                ),
                ElevatedButton(
                  onPressed: () => context.read<GalleryProvider>().clearImages(),
                  child: const Text('Clear Images'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // =================================================================
            // EXAMPLE 3: Future scenario with multiple providers
            // =================================================================
            const Text(
              '🔮 Example 3: Future Multiple Providers Scenario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'When you add more providers in the future:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('// providers.dart would contain:'),
                  Text("export 'gallery_provider.dart';"),
                  Text("export 'user_provider.dart';"),
                  Text("export 'settings_provider.dart';"),
                  Text("export 'camera_provider.dart';"),
                  SizedBox(height: 8),
                  Text('// Your widgets could then use:'),
                  Text('Consumer2<GalleryProvider, UserProvider>(...'),
                  Text('Consumer3<GalleryProvider, UserProvider, SettingsProvider>(...'),
                  SizedBox(height: 8),
                  Text(
                    'All with just ONE import line! 🎉',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRACTICAL USAGE PATTERNS
// =============================================================================

/// 🎯 PATTERN 1: Multiple Providers in One Widget
/// When you have multiple providers, barrel import shines:
class MultiProviderExample extends StatelessWidget {
  const MultiProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    // With barrel import, you can use multiple providers easily:
    // (This is what it would look like when you have more providers)
    
    return Consumer<GalleryProvider>(
      builder: (context, galleryProvider, child) {
        // You could also use Consumer2, Consumer3, etc. when you have more providers
        // Consumer2<GalleryProvider, UserProvider>(...)
        // Consumer3<GalleryProvider, UserProvider, SettingsProvider>(...)
        
        return Container(
          child: Column(
            children: [
              Text('Gallery Images: ${galleryProvider.imageCount}'),
              // Text('User Name: ${userProvider.name}'),        // Future provider
              // Text('Theme Mode: ${settingsProvider.themeMode}'), // Future provider
            ],
          ),
        );
      },
    );
  }
}

/// 🎯 PATTERN 2: Provider Methods Usage
/// Demonstrate how to call methods on providers imported via barrel export
class ProviderMethodsExample extends StatelessWidget {
  const ProviderMethodsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          // ✅ This works because GalleryProvider is available via barrel import
          onPressed: () async {
            final galleryProvider = context.read<GalleryProvider>();
            await galleryProvider.refreshGallery();
            
            // Future examples when you have more providers:
            // final userProvider = context.read<UserProvider>();
            // final settingsProvider = context.read<SettingsProvider>();
            // await userProvider.updateProfile();
            // settingsProvider.toggleTheme();
          },
          child: const Text('Refresh All Data'),
        ),
      ],
    );
  }
}

// =============================================================================
// COMPARISON: WITH vs WITHOUT BARREL EXPORTS
// =============================================================================

/*
❌ WITHOUT BARREL EXPORTS (Direct imports):

import 'package:flutter_camera_app/providers/gallery_provider.dart';
import 'package:flutter_camera_app/providers/user_provider.dart';
import 'package:flutter_camera_app/providers/settings_provider.dart';
import 'package:flutter_camera_app/providers/camera_provider.dart';
import 'package:flutter_camera_app/providers/theme_provider.dart';

Problems:
- Multiple import lines
- If you rename a provider file, you need to update imports everywhere
- Easy to forget importing a provider
- Cluttered import section

✅ WITH BARREL EXPORTS:

import 'package:flutter_camera_app/providers/providers.dart';

Benefits:
- Single import line
- Rename files? Just update the barrel export
- Consistent import pattern
- Clean and maintainable
- Easy to add new providers without changing imports
*/
