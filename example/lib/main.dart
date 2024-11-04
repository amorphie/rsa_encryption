import 'package:flutter/material.dart';
import 'package:rsa_encryption_package/rsa_encryption.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSA Şifreleme Örneği',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EncryptionDemo(),
    );
  }
}

class EncryptionDemo extends StatefulWidget {
  @override
  _EncryptionDemoState createState() => _EncryptionDemoState();
}

class _EncryptionDemoState extends State<EncryptionDemo> {
  final TextEditingController _passwordController = TextEditingController();
  String? encryptedPassword;

  void encryptPassword() {
    const publicKeyPem = '<?xml version=\"1.0\" encoding=\"utf-16\"?>\n<RSAParameters xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n  <Exponent>AQAB</Exponent>\n  <Modulus>rEta+dh45Z+zwU5+mYUfKA6S0lMM0+n3kTZmoXP4+4r8PtIMyhxBgoqmiDv7sdnkqWVNDAvEnHIECJWhunHnbnknOzqlOe3EJaSmLUFeHftGS9RQRb0LJmLzTiTS9utW85xu/GP3k9qggmpUHEI867JGBZzNyUfLbTZdqdXD/7TBKanxYs18PeiYCk5KO9/4MDqJxIoKonpJbtviNViCQgWcqNmwJEBesVBnmOJElhn/TXkq+4i7Kf3xiTXMs453VVv5Bdns2HYctwN9duGNfRSBfPbzNoJ+X4YS4/SG5OlKHZKJ0Mb9fSZd+Br6MyqWG/b3UBS2UFR38xwn82sUcQ==</Modulus>\n</RSAParameters>';
    try {
      final publicKey = RSAEncryption.parsePublicKeyFromPem(publicKeyPem);
      final rsaEncryption = RSAEncryption(publicKey);

      setState(() {
        encryptedPassword = rsaEncryption.encrypt(_passwordController.text);
      });
      print(encryptedPassword);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSA Şifreleme Örneği'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifrenizi Girin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: encryptPassword,
              child: Text('Şifrele'),
            ),
            SizedBox(height: 20),
            if (encryptedPassword != null)
              Text(
                'Şifrelenmiş Şifre: $encryptedPassword',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
