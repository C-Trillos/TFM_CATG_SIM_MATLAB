% Analisis de resultados para el Escenario 1 (Terreno Abierto)
% Lee los datos exportados de la app y saca las graficas para la memoria.

clc; clear; close all;

disp('Cargando excel...');
% Nota: el excel tiene que llamarse exactamente asi y estar en esta carpeta
archivo_excel = 'Escenario1.xlsx';

% Leemos las dos pestañas. Le pongo 'preserve' para que no me cambie los
% nombres de las columnas que vienen del App Designer
resumen = readtable(archivo_excel, 'Sheet', 'Resumen_Misiones', 'VariableNamingRule', 'preserve');
telemetria = readtable(archivo_excel, 'Sheet', 'Telemetria_Detallada', 'VariableNamingRule', 'preserve');

% Nombres de los algoritmos tal cual salen en el excel
planificadores = {'A Grid*', 'Hybrid A*', 'PRM', 'RRT*'};
controladores = {'APF', 'VFH', 'DWA', 'FTG'};

% Paleta de colores para las graficas (azul, naranja, amarillo, morado)
colores = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'};

%% 1. MACROMETRICAS (Tiempos y Errores)
disp('Calculando barras de error y tiempos...');

% Preparamos las matrices con NaN por si falla algun dato que no salga un 0 raro en la grafica
matriz_tiempos = NaN(4, 4);
matriz_err_medio = NaN(4, 4);
matriz_err_max = NaN(4, 4);

% Rellenamos las matrices buscando las combinaciones
for i = 1:4
    for j = 1:4
        idx = strcmp(resumen.Planificador_Global, planificadores{i}) & ...
              strcmp(resumen.Evasion_Local, controladores{j});
              
        if any(idx)
            matriz_tiempos(i,j) = resumen.Tiempo_Total_s(idx);
            matriz_err_medio(i,j) = resumen.Error_Medio_m(idx);
            matriz_err_max(i,j) = resumen.Error_Max_m(idx);
        end
    end
end

% Figura con los 3 subplots de barras
fig1 = figure('Name', 'Macrometricas - Escenario 1', 'WindowState', 'maximized');

% Barras de Tiempos
subplot(1,3,1);
b1 = bar(matriz_tiempos, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Tiempo Total (s)', 'FontWeight', 'bold');
title('Tiempo de Ejecucion');
grid on;
for k = 1:4, b1(k).FaceColor = colores{k}; end
legend(controladores, 'Location', 'northwest');

% Barras de Error Medio
subplot(1,3,2);
b2 = bar(matriz_err_medio, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Error Medio Lateral (m)', 'FontWeight', 'bold');
title('Precision Media');
grid on;
for k = 1:4, b2(k).FaceColor = colores{k}; end

% Barras de Error Maximo (Picos de desvio)
subplot(1,3,3);
b3 = bar(matriz_err_max, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Error Maximo Lateral (m)', 'FontWeight', 'bold');
title('Picos de Desviacion');
grid on;
for k = 1:4, b3(k).FaceColor = colores{k}; end


%% 2. MICROMETRICAS (Datos en tiempo real)
disp('Pintando telemetria...');

% --- Planta 2D (Rutas) ---
fig2 = figure('Name', 'Trayectorias XY', 'WindowState', 'maximized');
sgtitle('Trayectorias reales por planificador global', 'FontSize', 14, 'FontWeight', 'bold');
for i = 1:4
    subplot(2, 2, i); hold on;
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.X_m(idx), telemetria.Y_m(idx), 'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}]);
    xlabel('X (m)'); ylabel('Y (m)');
    grid on; axis equal;
    if i == 1, legend('Location', 'best'); end
end

% --- Perfiles de Velocidad (Dividido en 2 partes para mayor tamaño) ---

% Parte 1: A* Grid y Hybrid A* (Indices 1 y 2)
fig3a = figure('Name', 'Velocidad (Parte 1)', 'WindowState', 'maximized');
sgtitle('Evolucion de la velocidad (A* Grid y Hybrid A*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 1:2
    subplot(2, 1, i); hold on; % 2 filas, 1 columna (más anchas y altas)
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            % Aumentamos LineWidth a 2 para que se vea mejor al exportar
            plot(telemetria.Tiempo_s(idx), telemetria.Velocidad_kmh(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Velocidad (km/h)', 'FontSize', 11, 'FontWeight', 'bold');
    ylim([-1 25]); % limite para que se vean todas igual
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

% Parte 2: PRM y RRT* (Indices 3 y 4)
fig3b = figure('Name', 'Velocidad (Parte 2)', 'WindowState', 'maximized');
sgtitle('Evolucion de la velocidad (PRM y RRT*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 3:4
    subplot(2, 1, i-2); hold on; % (i-2) para que use las posiciones 1 y 2 del subplot
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.Tiempo_s(idx), telemetria.Velocidad_kmh(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Velocidad (km/h)', 'FontSize', 11, 'FontWeight', 'bold');
    ylim([-1 25]); 
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

% --- Pitch / Cabeceo (Dividido en 2 partes para mayor tamaño) ---
fig4a = figure('Name', 'Pitch P1 - Escenario 1', 'WindowState', 'maximized');
sgtitle('Angulo de Cabeceo (A* Grid y Hybrid A*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 1:2
    subplot(2, 1, i); hold on;
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.Tiempo_s(idx), telemetria.Pitch_deg(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Pitch (deg)', 'FontSize', 11, 'FontWeight', 'bold');
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

fig4b = figure('Name', 'Pitch P2 - Escenario 1', 'WindowState', 'maximized');
sgtitle('Angulo de Cabeceo (PRM y RRT*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 3:4
    subplot(2, 1, i-2); hold on;
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.Tiempo_s(idx), telemetria.Pitch_deg(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Pitch (deg)', 'FontSize', 11, 'FontWeight', 'bold');
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

% --- Yaw / Orientacion (Dividido en 2 partes para mayor tamaño) ---
fig5a = figure('Name', 'Yaw P1 - Escenario 1', 'WindowState', 'maximized');
sgtitle('Orientacion (A* Grid y Hybrid A*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 1:2
    subplot(2, 1, i); hold on;
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.Tiempo_s(idx), telemetria.Yaw_deg(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Yaw (deg)', 'FontSize', 11, 'FontWeight', 'bold');
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

fig5b = figure('Name', 'Yaw P2 - Escenario 1', 'WindowState', 'maximized');
sgtitle('Orientacion (PRM y RRT*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 3:4
    subplot(2, 1, i-2); hold on;
    for j = 1:4
        idx = strcmp(telemetria.Planificador_Global, planificadores{i}) & ...
              strcmp(telemetria.Controlador_Local, controladores{j});
        if any(idx)
            plot(telemetria.Tiempo_s(idx), telemetria.Yaw_deg(idx), ...
                'LineWidth', 2, 'Color', colores{j}, 'DisplayName', controladores{j});
        end
    end
    title(['Global: ' planificadores{i}], 'FontSize', 12);
    xlabel('Tiempo (s)', 'FontSize', 11, 'FontWeight', 'bold'); 
    ylabel('Yaw (deg)', 'FontSize', 11, 'FontWeight', 'bold');
    grid on;
    legend('Location', 'best', 'FontSize', 10);
end

disp('Fin del Escenario 1. Gráficas reescaladas y listas para exportar.');