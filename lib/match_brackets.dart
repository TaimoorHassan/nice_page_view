import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MatchBrackets extends StatefulWidget {
  const MatchBrackets({super.key});

  @override
  State<MatchBrackets> createState() => _MatchBracketsState();
}

class _MatchBracketsState extends State<MatchBrackets> {
  dynamic getMatchBracketData() {
    var ar = [];

    for (var j = 0; j < 10; j++) {
      var fights = [];

      for (var i = 0; i < 10 - j; i++) {
        var fight = {};
        fight["id"] = i;
        fight["name"] = "Fight $i";
        fight["stage"] = "Stage $j";

        fight['fighters'] = [
          {"name": "Fighter 1", "score": 10},
          {"name": "Fighter 2", "score": 5}
        ];

        fights.add(fight);
      }
      ar.add({"name": "Stage $j", "fights": fights});
    }

    ar.removeWhere((element) => element['fights'].length % 2 != 0 && element['fights'].length != 1);
    return ar;
  }

  var controller = PageController(viewportFraction: 0.9);

  double get safePage {
    try {
      return controller.page ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // pretty print this json
    var data = getMatchBracketData();
    // print(jsonEncode(data));
    // return Placeholder();

    

    ///
    /// A Fresh Attempt
    /// 
    
    return Scaffold(
      body: Text("Intented 2nd Draft"),
    );




    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: Transform.translate(
        offset: Offset(-100, 0),
        child: PageView.builder(
          itemCount: data.length,
          controller: controller,
          // scrollBehavior: MyCustomScrollBehavior(),
          itemBuilder: (context, index) {
            var stage = data[index];
        
            var fightsInThisStage = stage['fights'];
        
            return InPageWidget(
              page: safePage,
              index: index,
              itemsToShow: fightsInThisStage.length,
              fights: fightsInThisStage,
              totalStages: data.length,
            );
          },
        ),
      ),
    );
  }
}

class InPageWidget extends StatelessWidget {
  const InPageWidget({super.key, required this.page, required this.index, required this.itemsToShow, required this.fights, required this.totalStages});
  final double page;
  final int index;
  final int itemsToShow;
  final List fights;
  final int totalStages;

  @override
  Widget build(BuildContext context) {
    var _value = (index - page + 2) / 2;

    var _itemHeight = 150.0;

    var page_height = _itemHeight * itemsToShow;

    var _pageSizeMultiplier = _value > 1 ? 1 : _value;
    // get two decimal places
    _value = double.parse(_value.toStringAsFixed(2));
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height:(  page_height  + max((_value - 1), 0) * _itemHeight) * _pageSizeMultiplier,
        child: Row(
          children: [
            if (index > 0)
              Container(
                width: 20,
                child: Column(children: [],)
              ),
            Expanded(
              child: Stack(
                children: [
                  ...List.generate(
                    fights.length,
                    (_localIndex) => Positioned(
                      left: 0,
                      right: 0,
                      top : (max((_value - 1), 0) * _itemHeight) +  _localIndex * _itemHeight,
                      // top: _localIndex <= (fights.length /2).round() ? (max((_value - 1), 0) * _itemHeight) +  _localIndex * _itemHeight : null,
                      // bottom: _localIndex >= (fights.length /2).round() ? (max((_value - 1), 0) * _itemHeight) +  _localIndex * _itemHeight : null,
                      child: Container(
                          padding: EdgeInsets.all(3),
                          height: _itemHeight,
                          width: 100,
                          child: Card(
                            color: Colors.blue.withOpacity(0.04),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(fights[_localIndex]['name']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [CircleAvatar()],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
            if (index < 5)
              Container(
                width: 50,
              ),
          ],
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
