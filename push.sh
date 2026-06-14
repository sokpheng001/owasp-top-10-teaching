git add .
echo -n "[+] Your commit message: ";
read msg;
git commit -m "$msg"
git push -u origin main