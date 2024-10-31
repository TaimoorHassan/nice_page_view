import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nice_page_view/bracket_item.dart';
import 'package:nice_page_view/static_bracket_data.dart';

class MatchBrackets extends StatefulWidget {
  const MatchBrackets({super.key, required this.columnWidth});
  final double columnWidth;

  @override
  State<MatchBrackets> createState() => _MatchBracketsState();
}

class _MatchBracketsState extends State<MatchBrackets> {
  @override
  void initState() {
    super.initState();

    _horizontalScrollCOntroller.addListener(() {
      setState(() {});
    });
   
  }

  final _horizontalScrollCOntroller = ScrollController();


  ///
  /// This will be used to determine a columns distance from the center of attention (center or an offset)
  ///
  double get safeOffset {
    try {
      return _horizontalScrollCOntroller.offset;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = bracketData;
    var size = MediaQuery.of(context).size;

    double visibilityStartsFromPage = safeOffset / widget.columnWidth;
    var visibilityOffset = Offset(safeOffset, safeOffset + size.width);

    print(visibilityStartsFromPage);

    ///
    /// A Fresh Attempt
    ///
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragUpdate: (x) {
            _horizontalScrollCOntroller.jumpTo(safeOffset + (x.delta.dx * -1));
          },
          onHorizontalDragEnd: (details) {
            var offset = _horizontalScrollCOntroller.offset;
            // snap it to the nearest column
            var columnWidth = widget.columnWidth;
            var nearestColumn = (offset / columnWidth).round();
            var _nearestSnappableScrollOffset = nearestColumn * columnWidth;

            ///
            /// This piece is quite critical because it allows a number of pixels from previous page
            /// to still be visible as a result of scrolling one or multiple pages
            ///
            _nearestSnappableScrollOffset -= 20;
            _horizontalScrollCOntroller.animateTo(_nearestSnappableScrollOffset, duration: Duration(milliseconds: 300), curve: Curves.ease);
          },

          dragStartBehavior: DragStartBehavior.start,
          behavior: HitTestBehavior.deferToChild,
          child: SingleChildScrollView(
            hitTestBehavior: HitTestBehavior.deferToChild,
            physics: const NeverScrollableScrollPhysics(),
            controller: _horizontalScrollCOntroller,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(data.length, (index) {
                  var stage = data[index];
                  var fights = stage['fights'] as List;
                  return PureColumn(
                    offset: safeOffset,
                    centerPoint: safeOffset + (size.width / 2),
                    name: stage['name'].toString(),
                    columnWidth: widget.columnWidth,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ...List.generate(
                            fights.length,
                            (x) {
                              return BracketItem(
                                data: fights[x],
                                column: index,
                                row: x,
                                centerPoint: safeOffset,
                                visibleColumn: visibilityStartsFromPage,
                                columnWidth: widget.columnWidth,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PureColumn extends StatelessWidget {
  const PureColumn({super.key, required this.name, required this.child, required this.columnWidth, required this.centerPoint, required this.offset});
  final String name;
  final Widget child;
  final double columnWidth;
  final double centerPoint;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: columnWidth,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // Added 1 for aesthetics
              name.toString(),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class InPageWidget extends StatelessWidget {
  const InPageWidget({
    super.key,
    required this.page,
    required this.index,
    required this.itemsToShow,
    required this.fights,
    required this.totalStages,
  });
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
        height: (page_height + max((_value - 1), 0) * _itemHeight) * _pageSizeMultiplier,
        child: Row(
          children: [
            if (index > 0)
              Container(
                  width: 20,
                  child: Column(
                    children: [],
                  )),
            Expanded(
              child: Stack(
                children: [
                  ...List.generate(
                    fights.length,
                    (_localIndex) => Positioned(
                      left: 0,
                      right: 0,
                      top: (max((_value - 1), 0) * _itemHeight) + _localIndex * _itemHeight,
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
