import 'dart:io';

import 'package:bompare/persistence/parser/jk1_result_parser.dart';
import 'package:bompare/persistence/persistence_exception.dart';
import 'package:bompare/service/domain/item_id.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('$Jk1ResultParser', () {
    const license = 'License';
    final resourcePath = path.join('test', 'resources');
    final jk1File = File(path.join(resourcePath, 'jk1.json'));
    final lorumFile = File(path.join(resourcePath, 'testfile.txt'));
    final itemId1 = ItemId('component_1', 'v_1');
    final itemId2 = ItemId('component_2', 'v_2');

    final mapper = {'key': license};
    final parser = Jk1ResultParser(mapper);

    test('parses from file', () async {
      final result = await parser.parse(jk1File);

      expect(result.items, containsAll([itemId1, itemId2]));
    });

    test('converts licenses using mapper', () async {
      final result = await parser.parse(jk1File);

      expect(result.items.lookup(itemId1).licenses, contains('"my_license"'));
      expect(result.items.lookup(itemId2).licenses, contains(license));
    });

    test('throws when file does not exist', () {
      expect(
          () => parser.parse(File('unknown_file')),
          throwsA(predicate<PersistenceException>(
              (e) => e.toString().contains('not found'))));
    });

    test('throws for malformed file', () {
      expect(
          () => parser.parse(lorumFile),
          throwsA(predicate<PersistenceException>(
              (e) => e.toString().contains('Unexpected format'))));
    });
  });
}
