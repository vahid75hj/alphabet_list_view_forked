import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:alphabet_list_view/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class AlphabetList extends StatefulWidget {
  const AlphabetList({
    Key? key,
    required this.items,
    required this.scrollController,
    required this.symbolChangeNotifierList,
    required this.symbolChangeNotifierScrollbar,
    this.alphabetListOptions = const ListOptions(),
  }) : super(key: key);

  final List<AlphabetListViewItemGroup> items;
  final ScrollController scrollController;
  final SymbolChangeNotifier symbolChangeNotifierList;
  final SymbolChangeNotifier symbolChangeNotifierScrollbar;
  final ListOptions alphabetListOptions;

  @override
  State<AlphabetList> createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  late GlobalKey customScrollKey;

  late SliverChildBuilderDelegate d;

  @override
  void initState() {
    super.initState();
    customScrollKey = GlobalKey();
    widget.scrollController.addListener(_scrollControllerListener);
    widget.symbolChangeNotifierScrollbar
        .addListener(_symbolChangeNotifierScrollbarListener);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollControllerListener());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollControllerListener(),
    );

    return Padding(
      padding: widget.alphabetListOptions.padding ?? const EdgeInsets.all(.0),
      child: Container(
        color: widget.alphabetListOptions.backgroundColor,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: CustomScrollView(
            key: customScrollKey,
            controller: widget.scrollController,
            physics: widget.alphabetListOptions.physics,
            slivers: [
              if (widget.alphabetListOptions.sliverAppbar != null)
                widget.alphabetListOptions.sliverAppbar!,
              SliverToBoxAdapter(
                child: SizedBox(
                  height: widget.alphabetListOptions.topOffset,
                ),
              ),
              SliverToBoxAdapter(
                child: widget.alphabetListOptions.beforeList,
              ),
              ...widget.items.map(
                (item) {
                  bool useHeaderForEmptySection = widget.alphabetListOptions
                          .showSectionHeaderForEmptySections ||
                      !((item.childrenDelegate.estimatedChildCount ?? 0) == 0);
                  Widget header = widget
                              .alphabetListOptions.showSectionHeader &&
                          useHeaderForEmptySection
                      ? Semantics(
                          header: true,
                          child: widget.alphabetListOptions.listHeaderBuilder
                                  ?.call(context, item.tag) ??
                              DefaultAlphabetListHeader(
                                symbol: item.tag,
                              ),
                        )
                      : const SizedBox.shrink();

                  return SliverStickyHeader(
                    header: Container(
                      key: item.key,
                    ),
                    sliver: SliverStickyHeader(
                      header: Container(
                        child: header,
                      ),
                      sliver: SliverList(
                        delegate: item.childrenDelegate,
                      ),
                      sticky: widget.alphabetListOptions.stickySectionHeader,
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: widget.alphabetListOptions.afterList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.symbolChangeNotifierScrollbar
        .removeListener(_symbolChangeNotifierScrollbarListener);
    widget.scrollController.removeListener(_scrollControllerListener);
    super.dispose();
  }

  void _scrollControllerListener() {
    RenderBox? customScrollViewRenderBox;
    try {
      customScrollViewRenderBox =
          customScrollKey.currentContext?.findRenderObject() as RenderBox?;
      if (customScrollViewRenderBox != null) {
        widget.symbolChangeNotifierList.value = _getFirstVisibleItemGroupSymbol(
          customScrollViewRenderBox,
          widget.items,
        );
      }
    } catch (_) {}
  }

  void _symbolChangeNotifierScrollbarListener() {
    final String? tag = widget.symbolChangeNotifierScrollbar.value;
    if (tag != null) {
      _showGroup(tag);
    }
  }

  Future<void> _showGroup(String symbol) async {
    final RenderObject? renderObject = widget.items
        .firstWhere((element) => element.tag == symbol)
        .key
        .currentContext
        ?.findRenderObject();
    if (renderObject != null) {
      _jumpTo(renderObject);
    }
  }

  String? _getFirstVisibleItemGroupSymbol(
    RenderBox renderBoxScrollView,
    List<AlphabetListViewItemGroup> items,
  ) {
    String? hit;

    final result = BoxHitTestResult();
    for (final item in items) {
      final RenderBox? renderBoxItem =
          item.key.currentContext?.findRenderObject() as RenderBox?;
      final Offset? localLocationItem = renderBoxItem?.globalToLocal(
        renderBoxScrollView.localToGlobal(
          Offset(0, widget.alphabetListOptions.topOffset ?? 0),
        ),
      );
      if (localLocationItem != null &&
          renderBoxScrollView.hitTest(result, position: localLocationItem)) {
        hit = item.tag;
      }
    }

    return hit;
  }

  void _jumpTo(RenderObject object) {
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object)!;
    double? target;

    target = viewport.getOffsetToReveal(object, .0).offset.clamp(
          widget.alphabetListOptions.topOffset ?? 0,
          widget.scrollController.position.maxScrollExtent +
              (widget.alphabetListOptions.topOffset ?? 0),
        );
    widget.scrollController.jumpTo(
      target - (widget.alphabetListOptions.topOffset ?? 0),
    );
  }
}
