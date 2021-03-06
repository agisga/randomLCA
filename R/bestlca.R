`bestlca` <-
function(patterns,freq,nclass,calcSE,notrials,probit,penalty,EMtol,verbose) {
	bics <- rep(NA,notrials)
	for (i in 1:notrials) {
		lca <- fitFixed(patterns,freq,nclass=nclass,calcSE=FALSE,justEM=TRUE,probit=probit,penalty=penalty,EMtol=EMtol,verbose=verbose)
		currbic <- -2*(lca$logLik)+log(lca$nobs)*lca$np
		bics[i] <- currbic
		#browser()
		if (i==1) {
			maxbic <- currbic
			maxlca <- lca
		}
		#print(c(currbic,maxbic))
		if (currbic < maxbic) {
			maxbic <- currbic
			maxlca <- lca
		}
		if (verbose)
			cat("iteration ",i,"BIC ",BIC(lca),"\n")
	}
	if (verbose) print("refitting to obtain SE")
	#browser()
		maxlca <- fitFixed(patterns,freq,nclass=nclass,initoutcomep=maxlca$outcomep,
			initclassp=maxlca$classp,calcSE=calcSE,justEM=FALSE,probit=probit,penalty=penalty,EMtol=EMtol,verbose=verbose)
	if (verbose) {
		print("bic for class")
		print(bics)
	}
	return(c(maxlca,list(bics=bics)))
}

