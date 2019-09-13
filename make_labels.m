function labels = make_labels(tsize, emotions)
%Given the total size of the labels array and  another 2D array with the 
%number of utterances of each emotion for every actor (number of actors 
%the rows in the array and number of emotions the elements of each row).

labels = ones(tsize,1);
 k=1;
 for i=1:size(emotions,1)
     for j=1:size(emotions,2)
         labels(k:k+emotions(i,j)-1) = j;
         k = k+emotions(i,j);
     end
 end