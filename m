Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E673CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59A48E00FD; Tue, 14 Oct 2025 21:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A018E0005; Tue, 14 Oct 2025 21:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F92E8E00FD; Tue, 14 Oct 2025 21:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8803C8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:55:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D47313C105
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:55:09 +0000 (UTC)
X-FDA: 83998680738.16.80BB067
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09BDD180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:55:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lnZFarJ7;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760493307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=DfGCQh4OnAKLnqGkF2ATaUKnG8YJ2PJ9GbkljBai/rc=;
	b=GQy88uD1+WElrzJAIK5LmjAqBnBXJQTSgTFI9JFZYPjfQCoRFkArcb/idpZ2EVqn904PYP
	EFp7or7bFeziDqH9nyOtgTNdFWllgXOPRFEWm+o/wgjksdBpydE+QCiO5YWvf03BiIBN3i
	J7YhbErbMw6CECvYszA/Uaq+ekgjl38=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lnZFarJ7;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760493307; a=rsa-sha256;
	cv=none;
	b=Q87aOIyOb3peAfX+9punoRCNOq2actlLlvK5tCQMatYiRHJBjbJ17M9oyL/C4YRBYjR+U/
	YhNc1K3vCZIYsaZxCk5pOMkGxKg6SlrTUC16gJxZ2WIDDgGJKOuOd1X/mc6bXkcRfdgzAm
	ESNwWJ/TdpItoUoVitQ8o46wdf5+IQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760493306; x=1792029306;
  h=date:from:to:cc:subject:message-id;
  bh=Bx7hKWwFC3HBJf53Y5dUQiYbvc0geBkVWeIopiyy3xQ=;
  b=lnZFarJ7u6oWg3uhNpF8qAArzApa/O2JSiWnsnZkGAyOsLh+xR7tUZtD
   1yk7JXFKw4rXAUI64RfjZK/kqLCa6defhOqheXFHNowjo6DDT1DUQLUhF
   ynxJWuW0m5dcNrRg49/xN2M42w6ROgJrGN/QOi4TObH3GZcESI4Fo2G8j
   DKd/iS7T2G9OsUAAuySKtFC6BS1y8fPbJvOlrQJqr/wp8S+XPVqQ8o90m
   rGE42rXilirL68r5btW7OAIpz/l6kWmIhgHYEca1iEE+chcF5E9sQysS6
   wVSABdiSX9TeWUNGHDI2QTQ+UtQm4RBGSY9SWCI8v27bHteETR8v0R1u7
   A==;
X-CSE-ConnectionGUID: +M/Q8Ga6QIKLwEPZ4mTd0Q==
X-CSE-MsgGUID: nw0r+isQQs+YG/kts1zsYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="74109649"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="74109649"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:55:05 -0700
X-CSE-ConnectionGUID: jvEoP3IvRAWCyIuJcKAcEw==
X-CSE-MsgGUID: Aapv8YDkTGmcyYtCzPy3Tg==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 14 Oct 2025 18:55:03 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8qjE-0003Lf-19;
	Wed, 15 Oct 2025 01:55:00 +0000
Date: Wed, 15 Oct 2025 09:54:53 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 13863a59e410cab46d26751941980dc8f088b9b3
Message-ID: <202510150935.zrPIEqpl-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: x5fbd71o7wfctz3oa4rj7ocbbbwrccsc
X-Rspamd-Queue-Id: 09BDD180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760493305-499715
X-HE-Meta: U2FsdGVkX18WGstk9DniKR+9DTrwx8QvwdCAQbWz4Z87hKLaxwFlaQ67kXrRTCobUvTPkRaATVKFvI1xSrnJURdHXlLLAJmRJB4JlUfpy6PtfLCq4C6JSMz1LBn8pdiDuMP9ZRWrIUYzp7WLADin9Sl2/DbG2cmK8W2Hw3SVqnzHeNxeUPItMEDqW8C5hU0LDDpNrRYV6+6+hGpR9ZzcqkLqhIwc61bRfsbSwvZZqxekFs9viu7qSyEANMyiOoRHhKsw3aB9Xwn0BFoG49WmLLSczkzfq65ldBgDMjWsQtmJgeH38aiCWP3OiiZccnC/ENfECuxCFusaD7dqGMOyknqi8w5sCCFlG9b3xZ3e+5P8Q7XbWqAf9yYCBrl1bfzMhRksv4IvTcz7jK+YxRR2cQNBQbFcMheZoeas+LndakGZCYz/OqI6Fn06UqqH840KZ+NOXhqUfjD5+BXK1t7W/44gs8KxtVa3NJ+KU/ZOtFA0nVXQ3KIzFDgucoObdx1g/IRG/j51FIvAUO8Q2XFrlL8ltRD2lXHR4jVc/kwK+n7//CvaFRiP5rJFb5cxu6j2OGY2lXQHkDOCjhhbsmcuvlDhx4wrJz16OhclXJ7Ya5CCGZqQb5cV6+CaIYORgASxF8RC8mAWX6ly30hFCVwZLhgzFqV0EYyIjajJt0YYZqNtHIYSu5F+DDl8cV7BCpbHQzDm3tJ0NASwg+maalTvD1s2QGr2jpf8Le5YEbMy5qrUONLnbP6RutLc+K+5z4bQtAy/FRlQijvPBv/CYE88DLzFrUd7wpz5YRz6hp68nOFYwnhsyqsjgmoFwbcO0XntE0NdE/Sp7VAyGnO28AKvVHPl9tFSNHvEzheR8NGOerh0d5Ifqv1NOYFpLqmUG/NiiqmkrwIM3zMvVYrndr2wowV5MaV1lLMcflX83Tnyj1Rs1Det7qfYjb29emXOTXgPvH3yTxw8U+RXCiOINpr
 mq3I28bo
 D86FxaVTiW7BJzf+B4TPo9ywuBm0o46SCr7xYxZWulWFR/Gv9r8Ie0Ysbr9gAG5Ba5NGypVqODGWGe7Y675cqk5L60InxLTBpZc8H1unwN2CPuEpE+EN179tM5Bu0U4uFdAHeBpki+kL///pYhOVFghmPPM/H9ZaVkctdRxY6qi6XbgjsRzwN8nTbXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 13863a59e410cab46d26751941980dc8f088b9b3  Add linux-next specific files for 20251014

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
    https://lore.kernel.org/oe-kbuild-all/202510150406.kosHadG1-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509251347.F32MUauR-lkp@intel.com

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
    kernel/sched/ext.c:3220:20: error: 'scx_cgroup_rwsem' undeclared (first use in this function); did you mean 'scx_cgroup_ops_rwsem'?

Unverified Error/Warning (likely false positive, kindly check if interested):

    fs/fs-writeback.c:729 cleanup_offline_cgwb() error: uninitialized symbol 'new_wb'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arm-allmodconfig
|   `-- ERROR:__ffsdi2-drivers-spi-spi-amlogic-spifc-a4.ko-undefined
|-- arm-randconfig-051-20251014
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
|-- arm-randconfig-052-20251014
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
|-- arm-randconfig-053-20251014
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
|-- arm-randconfig-054-20251014
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
|-- arm-randconfig-055-20251014
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
|-- arm64-randconfig-051-20251014
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
|-- arm64-randconfig-052-20251014
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
|-- arm64-randconfig-053-20251014
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
|-- arm64-randconfig-054-20251014
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
|-- arm64-randconfig-055-20251014
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
|-- i386-buildonly-randconfig-002-20251014
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
|-- parisc-randconfig-002-20251015
|   `-- kernel-sched-ext.c:error:scx_cgroup_rwsem-undeclared-(first-use-in-this-function)
|-- sh-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- x86_64-randconfig-161-20251014
|   `-- fs-fs-writeback.c-cleanup_offline_cgwb()-error:uninitialized-symbol-new_wb-.
`-- xtensa-allyesconfig
    `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer

elapsed time: 735m

configs tested: 173
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251014    gcc-15.1.0
arc                   randconfig-002-20251014    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                     am200epdkit_defconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                          pxa910_defconfig    gcc-15.1.0
arm                   randconfig-001-20251014    gcc-15.1.0
arm                   randconfig-002-20251014    gcc-13.4.0
arm                   randconfig-003-20251014    clang-16
arm                   randconfig-004-20251014    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251014    gcc-9.5.0
arm64                 randconfig-002-20251014    gcc-10.5.0
arm64                 randconfig-003-20251014    gcc-14.3.0
arm64                 randconfig-004-20251014    gcc-14.3.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251014    gcc-15.1.0
csky                  randconfig-002-20251014    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251014    clang-22
hexagon               randconfig-002-20251014    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251014    gcc-14
i386        buildonly-randconfig-001-20251015    gcc-13
i386        buildonly-randconfig-002-20251014    clang-20
i386        buildonly-randconfig-002-20251015    gcc-14
i386        buildonly-randconfig-003-20251014    clang-20
i386        buildonly-randconfig-003-20251015    clang-20
i386        buildonly-randconfig-004-20251014    gcc-14
i386        buildonly-randconfig-004-20251015    clang-20
i386        buildonly-randconfig-005-20251014    gcc-14
i386        buildonly-randconfig-005-20251015    clang-20
i386        buildonly-randconfig-006-20251014    clang-20
i386        buildonly-randconfig-006-20251015    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251014    clang-18
loongarch             randconfig-002-20251014    gcc-15.1.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                        omega2p_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20251014    gcc-11.5.0
nios2                 randconfig-002-20251014    gcc-8.5.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-14
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251014    gcc-11.5.0
parisc                randconfig-002-20251014    gcc-9.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                 mpc834x_itx_defconfig    clang-16
powerpc               randconfig-001-20251014    gcc-9.5.0
powerpc               randconfig-002-20251014    clang-22
powerpc               randconfig-003-20251014    gcc-14.3.0
powerpc64             randconfig-001-20251014    gcc-8.5.0
powerpc64             randconfig-002-20251014    gcc-8.5.0
powerpc64             randconfig-003-20251014    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                 randconfig-001-20251014    gcc-10.5.0
riscv                 randconfig-002-20251014    gcc-10.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20251014    clang-22
s390                  randconfig-002-20251014    clang-19
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                          r7780mp_defconfig    gcc-15.1.0
sh                          r7785rp_defconfig    gcc-15.1.0
sh                    randconfig-001-20251014    gcc-14.3.0
sh                    randconfig-002-20251014    gcc-11.5.0
sh                           se7206_defconfig    gcc-15.1.0
sh                           se7780_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251014    gcc-15.1.0
sparc                 randconfig-002-20251014    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251014    clang-20
sparc64               randconfig-002-20251014    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251014    gcc-14
um                    randconfig-002-20251014    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251014    gcc-14
x86_64      buildonly-randconfig-001-20251015    clang-20
x86_64      buildonly-randconfig-002-20251014    clang-20
x86_64      buildonly-randconfig-002-20251015    gcc-14
x86_64      buildonly-randconfig-003-20251014    gcc-14
x86_64      buildonly-randconfig-003-20251015    clang-20
x86_64      buildonly-randconfig-004-20251014    clang-20
x86_64      buildonly-randconfig-004-20251015    clang-20
x86_64      buildonly-randconfig-005-20251014    clang-20
x86_64      buildonly-randconfig-005-20251015    gcc-14
x86_64      buildonly-randconfig-006-20251014    gcc-14
x86_64      buildonly-randconfig-006-20251015    gcc-13
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251014    gcc-8.5.0
xtensa                randconfig-002-20251014    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

