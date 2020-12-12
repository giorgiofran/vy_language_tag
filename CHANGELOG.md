# Changelog

## 0.2.0-nullsafety

- Moved to null-safety
- Change: The language value in LanguageTag constructor cannot be null
- Created simple conversion methods to ICU code and updated those to POSIX. These are simple conversion methods that consider only the portion of codes (language, region and script) that are generally compatible and exclude the others. This does not mean that a code valid in BCP 47 is also a valid POSIX or ICU one. No check is done.

## 0.1.5

- Small fixes

## 0.1.4

- Updated copyrights

## 0.1.3

- Prepared example and README files for pub.
- Corrected some Lint warnings

## 0.1.2

- Added Methods toJson() and fromJson() to LanguageTag class.
- Added Methods toJson() and fromJson() to Region class.

## 0.1.1

- Deprecated "simpleCode()" method
- Added "lowercaseCode()" method (substitutes "simpleCode()")
- Added "lowercasePosix()" method (lowercase subtags separated by underscores).

## 0.1.0

- Initial version
