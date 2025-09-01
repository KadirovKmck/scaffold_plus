library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A sugar-coated drop-in replacement for [Scaffold].
///
/// Adds:
/// 1) Optional background image layer.
/// 2) SafeArea toggles with custom paddings.
/// 3) [AnimatedSwitcher] for body transitions.
/// 4) Tap-to-unfocus behavior.
///
/// All common [Scaffold] params are proxied, so you can
/// use it as a full Scaffold with extras on top.
class ScaffoldPlus extends StatelessWidget {
  // ===== Modern API =====

  /// Whether to show a background image layer.
  final bool useBackgroundImage;

  /// Asset path for the background image. Used only when [useBackgroundImage] is true.
  final String? backgroundImage;

  /// Solid background color below the (optional) image.
  final Color? backgroundColor;

  /// Wrap body with [SafeArea] at the top side.
  final bool safeAreaTop;

  /// Wrap body with [SafeArea] at the bottom side.
  final bool safeAreaBottom;

  /// Horizontal padding inside the SafeArea (in logical pixels).
  final double? horizontalPadding;

  /// Vertical padding inside the SafeArea (in logical pixels).
  final double? verticalPadding;

  /// Duration of [AnimatedSwitcher] used for [body] transitions.
  final Duration switchDuration;

  /// Curve of the incoming child for the [AnimatedSwitcher].
  final Curve switchInCurve;

  /// Curve of the outgoing child for the [AnimatedSwitcher].
  final Curve switchOutCurve;

  /// Called after unfocusing when user taps outside any focusable widget.
  final VoidCallback? onTapOutside;

  // ===== Backward compatibility (kept; not used in docs) =====
  @Deprecated('Use backgroundImage instead')
  final String? backgrounImage; // legacy misspelling

  @Deprecated('Use useBackgroundImage instead')
  final bool backgroundImageHave;

  @Deprecated('Use safeAreaTop instead')
  final bool top;

  @Deprecated('Use horizontalPadding instead')
  final double? horizontal;

  @Deprecated('Use verticalPadding instead')
  final double? vertical;

  @Deprecated('Use onTapOutside instead')
  final VoidCallback? onTap;

  // ===== Proxied Scaffold params =====

  /// Key passed to underlying [Scaffold].
  final Key? scaffoldKey;

  /// Optional app bar.
  final PreferredSizeWidget? appBar;

  /// Main content of the screen. When changed, transitions via [AnimatedSwitcher].
  final Widget? body;

  /// Optional FAB.
  final Widget? floatingActionButton;

  /// FAB location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// FAB animator.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Footer buttons.
  final List<Widget>? persistentFooterButtons;

  /// Alignment for footer buttons.
  final AlignmentDirectional persistentFooterAlignment;

  /// Left drawer widget.
  final Widget? drawer;

  /// Drawer open/close callback.
  final ValueChanged<bool>? onDrawerChanged;

  /// Right drawer widget.
  final Widget? endDrawer;

  /// Right drawer open/close callback.
  final ValueChanged<bool>? onEndDrawerChanged;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Persistent bottom sheet.
  final Widget? bottomSheet;

  /// Whether to avoid inset when keyboard is shown.
  final bool? resizeToAvoidBottomInset;

  /// Whether this is the primary scaffold.
  final bool primary;

  /// Drawer drag behavior.
  final DragStartBehavior drawerDragStartBehavior;

  /// Whether body extends behind bottom navigation bar.
  final bool extendBody;

  /// Whether body extends behind app bar.
  final bool extendBodyBehindAppBar;

  /// Scrim color for drawer.
  final Color? drawerScrimColor;

  /// Edge drag width for drawer.
  final double? drawerEdgeDragWidth;

  /// Enable left drawer drag gesture.
  final bool drawerEnableOpenDragGesture;

  /// Enable right drawer drag gesture.
  final bool endDrawerEnableOpenDragGesture;

  /// Restoration id for state restoration.
  final String? restorationId;

  const ScaffoldPlus({
    // Modern API
    super.key,
    this.useBackgroundImage = false,
    this.backgroundImage,
    this.backgroundColor,
    this.safeAreaTop = true,
    this.safeAreaBottom = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.switchDuration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.easeInOut,
    this.switchOutCurve = Curves.easeInOut,
    this.onTapOutside,

    // Legacy (kept for source-compat)
    this.backgrounImage,
    this.backgroundImageHave = false,
    this.top = true,
    this.horizontal,
    this.vertical,
    this.onTap,

    // Proxied Scaffold
    this.scaffoldKey,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset = true,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    // Map legacy -> modern with local ignores so analyzer stays green on pub.dev.
    // ignore: deprecated_member_use_from_same_package
    final bool legacyUseBg = backgroundImageHave;
    // ignore: deprecated_member_use_from_same_package
    final String? legacyBg = backgrounImage;
    // ignore: deprecated_member_use_from_same_package
    final bool legacyTop = top;
    // ignore: deprecated_member_use_from_same_package
    final double? legacyH = horizontal;
    // ignore: deprecated_member_use_from_same_package
    final double? legacyV = vertical;

    final bool effectiveUseBg = useBackgroundImage || legacyUseBg;
    final String? effectiveBg = backgroundImage ?? legacyBg;
    final double effectiveHorizontal = horizontalPadding ?? legacyH ?? 0;
    final double effectiveVertical = verticalPadding ?? legacyV ?? 0;
    final bool effectiveSafeTop = safeAreaTop && legacyTop;

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        FocusScope.of(context).unfocus();
        onTapOutside?.call();
        // ignore: deprecated_member_use_from_same_package
        onTap?.call();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: appBar,
        backgroundColor: backgroundColor ?? const Color(0xFF2532A4),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        drawerDragStartBehavior: drawerDragStartBehavior,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        drawerScrimColor: drawerScrimColor,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        restorationId: restorationId,
        drawer: drawer,
        onDrawerChanged: onDrawerChanged,
        endDrawer: endDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        persistentFooterButtons: persistentFooterButtons,
        persistentFooterAlignment: persistentFooterAlignment,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        body: AnimatedSwitcher(
          duration: switchDuration,
          switchInCurve: switchInCurve,
          switchOutCurve: switchOutCurve,
          child: Container(
            key: ValueKey<Object?>(body?.key),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: (effectiveUseBg && effectiveBg != null)
                  ? DecorationImage(
                      image: AssetImage(effectiveBg),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: SafeArea(
              top: effectiveSafeTop,
              bottom: safeAreaBottom,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: effectiveHorizontal,
                  vertical: effectiveVertical,
                ),
                child: body ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
