# Language Tag Representation

LanguageTag is a class used for generating and checking language tags.

It can create a language Tag given all the subtags that are part of it or parsing an existing languageTag String.

The implementation is not yet complete, but it should be enough for the majority of cases

### What is missing

- There is no control on the values inserted, except for the length (and position). This will be fixed in a future release.
- The extension and private use subtags are not managed yet.

#### License

[license](https://github.com/giorgiofran/vy_language_tag/issues/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:vy_language_tag/vy_language_tag.dart';

main() {
  var languageTag = LanguageTag('en', region: 'US');
  print(languageTag.code);   // 'en-US'
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/giorgiofran/vy_language_tag/issues
