NAME_SOURCE = <<EOF
あいうえお
かきくけこ
さしすせそ
たちつてと
なにぬねの
はひふへほ
まみむめも
やゆよ
らりるれろ
わをん
がぎぐげご
ざじずぜぞ
だぢづでど
ばびぶべぼ
ぱぴぷぺぽ
EOF

KANA_NAME_SOURCE = <<EOF
アイウエオ
カキクケコ
サシスセソ
タチツテト
ナニヌネノ
ハヒフヘホ
マミムメモ
ヤユヨ
ラリルレロ
ワヲン
ガギグゲゴ
ザジズゼゾ
ダヂヅデド
バビブベボ
パピプペポ
EOF

NAME_ELEMENTS = NAME_SOURCE.split("").reject do |s| s == "\n" end
KANA_NAME_ELEMENTS = KANA_NAME_SOURCE.split("").reject do |s| s == "\n" end

 
def get_random_name
  name = "" 
  kana_name = ""
  name_size = rand(10) + 1
  name_size.times do
    i = rand(NAME_ELEMENTS.size)
    name << NAME_ELEMENTS[i]
    kana_name << KANA_NAME_ELEMENTS[i]
  end
  name << "　"
  kana_name << "　"

  name_size = rand(10) + 1
  name_size.times do
    i = rand(NAME_ELEMENTS.size)
    name << NAME_ELEMENTS[i]
    kana_name << KANA_NAME_ELEMENTS[i]
  end
  [name,kana_name]
end

if __FILE__ == $0
  name,kana_name = get_random_name
  puts name
  puts kana_name
end
