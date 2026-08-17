% Analisis de resultados para el Escenario 2 (Alta Densidad / Paso Estrecho)
% Lee los datos exportados y saca las graficas evidenciando los fallos de RRT*

clc; clear; close all;

disp('Cargando excel del Escenario 2...');
archivo_excel = 'Escenario2.xlsx';

% Leemos las pestanas respetando los nombres de las columnas
resumen = readtable(archivo_excel, 'Sheet', 'Resumen_Misiones', 'VariableNamingRule', 'preserve');
telemetria = readtable(archivo_excel, 'Sheet', 'Telemetria_Detallada', 'VariableNamingRule', 'preserve');

planificadores = {'A Grid*', 'Hybrid A*', 'PRM', 'RRT*'};
controladores = {'APF', 'VFH', 'DWA', 'FTG'};

% Colores estandar (azul, naranja, amarillo, morado)
colores = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'};

%% 1. MACROMETRICAS (Tiempos y Errores)
disp('Filtrando misiones exitosas y calculando barras...');

% Ponemos todo a NaN para que los fallos salgan como huecos limpios en la grafica
matriz_tiempos = NaN(4, 4);
matriz_err_medio = NaN(4, 4);
matriz_err_max = NaN(4, 4);

for i = 1:4
    for j = 1:4
        idx = strcmp(resumen.Planificador_Global, planificadores{i}) & ...
              strcmp(resumen.Evasion_Local, controladores{j});
              
        if any(idx)
            % Cogemos el estado (con find cogemos la fila exacta por si acaso)
            estado = resumen.Estado_Final{find(idx, 1)};
            
            % Solo guardamos los datos si la mision no acabo en choque o bloqueo
            if contains(estado, 'XITO') % Lo pongo asi por si hay lios con la tilde de EXITO
                matriz_tiempos(i,j) = resumen.Tiempo_Total_s(idx);
                matriz_err_medio(i,j) = resumen.Error_Medio_m(idx);
                matriz_err_max(i,j) = resumen.Error_Max_m(idx);
            end
        end
    end
end

% Figura de barras (Macrometricas)
fig1 = figure('Name', 'Macrometricas - Escenario 2', 'WindowState', 'maximized');

% Tiempos
subplot(1,3,1);
b1 = bar(matriz_tiempos, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Tiempo Total (s)', 'FontWeight', 'bold');
title('Tiempo de Ejecucion');
grid on;
for k = 1:4, b1(k).FaceColor = colores{k}; end
legend(controladores, 'Location', 'northwest');

% Error Medio
subplot(1,3,2);
b2 = bar(matriz_err_medio, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Error Medio Lateral (m)', 'FontWeight', 'bold');
title('Precision Media');
grid on;
for k = 1:4, b2(k).FaceColor = colores{k}; end

% Error Maximo
subplot(1,3,3);
b3 = bar(matriz_err_max, 'grouped');
set(gca, 'XTickLabel', planificadores, 'FontSize', 11);
ylabel('Error Maximo Lateral (m)', 'FontWeight', 'bold');
title('Picos de Desviacion');
grid on;
for k = 1:4, b3(k).FaceColor = colores{k}; end


%% 2. MICROMETRICAS (Telemetria detallada)
disp('Pintando telemetria. (El subplot de RRT* saldra vacio aposta)');

% --- Planta 2D (Rutas) ---
fig2 = figure('Name', 'Trayectorias XY - Escenario 2', 'WindowState', 'maximized');
sgtitle('Trayectorias reales en Terreno Denso', 'FontSize', 14, 'FontWeight', 'bold');
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

% --- Perfiles de Velocidad (Dividido en 2 partes) ---
fig3a = figure('Name', 'Velocidad P1 - Escenario 2', 'WindowState', 'maximized');
sgtitle('Evolucion de la velocidad (A* Grid y Hybrid A*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 1:2
    subplot(2, 1, i); hold on;
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

fig3b = figure('Name', 'Velocidad P2 - Escenario 2', 'WindowState', 'maximized');
sgtitle('Evolucion de la velocidad (PRM y RRT*)', 'FontSize', 14, 'FontWeight', 'bold');
for i = 3:4
    subplot(2, 1, i-2); hold on;
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
    % Evitamos poner leyenda si esta vacio (ej. RRT*)
    if i == 3, legend('Location', 'best', 'FontSize', 10); end 
end

% --- Pitch / Cabeceo (Dividido en 2 partes) ---
fig4a = figure('Name', 'Pitch P1 - Escenario 2', 'WindowState', 'maximized');
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

fig4b = figure('Name', 'Pitch P2 - Escenario 2', 'WindowState', 'maximized');
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
    if i == 3, legend('Location', 'best', 'FontSize', 10); end
end

% --- Yaw / Orientacion (Dividido en 2 partes) ---
fig5a = figure('Name', 'Yaw P1 - Escenario 2', 'WindowState', 'maximized');
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

fig5b = figure('Name', 'Yaw P2 - Escenario 2', 'WindowState', 'maximized');
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
    if i == 3, legend('Location', 'best', 'FontSize', 10); end
end

disp('Fin del Escenario 2. Gráficas reescaladas y listas para exportar.');