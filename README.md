# scaffold_plus

A drop-in replacement for Flutter's `Scaffold` with practical "plus" features:
a background image layer, SafeArea controls, animated body transitions via
`AnimatedSwitcher`, and tap-to-unfocus behavior. All core `Scaffold` parameters
are proxied, so you can use it as a full replacement with extra power.

Null safe. Lightweight. Flutter-first.

---

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Configuration notes](#configuration-notes)
- [API overview](#api-overview)
- [Examples](#examples)
  - [Simple](#simple)
  - [With background image](#with-background-image)
  - [Master-detail with switch animation](#master-detail-with-switch-animation)
- [Legacy compatibility](#legacy-compatibility)
- [Best practices](#best-practices)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- Background image layer (`useBackgroundImage`, `backgroundImage`)
- Tap-to-unfocus: dismisses the keyboard on outside tap (`onTapOutside`)
- SafeArea toggles (`safeAreaTop`, `safeAreaBottom`)
- Animated body transitions (`switchDuration`, `switchInCurve`, `switchOutCurve`)
- Proxies core `Scaffold` parameters (FAB, drawers, bottom bar, bottom sheet, etc.)
- Backward compatibility with legacy fields to ease migration

---

## Installation

Add to your app's `pubspec.yaml`:

```yaml
dependencies:
  scaffold_plus: ^1.0.2   # or the latest published version
```

Then:

```bash
flutter pub get
```

---

## Quick start

```dart
import 'package:scaffold_plus/scaffold_plus.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPlus(
      appBar: AppBar(title: const Text('ScaffoldPlus')),
      // extras
      useBackgroundImage: false,
      safeAreaTop: true,
      safeAreaBottom: false,
      horizontalPadding: 16,
      verticalPadding: 12,
      onTapOutside: () => FocusScope.of(context).unfocus(),
      // content
      body: const Center(child: Text('Hello')),
    );
  }
}
```

---

## Configuration notes

### Assets for background image

If you use a background image, add the asset to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/bg.png
```

Then:

```dart
ScaffoldPlus(
  useBackgroundImage: true,
  backgroundImage: 'assets/images/bg.png',
  body: ...
);
```

### Animated body transitions

`ScaffoldPlus` wraps the body with `AnimatedSwitcher`. When the `body` widget
identity changes (e.g. a different `key` or a different widget instance),
the switch animates in and out using the provided duration and curves.

---

## API overview

Public constructor parameters (subset):

| Parameter                           | Type                    | Default                                | Description |
|------------------------------------|-------------------------|----------------------------------------|-------------|
| `useBackgroundImage`               | `bool`                  | `false`                                | Enables background image layer. |
| `backgroundImage`                  | `String?`               | `null`                                 | Asset path for the background image. Used only when `useBackgroundImage` is true. |
| `backgroundColor`                  | `Color?`                | `Color(0xFF2532A4)`                    | Solid background color (below the image). |
| `safeAreaTop`                      | `bool`                  | `true`                                 | Wraps body with SafeArea at the top side. |
| `safeAreaBottom`                   | `bool`                  | `false`                                | Wraps body with SafeArea at the bottom side. |
| `horizontalPadding`                | `double?`               | `0`                                    | Horizontal padding inside SafeArea. |
| `verticalPadding`                  | `double?`               | `0`                                    | Vertical padding inside SafeArea. |
| `switchDuration`                   | `Duration`              | `Duration(milliseconds: 300)`          | AnimatedSwitcher duration. |
| `switchInCurve`                    | `Curve`                 | `Curves.easeInOut`                     | Incoming curve. |
| `switchOutCurve`                   | `Curve`                 | `Curves.easeInOut`                     | Outgoing curve. |
| `onTapOutside`                     | `VoidCallback?`         | `null`                                 | Called after unfocus when user taps outside. |
| `body`                             | `Widget?`               | `required`                             | Main content. Changes are animated via `AnimatedSwitcher`. |
| plus all common `Scaffold` params  |                         |                                        | `appBar`, FAB, drawers, bottom bar, bottom sheet, etc. |

---

## Examples

### Simple

```dart
ScaffoldPlus(
  appBar: AppBar(title: const Text('Inbox')),
  body: const Center(child: Text('Mail list')),
);
```

### With background image

```dart
ScaffoldPlus(
  appBar: AppBar(title: const Text('Welcome')),
  useBackgroundImage: true,
  backgroundImage: 'assets/images/bg.png',
  safeAreaTop: true,
  safeAreaBottom: true,
  horizontalPadding: 20,
  verticalPadding: 16,
  body: const Text('Landing'),
);
```

### Master-detail with switch animation

```dart
class MasterDetail extends StatefulWidget {
  const MasterDetail({super.key});
  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    final Widget body = selectedId == null
        ? _Master(onTap: (id) => setState(() => selectedId = id), key: const ValueKey('master'))
        : _Detail(id: selectedId!, onBack: () => setState(() => selectedId = null), key: ValueKey('detail-$selectedId'));

    return ScaffoldPlus(
      appBar: AppBar(title: const Text('Master-Detail')),
      switchDuration: const Duration(milliseconds: 250),
      body: body,
    );
  }
}
```

---

## Legacy compatibility

The package keeps deprecated fields for a smooth migration. New code should use the modern API.

| Legacy field            | Use instead            |
|------------------------|------------------------|
| `backgrounImageHave`   | `useBackgroundImage`   |
| `backgrounImage`       | `backgroundImage`      |
| `top`                  | `safeAreaTop`          |
| `horizontal`           | `horizontalPadding`    |
| `vertical`             | `verticalPadding`      |
| `onTap`                | `onTapOutside`         |

Deprecated fields will continue to work for now but may be removed in a future major release.

---

## Best practices

- Keep `backgroundImage` lightweight and optimized. Prefer compressed PNG or WebP.
- Consider contrast: if you use a bright image, apply a color filter to your content or select contrasting text colors.
- For body switching, provide stable keys to avoid unnecessary rebuilds and to get smoother `AnimatedSwitcher` transitions.
- If your page embeds a scrollable, avoid `Expanded` inside unbounded parents (e.g. inside a `SingleChildScrollView`).

---

## FAQ

**Q: Does `backgroundImage` support network images?**
A: Not directly. Provide an asset path. If you need network images, consider prefetching and storing them as files, or add custom logic to your app to paint a network image behind `ScaffoldPlus`.

**Q: Can I disable SafeArea entirely?**
A: Yes. Set `safeAreaTop: false` and `safeAreaBottom: false`.

**Q: Why are my transitions not animating?**
A: `AnimatedSwitcher` animates when the child widget identity changes. Give different keys or swap different widget instances.

**Q: Is this a full replacement for `Scaffold`?**
A: Yes. All common `Scaffold` parameters are proxied.

---

## Contributing

Issues and pull requests are welcome. Please run:

```bash
dart format .
dart analyze --fatal-infos
flutter test
```

before submitting.

---

## License

MIT. See `LICENSE` for details.
