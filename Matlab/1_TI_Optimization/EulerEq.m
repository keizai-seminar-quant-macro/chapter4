function  res = EulerEq(cons,m,capital,cfcn)
% c��^�����Ƃ��̃I�C���[�������̎c����Ԃ��֐�

wealth = capital.^m.alpha + (1.-m.delta).*capital;

kprime = wealth - cons;
% �g���b�N: k'�͐��̒l�������Ȃ�
kprime = max(m.kgrid(1),kprime);

% �����̐���֐�����`���
%cnext = interp1(m.kgrid,cfcn,kprime,'linear','extrap');
% �����̉��l�֐����X�v���C�����
cnext = interp1(m.kgrid,cfcn,kprime,'spline');

%% �I�C���[������
res = (1/cons) - m.beta*(1/cnext)*(m.alpha*kprime.^(m.alpha-1) + (1.-m.delta));
 
return