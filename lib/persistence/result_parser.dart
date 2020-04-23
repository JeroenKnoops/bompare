import 'dart:io';

import '../service/domain/scan_result.dart';

/// API for scan result parsers.
abstract class ResultParser {
  /// Returns the scanning result stored in a [file].
  Future<ScanResult> parse(File file);
}
