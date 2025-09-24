Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBA5CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 06:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1A68E0005; Wed, 24 Sep 2025 02:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62DF8E0001; Wed, 24 Sep 2025 02:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50AA8E0005; Wed, 24 Sep 2025 02:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBB148E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:49:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F52114071D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:49:07 +0000 (UTC)
X-FDA: 83923216734.15.044091A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E04A180006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:49:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AheFMbSp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758696545; a=rsa-sha256;
	cv=none;
	b=vUThhIuaoJksmaFvOrJQURr2LHtms1obdtMYMgThtWWnOo8mHy6ainFxwMQ3P5b3GeyreA
	/JljN1JZ8wCRCgo2PJsLWnAMLx/x7yV6E3Eh8W5wbTT3ALT52lXSoAY734k5Q5emvEBKNO
	ISZ1S48yVVDxlBRMOPomVoJjsUgOxys=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AheFMbSp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758696545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=GmOkPPKyloCO8I7PJMWc/YvTCQ+7DwWSVO0Xb4dM1Vo=;
	b=XCbGhdTWtOF+VA9/tyxuk9OC+94GOCRw1SNONcHecOKJ8mMaFauBOnMGjgvqrcVlir2fLn
	FHRz+bN+FIa8dEL9TV65A2IJ1aaZEs94rXLD0PaQtu9NAYwHh45pFq2Yt1Q+vOkODpaXRG
	V7qNC0vbyF2OlpYmOz6twem6pMitXmE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758696544; x=1790232544;
  h=date:from:to:cc:subject:message-id;
  bh=fACwJ1DVYJ/XL2xyxi+7a07juReR+hsM5RangBIsDtA=;
  b=AheFMbSpAPsP7J7PQVIistJiqNQEvhvajHSxmc67JvXO0twYFiqguauF
   PAoFZ3QMViAE9a+2IHKC/FRn4Lrzq4N+jbIRMeJjVJktJ1lb+qiGghbIG
   bFm8WsQUBL2UcvfP2z/Uc8SjgM5JsTXn7oQZMkbgUue0zLEC2ozu8QudS
   r6jfq5JD5k+cai4Lev4bShCkRa8usCZ4/8y4SESzyMmJ3d4FTCGXAiXCF
   h06jXRHDeGAzgvhgQPLitlworTRDQQnLfhwPaf1nLHcjbI7pkDGmVaGVL
   R+vrXUAVJrVSYiKG+YH5kQcrbLGhP80h0HNHhWPV1v5TE3+hw6qUwMA65
   Q==;
X-CSE-ConnectionGUID: WGV7XB32R3Ol5VvsFsftTg==
X-CSE-MsgGUID: gjAEMdLXRFeQosKvYTFWBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="78424268"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="78424268"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 23:49:03 -0700
X-CSE-ConnectionGUID: I1BXSGhmS8SfPWVJa8kQ2w==
X-CSE-MsgGUID: dH5UTuBaR16yhO4bC2x8jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="181264392"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 23 Sep 2025 23:49:02 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1JJD-0003sL-0F;
	Wed, 24 Sep 2025 06:48:59 +0000
Date: Wed, 24 Sep 2025 14:48:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 ce7f1a983b074f6cf8609068088ca3182c569ee4
Message-ID: <202509241458.dEoMn84D-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E04A180006
X-Stat-Signature: physq6sbz6r4wfxdmx99cqbung8inqyi
X-Rspam-User: 
X-HE-Tag: 1758696544-246954
X-HE-Meta: U2FsdGVkX19mbUoAie/PrPR7FPJOW5c+EsAtTRmSTpTfJldBS6R9ju01sJDi1PvrqWZ3pBNubkQz7GNQy/BBjL76FTwJp24GTZ3VsHFpaJuJhqk7LEBgZjLPbBp4a4IC2bSKB5KFjrxc/KjMUWY4YbacDZNSbSERW/S6ivp86YYfGAyh1BLwxWXObhkPz9F/KJjwaQD7bX3Xy/nUC1qbEJLcbTAnr85AWb4MMMdK5XHu81sVvHOcReLKAm3bqqzrpU3RKq8ndZELNYNKYQ0WprZfY+znS4ELM+1zeVO/Gdewb4DMPUwE6dm+e8vjQ7FVxK5iFj2OmyvBHsea7x/tIpMTbSAXLiSAUS2fTLYQw3681Pz6aRqpMktwPr6FSQXRBO4bY8tqUcXajT92o7DLRv2xJsP1yj417IsgiH6dv/5SJ6R4zTWCCj/pwPO5h2XTlGdzm00mIXQvySCdiOpXwa81t3rfYyGfwnFg/QTd564CbiuQQtpbRms/PkmJ6vVoD/n0ETFXwdVF+KyNFwy83scLbyWBFbwZfjg6EzJsuviph429Zmaf7eWXN/qzzIayVLMRwxTWwb2pXCBeLCfIia4uumivOZy2YfOmHD0YKp5S6c7/kuJBL7xh9b8wjA3OvxSXxM39i4CebWjkL46Diw7HSLYPJlqx3peP/7YnnthmK6dNk6OmqvpiCFr4ZsPaZkK5dArYH4LRpyxxAdQcz6X0OGzNnRAKA9B2DVnniOW+XWkRizN+OEEmA7v60tfu2uXrCZssBcW+TCMd6sIOsroz1/iv92i/wvCqyMr6lcwhRZ2vCOEhYvQHXP4UhZUGNH2MYORZ7a31fv+wTYCP7eHlkENLG37v6hCOw3Gz9RHwhHaKt+ZRpDQENAYVyYmCxt68v0yqSuqHHpdjh61g6qPhFs2GV6A5y9O6GOb1eaYIP/bQI/XG3FWGuORka6aaUD5+6t3pPIdjgnKbO3E
 Gnoajqjq
 VUW9dgGdOF9O+Yt/axa/Jopa1DPP5407LvPtlFY3oIMaC1AFLtftF85fri6VbmxHaM6J7OBxt1tLbLxWdwA2eMsjHGQCvz6SmzuENUdfLq+tZy8Tm6ik9P3Q8mNJ17EkBeJbu9kzoxp9xFO5gVUOTPOurubGIfTWEHa0ePhYhzbVOEMD6yw0Otfjxvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: ce7f1a983b074f6cf8609068088ca3182c569ee4  Add linux-next specific files for 20250923

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509170136.b5ZHaNAV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190505.fKGvEJRa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192041.tQwdE4DS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509211250.mD8JS2nu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509230549.L26lw7UZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509241020.mrKHkcLR-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    ERROR: modpost: "__ffsdi2" [drivers/spi/spi-amlogic-spifc-a4.ko] undefined!
    ERROR: modpost: "__udivdi3" [drivers/power/supply/intel_dc_ti_battery.ko] undefined!
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-aster.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-eval-v3.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris-v2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6dl-colibri-iris.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger', 'stmpe_adc' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval-v1.2.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-eval.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.1.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora.dtb: stmpe811@41 (st,stmpe811): 'blocks', 'id', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-2 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c2mux@1', 'i2c2mux@2' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-nitrogen6_max.dtb: i2c-mux-3 (i2c-mux-gpio): Unevaluated properties are not allowed ('i2c3mux@1' was unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): 'blocks', 'id', 'irq-gpio', 'irq-trigger' do not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): touchscreen: Unevaluated properties are not allowed ('st,adc-freq', 'st,mod-12b', 'st,ref-sel', 'st,sample-time' were unexpected)
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
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): pinctrl-names: ['default'] is too short
    drivers/char/tpm/tpm_loongson.c:48:10: error: incompatible function pointer types initializing 'int (*)(struct tpm_chip *, u8 *, size_t, size_t)' (aka 'int (*)(struct tpm_chip *, unsigned char *, unsigned long, unsigned long)') with an expression of type 'int (struct tpm_chip *, u8 *, size_t)' (aka 'int (struct tpm_chip *, unsigned char *, unsigned long)') [-Wincompatible-function-pointer-types]
    drivers/char/tpm/tpm_loongson.c:48:17: error: initialization of 'int (*)(struct tpm_chip *, u8 *, size_t,  size_t)' {aka 'int (*)(struct tpm_chip *, unsigned char *, long unsigned int,  long unsigned int)'} from incompatible pointer type 'int (*)(struct tpm_chip *, u8 *, size_t)' {aka 'int (*)(struct tpm_chip *, unsigned char *, long unsigned int)'} [-Wincompatible-pointer-types]
    drivers/firewire/core-card.c:561:32: warning: overflow in expression; result is -1'179'869'184 with type 'long' [-Winteger-overflow]
    drivers/firewire/core-card.c:561:32: warning: overflow in expression; result is -1179869184 with type 'long' [-Winteger-overflow]
    drivers/firewire/core.h:33:65: warning: integer overflow in expression of type 'long int' results in '-1179869184' [-Woverflow]
    drivers/gpu/drm/xe/tests/xe_pci.c:215:2: error: initializer element is not a compile-time constant
    drivers/i3c/master/adi-i3c-master.c:134:18: warning: variable 'm' set but not used [-Wunused-but-set-variable]
    drivers/i3c/master/adi-i3c-master.c:134:25: warning: variable 'm' set but not used [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    drivers/gpu/drm/xe/xe_configfs.c:282 lookup_engine_info() error: we previously assumed 'mask' could be null (see line 278)
    mips-linux-ld: spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width+0xd4): undefined reference to `__ffsdi2'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arm-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- ERROR:__ffsdi2-drivers-spi-spi-amlogic-spifc-a4.ko-undefined
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arm-linux-gnueabi-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-mmp2_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-mps2_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- arm-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- arm-randconfig-003-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-004-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-051-20250924
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-052-20250924
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-053-20250924
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-054-20250924
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-055-20250924
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-aster.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-eval-v3.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris-v2.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-colibri-iris.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-stmpe_adc-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-eval.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora-v1..dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-apalis-ixora.dtb:stmpe811-(st-stmpe811):blocks-id-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):blocks-id-irq-gpio-irq-trigger-do-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):touchscreen:Unevaluated-properties-are-not-allowed-(-st-adc-freq-st-mod-12b-st-ref-sel-st-sample-time-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c2mux-i2c2mux-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6qp-nitrogen6_max.dtb:i2c-mux-(i2c-mux-gpio):Unevaluated-properties-are-not-allowed-(-i2c3mux-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx7d-nitrogen7.dtb:touchscreen-(ti-tsc2004):wakeup-gpios-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-com.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:flash-(atmel-at45db021d):Unevaluated-properties-are-not-allowed-(-spi-cpha-spi-cpol-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-ls-ls1021a-qds.dtb:memory-controller-(fsl-ifc):board-control:Unevaluated-properties-are-not-allowed-(-address-cells-size-cells-bank-width-compatible-device-width-mdio-mux-ranges-
|-- arm-randconfig-r131-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-rpc_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-stm32_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-002-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20250924
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-052-20250924
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-053-20250923
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-053-20250924
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-054-20250924
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-055-20250924
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
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-r111-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-r121-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-rtc-rtc-optee.c:sparse:sparse:symbol-optee_rtc_pm_ops-was-not-declared.-Should-it-be-static
|-- csky-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- csky-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- csky-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- csky-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- hexagon-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-randconfig-r113-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-buildonly-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-buildonly-randconfig-003-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-004-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-005-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-buildonly-randconfig-006-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-015-20250923
|   `-- ERROR:__udivdi3-drivers-power-supply-intel_dc_ti_battery.ko-undefined
|-- i386-randconfig-141-20250923
|   `-- drivers-gpu-drm-xe-xe_configfs.c-lookup_engine_info()-error:we-previously-assumed-mask-could-be-null-(see-line-)
|-- loongarch-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_loongson.c:error:incompatible-function-pointer-types-initializing-int-(-)(struct-tpm_chip-u8-size_t-size_t)-(aka-int-(-)(struct-tpm_chip-unsigned-char-unsigned-long-unsigned-long)
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_loongson.c:error:incompatible-function-pointer-types-initializing-int-(-)(struct-tpm_chip-u8-size_t-size_t)-(aka-int-(-)(struct-tpm_chip-unsigned-char-unsigned-long-unsigned-long)
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-char-tpm-tpm_loongson.c:error:initialization-of-int-(-)(struct-tpm_chip-u8-size_t-size_t)-aka-int-(-)(struct-tpm_chip-unsigned-char-long-unsigned-int-long-unsigned-int)-from-incompatible-point
|-- m68k-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-mvme147_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- mips-linux-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- nios2-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- nios2-randconfig-r132-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-randconfig-r133-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- powerpc-kmeter1_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- powerpc-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- powerpc-randconfig-003-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-tqm8xx_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- powerpc64-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc64-randconfig-003-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-tests-xe_pci.c:error:initializer-element-is-not-a-compile-time-constant
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-randconfig-002-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-se7705_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- sparc64-randconfig-002-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- um-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-firewire-core-card.c:warning:overflow-in-expression-result-is-with-type-long
|-- um-randconfig-002-20250924
|   `-- arch-um-include-asm-kasan.h:error:UML-does-not-work-in-KASAN_INLINE-mode-with-STATIC_LINK-enabled
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- x86_64-buildonly-randconfig-001-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-003-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-buildonly-randconfig-004-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- x86_64-buildonly-randconfig-005-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-006-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-r123-20250924
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-rhel-9.4-rust
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-randconfig-001-20250924
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core.h:warning:integer-overflow-in-expression-of-type-long-int-results-in
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
`-- xtensa-randconfig-002-20250924
    |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
    `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET

elapsed time: 800m

configs tested: 165
configs skipped: 4

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250924    gcc-11.5.0
arc                   randconfig-002-20250924    gcc-14.3.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                            mmp2_defconfig    gcc-15.1.0
arm                            mps2_defconfig    clang-22
arm                   randconfig-001-20250924    clang-22
arm                   randconfig-002-20250924    clang-22
arm                   randconfig-003-20250924    clang-22
arm                   randconfig-004-20250924    gcc-13.4.0
arm                             rpc_defconfig    clang-18
arm                           stm32_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250924    gcc-14.3.0
arm64                 randconfig-002-20250924    clang-18
arm64                 randconfig-003-20250924    gcc-12.5.0
arm64                 randconfig-004-20250924    clang-22
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250924    gcc-14.3.0
csky                  randconfig-002-20250924    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250924    clang-22
hexagon               randconfig-002-20250924    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250924    gcc-14
i386        buildonly-randconfig-002-20250924    clang-20
i386        buildonly-randconfig-003-20250924    gcc-13
i386        buildonly-randconfig-004-20250924    gcc-14
i386        buildonly-randconfig-005-20250924    clang-20
i386        buildonly-randconfig-006-20250924    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250924    gcc-15.1.0
loongarch             randconfig-002-20250924    gcc-14.3.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        mvme147_defconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250924    gcc-11.5.0
nios2                 randconfig-002-20250924    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-14
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250924    gcc-12.5.0
parisc                randconfig-002-20250924    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     kmeter1_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250924    clang-18
powerpc               randconfig-002-20250924    clang-18
powerpc               randconfig-003-20250924    clang-22
powerpc                      tqm8xx_defconfig    clang-19
powerpc64             randconfig-001-20250924    clang-22
powerpc64             randconfig-002-20250924    gcc-15.1.0
powerpc64             randconfig-003-20250924    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                 randconfig-001-20250924    gcc-8.5.0
riscv                 randconfig-002-20250924    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20250924    gcc-8.5.0
s390                  randconfig-002-20250924    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250924    gcc-15.1.0
sh                    randconfig-002-20250924    gcc-15.1.0
sh                           se7705_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250924    gcc-15.1.0
sparc                 randconfig-002-20250924    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20250924    gcc-8.5.0
sparc64               randconfig-002-20250924    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250924    clang-16
um                    randconfig-002-20250924    clang-19
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250924    clang-20
x86_64      buildonly-randconfig-002-20250924    clang-20
x86_64      buildonly-randconfig-003-20250924    clang-20
x86_64      buildonly-randconfig-004-20250924    gcc-14
x86_64      buildonly-randconfig-005-20250924    clang-20
x86_64      buildonly-randconfig-006-20250924    clang-20
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250924    gcc-13.4.0
xtensa                randconfig-002-20250924    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

