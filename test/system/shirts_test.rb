require "application_system_test_case"

class ShirtsTest < ApplicationSystemTestCase
  setup do
    @shirt = shirts(:one)
  end

  test "visiting the index" do
    visit shirts_url
    assert_selector "h1", text: "Shirts"
  end

  test "creating a Shirt" do
    visit shirts_url
    click_on "New Shirt"

    fill_in "Name", with: @shirt.name
    fill_in "Numtaken", with: @shirt.numtaken
    fill_in "Size", with: @shirt.size
    click_on "Create Shirt"

    assert_text "Shirt was successfully created"
    click_on "Back"
  end

  test "updating a Shirt" do
    visit shirts_url
    click_on "Edit", match: :first

    fill_in "Name", with: @shirt.name
    fill_in "Numtaken", with: @shirt.numtaken
    fill_in "Size", with: @shirt.size
    click_on "Update Shirt"

    assert_text "Shirt was successfully updated"
    click_on "Back"
  end

  test "destroying a Shirt" do
    visit shirts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shirt was successfully destroyed"
  end
end
