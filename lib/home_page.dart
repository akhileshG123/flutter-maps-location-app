import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:provider/provider.dart';
import 'package:ridesense_location_app/location_screen.dart';
import 'location_provider.dart';

class LocationInputScreen extends StatefulWidget {
  const LocationInputScreen({super.key});

  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Function to show an error message in a SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Provider.of<LocationProvider>(context, listen: false)
            .setLocation(_locationController.text);

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NextScreen(location: _locationController.text),
          ),
        );
      } catch (e) {
        _showErrorSnackBar('An error occurred: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Image.asset(
                'assets/images/ridesense.png',
                height: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  _showErrorSnackBar(
                      'Failed to load image: ${error.toString()}');
                  return const Icon(Icons.error);
                },
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        'Enter your Desired Location ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Enter city name, address, or coordinates',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: PrettyWaveButton(
                        onPressed: () => _navigateToNextScreen(context),
                        child: const Text('Next',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}

class NextScreen extends StatelessWidget {
  final String location;

  const NextScreen({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return const LocationScreen();
  }
}
