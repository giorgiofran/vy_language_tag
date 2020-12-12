/// Copyright © 2020 Giorgio Franceschetti. All rights reserved.

import 'dart:collection';
import 'package:vy_language_tag/src/utils/constants.dart';
import 'package:vy_string_utils/vy_string_utils.dart';
import 'subtags/region.dart';

Map<String, LanguageTag> _existingLocales = SplayTreeMap<String, LanguageTag>();

bool _isCorrectLanguage(String subtag) =>
    /* subtag != null && */
    ((subtag.length > 1 && subtag.length < 4) ||
        (subtag.length > 4 && subtag.length < 9)) &&
    onlyContainsAlpha(subtag);

bool _isCorrectExtlang(String subtag) =>
    /* subtag != null && */ subtag.length == 3 && onlyContainsAlpha(subtag);

bool _isCorrectScript(String subtag) =>
    /* subtag != null && */ subtag.length == 4 && onlyContainsAlpha(subtag);

bool _isCorrectRegion(String subtag) {
  try {
    Region(subtag);
  } catch (e) {
    return false;
  }
  return true;
}

bool _isCorrectVariant(String subtag) =>
    /* subtag != null && */
    ((subtag.length > 4 && subtag.length < 9) ||
        (subtag.length == 4 && onlyContainsDigits(subtag[0])));

// Todo check values in a better way
class LanguageTag {
  final String language;
  final String extlang;
  final String script;
  final Region? region;
  final String variant;

  //Todo missing extension and private use

  const LanguageTag._(this.language,
      {String? extlang, String? script, this.region, String? variant})
      : extlang = extlang ?? '',
        script = script ?? '',
        variant = variant ?? '';

  factory LanguageTag(String language,
      {String? extlang, String? script, String? region, String? variant}) {
    var _language = language.toLowerCase();
    if (!_isCorrectLanguage(_language)) {
      throw ArgumentError('Incorrect language subtag "$_language"');
    }
    var _extlang = extlang?.toLowerCase() ?? '';
    if (_extlang.isNotEmpty && !_isCorrectExtlang(_extlang)) {
      throw ArgumentError('Incorrect extlang subtag "$_extlang"');
    }
    var _script = unfilled(script) ? '' : capitalizeAndLowercase(script!);
    if (_script.isNotEmpty && !_isCorrectScript(_script)) {
      throw ArgumentError('Incorrect script subtag "$_script"');
    }
    // tries to construct a Region to test if the code is correct
    Region? _region;
    if (filled(region)) {
      _region = Region(region!);
    }

    var _variant = variant?.toLowerCase() ?? '';
    if (_variant.isNotEmpty && !_isCorrectVariant(_variant)) {
      throw ArgumentError('Incorrect variant subtag "$_variant"');
    }
    var languageTag = LanguageTag._(_language,
        extlang: _extlang, script: _script, region: _region, variant: _variant);
    if (_existingLocales.containsKey(languageTag.code)) {
      return _existingLocales[languageTag.code]!;
    }
    _existingLocales[languageTag.code] = languageTag;
    return languageTag;
  }

  factory LanguageTag.parse(String languageTag) {
    if (unfilled(languageTag)) {
      throw ArgumentError('Invalid language tag to be parsed (null or blank)');
    }
    var subtags = languageTag.split(RegExp(r'[-_]'));
    var language = '';
    var extlang = '';
    var script = '';
    var region = '';
    var variant = '';
    var insertionIndex = 0;

    for (var subtag in subtags) {
      if (insertionIndex == 0) {
        if (_isCorrectLanguage(subtag)) {
          language = subtag;
          insertionIndex++;
          continue;
        } else {
          throw ArgumentError('Incorrect language subtag $subtag');
        }
      }
      if (insertionIndex == 1) {
        insertionIndex++;
        if (_isCorrectExtlang(subtag)) {
          extlang = subtag;
          continue;
        }
      }
      if (insertionIndex == 2) {
        insertionIndex++;
        if (_isCorrectScript(subtag)) {
          script = subtag;
          continue;
        }
      }
      if (insertionIndex == 3) {
        insertionIndex++;
        if (_isCorrectRegion(subtag)) {
          region = subtag;
          continue;
        }
      }
      if (insertionIndex == 4) {
        insertionIndex++;
        if (_isCorrectVariant(subtag)) {
          variant = subtag;
          continue;
        }
      }
      throw ArgumentError('Incorrect subtag $subtag');
    }

    return LanguageTag(language,
        extlang: extlang, script: script, region: region, variant: variant);
  }

  factory LanguageTag.fromJson(String jsonCode) => LanguageTag.parse(jsonCode);

  @override
  bool operator ==(other) {
    return other is LanguageTag &&
        language == other.language &&
        extlang == other.extlang &&
        script == other.script &&
        region == other.region &&
        variant == other.variant;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;

  String toJson() => code;

  bool get canBeTruncated =>
      region != null ||
      variant.isNotEmpty ||
      script.isNotEmpty ||
      extlang.isNotEmpty;

  LanguageTag get truncated {
    if (variant.isNotEmpty) {
      return LanguageTag(language,
          extlang: extlang, script: script, region: region?.code ?? '');
    } else if (region != null) {
      return LanguageTag(language, extlang: extlang, script: script);
    } else if (script.isNotEmpty) {
      return LanguageTag(language, extlang: extlang);
    } else if (extlang.isNotEmpty) {
      return LanguageTag(language);
    }
    throw StateError('Cannot truncate the current locale code ("$code")');
  }

  List<String> get normalizedValuesList => <String>[
        language,
        if (extlang.isNotEmpty) extlang,
        if (script.isNotEmpty) script,
        if (region != null) region!.code,
        if (variant.isNotEmpty) variant
      ];

  /// List of subtags in presentation order
  /// Exclude variants and ext languages
  List<String> get icuValuesList => <String>[
        language,
        if (script.isNotEmpty) script,
        if (region != null) region!.code,
      ];

  /// List of subtags in presentation order
  /// Exclude script, variants and ext languages
  List<String> get posixValuesList => <String>[
        language,
        if (region != null) region!.code,
      ];

  List<String> get simpleValuesList => <String>[
        language,
        if (extlang.isNotEmpty) extlang,
        if (script.isNotEmpty) script.toLowerCase(),
        if (region != null) region!.simpleCode,
        if (variant.isNotEmpty) variant
      ];

  /// List of lowercase subtags in presentation order.
  /// Exclude variants and ext languages
  List<String> get icuSimpleValuesList => <String>[
        language,
        if (script.isNotEmpty) script.toLowerCase(),
        if (region != null) region!.simpleCode,
      ];

  /// List of lowercase subtags in presentation order.
  /// Exclude script, variants and ext languages
  List<String> get posixSimpleValuesList => <String>[
        language,
        if (region != null) region!.simpleCode,
      ];

  /// At present this method simply returns subtags separated by underscores
  /// instead of hyphens
  String get posixCode => posixValuesList.join(charUnderscore);

  /// At present this method simply returns lowercase subtags separated
  /// by underscores instead of hyphens
  String get lowercasePosix => posixSimpleValuesList.join(charUnderscore);

  /// At present this method simply returns subtags separated by underscores
  /// instead of hyphens and exclude variants and extended languages
  String get icuCode => icuValuesList.join(charUnderscore);

  /// At present this method simply returns lowercase subtags separated
  /// by underscores instead of hyphens and exclude variants and ext languages
  String get lowercaseIcu => icuSimpleValuesList.join(charUnderscore);

  String get code => normalizedValuesList.join(charHyphen);
  String get lowercaseCode => simpleValuesList.join(charHyphen);

  @Deprecated('use lowercaseCode')
  String get simpleCode => simpleValuesList.join(charHyphen);
}
