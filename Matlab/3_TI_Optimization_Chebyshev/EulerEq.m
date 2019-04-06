function  res = EulerEq(cons)
% Function EulerEq
%  [res] = EulerEq(kprime)
%
% 目的:
% k'を一つ与えたときのオイラー方程式の残差を返す関数.
% main_ti.mから呼び出して使う.
%
% グローバル変数: beta gamma alpha delta capital vfcn kgrid

global beta gamma alpha delta capital cfcn kgrid

%% オイラー方程式

wealth = capital.^alpha + (1.-delta).*capital;

kprime = wealth - cons;
%% トリック(1): k'は正の値しか取らない
kprime = max(kgrid(1),kprime);

% 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
%if cons > 0.0
%    util = CRRA(cons, gamma);
%else
%    util = -10000.0;
%end

% 次期の政策関数を線形補間
%cnext = interp1(kgrid, cfcn, kprime, 'linear', 'extrap');

% 次期の価値関数をスプライン補間
cnext = interp1(kgrid, cfcn, kprime, 'spline');

res = (1/cons) - beta*(1/cnext)*(alpha*kprime.^(alpha-1) + (1.-delta));
%value = util + beta.*vnext;

%% トリック(1): k'は正の値しか取らないので、ペナルティを与えてその値が選ばれないようにする
%if kprime < 0
%    value = -1000000.0;
%end

%% トリック(2): "最小化"をするので符号を反転
%value = -1.0 * value;
 
return