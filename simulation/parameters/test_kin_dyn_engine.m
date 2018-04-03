function [ engine ] = test_kin_dyn_engine()
%% Force funcs

% solar radiation pressure
rad_press_func = @(t, x, jd0) solar_rad_press(x(1:3),t/86400 + jd0);
force_funcs{1} = @(t, x, params) ...
    rp_perturbations(t, x, params.physical.surface_model, ...
    rad_press_func, { params.simulation.jd0 });

% aerodynamics
density_func = @(t, x, varargin) exponential_atm( x(1:3) );
force_funcs{2} = @(t, x, params) ...
    aero_perturbations(t, x, params.physical.Cd, ...
    params.physical.surface_model, density_func, {});

% magnetic field
force_funcs{3} = @(t, x, params) ...
    magnetic_perturbation( t, x, params.physical.res_dipole, ...
    @(varargin) quat2CTM(x(7:10))*params.environment.b, {} );

% gravity gradient
force_funcs{4} = @(t, x, params) ...
    grav_grad_perturbation(t, x, params.environment.muE, ...
    params.physical.J);

%% Kinematics and dynamics funcs

% two body dynamics
kin_dyn_funcs{1} = @(t, x, params) two_body_dynamics(t, x, ...
    params.environment.muE);

% third body perturbation from moon
r3_moon_func = @(t, x, jd0, rE) get_r_moon(t/86400 + jd0, rE);
kin_dyn_funcs{2} = @(t, x, params) ...
    third_body_perturbations(t, x, params.environment.muMoon, ...
    {r3_moon_func}, {{params.simulation.jd0; params.environment.rE}});

% J2-J6 perturbations
kin_dyn_funcs{3} = @(t, x, params) ...
    zonal_harmonics_perturbation(t, x, params.environment.muE, ...
    params.environment.rE, 6);

%% output

engine            = @(t, x, controller, params) ...
    kin_dyn_superposition(t, x, params.physical.m, params.physical.J, ...
    controller.actuator(controller), force_funcs, {{params}}, ...
    kin_dyn_funcs, {{params}});
% graphics.plotter  = @() [];
% graphics.data_gen = @(t, x, controller, params) [];

end