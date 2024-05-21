﻿#一、 引用函数、库等写在最上方
#11111111111111111111111111111111111111111111111111111111111111

import requests
import json
import time
import hmac
import hashlib
import base64
import urllib.parse
from bs4 import BeautifulSoup
import random
import time

# 签名
def sign(secret,timestamp): 
    secret_enc = secret.encode('utf-8')
    string_to_sign = '{}\n{}'.format(timestamp, secret)
    string_to_sign_enc = string_to_sign.encode('utf-8')
    hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
    sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))
    # print(timestamp)
    # print(sign)
    sign_str= {"sign": sign,"timestamp":timestamp}
    return sign_str


# 钉钉消息
def send_msg(msg,webhook,sign,timestamp):
    tim = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    headers = {"Content-Type": "application/json"}
    #readData = EveryDayStudy()
    #imgurl = getImgUrl()
    data ={
        "msgtype": "text",
        "text": {
            "content": msg
        },
     # @群内人员
      # "at": {
      #     "atMobiles": [
      #         "150XXXXXXXX"
      #     ],
      #     "atUserIds ": [
      #         "user123"
      #     ],
      #     "isAtAll": false
      # }
    }
    webh = webhook+'&timestamp='+timestamp+'&sign='+sign
    r = requests.post(webh, data=json.dumps(data), headers=headers)
    print(r.text)


# 钉钉消息
def send_msgpng(sign,timestamp):
    tim = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    headers = {"Content-Type": "application/json"}
    readData = EveryDayStudy()
    imgurl = getImgUrl()
    data = {
     "msgtype": "markdown",
     "markdown": {
         "title":"每日一读",
         "text": "#### 今日鸡汤  \n> "+readData+" \n\n> ![screenshot]("+imgurl+") \n> ###### "+tim+" [更多](http://www.duanmeiwen.com/yulu/lizhi/46345.html) \n"
     },
     # @群内人员
      # "at": {
      #     "atMobiles": [
      #         "150XXXXXXXX"
      #     ],
      #     "atUserIds ": [
      #         "user123"
      #     ],
      #     "isAtAll": false
      # }
    }
    webh = webhook+'&timestamp='+timestamp+'&sign='+sign
    r = requests.post(webh, data=json.dumps(data), headers=headers)
    print(r.text)

# 每日一读 文字
def EveryDayStudy():
    num = random.randint(1,299)
    res = requests.get('http://www.duanmeiwen.com/yulu/lizhi/46345.html')
    res.encoding = 'gb2312'
    bs = BeautifulSoup(res.text, "html.parser")
    Datalist = []
    for i in bs.find_all("div", class_="content"):
        text1 = i.text
        for j in range(1,300,1):
            text2= text1.split(str(j)+'、')
            text3= text2[1].split(str(j+1)+'、')
            Datalist.append(text3[0])
        return Datalist[num]

# 图片
def getImgUrl():
    img=[]
    num = random.randint(1,17)
    headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.146 Safari/537.36',
    'Content-Type':"text/html; charset=utf-8"
    }
    req_url= 'https://www.ivsky.com/bizhi/fengjing/'
    res = requests.get(url=req_url,headers=headers)
    res.encoding = 'utf-8'
    bs = BeautifulSoup(res.text, "html.parser")
    for i in bs.find_all("img"):
        imgtext = i
        imgstr = str(imgtext).split(' src="')
        imgstr1=imgstr[1].split('"/>')
        imgurl = 'https:'+imgstr1[0]
        img.append(imgurl)
    return img[num]

#11111111111111111111111111111111111111111111111111111111111111
# ---------------r34.cc制作 excel 的输入输出---------------
import os,base64,time,sys,json,traceback,lilyfun # 导入同路径下的函数
prflag = "true"  # 是否打印输出，true输出
inarr,outarr={},{}
lilyfun.tj()

# 二、运行出错时，默认的输入、输出的默认标题行
#2222222222222222222222222222222222222222222222222222222222222
#输入文本
inarr["zzd_access_token"]="GetFromIni"
inarr["zzd_sign"]="GetFromIni"
inarr[""]=""
inarr[""]=""
inarr[""]=""
outarr[""] = ""
outarr[""] = ""
outarr[""] = ""
outarr[""] = ""
outarr[""] = ""
#文件标志
fkeyold=""   #输入变量中，哪个是文件的标记。
fkeynew=""   #输出变量中，哪个是文件的标记。
#2222222222222222222222222222222222222222222222222222222222222
config=lilyfun.readiniconfig()
inarr=lilyfun.updatearrfromini(inarr,config)




def main(fd2={}):
    global inarr,outarr,prflag,fkeyold,fkeynew,mlkey,config
    arr2ret,valarr,errarr = {},{},{}
    wholepath,f64="",""
    errarr=lilyfun.merge(inarr,outarr)  #合并字典
    # ----------------三、初始化读取数据：----------------------
    #读valarr,即读标题及标题对应的值
    # ----------------[1/4]读取fd2，生成base64字符串 json64 -----
    try: #1.1读取fd2，即传入字典
        json64=lilyfun.getfd2(fd2,"json64")
    except Exception as e:
        errarr = lilyfun.printtraceback(errarr,"读取fd2错误，请检查！",prflag)
        return lilyfun.mboutputarr(fd2,prflag,errarr)
    lilyfun.titlepr("[1/4] fd2 传入成功！：","传入成功",prflag)

    # ----------------[2/4] 生成f64,json64解码为jsonarr -----------
    try: #1.2 json64解码为jsonarr
        jsonarr = lilyfun.json64tojsonarr(json64)
        jsoncontentarr =jsonarr["contents"]
        jsoncontentarr=lilyfun.updatearrfromini(jsoncontentarr,config)
        jsonarr["contents"]=jsoncontentarr
        f64=lilyfun.getfd2_f64(fd2,fkeyold,jsonarr)
    except Exception as e:
        errarr = lilyfun.printtraceback(errarr,"jsonarr解码错误，请检查！",prflag)
        #fd2:函数传过来的值，arr2ret:运行得到的数组，prflag：打印标记
        return lilyfun.mboutputarr(fd2,prflag,errarr)
    lilyfun.titlepr("[2/4] 解码成功 jsonarr：",jsonarr,prflag)

    # ----------------[3/4]按输入区读传过来的值并反馈到字典valarr ------
    try:
        valarr=lilyfun.getvalarr(jsonarr,inarr,outarr,prflag)
    except Exception as e:
        errarr = lilyfun.printtraceback(errarr,"标题行没有需要的值，请确保标题行存在！",prflag)
        return lilyfun.mboutputarr(fd2,prflag,errarr)
    lilyfun.titlepr("","获取到的f64的长度为: " + str(len(f64)),prflag)
    lilyfun.titlepr("[3/4] 检查输入值成功 valarr：",valarr,prflag)
    #这里可能还要再写读文件的
    
    # ----------------[4/4]调用函数并生成arr2ret及f64 -------------------
    try:  # 运行函数,最后要生成arr2ret及f64
        old_filepath=lilyfun.randfile(errarr,fkeyold,"old")
        new_filepath=lilyfun.randfile(errarr,fkeynew,"new")
        old_filepath=lilyfun.writefile64(f64,old_filepath)
    except Exception as e:
        valarr = lilyfun.printtraceback(valarr,"读写文件错误，请检查！",prflag)
        return lilyfun.mboutputarr(fd2,prflag,valarr)


    #3333333333333333333333333333333333333333333333333333
    #txt=mainrun(valarr,old_filepath,new_filepath)
    #inarr zzd_access_token zzd_sign   
    #inarr     
    #fkeyold  fkeynew  
    try:  # 运行函数,最后要生成arr2ret及f64

        msg="【每日报时】现在是"+time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())+"，每天好心情。:)"
        secret=valarr["zzd_sign"]
        access_token=valarr["zzd_access_token"]

        webhook = 'https://openplatform-pro.ding.zj.gov.cn/robot/send?access_token='+access_token

        # 时间戳
        timestamp = str(round(time.time() * 1000))
        # 钉钉机器人配置
        sign_str =sign(secret,timestamp)
        sg = sign_str['sign']
        send_msg(msg,webhook,sg,timestamp)

    except Exception as e:# 保存函数出错后的执行结果
        valarr = lilyfun.printvalarr(valarr,"[运行]调用函数出错，请检查值是否正确。" +"\n"+'错误类型：'+ e.__class__.__name__+"\n"+ '错误明细：'+str(e))
        return lilyfun.mboutputarr(fd2,prflag,valarr)

    #3333333333333333333333333333333333333333333333333333
    
    try:  # 运行函数,最后要生成arr2ret及f64
        f64=lilyfun.readfile2f64(new_filepath)#有新文件就读取
        # newpath = valarr[fkeynew]
        # if f64!="" and fkeynew!="" and fd2=={}:
        #     lilyfun.writefile64(f64,newpath)
        lilyfun.safedel(old_filepath)
        lilyfun.safedel(new_filepath)
        arr2ret["execstat"]="√"
    except Exception as e:
        valarr = lilyfun.printtraceback(valarr,"读写、删除文件错误。！",prflag)
        return lilyfun.mboutputarr(fd2,prflag,valarr)
    lilyfun.titlepr("[4/4] 函数执行成功 arr2ret：",arr2ret,prflag)
    

    # ----------------五、写入文件，并返回字典 -------------------
    try:  # 写入文件
        if fd2=={} and fkeynew !="":
            excelfolder=lilyfun.safegetkey(jsonarr,"excelpath")
            raltiveapth=jsonarr["contents"][fkeynew]
            wholepath=lilyfun.getwholepath(raltiveapth,excelfolder)
        lilyfun.titlepr("执行、输出成功。","",prflag)
        #这是最关键的返回函数，并写入文件
        #print(wholepath)
        return lilyfun.mboutputarr(fd2,prflag,arr2ret,f64,wholepath,"key")
    except Exception as e:
        valarr = lilyfun.printtraceback(valarr,"写入文件出错，请检查值是否正确！",prflag)
        lilyfun.titlepr("最后写入文件出错，请检查值是否正确。","",prflag)       
        return lilyfun.mboutputarr(fd2,prflag,valarr)



if __name__ == '__main__':
    main()

    #fd2的内容
    # "json64": json文件  上传过来的json
    # "f64": f64   上传的文件的base64（只能一个文件）
    # "fkeyold": fkeyold  上传时的标题行（只能一个文件）
    # "fkeynew": fkeynew  返回时的标题行（只能一个文件）
        #fd2,prflag="true",arr2ret,f64="",fkeynew="",keyflag="all"
        #fd2:传过来的值，prflag：打印标记,keyflag:excel中的是否全部输出
        #arr2ret:运行得到的字典，f64:反馈文件的base64,fkeynew：输出值
        #return lilyfun.mboutputarr(fd2,prflag,errarr)