require_relative "room"
#======================== HOTEL ============================
class Hotel
    # attr_accessor   
    attr_reader :rooms
    def initialize(name,rooms)
        @name = name
        @rooms = {}
        rooms.each do |room_name ,v|
            @rooms[room_name]= Room.new(v)
        end
    end
    def name
        @name.split.map(&:capitalize).join(' ')
    end 
    def room_exists?(room_name)
        @rooms.include? room_name
    end
    def check_in(person,room_name)
        if room_exists?(room_name)
            if @rooms[room_name].add_occupant(person)
                puts 'check in successful'
            else 
                puts "sorry, room is full"
            end
        else
            puts 'sorry, room does not exist'
        end
    end
    def has_vacancy?
        # byebug
        @rooms.each do |room_name,details|
            if !@rooms[room_name].full? 
                return true
            end
        end 
        false
    end
    def list_rooms
        @rooms.each do |room_name,details|
            print room_name
            puts details.available_space
        end
    end
end


hotel = Hotel.new("hotel recode grande", "Family"=>4, "King Deluxe"=>2, "Capsule"=>1)