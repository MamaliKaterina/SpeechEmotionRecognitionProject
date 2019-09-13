function [data, labels]=read_zenodo(filename, n_actors, n_utter, opening, closing)

%This function is made to read data files taken from extraction of features
%using OpenSmile from zenodo database where we have 24 actors with 60 utterations each.
%Also, there are 8 -including neutral- feelings expressed: calm, happy,
%sad, angry, fearful, surprise and disgust.
%filename takes the name of the file to read from and n_actors is the number of actors 
%and n_utter is the number of utterances for each actor.
%emotions is the an array 2D which will contain for each actor the number
%of his/her utterances that express a specific emotion.
%opening and closing is used to specify if the start and/or end of the
%arithmetic data for each utterance contians a string, so as the code will
%omit it.
%labels is made according to the series of the emotions in each actors unit
%of utterances.

%n=number of samples/different vectors in the file
%filename='AllActorsEmobase2010.csv'; 

fid = fopen(filename,'r');

n = n_actors*n_utter;
 
 %reading input file
 for i=1:n
     if exist('opening','var') && opening==1
        textscan(fid, '%s', 1, 'Delimiter', ',');
     end
     %suppose samples are divided by '\n' in the file
     input = textscan(fid, '%f64', 'ExpChars', 'e', 'Delimiter', ",");
     data(i, :) = input{1};
     if exist('closing','var') && closing==1
        textscan(fid, '%s', 1, 'Delimiter', ',');
     end
 end
 fclose(fid);
 
 %emotion labels
 emotions1 = [4, 8, 8, 8, 8, 8, 8, 8];
 emotions = zeros(n_actors, size(emotions1,2));
 emotions=emotions+emotions1;
 
 labels = make_labels(n, emotions);

 
 
