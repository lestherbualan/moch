class Load {
  final int id;
  final String recipient;
  final String body;
  final num isPaid;
  final num value;
  final String createdAt;

  Load(
      {this.id,
      this.recipient,
      this.body,
      this.isPaid,
      this.value,
      this.createdAt});
}

class Graph {
  int value;
  String createdAt;

  Graph(this.value, this.createdAt);
}
