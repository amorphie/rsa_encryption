import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:xml/xml.dart';
import 'package:pointycastle/export.dart';
 
String convertXmlToPem(String xml) {

  // Parse the XML

  final document = XmlDocument.parse(xml);

  final modulusBase64 = document.findAllElements('Modulus').single.text;

  final exponentBase64 = document.findAllElements('Exponent').single.text;
 
  // Decode Base64 to bytes

  final modulusBytes = base64.decode(modulusBase64);

  final exponentBytes = base64.decode(exponentBase64);
 
  // Convert bytes to BigInt

  final modulus = BigInt.parse(base64.encode(modulusBytes));

  final exponent = BigInt.parse(base64.encode(exponentBytes));
 
  // Create RSA public key

  final publicKey = RSAPublicKey(modulus, exponent);
 
  // Convert to PEM format

  return _encodeToPem(publicKey);

}
 
String _encodeToPem(RSAPublicKey publicKey) {

  final encodedKey = publicKey.modulus!.toRadixString(16).padLeft(128, '0');

  final base64Key = base64.encode(hex.decode(encodedKey));

  final pemKey = '-----BEGIN PUBLIC KEY-----\n'

                 '${_wrapBase64(base64Key)}'

                 '-----END PUBLIC KEY-----';

  return pemKey;

}
 
String _wrapBase64(String base64Key) {

  const lineLength = 64;

  final buffer = StringBuffer();

  for (var i = 0; i < base64Key.length; i += lineLength) {

    buffer.writeln(base64Key.substring(i, i + lineLength.clamp(0, base64Key.length - i)));

  }

  return buffer.toString();

}

 

class RSAEncryption {
  final RSAPublicKey publicKey;

  RSAEncryption(this.publicKey);

  String encrypt(String plainTextPassword) {
    final encryptor = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encryptor.encrypt(plainTextPassword);
    return encrypted.base64;
  }

  static RSAPublicKey parsePublicKeyFromPem(String pemString) {
    final pk = parseRSAPublicKeyFromXml(pemString);
    return pk;
    // final parser = RSAKeyParser();

    // return parser.parse(pk) as RSAPublicKey;
  }

  static RSAPublicKey parseRSAPublicKeyFromXml(String xml) {
    final document = XmlDocument.parse(xml);
    final modulusBase64 = document.findAllElements('Modulus').single.text;
    final exponentBase64 = document.findAllElements('Exponent').single.text;
 
    final modulusBytes = base64.decode(modulusBase64);
    final exponentBytes = base64.decode(exponentBase64);
 
    final modulus = BigInt.parse(hex.encode(modulusBytes), radix: 16);
    final exponent = BigInt.parse(hex.encode(exponentBytes), radix: 16);
 
    return RSAPublicKey(modulus, exponent);
  }
}