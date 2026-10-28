import 'package:flutter/material.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // I changed this this color to D1B1C8 so it matches the theme
  static const Color brandColor = Color(0xFFD1B1C8);

  // The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🎂 Potion B: Birth-date picker fields
  DateTime? _birthDate;
  final TextEditingController _dateController = TextEditingController();

  // 🎛️ Potion A: Password visibility toggle
  bool _obscurePassword = true;

  // ⏳ Potion C: Loading state before navigation
  bool _submitting = false;

  // Task A: Fixed local preset demo tips (no network/HTTP used)
  final List<String> _demoTips = [
    'Use at least 8 characters with a mix of letters and numbers so it is hard to guess.',
    'Do not reuse passwords across multiple websites or apps.',
    'Combine unrelated words to make a strong password that is easy to remember.',
    'Avoid using obvious personal info like birthdays, pet names, or phone numbers in your password.',
    'Consider using a reputable password manager to generate and store complex, unique credentials.',
    'Make sure your email address is correct and accessible so you never get locked out of your account.',
    'Add special characters like exclamation marks, hashes, or dollar signs to boost password strength.',
    'Enable two-factor authentication whenever available to add an extra layer of account protection.',
  ];

  int _tipIndex = 0;
  bool _isLoadingTip = false;
  String? _displayedTip;
  String? _tipError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ⏳ Potion C: Submit with 2s loading state and pushReplacement
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true); // potion starts brewing
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return; // user may have left the screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: _nameController.text.trim(),
        ),
      ),
    );
  }

  // Task A: Local tip simulation
  Future<void> _fetchLocalTip({bool forceError = false}) async {
    setState(() {
      _isLoadingTip = true;
      _displayedTip = null;
      _tipError = null;
    });

    // Brief local delay to simulate loading state
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    if (forceError) {
      setState(() {
        _tipError = 'Could not load tip. Tap retry.';
        _isLoadingTip = false;
      });
      return;
    }

    setState(() {
      _displayedTip = _demoTips[_tipIndex % _demoTips.length];
      _tipIndex++;
      _isLoadingTip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haunted Signup Laboratory'),
        backgroundColor: brandColor,
        foregroundColor: const Color(0xFF14101F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🎂 Potion B — Birth-date picker
              TextFormField(
                controller: _dateController,
                readOnly: true, // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (_) =>
                    _birthDate == null ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(), // no future birthdays!
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 🧪 Potion A — Password Field with visibility toggle
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: brandColor),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: brandColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Task A: Local sample tip action
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _isLoadingTip ? null : () => _fetchLocalTip(),
                  onLongPress: () => _fetchLocalTip(forceError: true),
                  icon: const Icon(Icons.lightbulb_outline,
                      size: 18, color: brandColor),
                  label: const Text(
                    'Get a signup tip',
                    style: TextStyle(
                        color: brandColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_isLoadingTip)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text('Loading demo tip...'),
                ),
              if (_displayedTip != null)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    'Tip: $_displayedTip',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2C6B61),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_tipError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _tipError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _fetchLocalTip(forceError: false),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // ⏳ Potion C — Join the Mansion Button with loading state
              ElevatedButton(
                onPressed: _submitting ? null : _submit, // null = disabled
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  foregroundColor: const Color(0xFF14101F),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF14101F),
                        ),
                      )
                    : const Text(
                        'Join the Mansion',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
