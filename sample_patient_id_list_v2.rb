#!/usr/bin/ruby
# -*- coding: utf-8 -*-

#------ 患者番号一覧取得
require 'uri'
require 'net/http'

Net::HTTP.version_1_2

HOST = "192.168.4.123"
PORT = "8000"
USER = "ormaster"
PASSWD = "ormaster123"
CONTENT_TYPE = "application/xml"


req = Net::HTTP::Post.new("/api01rv2/patientlst1v2?class=01")
# class :01 新規・更新対象
# class :02 新規対象
#
#
BODY = <<EOF
<data>
        <patientlst1req type="record">
                <Base_StartDate type="string">2012-06-01</Base_StartDate>
                <Base_EndDate type="string">2014-09-30</Base_EndDate>
                <Contain_TestPatient_Flag type="string">1</Contain_TestPatient_Flag>
        </patientlst1req>
</data>
EOF

def list_patient(body)
  require 'pp'
  require 'crack' # for xml and json
  require 'crack/xml' # for just xml

  root = Crack::XML.parse(body)
  result = root["xmlio2"]["patientlst1res"]["Api_Result"]
  unless result == "00"
    puts "eroor:#{result}"
    exit 1
  end

  pinfo = root["xmlio2"]["patientlst1res"]["Patient_Information"]
  pinfo.each do |patient|
    puts "=========="
    puts patient["Patient_ID"]
    puts patient["WholeName"]
    puts patient["WholeName_inKana"]
    puts patient["BirthDate"]
    puts patient["Sex"]
    puts patient["CreateDate"]
    puts patient["UpdateDate"]
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
  #puts res.code
  list_patient(res.body)
  #puts res.body
}
