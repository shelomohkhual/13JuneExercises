#======================== ROOM ============================
class Room
    attr_accessor :capacity,:occupants
      def initialize(capacity)
          @capacity = capacity
          @occupants = []
      end
  
      def full?
          @occupants.size == @capacity ? true : false
      end
      def available_space
          @capacity - @occupants.size
      end
      def add_occupant(name)
          if full? == true
              return false
          else 
              @occupants << name
              return true 
          end
      end
  end