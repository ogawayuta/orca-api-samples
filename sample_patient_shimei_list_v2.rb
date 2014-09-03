
#!/usr/bin/ruby
# -*- coding: utf-8 -*-

#------ 患者番号一覧取得
require 'uri'
require 'net/http'
require 'pp'
require 'crack' # for xml and json
require 'crack/xml' # for just xml
Net::HTTP.version_1_2

HOST = "192.168.4.123"
PORT = "8000"
USER = "ormaster"
PASSWD = "ormaster123"
CONTENT_TYPE = "application/xml"


req = Net::HTTP::Post.new("/api01rv2/patientlst3v2?class=01")
# class :01 新規・更新対象
# class :02 新規対象

name = ARGV[0]
puts "氏名検索:#{name}"
puts "=========="
puts "検索結果"
puts "=========="

BODY = <<EOF
<data>
        <patientlst3req type="record">
                <WholeName type="string">#{name}</WholeName>
        </patientlst3req>
</data>
EOF

def list_patient(body)
  root = Crack::XML.parse(body)
  result = root["xmlio2"]["patientlst2res"]["Api_Result"]
  unless result == "00"
    puts "eroor:#{result}"
    exit 1
  end

  pinfo = root["xmlio2"]["patientlst2res"]["Patient_Information"]
  pinfo.each do |patient|
    puts "=========="
    puts "ID:      #{patient["Patient_ID"]}"
    puts "氏名:    #{patient["WholeName"]}"
    puts "カナ:    #{patient["WholeName_inKana"]}"
    puts "生年月日:#{patient["BirthDate"]}"
    if patient["Sex"] == "1"
      patient["Sex"] = "男"
    else
      patient["Sex"] = "女"
    end
    puts "性別:    #{patient["Sex"]}"
    puts "=========="
    puts
  end
end

req.content_length = BODY.size
req.content_type = CONTENT_TYPE
req.body = BODY
req.basic_auth(USER, PASSWD)

Net::HTTP.start(HOST, PORT) {|http|
  res = http.request(req)
  list_patient(res.body)
}
