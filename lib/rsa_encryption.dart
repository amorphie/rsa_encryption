import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  final RSAPublicKey publicKey;

  RSAEncryption(this.publicKey);

  String encrypt(String plainTextPassword) {
    final encryptor = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encryptor.encrypt(plainTextPassword);
    return encrypted.base64;
  }

  static RSAPublicKey parsePublicKeyFromPem(String pemString) {
    final parser = RSAKeyParser();
    return parser.parse(pemString) as RSAPublicKey;
  }
}