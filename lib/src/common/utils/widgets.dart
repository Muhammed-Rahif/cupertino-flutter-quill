import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Tooltip;

typedef WidgetWrapper = Widget Function(Widget child);

/// Provides utiulity widgets.
class UtilityWidgets {
  const UtilityWidgets._();

  /// Conditionally wraps the [child] with [Tooltip] widget if [message]
  /// is not null and not empty.
  static Widget maybeTooltip(
    BuildContext context, {
    required Widget child,
    String? message,
  }) =>
      (message?.isNotEmpty ?? false)
          ? Tooltip(
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).barBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              textStyle: TextStyle(
                color: CupertinoTheme.of(context).textTheme.textStyle.color,
              ),
              message: message,
              child: child,
            )
          : child;

  /// Conditionally wraps the [child] with [wrapper] widget if [enabled]
  /// is true.
  static Widget maybeWidget({
    required WidgetWrapper wrapper,
    required Widget child,
    bool enabled = false,
  }) =>
      enabled ? wrapper(child) : child;
}
