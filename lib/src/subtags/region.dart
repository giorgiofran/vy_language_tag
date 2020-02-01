import 'dart:collection';

import 'package:vy_string_utils/vy_string_utils.dart';

final Map<String, Region> _existingRegions = SplayTreeMap<String, Region>();

Region _insertRegion(Region region) {
  _existingRegions[region.code] = region;
  return region;
}

class Region {
  final String code;

  Region._(this.code);

  factory Region(String code) {
    Region region;
    if (unfilled(code)) {
      throw ArgumentError('An empty code is not valid in Region creation');
    } else if (code.length == 2) {
      if (!onlyContainsAlpha(code)) {
        throw ArgumentError(
            'The region code "$code" contains characters that are not alphabetic');
      }
      region = Region._(code.toUpperCase());
    } else if (code.length == 3) {
      if (!onlyContainsDigits(code)) {
        throw ArgumentError(
            'The region code "$code" contains characters that are not numeric');
      }
      region = Region._(code);
    } else {
      throw ArgumentError(
          'The length of the code can be only in the range of 2-3 chars');
    }
    return _existingRegions[region.code] ?? _insertRegion(region);
  }

  String get simpleCode => code.toLowerCase();

  @override
  bool operator ==(other) => other is Region && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
