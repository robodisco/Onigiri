module Onigiri
  class Measurement < Tag
    class << self
      attr_accessor :measurements

      def scan(tokens)
        tokens.each do |token|
          scan_for_measurement token
        end
      end

      def scan_for_measurement(token)
        normalized_measurements.each do |measurement|
          if token.name == measurement            
            token.add_tag self.new(token.name)
          end
        end
      end

      def normalize(text)
        measurements.each do |variation, normalized_form|
          text.gsub!(/\b#{variation}\b/i, normalized_form.gsub(" ", "_"))
        end
        text
      end

      def set_measurement(normalized_form, *variations)
        @measurements ||={}
        @measurements[normalized_form] = normalized_form
        variations.each do |variation|
          @measurements[variation] = normalized_form
        end
      end

      def normalized_measurements
        @normalized_measurements ||= measurements.values.uniq
      end
    end

    # english units
    set_measurement "cup", "c", "cup", "cups"
    set_measurement "fluid ounce", "fl. oz.", "fl oz", "fluid ounce", "fluid ounces"
    set_measurement "gallon", "gal", "gallon", "gallons"
    set_measurement "ounce", "oz", "ounce", "ounces"
    set_measurement "pint", "pt", "pint", "pints"
    set_measurement "pound", "lb", "lb.", "pound", "pounds"
    set_measurement "quart", "qt", "qts", "quart", "quarts"
    set_measurement "tablespoon", "tbsp", "T", "tablespoon", "tablespoons"
    set_measurement "teaspoon", "tsp", "t", "teaspoon", "teaspoons"
    set_measurement '15 ounce can', '15-?ounce cans?'
    set_measurement "9 ounce can", '9-?ounce cans?'
    # metric units
    set_measurement "gram", "g", "g.", "gr", "gr.", "gram", "grams"
    set_measurement "kilogram", "kg", "kilogram", "kilograms"
    set_measurement "liter", "l", "liter", "liters"
    set_measurement "milligram", "mg", "mg.", "milligram", "milligrams"
    set_measurement "milliliter", "ml", "ml.", "milliliter", "milliliters"

    set_measurement "clove", "cloves"
    set_measurement "head"

    set_measurement "medium", 'med\.?'
    set_measurement "large", 'lrg\.?'
    set_measurement "small", 'sml\.?'
  end
end