rem 安装库
cd %cd%

soft\python38\python38.exe -m pip install pywin32 -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install pywintypes -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install pythoncom -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install pyautogui -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install pyperclip -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install qrcode  -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install requests==2.20.1 -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install chardet  -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn
soft\python38\python38.exe -m pip install configparser  -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn



choice /t 9 /d y /n >nul