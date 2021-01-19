To add the Flavors to the application, place these files in a directory called flavor at the root of the project.

```bash
cd flavor
chmod + x flavor.sh && ./flavor.sh "App Flavor" # App Name
```

to execute the flavors:

```dart
flutter run
flutter run --dart-define = DEFINE_APP_NAME = '[QA] App Flavor' --dart-define = DEFINE_APP_SUFFIX = .qa
flutter run --dart-define = DEFINE_APP_NAME = '[DEV] App Flavor' --dart-define = DEFINE_APP_SUFFIX = .dev
```

