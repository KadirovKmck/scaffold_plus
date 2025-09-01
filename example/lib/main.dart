import 'package:flutter/material.dart';
import 'package:scaffold_plus/scaffold_plus.dart';

// Run this file as your main.dart to see ScaffoldPlus in action.
// Assets: if you toggle the background image, make sure you have
// an asset at assets/images/bg.png and it is declared in pubspec.yaml.
//
// flutter:
//   assets:
//     - assets/images/bg.png
//
// This example shows:
// - background image layer
// - SafeArea toggles and paddings
// - tap-to-unfocus (try the TextField)
// - AnimatedSwitcher body transitions (list <-> details <-> settings)
// - proxied Scaffold params: AppBar, FAB, drawers, bottom nav, bottom sheet
void main() => runApp(const ScaffoldPlusDemoApp());

class ScaffoldPlusDemoApp extends StatefulWidget {
  const ScaffoldPlusDemoApp({super.key});
  @override
  State<ScaffoldPlusDemoApp> createState() => _ScaffoldPlusDemoAppState();
}

class _ScaffoldPlusDemoAppState extends State<ScaffoldPlusDemoApp> {
  ThemeMode _mode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScaffoldPlus Demo',
      themeMode: _mode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: DemoHome(
        onToggleTheme: () {
          setState(() {
            _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          });
        },
        themeMode: _mode,
      ),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

enum BodyMode { list, details, settings }

class _DemoHomeState extends State<DemoHome> {
  // UI state
  int _selectedNav = 0; // 0: Explore, 1: Settings (same as BodyMode.settings)
  BodyMode _mode = BodyMode.list;
  int? _selectedId;
  int _counter = 0;

  // ScaffoldPlus extras
  bool _useBg = false;
  bool _safeTop = true;
  bool _safeBottom = false;
  double _hPad = 16;
  double _vPad = 12;

  // For bottom sheet demo
  void _showQuickSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick actions', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _counter++);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Counter incremented')),
                    );
                  },
                  child: const Text('Increment counter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide which body to show; changing this triggers AnimatedSwitcher.
    Widget body;
    if (_selectedNav == 1 || _mode == BodyMode.settings) {
      body = _SettingsPanel(
        useBg: _useBg,
        safeTop: _safeTop,
        safeBottom: _safeBottom,
        hPad: _hPad,
        vPad: _vPad,
        onChanged: (useBg, safeTop, safeBottom, hPad, vPad) {
          setState(() {
            _useBg = useBg;
            _safeTop = safeTop;
            _safeBottom = safeBottom;
            _hPad = hPad;
            _vPad = vPad;
          });
        },
      );
    } else if (_mode == BodyMode.details && _selectedId != null) {
      body = _DetailView(
        key: ValueKey('detail-$_selectedId'),
        id: _selectedId!,
        onBack: () => setState(() => _mode = BodyMode.list),
      );
    } else {
      body = _MasterList(
        key: const ValueKey('master'),
        onOpen: (id) => setState(() {
          _selectedId = id;
          _mode = BodyMode.details;
        }),
      );
    }

    return ScaffoldPlus(
      appBar: AppBar(
        title: const Text('ScaffoldPlus Demo'),
        actions: [
          IconButton(
            tooltip: 'Theme: toggle light/dark',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
          IconButton(
            tooltip: 'Show bottom sheet',
            onPressed: _showQuickSheet,
            icon: const Icon(Icons.keyboard_arrow_up),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const ListTile(
                title: Text('Demo drawer'),
                subtitle: Text('This proves Scaffold params are proxied'),
              ),
              SwitchListTile(
                title: const Text('Use background image'),
                value: _useBg,
                onChanged: (v) => setState(() => _useBg = v),
              ),
              SwitchListTile(
                title: const Text('SafeArea top'),
                value: _safeTop,
                onChanged: (v) => setState(() => _safeTop = v),
              ),
              SwitchListTile(
                title: const Text('SafeArea bottom'),
                value: _safeBottom,
                onChanged: (v) => setState(() => _safeBottom = v),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('About', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'ScaffoldPlus is a drop-in replacement for Scaffold with handy extras.',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _counter++),
        label: Text('$_counter'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNav,
        onDestinationSelected: (i) => setState(() {
          _selectedNav = i;
          _mode = i == 1 ? BodyMode.settings : BodyMode.list;
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),

      // ---- ScaffoldPlus extras ----
      useBackgroundImage: _useBg,
      backgroundImage:
          'assets/images/bg.png', // change or disable via drawer/settings
      safeAreaTop: _safeTop,
      safeAreaBottom: _safeBottom,
      horizontalPadding: _hPad,
      verticalPadding: _vPad,
      switchDuration: const Duration(milliseconds: 250),
      onTapOutside: () => debugPrint('Tap outside -> unfocus'),
      // The magic: AnimatedSwitcher will animate whenever "body" changes identity.
      body: body,
    );
  }
}

// ----------------- Widgets used inside the demo -----------------

class _MasterList extends StatelessWidget {
  const _MasterList({super.key, required this.onOpen});
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const _SearchField(),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: 20,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text('Item #${i + 1}'),
              subtitle: const Text(
                'Tap to open details (AnimatedSwitcher demo)',
              ),
              onTap: () => onOpen(i + 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({super.key, required this.id, required this.onBack});
  final int id;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            Text(
              'Details for item #$id',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'This page is different from the master list. '
          'Switching between them uses AnimatedSwitcher provided by ScaffoldPlus.',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left),
          label: const Text('Back to list'),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tap here, then tap outside to see unfocus behavior',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.useBg,
    required this.safeTop,
    required this.safeBottom,
    required this.hPad,
    required this.vPad,
    required this.onChanged,
  });

  final bool useBg;
  final bool safeTop;
  final bool safeBottom;
  final double hPad;
  final double vPad;
  final void Function(
    bool useBg,
    bool safeTop,
    bool safeBottom,
    double hPad,
    double vPad,
  )
  onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Use background image'),
          value: useBg,
          onChanged: (v) => onChanged(v, safeTop, safeBottom, hPad, vPad),
        ),
        SwitchListTile(
          title: const Text('SafeArea top'),
          value: safeTop,
          onChanged: (v) => onChanged(useBg, v, safeBottom, hPad, vPad),
        ),
        SwitchListTile(
          title: const Text('SafeArea bottom'),
          value: safeBottom,
          onChanged: (v) => onChanged(useBg, safeTop, v, hPad, vPad),
        ),
        ListTile(
          title: const Text('Horizontal padding'),
          subtitle: Slider(
            value: hPad,
            min: 0,
            max: 32,
            divisions: 32,
            label: hPad.round().toString(),
            onChanged: (v) => onChanged(useBg, safeTop, safeBottom, v, vPad),
          ),
        ),
        ListTile(
          title: const Text('Vertical padding'),
          subtitle: Slider(
            value: vPad,
            min: 0,
            max: 32,
            divisions: 32,
            label: vPad.round().toString(),
            onChanged: (v) => onChanged(useBg, safeTop, safeBottom, hPad, v),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Notes'),
          subtitle: const Text(
            'AnimatedSwitcher runs when the body widget changes. '
            'This happens when you switch between Explore (list/details) '
            'and Settings using the bottom navigation bar.',
          ),
        ),
      ],
    );
  }
}
