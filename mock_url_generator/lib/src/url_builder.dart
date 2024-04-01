import 'dev_platform.dart';
import 'ip_config.dart';
import 'port_extractor.dart';

class UrlBuilder {
  final PortExtractor _portExtractor;
  final IpConfig _ipConfig;

  UrlBuilder({
    required PortExtractor portExtractor,
    required IpConfig ipConfig,
  })  : _portExtractor = portExtractor,
        _ipConfig = ipConfig;

  Future<String> buildUrl() async {
    final ip = await _ipConfig.getIp();
    final port = _portExtractor.extractPort();
    return Uri(
      scheme: "http",
      host: ip,
      port: port,
    ).toString();
  }
}

class IpConfigProvider {
  IpConfig get platformIpConfig {
    final Map<DevPlatform, IpConfig> configMap = {
      DevPlatform.macOS: MacIpConfig(),
      DevPlatform.windows: WindowsIpConfig(),
      DevPlatform.linux: LinuxIpConfig(),
    };

    return configMap[DevPlatform.currentPlatform]!;
  }
}


// flutter create --org pe.mnisiddique --template=package mock_url_generator
