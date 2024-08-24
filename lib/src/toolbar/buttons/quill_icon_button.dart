import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Tooltip;

import '../theme/quill_icon_theme.dart';

class QuillToolbarIconButton extends StatelessWidget {
  const QuillToolbarIconButton({
    required this.onPressed,
    required this.icon,
    required this.isSelected,
    required this.iconTheme,
    this.afterPressed,
    this.tooltip,
    super.key,
  });

  final VoidCallback? onPressed;
  final VoidCallback? afterPressed;
  final Widget icon;

  final String? tooltip;
  final bool isSelected;

  final QuillIconTheme? iconTheme;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      textStyle: TextStyle(
        color: CupertinoTheme.of(context).textTheme.textStyle.color,
      ),
      message: tooltip ?? '',
      child: CupertinoButton(
        minSize: 34,
        onPressed: onPressed != null
            ? () {
                onPressed?.call();
                afterPressed?.call();
              }
            : null,
        // style: iconTheme?.iconButtonUnselectedData?.style,
        // visualDensity: iconTheme?.iconButtonUnselectedData?.visualDensity,
        // iconSize: iconTheme?.iconButtonUnselectedData?.iconSize,
        // splashRadius: iconTheme?.iconButtonUnselectedData?.splashRadius,
        // hoverColor: iconTheme?.iconButtonUnselectedData?.hoverColor,
        // highlightColor: iconTheme?.iconButtonUnselectedData?.highlightColor,
        // splashColor: iconTheme?.iconButtonUnselectedData?.splashColor,
        // mouseCursor: iconTheme?.iconButtonUnselectedData?.mouseCursor,
        // enableFeedback: iconTheme?.iconButtonUnselectedData?.enableFeedback,
        // constraints: iconTheme?.iconButtonUnselectedData?.constraints,
        // selectedIcon: iconTheme?.iconButtonUnselectedData?.selectedIcon,
        // alignment: iconTheme?.iconButtonUnselectedData?.alignment,
        // disabledColor: iconTheme?.iconButtonUnselectedData?.disabledColor,
        disabledColor: iconTheme?.iconButtonUnselectedData!.disabledColor ??
            CupertinoColors.quaternarySystemFill.resolveFrom(context),
        padding:
            iconTheme?.iconButtonUnselectedData?.padding ?? EdgeInsets.zero,
        color: isSelected ? CupertinoTheme.of(context).primaryColor : null,
        focusColor: iconTheme?.iconButtonUnselectedData?.focusColor,
        autofocus: iconTheme?.iconButtonUnselectedData?.autofocus ?? false,
        child: icon,
      ),
    );
  }
}
