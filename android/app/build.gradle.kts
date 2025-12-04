plugins {
  id("com.android.application")
  id("kotlin-android")
  id("org.sonarqube") version "6.3.1.5724"
  // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "com.zprofile.client"
  compileSdk = flutter.compileSdkVersion

  // ndkVersion = flutter.ndkVersion
  ndkVersion = "28.2.13676358"

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
  }

  kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

  defaultConfig {
    // TODO: Specify your own unique Application ID
    // (https://developer.android.com/studio/build/application-id.html).
    applicationId = "com.zprofile.client"
    // You can update the following values to match your application needs.
    // For more information, see: https://flutter.dev/to/review-gradle-config.
    // minSdk = flutter.minSdkVersion
    // targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
    minSdk = 24
    targetSdk = 36
    buildToolsVersion = "36.0.0"
    manifestPlaceholders["appAuthRedirectScheme"] = "com.zprofile.client"
  }

  buildTypes {
    release {
      // TODO: Add your own signing config for the release build.
      // Signing with the debug keys for now, so `flutter run --release` works.
      signingConfig = signingConfigs.getByName("debug")
    }
  }
}

flutter { source = "../.." }
