function ser(data, labels, mytitle)
%Runs tsne for various cases of input. This is the already exitsting
%implementation of tsne algorithm and it involves  PCA of the input at the
%begining of the process.
%For example, given different values for perplexity.
%Moreover, it shows the results given just the information about a signal's
%intensty.
%Also, runs tsne for only the intense and calm utterances of a signal.


 no_dims=2;
 initial_dims=30;
 perplexity=30;
 
 result = tsne(data, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');
 
 initial_dims=100;
 result = tsne(data, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');
 
 initial_dims=50;
 result = tsne(data, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');
 
 perplexity = 100;
 result = tsne(data, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');
 
 perplexity = 10;
 result = tsne(data, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');
 
 
 
 %emotional intensity
 for i=1:24
     %neutral emotion only calm
    for j=1:4
        em_intensity((i-1)*60+j)=1;
    end
    %other emotions both calm and intense samples
    for k=2:8
        for n=1:4
            em_intensity((i-1)*60+4+8*(k-2)+n)=1;
        end
        for m=5:8
            em_intensity((i-1)*60+4+8*(k-2)+m)=2;
        end
    end
 end
 
 figure();
 gscatter(result(:,1), result(:,2), em_intensity);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity)]);
 legend('calm','intense');
 
 
 %taking only calm aspects of emotions
 for i=1:24
     %neutral emotion only calm
    for j=1:4
       calm((i-1)*32+j, :)=data((i-1)*60+j,:);
    end
    %other emotions both calm and intense samples
    for k=2:8
        for n=1:4
            calm((i-1)*32+4+4*(k-2)+n, :)=data((i-1)*60+4+8*(k-2)+n, :);
        end
    end
 end
 %labels for calm case
for i=1:24
  %4 samples of the first emotion for each of the 24 actors
   for j=1:4
      labels2((i-1)*32+j) = 1;
   end
  %8 samples for each of the rest emotions for each actor
  for k=2:8
    for j=1:4
       labels2((i-1)*32+4+4*(k-2)+j) = k;
    end
  end
end

 result = tsne(calm, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels2);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity), 'calm-samples']);
 legend('neutral','calm','happy','sad','angry','fearful','surprise','disgust');

%taking only intense aspects of emotions
 for i=1:24
    %other emotions both calm and intense samples
    for k=2:8
        for n=1:4
            intense3((i-1)*28+4*(k-2)+n, :)=data((i-1)*60+4+8*(k-2)+n+4, :);
        end
    end
 end
%labels
for i=1:24
    %other emotions both calm and intense samples
    for k=2:8
        for n=1:4
            labels3((i-1)*28+(k-2)*4+n)=k;
        end
    end
end

 result = tsne(intense3, [], no_dims, initial_dims, perplexity);
 figure();
 gscatter(result(:,1), result(:,2), labels3);
 title([mytitle,',initial-dims:',num2str(initial_dims),',perplexity:',num2str(perplexity),'intense-samples']);
 legend('calm','happy','sad','angry','fearful','surprise','disgust');
 