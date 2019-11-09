import 'package:truncate/truncate.dart';

main() {
  var text = "This is a long text";
  var truncated =
      truncate(text, 17, omission: "...", position: TruncatePosition.end);
  print("${truncated} : ${truncated.length} characters");
  // Output: This is a long... : 17 characters

  truncated =
      truncate(text, 15, omission: "...", position: TruncatePosition.start);
  print("${truncated} : ${truncated.length} characters");
  // Output: ... a long text : 15 characters

  truncated =
      truncate(text, 5, omission: "zzz", position: TruncatePosition.middle);
  print("${truncated} : ${truncated.length} characters");
  // Output: Tzzzt : 5 characters

  truncated = truncator(text, 9, CutStrategy());
  print("${truncated} : ${truncated.length} characters");
  // Output: This is a : 9 characters
}
