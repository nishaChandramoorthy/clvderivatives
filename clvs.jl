"""
    Compute Lyapunov Exponents and Covariant 
    Lyapunov vectors.
    Reference: Ginelli 2013

"""
function clvs(DTu::Array{Float64,3},du::Int64)
    d = size(DTu)[1]
    m = size(DTu)[3]
    lyap_exps = zeros(du)
    R = zeros(du,du,m)
    Q = zeros(d,du,m)
    Q[:,:,1], R[:,:,1] = qr!(rand(d,du))
    for i=2:m
        Q[:,:,i] = DTu[:,:,i-1]*Q[:,:,i-1]
        Q[:,:,i], R[:,:,i] = qr!(Q[:,:,i])
        lyap_exps .+= log.(abs.(diag(R[:,:,i])))./m
    end
    C = zeros(du,du,m)
    C[:,:,end] = diagm(ones(du))
    for i=reverse(1:m-1)
        C[:,:,i] = R[:,:,i+1]\C[:,:,i+1]
        [normalize!(view(C,:,j,i)) for j = 1:du]
        Q[:,:,i] = Q[:,:,i]*C[:,:,i]
    end
    return lyap_exps, Q
end

