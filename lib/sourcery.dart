/// Reactive Magic
library sourcery;

import 'package:sourcery/sourcery.dart';

export 'src/sourcery.dart';

void main() {
  final Source<int?> source = AsyncSource(
    sourceFn: () => Future.value(1),
    initialValue: null,
  );
}
