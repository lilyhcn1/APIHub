# coding=utf-8
 
import os
 
env = os.getenv('PATH')
env0 = os.getcwd()
env1 = os.path.join(os.getcwd(), 'Lib')
env2 = os.path.join(os.getcwd(), 'Scripts')
 
 
command = 'set PATH=' + env0 + ';' + env1 + ';' + env2 + ';' + env
 
str1 = ''':: 设置环境变量
 
:: 关闭终端回显
@echo off
 
@echo ====current environment：
@echo %PATH%
 
:: 添加环境变量,即在原来的环境变量后加上英文状态下的分号和路径'''
 
 
str2 = '''@echo ====new environment：
@echo %PATH%
 
pause'''
 
 
file = open('set_environment_value.bat','w')
file.write(str1)
file.write('\r\n')
file.write(command)      #写入内容信息
file.write('\r\n')
file.write(str2)
file.close()
 
 
 