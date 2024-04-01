import 'dart:convert';

class PortExtractor {
  static const _kJsonKeyForPort = "port";
  final String _envJson;

  PortExtractor({required String envJson}) : _envJson = envJson;

  int extractPort() {
    final Map<String, dynamic> envMap = json.decode(_envJson);
    return envMap[_kJsonKeyForPort];
  }
}
