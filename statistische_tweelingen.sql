CREATE TABLE IF NOT EXISTS `persoon` (

  `id` int(11) NOT NULL AUTO_INCREMENT,

  `leeftijd` tinyint(4) DEFAULT NULL,

  `geslacht` enum('Man','Vrouw') DEFAULT 'Man',

  `frequentie` tinyint(4) DEFAULT NULL,

  `omzet` smallint(6) DEFAULT NULL,

  PRIMARY KEY (`id`)

);



INSERT INTO `persoon` (`id`, `leeftijd`, `geslacht`, `frequentie`, `omzet`) VALUES

	(1, 35, 'Vrouw', 12, 234),

	(2, 32, 'Man', 7, 629),

	(3, 29, 'Vrouw', 23, 3619),

	(4, 39, 'Vrouw', 8, 4848),

	(5, 33, 'Vrouw', 22, 4971),

	(6, 71, 'Man', 27, 2510),

	(7, 73, 'Vrouw', 30, 784),

	(8, 67, 'Vrouw', 14, 1981),

	(9, 61, 'Man', 24, 4031),

	(10, 57, 'Vrouw', 8, 1948),

	(11, 43, 'Vrouw', 17, 3827),

	(12, 30, 'Vrouw', 22, 4357),

	(13, 31, 'Vrouw', 12, 4163),

	(14, 25, 'Man', 29, 4401),

	(15, 52, 'Man', 8, 1910),

	(16, 38, 'Vrouw', 9, 484),

	(17, 69, 'Vrouw', 25, 2438),

	(18, 79, 'Man', 17, 544),

	(19, 78, 'Vrouw', 23, 305),

	(20, 22, 'Man', 16, 1677),

	(21, 29, 'Man', 24, 3250),

	(22, 73, 'Vrouw', 4, 2930),

	(23, 66, 'Man', 17, 82),

	(24, 51, 'Vrouw', 27, 1288),

	(25, 58, 'Vrouw', 20, 2596),

	(26, 64, 'Man', 22, 4646),

	(27, 51, 'Vrouw', 6, 3470),

	(28, 24, 'Vrouw', 21, 2539),

	(29, 48, 'Man', 23, 2647),

	(30, 42, 'Vrouw', 12, 449);



with

    cte_persoon_minmax as (

        select  min(leeftijd) as leeftijd_min,

                max(leeftijd) as leeftijd_max,

                min(frequentie) as freq_min,

                max(frequentie) as freq_max,

                min(omzet) as omzet_min,

                max(omzet) as omzet_max

        from    persoon

    ),

    cte_featurescale as (

        select  p.id,

                ( p.leeftijd - mm.leeftijd_min ) / ( mm.leeftijd_max - mm.leeftijd_min ) as fs_leeftijd,

                case when p.geslacht = 'Vrouw' then 1 else 0 end as fs_geslacht,

                ( p.frequentie - mm.freq_min ) / ( mm.freq_max - mm.freq_min ) as fs_frequentie,

                ( p.omzet - mm.omzet_min ) / ( mm.omzet_max - mm.omzet_min ) as fs_omzet

        from    persoon p     

                join cte_persoon_minmax mm on 1=1       

    ),

    cte_random_persoon as (

        select  *

        from    cte_featurescale

        order by rand()    

        limit 1

    )

select  pX.id as PersoonX,

        pRest.id as Tweeling,

        sqrt(

            power(pRest.fs_leeftijd - pX.fs_leeftijd, 2)

          + power(pRest.fs_geslacht - pX.fs_geslacht, 2)

          + power(pRest.fs_frequentie - pX.fs_frequentie, 2)

          + power(pRest.fs_omzet - pX.fs_omzet, 2)

        ) as afstand          

from    cte_random_persoon pX

        join cte_featurescale pRest on pRest.id != pX.id  

order by afstand asc

limit 1                  

        
