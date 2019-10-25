classdef robot_class
    properties
        ev3
        ev3_name
    end
    methods
        function passVal = disconnect(obj)
           DisconnectBrick(obj.ev3);
        end
        
        %-1 = fault, 0 =nocolor, 1 = black, 2= blue, 3 = green, 4= yellow
        %5 = red, 6 = white, 7 = brown
        function colorVal = getColor(obj, port)
            obj.ev3.setColorMode(2, port);
            color = obj.ev3.ColorCode(port);
            if color > 0
                colorVal = color;
            else
                colorVal = -1;
            end
        end 
        
        %null gyroscope output for whatever reason. needs to be resolved.
        function passVal = turnPos(obj, angle, speed)
            obj.ev3.StopMotor('AD');
            obj.ev3.GyroCalibrate(3);
            pause(2)
            error = (angle+str2double(obj.ev3.GyroAngle(3)))-str2double(obj.ev3.GyroAngle(3));
            if (error > 0)
                obj.ev3.MoveMotor('A',speed)
                obj.ev3.MoveMotor('D', -speed)
            else
                obj.ev3.MoveMotor('A',-speed)
                obj.ev3.MoveMotor('D', speed)
            end
             error = (angle+str2double(obj.ev3.GyroAngle(3)))-str2double(obj.ev3.GyroAngle(3));
            display(error)
            %startTime = clock(5)
            while (abs(error) > 3 )%&& clock(5) < startTime+5)
                print(error)
                error = angle-obj.ev3.GyroAngle(3);
            end
            obj.ev3.StopMotor('AD')
        end
        function passVal = driveEncod(obj,distance, speed)
            obj.ev3.ResetMotorAngle('AD');
            obj.ev3.MoveMotorAngleRel('AD', speed, distance, 'Brake');
            obj.ev3.WaitForMotor('A');
            passVal = 0;
        end
        function obj = robot_class(robot_name)
            obj.ev3 = ConnectBrick(robot_name);
            obj.ev3_name = robot_name;
        end
        function passVal = setArmToPosAbs(obj, pos)
        obj.ev3.ResetMotorAngle('C');
        obj.ev3.MoveMotorAngleRel('C', pos, 5, 'Brake');
        obj.ev3.WaitForMotor('C');
        passVal = 0;
        end  
    end
end


            
            