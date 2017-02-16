classdef subset_retrieval
    %
    %   Class:
    %   sci.time_series.subset_retrieval
    %
    %   This class was designed to be accessed via the subset property of
    %   sci.time_series.data
    %
    %   e.g. my_data.subset.fromEpoch
    %       - this calls the fromEpoch method below
    %
    %   See Also
    %   --------
    %   sci.time_series.subset_retrieval.processor
    %   sci.time_series.subset_retrieval.epoch_processor
    %   sci.time_series.subset_retrieval.event_processor
    %
    %   Optional Inputs (to functions)
    %   --------------------------------
    %   See the properties in:
    %       - sci.time_series.subset_retrieval.epoch_processor
    %       - sci.time_series.subset_retrieval.event_processor
    %       - sci.time_series.subset_retrieval.processor
    %   p_only: logical (default false)
    %       If true, the subset of data is not returned, but rather the
    %       processor with the specified options. The processor can then
    %       be executed using the fromProcessor() method.
    %           data.subset.fromProcessor(p)
    %
    
    properties
        data %sci.time_series.data
    end
    
    methods
        function obj = subset_retrieval(data)
            obj.data = data;
        end
    end
    
    methods
        function output = fromEpoch(obj,epoch_name,varargin)
            %
            %   output = fromEpoch(obj,epoch_name,varargin)
            %
            %                       epoch
            %    ---------------++++++++++++-------------------
            %   start_time = epoch_start
            %   stop_Time  = epoch_end
            %
            %   Inputs
            %   ------
            %   epoch_name
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.epoch_processor
            %
            %   Example
            %   -------
            %   subset = my_data.subset.fromEpoch('fill')
            %
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.epoch_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.epoch_name = epoch_name;
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEpochAndPct(obj,epoch_name,start_pct_offset,stop_pct_offset,varargin)
            %
            %   output = fromEpochAndPct(obj,epoch_name,varargin)
            %
            %                       epoch
            %    ---------------++++++++++++-------------------
            %   start_time = epoch_start + start_pct_offset*(epoch_duration)
            %   stop_Time  = epoch_end + stop_pct_offset*(epoch_duration)
            %
            %   Inputs
            %   ------
            %   epoch_name
            %   start_pct_offset
            %   stop_pct_offset
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.epoch_processor
            %
            %   Example
            %   -------
            %   %Grab from 20% to 80%
            %   subset = my_data.subset.fromEpochAndPct('fill',0.2,0.8)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.epoch_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.epoch_name = epoch_name;
            ep.percent = [start_pct_offset stop_pct_offset];
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEpochAndSampleWindow(obj,epoch_name,start_sample_offset,stop_sample_offset,varargin)
            %
            %   output = fromEpochAndSampleWindow(obj,epoch_name,start_sample_offset,stop_sample_offset,varargin)
            %
            %                       epoch
            %    ---------------++++++++++++-------------------
            %   start_sample = epoch_start + start_sample_offset
            %   stop_sample  = epoch_end + stop_sample_offset
            %
            %   Inputs
            %   ------
            %   epoch_name
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.epoch_processor
            %
            %   Example
            %   -------
            %   %Grab starting in 1000 samples and ending 500 samples early
            %   subset = my_data.subset.fromEpochAndSampleWindow('fill',1000,-500)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.epoch_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.epoch_name = epoch_name;
            ep.sample_offsets = [start_sample_offset stop_sample_offset];
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
            
        end
        function output = fromEpochAndTimeWindow(obj,epoch_name,start_time_offset,stop_time_offset,varargin)
            %
            %   output = fromEpochAndTimeWindow(obj,epoch_name,start_time_offset,stop_time_offset,varargin)
            %
            %                       epoch
            %    ---------------++++++++++++-------------------
            %   start_time = epoch_start + start_time_offset
            %   stop_time  = epoch_end + stop_time_offset
            %
            %
            %   Inputs
            %   ------
            %   epoch_name:
            %   start_time_offset:
            %   stop_time_offset:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.epoch_processor
            %
            %   Example
            %   -------
            %   %Grab after dropping the first 10s, and going until 5s after the end
            %   subset = my_data.subset.fromEpochAndTimeWindow('fill',10,5)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.epoch_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.epoch_name = epoch_name;
            ep.time_offsets = [start_time_offset stop_time_offset];
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromStartAndStopEvent(obj,start_name,stop_name,varargin)
            %
            %   output = fromStartAndStopEvent(obj,epoch_name,start_time_offset,stop_time_offset,varargin)
            %
            %                   start event      stop event
            %    ---------------+----------------+------------------
            %   start_time = start_event
            %   stop_time  = stop_event
            %
            %   Inputs
            %   ------
            %   start_name:
            %   stop_name:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.event_processor
            %
            %   Example
            %   -------
            %   %Grab from the start of the pump to the 1st bladder contraction
            %   subset = my_data.subset.fromStartAndStopEvent('start_pump','bladder_contraction_starts')
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.event_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.start_name = start_name;
            ep.stop_name = stop_name;
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEventAndTimeWindow(obj,event_name,start_time_offset,stop_time_offset,varargin)
            %
            %   output = fromStartAndStopEvent(obj,epoch_name,start_time_offset,stop_time_offset,varargin)
            %
            %                   event
            %    ---------------+-----------------------------------
            %   start_time = event + start_time_offset
            %   stop_time  = event + stop_time_offset
            %
            %   Inputs
            %   ------
            %   event_name:
            %   start_time_offset:
            %   stop_time_offset:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.event_processor
            %
            %   Example
            %   -------
            %   %Grab from 1 second before the 'start_pump' to 2 seconds after
            %   subset = my_data.subset.fromEventAndTimeWindow('start_pump',-1,2)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.event_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.start_name = event_name;
            ep.time_offsets = [start_time_offset stop_time_offset];
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEventAndSampleWindow(obj,event_name,start_sample_offset,stop_sample_offset,varargin)
            %
            %   output = fromEventAndSampleWindow(obj,event_name,start_sample_offset,stop_sample_offset,varargin)
            %
            %                   event
            %    ---------------+-----------------------------------
            %   start_sample = event + start_sample_offset
            %   stop_sample  = event + stop_sample_offset
            %
            %   Inputs
            %   ------
            %   event_name:
            %   start_sample_offset:
            %   stop_sample_offset:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.event_processor
            %
            %   Example
            %   -------
            %   %Grab from 10 to 20 samples after the 'start_pump' event
            %   subset = my_data.subset.fromEventAndSampleWindow('start_pump',10,20)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.event_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.start_name = event_name;
            ep.sample_offsets = [start_sample_offset,stop_sample_offset];
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEventAndTimeDuration(obj,event_name,time_duration,varargin)
            %
            %   output = fromEventAndTimeDuration(obj,event_name,time_duration,varargin)
            %
            %                   event
            %    ---------------+-----------------------------------
            %   start_time = event_time
            %   stop_time  = event_time + time_duration
            %
            %   Inputs
            %   ------
            %   event_name:
            %   time_duration:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.event_processor
            %
            %   Example
            %   -------
            %   %Grab 10 seconds, starting at the event
            %   subset = my_data.subset.fromEventAndTimeDuration('start_pump',10)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.event_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.start_name = event_name;
            ep.time_duration = time_duration;
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromEventAndSampleDuration(obj,event_name,sample_duration,varargin)
            %
            %   output = fromEventAndSampleDuration(obj,event_name,sample_duration,varargin)
            %
            %                   event
            %    ---------------+-----------------------------------
            %   start_time = event_time
            %   stop_time  = event_time + sample_duration
            %
            %   Inputs
            %   ------
            %   event_name:
            %   time_duration:
            %
            %   Optional Inputs
            %   ---------------
            %   See sci.time_series.subset_retrieval.event_processor
            %
            %   Example
            %   -------
            %   %Grab 1000 samples, starting at the event
            %   subset = my_data.subset.fromEventAndSampleDuration('start_pump',1000)
            
            [~,p_only,varargin] = sl.in.getOptionalParameter(varargin,'p_only','default',false,'remove',true);
            ep = sci.time_series.subset_retrieval.event_processor;
            ep = sl.in.processVarargin(ep,varargin);
            ep.start_name = event_name;
            ep.sample_duration = sample_duration;
            if p_only
                output = ep;
            else
                output = ep.getSubset(obj.data);
            end
        end
        function output = fromProcessor(obj,processor)
            %
            %   In this usage case, the processor is populated,
            %   and then we are simply passing it the data.
            output = processor.getSubset(obj.data);
        end
    end
    
end
