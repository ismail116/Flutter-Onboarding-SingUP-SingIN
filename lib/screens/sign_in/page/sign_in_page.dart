import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleuth/core/const/color_constants.dart';
import 'package:sleuth/core/const/text_constants.dart';
import 'package:sleuth/core/services/validation_service.dart';
import 'package:sleuth/screens/common_widgets/sleuth_button.dart';
import 'package:sleuth/screens/common_widgets/sleuth_loading.dart';
import 'package:sleuth/screens/common_widgets/sleuth_text_field.dart';
import 'package:sleuth/screens/common_widgets/tab_bar.dart';
import 'package:sleuth/screens/sign_in/bloc/sign_in_bloc.dart';
import 'package:sleuth/screens/sign_in/widget/sign_in_content.dart';
import 'package:sleuth/screens/sign_up/page/sign_up_page.dart';
import 'package:sleuth/screens/forgot_password/page/forgot_password_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
    );
  }

  BlocProvider<SignInBloc> _buildContext(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (BuildContext context) => SignInBloc(),
      child: BlocConsumer<SignInBloc, SignInState>(
        buildWhen: (_, currState) => currState is SignInInitial,
        builder: (context, state) {
          return SignInContent();
        },
        listenWhen: (_, currState) =>
            currState is NextForgotPasswordPageState ||
            currState is NextSignUpPageState ||
            currState is NextTabBarPageState ||
            currState is ErrorState,
        listener: (context, state) {
          if (state is NextForgotPasswordPageState) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
          } else if (state is NextSignUpPageState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => SignUpPage()));
          } else if (state is NextTabBarPageState) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => TabBarPage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }

  Widget _createLoading() {
    return SleuthLoading();
  }

  Widget _createHeader() {
    return Center(
      child: Text(
        TextConstants.signIn,
        style: TextStyle(
          color: ColorConstants.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (_, currState) => currState is ShowErrorState,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SleuthTextField(
              title: TextConstants.email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              placeholder: TextConstants.emailPlaceholder,
              controller: bloc.emailController,
              errorText: TextConstants.emailErrorText,
              isError: state is ShowErrorState
                  ? !ValidationService.email(bloc.emailController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangeEvent());
              },
            ),
            const SizedBox(height: 20),
            SleuthTextField(
              title: TextConstants.password,
              placeholder: TextConstants.passwordPlaceholderSignIn,
              controller: bloc.passwordController,
              errorText: TextConstants.passwordErrorText,
              isError: state is ShowErrorState
                  ? !ValidationService.password(bloc.passwordController.text)
                  : false,
              obscureText: true,
              onTextChanged: () {
                bloc.add(OnTextChangeEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createForgotPasswordButton(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 21),
        child: Text(
          TextConstants.forgotPassword,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryColor,
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        bloc.add(ForgotPasswordTappedEvent());
      },
    );
  }

  Widget _createSignInButton(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (_, currState) =>
            currState is SignInButtonEnableChangedState,
        builder: (context, state) {
          return SleuthButton(
            title: TextConstants.signIn,
            isEnabled: state is SignInButtonEnableChangedState
                ? state.isEnabled
                : false,
            onTap: () {
              FocusScope.of(context).unfocus();
              bloc.add(SignInTappedEvent());
            },
          );
        },
      ),
    );
  }

  Widget _createDoNotHaveAccountText(BuildContext context) {
    final bloc = BlocProvider.of<SignInBloc>(context);
    return Center(
      child: RichText(
        text: TextSpan(
          text: TextConstants.doNotHaveAnAccount,
          style: TextStyle(
            color: ColorConstants.textBlack,
            fontSize: 18,
          ),
          children: [
            TextSpan(
              text: " ${TextConstants.signUp}",
              style: TextStyle(
                color: ColorConstants.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  bloc.add(SignUpTappedEvent());
                },
            ),
          ],
        ),
      ),
    );
  }
}
