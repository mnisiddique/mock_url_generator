import 'dart:io';


// Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPENABLED=TRUE | Select IPAddress

abstract class IpConfig {
  final String kLoopbackAddress = "127.0.0.1";

  String get command;

  List<String> get arguments;

  String extractIP(String output);

  Future<String> getIp() async {
    final prResult = await Process.run(command, arguments);

    if (prResult.exitCode == 0) {
      return extractIP(prResult.stdout);
    }
    return "";
  }
}

class WindowsIpConfig extends IpConfig {
  final _winIpRegExp = RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
  @override
  List<String> get arguments => [
        "-c",
        "Get-WmiObject",
        " -Class",
        "Win32_NetworkAdapterConfiguration",
        "-Filter",
        "IPENABLED=TRUE",
        "|",
        "Select",
        "IPAddress",
      ];

  @override
  String get command => "powershell";

  @override
  String extractIP(String output) {
    return _winIpRegExp.firstMatch(output)!.group(0)!;
  }
}

class MacIpConfig extends IpConfig {
  final _macIpRegExp = RegExp(r'inet \b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
  final _ipRegExp = RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
  @override
  List<String> get arguments => [];

  @override
  String get command => "ifconfig";

  @override
  String extractIP(String output) {
    final matches = _macIpRegExp.allMatches(output);
    tester(RegExpMatch m) => !m[0]!.contains(kLoopbackAddress);
    final ipMatch = matches.where(tester).first.group(0)!;
    return _ipRegExp.firstMatch(ipMatch)!.group(0)!;
  }
}

class LinuxIpConfig extends IpConfig {
  final _macIpRegExp = RegExp(r'inet \b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
  final _ipRegExp = RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b');
  @override
  List<String> get arguments => ["address"];

  @override
  String get command => "ip";

  @override
  String extractIP(String output) {
    final matches = _macIpRegExp.allMatches(output);
    tester(RegExpMatch m) => !m[0]!.contains(kLoopbackAddress);
    final ipMatch = matches.where(tester).first.group(0)!;
    return _ipRegExp.firstMatch(ipMatch)!.group(0)!;
  }
}
