classdef simulation_params < sim_component
    
    properties (SetAccess = private, GetAccess = public)
        ti(1,1) double
        dt_data(1,1) double
        te(1,1) double
        tv_data double
        N_data(1,1) double
        jd0(1,1) double
        q_c(4,1) double
        command_mode(1,1) command_mode_enumeration
    end
    properties (Access = public)
        odeOpts
    end
    
    methods
        function obj = simulation_params(aOwningSimHandle,...
                aSimulationParamsScript)
            obj.pOwningSimHandle = aOwningSimHandle;
            struct = load_parameters(aSimulationParamsScript,'simulation');
            obj.ti = struct.ti;
            obj.dt_data = struct.dt_data;
            obj.te = struct.te;
            obj.tv_data = struct.tv_data;
            obj.N_data = struct.N_data;
            obj.jd0 = struct.jd0;
            obj.odeOpts = struct.odeOpts;
            obj.q_c = struct.q_c;
            obj.command_mode = struct.command_mode;
        end
    end
end

