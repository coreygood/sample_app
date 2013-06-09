FactoryGirl.define do
	factory :user do
		name "Corey Good"
		email	"coreyg@good.com"
		password "foobar"
		password_confirmation "foobar"
	end
end