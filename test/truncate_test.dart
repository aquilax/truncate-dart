import 'package:truncate/truncate.dart';
import 'package:test/test.dart';

class TestCase {
  String name;
  String text;
  int maxLength;
  String expected;
  TestCase(this.name, this.text, this.maxLength, this.expected);
}

class StrategyCases {
  TruncateStrategy strategy;
  List<TestCase> testCases;
  StrategyCases(this.strategy, this.testCases);
}

void main() {
  group('Test Truncating strategies', () {
    var cases = [
      StrategyCases(CutStrategy(), [
        TestCase('works with shorter strings', 'те', 10, 'те'),
        TestCase('works with exact size strings', 'тест', 4, 'тест'),
        TestCase('works with ansi strings', 'test', 3, 'tes'),
        TestCase('works with utf8 strings', 'тест', 3, 'тес'),
      ]),
      StrategyCases(
        OmissionShortenStrategy(position: TruncatePosition.end),
        [
          TestCase('works with shorter strings', 'те', 10, 'те'),
          TestCase('works with exact size strings', 'тест', 4, 'тест'),
          TestCase('works with ansi strings', 'test', 3, 'te…'),
          TestCase('works with utf8 strings', 'тест', 3, 'те…'),
        ],
      ),
      StrategyCases(
        OmissionShortenStrategy(position: TruncatePosition.start),
        [
          TestCase('works with shorter strings', 'те', 10, 'те'),
          TestCase('works with exact size strings', 'тест', 4, 'тест'),
          TestCase('works with ansi strings', 'test', 3, '…st'),
          TestCase('works with utf8 strings', 'тест', 3, '…ст'),
        ],
      ),
      StrategyCases(
        OmissionShortenStrategy(position: TruncatePosition.middle),
        [
          TestCase('works with shorter strings', 'те', 10, 'те'),
          TestCase('works with exact size strings', 'тест', 4, 'тест'),
          TestCase('works with ansi strings', 'test', 3, 't…t'),
          TestCase('works with utf8 strings', 'тест', 3, 'т…т'),
          TestCase('works with loner strings off cut', 'testttest', 5, 'te…st'),
          TestCase('works with loner strings even cut', 'testttest', 4, 't…st'),
        ],
      ),
      StrategyCases(
          OmissionShortenStrategy(
              position: TruncatePosition.middle, omission: '....'),
          [
            TestCase('works with long omission strings', 'теста', 4, '....'),
          ]),
    ];

    for (var strategyCase in cases) {
      for (var testCase in strategyCase.testCases) {
        test(testCase.name, () {
          var result = truncator(
              testCase.text, testCase.maxLength, strategyCase.strategy);
          expect(result, equals(testCase.expected), reason: testCase.name);
        });
      }
    }
  });
}
