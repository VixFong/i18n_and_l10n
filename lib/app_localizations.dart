import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';  // Importing intl package

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(instance != null, 'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizationsDelegate to localizationsDelegates?');
    return instance!;
  }

  static Map<String, String> _localizedStrings = {};

  // Load the language JSON file from the assets
  static Future<AppLocalizations> load(Locale locale) async {
    final jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    _localizedStrings = Map<String, String>.from(json.decode(jsonString));
    return AppLocalizations(locale);
  }

  // Translate a key to its corresponding localized string
  String translateKey(String key, [Map<String, String>? placeholders]) {
    String? value = _localizedStrings[key];
    if (value != null && placeholders != null) {
      placeholders.forEach((placeholder, val) {
        value = value!.replaceAll('{$placeholder}', val);
      });
    }
    return value ?? '';
  }

   final Map<String, double> currencyConversionRates = {
    'vi': 23500.0, // Vietnamese Dong
    'en': 1.0,     // US Dollar (base currency)
    'ja': 110.0,   // Japanese Yen
    'es': 0.85,  // Euro
    'zh': 0.1426,  //Chinese
  };

  // Formatting currency
  String formatCurrency(double price) {
    // Get the conversion rate based on the locale
    double conversionRate = currencyConversionRates[locale.languageCode] ?? 1.0;
    
    // Convert the price
    double convertedPrice = price * conversionRate;
    
    // Format the converted price with the correct symbol
    final format = NumberFormat.currency(
      locale: locale.toString(), 
      symbol: _getCurrencySymbol(),
    );
    
    print('Locale: ${locale.toString()}, Symbol: ${_getCurrencySymbol()}, Price: $price, Converted Price: $convertedPrice');
    
    return format.format(convertedPrice);
  }



  // Formatting date
  String formatDate(DateTime date) {
    final formatDate = DateFormat.yMMMMd(locale.toString());
    return formatDate.format(date);
  }

  // Formatting number
  String formatNumber(int number) {
    final formatNumber = NumberFormat.decimalPattern(locale.toString());
    return formatNumber.format(number);
  }

   String _getCurrencySymbol() {
    switch (locale.languageCode) {
      case 'vi':
        return '₫';
      case 'en':
        return '\$';
      case 'ja':
        return '¥';
      case 'es':
        return '€';
      case 'zh':
        return '¥';
      default:
        return '\$';
    }
  }
}

// The delegate class for AppLocalizations, to load the locale data
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'ja', 'zh', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
