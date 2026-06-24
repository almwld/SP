import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phone;
  const OtpVerificationScreen({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد الرمز'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sms, size: 80, color: Color(0xFF0D9488)),
            const SizedBox(height: 20),
            const Text(
              'تم إرسال رمز التحقق إلى',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              phone,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => SizedBox(
                width: 45,
                height: 55,
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              )),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تأكيد الرمز')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                ),
                child: const Text('تأكيد'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('إعادة إرسال الرمز'),
            ),
          ],
        ),
      ),
    );
  }
}
