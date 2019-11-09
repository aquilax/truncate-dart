import 'package:truncate/truncate.dart';

const DEFAULT_OMISSION = '…';

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

/// OmissionShortenStrategy truncates text up to the maxLength using position and omission
class OmissionShortenStrategy implements TruncateStrategy {
  var omission;
  var position;

  OmissionShortenStrategy({this.omission = DEFAULT_OMISSION, this.position = TruncatePosition.end});

  String doTruncate(String text, int maxLength) =>
    truncate(text, maxLength, omission: this.omission, position: this.position);
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

String _truncateMiddle(String text, int maxLength, String omission) {
  final int omissionLength = omission.length;
  final int delta = text.length % 2 == 0
      ? ((maxLength - omissionLength) / 2).ceil()
      : ((maxLength - omissionLength) / 2).floor();
  return text.substring(0, delta) +
      omission +
      text.substring(text.length - maxLength + omissionLength + delta);
}
