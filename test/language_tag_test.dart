/// Copyright © 2020 Giorgio Franceschetti. All rights reserved.

import 'package:vy_language_tag/src/subtags/region.dart';
import 'package:vy_language_tag/src/language_tag.dart';
import 'package:test/test.dart';

void main() {
  group('Creation', () {
    LanguageTag localeCode;

    setUp(() {});

    test('Minimal', () {
      localeCode = LanguageTag('EN');
      expect(localeCode.posixCode, 'en');
      expect(localeCode.icuCode, 'en');
      expect(localeCode.code, 'en');
      expect(localeCode.lowercaseCode, 'en');
      expect(localeCode.posixCode, 'en');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, isNull);
      expect(localeCode.variant, isEmpty);
    });
    test('Extended Language', () {
      localeCode = LanguageTag('zH', extlang: 'YuE');
      expect(localeCode.posixCode, 'zh');
      expect(localeCode.icuCode, 'zh');
      expect(localeCode.code, 'zh-yue');
      expect(localeCode.lowercaseCode, 'zh-yue');
      expect(localeCode.language, 'zh');
      expect(localeCode.extlang, 'yue');
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, isNull);
      expect(localeCode.variant, isEmpty);
    });
    test('Script', () {
      localeCode = LanguageTag('az', script: 'latn');
      expect(localeCode.posixCode, 'az');
      expect(localeCode.icuCode, 'az_Latn');
      expect(localeCode.code, 'az-Latn');
      expect(localeCode.lowercaseIcu, 'az_latn');
      expect(localeCode.lowercaseCode, 'az-latn');
      expect(localeCode.language, 'az');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, 'Latn');
      expect(localeCode.region, isNull);
      expect(localeCode.variant, isEmpty);
    });
    test('Region - regular', () {
      localeCode = LanguageTag('it', region: 'it');
      expect(localeCode.posixCode, 'it_IT');
      expect(localeCode.icuCode, 'it_IT');
      expect(localeCode.code, 'it-IT');
      expect(localeCode.lowercaseCode, 'it-it');
      expect(localeCode.language, 'it');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, Region('IT'));
      expect(localeCode.variant, isEmpty);
    });
    test('Region - Macro area (Spanish_South America)', () {
      localeCode = LanguageTag('es', region: '005');
      expect(localeCode.posixCode, 'es_005');
      expect(localeCode.icuCode, 'es_005');
      expect(localeCode.code, 'es-005');
      expect(localeCode.lowercaseCode, 'es-005');
      expect(localeCode.language, 'es');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, Region('005'));
      expect(localeCode.variant, isEmpty);
    });

    test('Region with script (Tradition Chinese in Hong-Kong)', () {
      localeCode = LanguageTag('zh', script: 'hant', region: 'hk');
      expect(localeCode.posixCode, 'zh_HK');
      expect(localeCode.icuCode, 'zh_Hant_HK');
      expect(localeCode.code, 'zh-Hant-HK');
      expect(localeCode.lowercaseCode, 'zh-hant-hk');
      expect(localeCode.language, 'zh');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, 'Hant');
      expect(localeCode.region, Region('HK'));
      expect(localeCode.variant, isEmpty);
    });
    test('Variant (the Nadiza dialect of Slovenian)', () {
      localeCode = LanguageTag('sl', variant: 'nedis');
      expect(localeCode.posixCode, 'sl');
      expect(localeCode.icuCode, 'sl');
      expect(localeCode.code, 'sl-nedis');
      expect(localeCode.lowercaseCode, 'sl-nedis');
      expect(localeCode.language, 'sl');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, isNull);
      expect(localeCode.variant, 'nedis');
    });
    test(
        'Regional Variant '
        '(the Nadiza dialect of Slovenian that is spoken in Italy)', () {
      localeCode = LanguageTag('sl', variant: 'nedis', region: 'it');
      expect(localeCode.posixCode, 'sl_IT');
      expect(localeCode.icuCode, 'sl_IT');
      expect(localeCode.code, 'sl-IT-nedis');
      expect(localeCode.lowercaseCode, 'sl-it-nedis');
      expect(localeCode.lowercasePosix, 'sl_it');
      expect(localeCode.lowercaseIcu, 'sl_it');
      expect(localeCode.language, 'sl');
      expect(localeCode.extlang, isEmpty);
      expect(localeCode.script, isEmpty);
      expect(localeCode.region, Region('IT'));
      expect(localeCode.variant, 'nedis');
    });

    test('Truncation', () {
      localeCode = LanguageTag('en');
      expect(localeCode.canBeTruncated, isFalse);
      localeCode = LanguageTag('sl', variant: 'nedis', region: 'it');
      expect(localeCode.canBeTruncated, isTrue);
      localeCode = localeCode.truncated;
      expect(localeCode, LanguageTag('sl', region: 'it'));
      localeCode = localeCode.truncated;
      expect(localeCode, LanguageTag('sl'));
      expect(localeCode.canBeTruncated, isFalse);
      expect(() => localeCode.truncated, throwsStateError);
    });

    test('Parse', () {
      expect(LanguageTag.parse('en'), LanguageTag('en'));
      expect(LanguageTag.parse('en_US'), LanguageTag('en', region: 'US'));
      expect(LanguageTag.parse('en-US'), LanguageTag('en', region: 'US'));
      expect(LanguageTag.parse('en-us'), LanguageTag('en', region: 'US'));
      expect(LanguageTag.parse('zh-yue'), LanguageTag('zH', extlang: 'YuE'));
      expect(LanguageTag.parse('ZH_YUE'), LanguageTag('zH', extlang: 'YuE'));
      expect(LanguageTag.parse('az_latn'), LanguageTag('az', script: 'Latn'));
      expect(LanguageTag.parse('es_005'), LanguageTag('es', region: '005'));
      expect(LanguageTag.parse('zh-hant-HK'),
          LanguageTag('zh', script: 'hant', region: 'hk'));
      expect(LanguageTag.parse('sl_IT-nedis'),
          LanguageTag('sl', variant: 'nedis', region: 'it'));
      expect(LanguageTag.parse('de-CH-1901'),
          LanguageTag('de', variant: '1901', region: 'ch'));
    });

    test('Parse error', () {
      //expect(() => LanguageTag.parse(null), throwsArgumentError);
      expect(() => LanguageTag.parse(''), throwsArgumentError);
      expect(() => LanguageTag.parse('en1'), throwsArgumentError);
      expect(() => LanguageTag.parse('e'), throwsArgumentError);
      expect(() => LanguageTag.parse('engl'), throwsArgumentError);
      expect(() => LanguageTag.parse('en US'), throwsArgumentError);
      expect(() => LanguageTag.parse('en/US'), throwsArgumentError);
      expect(() => LanguageTag.parse('en-US1'), throwsArgumentError);
      expect(() => LanguageTag.parse('en1-us'), throwsArgumentError);
      expect(() => LanguageTag.parse('zh-y1e'), throwsArgumentError);
      expect(() => LanguageTag.parse('Z1H_YUE'), throwsArgumentError);
      expect(() => LanguageTag.parse('az_latn_'), throwsArgumentError);
      expect(() => LanguageTag.parse('latn_az'), throwsArgumentError);
      expect(() => LanguageTag.parse('es_r005'), throwsArgumentError);
      expect(() => LanguageTag.parse('es_19'), throwsArgumentError);
      expect(() => LanguageTag.parse('zh-ha-HK'), throwsArgumentError);
      expect(() => LanguageTag.parse('sl-nedis_IT'), throwsArgumentError);
      expect(() => LanguageTag.parse('sl-it-nedi'), throwsArgumentError);
      expect(() => LanguageTag.parse('de-CH-190'), throwsArgumentError);
    });
  });
}
