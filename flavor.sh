#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\nPlease call '$0 AppName' to run this script!\n"
    exit 1
fi

APP_NAME=$1

sed -i '' "s/@AppName/$APP_NAME/g" script_android

######## IOS ##############
RUNNER_XCSCHEME="../ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"
FIND_PATTERN="buildImplicitDependencies = \"YES\">"

sed -i '' "/$FIND_PATTERN/rscript_ios" $RUNNER_XCSCHEME

FLUTTER_IOS_PATH="../ios/Flutter"
touch $FLUTTER_IOS_PATH/Define-defaults.xcconfig
echo "DEFINE_APP_NAME=$APP_NAME" >>$FLUTTER_IOS_PATH/Define-defaults.xcconfig
echo "DEFINE_APP_SUFFIX=" >>$FLUTTER_IOS_PATH/Define-defaults.xcconfig

echo "#include \"Define-defaults.xcconfig\"" >>$FLUTTER_IOS_PATH/Release.xcconfig
echo "#include \"Define.xcconfig\"" >>$FLUTTER_IOS_PATH/Release.xcconfig
echo "#include \"Define-defaults.xcconfig\"" >>$FLUTTER_IOS_PATH/Debug.xcconfig
echo "#include \"Define.xcconfig\"" >>$FLUTTER_IOS_PATH/Debug.xcconfig

INFO_PLIST_PATH="../ios/Runner/Info.plist"

sed -i '' "s/\$(PRODUCT_BUNDLE_IDENTIFIER)/\$(PRODUCT_BUNDLE_IDENTIFIER)\$(DEFINE_APP_SUFFIX)/g" $INFO_PLIST_PATH
sed -i '' -e '/<key>CFBundleName<\/key>/ {' -e 'n; s/<string>.*<\/string>/<string>\$(DEFINE_APP_NAME)<\/string>/' -e '}' $INFO_PLIST_PATH

######## ANDROID ##############
GRADLE_PATH_FILE="../android/app/build.gradle"
ANDROID_MANIFEST="../android/app/src/main/AndroidManifest.xml"

sed -i '' "/def localProperties /r script_android" $GRADLE_PATH_FILE

FIND_PATTERN="applicationId \".*\""
sed -i '' "/$FIND_PATTERN/rscript_android_gradle" $GRADLE_PATH_FILE

sed -i '' 's#android:label=".*"#android:label="@string/app_name"#g' $ANDROID_MANIFEST


sed -i '' "s/$APP_NAME/@AppName/g" script_android