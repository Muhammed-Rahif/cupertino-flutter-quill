import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../translations.dart';
import '../../../document/attribute.dart';
import '../../base_button/base_value_button.dart';
import '../../config/buttons/select_header_style_dropdown_button_configurations.dart';
import '../../simple_toolbar_provider.dart';
import '../quill_icon_button.dart';

typedef QuillToolbarSelectHeaderStyleDropdownBaseButton
    = QuillToolbarBaseButton<QuillToolbarSelectHeaderStyleDropdownButtonOptions,
        QuillToolbarSelectHeaderStyleDropdownButtonExtraOptions>;

typedef QuillToolbarSelectHeaderStyleDropdownBaseButtonsState<
        W extends QuillToolbarSelectHeaderStyleDropdownButton>
    = QuillToolbarCommonButtonState<
        W,
        QuillToolbarSelectHeaderStyleDropdownButtonOptions,
        QuillToolbarSelectHeaderStyleDropdownButtonExtraOptions>;

class QuillToolbarSelectHeaderStyleDropdownButton
    extends QuillToolbarSelectHeaderStyleDropdownBaseButton {
  const QuillToolbarSelectHeaderStyleDropdownButton({
    required super.controller,
    super.options = const QuillToolbarSelectHeaderStyleDropdownButtonOptions(),
    super.key,
  });

  @override
  QuillToolbarSelectHeaderStyleDropdownBaseButtonsState createState() =>
      _QuillToolbarSelectHeaderStyleDropdownButtonState();
}

class _QuillToolbarSelectHeaderStyleDropdownButtonState
    extends QuillToolbarSelectHeaderStyleDropdownBaseButtonsState {
  @override
  String get defaultTooltip => context.loc.headerStyle;

  @override
  IconData get defaultIconData => Icons.question_mark_outlined;

  Attribute<dynamic> _selectedItem = Attribute.header;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  void didUpdateWidget(
      covariant QuillToolbarSelectHeaderStyleDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    widget.controller
      ..removeListener(_didChangeEditingValue)
      ..addListener(_didChangeEditingValue);
  }

  void _didChangeEditingValue() {
    final newSelectedItem = _getHeaderValue();
    if (newSelectedItem == _selectedItem) {
      return;
    }
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

  Attribute<dynamic> _getHeaderValue() {
    final attr = widget.controller.toolbarButtonToggler[Attribute.header.key];
    if (attr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.header.key);
      return attr;
    }
    return widget.controller
            .getSelectionStyle()
            .attributes[Attribute.header.key] ??
        Attribute.header;
  }

  String _label(Attribute<dynamic> value) {
    final label = switch (value) {
      Attribute.h1 => context.loc.heading1,
      Attribute.h2 => context.loc.heading2,
      Attribute.h3 => context.loc.heading3,
      Attribute.h4 => context.loc.heading4,
      Attribute.h5 => context.loc.heading5,
      Attribute.h6 => context.loc.heading6,
      Attribute.header =>
        widget.options.defaultDisplayText ?? context.loc.normal,
      Attribute<dynamic>() => throw ArgumentError(),
    };
    return label;
  }

  List<Attribute<int?>> get headerAttributes {
    return widget.options.attributes ??
        [
          Attribute.h1,
          Attribute.h2,
          Attribute.h3,
          Attribute.header,
        ];
  }

  void _onPressed(Attribute<int?> e) {
    setState(() => _selectedItem = e);
    widget.controller.formatSelection(_selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    final baseButtonConfigurations = context.quillToolbarBaseButtonOptions;
    final childBuilder =
        widget.options.childBuilder ?? baseButtonConfigurations?.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        widget.options,
        QuillToolbarSelectHeaderStyleDropdownButtonExtraOptions(
          currentValue: _selectedItem,
          context: context,
          controller: widget.controller,
          onPressed: () {
            throw UnimplementedError('Not implemented yet.');
          },
        ),
      );
    }

    return PullDownButton(
      itemBuilder: (context) => headerAttributes
          .map(
            (e) => PullDownMenuItem.selectable(
              selected: _label(e) == _label(_selectedItem),
              onTap: () {
                _onPressed(e);
              },
              title: _label(e),
              itemTheme: PullDownMenuItemTheme(
                textStyle: TextStyle(
                  color: _label(e) == _label(_selectedItem)
                      ? CupertinoTheme.of(context).primaryColor
                      : null,
                ),
              ),
            ),
          )
          .toList(),
      buttonBuilder: (context, showMenu) {
        final child = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _label(_selectedItem),
              style: widget.options.textStyle ??
                  TextStyle(
                    fontSize: iconSize / 1.15,
                  ),
            ),
            const SizedBox(width: 2),
            const Icon(
              CupertinoIcons.chevron_up_chevron_down,
              size: 16,
            ),
          ],
        );
        return QuillToolbarIconButton(
          onPressed: () {
            showMenu();
            afterButtonPressed?.call();
          },
          icon: child,
          isSelected: false,
          iconTheme: iconTheme,
          tooltip: tooltip,
        );
      },
    );
  }
}
