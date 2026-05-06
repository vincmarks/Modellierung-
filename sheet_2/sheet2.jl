# 2 Bonus
using Pkg
Pkg.activate()

Pkg.add("Plots")
Pkg.add("LaTeXStrings")

using Plots
using LaTeXStrings

plot_folder = joinpath(@__DIR__, "Plots")

function res_sin(x1, h)
    x0 = x1-h
    x2 = x1+h
    return abs(cos(x0) - (sin(x2)-sin(x0))/(2*h))
end

err = []

for i in 1:10
    h = 10.0^(-i)
    push!(err, res_sin(pi/4, h))
end
p1 = scatter(10.0 .^(-1:-1:-10) , err, yaxis=:log, xaxis=:log, label="Error", xlabel=L"10^{-i}", ylabel="Error", legend =:bottomright)
vline!(p1, [sqrt(eps())], label=L"h = \sqrt{\epsilon}", color=:red, linestyle=:dash)
savefig(p1, joinpath(plot_folder, "error_sin.png"))

# one can show, that the error is not monotonely decreasing for h->0. That ist because of rounding errrors.
# From a error analysis point ov view, one gets O(eps()/h) as rounding errors and O(h) as an error of the method. eps() is here the machine precision
# combining these two we obtain: g(h) = eps()/h + h. Minimizing g results in h = sqrt(eps()). This is actually a global minimum, since g''(h)<0
#sqrt(eps()) ≈ 1.4901161193847656e-8. actually we can see this in the plot itself.

# Exercise 3
function riemann_sum(f, a, b, n)
    h = (b - a) / n
      x = [a + i*h for i in 0:n-1] 
    return sum(f.(x)) * h
end

function trapezoidal_rule(f, a, b, n)
    h = (b - a) / n
    x = range(a, b, length=n+1)
    return (h/2) * (f(a) + 2*sum(f.(x[2:end-1])) + f(b))
end


function simpson_rule(f, a, b, n)
    @assert iseven(n)
    h = (b - a) / n
    x = range(a, b, length=n+1)         
    return (h/3) * (f(a) + 2 * sum(f.(x[3:2:end-1])) + 4 * sum(f.(x[2:2:end-1])) + f(b))
end   


function error_analysis(f, a, b, true_value, n)  
    riemann_error      = abs(riemann_sum(f, a, b, n)      - true_value)
    trapezoidal_error  = abs(trapezoidal_rule(f, a, b, n) - true_value)
    simpson_error      = abs(simpson_rule(f, a, b, n)     - true_value)
    return riemann_error, trapezoidal_error, simpson_error
end

n_values = [10, 20, 50, 100, 200, 500, 1000]   
errors = [error_analysis(sin, 0, pi, 2, n) for n in n_values]

# errors for n=10 
c1 = errors[1][1]   # riemann error at n=10
c2 = errors[1][2]   # trapezoidal error at n=10
c4 = errors[1][3]   # simpson error at n=10

p2 = plot(n_values, [e[1] for e in errors],title = L"\sin", label="Riemann Sum",
     xaxis=:log, yaxis=:log, xlabel="n", ylabel="Error", linewidth = 5)
plot!(p2,n_values, [e[2] for e in errors], label="Trapezoidal Rule", linestyle=:dash,  linewidth = 4)
plot!(p2, n_values, [e[3] for e in errors], label="Simpson's Rule",  linewidth = 4)
plot!(p2, n_values, [c1 * (10/n)^1 for n in n_values], label="O(1/n)",  linestyle=:dash,  linewidth = 4)
plot!(p2, n_values, [c2 * (10/n)^2 for n in n_values], label="O(1/n²)", linestyle=:dash, linewidth = 5)
plot!(p2, n_values, [c4 * (10/n)^4 for n in n_values], label="O(1/n⁴)", linestyle=:dash, linewidth = 4)

savefig(p2, joinpath(plot_folder, "error_sin_integration.png"))

# in this case we see, that the errors of the riemann sum and the trapezeudal rule allign with each other. 
# normally I would not expect this. However, in this special periodic case these both methods seem to be identically due to the boundary terms sin(0)=sin(pi)=0
#############
# other example with no periodic function to varify the error behavior of the methods using exp

errors = [error_analysis(exp, 0, 5, exp(5)-1, n) for n in n_values]

# errors for n=10 
c1 = errors[1][1]   # riemann error at n=10
c2 = errors[1][2]   # trapezoidal error at n=10
c4 = errors[1][3]   # simpson error at n=10

p3 = plot(n_values, [e[1] for e in errors],title = L"\exp", label="Riemann Sum",
     xaxis=:log, yaxis=:log, xlabel="n", ylabel="Error", linewidth = 5)
plot!(p3, n_values, [e[2] for e in errors], label="Trapezoidal Rule", linestyle=:dash,  linewidth = 4)
plot!(p3, n_values, [e[3] for e in errors], label="Simpson's Rule",  linewidth = 4)
plot!(p3, n_values, [c1 * (10/n)^1 for n in n_values], label="O(1/n)",  linestyle=:dash,  linewidth = 4)
plot!(p3, n_values, [c2 * (10/n)^2 for n in n_values], label="O(1/n²)", linestyle=:dash, linewidth = 5)
plot!(p3, n_values, [c4 * (10/n)^4 for n in n_values], label="O(1/n⁴)", linestyle=:dash, linewidth = 4)

savefig(p3, joinpath(plot_folder, "error_exp_integration.png"))
