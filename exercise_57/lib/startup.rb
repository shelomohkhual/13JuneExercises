require "employee"
require "byebug"

class Startup
    attr_accessor :name,:funding,:salaries,:employees
    def initialize(name,funding,salaries)
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end
    def valid_title?(title)
        @salaries.keys.any? title
    end
    def >(another_startup)
        self.funding > another_startup.funding
    end
    def hire(employee_name,title)
        if valid_title?(title) != true
            error                                   # i don't even know why it's working
        else
            @employees.push Employee.new(employee_name,title)
        end
    end
    def size
        @employees.size
    end
    def pay_employee(employee)
        if @funding >= @salaries[employee.title]
            employee.pay(@salaries[employee.title]) #Employee and employee
            @funding -= @salaries[employee.title]
        else
            error
        end
    end
    def payday
        @employees.each do |employee|
            pay_employee(employee)
        end
    end
    def average_salary
        @employees.map{|employee|@salaries[employee.title]}.sum/@employees.size
    end
    def close
        @employees = []
        @funding = 0
    end
    def acquire(another_startup)
        @funding += another_startup.funding
        @salaries=another_startup.salaries.merge@salaries
        another_startup.employees.each {|employee| @employees.push employee}
        another_startup.close
    end

end
