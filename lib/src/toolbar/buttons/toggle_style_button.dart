import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../../common/utils/widgets.dart';
import '../../document/attribute.dart';
import '../../document/style.dart';
import '../../l10n/extensions/localizations_ext.dart';
import '../base_button/base_value_button.dart';
import '../base_toolbar.dart';
import '../simple_toolbar_provider.dart';
import '../theme/quill_icon_theme.dart';

typedef ToggleStyleButtonBuilder = Widget Function(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  bool? isToggled,
  VoidCallback? onPressed,
  VoidCallback? afterPressed, [
  double iconSize,
  QuillIconTheme? iconTheme,
]);

class QuillToolbarToggleStyleButton extends QuillToolbarToggleStyleBaseButton {
  const QuillToolbarToggleStyleButton({
    required super.controller,
    required this.attribute,
    super.options = const QuillToolbarToggleStyleButtonOptions(),
    super.key,
  });

  final Attribute attribute;

  @override
  QuillToolbarToggleStyleButtonState createState() =>
      QuillToolbarToggleStyleButtonState();
}

class QuillToolbarToggleStyleButtonState
    extends QuillToolbarToggleStyleBaseButtonState<
        QuillToolbarToggleStyleButton> {
  Style get _selectionStyle => controller.getSelectionStyle();

  @override
  bool get currentStateValue => _getIsToggled(_selectionStyle.attributes);

  (String, IconData) get _defaultTooltipAndIconData {
    switch (widget.attribute.key) {
      case 'bold':
        return (context.loc.bold, CupertinoIcons.bold);
      case 'script':
        if (widget.attribute.value == ScriptAttributes.sub.value) {
          return (context.loc.subscript, CupertinoIcons.textformat_subscript);
        }
        return (context.loc.superscript, CupertinoIcons.textformat_superscript);
      case 'italic':
        return (context.loc.italic, CupertinoIcons.italic);
      case 'small':
        return (context.loc.small, CupertinoIcons.textformat_size);
      case 'underline':
        return (context.loc.underline, CupertinoIcons.underline);
      case 'strike':
        return (context.loc.strikeThrough, CupertinoIcons.strikethrough);
      case 'code':
        return (
          context.loc.inlineCode,
          CupertinoIcons.chevron_left_slash_chevron_right
        );
      case 'direction':
        return (context.loc.textDirection, Icons.format_textdirection_r_to_l);
      case 'list':
        if (widget.attribute.value == 'bullet') {
          return (context.loc.bulletList, CupertinoIcons.list_bullet);
        }
        return (context.loc.numberedList, CupertinoIcons.list_number);
      case 'code-block':
        return (
          context.loc.codeBlock,
          CupertinoIcons.chevron_left_slash_chevron_right
        );
      case 'blockquote':
        return (context.loc.quote, CupertinoIcons.text_quote);
      case 'align':
        return switch (widget.attribute.value) {
          'left' => (context.loc.alignLeft, CupertinoIcons.text_alignleft),
          'right' => (context.loc.alignRight, CupertinoIcons.text_alignright),
          'center' => (
              context.loc.alignCenter,
              CupertinoIcons.text_aligncenter
            ),
          'justify' => (context.loc.alignJustify, CupertinoIcons.text_justify),
          Object() => throw ArgumentError(widget.attribute.value),
          null => (context.loc.alignCenter, CupertinoIcons.text_aligncenter),
        };
      default:
        throw ArgumentError(
          'Could not find the default tooltip for '
          '${widget.attribute.toString()}',
        );
    }
  }

  @override
  String get defaultTooltip => _defaultTooltipAndIconData.$1;

  @override
  IconData get defaultIconData => _defaultTooltipAndIconData.$2;

  void _onPressed() {
    _toggleAttribute();
    afterButtonPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final childBuilder = options.childBuilder ??
        context.quillToolbarBaseButtonOptions?.childBuilder;
    if (childBuilder != null) {
      return childBuilder(
        options,
        QuillToolbarToggleStyleButtonExtraOptions(
          context: context,
          controller: controller,
          onPressed: _onPressed,
          isToggled: currentValue,
        ),
      );
    }
    return UtilityWidgets.maybeTooltip(
      context,
      message: tooltip,
      child: defaultToggleStyleButtonBuilder(
        context,
        widget.attribute,
        iconData,
        currentValue,
        _toggleAttribute,
        afterButtonPressed,
        iconSize,
        iconButtonFactor,
        iconTheme,
      ),
    );
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key ||
        widget.attribute.key == Attribute.header.key ||
        widget.attribute.key == Attribute.script.key ||
        widget.attribute.key == Attribute.align.key) {
      final attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  void _toggleAttribute() {
    controller
      ..skipRequestKeyboard = !widget.attribute.isInline
      ..formatSelection(
        currentValue
            ? Attribute.clone(widget.attribute, null)
            : widget.attribute,
      );
  }
}

Widget defaultToggleStyleButtonBuilder(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  bool? isToggled,
  VoidCallback? onPressed,
  VoidCallback? afterPressed, [
  double iconSize = kDefaultIconSize,
  double iconButtonFactor = kDefaultIconButtonFactor,
  QuillIconTheme? iconTheme,
]) {
  final isEnabled = onPressed != null;
  return QuillToolbarIconButton(
    icon: Icon(
      icon,
      size: iconSize * iconButtonFactor,
    ),
    isSelected: isEnabled ? isToggled == true : false,
    onPressed: onPressed,
    afterPressed: afterPressed,
    iconTheme: iconTheme,
  );
}
