function err = calcerr(m,cfcn0)
%% �I�C���[����������덷�𑪒�
% ���̃O���b�h�ł̓I�C���[�������̌덷�̓[���ɂȂ邽�߁A�O���b�h���ׂ����Ƃ�
theta = m.invT*cfcn0;
kgrid_err = linspace(m.kmin,m.kmax,(m.nk-1)*10+1)';
T = polybas(m.kmin,m.kmax,m.nk,kgrid_err);
cons = T*theta;
%cons = interp1(m.kgrid,cfcn0(:,1),kgrid_err);
LHS  = mu_CRRA(cons, m.gamma);

kp   = kgrid_err.^m.alpha + (1-m.delta)*kgrid_err - cons;
T = polybas(m.kmin,m.kmax,m.nk,kp);
cnext = T*theta;
%cnext = interp1(m.kgrid, cfcn0(:,1), kp);
rent = m.alpha.*kp.^(m.alpha-1.0) - m.delta;
RHS  = m.beta.*(1.+rent).*mu_CRRA(cnext,m.gamma);

err  = RHS./LHS-1.0;