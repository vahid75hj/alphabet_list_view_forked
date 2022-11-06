import 'package:alphabet_list_view/src/enum.dart';
import 'package:alphabet_list_view/src/typedef.dart';
import 'package:flutter/material.dart';

/// Options class.
///
/// Optional class containing all options for the AlphabetListView.
class AlphabetListViewOptions {
  const AlphabetListViewOptions({
    this.listOptions = const ListOptions(),
    this.scrollbarOptions = const ScrollbarOptions(),
    this.overlayOptions = const OverlayOptions(),
  });

  /// Customisation options for the list.
  final ListOptions listOptions;

  /// Customisation options for the scrollbar.
  final ScrollbarOptions scrollbarOptions;

  /// Customisation options for the overlay.
  final OverlayOptions overlayOptions;
}

/// Options for the list of the AlphabetListView.
class ListOptions {
  const ListOptions({
    this.backgroundColor,
    this.topOffset,
    this.padding,
    this.physics,
    this.showSectionHeader = true,
    this.stickySectionHeader = true,
    this.showSectionHeaderForEmptySections = false,
    this.beforeList,
    this.afterList,
    this.listHeaderBuilder,
    this.sliverAppbar,
  }) : assert((topOffset ?? 0) >= 0);

  /// Optional background color.
  final Color? backgroundColor;

  /// Sets an offset to the upper edge.
  ///
  /// Must be >= 0 or [null]
  /// Does not work in combination with [stickySectionHeader] set to true.
  final double? topOffset;

  /// Padding around the list.
  final EdgeInsets? padding;

  /// Custom scroll physics.
  final ScrollPhysics? physics;

  /// Show the header above the items.
  final bool showSectionHeader;

  /// Use sticky headers.
  final bool stickySectionHeader;

  /// Show headers for sections without child widgets.
  final bool showSectionHeaderForEmptySections;

  /// Optional [Widget] before the list.
  final Widget? beforeList;

  /// Optional [Widget] after the list.
  final Widget? afterList;

  /// Builder function for headers.
  final SymbolBuilder? listHeaderBuilder;

  ///custom sliver appbar
  final Widget? sliverAppbar;
}

/// Options for the scrollbar of the AlphabetListView
class ScrollbarOptions {
  const ScrollbarOptions({
    this.width = 40,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.scrollBarDecoration,
    this.symbols = defaultSymbols,
    this.jumpToSymbolsWithNoEntries = false,
    this.forcePosition,
    this.symbolBuilder,
  });

  /// The width of the sidebar.
  final double width;

  /// Padding around the sidebar.
  final EdgeInsets? padding;

  /// Placement of the children in the sidebar.
  final MainAxisAlignment mainAxisAlignment;

  /// Optional decoration for the sidebar.
  final BoxDecoration? scrollBarDecoration;

  /// A [List] of [String] representing the symbols to be shown.
  ///
  /// Strings must be unique.
  final Iterable<String> symbols;

  /// Activates symbols without children.
  ///
  /// Enables jumping to the position even if there are no entries present.
  final bool jumpToSymbolsWithNoEntries;

  /// Force the position of the sidebar.
  ///
  /// If set, [Directionality] will be ignored.
  final AlphabetScrollbarPosition? forcePosition;

  /// Builder function for sidebar symbols.
  final SymbolStateBuilder? symbolBuilder;
}

/// Options for the overlay of the AlphabetListView
class OverlayOptions {
  const OverlayOptions({
    this.showOverlay = true,
    this.alignment = Alignment.center,
    this.overlayBuilder,
  });

  /// Showing an overlay of the current icon when swiping across the sidebar.
  final bool showOverlay;

  /// The [Alignment] of the overlay.
  final Alignment alignment;

  /// Builder function for the overlay.
  final SymbolBuilder? overlayBuilder;
}

/// Default symbols used by the sidebar.
///
/// 'A'-'Z' and '#'
const List<String> defaultSymbols = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '#',
];
