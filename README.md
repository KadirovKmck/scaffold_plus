# scaffold_plus

A drop-in replacement for Flutter’s `Scaffold` with practical “plus” features:
a background image layer, SafeArea controls, animated body transitions via
`AnimatedSwitcher`, and tap-to-unfocus behavior. All key `Scaffold` parameters
are proxied, so you can use it as a full replacement with extra power.

> **Null safe**, Flutter-first, lightweight.

---

## Features

- 📸 **Background image layer** (`useBackgroundImage`, `backgroundImage`)
- 🧼 **Tap-to-unfocus**: dismisses keyboard when tapping outside
- 🧩 **SafeArea toggles** (`safeAreaTop`, `safeAreaBottom`)
- 🎞️ **Animated page/body transitions** (`switchDuration`, `switchInCurve`, `switchOutCurve`)
- 🧰 **Proxies core `Scaffold` parameters** (FAB, drawers, bottom bar, bottom sheet, etc.)
- 🔁 **Backward compatibility** with legacy fields (`backgrounImage*`, `top`, `horizontal`, `vertical`, `onTap`) to ease migration

---

## Installation

Add to your app’s `pubspec.yaml`:

```yaml
dependencies:
  scaffold_plus: ^0.0.1
