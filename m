Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC42ACCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DB38E0055; Fri, 17 Oct 2025 05:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F403F8E0016; Fri, 17 Oct 2025 05:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F028E0055; Fri, 17 Oct 2025 05:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C19028E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:05:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56FCBC05B9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:06 +0000 (UTC)
X-FDA: 84007021812.11.741D902
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8437140007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fErQ56rG;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=In3DWbp7n180h8T90yh8iUKIqqEfVs642KBaKPktN2I=;
	b=auhLlTvy3J8LVU6KwFHYajN/G4O3lcI69uGnmZH8uI6D3gb+aZFvhhKJCFuWG2h/o4Jbx6
	K5QIlS/v1dxQKGzujJfOifXiznHA4IV/LgIj2WpGBse1RbqSUrHHQ7czMV9HAp06jCRg1F
	5inrfZjhqBTZryagrf+pke9sIcF7IXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691904; a=rsa-sha256;
	cv=none;
	b=ppJAu+cLjCfVqhS/yrFxUsotUD0fivyjz2zksZl0UJIQvXVeAMb8qa2NYfOqd1IGHW0a1P
	8873stoCVmaotBIrLXwOboGdIIZqBtxoZPoAgoH4UocJ/PA/BrIYvUbibLeTRv9rcNCByJ
	wp9dGuk1IO0uZhcsI+vOT+Ye28gTxXs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fErQ56rG;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760691904; x=1792227904;
  h=date:from:to:cc:subject:message-id;
  bh=oZVjQuhntO3Lg1O4SrjFMa8sN/M85GTHYXsqLo/YXDU=;
  b=fErQ56rG87YfhjQ1DBJBjwxkFPSHGmWgwpNnItohCYcIpCIhI/F+MxYq
   kRpYhqWD6uKCEl13GRe3ze6IIzjDbUng2pbCrSML0EUqq3SmNGUZoAVFx
   LTSHz0U6gzmEU/6vkH8mOZzKD9OP00m7kIwa6z53j6oACBgGWb1ovczM7
   QnF+vPzsddxPu/0GtTGoTEmjKtImh39aBHuBYFGsmldd9eXaf/k1bogxh
   xPLBZDnnUyz1z2ltmT/e+kWlNwxzLQb3lokUrsxAiICv8pWN0AEFP9SsP
   Qj4g3pwD+hb9Tnpk8gZE7M0r8KuuaGHgHk3eSA/fMURb4NoiNeVAnMX7Z
   w==;
X-CSE-ConnectionGUID: kVxUUaCCSUqgauhgCSJVfA==
X-CSE-MsgGUID: VHfobsHnSUWBmpaInoJBCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="74243372"
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="74243372"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 02:05:02 -0700
X-CSE-ConnectionGUID: tyBk4gm4SjmllerBUtNXjw==
X-CSE-MsgGUID: AiGCUkAlQBe+p1odixmeTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="182372411"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 17 Oct 2025 02:04:56 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9gNH-0005mt-0R;
	Fri, 17 Oct 2025 09:03:56 +0000
Date: Fri, 17 Oct 2025 17:03:14 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 2433b84761658ef123ae683508bc461b07c5b0f0
Message-ID: <202510171756.4npPyBuH-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Stat-Signature: 9woumqxtazu5wrpipmscgo58tjzsastx
X-Rspam-User: 
X-Rspamd-Queue-Id: A8437140007
X-HE-Tag: 1760691903-500981
X-HE-Meta: U2FsdGVkX1/qXalDo/1EQ3oDkTdfNG5SCTGhDMkw+Y3SjSg+B7ZRhqnFgutXRwS3qqfMV9g3Z8OJSvJWzm6/53pM/gnWlshdScet3i5w7CkfUIw1dtCw3k8UN4Uj7+0dk9DHaauwXe6Ye2XK/p9CBbE4HMUiZ/7JS7HXVMWjL05Hy+eXcdUAEC+POPBt5+PKTgVazbXms7QB/A9gkLZMcoZujtZ8VJJznM3ggv3XZl/0P7+PiC3ptA4UBS+wdZbfxZFfVNg/ghlzVEP/mJrG2PBV0/TxzHQHWEhnVrxQiIHhP4KWmUobTpIbC8lyyvi52VR1b8WUBdQMtRles31x/Dk4nIcYhq7ANOcfvjJ8U0WYJXmNfSZDMhIug3kFIcGlvYup5jwx7UNAE7nz8tfjNiJj4c6/Ket6S+AUrjkOineRziG0oFo5Uggm8GvxRXC1RVKoClqOaORgxmDmbJBmBcmx3EB8Yvcvb4xtbUeknisj8Lp/QY4OlBkDfx6278q5eFIn1mhA3OXV1wjHTMGvAMtJbBM33kr3pWqCJb1U/FCu2eITVbrvy0YDXk1/KQa+RhP9vo0AMhsPVe5lnfFHmz7gIWh1o7JJUQEGDMjjcbREKbRy35knBDaaFy7mpo1as/7Q97Wx+v5EbMtUculLXQKkkWo8HGckA9XgpOfKSq0ZmqIOa0RmGSZVC9rbmOtkWMaDRze4R/K+I97BkQS7KNjz9tSQLGOuhfbOp8fGLCNEnwYQXLj5KNplBfqOMl5LbSfYqI8z6T4kIXVO3v6VT8VZ4Au+6P9oMqj4FyAHRG9ZcNjn/s+N17x7P/anclKcQU7EEap2CKL6/Q3wsaRRZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 2433b84761658ef123ae683508bc461b07c5b0f0  Add linux-next specific files for 20251016

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509231815.d1EjWp8Y-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509251326.SYA3QL9j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510031615.GardRYTk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510110109.hIUbuESQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510100941.GZGMq64U-lkp@intel.com

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
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b10000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b12000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana-rev7.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): pinctrl-names: ['default'] is too short
    drivers/hwmon/gpd-fan.c:231:2: error: call to undeclared function 'outb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/hwmon/gpd-fan.c:244:9: error: call to undeclared function 'inb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    kernel/liveupdate/kexec_handover.c:1337 kho_release_scratch() warn: iterator 'i' not incremented

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arm-randconfig-051-20251017
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
|   `-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|-- arm-randconfig-052-20251017
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
|   `-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|-- arm-randconfig-053-20251017
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
|   `-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|-- arm-randconfig-054-20251017
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
|   `-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|-- arm-randconfig-055-20251017
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
|   `-- arch-arm-boot-dts-nxp-imx-imx7ulp-evk.dtb:clock-controller-(fsl-imx7ulp-smc1):clock-cells-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-051-20251017
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
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-052-20251017
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
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-053-20251017
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
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-054-20251017
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
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-055-20251017
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
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-marvell-mmp-pxa1908-samsung-coreprimevelte.dtb:clock-controller-(marvell-pxa1908-apmu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- i386-buildonly-randconfig-002-20251017
|   |-- drivers-hwmon-gpd-fan.c:error:call-to-undeclared-function-inb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-hwmon-gpd-fan.c:error:call-to-undeclared-function-outb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- microblaze-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- openrisc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- x86_64-buildonly-randconfig-006-20251017
|   |-- drivers-hwmon-gpd-fan.c:error:call-to-undeclared-function-inb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-hwmon-gpd-fan.c:error:call-to-undeclared-function-outb-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-randconfig-161-20251017
|   `-- kernel-liveupdate-kexec_handover.c-kho_release_scratch()-warn:iterator-i-not-incremented
`-- xtensa-allyesconfig
    `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer

elapsed time: 1046m

configs tested: 244
configs skipped: 9

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    clang-19
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    clang-19
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251017    clang-22
arc                   randconfig-001-20251017    gcc-8.5.0
arc                   randconfig-002-20251017    clang-22
arc                   randconfig-002-20251017    gcc-11.5.0
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-19
arm                                 defconfig    clang-22
arm                   randconfig-001-20251017    clang-22
arm                   randconfig-001-20251017    gcc-15.1.0
arm                   randconfig-002-20251017    clang-22
arm                   randconfig-003-20251017    clang-22
arm                   randconfig-004-20251017    clang-22
arm                         wpcm450_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251017    clang-20
arm64                 randconfig-001-20251017    clang-22
arm64                 randconfig-002-20251017    clang-22
arm64                 randconfig-003-20251017    clang-22
arm64                 randconfig-003-20251017    gcc-15.1.0
arm64                 randconfig-004-20251017    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251017    gcc-15.1.0
csky                  randconfig-002-20251017    gcc-10.5.0
csky                  randconfig-002-20251017    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251017    clang-22
hexagon               randconfig-001-20251017    gcc-15.1.0
hexagon               randconfig-002-20251017    clang-22
hexagon               randconfig-002-20251017    gcc-15.1.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251017    clang-20
i386        buildonly-randconfig-002-20251017    clang-20
i386        buildonly-randconfig-003-20251017    clang-20
i386        buildonly-randconfig-004-20251017    clang-20
i386        buildonly-randconfig-005-20251017    clang-20
i386        buildonly-randconfig-006-20251017    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251017    clang-20
i386                  randconfig-002-20251017    clang-20
i386                  randconfig-003-20251017    clang-20
i386                  randconfig-004-20251017    clang-20
i386                  randconfig-005-20251017    clang-20
i386                  randconfig-006-20251017    clang-20
i386                  randconfig-007-20251017    clang-20
i386                  randconfig-011-20251017    gcc-12
i386                  randconfig-012-20251017    gcc-12
i386                  randconfig-013-20251017    gcc-12
i386                  randconfig-014-20251017    gcc-12
i386                  randconfig-015-20251017    gcc-12
i386                  randconfig-016-20251017    gcc-12
i386                  randconfig-017-20251017    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251017    gcc-13.4.0
loongarch             randconfig-001-20251017    gcc-15.1.0
loongarch             randconfig-002-20251017    clang-18
loongarch             randconfig-002-20251017    gcc-15.1.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                       rbtx49xx_defconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20251017    gcc-15.1.0
nios2                 randconfig-001-20251017    gcc-8.5.0
nios2                 randconfig-002-20251017    gcc-15.1.0
nios2                 randconfig-002-20251017    gcc-8.5.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                generic-32bit_defconfig    gcc-15.1.0
parisc                randconfig-001-20251017    gcc-12.5.0
parisc                randconfig-001-20251017    gcc-15.1.0
parisc                randconfig-002-20251017    gcc-15.1.0
parisc                randconfig-002-20251017    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                          allyesconfig    gcc-15.1.0
powerpc                     ep8248e_defconfig    gcc-15.1.0
powerpc                  mpc866_ads_defconfig    clang-22
powerpc                      ppc64e_defconfig    clang-22
powerpc               randconfig-001-20251017    gcc-14.3.0
powerpc               randconfig-001-20251017    gcc-15.1.0
powerpc               randconfig-002-20251017    clang-22
powerpc               randconfig-002-20251017    gcc-15.1.0
powerpc               randconfig-003-20251017    gcc-11.5.0
powerpc               randconfig-003-20251017    gcc-15.1.0
powerpc                    socrates_defconfig    clang-22
powerpc64             randconfig-001-20251017    clang-20
powerpc64             randconfig-001-20251017    gcc-15.1.0
powerpc64             randconfig-002-20251017    gcc-15.1.0
powerpc64             randconfig-003-20251017    gcc-15.1.0
riscv                            allmodconfig    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                    nommu_virt_defconfig    clang-22
riscv                 randconfig-001-20251017    clang-22
riscv                 randconfig-002-20251017    clang-22
s390                             alldefconfig    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251017    clang-22
s390                  randconfig-002-20251017    clang-22
s390                  randconfig-002-20251017    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                ecovec24-romimage_defconfig    gcc-15.1.0
sh                 kfr2r09-romimage_defconfig    clang-22
sh                 kfr2r09-romimage_defconfig    gcc-15.1.0
sh                    randconfig-001-20251017    clang-22
sh                    randconfig-001-20251017    gcc-14.3.0
sh                    randconfig-002-20251017    clang-22
sh                    randconfig-002-20251017    gcc-15.1.0
sh                   sh7770_generic_defconfig    gcc-15.1.0
sh                            titan_defconfig    gcc-15.1.0
sh                              ul2_defconfig    clang-22
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251017    clang-22
sparc                 randconfig-001-20251017    gcc-12.5.0
sparc                 randconfig-002-20251017    clang-22
sparc                 randconfig-002-20251017    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251017    clang-22
sparc64               randconfig-001-20251017    gcc-14.3.0
sparc64               randconfig-002-20251017    clang-20
sparc64               randconfig-002-20251017    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251017    clang-22
um                    randconfig-001-20251017    gcc-14
um                    randconfig-002-20251017    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251017    clang-20
x86_64      buildonly-randconfig-001-20251017    gcc-14
x86_64      buildonly-randconfig-002-20251017    clang-20
x86_64      buildonly-randconfig-002-20251017    gcc-14
x86_64      buildonly-randconfig-003-20251017    clang-20
x86_64      buildonly-randconfig-004-20251017    clang-20
x86_64      buildonly-randconfig-004-20251017    gcc-14
x86_64      buildonly-randconfig-005-20251017    clang-20
x86_64      buildonly-randconfig-006-20251017    clang-20
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251017    gcc-14
x86_64                randconfig-002-20251017    gcc-14
x86_64                randconfig-003-20251017    gcc-14
x86_64                randconfig-004-20251017    gcc-14
x86_64                randconfig-005-20251017    gcc-14
x86_64                randconfig-006-20251017    gcc-14
x86_64                randconfig-007-20251017    gcc-14
x86_64                randconfig-008-20251017    gcc-14
x86_64                randconfig-071-20251017    clang-20
x86_64                randconfig-072-20251017    clang-20
x86_64                randconfig-073-20251017    clang-20
x86_64                randconfig-074-20251017    clang-20
x86_64                randconfig-075-20251017    clang-20
x86_64                randconfig-076-20251017    clang-20
x86_64                randconfig-077-20251017    clang-20
x86_64                randconfig-078-20251017    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251017    clang-22
xtensa                randconfig-001-20251017    gcc-12.5.0
xtensa                randconfig-002-20251017    clang-22
xtensa                randconfig-002-20251017    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

