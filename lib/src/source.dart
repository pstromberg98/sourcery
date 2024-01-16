abstract class Source<T> {
  Stream<T> get updates;
  T get value;
}
