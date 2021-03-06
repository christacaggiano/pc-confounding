rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( '../code/ice_fxn_new.R' )
source( 'simfxn.R' )
source( '../fig3/mainfxn.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
fac <- 'ice'
for( type in sample( types ) )
	for( meta in 1:2 )
		for( dat_type in dat_types[1] )
			for( r.i in 1:r.n )
{

	savefile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_',dat_type, '_',r.i, '_', it, '.Rdata' )
	if( file.exists( savefile ) ) next
	sink(					paste0( 'Rout/'	, fac, '_', meta, '_', type, '_',dat_type, '_',r.i, '_', it, '.Rout' ) )
	tryCatch({

		simdat	<- sim_fxn( seed=it, sig2_x=sig2_xs[type], sig2_u=sig2_us[type], rho=sqrt(rho2s[r.i]), f=fs[type], dat_type=dat_type )

		caus_p	<- simdat$caus
		Y				<- simdat$Y
		g				<- simdat$g
		rm( simdat )

		time	<- system.time({
			out	<- ice_summ_fxn( Y, g, ML=(meta==1) )
		})[3]
		cat( 'maintime=', time, '\n' )

		save( out, caus_p, file=savefile )

		rm( Y, g, x, time, caus_p, out )

	}, error=function(e){ print( e ); print( c( type, meta, fac ) ) })
	sink()
}
