import 'package:vy_language_tag/vy_language_tag.dart';

void main() {
  var languageTag = LanguageTag('en');
  print(languageTag.code);             // 'en'
  print(languageTag.posixCode);        // 'en'
  print(languageTag.lowercaseCode);    // 'en'
  print(languageTag.lowercasePosix);   // 'en'

  languageTag = LanguageTag('en', region: 'US');
  print(languageTag.code);             // 'en-US'
  print(languageTag.posixCode);        // 'en_US'
  print(languageTag.lowercaseCode);    // 'en-us'
  print(languageTag.lowercasePosix);   // 'en_us'

  languageTag = LanguageTag('zh', script: 'hant', region: 'hk');
  print(languageTag.code);             // 'zh-Hant-HK');
  print(languageTag.posixCode);        // 'zh_Hant_HK');
  print(languageTag.lowercaseCode);    // 'zh-hant-hk');
  print(languageTag.lowercasePosix);   // 'zh_hant_hk');

  languageTag = LanguageTag.parse('en-us');
  print(languageTag.posixCode);        // 'en_US');

  languageTag = LanguageTag.parse('de_CH_1901');
  print(languageTag.code);             // 'de-CH-1901'
}
