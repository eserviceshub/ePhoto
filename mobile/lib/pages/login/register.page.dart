import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/extensions/build_context_extensions.dart';
import 'package:immich_mobile/extensions/theme_extensions.dart';
import 'package:immich_mobile/widgets/forms/login/register_form.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = useState('0.0.0');

    getAppInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    }

    useEffect(() {
      getAppInfo();
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.maybePop(),
        ),
      ),
      body: RegisterForm(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                'v${appVersion.value}',
                style: TextStyle(
                  color: context.colorScheme.onSurfaceSecondary,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inconsolata",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
