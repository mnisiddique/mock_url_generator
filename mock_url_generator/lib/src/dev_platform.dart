import 'dart:io';

class DevPlatform {
  final bool _isCurrent;
  final String name;
  DevPlatform._(this._isCurrent, this.name);

  static DevPlatform get currentPlatform =>
      devPlatforms.firstWhere((element) => element._isCurrent);

  static final macOS = DevPlatform._(Platform.isMacOS, "MacOS");
  static final windows = DevPlatform._(Platform.isWindows, "Windows");
  static final linux = DevPlatform._(Platform.isLinux, "Linux");

  static List<DevPlatform> devPlatforms = [
    macOS,
    windows,
    linux,
  ];
}
