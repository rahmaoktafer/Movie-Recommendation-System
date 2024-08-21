%% No 1 : Load the data
clear;
%Memuat data
load('users_movies.mat','movies','users_movies','users_movies_sort','index_small','trial_user');
%m dan n adalah jumlah baris dan kolom dari users_movies
[m,n]=size(users_movies);

%% No 2 : print out 20 most popular movies
% index_small :indeks dari 20 movies terpopuler
 fprintf('20 movies terpopuler adalah sebagai berikut:\n')
 for j=1:length(index_small)
    fprintf('%s \n',movies{index_small(j)})
 end;
 fprintf('\n')

 %% No 3 : Membuat matriks ratings yg berisi user yg rate keseluruhan 20 film terpopuler
 %m1 dan n1 adalah jumlah baris dan kolom dari matriks users_movies_sort
 [m1,n1]=size(users_movies_sort);
 
 % ratings adalah matriks yang berisi rating yang diberikan oleh user_movies_sort ke seluruh 
 % 20 movies terpopuler (tidak ada rating 0)
 ratings=[];
 for j=1:m1
    %Cek apakah user rate seluruh 20 movies terpopuler dengan cara mengalikan
    %semua rating yg diberikan. Jika hasil perkaliannya sama dengan 0, maka
    %terdapat movie yang tidak di-rate oleh user tersebut.
    %Matriks ratings hanya mengambil user yang rate keseluruhan movies
    %terpopuler yakni jika perkalian ratingnya tidak sama dengan 0
    if prod(users_movies_sort(j,:))~=0 
        ratings=[ratings; users_movies_sort(j,:)];
    end;
 end;

%% No 4 : Find the Euclidean distances
%m2 dan n2 adalah jumlah baris dan kolom dari matriks ratings
 [m2,n2]=size(ratings);
 for i=1:m2
     %menghitung jarak Euclidean antara setiap baris ratings (setiap user
     %yg memberikan rating keseluruhan film terpopuler) dengan trial_user.
     %Jarak euclidean disimpan dalam array eucl
     eucl(i)=norm(ratings(i,:)-trial_user);
 end

 %% No 5 
 %Mengurutkan jarak euclidean dari terkecil ke terbesar.
 %Semakin dekat jaraknya semakin mirip taste movie nya.
 %MinDist : eucl (Jarak Euclidean) diurutkan dari yg terpendek
 %DistIndex : indeks yang berkaitan dengan eucl yg telah diurutkan dari
 %terpendek.
 %closest_user_Dist : indeks dari user dengan jarak Euclidean terpendek

 [MinDist,DistIndex]=sort(eucl,'ascend');
 closest_user_Dist=DistIndex(1);

 %% No 6 
 %sentralisasi matriks ratings dan trial_user
 ratings_cent = ratings-mean(ratings,2)*ones(1,n2);
 trial_user_cent=trial_user-mean(trial_user);

 %% No 7
% m3 adalah jumlah baris dari matriks ratings
m3 = size(ratings_cent, 1);

%inisialisasi vektor pearson yang nantinya untuk menyimpan koefisien
%korelasi Pearson
pearson = zeros(1, m3);

%Menghitung koefisien korelasi Pearson
for i = 1:m3
    % Mengambil baris ke-i ratings_cent
    row_i = ratings_cent(i, :);
    
    %Koefisien korelasi Pearson antara baris ke-i rating_cent dengan
    %trial_user_cent
    pearson(i) = corr(row_i', trial_user_cent', 'Type', 'Pearson');
end

%% No 8
%MaxPearson : koefisien korelasi Pearson diurutkan dari yg paling besar
%PearsonIndex : indeks yg berkaitan dengan koefisien korelasi Pearson setelah 
% diurutkan dari yang paling besar
[MaxPearson, PearsonIndex] = sort(pearson, 'descend');

% closest_user_Pearson : indeks dari koefisien korelasi Pearson terbesar
closest_user_Pearson = PearsonIndex(1);

%% No 9
% Membandingkan hasil dari menggunakan jarak Euclidean dengan koefisien
% korelasi Pearson.
% comparison = 1 jika DistIndex = PearsonIndex dan comparison = 0 jika
% keduanya tidak sama
comparison = (DistIndex == PearsonIndex);

% Menampilakn indeks user dengan taste yang mirip dengan trial user

%berdasarkan koefisien korelasi Pearson
disp('Closest User Pearson):');
disp(closest_user_Pearson);

%berdasarkan jarak Euclidean
disp('Closest User Dist');
disp(closest_user_Dist);

%Diperoleh closest_user_Dist = 14 dan closest_user_Pearson = 88
% sehingga hasil yang diperoleh dengan menggunakan jarak Euclidean dan
% koefisien korelasi Pearson akan berbeda

%% No 10 : Recommendations
 %recommend_dist adalah array yg berisi indeks movies yang direkomendasikan 
 %kepada trial user menurut Jarak Euclidean
 recommend_dist=[];

 %menentukan movies yang akan direkomendasikan kepada trial user
 %berdasarkan jarak Euclidean
 %n = banyaknya kolom dari user_movies (banyaknya movies)
 for k=1:n
     %jika closest_user_Dist memberikan rating 5 pada movie indeks ke-k, 
     % maka rekomendasikan movie tersebut kepada trial user
    if (users_movies(closest_user_Dist,k)==5)
        recommend_dist=[recommend_dist; k];
    end;
 end;

 %recommend_Pearson vektor yg berisi indeks movies yang direkomendasikan
 %kepada trial user menurut koefisien korelasi Pearson
 recommend_Pearson=[];
 for k=1:n
     %jika rate film pada indeks k oleh closest_user_Pearson = 5, 
     % maka rekomendasikan movie tersebut kepada trial user
     if (users_movies(closest_user_Pearson,k)==5)
         recommend_Pearson=[recommend_Pearson; k];
     end;
 end;

 %liked adalah array yg berisi movies yg disukai trial user dgn kriteria 
 % trial user memberi rating 5
 liked=[];
 for k=1:20
    %jika trial user memberikan rating 5 maka trial user suka dengan movie
    %tersebut
    if (trial_user(k)==5)
        %masukkan indeks movie yang disuka oleh trial user ke array liked
        liked=[liked; index_small(k)];
    end;
 end;

%% No 11
%Menampilkan judul movies yang disukai oleh trial user
disp('Film yg disukai trial_user :')
for i = 1 :length(liked)
    fprintf('%s \n',movies{liked(i)});
end;
fprintf('\n');

%Menampilkan judul movies yang direkomendasikan kepdaa trial user
%berdasarkan jarak Euclidean
disp('Movies yg direkomendasikan kepada trial user berdasarkan jarak Euclidean :')
for i = 1 :length(recommend_dist)
    fprintf('%s \n',movies{recommend_dist(i)});
end;
fprintf('\n');

%Menampilkan judul movies yang direkomendasikan kepaa trial user
%berdasarkan koefisien korelasi Pearson
disp('Film yg direkomendasikan berdasarkan koefisien Pearson :')
for i = 1 :length(recommend_Pearson)
    fprintf('%s \n',movies{recommend_Pearson(i)});
end;
fprintf('\n');

%% No 12
%Ratings yang diberikan oleh kelompok kami untuk ke seluruh 20 movies terpopuler 
% yang disimpan di dalam array myratings
myratings= [4, 5, 0, 1, 3, 4, 4, 0, 3, 1, 5, 5, 0, 3, 1, 4, 4, 5, 3, 2];

%% No 13
%m2 adalah jumlah baris dari matriks ratings
 for i=1:m2
     %Menghitung jarak Euclidean antara setiap baris ratings (setiap user
     %yg memberikan rating keseluruhan movies terpopuler) dengan myratings.
     %Jarak euclidean disimpan dalam array myeucl
     myeucl(i)=norm(ratings(i,:)-myratings);
 end

 %Mengurutkan jarak euclidean dari terkecil ke terbesar
 %Semakin dekat jaraknya semakin mirip taste movie nya
 %myMinDist : myeucl (Jarak Euclidean) diurutkan dari yg terpendek
 %myDistIndex : indeks yang berkaitan dengan myeucl yg telah diurutkan dari
 %terpendek
 %closest_user_Dist : indeks dari user dengan jarak Euclidean terpendek
 [myMinDist,myDistIndex]=sort(myeucl,'ascend');
 my_closest_user_Dist=myDistIndex(1)

 %sentralisasi array myratings
 my_cent=myratings-mean(myratings);

%inisialisasi array mypearson yang nantinya untuk menyimpan koefisien
%korelasi Pearson
mypearson = zeros(1, m3);

%Menghitung koefisien korelasi Pearson
% m3 adalah jumlah baris dari matriks ratings_cent
for i = 1:m3
    % Mengambil baris ke-i ratings_cent
    row_i = ratings_cent(i, :);
    
    %Koefisien korelasi Pearson antara baris ke-i rating_cent dengan my_cent
    mypearson(i) = corr(row_i', my_cent', 'Type', 'Pearson');
end

%myMaxPearson : koefisien korelasi Pearson diurutkan dari yg paling besar
%myPearsonIndex : indeks yg berkaitan dengan koefisien korelasi Pearson 
% setelah diurutkan dari yang paling besar
[myMaxPearson, myPearsonIndex] = sort(mypearson, 'descend');

%my_closest_user_Pearson : indeks dari koefisien korelasi Pearson terbesar
my_closest_user_Pearson = myPearsonIndex(1)

% Membandingkan hasil dari menggunakan jarak Euclidean dengan koefisien
% korelasi Pearson
% mycomparison = 1 jika myDistIndex = myPearsonIndex dan mycomparison = 0 jika
% keduanya tidak sama
mycomparison = (myDistIndex == myPearsonIndex);

% Menampilakn indeks user dengan taste yang mirip dengan kelompok kami

%berdasarkan koefisien korelasi Pearson
disp('My Closest User Pearson):');
disp(my_closest_user_Pearson);

%berdasarkan jarak Euclidean
disp('My Closest User Dist');
disp(my_closest_user_Dist);

%my_recommend_dist adalah array yg berisi indeks movies yang direkomendasikan 
%kepada kelompok kami menurut Jarak Euclidean
my_recommend_dist=[];
%n = banyaknya kolom matriks user_movies (banyaknya movies)
for k=1:n
 %menentukan movies yang akan direkomendasikan kepada kelompok kami
 %berdasarkan jarak Euclidean 
    if (users_movies(my_closest_user_Dist,k)==5)
        %jika my_closest_user_dist memberikan rating 5 pada movie indeks ke-k, 
        % maka rekomendasikan movie tersebut kepada kelompok kami
        my_recommend_dist=[my_recommend_dist; k];
    end;
end;

%my_recommend_Pearson adalah array yg berisi indeks movies yang direkomendasikan
%kepada kelompok kami menurut koefisien korelasi Pearson
 my_recommend_Pearson=[];
 for k=1:n
     %jika rate movie pada indeks k oleh my_closest_user_Pearson = 5, 
     % maka rekomendasikan movie tersebut kepada kelompok kami 
     if (users_movies(my_closest_user_Pearson,k)==5)
         my_recommend_Pearson=[my_recommend_Pearson; k];
     end;
 end;

 %myliked adalah array yg berisi movies yg disukai kelompok kami dgn kriteria 
 % kami memberi rating 5
 myliked=[];
 for k=1:20
    %jika kami memberikan rating 5 maka kami suka dengan movie tersebut
    if (myratings(k)==5)
        myliked=[myliked; index_small(k)];
    end;
 end;

%Menampilkan judul movies yang kami suka
disp('Film yg kami suka :')
for i = 1 :length(myliked)
    fprintf('%s \n',movies{myliked(i)});
end;
fprintf('\n');

%Menampilkan judul movies yang direkomendasikan kepada kelompok kami
%berdasarkan jarak Euclidean
disp('Film yg direkomendasikan untuk saya berdasarkan jarak Euclidean :')
for i = 1 :length(my_recommend_dist)
    fprintf('%s \n',movies{my_recommend_dist(i)});
end;
fprintf('\n');

%Menampilkan judul movies yang direkomendasikan kepada kelompok kami
%berdasarkan koefisien korelasi Pearson
disp('Film yg direkomendasikan berdasarkan koefisien Pearson :')
for i = 1 :length(my_recommend_Pearson)
    fprintf('%s \n',movies{my_recommend_Pearson(i)});
end;
fprintf('\n');

