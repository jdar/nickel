require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/nickel")


describe "A single date" do 
  before(:all) { @n = Nickel.query "oct 15 09" }
  
  it "should have an empty message" do 
    @n.message.should be_empty
  end
  
  it "should have a start date" do 
    @n.occurrences.size.should == 1
    @n.occurrences.first.start_date.should == "20091015"
  end
end

describe "A daily occurrence" do 
  before(:all) do 
    @n = Nickel.query "wake up everyday at 11am"
    @occurs = @n.occurrences.first
  end
  
  it "should have a message" do 
    @n.message.should == "wake up"
  end
  
  it "should be daily" do
    @occurs.type.should == "daily"
  end
  
  it "should have a start time" do 
    @occurs.start_time.should == "11:00:00"
  end
end


describe "A weekly occurrence" do
  before(:all) do 
    @n = Nickel.query "guitar lessons every tuesday at 5pm"
    @occurs = @n.occurrences.first
  end
  
  it "should have a message" do
    @n.message.should == "guitar lessons"
  end
  
  it "should be weekly" do 
    @occurs.type.should == "weekly"
  end
  
  
  it "should occur on tuesdays" do
    @occurs.day_of_week.should == "tue"
  end
  
  it "should occur once per week" do 
    @occurs.interval.should == 1
  end
  
  it "should have a start date" do 
    @occurs.start_date.should_not be_nil
  end
  
  it "should not have an end date" do 
    @occurs.end_date.should be_nil
  end
end


describe "A day monthly occurrence" do 
  before(:all) do 
    @n = Nickel.query "drink specials on the second thursday of every month"
    @occurs = @n.occurrences.first
  end
  
  it "should have a message" do 
    @n.message.should == "drink specials"
  end
  
  it "should be day monthly" do 
    @occurs.type.should == "daymonthly"
  end
  
  it "should occur on second thursday of every month" do 
    @occurs.week_of_month.should == 2
    @occurs.day_of_week.should == "thu"
  end
  
  it "should occur once per month" do 
    @occurs.interval.should == 1
  end
end



describe "A date monthly occurrence" do 
  before(:all) do 
    @n = Nickel.query "pay credit card every month on the 22nd"
    @occurs = @n.occurrences.first
  end
  
  it "should have a message" do 
    @n.message.should == "pay credit card"
  end
  
  it "should be date monthly" do 
    @occurs.type.should == "datemonthly"
  end
  
  it "should occur on the 22nd of every month" do
    @occurs.date_of_month.should == 22
  end
  
  it "should occur once per month" do 
    @occurs.interval.should == 1
  end
end


describe "Multiple occurrences" do 
  before(:all) do 
    @n = Nickel.query "band meeting every monday and wednesday at 2pm"
  end
  
  it "should have a message" do 
    @n.message.should == "band meeting"
  end
  
  it "should have two occurrences" do 
    @n.occurrences.size.should == 2
  end
  
  it "should occur on mondays and wednesdays" do 
    days = @n.occurrences.collect {|occ| occ.day_of_week}
    days.include?("mon").should be_true
    days.include?("wed").should be_true
    days.size.should == 2
  end
  
  it "should occur at 2pm on both days" do 
    @n.occurrences[0].start_time.should == "14:00:00"
    @n.occurrences[1].start_time.should == "14:00:00"
  end
end