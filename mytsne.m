function result=mytsne(X, perp)

%!!!Calculation of conditional probabilities between the given
%datapoints!!!

%???need for normalization???
X = X - min(X(:));
X = X / max(X(:));
X = X-mean(X,1);


%conditionnal probabilities
%p(j|i)=exp(-||x(i)-x(j)||^2/2*cvr^2)/S(k!=i)(exp(-||x(i)-x(k)||^2/2*cvr^2))


%Create the distances between given datapoints x(i)

%Given the input array x(i) is its rows so
M = sum(X.^2,2); %||x(i)||^2
Product = X*X';        %x(i)*x(j) X=[x(1),x(2),...,x(n)]' so [x(1),x(2),...,x(n)]'*[x(1),x(2),...,x(n)]
Distances = M-2*Product+M';    %||x(i)-x(j)||^2=||x(i)||^2-2x(i)x(j)+||x(j)||^2



%!!!Finding cvr=covariance according to given perplexity!!!

%each datapoint will have a different(possibly) covariance so we need an
%array for the cvr of each datapoint starting at the value 1(no particular reson for thiw choice)
n = size(X,1);
inv_cvr = ones(n, 1); %the elements are 1/2*cvr^2 to make calculations easier
HP = log(perp);       %perp(P(i))=2^H(P(i))

%final array of probabilities
P = zeros(n,n);

%H(P(i))=-S(j)(p(j|i)*log(p(j|i)))
for i=1:n 
    
    %binary search for correct cvr
    mymax = Inf;
    mymin = -Inf;
    
    %findfirst H
    H = cal_H(Distances(i,[1:i-1,i+1:end]), inv_cvr(i));
    
    %compare with given pepr
    Diff = HP-H;
    %set a tolerance for the difference between given and calculated perp
    tolerance = 0.00001;
    rep = 0;
    while(abs(Diff)>tolerance && rep < 50)
      
      if(Diff<0) %we want to make H smaller, so we make inv_cvr bigger
        mymin = inv_cvr(i);
        if(mymax==Inf)
            inv_cvr(i) = inv_cvr(i)*2;
        else
            inv_cvr(i) = (inv_cvr(i)+mymax)/2;
        end
      else  %we want to make H bigger, so inv_cvr smaller
        mymax = inv_cvr(i);
        if(mymin==-Inf)
            inv_cvr(i) = inv_cvr(i)/2;
        else
            inv_cvr(i) = (inv_cvr(i)+mymin)/2;
        end
      end
      
      H = cal_H(Distances(i,[1:i-1,i+1:n]), inv_cvr(i)); %not taking the element in diag
      Diff = HP - H;
      rep = rep+1;
    end
    
    %when found, we compute the P(j|i) as
    Pin = exp(-Distances(i,[1:i-1,i+1:end])*inv_cvr(i));
    Pi_sum = sum(Pin); 
    Pi = Pin/Pi_sum;
    
    %put in final P array
    P(i,[1:i-1,i+1:end]) = Pi;
    
end



%!!!Symmetric SNE: make joint probabilities!!!
P(1:n + 1:end) = 0;   
P = (P+P')/2;  %p(ij) = (p(j|i)+p(i|j))/2
P = max(P / sum(P(:)), realmin);
P = 4*P; %optimization technique

%!!!initial solution y with values in (0,0.0001)
Y = 0.0001*randn(n,2);
Prev = zeros(n,2);
%for learning rate
gains = ones(n,2);
min_gain = 0.01;

stop_opt = 200;


%???number of iterations t, learning rate h, momentum a???
t = 1000;
h = 500;
a = 0.5;

for i=1:t
    
    disp(['Iteration' num2str(i)]);
    %calculate distances between low dimensional points
    M_low = sum(Y.^2,2);
    Product_low = Y*Y';
    Distances_y = M_low-2*Product_low+M_low';
    
    %compute q(ij) with t-Student 
    Qn = 1./(1+Distances_y);
    Qn(1:n+1:end) = 0; %the diag will be Inf because of division with 0, so set 0
    S = sum(Qn(:));
    Q = max((Qn / S), realmin);
    
    %comptute the gradient of cost
    %gradient(Cost) = 4*S(j)((p(ij)-q(ij))*(y(i)-y(j))*((1+||y(i)-y(j)||^2)^(-1)))
    C = (P-Q).*Qn;
    GC = 4*(sum(C,2).*Y-C*Y);
    
    if(i==250)
        a=0.8;
    end
    if(i==stop_opt)
        P = P/4;
    end
    
     gains = (gains + .2) .* (sign(GC) ~= sign(Prev)) ...         % note that the y_grads are actually -y_grads
              + (gains * .8) .* (sign(GC) == sign(Prev));
     gains(gains < min_gain) = min_gain;
     Prev = a * Prev - h * (gains .* GC);
     Y = Y+Prev;
    %Y = Y+h*GC+a*(Y-Prev);
     Y = Y-mean(Y,1); %normalization
    
end

result = Y;
end

%calculate H(P(i))=H
function H = cal_H(Dis, in_c)
    A = exp(-Dis*in_c);
    B = sum(A);
    H = log(B)+ (in_c/B)*sum(Dis.*A);
end
