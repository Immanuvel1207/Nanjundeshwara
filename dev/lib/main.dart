import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Get the saved locale
  Locale locale = await AppLocalizations.getLocale();
  
  runApp(MyApp(locale: locale));
}

class MyApp extends StatefulWidget {
  final Locale locale;
  
  MyApp({required this.locale});
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  
  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }
  
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(setLocale: setLocale),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  
  SplashScreen({required this.setLocale});
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    bool? isAdmin = prefs.getBool('isAdmin');

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username, isAdmin: isAdmin, setLocale: widget.setLocale)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FIXED: Added error handling for splash screen image
            Image.asset(
              'assets/jerry.gif',
              height: 150,
              width: 150,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading splash image: $error');
                return Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).translate('app_name'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String? username;
  final bool? isAdmin;
  final Function(Locale) setLocale;
  
  HomeScreen({this.username, this.isAdmin, required this.setLocale});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String shopName = "Sri SivaSakthi Stores";
  final String ownerName = "Mr. Madhu Kumar";
  final String phoneNumber = "+91 9080660749";
  final String serviceDescription = "Specialized in Diwali Chits with various categories to choose from.";
  final String address = "Sri SivaSakthi Stores, Konganapalli Road, Opposite to Aishwarya Hotel, Veppanapalli 635 121";
  final String mapUrl = "https://maps.app.goo.gl/44evAN22mo1KNfTc7";

  late List<Map<String, dynamic>> categories;

  @override
  void initState() {
    super.initState();
    // Add this to debug images after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _debugImages();
    });
  }

  List<Map<String, dynamic>> getLocalizedCategories(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return [
      {
        "title": appLocalizations.translate('gold_category'),
        "amount": "₹500 " + appLocalizations.translate('per_month'),
        "color": "blue",
        "products": [
          {"name": appLocalizations.translate('rice'), "quantity": "25 Kg", "image": "assets/things/ricejpg.jpg"},
          {"name": appLocalizations.translate('maida'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/maida.jpg"},
          {"name": appLocalizations.translate('oil'), "quantity": "5 " + appLocalizations.translate('liters'), "image": "assets/things/oil.jpg"},
          {"name": appLocalizations.translate('wheat_flour'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/atta.jpg"},
          {"name": appLocalizations.translate('white_dhall'), "quantity": "3 Kg", "image": "assets/things/whitedall.jpg"},
          {"name": appLocalizations.translate('rice_raw'), "quantity": "3 Kg", "image": "assets/things/riceraw.jpg"},
          {"name": appLocalizations.translate('semiya'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/semiya.jpg"},
          {"name": appLocalizations.translate('payasam_mix'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/payasam.jpg"},
          {"name": appLocalizations.translate('sugar'), "quantity": "1 Kg", "image": "assets/things/sugar.jpg"},
          {"name": appLocalizations.translate('sesame_oil'), "quantity": "150 " + appLocalizations.translate('grams'), "image": "assets/things/sesame.jpg"},
          {"name": appLocalizations.translate('tamarind'), "quantity": "25 " + appLocalizations.translate('pieces'), "image": "assets/things/tamrind.jpg"},
          {"name": appLocalizations.translate('dry_chilli'), "quantity": "25 " + appLocalizations.translate('pieces'), "image": "assets/things/chilly.jpg"},
          {"name": appLocalizations.translate('coriander_seeds'), "quantity": "11 " + appLocalizations.translate('pieces'), "image": "assets/things/coriander.jpg"},
          {"name": appLocalizations.translate('salt'), "quantity": "1/2 Kg", "image": "assets/things/salt.jpg"},
          {"name": appLocalizations.translate('jaggery'), "quantity": "1/2 Kg", "image": "assets/things/jaggery.jpg"},
          {"name": appLocalizations.translate('pattasu_box'), "quantity": "1 " + appLocalizations.translate('box'), "image": "assets/things/pattasu.jpg"},
          {"name": appLocalizations.translate('matches_box'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/match.jpg"},
          {"name": appLocalizations.translate('turmeric_powder'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/tumeric.jpg"},
          {"name": appLocalizations.translate('kumkum'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/kumkumjpg.jpg"},
          {"name": appLocalizations.translate('camphor'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/camphor.jpg"}
        ],
      },
      {
        "title": appLocalizations.translate('silver_category'),
        "amount": "₹300 " + appLocalizations.translate('per_month'),
        "color": "yellow",
        "products": [
          {"name": appLocalizations.translate('rice'), "quantity": "5 Kg", "image": "assets/things/ricejpg.jpg"},
          {"name": appLocalizations.translate('oil'), "quantity": "5 " + appLocalizations.translate('liters'), "image": "assets/things/oil.jpg"},
          {"name": appLocalizations.translate('white_dhall'), "quantity": "5 Kg", "image": "assets/things/whitedall.jpg"},
          {"name": appLocalizations.translate('sesame_oil'), "quantity": "250 " + appLocalizations.translate('grams'), "image": "assets/things/sesame.jpg"},
          {"name": appLocalizations.translate('tamarind'), "quantity": "25 " + appLocalizations.translate('pieces'), "image": "assets/things/tamrind.jpg"},
          {"name": appLocalizations.translate('dry_chilli'), "quantity": "25 " + appLocalizations.translate('pieces'), "image": "assets/things/chilly.jpg"},
          {"name": appLocalizations.translate('coriander_seeds'), "quantity": "11 " + appLocalizations.translate('pieces'), "image": "assets/things/coriander.jpg"},
          {"name": appLocalizations.translate('maida'), "quantity": "5 Kg", "image": "assets/things/maida.jpg"},
          {"name": appLocalizations.translate('wheat_flour'), "quantity": "5 Kg", "image": "assets/things/atta.jpg"},
          {"name": appLocalizations.translate('oil'), "quantity": "1/2 " + appLocalizations.translate('liter'), "image": "assets/things/oil.jpg"},
          {"name": appLocalizations.translate('semiya'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/semiya.jpg"},
          {"name": appLocalizations.translate('matches_box'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/match.jpg"},
          {"name": appLocalizations.translate('turmeric_powder'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/tumeric.jpg"},
          {"name": appLocalizations.translate('kumkum'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/kumkumjpg.jpg"},
          {"name": appLocalizations.translate('camphor'), "quantity": "1 " + appLocalizations.translate('pack'), "image": "assets/things/camphor.jpg"}
        ],
      }
    ];
  }

  Future<void> _debugImages() async {
    categories = getLocalizedCategories(context);
    for (var category in categories) {
      for (var product in category['products']) {
        try {
          await precacheImage(AssetImage(product['image']), context);
        } catch (e) {
          print('Failed to load: ${product['image']}, error: $e');
        }
      }
    }
  }

  void _showLanguageDialog() {
    final appLocalizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('language_settings')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', 'en'),
              _buildLanguageOption('தமிழ்', 'ta'),
              _buildLanguageOption('हिंदी', 'hi'),
              _buildLanguageOption('తెలుగు', 'te'),
              _buildLanguageOption('ಕನ್ನಡ', 'kn'),
              _buildLanguageOption('اردو', 'ur'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        // Save the selected language
        await AppLocalizations.setLocale(code);
        
        // Update the app locale
        widget.setLocale(Locale(code, ''));
        
        // If user is logged in, update language preference on server
        if (widget.username != null) {
          await AppLocalizations.updateLanguageOnServer(widget.username!, code);
        }
        
        Navigator.of(context).pop();
        
        // Refresh categories with new language
        setState(() {
          categories = getLocalizedCategories(context);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('language_updated'))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    categories = getLocalizedCategories(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(shopName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Language selection button
          IconButton(
            icon: Icon(Icons.language),
            onPressed: _showLanguageDialog,
          ),
          if (widget.username != null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.isAdmin == true
                        ? AdminScreen(setLocale: widget.setLocale)
                        : UserScreen(username: widget.username!, setLocale: widget.setLocale),
                  ),
                );
              },
              child: Text(appLocalizations.translate('actions')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(setLocale: widget.setLocale)),
                );
              },
              child: Text(appLocalizations.translate('login')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/shop.jpg',
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.store, size: 50, color: Colors.grey[600]),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      shopName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildPersonCard(appLocalizations.translate('nanjappan'), appLocalizations.translate('honoured'), 'assets/father.jpg'),
                  buildPersonCard(ownerName, appLocalizations.translate('owner'), 'assets/owner.jpg'),
                  buildPersonCard(appLocalizations.translate('suselamma'), appLocalizations.translate('honoured'), 'assets/mother.jpg'),
                ],
              ),

              const SizedBox(height: 20),

              Text(appLocalizations.translate('address') + ':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(address, style: TextStyle(fontSize: 15)),

              const SizedBox(height: 14),

              /// SMALL BUTTONS SECTION
              Row(
                children: [
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // FIXED: Improved directions functionality
                        try {
                          // First check if we have location permission
                          LocationPermission permission = await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission == LocationPermission.denied) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(appLocalizations.translate('location_permission_denied'))),
                              );
                              return;
                            }
                          }
                          
                          if (permission == LocationPermission.deniedForever) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(appLocalizations.translate('location_permission_permanently_denied'))),
                            );
                            return;
                          }
                          
                          // Try to open Google Maps app first
                          final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=Veppanapalli&destination_place_id=ChIJXbGmYHVdqzsRCLLuI0YpO_A');
                          if (await canLaunchUrl(googleMapsUri)) {
                            await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
                          } else {
                            // Fallback to web URL
                            final Uri webUri = Uri.parse('https://maps.app.goo.gl/44evAN22mo1KNfTc7');
                            if (await canLaunchUrl(webUri)) {
                              await launchUrl(webUri, mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(appLocalizations.translate('could_not_open_maps'))),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(appLocalizations.translate('error_opening_maps') + ': $e')),
                          );
                        }
                      },
                      icon: Icon(Icons.directions, size: 16),
                      label: Text(appLocalizations.translate('directions'), style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // FIXED: Improved phone call functionality
                        try {
                          final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(appLocalizations.translate('cannot_open_phone_dialer'))),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(appLocalizations.translate('error_making_phone_call') + ': $e')),
                          );
                        }
                      },
                      icon: Icon(Icons.phone, size: 16),
                      label: Text(appLocalizations.translate('call'), style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Service Description
              Text(appLocalizations.translate('service_description'), style: TextStyle(fontSize: 15)),
              const SizedBox(height: 20),

              /// Categories
              Text(appLocalizations.translate('categories') + ':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Column(
                children: categories.map((category) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(category['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      subtitle: Text(category['amount'], style: TextStyle(fontSize: 14)),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailsPage(category: category),
                            ),
                          );
                        },
                        child: Text(appLocalizations.translate('view_more')),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          textStyle: TextStyle(fontSize: 13),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonCard(String name, String role, String imagePath) {
    return Column(
      children: [
        // FIXED: Added error handling for person images
        Image.asset(
          imagePath, 
          height: 100, 
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading person image: $imagePath - $error');
            return Container(
              height: 100,
              width: 100,
              color: Colors.grey[300],
              child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
            );
          },
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(role, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

// FIXED: CategoryDetailsPage with proper image loading
class CategoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryDetailsPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(category['title']),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              category['amount'],
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              appLocalizations.translate('products') + ':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: category['products'].length,
                itemBuilder: (context, index) {
                  final product = category['products'][index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        product['image'],
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading product image: ${product['image']} - $error');
                          return Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                          );
                        },
                      ),
                      title: Text(product['name']),
                      subtitle: Text(product['quantity']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  
  LoginScreen({required this.setLocale});
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'username': _username, 'password': _password}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success']) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', _username);
            await prefs.setBool('isAdmin', data['isAdmin']);
            
            // Save the language preference if available
            if (data['language'] != null) {
              await AppLocalizations.setLocale(data['language']);
              widget.setLocale(Locale(data['language'], ''));
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(username: _username, isAdmin: data['isAdmin'], setLocale: widget.setLocale)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).translate('invalid_credentials'))),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).translate('login_failed'))),
          );
        }
      } catch (e) {
        print('Error during login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('error_occurred'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('login')),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Language selection button
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(appLocalizations.translate('language_settings')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption('English', 'en'),
                        _buildLanguageOption('தமிழ்', 'ta'),
                        _buildLanguageOption('हिंदी', 'hi'),
                        _buildLanguageOption('తెలుగు', 'te'),
                        _buildLanguageOption('ಕನ್ನಡ', 'kn'),
                        _buildLanguageOption('اردو', 'ur'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: appLocalizations.translate('user_id')),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_user_id') : null,
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: appLocalizations.translate('phone_number')),
                keyboardType: TextInputType.phone,
                obscureText: true,
                validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_phone_number') : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(appLocalizations.translate('login')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        // Save the selected language
        await AppLocalizations.setLocale(code);
        
        // Update the app locale
        widget.setLocale(Locale(code, ''));
        
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('language_updated'))),
        );
      },
    );
  }
}

class AdminScreen extends StatelessWidget {
  final Function(Locale) setLocale;
  
  AdminScreen({required this.setLocale});
  
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(setLocale: setLocale)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('admin_dashboard')),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Language selection button
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(appLocalizations.translate('language_settings')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption(context, 'English', 'en'),
                        _buildLanguageOption(context, 'தமிழ்', 'ta'),
                        _buildLanguageOption(context, 'हिंदी', 'hi'),
                        _buildLanguageOption(context, 'తెలుగు', 'te'),
                        _buildLanguageOption(context, 'ಕನ್ನಡ', 'kn'),
                        _buildLanguageOption(context, 'اردو', 'ur'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(appLocalizations.translate('welcome') + ', Admin!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminOperationsScreen(setLocale: setLocale)),
                );
              },
              child: Text(appLocalizations.translate('operations')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPaymentApprovalScreen(setLocale: setLocale)),
                );
              },
              child: Text(appLocalizations.translate('pending_payments')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // NEW: Added Trash button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrashScreen(setLocale: setLocale)),
                );
              },
              child: Text(appLocalizations.translate('trash')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text(appLocalizations.translate('logout')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(BuildContext context, String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        // Save the selected language
        await AppLocalizations.setLocale(code);
        
        // Update the app locale
        setLocale(Locale(code, ''));
        
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('language_updated'))),
        );
      },
    );
  }
}

// NEW: Added TrashScreen to manage deleted users
class TrashScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  
  TrashScreen({required this.setLocale});
  
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<Map<String, dynamic>> _deletedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeletedUsers();
  }

  Future<void> _fetchDeletedUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/deleted_users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _deletedUsers = List<Map<String, dynamic>>.from(data['users']);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch deleted users: ${response.body}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restoreUser(int userId) async {
    try {
      final response = await http.put(
        Uri.parse('https://nanjundeshwara.vercel.app/restore_user/$userId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('user_restored'))),
        );
        _fetchDeletedUsers(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restore user: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _permanentlyDeleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://nanjundeshwara.vercel.app/permanent_delete_user/$userId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('user_permanently_deleted'))),
        );
        _fetchDeletedUsers(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to permanently delete user: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(int userId, String userName) {
    final appLocalizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('permanently_delete_user')),
          content: Text(
            appLocalizations.translate('are_you_sure_permanent_delete')
                .replaceAll('{name}', userName)
                .replaceAll('{id}', userId.toString())
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(appLocalizations.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _permanentlyDeleteUser(userId);
              },
              child: Text(appLocalizations.translate('delete_permanently'), style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('trash')),
        backgroundColor: Colors.red[700],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _deletedUsers.isEmpty
              ? Center(child: Text(appLocalizations.translate('no_deleted_users_found')))
              : ListView.builder(
                  itemCount: _deletedUsers.length,
                  itemBuilder: (context, index) {
                    final user = _deletedUsers[index];
                    final deletedAt = user['deletedAt'] != null 
                        ? DateTime.parse(user['deletedAt']).toString().substring(0, 16)
                        : 'Unknown';
                    
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('${user['_id']} - ${user['c_name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${appLocalizations.translate('village')}: ${user['c_vill']}, ${appLocalizations.translate('category')}: ${user['c_category']}'),
                            Text('${appLocalizations.translate('phone_number')}: ${user['phone']}'),
                            Text('${appLocalizations.translate('deleted_on')}: $deletedAt'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.restore, color: Colors.green),
                              onPressed: () => _restoreUser(user['_id']),
                              tooltip: appLocalizations.translate('restore_user'),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(user['_id'], user['c_name']),
                              tooltip: appLocalizations.translate('delete_permanently'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class AdminPaymentApprovalScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  
  AdminPaymentApprovalScreen({required this.setLocale});
  
  @override
  _AdminPaymentApprovalScreenState createState() => _AdminPaymentApprovalScreenState();
}

class _AdminPaymentApprovalScreenState extends State<AdminPaymentApprovalScreen> {
  List<Map<String, dynamic>> _pendingTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingTransactions(); // Fetch pending transactions when the screen loads
  }

  Future<void> _fetchPendingTransactions() async {
    try {
      final url = Uri.parse('https://nanjundeshwara.vercel.app/pending_transactions');
      print('Sending request to: $url'); // Log the request URL

      final response = await http.get(url);

      print('Response status code: ${response.statusCode}'); // Log the status code
      print('Response body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        final transactions = json.decode(response.body);
        print('Transactions found: ${transactions.length}'); // Log the number of transactions
        setState(() {
          _pendingTransactions = List<Map<String, dynamic>>.from(transactions);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch pending transactions: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _approvePayment(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/approve_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('payment_approved'))),
        );
        _fetchPendingTransactions(); // Refresh the list after approval
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve payment: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _rejectPayment(String transactionId) async {
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/reject_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('payment_rejected'))),
        );
        _fetchPendingTransactions(); // Refresh the list after rejection
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject payment: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('pending_payments')),
        backgroundColor: Colors.deepPurple,
      ),
      body: _pendingTransactions.isEmpty
          ? Center(child: Text(appLocalizations.translate('no_pending_payment_requests')))
          : ListView.builder(
              itemCount: _pendingTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _pendingTransactions[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${appLocalizations.translate('user_id')}: ${transaction['userId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${appLocalizations.translate('month')}: ${transaction['month']}'),
                        Text('${appLocalizations.translate('amount')}: ₹${transaction['amount']}'),
                        Text('${appLocalizations.translate('transaction_id')}: ${transaction['transactionId']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approvePayment(transaction['transactionId']),
                          tooltip: appLocalizations.translate('approve'),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _rejectPayment(transaction['transactionId']),
                          tooltip: appLocalizations.translate('reject'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AdminOperationsScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  
  AdminOperationsScreen({required this.setLocale});
  
  @override
  _AdminOperationsScreenState createState() => _AdminOperationsScreenState();
}

class _AdminOperationsScreenState extends State<AdminOperationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  String _selectedCategory = 'Gold';
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _monthController = TextEditingController();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _paidUsers = [];
  List<Map<String, dynamic>> _unpaidUsers = [];
  List<String> _villages = [];
  String _selectedVillage = '';
  List<Map<String, dynamic>> _villageUsers = [];
  List<Map<String, dynamic>> _inactiveUsers = [];

  String _selectedOperation = '';
  Map<String, dynamic> _userToDelete = {};

  List<String> categories = ['Gold', 'Silver', 'Bronze'];

  @override
  void dispose() {
    _userIdController.dispose();
    _nameController.dispose();
    _villageController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _monthController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVillages() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/get_all_villages'),
      );

      if (response.statusCode == 200) {
        final villages = json.decode(response.body);
        setState(() {
          _villages = List<String>.from(villages.map((v) => v['v_name']));
          if (_villages.isNotEmpty && _selectedVillage.isEmpty) {
            _selectedVillage = _villages[0];
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch villages: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _searchByVillage() async {
    if (_selectedVillage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('please_select_village'))),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/search_by_village?village=${_selectedVillage}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _villageUsers = List<Map<String, dynamic>>.from(data['users']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search by village: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _fetchInactiveCustomers() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/inactive_customers'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _inactiveUsers = List<Map<String, dynamic>>.from(data['inactiveUsers']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch inactive customers: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/add_user'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': int.parse(_userIdController.text),
            'c_name': _nameController.text,
            'c_vill': _villageController.text,
            'c_category': _selectedCategory,
            'phone': _phoneController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).translate('user_added'))),
          );
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add user: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  Future<void> _fetchUserDetailsForDeletion() async {
    if (_userIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('please_enter_user_id_to_delete'))),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userToDelete = json.decode(response.body);
        });
        
        // Show confirmation dialog
        _showDeleteConfirmationDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    final appLocalizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('confirm_deletion')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appLocalizations.translate('are_you_sure_delete')),
              SizedBox(height: 20),
              Text(appLocalizations.translate('user_details') + ':', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('ID: ${_userToDelete['_id']}'),
              Text(appLocalizations.translate('name') + ': ${_userToDelete['c_name']}'),
              Text(appLocalizations.translate('village') + ': ${_userToDelete['c_vill']}'),
              Text(appLocalizations.translate('category') + ': ${_userToDelete['c_category']}'),
              Text(appLocalizations.translate('phone_number') + ': ${_userToDelete['phone']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(appLocalizations.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteUser(); // Proceed with deletion
              },
              child: Text(appLocalizations.translate('move_to_trash'), style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    try {
      final response = await http.delete(
        Uri.parse('https://nanjundeshwara.vercel.app/delete_user/${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('user_moved_to_trash'))),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('failed_to_delete_user') + ': ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _viewAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_all_users'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data['users']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch users: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _addPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://nanjundeshwara.vercel.app/add_payments'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'c_id': int.parse(_userIdController.text),
            'p_month': _monthController.text,
            'amount': double.parse(_amountController.text),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).translate('payment_added'))),
          );
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add payment: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  Future<void> _viewPayments() async {
    if (_userIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('please_enter_user_id_to_view_payments'))),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_payments?userIdPayments=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch payments: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _viewPaymentsByMonth() async {
    if (_monthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('please_enter_month_to_view_payments'))),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/view_payments_by_month?p_month=${_monthController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _paidUsers = List<Map<String, dynamic>>.from(data['paidUsers']);
          _unpaidUsers = List<Map<String, dynamic>>.from(data['unpaidUsers']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch payments: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_userIdController.text.isEmpty) {
      return;
    }
    
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['c_name'];
          _selectedCategory = userData['c_category'];
          switch (_selectedCategory) {
            case 'Gold':
              _amountController.text = '500';
              break;
            case 'Silver':
              _amountController.text = '300';
              break;
            default:
              _amountController.text = '';
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _clearForm() {
    _userIdController.clear();
    _nameController.clear();
    _villageController.clear();
    _selectedCategory = 'Gold';
    _phoneController.clear();
    _amountController.clear();
    _monthController.clear();
  }

  Widget _buildOperationButton(String operation) {
    final appLocalizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedOperation = operation;
            _clearForm();
            
            // Initialize data for specific operations
            if (operation == 'Search\nBy\nVillage') {
              _fetchVillages();
            } else if (operation == 'Inactive\nCustomers') {
              _fetchInactiveCustomers();
            }
          });
        },
        child: Text(appLocalizations.translate(operation.toLowerCase().replaceAll('\n', '_'))),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedOperation == operation ? Colors.deepPurple : Colors.grey,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildOperationContent() {
    switch (_selectedOperation) {
      case 'Add\nUser':
        return _buildAddUserForm();
      case 'Delete\nUser':
        return _buildDeleteUserForm();
      case 'View\nAll\nUsers':
        return _buildViewAllUsersContent();
      case 'Add\nPayment':
        return _buildAddPaymentForm();
      case 'View\nPayments':
        return _buildViewPaymentsContent();
      case 'View\nPayments\nby\nMonth':
        return _buildViewPaymentsByMonthContent();
      case 'Search\nBy\nVillage':
        return _buildSearchByVillageContent();
      case 'Inactive\nCustomers':
        return _buildInactiveCustomersContent();
      default:
        return Container();
    }
  }

  Widget _buildAddUserForm() {
    final appLocalizations = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _userIdController,
            decoration: InputDecoration(labelText: appLocalizations.translate('user_id')),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_user_id') : null,
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: appLocalizations.translate('name')),
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_name') : null,
          ),
          TextFormField(
            controller: _villageController,
            decoration: InputDecoration(labelText: appLocalizations.translate('village')),
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_village') : null,
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(labelText: appLocalizations.translate('category')),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(appLocalizations.translate(category.toLowerCase() + '_category')),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: appLocalizations.translate('phone_number')),
            keyboardType: TextInputType.phone,
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_phone_number') : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addUser,
            child: Text(appLocalizations.translate('add_user')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteUserForm() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          controller: _userIdController,
          decoration: InputDecoration(labelText: appLocalizations.translate('user_id')),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _fetchUserDetailsForDeletion,
          child: Text(appLocalizations.translate('move_user_to_trash')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllUsersContent() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        ElevatedButton(
          onPressed: _viewAllUsers,
          child: Text(appLocalizations.translate('refresh_users_list')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        if (_users.isNotEmpty)
          Text(
            '${appLocalizations.translate('total_users')}: ${_users.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 10),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: appLocalizations.translate('search_users'),
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              // Filter users based on search text
              if (value.isEmpty) {
                _viewAllUsers(); // Refresh the list if search is cleared
              } else {
                _users = _users.where((user) =>
                  user['c_name'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['c_vill'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['c_category'].toString().toLowerCase().contains(value.toLowerCase()) ||
                  user['_id'].toString().contains(value)
                ).toList();
              }
            });
          },
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                title: Text('${user['_id']} - ${user['c_name']}'),
                subtitle: Text('${appLocalizations.translate('village')}: ${user['c_vill']}, ${appLocalizations.translate('category')}: ${user['c_category']}'),
                trailing: Text('${appLocalizations.translate('payments')}: ${user['paymentCount']}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddPaymentForm() {
    final appLocalizations = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _userIdController,
            decoration: InputDecoration(labelText: appLocalizations.translate('user_id')),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_user_id') : null,
            onChanged: (_) => _fetchUserDetails(),
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: appLocalizations.translate('name')),
            readOnly: true,
          ),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(labelText: appLocalizations.translate('amount')),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_amount') : null,
          ),
          TextFormField(
            controller: _monthController,
            decoration: InputDecoration(labelText: appLocalizations.translate('month')),
            validator: (value) => value!.isEmpty ? appLocalizations.translate('please_enter_month') : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addPayment,
            child: Text(appLocalizations.translate('add_payment')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewPaymentsContent() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          controller: _userIdController,
          decoration: InputDecoration(labelText: appLocalizations.translate('user_id')),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _viewPayments,
          child: Text(appLocalizations.translate('view_payments')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _payments.length,
            itemBuilder: (context, index) {
              final payment = _payments[index];
              return ListTile(
                title: Text('${appLocalizations.translate('amount')}: ${payment['amount']}'),
                subtitle: Text('${appLocalizations.translate('month')}: ${payment['p_month']}, ${appLocalizations.translate('user')}: ${payment['c_name']}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildViewPaymentsByMonthContent() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          controller: _monthController,
          decoration: InputDecoration(labelText: appLocalizations.translate('month_format')),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _viewPaymentsByMonth,
          child: Text(appLocalizations.translate('view_payments_by_month')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        if (_paidUsers.isNotEmpty || _unpaidUsers.isNotEmpty)
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: '${appLocalizations.translate('paid')} (${_paidUsers.length})'),
                      Tab(text: '${appLocalizations.translate('unpaid')} (${_unpaidUsers.length})'),
                    ],
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Paid Users Tab
                        _buildUserList(_paidUsers, true),
                        // Unpaid Users Tab
                        _buildUserList(_unpaidUsers, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users, bool isPaid) {
    final appLocalizations = AppLocalizations.of(context);
    return users.isEmpty
        ? Center(child: Text(appLocalizations.translate(isPaid ? 'no_paid_users' : 'no_unpaid_users')))
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPaid ? Colors.green[100] : Colors.red[100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text('ID: ${user['_id']} - ${user['c_name']}'),
                  subtitle: Text('${appLocalizations.translate('village')}: ${user['c_vill']}, ${appLocalizations.translate('category')}: ${user['c_category']}, ${appLocalizations.translate('phone_number')}: ${user['number']}'),
                  trailing: isPaid
                      ? Text('₹${user['amount']}', style: TextStyle(fontWeight: FontWeight.bold))
                      : null,
                ),
              );
            },
          );
  }

  Widget _buildSearchByVillageContent() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        DropdownButton<String>(
          value: _selectedVillage.isNotEmpty ? _selectedVillage : null,
          hint: Text(appLocalizations.translate('select_village')),
          isExpanded: true,
          items: _villages.map((String village) {
            return DropdownMenuItem<String>(
              value: village,
              child: Text(village),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedVillage = newValue!;
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _searchByVillage,
          child: Text(appLocalizations.translate('search')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        if (_villageUsers.isNotEmpty)
          Text(
            '${appLocalizations.translate('customers_in')} ${_selectedVillage}: ${_villageUsers.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _villageUsers.length,
            itemBuilder: (context, index) {
              final user = _villageUsers[index];
              return ListTile(
                title: Text('ID: ${user['_id']} - ${user['c_name']}'),
                subtitle: Text('${appLocalizations.translate('category')}: ${user['c_category']}'),
                trailing: Text('${appLocalizations.translate('payments')}: ${user['paymentCount']}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInactiveCustomersContent() {
    final appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        ElevatedButton(
          onPressed: _fetchInactiveCustomers,
          child: Text(appLocalizations.translate('refresh_inactive_customers')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        if (_inactiveUsers.isNotEmpty)
          Text(
            '${appLocalizations.translate('inactive_customers')}: ${_inactiveUsers.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _inactiveUsers.length,
            itemBuilder: (context, index) {
              final user = _inactiveUsers[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text('ID: ${user['id']} - ${user['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${appLocalizations.translate('phone_number')}: ${user['phone']}'),
                      Text('${appLocalizations.translate('village')}: ${user['village']}, ${appLocalizations.translate('category')}: ${user['category']}'),
                      Text('${appLocalizations.translate('last_payment')}: ${user['lastPaymentMonth']}'),
                    ],
                  ),
                  trailing: Text('₹${user['lastPaymentAmount']}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('admin_operations')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  _buildOperationButton('Add\nUser'),
                  _buildOperationButton('Delete\nUser'),
                  _buildOperationButton('View\nAll\nUsers'),
                  _buildOperationButton('Add\nPayment'),
                  _buildOperationButton('View\nPayments'),
                  _buildOperationButton('View\nPayments\nby\nMonth'),
                  _buildOperationButton('Search\nBy\nVillage'),
                  _buildOperationButton('Inactive\nCustomers'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildOperationContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class UserScreen extends StatefulWidget {
  final String username;
  final Function(Locale) setLocale;

  UserScreen({required this.username, required this.setLocale});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic> _userDetails = {};
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchPayments();
    _fetchNotifications();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userDetails = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _fetchPayments() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_payments?userIdPayments=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _payments = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch payments: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/notifications/${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch notifications: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(setLocale: widget.setLocale)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('user_dashboard')),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(appLocalizations.translate('language_settings')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption(context, 'English', 'en'),
                        _buildLanguageOption(context, 'தமிழ்', 'ta'),
                        _buildLanguageOption(context, 'हिंदी', 'hi'),
                        _buildLanguageOption(context, 'తెలుగు', 'te'),
                        _buildLanguageOption(context, 'ಕನ್ನಡ', 'kn'),
                        _buildLanguageOption(context, 'اردو', 'ur'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen(notifications: _notifications, setLocale: widget.setLocale)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.payment), // Add a payment icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentScreen(username: widget.username, setLocale: widget.setLocale)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${appLocalizations.translate('welcome')}, ${_userDetails['c_name'] ?? widget.username}!', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(appLocalizations.translate('user_details') + ':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('ID: ${_userDetails['_id'] ?? 'N/A'}'),
              Text('${appLocalizations.translate('name')}: ${_userDetails['c_name'] ?? 'N/A'}'),
              Text('${appLocalizations.translate('village')}: ${_userDetails['c_vill'] ?? 'N/A'}'),
              Text('${appLocalizations.translate('phone_number')}: ${_userDetails['phone'] ?? 'N/A'}'),
              Text('${appLocalizations.translate('category')}: ${_userDetails['c_category'] ?? 'N/A'}'),
              SizedBox(height: 20),
              Text(appLocalizations.translate('payment_history') + ':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _payments.isEmpty
                ? Text(appLocalizations.translate('no_payments_found'))
                : Column(
                    children: _payments.map((payment) => ListTile(
                      title: Text('${appLocalizations.translate('amount')}: ${payment['amount']}'),
                      subtitle: Text('${appLocalizations.translate('month')}: ${payment['p_month']}'),
                    )).toList(),
                  ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _logout(context),
                child: Text(appLocalizations.translate('logout')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(BuildContext context, String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        // Save the selected language
        await AppLocalizations.setLocale(code);
        
        // Update the app locale
        widget.setLocale(Locale(code, ''));
        
        // Update language preference on server
        await AppLocalizations.updateLanguageOnServer(widget.username, code);
        
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('language_updated'))),
        );
      },
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final Function(Locale) setLocale;

  NotificationsScreen({required this.notifications, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('notifications')),
        backgroundColor: Colors.deepPurple,
      ),
      body: notifications.isEmpty
          ? Center(child: Text(appLocalizations.translate('no_notifications')))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['message']),
                  subtitle: Text(DateTime.parse(notification['createdAt']).toString()),
                );
              },
            ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String username;
  final Function(Locale) setLocale;

  PaymentScreen({required this.username, required this.setLocale});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _transactionIdController = TextEditingController();
  bool _isPaid = false;
  Map<String, dynamic> _userDetails = {};
  String _selectedMonth = '01'; 

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://nanjundeshwara.vercel.app/find_user?userId=${widget.username}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userDetails = json.decode(response.body);
        });
        _checkPaymentStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final url = Uri.parse(
        'https://nanjundeshwara.vercel.app/check_payment_status?userId=${widget.username}&month=$_selectedMonth',
      );
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isPaid = data['isPaid'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check payment status: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _requestPayment() async {
    final appLocalizations = AppLocalizations.of(context);
    
    if (_transactionIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.translate('please_enter_transaction_id'))),
      );
      return;
    }
    
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/request_payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': int.parse(widget.username),
          'month': _selectedMonth,
          'amount': _userDetails['c_category'] == 'Gold' ? 500 : 300,
          'transactionId': _transactionIdController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.translate('payment_request_submitted'))),
        );
        // Refresh payment status after submitting
        _checkPaymentStatus();
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? appLocalizations.translate('failed_to_submit_payment_request'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.translate('error_occurred') + ': $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('make_payment')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedMonth,
              items: List.generate(12, (index) {
                final month = (index + 1).toString().padLeft(2, '0'); 
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text('${appLocalizations.translate('month')} $month'),
                );
              }),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMonth = newValue!;
                });
                _checkPaymentStatus(); 
              },
            ),
            SizedBox(height: 20),
            _isPaid
              ? Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 48),
                      SizedBox(height: 10),
                      Text(
                        appLocalizations.translate('payment_already_made').replaceAll('{month}', _selectedMonth),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Image.asset(
                      'assets/things/qr.jpg', 
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading QR code image: $error');
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code, size: 48, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(appLocalizations.translate('qr_code_not_available'), style: TextStyle(color: Colors.grey[600])),
                              Text(appLocalizations.translate('contact_admin_for_payment_details'), style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _transactionIdController,
                      decoration: InputDecoration(labelText: appLocalizations.translate('transaction_id')),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _requestPayment,
                      child: Text(appLocalizations.translate('submit_payment')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}