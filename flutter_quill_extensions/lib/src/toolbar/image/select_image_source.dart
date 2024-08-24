import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/extensions.dart' show isDesktop;
import 'package:flutter_quill/translations.dart';

import '../../editor/image/image_embed_types.dart';

class SelectImageSourceDialog extends StatelessWidget {
  const SelectImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(InsertImageSource.gallery),
          child: ListItem(
            title: context.loc.gallery,
            subtitle: context.loc.pickAPhotoFromYourGallery,
            icon: CupertinoIcons.photo,
          ),
        ),
        Opacity(
          opacity: !isDesktop(supportWeb: false) ? 1 : 0.45,
          child: CupertinoActionSheetAction(
            onPressed: () => !isDesktop(supportWeb: false)
                ? Navigator.of(context).pop(InsertImageSource.camera)
                : null,
            child: ListItem(
              title: context.loc.camera,
              subtitle: context.loc.takeAPhotoUsingYourCamera,
              icon: CupertinoIcons.photo_camera,
            ),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(InsertImageSource.link),
          child: ListItem(
            title: context.loc.link,
            subtitle: context.loc.pasteAPhotoUsingALink,
            icon: CupertinoIcons.link,
          ),
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyle,
              ),
              Text(
                subtitle,
                style: textStyle.copyWith(
                  fontSize: 12,
                  color: textStyle.color!.withOpacity(0.5),
                ),
              ),
            ],
          ),
          Icon(icon),
        ],
      ),
    );
  }
}

Future<InsertImageSource?> showSelectImageSourceDialog({
  required BuildContext context,
}) async {
  final imageSource = await showCupertinoModalPopup<InsertImageSource>(
    context: context,
    builder: (_) => const FlutterQuillLocalizationsWidget(
      child: SelectImageSourceDialog(),
    ),
  );
  return imageSource;
}
