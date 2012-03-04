require "spec_helper"

describe "Win32::Mouse", :if => SpecHelper.adapter == :win_32 do

  it "#click" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    popup = RAutomation::Window.new(:title => "About")
    popup.should_not be_present

    window.maximize
    mouse = window.mouse
    mouse.move :x => 60, :y => 45
    mouse.click

    RAutomation::WaitHelper.wait_until {popup.present?}
  end

  it "#position" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    mouse = window.mouse

    mouse.move :x => 13, :y => 16
    mouse.position.should == {:x => 13, :y => 16}
  end

  it "#press/#release" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.maximize

    text_field = window.text_field(:index => 1)
    text_field.set("start string")
    text_field.value.should == "start string"

    mouse = window.mouse
    mouse.move :x => 146, :y => 103
    mouse.press
    mouse.move :x => 194
    mouse.release
    window.send_keys [:control, "c"]

    text_field.set("new string")
    text_field.value.should == "new string"
    require "ruby-debug"; debugger;

    mouse.move :x => 146
    mouse.press
    mouse.move :x => 194
    mouse.release
    window.send_keys [:control, "v"]

    text_field.value.should == "start string"
  end
end
