### WE are using a flask script to get the url of the application and try to connect to it 5 times at 5 seconds intervals and returns one of the true or false values based on "200 response_code" in a json format, if the success_rate is 80% or more , it returns "true" value, Otherwise it returns "false" value
from flask import Flask, request, jsonify       #Flask → Web server তৈরি করার জন্য request → Client কী data পাঠিয়েছে সেটা পড়ার জন্য jsonify → JSON format এ response পাঠানোর জন্য
import requests, time                           #requests → অন্য URL-এ HTTP request পাঠানোর জন্য time → কিছুক্ষণ wait করার জন্য

app = Flask(__name__)                           #Flask application তৈরি করা হচ্ছে।  ভাবো:  Flask Application Start

@app.route('/measure_success_rate', methods=['POST'])       #নতুন API তৈরি করা হলো:  http://SERVER_IP:5001/measure_success_rate  এবং শুধু POST request গ্রহণ করবে।
def measure_success_rate():                                 #যখন কেউ /measure_success_rate call করবে তখন এই function execute হবে।
    url = request.json.get('url')       #ধরো Flask API-কে তুমি এই request পাঠাও:  curl -X POST -H "Content-type: application/json" -d '{"url":"http://rollouts-setweight.demo:32577"}'  http://172.17.0.232:5001/measure_success_rate  এখানে -d অংশে তুমি Flask-কে একটা JSON পাঠাচ্ছো:  {   "url": "http://rollouts-setweight.demo:32577" }  এখন Flask-এর এই লাইন:  url = request.json.get('url')  এর মানে হলো:  "JSON-এর মধ্যে url নামে যে value আছে, সেটা নিয়ে url variable-এ রাখো।"  যেমন:  JSON:  {   "url": "http://rollouts-setweight.demo:32577" }  থেকে Flask বের করে:  url = "http://rollouts-setweight.demo:32577"

    if not url:                         # url আছে কি না চেক করো। যদি url খালি হয় (None, " ") তাহলে condition True হবে।  উদাহরণ:  url = None  অথবা  url = " "
        return jsonify({'error': 'URL is missing in the request body'}), 400            #User URL পাঠায়নি।  তাই API সাথে সাথে response দিবে:  {   "error": "URL is missing in the request body" }  এবং HTTP Status:  400 Bad Request

    success_count = 0       #কতবার request successful হবে সেটা গোনার জন্য একটা counter তৈরি করা হলো।  শুরুতে:  success_count = 0

    for _ in range(5):          #নিচের code ৫ বার চলবে।
        try:
            response = requests.get(url)        #URL-এ HTTP GET request পাঠাও।  ধরো:  url = "http://rollouts-setweight.demo:32577"  তাহলে:  requests.get("http://rollouts-setweight.demo:32577")  চলবে।
        except requests.exceptions.RequestException:        #Request পাঠানোর সময় error হলে এখানে আসবে।  যেমন:  DNS resolve failed Connection refused Timeout
            pass                                        # কিছু করো না।  Error হয়েছে, কিন্তু program বন্ধ করো না।  পরের iteration-এ চলে যাও।
        else:                                   #যদি কোনো error না হয় তাহলে এই block চলবে।  মানে request successfully গেছে।
            if response.status_code == 200:     #Application কি 200 OK দিয়েছে?  যদি দেয় তাহলে success।  উদাহরণ:  HTTP/1.1 200 OK
                success_count += 1
                time.sleep(5)                   #time.sleep(5)  অর্থ: ৫ সেকেন্ড অপেক্ষা করো।  তারপর আবার check করবে।
            else:
                time.sleep(5)               #Response এসেছে, কিন্তু status code 200 না। but setar jonno o ৫ সেকেন্ড অপেক্ষা করো।
    success_rate = (success_count / 5) * 100        #Success percentage বের করো।  ধরো:  success_count = 4  তাহলে:  (4 / 5) * 100  ফলাফল:  80.0 
    if int(success_rate) >= 80:                     #success_rate = 80  তাহলে:  80 >= 80  True
        return jsonify({'data': {'ok': 'true'}})
    else:
        return jsonify({'data': {'ok': 'false'}})

if __name__ == '__main__':      #এই file সরাসরি run করা হয়েছে কি না check করো।  যেমন:  python app.py
    app.run()                   #Flask server চালু করো।  সাধারণত:  http://0.0.0.0:5000  বা  http://127.0.0.1:5000  এ listen করবে।
