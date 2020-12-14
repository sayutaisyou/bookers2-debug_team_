FactoryBot.define do
  factory :user do      
    name { Faker::Lorem.characters(number:10) } #文字数10のダミー文章
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number:20) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end