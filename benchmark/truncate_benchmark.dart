// Import BenchmarkBase class.
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:truncate/truncate.dart';

List<String> getTestStrings() =>
    (['hi-diddly-ho there, neighborino', 'test', '']);

// Create a new benchmark by extending BenchmarkBase
class TruncateTemplateBenchmark extends BenchmarkBase {
  List<String> testStrings;

  TruncateTemplateBenchmark(String name) : super(name);

  @override
  void setup() {
    testStrings = getTestStrings();
  }
}

class TruncateShortenEndBenchmark extends BenchmarkBase {
  List<String> testStrings = getTestStrings();
  TruncateShortenEndBenchmark() : super('TruncateShortenEndBenchmark');

  @override
  void run() {
    for (String text in testStrings) {
      truncator(text, 10, ShortenStrategy(position: TruncatePosition.end));
    }
  }
}

class TruncateShortenStartBenchmark extends BenchmarkBase {
  List<String> testStrings = getTestStrings();
  TruncateShortenStartBenchmark() : super('TruncateShortenStartBenchmark');

  @override
  void run() {
    for (String text in testStrings) {
      truncator(text, 10, ShortenStrategy(position: TruncatePosition.start));
    }
  }
}

class TruncateShortenMiddleBenchmark extends BenchmarkBase {
  List<String> testStrings = getTestStrings();
  TruncateShortenMiddleBenchmark() : super('TruncateShortenMiddleBenchmark');

  @override
  void run() {
    for (String text in testStrings) {
      truncator(text, 10, ShortenStrategy(position: TruncatePosition.middle));
    }
  }
}

main() {
  TruncateShortenEndBenchmark().report();
  TruncateShortenStartBenchmark().report();
  TruncateShortenMiddleBenchmark().report();
}
