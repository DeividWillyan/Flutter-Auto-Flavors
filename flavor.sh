#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\nPlease call '$0 AppName' to run this script!\n"
    exit 1
fi

sedi() {
  case $(uname) in
    Darwin*) sedi=('-i' '') ;;
    *) sedi='-i' ;;
  esac

  LC_ALL=C sed "${sedi[@]}" "$@"
}

APP_NAME=$1

sedi "s/@AppName/$APP_NAME/g" script_android

######## IOS ##############
RUNNER_XCSCHEME="../ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"
FIND_PATTERN="buildImplicitDependencies = \"YES\">"

sedi "/$FIND_PATTERN/rscript_ios" $RUNNER_XCSCHEME

FLUTTER_IOS_PATH="../ios/Flutter"
touch $FLUTTER_IOS_PATH/Define-defaults.xcconfig
echo "DEFINE_APP_NAME=$APP_NAME" >>$FLUTTER_IOS_PATH/Define-defaults.xcconfig
echo "DEFINE_APP_SUFFIX=" >>$FLUTTER_IOS_PATH/Define-defaults.xcconfig

echo "#include \"Define-defaults.xcconfig\"" >>$FLUTTER_IOS_PATH/Release.xcconfig
echo "#include \"Define.xcconfig\"" >>$FLUTTER_IOS_PATH/Release.xcconfig
echo "#include \"Define-defaults.xcconfig\"" >>$FLUTTER_IOS_PATH/Debug.xcconfig
echo "#include \"Define.xcconfig\"" >>$FLUTTER_IOS_PATH/Debug.xcconfig

INFO_PLIST_PATH="../ios/Runner/Info.plist"

sedi "s/\$(PRODUCT_BUNDLE_IDENTIFIER)/\$(PRODUCT_BUNDLE_IDENTIFIER)\$(DEFINE_APP_SUFFIX)/g" $INFO_PLIST_PATH
sedi -e '/<key>CFBundleName<\/key>/ {' -e 'n; s/<string>.*<\/string>/<string>\$(DEFINE_APP_NAME)<\/string>/' -e '}' $INFO_PLIST_PATH

######## ANDROID ##############
GRADLE_PATH_FILE="../android/app/build.gradle"
ANDROID_MANIFEST="../android/app/src/main/AndroidManifest.xml"

sedi "/def localProperties /r script_android" $GRADLE_PATH_FILE

FIND_PATTERN="applicationId \".*\""
sedi "/$FIND_PATTERN/rscript_android_gradle" $GRADLE_PATH_FILE

sedi 's#android:label=".*"#android:label="@string/app_name"#g' $ANDROID_MANIFEST


sedi "s/$APP_NAME/@AppName/g" script_android
