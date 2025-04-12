// Middleware to detect and set language preference

function languageMiddleware(req, res, next) {
  // Get language from query parameter, header, or default to English
  const lang = req.query.lang || req.headers["accept-language"]?.split(",")[0]?.split("-")[0] || "en"

  // Only allow supported languages
  const supportedLanguages = ["en", "ta", "te", "kn", "hi"]
  req.lang = supportedLanguages.includes(lang) ? lang : "en"

  // Add translation function to response locals for use in routes
  res.locals.t = (key, variables) => {
    const { translate } = require("../i18n/i18n")
    return translate(key, req.lang, variables)
  }

  next()
}

module.exports = languageMiddleware
