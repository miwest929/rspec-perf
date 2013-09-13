module StatsHelper
  # table below is for 95% confidence level
  POINT_O_FIVE_TABLE = [
    12.71,
    4.303,
    3.182,
    2.776,
    2.571,
    2.447,
    2.365,
    2.306,
    2.262,
    2.228,
    2.201,
    2.179,
    2.16,
    2.145,
    2.131,
    2.12,
    2.11,
    2.101,
    2.093,
    2.086,
    2.08,
    2.074,
    2.069,
    2.064,
    2.06,
    2.056,
    2.052,
    2.048,
    2.045,
    2.042
  ]

  def self.point_o_five(degrees_of_freedom)
    POINT_O_FIVE_TABLE[degrees_of_freedom.round]
  end
end

