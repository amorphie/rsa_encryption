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
    const publicKeyPem = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApYd2/xoBG/XKISkoM4qj
o17YAi5+gL19OfLbmAH8XKdCjBFMhH2ginSp6SSX5UDXn7nrzzEBK0wkoZZUD6KX
iXaALQimu5uXqVdAqYO2xcFt+n1gYOrzlIXy23hcTqPAxEcz1Wk8H8ob6SfDxL7O
6O7D3emCzdYgDnsViWROSrja4MO2YXFur/hNUAYxFonMo2x0sis90Ic4KcwFlhx8
FazbffMcMGsV+VpNmRqFBi00eG4GyaC/Q2v07me+tEoVnwnNBdqzEblFIyulAZzC
JAN1YFAsbcjL459yU31Bx1Gxu2XWuukKCE88D10kzNGYF+4mVkeF8ska5kDQERDL
dwIDAQAB
-----END PUBLIC KEY-----''';
    try {
      final publicKey = RSAEncryption.parsePublicKeyFromPem(publicKeyPem);
      final rsaEncryption = RSAEncryption(publicKey);

      setState(() {
        encryptedPassword = rsaEncryption.encrypt(_passwordController.text);
      });
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
