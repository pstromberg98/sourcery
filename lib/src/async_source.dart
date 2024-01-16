import 'dart:async';

import 'package:sourcery/sourcery.dart';

/// Function that wraps the underlying source.
typedef AsyncSourceFn<T> = Future<T> Function();

/// {@template change_source}
/// Reactive object for async sources that change
/// {@endtemplate}
class AsyncSource<T> extends Source<T> {
  /// {@macro change_source}
  AsyncSource({
    required AsyncSourceFn<T> sourceFn,
    required T initialValue,
    bool sourceImmediately = true,
  })  : _sourceFn = sourceFn,
        _value = initialValue {
    _value = initialValue;
    if (sourceImmediately) {
      refresh();
    }
  }

  final AsyncSourceFn<T> _sourceFn;

  @override
  Stream<T> get updates => _updatesController.stream;
  final _updatesController = StreamController<T>.broadcast();

  @override
  T get value => _value;
  T _value;

  // currentAndUpdates
  // updates
  // current
  // loadAndUpdates
  // currentLoadAndUPdates

  /// Refreshes source by calling source function.
  Future<T> refresh() {
    return _sourceFn().then((value) {
      _value = value;
      _updatesController.add(value);
      return value;
    });
  }

  /// Changes source value to [newValue] and notifys listeners
  void mutate(T newValue) {
    _value = newValue;
    _updatesController.add(newValue);
  }
}

typedef AsyncFamilySourceFn<R, T> = Future<T> Function(R param);

class AsyncSourceFamily<R, T> {
  final Map<R, AsyncSource<T>> _asyncSources = {};

  AsyncSourceFamily({
    required this.sourceFn,
    required this.initialValue,
  });

  final AsyncFamilySourceFn<R, T> sourceFn;
  final T initialValue;

  AsyncSource<T> _getOrCreate(R key) {
    if (_asyncSources.containsKey(key)) {
      return _asyncSources[key]!;
    }

    final asyncSource = AsyncSource(
      sourceFn: () => sourceFn(key),
      initialValue: initialValue,
    );
    _asyncSources[key] = asyncSource;
    return asyncSource;
  }

  AsyncSource<T> call(R key) => _getOrCreate(key);
}
