import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../extensions.dart';
import '../../common/utils/font.dart';
import '../../document/attribute.dart';
import '../../l10n/extensions/localizations_ext.dart';
import '../base_button/base_value_button.dart';
import '../base_toolbar.dart';
import '../simple_toolbar_provider.dart';

class QuillToolbarFontSizeButton extends QuillToolbarBaseButton<
    QuillToolbarFontSizeButtonOptions, QuillToolbarFontSizeButtonExtraOptions> {
  QuillToolbarFontSizeButton({
    required super.controller,
    @Deprecated('Please use the default display text from the options')
    this.defaultDisplayText,
    super.options = const QuillToolbarFontSizeButtonOptions(),
    super.key,
  })  : assert(options.rawItemsMap?.isNotEmpty ?? true),
        assert(options.initialValue == null ||
            (options.initialValue?.isNotEmpty ?? true));

  final String? defaultDisplayText;

  @override
  QuillToolbarFontSizeButtonState createState() =>
      QuillToolbarFontSizeButtonState();
}

class QuillToolbarFontSizeButtonState extends QuillToolbarBaseButtonState<
    QuillToolbarFontSizeButton,
    QuillToolbarFontSizeButtonOptions,
    QuillToolbarFontSizeButtonExtraOptions,
    String> {
  Map<String, String> get rawItemsMap {
    final fontSizes = options.rawItemsMap ??
        context.quillSimpleToolbarConfigurations?.fontSizesValues ??
        {
          context.loc.small: 'small',
          context.loc.large: 'large',
          context.loc.huge: 'huge',
          context.loc.clear: '0'
        };
    return fontSizes;
  }

  String? getLabel(String? currentValue) {
    return switch (currentValue) {
      'small' => context.loc.small,
      'large' => context.loc.large,
      'huge' => context.loc.huge,
      String() => currentValue,
      null => null,
    };
  }

  String get _defaultDisplayText {
    return options.initialValue ??
        widget.options.defaultDisplayText ??
        widget.defaultDisplayText ??
        context.loc.fontSize;
  }

  @override
  String get currentStateValue {
    final attribute =
        controller.getSelectionStyle().attributes[options.attribute.key];
    return attribute == null
        ? _defaultDisplayText
        : (_getKeyName(attribute.value) ?? _defaultDisplayText);
  }

  String? _getKeyName(dynamic value) {
    for (final entry in rawItemsMap.entries) {
      if (getFontSize(entry.value) == getFontSize(value)) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  String get defaultTooltip => context.loc.fontSize;

  @override
  IconData get defaultIconData => CupertinoIcons.textformat_size;

  @override
  Widget build(BuildContext context) {
    final baseButtonConfigurations = context.quillToolbarBaseButtonOptions;
    final childBuilder =
        options.childBuilder ?? baseButtonConfigurations?.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        options,
        QuillToolbarFontSizeButtonExtraOptions(
          controller: controller,
          currentValue: currentValue,
          defaultDisplayText: _defaultDisplayText,
          context: context,
          onPressed: () {},
        ),
      );
    }
    return PullDownButton(
      itemBuilder: (context) => rawItemsMap.entries.map((fontSize) {
        return PullDownMenuItem.selectable(
          selected: currentValue == _getKeyName(fontSize.value),
          key: ValueKey(fontSize.key),
          onTap: () {
            final newValue = fontSize.value;
            final keyName = _getKeyName(newValue);
            setState(() {
              if (keyName != context.loc.clear) {
                currentValue = keyName ?? _defaultDisplayText;
              } else {
                currentValue = _defaultDisplayText;
              }
              if (keyName != null) {
                controller.formatSelection(
                  Attribute.fromKeyValue(
                    Attribute.size.key,
                    newValue == '0' ? null : getFontSize(newValue),
                  ),
                );
                options.onSelected?.call(newValue);
              }
            });
          },
          title: fontSize.key.toString(),
          itemTheme: PullDownMenuItemTheme(
            textStyle: TextStyle(
              color: fontSize.value == '0'
                  ? options.defaultItemColor
                  : currentValue == _getKeyName(fontSize.value)
                      ? CupertinoTheme.of(context).primaryColor
                      : null,
            ),
          ),
        );
      }).toList(),
      buttonBuilder: (context, showMenu) => QuillToolbarIconButton(
        tooltip: tooltip,
        isSelected: false,
        iconTheme: iconTheme,
        onPressed: () {
          showMenu();
          afterButtonPressed?.call();
        },
        icon: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final hasFinalWidth = options.width != null;
    return Padding(
      padding: options.padding ?? const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisSize: !hasFinalWidth ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UtilityWidgets.maybeWidget(
            enabled: hasFinalWidth,
            wrapper: (child) => Expanded(child: child),
            child: Text(
              getLabel(currentValue) ?? '',
              overflow: options.labelOverflow,
              style: options.style ??
                  TextStyle(
                    fontSize: iconSize / 1.15,
                  ),
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            CupertinoIcons.chevron_up_chevron_down,
            size: 16,
          ),
        ],
      ),
    );
  }
}
