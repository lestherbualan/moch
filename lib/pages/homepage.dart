import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moch/models/loadModel.dart';
import 'package:moch/utilities/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Graph> graph;
  var data;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    this.data = await DatabaseHelper.database.getValueForGraph();
    graph = data.map<Graph>((e) => Graph(e['value'], e['createdAt'])).toList();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                child: SfCartesianChart(
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<Graph, String>>[
                  LineSeries<Graph, String>(
                      // Bind data source
                      dataSource: this.graph,
                      xValueMapper: (Graph x, _) => x.createdAt,
                      yValueMapper: (Graph y, _) => y.value)
                ]));
          } else {
            return Text('hello');
          }
        },
      ),
    );
  }
}
