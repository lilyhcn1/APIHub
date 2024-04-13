@set nowpath=%cd%
@cd py
"%nowpath%\soft\python38\python38.exe" -m uvicorn wsmain:app --host 0.0.0.0 --port 5035 --reload --ssl-keyfile=../soft/ssl/key.pem --ssl-certfile=../soft/ssl/cert.pem

