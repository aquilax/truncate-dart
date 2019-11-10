import 'package:truncate/truncate.dart';

/// The default omission string is  ellipsis
const DEFAULT_OMISSION = '…';

/// The default text terminator is whitespace
var DEFAULT_TERMINATOR = RegExp(r'\s');

/// Truncation position
enum TruncatePosition { start, middle, end }

/// Abstract class for string truncation strategy
abstract class TruncateStrategy {
  String doTruncate(String text, int maxLength);
}

/// Truncates text to maximum length using the selected strategy
String truncator(String text, int maxLength, TruncateStrategy strategy) =>
    strategy.doTruncate(text, maxLength);

/// CutStrategy cuts the string to the maximum length
class CutStrategy implements TruncateStrategy {
  String doTruncate(String text, int maxLength) =>
      text.length <= maxLength ? text : text.substring(0, maxLength);
}

/// ShortenStrategy truncates text up to the maxLength using position and omission
class ShortenStrategy implements TruncateStrategy {
  final String omission;
  final TruncatePosition position;

  ShortenStrategy(
      {this.omission = DEFAULT_OMISSION, this.position = TruncatePosition.end});

  String doTruncate(String text, int maxLength) =>
      truncate(text, maxLength, omission: omission, position: position);
}

/// ShortenStrategy truncates text up to the maxLength using position and omission
class ShortenWordStrategy implements TruncateStrategy {
  final String omission;
  final TruncatePosition position;
  RegExp terminator;

  ShortenWordStrategy(
      {this.omission = DEFAULT_OMISSION,
      this.position = TruncatePosition.end,
      terminator})
      : terminator = terminator ?? DEFAULT_TERMINATOR;

  String doTruncate(String text, int maxLength) => truncateWord(text, maxLength,
      omission: omission, position: position, terminator: terminator);
}

/// Returns truncated string up to the maxLength at the selected position using the omission string
String truncate(String text, int maxLength,
    {String omission = DEFAULT_OMISSION,
    TruncatePosition position = TruncatePosition.end}) {
  if (text.length <= maxLength) {
    return text;
  }
  switch (position) {
    case TruncatePosition.start:
      return omission +
          text.substring(text.length - maxLength + omission.length);
    case TruncatePosition.middle:
      return _truncateMiddle(text, maxLength, omission);
    default:
      return text.substring(0, maxLength - omission.length) + omission;
  }
}

/// Returns truncated string up to the maxLength at the selected position using the omission string
/// and breaking only at the terminator position (by default whitespace)
String truncateWord(String text, int maxLength,
    {String omission = DEFAULT_OMISSION,
    TruncatePosition position = TruncatePosition.end,
    RegExp terminator}) {
  terminator = terminator ?? DEFAULT_TERMINATOR;
  if (text.length <= maxLength) {
    return text;
  }
  switch (position) {
    case TruncatePosition.start:
      return omission +
          text.substring(text.indexOf(
                  terminator, text.length - maxLength + omission.length) +
              1);
    case TruncatePosition.middle:
      return _truncateWordMiddle(text, maxLength, omission, terminator);
    default:
      return text.substring(
              0, text.lastIndexOf(terminator, maxLength - omission.length)) +
          omission;
  }
}

String _truncateMiddle(String text, int maxLength, String omission) {
  final int omissionLength = omission.length;
  final int delta = text.length % 2 == 0
      ? ((maxLength - omissionLength) / 2).ceil()
      : ((maxLength - omissionLength) / 2).floor();
  return text.substring(0, delta) +
      omission +
      text.substring(text.length - maxLength + omissionLength + delta);
}

String _truncateWordMiddle(
    String text, int maxLength, String omission, RegExp terminator) {
  final int omissionLength = omission.length;
  final int delta = text.length % 2 == 0
      ? ((maxLength - omissionLength) / 2).ceil()
      : ((maxLength - omissionLength) / 2).floor();
  String t = text.substring(0, text.lastIndexOf(terminator, delta)) + omission;
  return t +
      text.substring(
          text.indexOf(terminator, text.length - maxLength + t.length) + 1);
}
