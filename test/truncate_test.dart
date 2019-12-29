import 'package:truncate/truncate.dart';
import 'package:test/test.dart';

void main() {
  group('Test Truncating strategies', () {
    var makeCase = (name, text, maxLength, expected) => ({
          'name': name,
          'text': text,
          'maxLength': maxLength,
          'expected': expected,
        });

    var cases = [
      {
        'strategy': CutStrategy(),
        'cases': [
          makeCase('works with shorter strings', 'те', 10, 'те'),
          makeCase('works with exact size strings', 'тест', 4, 'тест'),
          makeCase('works with ansi strings', 'test', 3, 'tes'),
          makeCase('works with utf8 strings', 'тест', 3, 'тес'),
        ]
      },
      {
        'strategy': OmissionShortenStrategy(position: TruncatePosition.end),
        'cases': [
          makeCase('works with shorter strings', 'те', 10, 'те'),
          makeCase('works with exact size strings', 'тест', 4, 'тест'),
          makeCase('works with ansi strings', 'test', 3, 'te…'),
          makeCase('works with utf8 strings', 'тест', 3, 'те…'),
        ],
      },
      {
        'strategy': OmissionShortenStrategy(position: TruncatePosition.start),
        'cases': [
          makeCase('works with shorter strings', 'те', 10, 'те'),
          makeCase('works with exact size strings', 'тест', 4, 'тест'),
          makeCase('works with ansi strings', 'test', 3, '…st'),
          makeCase('works with utf8 strings', 'тест', 3, '…ст'),
        ],
      },
      {
        'strategy': OmissionShortenStrategy(position: TruncatePosition.middle),
        'cases': [
          makeCase('works with shorter strings', 'те', 10, 'те'),
          makeCase('works with exact size strings', 'тест', 4, 'тест'),
          makeCase('works with ansi strings', 'test', 3, 't…t'),
          makeCase('works with utf8 strings', 'тест', 3, 'т…т'),
          makeCase('works with loner strings off cut', 'testttest', 5, 'te…st'),
          makeCase('works with loner strings even cut', 'testttest', 4, 't…st'),
        ],
      },
      {
        'strategy': OmissionShortenStrategy(
            position: TruncatePosition.middle, omission: '....'),
        'cases': [
          makeCase('works with long omission strings', 'теста', 4, '....'),
        ]
      },
    ];

    for (var strategCase in cases) {
      for (var testCase in strategCase['cases']) {
        test(testCase['name'], () {
          var result = truncator(
              testCase['text'], testCase['maxLength'], strategCase['strategy']);
          expect(result, equals(testCase['expected']),
              reason: testCase['name']);
        });
      }
    }
  });
}
