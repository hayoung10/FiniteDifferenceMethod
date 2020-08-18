# FiniteDifferenceMethod
Explicit & Implicit FDM(유한차분법)  
2019.12.02 금융수학 코드  

> 실행 환경 MATLAB R2018a  

- Explicit FDM과 Implict FDM의 **Price** 와 **V(S,t)** 를 구하는 함수 Final을 구현
  - Price : Option value
  - V(S,t) : Option value at time t and stock price S

- Final 함수 파라미터  
  Final(C_P, Method, S, X, r, T, vol, Smax, M, N)
  - C_P : 'C' or 'P' (European Call option or Put option)
  - Method : 'EXP' or 'IMP' (Explicit FDM or Implicit FDM)
  - S : current stock price
  - X : strike price
  - r : risk-free interest rate
  - T : time to expiration
  - vol : volatility
  - Smax : 
  - M : stock price steps
  - N : time steps

- 실행 예시  

```matlab
>> [Price, V]=Final('C','IMP',50,50,0.03,0.5,0.3,200,50,50);
>> Price

Price =
    4.6396
```
V(S,t)에 대한 결과는 **Final('C','IMP',50,50,0.03,0.5,0.3,200,50,50).mat** 파일에 있음
