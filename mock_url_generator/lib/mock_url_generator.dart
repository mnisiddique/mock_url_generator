library mock_url_generator;

import 'dart:async';

import 'package:build/build.dart';
import 'package:mock_url_generator/src/port_extractor.dart';
import 'package:mock_url_generator/src/url_builder.dart';

Builder mockUrlBuilder(BuilderOptions options) => MockBaseUrlBuilder();

class MockBaseUrlBuilder implements Builder {
  static const _kOutputPath = 'lib/mock/base_url.g.dart';
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final envJson = await buildStep.readAsString(buildStep.inputId);
    final pkg = buildStep.inputId.package;
    await buildStep.writeAsString(getOutputId(pkg), getCode(envJson));
  }

  AssetId getOutputId(String package) {
    final outputId = AssetId(package, _kOutputPath);
    return outputId;
  }

  Future<String> getCode(String envJson) async {
    final urlBuilder = UrlBuilder(
      portExtractor: PortExtractor(envJson: envJson),
      ipConfig: IpConfigProvider().platformIpConfig,
    );
    final url = await urlBuilder.buildUrl();
    final outputBuffer = StringBuffer('// Generated, do not edit\n');
    outputBuffer.writeln("\n\nconst String mockBaseUrl = '$url';");
    return outputBuffer.toString();
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        "mock/env.json": ["mock/base_url.g.dart"]
      };
}
