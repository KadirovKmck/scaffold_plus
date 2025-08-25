import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A drop-in replacement over [Scaffold] that adds:
/// 1) Background image layer
/// 2) SafeArea toggles with custom paddings
/// 3) AnimatedSwitcher for body transitions
/// 4) Tap-to-unfocus behavior
///
/// All common [Scaffold] params are proxied, so you can use it as a full
/// Scaffold with extra sugar on top.
class ScaffoldPlus extends StatelessWidget {
  // ===== Custom additions =====
  final bool useBackgroundImage;
  final String? backgroundImage;
  final Color? backgroundColor;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Duration switchDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final VoidCallback? onTapOutside;

  // Backward compatibility (deprecated but supported)
  @Deprecated('Use backgroundImage instead')
  final String? backgrounImage;
  @Deprecated('Use useBackgroundImage instead')
  final bool backgrounImageHave;
  @Deprecated('Use safeAreaTop instead')
  final bool top;
  @Deprecated('Use horizontalPadding instead')
  final double? horizontal;
  @Deprecated('Use verticalPadding instead')
  final double? vertical;
  @Deprecated('Use onTapOutside instead')
  final Function()? onTap;

  // ===== Proxied Scaffold params =====
  final Key? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final ValueChanged<bool>? onDrawerChanged;
  final Widget? endDrawer;
  final ValueChanged<bool>? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  const ScaffoldPlus({
    // Custom
    super.key,
    this.useBackgroundImage = false,
    this.backgroundImage,
    this.backgroundColor,
    this.safeAreaTop = true,
    this.safeAreaBottom = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.switchDuration = const Duration(milliseconds: 800),
    this.switchInCurve = Curves.easeInOut,
    this.switchOutCurve = Curves.easeInOut,
    this.onTapOutside,

    // Back-compat (don’t remove until you мигрируешь в проекте)
    this.backgrounImage,
    this.backgrounImageHave = false,
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
    // Migrate deprecated fields to new ones if provided
    final effectiveUseBg = useBackgroundImage || backgrounImageHave;
    final effectiveBgImage =
        backgroundImage ?? backgrounImage ?? 'assets/images/bg.png';
    final effectiveHorizontal = horizontalPadding ?? horizontal ?? 0;
    final effectiveVertical = verticalPadding ?? vertical ?? 0;
    final effectiveSafeTop = safeAreaTop && top; // keep legacy toggle respected

    return GestureDetector(
      onTap: () {
        // 1) снятие фокуса
        FocusScope.of(context).unfocus();
        // 2) пользовательский колбэк
        onTapOutside?.call();
        onTap?.call(); // legacy
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
            key: ValueKey<Object?>(body?.key), // стабильная анимация
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: effectiveUseBg
                  ? DecorationImage(
                      image: AssetImage(effectiveBgImage),
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
