part of '../main_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  static const _userUrl =
      "http://eds.pau.edu.tr/4/pluginfile.php/1593883/user/icon/boost/f1?rev=30757868";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData.fallback().copyWith(color: Colors.black),
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          _Avatar(),
          _Title(),
        ],
      ),
      actions: [
        _Menu(
          onPressed: () {},
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Menu extends StatelessWidget {
  const _Menu({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.menu_outlined),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Merhaba [Kullanıcı]',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700));
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: NetworkImage(_AppBar._userUrl),
    );
  }
}
