FactoryBot.define do
  factory :book do
    title { Faker::Lorem.characters(number:5) } #文字数5のダミータイトル
    body { Faker::Lorem.characters(number:20) } #文字数20のダミー内容
    user
  end
end