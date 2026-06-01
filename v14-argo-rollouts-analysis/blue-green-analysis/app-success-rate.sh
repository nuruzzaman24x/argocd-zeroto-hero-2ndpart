### WE are using curl command to get success_rate of active and preview services in blue-green strategy
### $service_url variable will be initialized in kubernetes job as an container environment variable
### The Value of $service_url variable will be one of the active or preview services names
#!/bin/bash     # এটাকে Shebang বলে।  OS-কে বলে দেয় এই script bash interpreter দিয়ে execute করতে হবে।
success=0       # success=0 failure=0  দুটি variable declare করা হচ্ছে।  success = সফল request সংখ্যা failure = ব্যর্থ request সংখ্যা  শুরুতে দুটিই 0।
failure=0
##################
for i in {1..5}         # for i in {1..5}  Loop শুরু।  1 2 3 4 5  মোট ৫ বার loop চলবে।
do                      # Loop body শুরু।
        response=$(curl -s -o /dev/null -w "%{http_code}" $service_url)
        if [ "$response" -eq 200 ]
        then
		((success++))
         else
                ((failure++))
         fi
         sleep 5s
done
##################
echo "Success rate: $success/5"         # jodi success=3 hoy then output hobe 3/5. 
##################
if [ "$success" -ge 3 ]                 # মানে:  success কি ৩ বা তার বেশি? TRUE হলে exit 0 exit  মানে: script শেষ করে দেওয়া
then
        exit 0                          # 0  Linux convention অনুযায়ী:  0 = SUCCESS
else
        exit 1                          # FALSE হলে exit 1 1  Linux convention:  1 = FAILURE
fi
