!Allocate variables related to the snow module

    idummy = 0 !for summing up IO-error flags

    allocate(snowEnergyCont(366,nt,ntcinst), &
             snowWaterEquiv(366,nt,ntcinst), &
             snowAlbedo    (366,nt,ntcinst), &
             snowCover     (366,nt,ntcinst), &
             precipMod     (366,nt,ntcinst), &
             precipBal     (366,nt,ntcinst), &
             STAT = istate)
    idummy = istate + idummy

    !Initial values states
    snowEnergyCont(:,:,:)     =     0.
    snowWaterEquiv(:,:,:)     =     0.
    snowAlbedo(:,:,:)         =     albedoMax

    allocate(rel_elevation(nterrain), STAT = istate)
    idummy = istate + idummy

    !if (f_precipMod) then
    !allocate(precipMod(366,nt,ntcinst), STAT = istate)
    !end if
    !idummy = istate + idummy

    if (f_cloudFrac) then
    allocate(cloudFrac(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_snowTemp) then
    allocate(snowTemp(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_surfTemp) then
    allocate(surfTemp(366,nt,ntcinst), STAT = istate)
    end if    
    idummy = istate + idummy

    if (f_liquFrac) then
    allocate(liquFrac(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_fluxPrec) then 
    allocate(fluxPrec(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

   
    if (f_fluxSubl) then 
    allocate(fluxSubl(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    
    if (f_fluxFlow) then 
    allocate(fluxFlow(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy
    
    if (f_fluxNetS) then 
    allocate(fluxNetS(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    
    if (f_fluxNetL) then 
    allocate(fluxNetL(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_fluxSoil) then
    allocate(fluxSoil(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

 
    if (f_fluxSens) then 
    allocate(fluxSens(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    
    if (f_stoiPrec) then
    allocate(stoiPrec(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy
    
    if (f_stoiSubl) then
    allocate(stoiSubl(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_stoiFlow) then
    allocate(stoiFlow(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (f_rateAlbe) then
    allocate(rateAlbe(366,nt,ntcinst), STAT = istate)
    end if
    idummy = istate + idummy

    if (idummy/=0) then
        write(*,'(A,i0,i0,a)')'Memory allocation error (',istate,'/',idummy,') in hymo-module (snow): '
        stop
    end if



    !Computation relative elevation of TC centre above foot of toposequence/LU (i.e. river) [m]

    DO i_lu=1,nsoter
        temp2 = 0. !cumulative elevation of downslope TCs

       DO tc_counter=1,nbrterrain(i_lu)
           !Relative elevation of center TC
           !Note: slope(tc_counter) in %
           rel_elevation(id_terrain_intern(tc_counter,i_lu)) = temp2 + slength(i_lu)*fracterrain(tc_counter)*slope(tc_counter)/100/2

           temp2 = temp2 + slength(i_lu)*fracterrain(tc_counter)*slope(tc_counter)/100 !cumulate y-extent TCs

           !rel_elevation(id_terrain_intern(tc_counter,i_lu)) = fracterrain(tc_counter)*slope(tc_counter)*slope(tc_counter)/2 + &   !centre of TC plus ...
           !                                                 temp2  ! cumulative downslope elevation
           !temp1 = temp1 + slength(i_lu)*fracterrain(tc_counter)  ! cumulate downslope x-extent
           !temp2 = temp2 + slength(i_lu)*fracterrain(tc_counter)*slope(tc_counter) ! cumulate downslope y-extent
       END DO

       DO tc_counter=1,nbrterrain(i_lu)

           rel_elevation(id_terrain_intern(tc_counter,i_lu)) = rel_elevation(id_terrain_intern(tc_counter,i_lu)) - (temp2 / 2.) !"normalize" to middle elevation of the LU

       END DO

    END DO
       
