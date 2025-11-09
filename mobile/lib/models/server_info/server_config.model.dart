import 'package:openapi/api.dart';

class ServerConfig {
  final int trashDays;
  final String oauthButtonText;
  final String externalDomain;
  final String mapDarkStyleUrl;
  final String mapLightStyleUrl;
  final bool publicUsers;
  final bool isOnboarded;
  final bool isInitialized;
  final String loginPageMessage;
  final int userDeleteDelay;

  const ServerConfig({
    required this.trashDays,
    required this.oauthButtonText,
    required this.externalDomain,
    required this.mapDarkStyleUrl,
    required this.mapLightStyleUrl,
    required this.publicUsers,
    required this.isOnboarded,
    required this.isInitialized,
    required this.loginPageMessage,
    required this.userDeleteDelay,
  });

  ServerConfig copyWith({
    int? trashDays,
    String? oauthButtonText,
    String? externalDomain,
    String? mapDarkStyleUrl,
    String? mapLightStyleUrl,
    bool? publicUsers,
    bool? isOnboarded,
    bool? isInitialized,
    String? loginPageMessage,
    int? userDeleteDelay,
  }) {
    return ServerConfig(
      trashDays: trashDays ?? this.trashDays,
      oauthButtonText: oauthButtonText ?? this.oauthButtonText,
      externalDomain: externalDomain ?? this.externalDomain,
      mapDarkStyleUrl: mapDarkStyleUrl ?? this.mapDarkStyleUrl,
      mapLightStyleUrl: mapLightStyleUrl ?? this.mapLightStyleUrl,
      publicUsers: publicUsers ?? this.publicUsers,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isInitialized: isInitialized ?? this.isInitialized,
      loginPageMessage: loginPageMessage ?? this.loginPageMessage,
      userDeleteDelay: userDeleteDelay ?? this.userDeleteDelay,
    );
  }

  @override
  String toString() =>
      'ServerConfig(trashDays: $trashDays, oauthButtonText: $oauthButtonText, externalDomain: $externalDomain, publicUsers: $publicUsers, isInitialized: $isInitialized)';

  ServerConfig.fromDto(ServerConfigDto dto)
    : trashDays = dto.trashDays,
      oauthButtonText = dto.oauthButtonText,
      externalDomain = dto.externalDomain,
      mapDarkStyleUrl = dto.mapDarkStyleUrl,
      mapLightStyleUrl = dto.mapLightStyleUrl,
      publicUsers = dto.publicUsers,
      isOnboarded = dto.isOnboarded,
      isInitialized = dto.isInitialized,
      loginPageMessage = dto.loginPageMessage,
      userDeleteDelay = dto.userDeleteDelay;

  @override
  bool operator ==(covariant ServerConfig other) {
    if (identical(this, other)) return true;

    return other.trashDays == trashDays &&
        other.oauthButtonText == oauthButtonText &&
        other.externalDomain == externalDomain &&
        other.publicUsers == publicUsers &&
        other.isOnboarded == isOnboarded &&
        other.isInitialized == isInitialized &&
        other.loginPageMessage == loginPageMessage &&
        other.userDeleteDelay == userDeleteDelay;
  }

  @override
  int get hashCode =>
      trashDays.hashCode ^
      oauthButtonText.hashCode ^
      externalDomain.hashCode ^
      publicUsers.hashCode ^
      isOnboarded.hashCode ^
      isInitialized.hashCode ^
      loginPageMessage.hashCode ^
      userDeleteDelay.hashCode;
}
