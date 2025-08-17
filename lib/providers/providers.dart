// =============================================================================
// BARREL EXPORT (INDEX FILE) for Providers
// =============================================================================
//
// 🎯 PURPOSE:
// This file serves as a "barrel export" or "index file" that re-exports all
// provider classes from this folder. It acts as a single entry point for
// importing multiple providers.
//
// 📦 HOW IT WORKS:
// Instead of importing each provider file individually:
//   import 'package:flutter_camera_app/providers/gallery_provider.dart';
//   import 'package:flutter_camera_app/providers/user_provider.dart';     // (future)
//   import 'package:flutter_camera_app/providers/settings_provider.dart'; // (future)
//
// You can import everything at once:
//   import 'package:flutter_camera_app/providers/providers.dart';
//
// 💡 BENEFITS:
// 1. 🧹 Cleaner Imports: One import statement instead of multiple
// 2. 🔧 Easier Maintenance: Central place to manage exports
// 3. 🚀 Better Scalability: Easy to add new providers without changing imports
// 4. ♻️  Easier Refactoring: Rename files without updating imports everywhere
// 5. 📚 Better Organization: Clear structure and dependency management
//
// ⏰ WHEN TO USE:
// ✅ When you have 2+ providers (currently we have 1, so it's future-proofing)
// ✅ When you want consistent import patterns across the app
// ✅ When building a library or package
// ❌ Not strictly necessary for single provider setups
//
// 🔮 FUTURE EXAMPLE:
// As your app grows, this file might look like:
//   export 'gallery_provider.dart';
//   export 'user_provider.dart';
//   export 'settings_provider.dart';
//   export 'camera_provider.dart';
//   export 'theme_provider.dart';
//
// 📖 USAGE EXAMPLES:
// See the usage examples in main.dart, gallery_screen.dart, and camera_screen.dart
// where we demonstrate both approaches (direct import vs barrel import).
//
// =============================================================================

// Export all provider classes from this folder
export 'gallery_provider.dart';
