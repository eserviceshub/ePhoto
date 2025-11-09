import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/extensions/build_context_extensions.dart';
import 'package:immich_mobile/providers/api.provider.dart';
import 'package:immich_mobile/providers/server_info.provider.dart';
import 'package:immich_mobile/routing/router.dart';
import 'package:immich_mobile/widgets/common/immich_logo.dart';
import 'package:immich_mobile/widgets/common/immich_title_text.dart';
import 'package:immich_mobile/widgets/common/immich_toast.dart';
import 'package:immich_mobile/widgets/forms/login/email_input.dart';
import 'package:immich_mobile/widgets/forms/login/loading_icon.dart';
import 'package:immich_mobile/widgets/forms/login/password_input.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';

class RegisterForm extends HookConsumerWidget {
  RegisterForm({super.key});

  final log = Logger('RegisterForm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController.fromValue(TextEditingValue.empty);
    final emailController = useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordController = useTextEditingController.fromValue(TextEditingValue.empty);
    final confirmPasswordController = useTextEditingController.fromValue(TextEditingValue.empty);

    final nameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();

    final isLoading = useState<bool>(false);
    final logoAnimationController = useAnimationController(duration: const Duration(seconds: 60))..repeat();
    final registerFormKey = GlobalKey<FormState>();

    register() async {
      // Validate form
      if (!registerFormKey.currentState!.validate()) {
        return;
      }

      // Check if passwords match
      if (passwordController.text != confirmPasswordController.text) {
        ImmichToast.show(
          context: context,
          msg: "register_form_passwords_do_not_match".tr(),
          toastType: ToastType.error,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      // Check password length
      if (passwordController.text.length < 8) {
        ImmichToast.show(
          context: context,
          msg: "register_form_password_too_short".tr(),
          toastType: ToastType.error,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      isLoading.value = true;

      try {
        final serverInfo = ref.read(serverInfoProvider);
        final apiService = ref.read(apiServiceProvider);

        // Check if server is already initialized
        if (serverInfo.serverConfig.isInitialized) {
          // Server is already initialized, check if public registration is allowed
          if (serverInfo.serverConfig.publicUsers) {
            // Public registration is allowed, but we need to find the correct endpoint
            // For now, show a message that registration is not available through this form
            ImmichToast.show(
              context: context,
              msg: "register_form_public_registration_not_available".tr(),
              toastType: ToastType.info,
              gravity: ToastGravity.TOP,
            );
            return;
          } else {
            // Public registration is disabled
            ImmichToast.show(
              context: context,
              msg: "register_form_public_registration_disabled".tr(),
              toastType: ToastType.error,
              gravity: ToastGravity.TOP,
            );
            return;
          }
        }

        final signUpDto = SignUpDto(
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          password: passwordController.text,
        );

        await apiService.authenticationApi.signUpAdmin(signUpDto);

        ImmichToast.show(
          context: context,
          msg: "register_form_success".tr(),
          toastType: ToastType.success,
          gravity: ToastGravity.TOP,
        );

        // Navigate back to login page
        context.maybePop();
      } catch (error) {
        log.severe('Error during registration: $error');

        String errorMessage = "register_form_failed".tr();
        if (error is ApiException) {
          errorMessage = error.message ?? errorMessage;
        }

        ImmichToast.show(
          context: context,
          msg: errorMessage,
          toastType: ToastType.error,
          gravity: ToastGravity.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Form(
                key: registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: constraints.maxHeight / 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RotationTransition(
                          turns: logoAnimationController,
                          child: const ImmichLogo(heroTag: 'logo'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 16),
                          child: ImmichTitleText(),
                        ),
                        Text(
                          'register_form_title'.tr(),
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'register_form_subtitle'.tr(),
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    TextFormField(
                      controller: nameController,
                      focusNode: nameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'register_form_name_label'.tr(),
                        border: const OutlineInputBorder(),
                        hintText: 'register_form_name_hint'.tr(),
                      ),
                      onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'register_form_name_required'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    EmailInput(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      onSubmit: passwordFocusNode.requestFocus,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    PasswordInput(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      onSubmit: confirmPasswordFocusNode.requestFocus,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    TextFormField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'register_form_confirm_password_label'.tr(),
                        border: const OutlineInputBorder(),
                        hintText: 'register_form_confirm_password_hint'.tr(),
                      ),
                      onFieldSubmitted: (_) => register(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'register_form_confirm_password_required'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register button or loading indicator
                    isLoading.value
                        ? const LoadingIcon()
                        : ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'register_form_button'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
