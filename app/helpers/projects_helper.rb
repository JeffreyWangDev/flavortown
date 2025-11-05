module ProjectsHelper
  def format_hours(hours)
    return "0h 0m" if hours.nil? || hours.zero?
    
    hours_int = hours.to_i
    minutes = ((hours - hours_int) * 60).round
    
    if hours_int > 0 && minutes > 0
      "#{hours_int}h #{minutes}m"
    elsif hours_int > 0
      "#{hours_int}h"
    else
      "#{minutes}m"
    end
  end
end
