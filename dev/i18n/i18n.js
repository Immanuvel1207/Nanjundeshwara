const translations = require("./translations")

// Function to format messages with variables
function formatMessage(message, variables) {
  if (!variables) return message

  let formattedMessage = message
  for (const key in variables) {
    formattedMessage = formattedMessage.replace(`{${key}}`, variables[key])
  }

  return formattedMessage
}

// Main translation function
function translate(key, lang = "en", variables) {
  // Default to English if the language is not supported
  const langData = translations[lang] || translations.en

  // Return the key itself if translation is not found
  const message = langData[key] || translations.en[key] || key

  return formatMessage(message, variables)
}

module.exports = {
  translate,
}
