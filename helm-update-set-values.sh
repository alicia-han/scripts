#!/bin/sh

UPDATE_VALUES=images1.tag,image2.tag
IMAGE_TAG=jeweirjwierjiwejril


if [ ! -z ${UPDATE_VALUES} ]; then
  export UPDATE_PHRASE=$(echo $UPDATE_VALUES |\
    awk -v SHA=${IMAGE_TAG} \
      '{\
        split($0, WORDS, ",");\
        for ( WORD in WORDS ) {printf "--set "WORDS[WORD]"="SHA" " }\
      }'\
  );
else
  export UPDATE_PHRASE="--set image.tag=${IMAGE_TAG}"
fi


echo $UPDATE_PHRASE
