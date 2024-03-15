@set nowpath=%cd%
@cd py
"%nowpath%\soft\python38\python38.exe" -m uvicorn wsmain:app --host 0.0.0.0 --port 5034 --reload