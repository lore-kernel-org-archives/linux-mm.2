Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2577ACAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 00:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A588E0003; Fri,  3 Oct 2025 20:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AC88E0002; Fri,  3 Oct 2025 20:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DDB8E0003; Fri,  3 Oct 2025 20:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6E38E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:59:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6209C5BD2C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 00:59:25 +0000 (UTC)
X-FDA: 83958623490.19.580D02C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E217C000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 00:59:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UsN6HjD9;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759539563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0ybycQzllbOLNZLWGc0+EGob2VFWfCEIuV6y0M6MQKY=;
	b=o9KVuBPjrbGsv3RgGimiFwd76T+3sg6hDK5jAf6Ylx2zLbH09Y5JHFSjC3gszFhmPhzH+R
	OmHYEjUF2RA0u9Yo8+4FbVOW+skwkJodsDJFt28y3vlormyoCE+YRcaJMJFOJiUH9D/kg+
	zjz2DCIy/+TKjMjmApfp0C3abRgzSPc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UsN6HjD9;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759539563; a=rsa-sha256;
	cv=none;
	b=6w2Mws5OMq9kJvDy5LYS4owYrgFktBTT4WBqvOhuMcOi9CyWMtdUF5Zw4okDchf+ub5M3j
	/u6Livi7fFC9FY0uzMZyZckPxLQCZpXsBgFfVeytn2KgLeOeKEWTWdj5Lw0C4jO677DU/h
	RcoKwe1QJuA4eBOvo1/K6E6LHjZC4t0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759539562; x=1791075562;
  h=date:from:to:cc:subject:message-id;
  bh=AUMj7knk9XkhnsNqwapZU6XyTxVH83rjU/62TgqhCdQ=;
  b=UsN6HjD9ba0kqedFa0J8TTqp0hC/++f6D2blQpfveHA+LWXgkpu6EhaS
   Rmpcqq7CaqNiKR4UDaG4HDWrTkPtOFjOAYZDwFC6H6mXDb7eEjvsQkHNL
   zjNG19b5RBz94otoaO2qnTuwNbknBLfZgNLHick2FI0C2x4qqxXZOddlH
   MXaVgKssTPMFxuo3Q6QpktAayuhjnEYKtyJqYi9oySpVrxgAxplX537oo
   phDuYxYbZ+QoKkJW+ikW7ENSDpLNvSV8Z2zlgwJuXdei8MMNN3ZGrid+R
   FRZPhJWoGRdIDtr9EoJlr26G4Pm4+SZwYEsRe11Rh1XBDOFROWa3hPnCQ
   g==;
X-CSE-ConnectionGUID: /9rgfml+Qwefzho7fNAuxg==
X-CSE-MsgGUID: Zc0xcU32RymKBu/V9ZVqWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61857043"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="61857043"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:59:20 -0700
X-CSE-ConnectionGUID: XGMm9UBgTrmoLQnKNhaLvg==
X-CSE-MsgGUID: A1D5hXt1S6ukUVAuFOEk7Q==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 03 Oct 2025 17:59:18 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v4qcF-00050F-34;
	Sat, 04 Oct 2025 00:59:15 +0000
Date: Sat, 04 Oct 2025 08:58:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 47a8d4b89844f5974f634b4189a39d5ccbacd81c
Message-ID: <202510040823.ek5Pp7JK-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: 0E217C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: dti16hzy6ou1omm1bykogjakr9weuhag
X-Rspam-User: 
X-HE-Tag: 1759539561-291888
X-HE-Meta: U2FsdGVkX1/RB1CaV8V4mQELzLH+m5QPSzbJbx6Wfl3oOiMUg2hpdywtnk7cH55lQvnoxaIUR176Q+IjXWJyHzHMyzbieBjP/s9QZljiP9wlwVc1YqD2pkJSutlnQ1ggXRSV9RbRXVEuXznfLBSqBJl13Hlk+8hMfxdDzT2SWGMKjtEJgnIqlSTmYVcM+VtkdBm8ApoaRDBZgW6pZ9Ho9ggBEHuh0YMpPXqIiV0DDDq0udar6hh+oF4ZiYwTCmk/FArekFhmTStQGfOx/LTCJCXG88MdBAoZq3n8pR3OSzGg+j2FmyIK3qVpEVJFngpzWGUtrQL9+JfwuMM37VRbHTJPxfUXj2B+v7YvXkvevFa6au27EMwB5ezQ7ZlX/kIdNSwGz+Fu5k5p3066GcjZUd2RBxB9sCmDVf6od15d6mKyFUyUOlYb9wj7MGq41zJKWy3FxNFGMxMxqicW6hrBvpRQPVTk+hI34uYkUv3K+ANnFJew/f9xqFWwX4HERp50fJIGVgHsZ37vAZ5CFWFYbvI1bsV2NCX+SAs36oBA/Iw+CkehL9ejYM0zcS2/YUtr1CiNHGxYxjgin8Pvd9CbNNlOHqlrS0Ozj70wuqlxEVJeWVKuJ0CqrxcaJO4G6TQ8VIyyNAmzW8QkepBJbIEUWA24TEswVTWmrIfWI7edu9rtOIgBtNRKJ90X07B5Az3x0L79Q0pLZeeNiiu+yW7BBLsMhvKzqojWZtDk5lomE/ubq+yMbNAD3fCADuzC6ZvRqEv60EleSL2r8s07Ef9AGmZqe2jSFZbfVCsbnjSpd5XBXECyVJCaPFcQl9EN2hzToiZPTUXPUmEljOBJ/x4W7AXFxpTUZLLLUtMsgp/Vxrrwpqhg0ATKeeBSkz8IK+QLys6a+EL/fGvWNFRNcZihW94f+AxNfF1YB2W8jFePBN64snl0rGb4hOuVcIbI3x2JwFw0w9a28D8M+O9LoHa
 CcUcT2oH
 uf4/Ur4Lo1BdFWXwYIoitdlCopj570oCoEyXhK7/3Ewnlcqzr30dHoo+RtC1msBl9SMrLPWxXehSsw6+RHfn5XPSNhjuOHrLAIgipoyn+PZtLR5kBDgdzK8QQK3NgmY3QSECWuuI5XnSKjDm3iltW8l9Cox3VbskTiHI/42MY77PIQf9KUaDVgP21vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 47a8d4b89844f5974f634b4189a39d5ccbacd81c  Add linux-next specific files for 20251003

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
    https://lore.kernel.org/oe-kbuild/202509112313.0XfkfKPl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509250925.4L4JQTtn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509251347.F32MUauR-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
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
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    fs/btrfs/extent_io.c:401 find_lock_delalloc_range() error: we previously assumed 'fs_info' could be null (see line 378)
    fs/fs-writeback.c:729 cleanup_offline_cgwb() error: uninitialized symbol 'new_wb'.
    kernel/power/energy_model.c:649 em_dev_register_pd_no_update() error: we previously assumed 'dev->em_pd' could be null (see line 594)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-axs103_smp_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-exynos_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-003-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-004-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-051-20251003
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
|-- arm-randconfig-052-20251003
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
|-- arm-randconfig-053-20251003
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
|-- arm-randconfig-054-20251003
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
|-- arm-randconfig-055-20251003
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
|-- arm-sunxi_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20251003
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
|-- arm64-randconfig-052-20251003
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
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
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
|-- arm64-randconfig-053-20251003
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
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
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
|-- arm64-randconfig-054-20251003
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
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
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
|-- arm64-randconfig-055-20251003
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
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revA.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA-sck-kv-g-revB.dtb:spi-ff050000-(cdns-spi-r1p6):Unevaluated-properties-are-not-allowed-(-compatible-was-unexpected)
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-sm-k26-revA.dtb:spi-ff040000-(cdns-spi-r1p6):compatible:oneOf-conditional-failed-one-must-be-fixed:
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
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-006-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-141-20251003
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- fs-btrfs-extent_io.c-find_lock_delalloc_range()-error:we-previously-assumed-fs_info-could-be-null-(see-line-)
|   `-- kernel-power-energy_model.c-em_dev_register_pd_no_update()-error:we-previously-assumed-dev-em_pd-could-be-null-(see-line-)
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- mips-linux-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-002-20251003
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
|-- parisc-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-r122-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-g5_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-ge_imp3a_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-tqm5200_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-003-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-nommu_k210_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-002-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-006-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20251003
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- fs-btrfs-extent_io.c-find_lock_delalloc_range()-error:we-previously-assumed-fs_info-could-be-null-(see-line-)
|   `-- fs-fs-writeback.c-cleanup_offline_cgwb()-error:uninitialized-symbol-new_wb-.
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- xtensa-randconfig-001-20251003
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
`-- xtensa-randconfig-002-20251003
    `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files

elapsed time: 724m

configs tested: 160
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    clang-19
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                      axs103_smp_defconfig    gcc-15.1.0
arc                                 defconfig    clang-19
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251003    gcc-11.5.0
arc                   randconfig-002-20251003    gcc-13.4.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-19
arm                                 defconfig    clang-22
arm                          exynos_defconfig    clang-22
arm                   randconfig-001-20251003    gcc-12.5.0
arm                   randconfig-002-20251003    clang-22
arm                   randconfig-003-20251003    gcc-13.4.0
arm                   randconfig-004-20251003    gcc-13.4.0
arm                           sunxi_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251003    gcc-13.4.0
arm64                 randconfig-002-20251003    clang-22
arm64                 randconfig-003-20251003    gcc-10.5.0
arm64                 randconfig-004-20251003    gcc-13.4.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251003    gcc-15.1.0
csky                  randconfig-002-20251003    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251003    clang-22
hexagon               randconfig-002-20251003    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251003    gcc-14
i386        buildonly-randconfig-002-20251003    gcc-12
i386        buildonly-randconfig-003-20251003    clang-20
i386        buildonly-randconfig-004-20251003    gcc-12
i386        buildonly-randconfig-005-20251003    clang-20
i386        buildonly-randconfig-006-20251003    gcc-14
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251003    gcc-15.1.0
loongarch             randconfig-002-20251003    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251003    gcc-8.5.0
nios2                 randconfig-002-20251003    gcc-11.5.0
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
parisc                randconfig-001-20251003    gcc-9.5.0
parisc                randconfig-002-20251003    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                          allyesconfig    gcc-15.1.0
powerpc                          g5_defconfig    gcc-15.1.0
powerpc                    ge_imp3a_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251003    clang-22
powerpc               randconfig-002-20251003    gcc-8.5.0
powerpc               randconfig-003-20251003    clang-22
powerpc                     tqm5200_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251003    gcc-12.5.0
powerpc64             randconfig-002-20251003    gcc-10.5.0
powerpc64             randconfig-003-20251003    clang-18
riscv                            allmodconfig    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                    nommu_k210_defconfig    clang-22
riscv                 randconfig-001-20251003    gcc-11.5.0
riscv                 randconfig-002-20251003    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20251003    clang-22
s390                  randconfig-002-20251003    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251003    gcc-10.5.0
sh                    randconfig-002-20251003    gcc-14.3.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251003    gcc-14.3.0
sparc                 randconfig-002-20251003    gcc-13.4.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251003    clang-20
sparc64               randconfig-002-20251003    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251003    clang-22
um                    randconfig-002-20251003    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251003    clang-20
x86_64      buildonly-randconfig-002-20251003    gcc-14
x86_64      buildonly-randconfig-003-20251003    gcc-14
x86_64      buildonly-randconfig-004-20251003    gcc-14
x86_64      buildonly-randconfig-005-20251003    clang-20
x86_64      buildonly-randconfig-006-20251003    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251003    gcc-13.4.0
xtensa                randconfig-002-20251003    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

