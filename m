Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053CBCCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C54A8E0097; Thu,  9 Oct 2025 21:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EE68E0002; Thu,  9 Oct 2025 21:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8C08E0097; Thu,  9 Oct 2025 21:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE37E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:38:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2065140157
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:38:35 +0000 (UTC)
X-FDA: 83980494990.04.FFC7464
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id AA04B80007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:38:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eFmg6ymR;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760060313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7zAA0p8zckCeyLDOP5ldjDoB9sBI74eJ+YE6QJ9N5aI=;
	b=JwXsff9Pkm6VYi1ltWejYAqbqfngYXyGZfnnpmbQXiv/eaEanvdtQYnoX5h3CyVRwW6WTX
	N1YPnD9bqnxj/O0FIMPYdfBWwEypBFpUjG9nrjWbMKCvfWEqwel3st33XVOPNMKyoPn7ur
	v/w8yv+53Vz/TOzsQpZ6Dz1jDb/PPV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eFmg6ymR;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760060313; a=rsa-sha256;
	cv=none;
	b=u+Z3+76ihw/WY3f0ZkEIZzXiU0VR1gLK/atSHBkc6i03vlfEtiAyUM1RZ5+IdLv612aX4E
	Q5aomjQN8wnc36BJmIOZu6k0Egpa8AFQsYld5nJIN4ZmS/2HtQ4oZQswe6H9oXKFLLXLP9
	TN+WkO1xWPpEktlJYgQXMFuJLo9i1hw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760060312; x=1791596312;
  h=date:from:to:cc:subject:message-id;
  bh=OkTF/TlGwF1RFma5nH5rZtlvIAUpiohU0bq96gWm9b0=;
  b=eFmg6ymRgYz8KFEQq6B6nxW0qpa2GtjOTowiUXZV8WlJDyJhr5r37FC9
   qGW7UTPgOnRNwzmjOtk+NkjiazpRh37Qf72XphlaZKXqZH+zjVnpV3Fps
   Z1+wRMc5Tu2LZEgAsfS0lcWVQZ9X9Mnjhh4MwP7l2upEL/y1tkFCZAT+Y
   8Me3ck5PqpE7L/oCYuR8lTa9KR3ZCtoLtsAw+/cu2iBvWdQFjM2H9oT5p
   jqr4NMfAQA0Y+S6W2VH/bnH3Lq0gDwf8wjb4wTVLONdfJn6kEd4vNXn1B
   V8WAhz8em7Yw825IGwtPRBy12JSym8pOcF25xfkwZSCrl+9+dZeL8KJpK
   g==;
X-CSE-ConnectionGUID: dDXJ2BCJThSgqr7uWdL03A==
X-CSE-MsgGUID: LhtCvHYJRmKuEy8R9ZiO8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="61985372"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="61985372"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:38:31 -0700
X-CSE-ConnectionGUID: /Wn+OK+iSSyDOH0eZyI6bw==
X-CSE-MsgGUID: FPl77W5UQ0+cqTh4I5UyEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="204565914"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Oct 2025 18:38:29 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v725S-0001oV-1P;
	Fri, 10 Oct 2025 01:38:26 +0000
Date: Fri, 10 Oct 2025 09:38:04 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 0b2f041c47acb45db82b4e847af6e17eb66cd32d
Message-ID: <202510100909.AUAs0RDj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA04B80007
X-Stat-Signature: xnfaobimnmw67juet6sof66rrohnnr6q
X-Rspam-User: 
X-HE-Tag: 1760060312-165393
X-HE-Meta: U2FsdGVkX18dJhQpMUtmu9wwgT751R4SwXcSO6TJezEe/RnWttN6L1wIroUmM64pw/VvZ00ax9/2q1PLgH0Qt1PWjPlNSq3052MQzAJCNP3Ri2TsBW0FrtDuzxL6JXljqQPBP0cAQU+uOL6ovmmjgeoMZGVZ6Wbknm3jRKY1b+tiWPwzrRgtryji32YaDvjPrrtA1SaOdqwqHbgKhGqa7eeRsNOZwkLr60MAJ2vCmyc9amlSBCN1Qeqk/1BJ264GkBLrAE9Wg2NERCvlU0zfC9lTxAryPCmYuqbEbtAEjb4USzi9BRvgwQcvQutPmDFEYYZycN9ObVkIp4aoUXQJEnPGE9Hz3g+e/5AUgUTkNoR4icQr0HeKeoqeUyp5y9NYcoq61RC7uZiCWaPBdBEUxlXlBTLs+TTOHUBOqreID36K1wxjVJuUHNAYlHnVJLX4wm7gPKr+c1+3RFDHYFy9fwR+OfqQPtlIOxv5DF54d0RLFDQ8q1Rie1Dn8WCIbgOSyXbVH7g9SEowOqSf4VumEwswiXFzcqym6W3gOguvD/J9iqQwaaWGLjKQEuwfWw2g//nDC7prrOlJYYE7V3FcfulGZt92u9dvzFKzPXROkDIaC6j4YydJpdN3wLhAhlFJwRDGLrd7tdfjJvq19foGiUHHS+m1mrOeshO4HbeK+zIgsKMB3dURcu++e+J9VDAeFk2RikPzEH/zM6EboA+pxi2y1Dl0B87ejGw55pKwRxwXJEGjM8Bzx7KNfkzxfj+XOOEV+NUJl3We1m/u5jOzB1117MtuVJGX08rjIgHnt32/OhFUluSNtsdHXy7RDPLQx05lVuiOzBIWOwMibTzdsveWbYh60ekcjFZZSRvRiWOkoXLiCcS6SqMWnE1eLohhoG91gqZJl3J754048IMARZk2ng7Ky6p+b3eyVb4ZjluCsCFbH7XGDYx7G+BH3kEkeAYtPBebD+Dcj+f2mBF
 cyTuEvAX
 wm3H7tADhyY2fnJ7bxPQCrvQIZHNs+x3J7crrHXIzCfeEhACwbFyxikafwjByYX1uCcYOL0eMK/JnAVZiB7M/gaOn0ObqW47ALGLUL8kTCVxV42YgLiGqgW4OKLIWGbNrIaOE9sx6h8zpvyUPdazHj4GrPkTt0SVYqPRQ10dkAAnUK5SB4oHLe4p9mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 0b2f041c47acb45db82b4e847af6e17eb66cd32d  Add linux-next specific files for 20251009

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509231815.d1EjWp8Y-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509251326.SYA3QL9j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509252250.uv5q12aK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510031615.GardRYTk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510032336.PjyL10gR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510040140.njOfkDkC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510040434.KzlnjhdR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510092253.kjfjscfD-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509112313.0XfkfKPl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509250925.4L4JQTtn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510100324.hSCnBCWb-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    ERROR: modpost: "__ffsdi2" [drivers/spi/spi-amlogic-spifc-a4.ko] undefined!
    arch/arm/boot/dts/aspeed/aspeed-bmc-ibm-balcones.dtb: pressure-sensor@76 (infineon,dps310): '#io-channel-cells' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-aster.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-eval-v3.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris-v2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval-v1.2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.1.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-2 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c2mux@1', 'i2c2mux@2' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-3 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c3mux@1' was unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): 'blocks', 'id', 'irq-gpio', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): touchscreen: Unevaluated properties are not allowed ('st,adc-freq', 'st,mod-12b', 'st,ref-sel', 'st,sample-time' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6qp-nitrogen6_max.dtb: i2c-mux-2 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c2mux@1', 'i2c2mux@2' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6qp-nitrogen6_max.dtb: i2c-mux-3 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c3mux@1' was unexpected)
    arch/arm/boot/dts/nxp/imx/imx7d-nitrogen7.dtb: touchscreen@48 (ti,tsc2004): 'wakeup-gpios' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx7ulp-com.dtb: clock-controller@40410000 (fsl,imx7ulp-smc1): '#clock-cells' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx7ulp-evk.dtb: clock-controller@40410000 (fsl,imx7ulp-smc1): '#clock-cells' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-tian-g07017.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-tian-g07017.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana-rev7.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8183-evb.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel-sku1.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel-sku6.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel-sku7.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel14-sku2.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel14.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-juniper-sku16.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kappa.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-makomo-sku0.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-makomo-sku1.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow-sku0.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow-sku1.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu-sku22.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-katsu-sku32.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-katsu-sku38.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama-sku16.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama-sku272.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama-sku288.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama-sku32.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-krane-sku0.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-kukui-krane-sku176.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dtb: audio-controller@11220000 (mediatek,mt8183-audiosys): 'mt8183-afe-pcm' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/xilinx/avnet-ultra96-rev1.dtb: spi@ff040000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/versal-net-vn-x-b2197-01-revA.dtb: spi@f1970000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kd-g-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kd-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kd-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kr-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kv-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k24-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kv-g-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kv-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kv-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kd-g-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kd-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kd-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kr-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kv-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k24-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kr-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kv-g-revA.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA-sck-kv-g-revB.dtb: spi@ff050000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zc1232-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm015-dc1.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dtb: spi@ff040000 (cdns,spi-r1p6): Unevaluated properties are not allowed ('compatible' was unexpected)
    arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm017-dc3.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm018-dc4.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revC.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dtb: spi@ff040000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/xilinx/zynqmp-zcu1275-revA.dtb: spi@ff050000 (cdns,spi-r1p6): compatible: 'oneOf' conditional failed, one must be fixed:
    fs/smb/client/smb2ops.c:3128:3: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
    fs/smb/client/smb2ops.c:3213:3: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
    fs/smb/client/smb2ops.c:3214:3: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    fs/btrfs/extent_io.c:401 find_lock_delalloc_range() error: we previously assumed 'fs_info' could be null (see line 378)
    fs/smb/client/smb2ops.c:3128 get_smb2_acl_by_path() error: uninitialized symbol 'rc'.
    kernel/power/energy_model.c:649 em_dev_register_pd_no_update() error: we previously assumed 'dev->em_pd' could be null (see line 594)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-randconfig-r123-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- ERROR:__ffsdi2-drivers-spi-spi-amlogic-spifc-a4.ko-undefined
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arm-linux-gnueabi-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-mv78xx0_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-qcom_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-004-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-051-20251009
|   |-- arch-arm-boot-dts-aspeed-aspeed-bmc-ibm-balcones.dtb:pressure-sensor-(infineon-dps310):io-channel-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-052-20251009
|   |-- arch-arm-boot-dts-aspeed-aspeed-bmc-ibm-balcones.dtb:pressure-sensor-(infineon-dps310):io-channel-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-053-20251009
|   |-- arch-arm-boot-dts-aspeed-aspeed-bmc-ibm-balcones.dtb:pressure-sensor-(infineon-dps310):io-channel-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-054-20251009
|   |-- arch-arm-boot-dts-aspeed-aspeed-bmc-ibm-balcones.dtb:pressure-sensor-(infineon-dps310):io-channel-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-055-20251009
|   |-- arch-arm-boot-dts-aspeed-aspeed-bmc-ibm-balcones.dtb:pressure-sensor-(infineon-dps310):io-channel-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm64-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20251009
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-mediatek-mt8183-evb.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-burnet.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-cozmo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-damu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku7.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14-sku2.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-juniper-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kappa.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kenzo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu-sku22.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku38.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku272.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku288.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku176.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-pumpkin.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-xilinx-avnet-ultra96-rev1.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-versal-net-vn-x-b2197-revA.dtb:spi-f1970000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1232-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm015-dc1.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm016-dc2.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm017-dc3.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm018-dc4.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu1275-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-052-20251009
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-mediatek-mt8183-evb.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-burnet.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-cozmo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-damu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku7.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14-sku2.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-juniper-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kappa.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kenzo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu-sku22.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku38.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku272.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku288.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku176.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-pumpkin.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-xilinx-avnet-ultra96-rev1.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-versal-net-vn-x-b2197-revA.dtb:spi-f1970000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1232-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm015-dc1.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm016-dc2.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm017-dc3.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm018-dc4.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu1275-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-053-20251009
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-mediatek-mt8183-evb.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-burnet.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-cozmo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-damu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku7.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14-sku2.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-juniper-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kappa.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kenzo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu-sku22.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku38.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku272.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku288.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku176.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-pumpkin.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-xilinx-avnet-ultra96-rev1.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-versal-net-vn-x-b2197-revA.dtb:spi-f1970000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1232-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm015-dc1.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm016-dc2.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm017-dc3.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm018-dc4.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu1275-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-054-20251009
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-mediatek-mt8183-evb.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-burnet.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-cozmo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-damu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku7.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14-sku2.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-juniper-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kappa.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kenzo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu-sku22.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku38.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku272.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku288.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku176.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-pumpkin.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-xilinx-avnet-ultra96-rev1.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-versal-net-vn-x-b2197-revA.dtb:spi-f1970000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1232-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm015-dc1.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm016-dc2.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm017-dc3.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm018-dc4.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu1275-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- arm64-randconfig-055-20251009
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-mediatek-mt8183-evb.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-burnet.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-cozmo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-damu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel-sku7.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14-sku2.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-fennel14.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-juniper-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kappa.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-kenzo.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-makomo-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-pico6.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-jacuzzi-willow-sku1.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu-sku22.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kakadu.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-katsu-sku38.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku16.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku272.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku288.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-kodama-sku32.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku0.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-kukui-krane-sku176.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-mediatek-mt8183-pumpkin.dtb:audio-controller-(mediatek-mt8183-audiosys):mt8183-afe-pcm-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-xilinx-avnet-ultra96-rev1.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-versal-net-vn-x-b2197-revA.dtb:spi-f1970000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kd-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k24-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kr-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-smk-k26-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1232-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm015-dc1.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm016-dc2.dtb:spi-ff040000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm017-dc3.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zc1751-xm018-dc4.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu100-revC.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu104-revC.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu1275-revA.dtb:spi-ff050000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20251009
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- hexagon-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-r131-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-002-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-buildonly-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-004-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-005-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-006-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-005-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-006-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-011-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-014-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-016-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-017-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- i386-randconfig-141-20251009
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- fs-smb-client-smb2ops.c-get_smb2_acl_by_path()-error:uninitialized-symbol-rc-.
|   |-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|   `-- kernel-power-energy_model.c-em_dev_register_pd_no_update()-error:we-previously-assumed-dev-em_pd-could-be-null-(see-line-)
|-- i386-randconfig-r072-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- loongarch-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- loongarch-defconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- loongarch-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-m5249evb_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-randconfig-r132-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- powerpc-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-001-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- powerpc64-randconfig-002-20251009
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- powerpc64-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-r113-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-r121-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-defconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- s390-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-zfcpdump_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-r111-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-alldefconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-r133-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20251009
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- um-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-buildonly-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-003-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-004-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-005-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-006-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-kexec
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-001-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-005-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-006-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-007-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-008-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-071-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-073-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-075-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-076-20251010
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-randconfig-161-20251009
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- fs-btrfs-extent_io.c-find_lock_delalloc_range()-error:we-previously-assumed-fs_info-could-be-null-(see-line-)
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- x86_64-rhel-9.4-rust
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- fs-smb-client-smb2ops.c:warning:variable-rc-is-uninitialized-when-used-here
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-001-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-002-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-randconfig-r112-20251009
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
`-- xtensa-virt_defconfig
    `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files

elapsed time: 802m

configs tested: 281
configs skipped: 6

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    clang-19
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    clang-19
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251009    gcc-11.5.0
arc                   randconfig-001-20251010    gcc-8.5.0
arc                   randconfig-002-20251009    gcc-14.3.0
arc                   randconfig-002-20251010    gcc-8.5.0
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                         bcm2835_defconfig    gcc-15.1.0
arm                                 defconfig    clang-19
arm                                 defconfig    clang-22
arm                      integrator_defconfig    gcc-15.1.0
arm                         mv78xx0_defconfig    clang-19
arm                            qcom_defconfig    clang-22
arm                   randconfig-001-20251009    gcc-10.5.0
arm                   randconfig-001-20251010    gcc-8.5.0
arm                   randconfig-002-20251009    gcc-11.5.0
arm                   randconfig-002-20251010    gcc-8.5.0
arm                   randconfig-003-20251009    gcc-11.5.0
arm                   randconfig-003-20251010    gcc-8.5.0
arm                   randconfig-004-20251009    gcc-12.5.0
arm                   randconfig-004-20251010    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251009    gcc-8.5.0
arm64                 randconfig-001-20251010    gcc-8.5.0
arm64                 randconfig-002-20251009    gcc-14.3.0
arm64                 randconfig-002-20251010    gcc-8.5.0
arm64                 randconfig-003-20251009    gcc-9.5.0
arm64                 randconfig-003-20251010    gcc-8.5.0
arm64                 randconfig-004-20251009    gcc-8.5.0
arm64                 randconfig-004-20251010    gcc-8.5.0
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251009    gcc-13.4.0
csky                  randconfig-001-20251010    gcc-14.3.0
csky                  randconfig-002-20251009    gcc-15.1.0
csky                  randconfig-002-20251010    gcc-14.3.0
hexagon                          alldefconfig    clang-22
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251009    clang-16
hexagon               randconfig-001-20251010    gcc-14.3.0
hexagon               randconfig-002-20251009    clang-19
hexagon               randconfig-002-20251010    gcc-14.3.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251009    clang-20
i386        buildonly-randconfig-001-20251010    gcc-14
i386        buildonly-randconfig-002-20251009    gcc-14
i386        buildonly-randconfig-002-20251010    clang-20
i386        buildonly-randconfig-002-20251010    gcc-14
i386        buildonly-randconfig-003-20251009    gcc-14
i386        buildonly-randconfig-003-20251010    clang-20
i386        buildonly-randconfig-003-20251010    gcc-14
i386        buildonly-randconfig-004-20251009    gcc-14
i386        buildonly-randconfig-004-20251010    gcc-14
i386        buildonly-randconfig-005-20251009    clang-20
i386        buildonly-randconfig-005-20251010    gcc-14
i386        buildonly-randconfig-006-20251009    gcc-14
i386        buildonly-randconfig-006-20251010    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251010    clang-20
i386                  randconfig-002-20251010    clang-20
i386                  randconfig-003-20251010    clang-20
i386                  randconfig-004-20251010    clang-20
i386                  randconfig-005-20251010    clang-20
i386                  randconfig-006-20251010    clang-20
i386                  randconfig-007-20251010    clang-20
i386                  randconfig-011-20251010    gcc-14
i386                  randconfig-012-20251010    gcc-14
i386                  randconfig-013-20251010    gcc-14
i386                  randconfig-014-20251010    gcc-14
i386                  randconfig-015-20251010    gcc-14
i386                  randconfig-016-20251010    gcc-14
i386                  randconfig-017-20251010    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251009    gcc-15.1.0
loongarch             randconfig-001-20251010    gcc-14.3.0
loongarch             randconfig-002-20251009    gcc-15.1.0
loongarch             randconfig-002-20251010    gcc-14.3.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
m68k                       m5249evb_defconfig    gcc-15.1.0
m68k                          sun3x_defconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                          eyeq5_defconfig    clang-22
mips                           gcw0_defconfig    gcc-15.1.0
mips                           ip22_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20251009    gcc-8.5.0
nios2                 randconfig-001-20251010    gcc-14.3.0
nios2                 randconfig-002-20251009    gcc-11.5.0
nios2                 randconfig-002-20251010    gcc-14.3.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-14
openrisc                            defconfig    gcc-15.1.0
openrisc                  or1klitex_defconfig    clang-22
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251009    gcc-8.5.0
parisc                randconfig-001-20251010    gcc-14.3.0
parisc                randconfig-002-20251009    gcc-9.5.0
parisc                randconfig-002-20251010    gcc-14.3.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                      mgcoge_defconfig    clang-22
powerpc                      pasemi_defconfig    clang-22
powerpc               randconfig-001-20251009    gcc-8.5.0
powerpc               randconfig-001-20251010    gcc-14.3.0
powerpc               randconfig-002-20251009    gcc-11.5.0
powerpc               randconfig-002-20251010    gcc-14.3.0
powerpc               randconfig-003-20251009    gcc-8.5.0
powerpc               randconfig-003-20251010    gcc-14.3.0
powerpc64             randconfig-001-20251010    gcc-14.3.0
powerpc64             randconfig-002-20251009    clang-22
powerpc64             randconfig-002-20251010    gcc-14.3.0
powerpc64             randconfig-003-20251009    clang-22
powerpc64             randconfig-003-20251010    gcc-14.3.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                    nommu_k210_defconfig    gcc-15.1.0
riscv                 randconfig-001-20251009    gcc-8.5.0
riscv                 randconfig-001-20251010    gcc-9.5.0
riscv                 randconfig-002-20251009    clang-19
riscv                 randconfig-002-20251010    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20251009    clang-22
s390                  randconfig-001-20251010    gcc-9.5.0
s390                  randconfig-002-20251009    clang-22
s390                  randconfig-002-20251010    gcc-9.5.0
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251009    gcc-15.1.0
sh                    randconfig-001-20251010    gcc-9.5.0
sh                    randconfig-002-20251009    gcc-12.5.0
sh                    randconfig-002-20251010    gcc-9.5.0
sh                           se7721_defconfig    clang-22
sh                            shmin_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251009    gcc-8.5.0
sparc                 randconfig-001-20251010    gcc-9.5.0
sparc                 randconfig-002-20251009    gcc-8.5.0
sparc                 randconfig-002-20251010    gcc-9.5.0
sparc64                          alldefconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251009    clang-22
sparc64               randconfig-001-20251010    gcc-9.5.0
sparc64               randconfig-002-20251009    clang-22
sparc64               randconfig-002-20251010    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251009    clang-17
um                    randconfig-001-20251010    gcc-9.5.0
um                    randconfig-002-20251009    gcc-14
um                    randconfig-002-20251010    gcc-9.5.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
um                           x86_64_defconfig    gcc-15.1.0
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251009    clang-20
x86_64      buildonly-randconfig-001-20251010    clang-20
x86_64      buildonly-randconfig-001-20251010    gcc-14
x86_64      buildonly-randconfig-002-20251009    clang-20
x86_64      buildonly-randconfig-002-20251010    clang-20
x86_64      buildonly-randconfig-002-20251010    gcc-14
x86_64      buildonly-randconfig-003-20251009    clang-20
x86_64      buildonly-randconfig-003-20251010    clang-20
x86_64      buildonly-randconfig-003-20251010    gcc-14
x86_64      buildonly-randconfig-004-20251009    clang-20
x86_64      buildonly-randconfig-004-20251010    clang-20
x86_64      buildonly-randconfig-004-20251010    gcc-14
x86_64      buildonly-randconfig-005-20251009    clang-20
x86_64      buildonly-randconfig-005-20251010    gcc-14
x86_64      buildonly-randconfig-006-20251009    gcc-14
x86_64      buildonly-randconfig-006-20251010    gcc-14
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251010    clang-20
x86_64                randconfig-002-20251010    clang-20
x86_64                randconfig-003-20251010    clang-20
x86_64                randconfig-004-20251010    clang-20
x86_64                randconfig-005-20251010    clang-20
x86_64                randconfig-006-20251010    clang-20
x86_64                randconfig-007-20251010    clang-20
x86_64                randconfig-008-20251010    clang-20
x86_64                randconfig-071-20251010    clang-20
x86_64                randconfig-072-20251010    clang-20
x86_64                randconfig-073-20251010    clang-20
x86_64                randconfig-074-20251010    clang-20
x86_64                randconfig-075-20251010    clang-20
x86_64                randconfig-076-20251010    clang-20
x86_64                randconfig-077-20251010    clang-20
x86_64                randconfig-078-20251010    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                generic_kc705_defconfig    gcc-15.1.0
xtensa                randconfig-001-20251009    gcc-11.5.0
xtensa                randconfig-001-20251010    gcc-9.5.0
xtensa                randconfig-002-20251009    gcc-8.5.0
xtensa                randconfig-002-20251010    gcc-9.5.0
xtensa                         virt_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

