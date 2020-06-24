#!/bin/bash

set -e	# stop on error

#DATE=`date +%Y-%m-%d`
DATE=`date +%Y-%m-%d-%H-%M-%S`
LONG_DATE=`date`

STORE_DIR="download"
SUMMARY_DIR="summary"
SUMMARY_FILENAME="index.htm"
SUMMARY_TEMPLATE_FILENAME="summary.htm"
TEMPLATE_DIR="template"
PROTO_DIR="proto"
PROTO_APP_CONFIG_FORMAT_FILENAME="applicationConfiguration.proto"
PROTO_DIAGNOSIS_KEY_FORMAT_FILENAME="keyExportFormat.proto"

CONFIG_DIR="app-config"
DIAGNOSIS_KEYS_DIR="diagnosis-keys"

CONFIG_ZIP_FILENAME="app-config.zip"
CONFIG_BINARY_FILENAME="export.bin"
CONFIG_EXTRACTED_FILENAME="app-config.txt"
DIAGNOSIS_KEYS_AVAILABLE_DAYS_FILENAME="diagnosis-days.txt"
DIAGNOSIS_KEYS_ZIP_FILENAME="diagnosis-keys.zip"

CONFIG_URL="https://svc90.main.px.t-online.de/version/v1/configuration/country/DE/app_config"
DIAGNOSIS_KEYS_URL="https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date"

CURRENT_CONFIG_DIR="$STORE_DIR/$DATE/$CONFIG_DIR"
CURRENT_DIAGNOSIS_KEYS_DIR="$STORE_DIR/$DATE/$DIAGNOSIS_KEYS_DIR"

mkdir -p "$STORE_DIR"
mkdir -p "$STORE_DIR/$DATE"
mkdir -p "$CURRENT_CONFIG_DIR"
mkdir -p "$CURRENT_DIAGNOSIS_KEYS_DIR"

##################################
echo "Downloading list of dates with diagnosis keys to $CURRENT_DIAGNOSIS_KEYS_DIR/$DIAGNOSIS_KEYS_AVAILABLE_DAYS_FILENAME"
curl "$DIAGNOSIS_KEYS_URL" --output "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAGNOSIS_KEYS_AVAILABLE_DAYS_FILENAME"

echo "Parsing dates"
DIAG_DATES=$(cat "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAGNOSIS_KEYS_AVAILABLE_DAYS_FILENAME" | sed 's/[]["]//g' | sed 's/,/\n/g')
echo $DIAG_DATES

echo "Downloading and unpacking diagnosis keys"
for DIAG_DATE in $DIAG_DATES
do
  mkdir -p "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAG_DATE"
  echo "Downloading: $DIAGNOSIS_KEYS_URL/$DIAG_DATE"
  curl "$DIAGNOSIS_KEYS_URL/$DIAG_DATE" --output "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAG_DATE/$DIAGNOSIS_KEYS_ZIP_FILENAME"
  unzip -o "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAG_DATE/$DIAGNOSIS_KEYS_ZIP_FILENAME" -d "$CURRENT_DIAGNOSIS_KEYS_DIR/$DIAG_DATE"
  # TODO: Unpack 'export.bin' into human-readable form here.
  # protoc --decode="TemporaryExposureKeyExport" proto/keyExportFormat.proto < download/2020-07-05-09-16-06/diagnosis-keys/2020-07-04/export.bin 
done

##################################
echo "Downloading CWA config to $CURRENT_CONFIG_DIR/$CONFIG_ZIP_FILENAME"
curl "$CONFIG_URL" --output "$CURRENT_CONFIG_DIR/$CONFIG_ZIP_FILENAME"

echo "Extracting ZIP"
unzip -o "$CURRENT_CONFIG_DIR/$CONFIG_ZIP_FILENAME" -d "$CURRENT_CONFIG_DIR"

echo "Unpacking CWA config into human-readable form"
PROTO_CWA_PACKAGE="de.rki.coronawarnapp.server.protocols"
PROTO_CWA_CONFIG="ApplicationConfiguration"
protoc --decode="$PROTO_CWA_PACKAGE.$PROTO_CWA_CONFIG" "$PROTO_DIR/$PROTO_APP_CONFIG_FORMAT_FILENAME" < "$CURRENT_CONFIG_DIR/$CONFIG_BINARY_FILENAME" > "$CURRENT_CONFIG_DIR/$CONFIG_EXTRACTED_FILENAME"

##################################
mkdir -p "$SUMMARY_DIR"
cp "$CURRENT_CONFIG_DIR/$CONFIG_EXTRACTED_FILENAME" "$SUMMARY_DIR"
CURRNET_SUMMARY_TEMPLATE_FILENAME="$TEMPLATE_DIR/$SUMMARY_TEMPLATE_FILENAME"
CURRENT_SUMMARY_FILENAME="$SUMMARY_DIR/$SUMMARY_FILENAME"
echo "Writing summary to $CURRENT_SUMMARY_FILENAME"
export APP_CONFIG="$(cat $CURRENT_CONFIG_DIR/$CONFIG_EXTRACTED_FILENAME)"
export LAST_UPDATE="$LONG_DATE"
envsubst < "$CURRNET_SUMMARY_TEMPLATE_FILENAME" > "$CURRENT_SUMMARY_FILENAME"