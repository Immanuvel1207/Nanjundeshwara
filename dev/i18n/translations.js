// Translation files for different languages

const translations = {
    en: {
      // User related messages
      userAdded: "User added successfully",
      userDeleted: "User with ID {userId} and their related data were deleted successfully",
      userNotFound: "User not found",
      userIdExists: "User ID already exists",
  
      // Payment related messages
      paymentAdded: "Payment added successfully",
      paymentApproved: "Payment approved successfully",
      paymentRejected: "Payment rejected successfully",
      paymentRequestSubmitted: "Payment request submitted successfully",
      paymentExists: "Payment for this month already exists",
      pendingPaymentExists: "A payment request for this month is already pending approval",
      transactionIdExists: "Transaction ID already exists",
  
      // Authentication messages
      invalidCredentials: "Invalid credentials",
  
      // Notification messages
      welcomeMessage: "Welcome {name}! Your account has been created successfully.",
      paymentRecorded: "Your payment of {amount} for {month} has been recorded.",
      paymentRequestPending: "Your payment request of {amount} for {month} has been submitted and is pending approval.",
      paymentApprovedNotification: "Your payment of {amount} for {month} month has been approved.",
      paymentRejectedNotification: "Your payment of {amount} for {month} month has been rejected.",
  
      // Device registration
      deviceRegistered: "Device registered successfully",
    },
  
    ta: {
      // User related messages
      userAdded: "பயனர் வெற்றிகரமாக சேர்க்கப்பட்டார்",
      userDeleted: "ஐடி {userId} கொண்ட பயனரும் அவரது தொடர்புடைய தரவும் வெற்றிகரமாக நீக்கப்பட்டன",
      userNotFound: "பயனர் கிடைக்கவில்லை",
      userIdExists: "பயனர் ஐடி ஏற்கனவே உள்ளது",
  
      // Payment related messages
      paymentAdded: "கட்டணம் வெற்றிகரமாக சேர்க்கப்பட்டது",
      paymentApproved: "கட்டணம் வெற்றிகரமாக அங்கீகரிக்கப்பட்டது",
      paymentRejected: "கட்டணம் வெற்றிகரமாக நிராகரிக்கப்பட்டது",
      paymentRequestSubmitted: "கட்டண கோரிக்கை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது",
      paymentExists: "இந்த மாதத்திற்கான கட்டணம் ஏற்கனவே உள்ளது",
      pendingPaymentExists: "இந்த மாதத்திற்கான கட்டண கோரிக்கை ஏற்கனவே அங்கீகாரத்திற்காக காத்திருக்கிறது",
      transactionIdExists: "பரிவர்த்தனை ஐடி ஏற்கனவே உள்ளது",
  
      // Authentication messages
      invalidCredentials: "தவறான சான்றுகள்",
  
      // Notification messages
      welcomeMessage: "வரவேற்கிறோம் {name}! உங்கள் கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது.",
      paymentRecorded: "{month} மாதத்திற்கான உங்கள் {amount} கட்டணம் பதிவு செய்யப்பட்டுள்ளது.",
      paymentRequestPending: "{month} மாதத்திற்கான உங்கள் {amount} கட்டண கோரிக்கை சமர்ப்பிக்கப்பட்டு அங்கீகாரத்திற்காக காத்திருக்கிறது.",
      paymentApprovedNotification: "{month} மாதத்திற்கான உங்கள் {amount} கட்டணம் அங்கீகரிக்கப்பட்டது.",
      paymentRejectedNotification: "{month} மாதத்திற்கான உங்கள் {amount} கட்டணம் நிராகரிக்கப்பட்டது.",
  
      // Device registration
      deviceRegistered: "சாதனம் வெற்றிகரமாக பதிவு செய்யப்பட்டது",
    },
  
    te: {
      // User related messages
      userAdded: "వినియోగదారు విజయవంతంగా జోడించబడ్డారు",
      userDeleted: "ID {userId} తో వినియోగదారు మరియు వారి సంబంధిత డేటా విజయవంతంగా తొలగించబడ్డాయి",
      userNotFound: "వినియోగదారు కనబడలేదు",
      userIdExists: "వినియోగదారు ID ఇప్పటికే ఉంది",
  
      // Payment related messages
      paymentAdded: "చెల్లింపు విజయవంతంగా జోడించబడింది",
      paymentApproved: "చెల్లింపు విజయవంతంగా ఆమోదించబడింది",
      paymentRejected: "చెల్లింపు విజయవంతంగా తిరస్కరించబడింది",
      paymentRequestSubmitted: "చెల్లింపు అభ్యర్థన విజయవంతంగా సమర్పించబడింది",
      paymentExists: "ఈ నెలకు చెల్లింపు ఇప్పటికే ఉంది",
      pendingPaymentExists: "ఈ నెలకు చెల్లింపు అభ్యర్థన ఇప్పటికే ఆమోదం కోసం పెండింగ్‌లో ఉంది",
      transactionIdExists: "లావాదేవీ ID ఇప్పటికే ఉంది",
  
      // Authentication messages
      invalidCredentials: "చెల్లని ఆధారాలు",
  
      // Notification messages
      welcomeMessage: "స్వాగతం {name}! మీ ఖాతా విజయవంతంగా సృష్టించబడింది.",
      paymentRecorded: "{month} నెలకు మీ {amount} చెల్లింపు నమోదు చేయబడింది.",
      paymentRequestPending: "{month} నెలకు మీ {amount} చెల్లింపు అభ్యర్థన సమర్పించబడింది మరియు ఆమోదం కోసం పెండింగ్‌లో ఉంది.",
      paymentApprovedNotification: "{month} నెలకు మీ {amount} చెల్లింపు ఆమోదించబడింది.",
      paymentRejectedNotification: "{month} నెలకు మీ {amount} చెల్లింపు తిరస్కరించబడింది.",
  
      // Device registration
      deviceRegistered: "పరికరం విజయవంతంగా నమోదు చేయబడింది",
    },
  
    kn: {
      // User related messages
      userAdded: "ಬಳಕೆದಾರರನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ",
      userDeleted: "ID {userId} ಹೊಂದಿರುವ ಬಳಕೆದಾರ ಮತ್ತು ಅವರ ಸಂಬಂಧಿತ ಡೇಟಾವನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಅಳಿಸಲಾಗಿದೆ",
      userNotFound: "ಬಳಕೆದಾರರು ಕಂಡುಬಂದಿಲ್ಲ",
      userIdExists: "ಬಳಕೆದಾರ ID ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ",
  
      // Payment related messages
      paymentAdded: "ಪಾವತಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ",
      paymentApproved: "ಪಾವತಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಅನುಮೋದಿಸಲಾಗಿದೆ",
      paymentRejected: "ಪಾವತಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ತಿರಸ್ಕರಿಸಲಾಗಿದೆ",
      paymentRequestSubmitted: "ಪಾವತಿ ವಿನಂತಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಸಲ್ಲಿಸಲಾಗಿದೆ",
      paymentExists: "ಈ ತಿಂಗಳಿಗೆ ಪಾವತಿ ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ",
      pendingPaymentExists: "ಈ ತಿಂಗಳಿಗೆ ಪಾವತಿ ವಿನಂತಿಯು ಈಗಾಗಲೇ ಅನುಮೋದನೆಗಾಗಿ ಬಾಕಿ ಇದೆ",
      transactionIdExists: "ವಹಿವಾಟು ID ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ",
  
      // Authentication messages
      invalidCredentials: "ಅಮಾನ್ಯ ರುಜುವಾತುಗಳು",
  
      // Notification messages
      welcomeMessage: "ಸ್ವಾಗತ {name}! ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ರಚಿಸಲಾಗಿದೆ.",
      paymentRecorded: "{month} ತಿಂಗಳಿಗೆ ನಿಮ್ಮ {amount} ಪಾವತಿಯನ್ನು ದಾಖಲಿಸಲಾಗಿದೆ.",
      paymentRequestPending: "{month} ತಿಂಗಳಿಗೆ ನಿಮ್ಮ {amount} ಪಾವತಿ ವಿನಂತಿಯನ್ನು ಸಲ್ಲಿಸಲಾಗಿದೆ ಮತ್ತು ಅನುಮೋದನೆಗಾಗಿ ಬಾಕಿ ಇದೆ.",
      paymentApprovedNotification: "{month} ತಿಂಗಳಿಗೆ ನಿಮ್ಮ {amount} ಪಾವತಿಯನ್ನು ಅನುಮೋದಿಸಲಾಗಿದೆ.",
      paymentRejectedNotification: "{month} ತಿಂಗಳಿಗೆ ನಿಮ್ಮ {amount} ಪಾವತಿಯನ್ನು ತಿರಸ್ಕರಿಸಲಾಗಿದೆ.",
  
      // Device registration
      deviceRegistered: "ಸಾಧನವನ್ನು ಯಶಸ್ವಿಯಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ",
    },
  
    hi: {
      // User related messages
      userAdded: "उपयोगकर्ता सफलतापूर्वक जोड़ा गया",
      userDeleted: "आईडी {userId} वाले उपयोगकर्ता और उनके संबंधित डेटा को सफलतापूर्वक हटा दिया गया",
      userNotFound: "उपयोगकर्ता नहीं मिला",
      userIdExists: "उपयोगकर्ता आईडी पहले से मौजूद है",
  
      // Payment related messages
      paymentAdded: "भुगतान सफलतापूर्वक जोड़ा गया",
      paymentApproved: "भुगतान सफलतापूर्वक स्वीकृत किया गया",
      paymentRejected: "भुगतान सफलतापूर्वक अस्वीकार कर दिया गया",
      paymentRequestSubmitted: "भुगतान अनुरोध सफलतापूर्वक जमा किया गया",
      paymentExists: "इस महीने के लिए भुगतान पहले से मौजूद है",
      pendingPaymentExists: "इस महीने के लिए भुगतान अनुरोध पहले से ही अनुमोदन के लिए लंबित है",
      transactionIdExists: "लेनदेन आईडी पहले से मौजूद है",
  
      // Authentication messages
      invalidCredentials: "अमान्य प्रमाण पत्र",
  
      // Notification messages
      welcomeMessage: "स्वागत है {name}! आपका खाता सफलतापूर्वक बनाया गया है।",
      paymentRecorded: "{month} महीने के लिए आपका {amount} भुगतान दर्ज किया गया है।",
      paymentRequestPending: "{month} महीने के लिए आपका {amount} भुगतान अनुरोध जमा किया गया है और अनुमोदन के लिए लंबित है।",
      paymentApprovedNotification: "{month} महीने के लिए आपका {amount} भुगतान स्वीकृत कर दिया गया है।",
      paymentRejectedNotification: "{month} महीने के लिए आपका {amount} भुगतान अस्वीकार कर दिया गया है।",
  
      // Device registration
      deviceRegistered: "डिवाइस सफलतापूर्वक पंजीकृत किया गया",
    },
  }
  
  module.exports = translations
  