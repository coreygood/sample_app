require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }

  	it { should have_selector('h1', text: user.name) }
  	it { should have_selector('title', text: user.name) }
  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    def fill_in_defaults(name = "Example User", email = "user@example.com", password = "foobar", confirmation = "foobar")
      fill_in "Name",          with: name
      fill_in "Email",         with: email
      fill_in "Password",      with: password
      fill_in "Confirmation",  with: confirmation
    end

    describe "with invalid information" do
      
      describe "Name can't be blank" do
        before do 
          fill_in_defaults(name = "")
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end
      
      describe "Email can't be blank" do
        before do
          fill_in_defaults(email = "")
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

      describe "Email is invalid (has two '@' symbols" do
        before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "ex@@foo.com"
         fill_in "Password",      with: "foobar"
         fill_in "Confirmation",  with: "foobar"
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end
      describe "Email is invalid (doesn't have '.' in domain" do
        before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "ex@foocom"
         fill_in "Password",      with: "foobar"
         fill_in "Confirmation",  with: "foobar"
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

      describe "Email is invalid (has underscore)" do
        before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "ex_foo.com"
         fill_in "Password",      with: "foobar"
         fill_in "Confirmation",  with: "foobar"
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end
      
      describe "Password can't be blank" do
        before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "user@example.com"
         fill_in "Password",      with: ""
         fill_in "Confirmation",  with: "foobar"
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

      describe "Password is too short (minimum is 6 characters)" do
              before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "user@example.com"
         fill_in "Password",      with: "fooba"
         fill_in "Confirmation",  with: "fooba"
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

      describe "Password confirmation can't be blank" do
        before do
         fill_in "Name",          with: "Example User"
         fill_in "Email",         with: "user@example.com"
         fill_in "Password",      with: "foobar"
         fill_in "Confirmation",  with: ""
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end
      describe "Password and confirmation don't match" do
        before do
          fill_in_defaults(password = "foobar", confirmation = "fooba")
        end 

        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

#      describe "Password digest can't be blank" do
#        before do
#         fill_in "Name",          with: "Example User"
#         fill_in "Email",         with: ""
#         fill_in "Password",      with: "foobar"
#         fill_in "Confirmation",  with: "foobar"
#        end 
#
#        it "should not create a user" do
#          expect { click_button submit }.not_to change(User, :count)
#        end
#
#        describe "after submission" do
#          before { click_button submit }
#
#          it { should have_selector('title', text: 'Sign up') }
#          it { should have_content('error') }
#        end
#      end
    end

    describe "with valid information" do
      before do
       fill_in "Name",          with: "Example User"
       fill_in "Email",         with: "user@example.com"
       fill_in "Password",      with: "foobar"
       fill_in "Confirmation",  with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
        it { should have_link('Sign out') }
      end
    end
  end
end
