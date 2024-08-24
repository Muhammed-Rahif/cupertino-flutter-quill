import 'package:flutter/cupertino.dart';

class QuillEditorCheckboxPoint extends StatefulWidget {
  const QuillEditorCheckboxPoint({
    required this.size,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.uiBuilder,
    super.key,
  });

  final double size;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final QuillCheckboxBuilder? uiBuilder;

  @override
  QuillEditorCheckboxPointState createState() =>
      QuillEditorCheckboxPointState();
}

class QuillEditorCheckboxPointState extends State<QuillEditorCheckboxPoint> {
  @override
  Widget build(BuildContext context) {
    final uiBuilder = widget.uiBuilder;
    if (uiBuilder != null) {
      return uiBuilder.build(
        context: context,
        isChecked: widget.value,
        onChanged: widget.onChanged,
      );
    }
    final theme = CupertinoTheme.of(context);
    final child = Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsetsDirectional.only(end: widget.size / 2),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CupertinoCheckbox(
          activeColor: theme.primaryColor,
          value: widget.value,
          onChanged: (value) =>
              widget.enabled ? widget.onChanged(!widget.value) : null,
        ),
      ),
    );
    return child;
  }
}

abstract class QuillCheckboxBuilder {
  Widget build({
    required BuildContext context,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
  });
}
