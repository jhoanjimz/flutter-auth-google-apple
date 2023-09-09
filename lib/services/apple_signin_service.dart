

import 'dart:io';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class AppleSignInService {

  static String clientId = 'gov.co.santamarta.flutterauthapp';
  static String redirectUri= 'https://app-google-apple-signin-0f15519ad111.herokuapp.com/callbacks/sign_in_with_apple';

  static void signIn() async {

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: clientId,
          redirectUri: Uri.parse(redirectUri)
        )
      );

      final signInWithAppleEndpoint = Uri(
        scheme: 'https',
        host: 'app-google-apple-signin-0f15519ad111.herokuapp.com',
        path: '/sign_in_with_apple',
        queryParameters: {
          'code': credential.authorizationCode,
          'firstName': credential.givenName,
          'lastName': credential.familyName,
          'useBundleId': Platform.isIOS ? 'true' : 'false',
          if (credential.state != null) 'state': credential.state
        }
      );

      final session = await http.post(signInWithAppleEndpoint);
      print("====================== RESPUESTA DE MI SERVICIO ======================");
      print(session.body);

    } catch (e) {
      print('Error en signIn $e');
    }

  }

}