import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:termora/app/theme/app_theme.dart';
import 'package:termora/features/settings/controller/setting_providers.dart';

/// 打开设置弹窗
Future<void> showSettingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const SettingsDialog(),
  );
}

/// 设置弹窗 — 外观(主题模式 + 品牌主色),与 superdesk 同一套配色体系
class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeControllerProvider);
    final brandColor = ref.watch(appBrandColorControllerProvider);
    final locale = ref.watch(appLocaleControllerProvider);
    final l10n = AppL10n.resolve(locale);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.settings, size: 18, color: AppTheme.brandColor),
                  const SizedBox(width: 8),
                  Text(
                    l10n.settings,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.headingColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: l10n.close,
                    icon: Icon(
                      LucideIcons.x,
                      size: 16,
                      color: AppTheme.subtleTextColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── 界面语言 ──
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtleTextColor,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<AppLocale>(
                  segments: [
                    ButtonSegment(
                      value: AppLocale.system,
                      label: Text(l10n.followSystem),
                      icon: const Icon(LucideIcons.languages, size: 14),
                    ),
                    ButtonSegment(
                      value: AppLocale.zh,
                      label: Text(l10n.chinese),
                    ),
                    ButtonSegment(
                      value: AppLocale.en,
                      label: Text(l10n.english),
                    ),
                  ],
                  selected: {locale},
                  onSelectionChanged: (selection) {
                    ref
                        .read(appLocaleControllerProvider.notifier)
                        .setLocale(selection.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: const WidgetStatePropertyAll(
                      TextStyle(fontSize: 12.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── 主题模式 ──
              Text(
                l10n.theme,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtleTextColor,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.followSystem),
                      icon: const Icon(LucideIcons.monitor, size: 14),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.lightTheme),
                      icon: const Icon(LucideIcons.sun, size: 14),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.darkTheme),
                      icon: const Icon(LucideIcons.moon, size: 14),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(appThemeControllerProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: const WidgetStatePropertyAll(
                      TextStyle(fontSize: 12.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── 品牌主色 ──
              Text(
                l10n.brandColor,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtleTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final color in AppBrandColor.values)
                    _BrandColorSwatch(
                      color: color,
                      isDark: isDark,
                      selected: color == brandColor,
                      onTap: () => ref
                          .read(appBrandColorControllerProvider.notifier)
                          .setColor(color),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.brandColorDesc,
                style: TextStyle(fontSize: 11, color: AppTheme.subtleTextColor),
              ),

              const SizedBox(height: 20),
              Divider(height: 1, color: AppTheme.borderColor),
              const SizedBox(height: 16),

              // ── 关于 Termora (About) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.info, size: 16, color: AppTheme.brandColor),
                        const SizedBox(width: 8),
                        Text(
                          l10n.aboutTermora,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.headingColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.brandColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'v0.0.1+1',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brandColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.aboutTagline,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.bodyColor,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(LucideIcons.externalLink, size: 13, color: AppTheme.subtleTextColor),
                        const SizedBox(width: 5),
                        Text(
                          'https://github.com/pynets/termora',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.subtleTextColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'MIT License',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.subtleTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandColorSwatch extends StatelessWidget {
  const _BrandColorSwatch({
    required this.color,
    required this.isDark,
    required this.selected,
    required this.onTap,
  });

  final AppBrandColor color;
  final bool isDark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = isDark ? color.darkBrandColor : color.lightBrandColor;

    return Tooltip(
      message: color.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? swatch : AppTheme.borderColor,
              width: selected ? 1.6 : 1,
            ),
            color: selected
                ? swatch.withValues(alpha: 0.10)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: swatch, shape: BoxShape.circle),
                child: selected
                    ? const Icon(Icons.check, size: 15, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                // label 形如「青色 (Teal)」,取中文部分显示
                color.label.split(' ').first,
                style: TextStyle(
                  fontSize: 10.5,
                  color: selected ? AppTheme.headingColor : AppTheme.bodyColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
