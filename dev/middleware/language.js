const { translate, supportedLanguages } = require('../i18n/i18n');

// Middleware to handle language preferences
module.exports = (req, res, next) => {
  // Get the language from the request header or query parameter
  const lang = req.headers['accept-language'] || req.query.lang || 'en';
  
  // Extract the primary language code (e.g., 'en-US' -> 'en')
  const primaryLang = lang.split('-')[0].toLowerCase();
  
  // Check if the language is supported, otherwise default to English
  const selectedLang = supportedLanguages.includes(primaryLang) ? primaryLang : 'en';
  
  // Add translation function to response locals
  res.locals.t = (key, params = {}) => translate(key, selectedLang, params);
  
  // Store the selected language for later use
  req.lang = selectedLang;
  
  next();
};