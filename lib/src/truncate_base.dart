const DEFAULT_OMISSION = '…';

/// Truncation position
enum TruncatePosition { start, middle, end }

/// Abstract class for string truncation strategy
abstract class TruncateStrategy {
  String doTruncate(String text, int maxLength);
}

/// truncates text to maximum length using the selected strategy
String truncator(String text, int maxLength, TruncateStrategy strategy) =>
    strategy.doTruncate(text, maxLength);

/// CutStrategy cuts the string to the maximum length
class CutStrategy implements TruncateStrategy {
  String doTruncate(String text, int maxLength) =>
      text.length <= maxLength ? text : text.substring(0, maxLength);
}

/// CutEllipsisStrategy simply truncates the string to the desired length and adds ellipsis at the end
class CutEllipsisStrategy implements TruncateStrategy {
  String doTruncate(String text, int maxLength) => truncate(text, maxLength);
}

/// CutEllipsisLeadingStrategy simply truncates the string from the start the desired length and adds ellipsis at the front
class CutEllipsisLeadingStrategy implements TruncateStrategy {
  String doTruncate(String text, int maxLength) =>
      truncate(text, maxLength, position: TruncatePosition.start);
}

/// EllipsisMiddleStrategy truncates the string to the desired length and adds ellipsis in the middle
class EllipsisMiddleStrategy implements TruncateStrategy {
  String doTruncate(String text, int maxLength) =>
      truncate(text, maxLength, position: TruncatePosition.middle);
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
