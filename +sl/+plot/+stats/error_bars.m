classdef error_bars
    %
    %   Class:
    %   sl.plot.stats.error_bars
    
    properties
        x
        y
        h_data_line
    end
    
    properties (Dependent)
        bar_color
        bar_colors
        bar_width
        bar_widths
    end
    
    properties (Hidden)
        h_lines
        l_lines
        c_lines
    end
    
    methods
        function obj = error_bars(x,y,l,h,varargin)
            %
            %   obj = sl.plot.stats.error_bars(x,y,l,h);
            %
            %   Inputs
            %   ---------------
            %   l: 
            %       lower error, should be relative
            %   h: 
            %       higher error, should be relative
            %
            %   Optional Inputs
            %   ---------------
            %   width:
            %   widths:
            %   bar_options:
            %   line_options:
            %   plot_line: default false
            %
            
            in.width = [];
            in.widths = [];
            in.bar_options = {};
            in.line_options = {};
            in.plot_line = false;
            in = sl.in.processVarargin(in,varargin);
            
            
            if in.plot_line
                obj.h_data_line = plot(x,y,in.line_options{:});
            end
            
            n_points = length(x);
            
            if ~isempty(in.widths)
                widths = in.widths;
            elseif ~isempty(in.width)
                widths = width*ones(1,n_points);
            else
                widths = 0.5*mean(diff(x))*ones(1,n_points);
            end
            
            L_x1 = x -0.5*widths;
            L_x2 = L_x1 + widths;
            H_x1 = L_x1;
            H_x2 = L_x2;
            L_y  = y - l;
            H_y  = y + h;
            
            
            h_lines = zeros(1,n_points);
            l_lines = zeros(1,n_points);
            c_lines = zeros(1,n_points);
            
            %Bar Plotting
            %--------------------------------------------------------------
            has_color = any(strcmp(in.bar_options(1:2:end),'color'));
            if ~has_color
                last_index = get(gca,'ColorOrderIndex')-1;
                colors = get(gca,'ColorOrder');
                last_color = colors(last_index,:);
                in.bar_options = [in.bar_options {'color' last_color}];
            end
            options = h__expandOptions(n_points,in.bar_options);
            for iPoint = 1:n_points
                h_lines(iPoint) = line([H_x1(iPoint) H_x2(iPoint)],[H_y(iPoint),H_y(iPoint)],options{iPoint,:});
                l_lines(iPoint) = line([L_x1(iPoint) L_x2(iPoint)],[L_y(iPoint),L_y(iPoint)],options{iPoint,:});
                c_lines(iPoint) = line([x(iPoint) x(iPoint)],[L_y(iPoint),H_y(iPoint)],options{iPoint,:});
            end
        end
    end
    
end

function expanded_options = h__expandOptions(n_points,options)
    %
    %   The main idea here is that a cell is expanded to individual
    %   values where as scalars are simply replicated
    
    expanded_options = cell(n_points,length(options));
    for iOption = 2:2:length(options)
        cur_name = options{iOption-1};
        expanded_options(:,iOption-1) = {cur_name};

        cur_value = options{iOption};
        if iscell(cur_value)
            expanded_options(:,iOption) = cur_value;
        else
            expanded_options(:,iOption) = {cur_value};
        end
    end
end

