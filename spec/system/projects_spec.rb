require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "user creates a new project" do
    sign_in user
    visit root_path

    expect {
      create_new_project(
        name: 'Test Project',
        description: 'Trying out Capybara'
      )

      expect_successfully_saved_project(
        flash_message: 'Project was successfully created',
        name: 'Test Project',
        description: 'Trying out Capybara',
        owner: user
      )
    }.to change(user.projects, :count).by(1)
  end

  scenario "user edits the project" do
    project = FactoryBot.create(:project, owner: user)

    sign_in user
    visit root_path

    click_link project.name

    edit_project(
      name: 'Edit Project',
      description: 'edit description'
    )

    expect_successfully_saved_project(
      flash_message: 'Project was successfully updated',
      name:          'Edit Project',
      description:   'edit description',
      owner:          user
    )
  end
end

def create_new_project(name:, description:)
  click_link "New Project"
  fill_in "Name", with: name
  fill_in "Description", with: description
  click_button "Create Project"
end

def edit_project(name:, description:)
  click_link "Edit"
  fill_in "Name", with: name
  fill_in "Description", with: description
  click_button "Update Project"
end

def expect_successfully_saved_project(flash_message:, name:, description:, owner:)
  aggregate_failures do
    expect(page).to have_content flash_message
    expect(page).to have_content name
    expect(page).to have_content "Owner: #{owner.name}"
  end
end
