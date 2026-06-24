import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_frsfhn0jde9cWVUW3hXjGcnMIQmY51k',
    appId: '1:1053269106596:android:de2128024cd023a973ab31',
    messagingSenderId: '1053269106596',
    projectId: 'sehatak-platform',
    authDomain: 'sehatak-platform.firebaseapp.com',
    storageBucket: 'sehatak-platform.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_frsfhn0jde9cWVUW3hXjGcnMIQmY51k',
    appId: '1:1053269106596:ios:de2128024cd023a973ab31',
    messagingSenderId: '1053269106596',
    projectId: 'sehatak-platform',
    authDomain: 'sehatak-platform.firebaseapp.com',
    storageBucket: 'sehatak-platform.firebasestorage.app',
    iosClientId: 'com.googleusercontent.apps.1053269106596-xxxxxxxx',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD_frsfhn0jde9cWVUW3hXjGcnMIQmY51k',
    appId: '1:1053269106596:web:de2128024cd023a973ab31',
    messagingSenderId: '1053269106596',
    projectId: 'sehatak-platform',
    authDomain: 'sehatak-platform.firebaseapp.com',
    storageBucket: 'sehatak-platform.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_frsfhn0jde9cWVUW3hXjGcnMIQmY51k',
    appId: '1:1053269106596:ios:de2128024cd023a973ab31',
    messagingSenderId: '1053269106596',
    projectId: 'sehatak-platform',
    authDomain: 'sehatak-platform.firebaseapp.com',
    storageBucket: 'sehatak-platform.firebasestorage.app',
    iosClientId: 'com.googleusercontent.apps.1053269106596-xxxxxxxx',
  );
}
