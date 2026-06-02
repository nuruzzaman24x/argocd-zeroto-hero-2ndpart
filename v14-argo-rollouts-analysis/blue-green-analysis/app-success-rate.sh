### WE are using curl command to get success_rate of active and preview services in blue-green strategy
### $service_url variable will be initialized in kubernetes job as an container environment variable
### The Value of $service_url variable will be one of the active or preview services names
#!/bin/bash     # Shebang line, যা নির্দেশ করে যে এই স্ক্রিপ্টটি bash শেল দ্বারা চালানো হবে।
success=0       # success variable কে 0 দিয়ে initialize করা হয়েছে।  success variable এর মান ১ বাড়ানো হবে যখন response 200 হবে।  success++ মানে success variable এর মান ১ বাড়ানো।
failure=0        # failure variable কে 0 দিয়ে initialize করা হয়েছে।  failure variable এর মান ১ বাড়ানো হবে যখন response 200 না হবে।  failure++ মানে failure variable এর মান ১ বাড়ানো।
##################
for i in {1..5}         # for loop যা 1 থেকে 5 পর্যন্ত চলবে।  এই লুপটি ৫ বার চলবে এবং প্রতিবার curl কমান্ড ব্যবহার করে $service_url এ HTTP request পাঠাবে।
do                      # for loop এর শুরু
        response=$(curl -s -o /dev/null -w "%{http_code}" $service_url)                 # curl কমান্ড যা $service_url এ HTTP request পাঠাবে এবং response code কে response variable এ সংরক্ষণ করবে।  -s option curl কে silent mode এ চালায়, -o /dev/null option curl কে output discard করতে বলে, -w "%{http_code}" option curl কে response code print করতে বলে।
        if [ "$response" -eq 200 ]              # যদি response variable এর মান 200 হয়, তাহলে success variable এর মান ১ বাড়ানো হবে।  অন্যথায় failure variable এর মান ১ বাড়ানো হবে।  -eq operator ব্যবহার করা হয়েছে response variable এর মান 200 এর সাথে তুলনা করার জন্য।
        then                            # যদি response 200 হয় তাহলে success++ হবে, অন্যথায় failure++ হবে।  success++ মানে success variable এর মান ১ বাড়ানো।  failure++ মানে failure variable এর মান ১ বাড়ানো।
		((success++))           # success++ মানে success variable এর মান ১ বাড়ানো।  failure++ মানে failure variable এর মান ১ বাড়ানো।  যদি response 200 হয় তাহলে success++ হবে, অন্যথায় failure++ হবে।
         else                           # যদি response 200 না হয় তাহলে success++ হবে, অন্যথায় failure++ হবে।  success++ মানে success variable এর মান ১ বাড়ানো।  failure++ মানে failure variable এর মান ১ বাড়ানো।
                ((failure++))           # failure++ মানে failure variable এর মান ১ বাড়ানো।  যদি response 200 হয় তাহলে success++ হবে, অন্যথায় failure++ হবে।
         fi                             # if statement এর শেষ
         sleep 5s                       # sleep 5s মানে script 5 সেকেন্ডের জন্য থামানো হবে।  এই লাইনটি প্রতিটি HTTP request এর পরে 5 সেকেন্ডের বিরতি দেয়।
done
##################
echo "Success rate: $success/5"         # success variable এর মান এবং total attempts (5) কে print করবে।  এই লাইনটি success rate কে print করবে, যা success variable এর মান এবং total attempts (5) এর অনুপাত হিসাবে প্রকাশ করা হবে।
##################
if [ "$success" -ge 3 ]                 # যদি success variable এর মান 3 বা তার বেশি হয়, তাহলে exit 0 হবে, অন্যথায় exit 1 হবে।  -ge operator ব্যবহার করা হয়েছে success variable এর মান 3 এর সাথে তুলনা করার জন্য।
then
        exit 0                          # TRUE হলে exit 0 0  Linux convention:  0 = SUCCESS
else
        exit 1                          # FALSE হলে exit 1  Linux convention:  1 = FAILURE
fi
