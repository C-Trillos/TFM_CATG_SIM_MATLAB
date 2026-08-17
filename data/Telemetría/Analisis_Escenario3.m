% Analisis de resultados para el Escenario 3 (Evasion Dinamica)
% Compara el "cara a cara" de los 4 algoritmos locales frente a un obstaculo repentino
clc; clear; close all;
disp('Cargando excel del Escenario 3...');
archivo_excel = 'Escenario3.xlsx';

% Ojo aqui: asegurate de que la pestana del obstaculo se llama exactamente
% asi en tu excel, con la tilde en la 'a' de Dinámicos.
telemetria = readtable(archivo_excel, 'Sheet', 'Telemetria_Detallada', 'VariableNamingRule', 'preserve');
obstaculo = readtable(archivo_excel, 'Sheet', 'Obstaculos_Dinámicos', 'VariableNamingRule', 'preserve');

% Colores estandar
colores = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'};

%% 1. TRAYECTORIAS XY (Vista en planta de la esquiva)
fig1 = figure('Name', 'Trayectorias XY - Escenario 3', 'WindowState', 'maximized');
hold on;

% Extraemos donde pusiste el click del obstaculo
centro_x = obstaculo.Centro_X(1); 
centro_y = obstaculo.Centro_Y(1);
radio_obstaculo = 2.5; % Suponemos ~2.5m contando el radio del coche y margen

% Dibujamos el circulo a mano con senos y cosenos para evitar problemas de toolboxes
theta = linspace(0, 2*pi, 100);
plot(centro_x + radio_obstaculo*cos(theta), centro_y + radio_obstaculo*sin(theta), ...
    'k--', 'LineWidth', 1.5, 'DisplayName', 'Margen Obstaculo');
plot(centro_x, centro_y, 'kx', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Centro ROI');

% Pintamos las 4 misiones superpuestas
for m = 1:4
    idx = (telemetria.ID_Mision == m);
    if any(idx)
        nombre_controlador = telemetria.Controlador_Local{find(idx, 1)};
        plot(telemetria.X_m(idx), telemetria.Y_m(idx), 'LineWidth', 2.5, ...
             'Color', colores{m}, 'DisplayName', nombre_controlador);
    end
end

axis equal; 
grid on;
xlabel('X (m)', 'FontSize', 11, 'FontWeight', 'bold'); 
ylabel('Y (m)', 'FontSize', 11, 'FontWeight', 'bold');
title('Comparativa de Evasion Local (Planificador Global: A* Grid)', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);

%% 2. PERFIL DE VELOCIDAD (Frenadas)
fig2 = figure('Name', 'Velocidad - Escenario 3', 'WindowState', 'maximized');
hold on;

for m = 1:4
    idx = (telemetria.ID_Mision == m);
    if any(idx)
        nombre_controlador = telemetria.Controlador_Local{find(idx, 1)};
        plot(telemetria.Tiempo_s(idx), telemetria.Velocidad_kmh(idx), 'LineWidth', 2.5, ...
             'Color', colores{m}, 'DisplayName', nombre_controlador);
    end
end

grid on;
xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
ylabel('Velocidad (km/h)', 'FontSize', 11, 'FontWeight', 'bold');
title('Evolucion de la velocidad durante la Evasion', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);

disp('Fin del Escenario 3. Graficas separadas y listas para exportar.');