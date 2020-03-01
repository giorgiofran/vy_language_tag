/// Copyright © 2020 Giorgio Franceschetti. All rights reserved.

import 'package:vy_language_tag/src/subtags/region.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Region region;

    setUp(() {});

    test('Create Region (two chars)', () {
      region = Region('Us');
      expect(region.code, 'US');
      expect(region.simpleCode, 'us');
    });

    test('Create Region (three digits)', () {
      region = Region('419');
      expect(region.code, '419');
      expect(region.simpleCode, '419');
    });

    test('Create Region (errors)', () {
      expect(() => Region(null), throwsArgumentError);
      expect(() => Region(''), throwsArgumentError);
      expect(() => Region('r'), throwsArgumentError);
      expect(() => Region('r1'), throwsArgumentError);
      expect(() => Region('_t'), throwsArgumentError);
      expect(() => Region(' Z'), throwsArgumentError);
      expect(() => Region('HAL'), throwsArgumentError);
      expect(() => Region('9000'), throwsArgumentError);
      expect(() => Region('H12'), throwsArgumentError);
      expect(() => Region('1-2'), throwsArgumentError);
      expect(() => Region('2 3'), throwsArgumentError);
    });

    test('verify single class per region', () {
      region = Region('gb');
      expect(identical(region, Region('GB')), isTrue);
      expect(region == Region('GB'), isTrue);
      expect(region == Region('US'), isFalse);
    });
  });
}
