import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/plugins/wstore_plugin.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:wstore/wstore.dart';

class UserAvatarWidgetStore extends WStore {
  Map<int, OrganizationMember> get organizationMembers => computedFromStore(
        store: UserStore(),
        getValue: (store) => store.organizationMembers,
        keyName: 'organizationMembers',
      );

  OrganizationMember? get user => computed<OrganizationMember?>(
        getValue: () => organizationMembers[widget.id],
        watch: () => [organizationMembers],
        keyName: 'user',
      );

  String get userAvatarUrl => computed<String>(
        getValue: () => user?.avatarLink ?? '',
        watch: () => [user],
        keyName: 'userAvatarUrl',
      );

  String get userEmail => computed<String>(
        getValue: () => user?.email.trim() ?? widget.email.trim(),
        watch: () => [user],
        keyName: 'userEmail',
      );

  String get userNameFirstLetter => computed<String>(
        getValue: () {
          if (userAvatarUrl.isNotEmpty) return '';
          final name = user?.name.trim() ?? '';
          if (name.isNotEmpty) {
            final names = name.split(' ');
            final firstName = names.isNotEmpty ? names[0] : '';
            final lastName = names.length > 1 ? names[1] : '';
            final firstLetter =
                firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
            final lastLetter =
                lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
            return '$firstLetter$lastLetter';
          }
          final email = userEmail.isEmpty ? '?' : userEmail;
          final nameFromEmail = email.split(' ')[0];
          final names = nameFromEmail.split('.');
          final firstName = names.isNotEmpty ? names[0] : '';
          final lastName = names.length > 1 ? names[1] : '';
          final firstLetter =
              firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
          final lastLetter =
              lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
          return '$firstLetter$lastLetter';
        },
        watch: () => [user, userAvatarUrl],
        keyName: 'userNameFirstLetter',
      );

  @override
  UserAvatarWidget get widget => super.widget as UserAvatarWidget;
}

class UserAvatarWidget extends WStoreWidget<UserAvatarWidgetStore> {
  final int id;
  final double width;
  final double height;
  final String email;
  final double fontSize;
  final double radius;
  final Color colorBackground;
  final Color colorText;

  const UserAvatarWidget({
    super.key,
    required this.id,
    required this.width,
    required this.height,
    required this.fontSize,
    this.email = '',
    this.radius = 6,
    this.colorBackground = const Color(0xFF6E777A),
    this.colorText = Colors.white,
  });

  @override
  UserAvatarWidgetStore createWStore() => UserAvatarWidgetStore();

  @override
  Widget build(BuildContext context, UserAvatarWidgetStore store) {
    return WStoreBuilder(
      store: store,
      watch: (store) => [store.userAvatarUrl, store.userNameFirstLetter],
      builder: (context, store) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: colorBackground,
            border: Border.all(
              color: Colors.white, // Specify the border color
              width: 1, // Specify the border width
            ),
            image: store.userAvatarUrl.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(store.userAvatarUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              store.userNameFirstLetter,
              style: TextStyle(
                color: colorText,
                fontSize: fontSize,
              ),
              textScaleFactor: 1.0,
            ),
          ),
        );
      },
    );
  }
}
