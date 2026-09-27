Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB80DC98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 08:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FC06B0088; Sun, 27 Sep 2026 04:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C106F6B008A; Sun, 27 Sep 2026 04:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEE96B008C; Sun, 27 Sep 2026 04:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84DBE6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:01:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 042BC1209EC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:01:51 +0000 (UTC)
X-FDA: 85258798464.27.E02AE07
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9089100003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:01:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cutH5A+1;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790496110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WZGFZjN4NOcJmxvJXf1GI5OWSTEgMM9GPeduOnIU4q4=;
	b=eJ5TsjweC9yNqnTVyU1tGdv7M3IYFw4gsfm7/U9RblVnWE/A+sb7gwgP3gLJH16Gv+L7C6
	3FthKzySs9NlCbMhjEKhAX22Qcx8igYp+kfqBBLG7KD4HrfsCyfaI6lLul77cFhg/dUmgM
	aOHcShD1+Catq0+EjM+Rrffdt3+3nSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790496110;
	b=x5aX4ASpQnAFnbiGNk2+pL7tz2qhi0mqHSIlQkFkc/ktQBPyV+zfAxcAkO10uxkFLKYTTJ
	lZpXwD0JVD7Heb9WEWyhhyUraLe5Q843wq/O4TJ8m8Nog4Y3h94EoKq70tNqX7Qgp4iUNN
	WO9i7HUSIoVJ5UQzsaFJy+7QgOFXVDw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cutH5A+1;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790496109; x=1822032109;
  h=date:from:to:cc:subject:message-id;
  bh=UNJ+u4Slgr+C0wipUwq+JRskcFcdD6giC8gvqFp7rSk=;
  b=cutH5A+1CKJnQJcQulr1rd5uD45dlTVJ3mt9OzMBto5wvZJdGanbsIBl
   j09JgqGXfyHZVG+VO6ax3xPyPd8/MBIhX+8Qd1Tr1qd7FizqIJt/4wUiJ
   UMct+d+APmGGj+axSCeAoOTNmIJic5FrM2b726KWqYOOB2v7jDC5VxN46
   hWLSU5x4aQGKWG5TQ9D5m2SYY7J/BNeMO0DEi46doz4W6TC2VgxX7PO7R
   ncVvPUDLs5ypjzv/CcLkrQv/KvkHcdy0ZqtHILvI3VW/BCA5CJgjnBxIc
   lt2FOil6XmUOCv2Y5wr3o+inELOSNn9Ps4IBa/3Ge1SgqiDV8JfpvNzVn
   Q==;
X-CSE-ConnectionGUID: 3EQwk30xRbGpw3rfjplxcw==
X-CSE-MsgGUID: 3oqOQEK9TeqfZqTl/spx7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100555946"
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="100555946"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 01:01:48 -0700
X-CSE-ConnectionGUID: TbNF1dQgRISK6qlgIG4okg==
X-CSE-MsgGUID: 6IEAHAwlSKSvkGCKVxcbnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="273358814"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 27 Sep 2026 01:01:46 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAjpP-00000000MgM-2YEC;
	Sun, 27 Sep 2026 08:01:43 +0000
Date: Sun, 27 Sep 2026 16:01:26 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 f5f84daefcd92d7a630066635ecea1433ed5eac7
Message-ID: <202609271623.zM7VOGFV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9089100003
X-Stat-Signature: 8r9z9x3p9wwgxbxhnoujfwzkc89f693e
X-Rspam-User: 
X-HE-Tag: 1790496108-727565
X-HE-Meta: U2FsdGVkX1/3/cQFDS6L7K/UmKayu00EazG6n/sFX6bIu3PBgtlASHG5gKZW4gLTi9q7z1MUNA16BSNMsUhwcZ0I9GAviFXZq0wTjTkG1yRTywIqybU5ATEDQTz8urYzqU4/AVKjLYEzMaBpAk/IToDEOe6bQ4hm8DtE7vZ2nmc3CDXdnWfkGT8mmYNv+ClVoXrx9Zp+fJYq3KZkH470MRCtQxPgR1ExXEYsLs86IlR6ilbWELO6S2fw3CduS0OSXd+4ISxWyR4j994wGluRFQG2Ntoxm++bNoN9bUtCz3mIzIo+P3FiBX1LzdRVB0v/g2ImI0O7cpzhwkOc0Aus8rGJde4+JUEYVkY5gjVGkiYAlxtJWCMl0N5lett7Um9icV/otnsSjouccFeHt9M9oeDR51bX+D2YoyWlJ0auTVqawmcRKbOXP50PCBVaEL9apY9/BSAOdXXJT1mOVPnm5Gdi/EvwloTty2AznXlGSbsRPv33m/eklR64gWJSG7hjtMIU6ZgNyzPlUrt5skm/Cc7Mpxt04lHnCCLsWD6GJnYdWtwjxMRu1oW2Z1m9o0qPj3M46JMdgYLc3l0sysyYhQQKfgGXZMTZO5PtT4/7LBQm2a+WURJoqI2h2KWz7TQQx7P9HlanIWFgAlD7bUXhneSuFPeSHsp+DIZaqqYUQRoPQYwGyG66V/aXv4KNbCV4XEK1IIGKfJ2cWYjPF4cmjT8sotSVBPOb1VIjw8tGnonniBOgeCpG2YnbhtRy0CF7a7W9KT19N5LG2pZAHOfR6ufChSDuhB7lrdKYlHoU88D71pbomEjZGWg3xh+Afd5scwhimT3viBcx0RaEjY2Fu7N/eZdnOzcAIy80NUoTwJpQZfsRNxcM5nTuFjrWuQRdj2vP2uA9Hs2SWDgfE44r5Z4NOR437dFJ+c1wJKyVJuH96HFZVc+avqv0e3ocxAdyEj0Bu4OMkCUeUP2e84Q
 YlwfqQVz
 c8ebieG8Ku0gqMSfLuyCCXSHDUHCyHVjiGFQF6e2apx9Dvn6oT+a+Xy8wYPl+HFMkUnWlN3n9S6tKjzZayey3s1Bs2k04HigRL7OdEYaabOnP4LI5EGRd9jWiqgUKVqBgA5tf42GKSEUt/dMGtHuyM3gydt9m+xQH6eAryzIR0lrByGkk9Q8ERDvIUiDnYePKm53IXRP2Umz0xeCBvB167BKWBy8UEIII0bHp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f5f84daefcd92d7a630066635ecea1433ed5eac7  Add linux-next specific files for 20260925

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609252250.0O55BOZO-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609252351.5UfBIiOJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609260658.uBR4QZNk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609260721.RtG4LmP9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609261010.qYWQPhqM-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609261818.gGqBcNSM-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609270240.3jTO1ZSC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609271037.xasAFkVC-lkp@intel.com

    /usr/bin/ld:./arch/um/kernel/vmlinux.lds:161: syntax error
    Warning: drivers/remoteproc/da8xx_remoteproc.c:82 function parameter 'irq' not described in 'handle_event'
    Warning: drivers/remoteproc/da8xx_remoteproc.c:82 function parameter 'p' not described in 'handle_event'
    arch/arm64/boot/dts/freescale/imx8mm-data-modul-edm-sbc-overlay-cm4.dtb: vdev0buffer@b8400000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc-overlay-cm7.dtb: vdev0buffer@55400000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/freescale/imx952-frdm.dtb: linux,cma (shared-dma-pool): Unevaluated properties are not allowed ('alloc-ranges', 'reusable', 'size' were unexpected)
    arch/arm64/boot/dts/qcom/sm8650-valve-deckard.dtb: aop-cmd-db-region@81c60000 (qcom,cmd-db): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/qcom/sm8650-valve-deckard.dtb: lpm-region@6000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/qcom/sm8650-valve-deckard.dtb: lpm-region@6c80000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/qcom/sm8650-valve-deckard.dtb: lpm-region@6d40000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/qcom/sm8650-valve-deckard.dtb: lpm-region@7c10000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk-cn20-lcdc.dtb: adc@90014000 (renesas,r9a09g087-adc): interrupt-names: ['adi', 'gbadi', 'gcadi', 'cmpai', 'cmpbi'] is too short
    arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk-cn20-lcdc.dtb: adc@90014000 (renesas,r9a09g087-adc): interrupts: [[0, 698, 1], [0, 699, 1], [0, 700, 1], [0, 701, 4], [0, 702, 4]] is too short
    arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dtb: adc@90014000 (renesas,r9a09g087-adc): interrupt-names: ['adi', 'gbadi', 'gcadi', 'cmpai', 'cmpbi'] is too short
    arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dtb: adc@90014000 (renesas,r9a09g087-adc): interrupts: [[0, 698, 1], [0, 699, 1], [0, 700, 1], [0, 701, 4], [0, 702, 4]] is too short
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a0000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a0100000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a1000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a1100000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a2000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a2100000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a3000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a3100000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a4000000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    arch/arm64/boot/dts/ti/k3-am6754-phyboard-rigel.dtb: memory@a4100000 (shared-dma-pool): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
    fs/proc/task_mmu.c:3452:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3454:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
    include/linux/mmzone.h:94:34: error: 'PUD_SHIFT' undeclared here (not in a function); did you mean 'NMI_SHIFT'?

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609261944.h6Ey9ZPR-lkp@intel.com

    ERROR: modpost: __ex_table+0x18d8 references non-executable section '.data.rel.local'
    drivers/gpu/drm/amd/amdgpu/../ras/core/ras_umc.c:632:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
    drivers/pinctrl/sunplus/sppctl.c:980:1: internal compiler error: in final_scan_insn_1, at final.cc:2823

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-2400-20260921
|   |-- arch-arm64-boot-dts-freescale-imx8mm-data-modul-edm-sbc-overlay-cm4.dtb:vdev0buffer-b8400000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-data-modul-edm-sbc-overlay-cm7.dtb:vdev0buffer-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx952-frdm.dtb:linux-cma-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-alloc-ranges-reusable-size-were-unexpected)
|-- arm64-randconfig-2400-20260924
|   |-- arch-arm64-boot-dts-qcom-sm8650-valve-deckard.dtb:aop-cmd-db-region-81c60000-(qcom-cmd-db):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sm8650-valve-deckard.dtb:lpm-region-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sm8650-valve-deckard.dtb:lpm-region-6c80000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sm8650-valve-deckard.dtb:lpm-region-6d40000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-qcom-sm8650-valve-deckard.dtb:lpm-region-7c10000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a0000000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a0100000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a1000000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a1100000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a2000000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a2100000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a3000000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a3100000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   |-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a4000000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|   `-- arch-arm64-boot-dts-ti-k3-am6754-phyboard-rigel.dtb:memory-a4100000-(shared-dma-pool):Unevaluated-properties-are-not-allowed-(-no-map-reg-were-unexpected)
|-- arm64-randconfig-2400-20260925
|   |-- arch-arm64-boot-dts-renesas-r9a09g087m44-rzn2h-evk-cn20-lcdc.dtb:adc-(renesas-r9a09g087-adc):interrupt-names:adi-gbadi-gcadi-cmpai-cmpbi-is-too-short
|   |-- arch-arm64-boot-dts-renesas-r9a09g087m44-rzn2h-evk-cn20-lcdc.dtb:adc-(renesas-r9a09g087-adc):interrupts:is-too-short
|   |-- arch-arm64-boot-dts-renesas-r9a09g087m44-rzn2h-evk.dtb:adc-(renesas-r9a09g087-adc):interrupt-names:adi-gbadi-gcadi-cmpai-cmpbi-is-too-short
|   `-- arch-arm64-boot-dts-renesas-r9a09g087m44-rzn2h-evk.dtb:adc-(renesas-r9a09g087-adc):interrupts:is-too-short
|-- csky-allmodconfig
|   `-- drivers-pinctrl-sunplus-sppctl.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- csky-randconfig-1001-20260926
|   `-- drivers-gpu-drm-amd-amdgpu-..-ras-core-ras_umc.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- loongarch-allyesconfig
|   |-- Warning:drivers-remoteproc-da8xx_remoteproc.c-function-parameter-irq-not-described-in-handle_event
|   `-- Warning:drivers-remoteproc-da8xx_remoteproc.c-function-parameter-p-not-described-in-handle_event
|-- powerpc64-randconfig-1001-20260926
|   |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
|   `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu
|-- riscv-randconfig-1001-20260926
|   `-- ERROR:__ex_table-references-non-executable-section-.data.rel.local
|-- riscv-randconfig-1001-20260927
|   `-- include-linux-mmzone.h:error:PUD_SHIFT-undeclared-here-(not-in-a-function)
`-- um-randconfig-1000-20260926
    `-- usr-bin-ld:.-arch-um-kernel-vmlinux.lds:syntax-error

elapsed time: 1422m

configs tested: 165
configs skipped: 9

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                       axs103_smp_defconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260927    gcc-15.2.0
arc                   randconfig-1001-20260927    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                   randconfig-1000-20260927    gcc-10.5.0
arm                   randconfig-1001-20260927    gcc-11.5.0
arm                   randconfig-1002-20260927    gcc-13.4.0
arm                   randconfig-1003-20260927    gcc-15.2.0
arm                            sama5_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                 randconfig-1000-20260926    gcc-9.5.0
arm64                 randconfig-1001-20260926    clang-24
arm64                 randconfig-1002-20260926    gcc-8.5.0
arm64                 randconfig-1003-20260926    gcc-15.2.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260926    gcc-16.1.0
csky                  randconfig-1001-20260926    gcc-16.1.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon               randconfig-1000-20260927    clang-24
hexagon               randconfig-1001-20260927    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260926    gcc-14
i386        buildonly-randconfig-1001-20260926    clang-22
i386        buildonly-randconfig-1002-20260926    gcc-14
i386        buildonly-randconfig-1003-20260926    gcc-14
i386        buildonly-randconfig-1004-20260926    gcc-14
i386        buildonly-randconfig-1005-20260926    gcc-14
i386                  randconfig-1000-20260927    clang-22
i386                  randconfig-1001-20260927    clang-22
i386                  randconfig-1002-20260927    clang-22
i386                  randconfig-1003-20260927    gcc-14
i386                  randconfig-1004-20260927    gcc-14
i386                  randconfig-1005-20260927    clang-22
i386                  randconfig-1006-20260927    gcc-14
i386                  randconfig-1007-20260927    clang-22
i386                  randconfig-1008-20260926    gcc-14
i386                  randconfig-1008-20260927    gcc-13
i386                  randconfig-1009-20260927    gcc-14
i386                  randconfig-1010-20260927    clang-22
i386                  randconfig-1011-20260927    gcc-14
i386                  randconfig-1012-20260927    gcc-14
i386                  randconfig-1013-20260927    clang-22
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260927    gcc-16.1.0
loongarch             randconfig-1001-20260927    clang-24
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                           hp300_defconfig    gcc-16.1.0
m68k                        m5475evb_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    clang-24
mips                           rm200_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260927    gcc-11.5.0
nios2                 randconfig-1001-20260927    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260927    gcc-9.5.0
parisc                randconfig-1001-20260927    gcc-11.5.0
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                   mpc885_ads_defconfig    clang-24
powerpc               randconfig-1000-20260927    clang-24
powerpc               randconfig-1001-20260927    gcc-16.1.0
powerpc64             randconfig-1000-20260927    clang-24
powerpc64             randconfig-1001-20260927    clang-17
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260926    gcc-15.2.0
riscv                 randconfig-1001-20260926    gcc-9.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260926    gcc-15.2.0
s390                  randconfig-1001-20260926    gcc-8.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260926    gcc-10.5.0
sh                    randconfig-1001-20260926    gcc-12.5.0
sh                             titan_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260926    gcc-14.3.0
sparc                 randconfig-1001-20260926    gcc-12.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260926    clang-20
sparc64               randconfig-1001-20260926    gcc-9.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260926    gcc-14
um                    randconfig-1001-20260926    clang-17
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260927    gcc-14
x86_64      buildonly-randconfig-1001-20260927    clang-22
x86_64      buildonly-randconfig-1002-20260927    clang-22
x86_64      buildonly-randconfig-1003-20260927    clang-22
x86_64      buildonly-randconfig-1004-20260927    gcc-14
x86_64      buildonly-randconfig-1005-20260927    gcc-13
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260927    clang-22
x86_64                randconfig-1001-20260927    clang-22
x86_64                randconfig-1002-20260927    clang-22
x86_64                randconfig-1003-20260927    clang-22
x86_64                randconfig-1004-20260927    clang-22
x86_64                randconfig-1005-20260927    gcc-14
x86_64                randconfig-1006-20260926    gcc-12
x86_64                randconfig-1007-20260926    clang-22
x86_64                randconfig-1008-20260926    clang-22
x86_64                randconfig-1009-20260926    gcc-14
x86_64                randconfig-1010-20260926    clang-22
x86_64                randconfig-1011-20260926    gcc-14
x86_64                randconfig-1012-20260926    clang-22
x86_64                randconfig-1013-20260926    gcc-14
x86_64                randconfig-1014-20260926    clang-22
x86_64                randconfig-1015-20260926    clang-22
x86_64                randconfig-1016-20260926    clang-22
x86_64                randconfig-1017-20260926    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260926    gcc-16.1.0
xtensa                randconfig-1001-20260926    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

