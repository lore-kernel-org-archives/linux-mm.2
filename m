Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBE8CAC5B9
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 04:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48608E0003; Sat, 27 Sep 2025 00:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D24E8E0001; Sat, 27 Sep 2025 00:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8729A8E0003; Sat, 27 Sep 2025 00:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66D2A8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:31:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6B681A0802
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:31:20 +0000 (UTC)
X-FDA: 83933755920.30.1510C9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0782C2000B
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:31:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kis2mXHj;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758947479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AD+GDe6dkb6CAirbse8oNyim1mCbH34F/z7cVK1RJp0=;
	b=jiu1bwJIOUMaGQU213Fd5/TxP5OyLzz6bZ/Fyps/hIT+lroof3NVgguKsxcRTD5hBK9YwZ
	1RZbASGzQLRgJUHZFh1GBsJUq+65qAjKBzDRdBLyIsTGZzoDqS8EY6dFIz6C4ms+R7L3uw
	wxJuA7ecs1QsZqtDQPe6/RyI/FK3zaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758947479; a=rsa-sha256;
	cv=none;
	b=8D3L0+mU3W1dWmcqZRgN0bm29D+SY55w2xQgGCC4IABprysRpQFvIQfe6ps3gj0KwnzSSh
	qjkpQXGYHt4jZPLFV4e26hu8/2SJuyO0Qsqp3Wb1mcB2KRLWm0SyZKxOxjzGxeN2qSyutK
	juw/gN6ZEAuuutGBx2UybtalmdFWmNY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kis2mXHj;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758947478; x=1790483478;
  h=date:from:to:cc:subject:message-id;
  bh=mQXVNR89QmIlz+Istp3l46pb5zGAxFAQPT5fzVMJHss=;
  b=kis2mXHjWq0ln/B9TUvg723FJzagFsfJhqfj/7J8fkZUPas/wVI+cbia
   7ObUTVuClN0nViGX2aQ3tAWrSXxCjYKQuVAseB/ySaxMh3Q9aKIe+sKiq
   YRmGjOSsGwEqMKFaVYHD12lS9xudfvMYYB+utijq0BL9f7RVRkWknAOo4
   sUQ0QF+gBDPDtxtmP+O3T8cc1yN8eFgFDE3didUwfiOnPBuGSFynLVfoO
   5DDpJS5AjcCp57H1eBCe0a9MjL+e2TgwHAhoWzk0NxJKXDCqKxNlKHv0x
   9YgyZ3RxsYx44P9A2es2t+72E9UOb5ZS0RvNC06uecXsEC+2nGNdjpjVS
   g==;
X-CSE-ConnectionGUID: Ka36PPIKSLmdeeCfHAFyww==
X-CSE-MsgGUID: YZjsmFoHRvuEeD8sftHlFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="71958582"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="71958582"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 21:31:16 -0700
X-CSE-ConnectionGUID: kQY0LDwDSj25lUJbEE+g9g==
X-CSE-MsgGUID: 54renw8pQAei6juK/4wGtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="178173225"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 26 Sep 2025 21:31:14 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2MaV-0006mz-2r;
	Sat, 27 Sep 2025 04:31:11 +0000
Date: Sat, 27 Sep 2025 12:30:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 262858079afde6d367ce3db183c74d8a43a0e83f
Message-ID: <202509271226.X0pWIs0Z-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0782C2000B
X-Stat-Signature: ci9fd1n9asqwg914a6c9hdghpn8ab9tf
X-Rspam-User: 
X-HE-Tag: 1758947477-407954
X-HE-Meta: U2FsdGVkX199aJHaryZZr4PwJRryoRc67wdh6VkJFvkZ6mzKMcGemG4TXSSy5/RgCgWH13GnrDodQ6wNLVXyRYXHoTMZ6gsv97h6Ybd7zinoI/rOi/G2pVpK6jAwkbl3WBO/S1imOBE2ST/cKaZJc+AaHVze9z+prgpe5OOz0Nmwrxzk2204J+G7sPdkOp/bgUet6LYwYHd1VquhmtzE/A6rPVImz7tz6DIZWMQFtv2i71JR8rm4gqIepcY32wFmxBBtAALpIeWHIi2fFtq7/75WmtbM68jOAt7zB0Bh2GW73W3ucN590PYq75YoHIqj3bmDQedM1R6TKKIE2NO9SlrRxglT1y7Ob+Yd35pUOu1SFbQ/hwGOihDHuOeBbJ3K4zFrFpW3csfpTnSd3sxDMHv9m3ex1vEc/f3NQUNgbcJRXiD8BkrAcRoreo4RH6OKQUTLyNdEOkrybY/I+AEYWPNlHSeErpct0yvVNhI/2B01Kf0FWbMYBuyATveRXqIasdKGt8tWkNy+qeS7GbrIUBrUhFjmLEr2xmj7xyEtzyG5busHyzOOrN8fQpBVLEGVYwL3rtbXYDfO2bgT6VnBhvpH4ZfQZGrUJepdUxVoMAkNB/6LN6CHKVBW4RXLa8NzPPzbQkG9lvpLpim9c2TjAGPm/oMBrQo85qur0wYhJP6S+pUcKAL44q1RgQJlKDj6OlvC7vgoKJPRQ7iKL30xwSehTDes7WaRr64RCpEMQxZJOrc5r+VBBI1rg71p7ATY5zmIy4Pm9v88L7xNQdxNhiKYPe63o1H8KQK+FZADgBLfjb9jVFJ+eAzP3Y25Jn7bv3KoyzoV5bRGxvglHBY+BKm3xdqyaOpldckBauqlNWcVI+VgJkwCuDupo36CwRpcr+NPOI3UPFQOWQNcdvkksQgtHOD/3aw8IDCa50YX3OY7ysT3DHQvMH3x4LUGAa/QYI2M3JoXfkBUrbCur2+
 pHapS1DI
 hfGqVjQ5w6UCGPaAJ8QXuAcLu9lqYInlrn4SGvyQ5lWby6aka0mHs8KkbH18Zu64uAmxr5Tn++HEn2h6oZsHUXGnEIAbU543//IUQXwAVrhS3ZkiDqyY5P9uWW0mp92m31TxpdWJYzR5d1twepKRDTtfU3AYurLpBi636iuegL+3zD9DspLmdgtcA+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 262858079afde6d367ce3db183c74d8a43a0e83f  Add linux-next specific files for 20250926

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190505.fKGvEJRa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509211250.mD8JS2nu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509231815.d1EjWp8Y-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509251326.SYA3QL9j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509252250.uv5q12aK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509270428.FZaO2PPq-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509112313.0XfkfKPl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509121952.ChfqonoQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509122123.Tv76XiqQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509122328.JDGUFyAN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509250925.4L4JQTtn-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    ERROR: modpost: "__ffsdi2" [drivers/spi/spi-amlogic-spifc-a4.ko] undefined!
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
    drivers/char/tpm/tpm_loongson.c:48:10: error: incompatible function pointer types initializing 'int (*)(struct tpm_chip *, u8 *, size_t, size_t)' (aka 'int (*)(struct tpm_chip *, unsigned char *, unsigned long, unsigned long)') with an expression of type 'int (struct tpm_chip *, u8 *, size_t)' (aka 'int (struct tpm_chip *, unsigned char *, unsigned long)') [-Wincompatible-function-pointer-types]
    drivers/firewire/core-transaction.c:1255: undefined reference to `__aeabi_uldivmod'
    drivers/i3c/master/adi-i3c-master.c:134:18: warning: variable 'm' set but not used [-Wunused-but-set-variable]
    drivers/i3c/master/adi-i3c-master.c:134:25: warning: variable 'm' set but not used [-Wunused-but-set-variable]
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_bo.c:2468 xe_bo_create_pin_range_novm() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_bo.c:2553 xe_bo_create_pin_map_at_novm() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_pxp_submit.c:133 allocate_gsc_client_resources() error: uninitialized symbol 'bo'.
    fs/btrfs/extent_io.c:401 find_lock_delalloc_range() error: we previously assumed 'fs_info' could be null (see line 378)
    kernel/power/energy_model.c:649 em_dev_register_pd_no_update() error: we previously assumed 'dev->em_pd' could be null (see line 594)

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
|-- alpha-randconfig-r112-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arm-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- ERROR:__ffsdi2-drivers-spi-spi-amlogic-spifc-a4.ko-undefined
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arm-linux-gnueabi-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-exynos_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-gemini_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-003-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-firewire-core-transaction.c:undefined-reference-to-__aeabi_uldivmod
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-randconfig-004-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm-randconfig-051-20250927
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
|-- arm-randconfig-052-20250927
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
|-- arm-randconfig-053-20250927
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
|-- arm-randconfig-054-20250927
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
|-- arm-randconfig-055-20250927
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
|-- arm-spear3xx_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- arm64-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20250927
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
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-052-20250927
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
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-053-20250927
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
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-054-20250927
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
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-055-20250927
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
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-r132-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- i386-buildonly-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-003-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-buildonly-randconfig-004-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-005-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-006-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-061-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-062-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-063-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- i386-randconfig-141-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_pin_map_at_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_pin_range_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_gem_create_ioctl()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_dma_buf.c-xe_dma_buf_init_obj()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_pxp_submit.c-allocate_gsc_client_resources()-error:uninitialized-symbol-bo-.
|   `-- drivers-gpu-drm-xe-xe_vm.c-new_vma()-error:uninitialized-symbol-vma-.
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
|-- loongarch-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- loongarch-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_loongson.c:error:incompatible-function-pointer-types-initializing-int-(-)(struct-tpm_chip-u8-size_t-size_t)-(aka-int-(-)(struct-tpm_chip-unsigned-char-unsigned-long-unsigned-long)
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- m68k-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-randconfig-r111-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-randconfig-r133-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- mips-linux-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
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
|-- powerpc-lite5200b_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- powerpc-randconfig-003-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc64-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- powerpc64-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc64-randconfig-003-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- riscv-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- s390-debug_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- s390-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-rsk7264_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-alldefconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc64-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
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
|-- um-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-002-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-r121-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|-- x86_64-buildonly-randconfig-001-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-buildonly-randconfig-003-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-buildonly-randconfig-004-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- x86_64-buildonly-randconfig-005-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- x86_64-buildonly-randconfig-006-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-121-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-122-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-123-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- fs-btrfs-extent_io.c-find_lock_delalloc_range()-error:we-previously-assumed-fs_info-could-be-null-(see-line-)
|   `-- kernel-power-energy_model.c-em_dev_register_pd_no_update()-error:we-previously-assumed-dev-em_pd-could-be-null-(see-line-)
|-- x86_64-randconfig-r122-20250927
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-rhel-9.4-rust
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-i3c-master-adi-i3c-master.c:warning:variable-m-set-but-not-used
|   |-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- xtensa-randconfig-001-20250927
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
`-- xtensa-randconfig-002-20250927
    |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
    `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET

elapsed time: 746m

configs tested: 159
configs skipped: 5

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250927    gcc-10.5.0
arc                   randconfig-002-20250927    gcc-13.4.0
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                          exynos_defconfig    clang-22
arm                          gemini_defconfig    clang-20
arm                   randconfig-001-20250927    clang-18
arm                   randconfig-002-20250927    clang-16
arm                   randconfig-003-20250927    gcc-8.5.0
arm                   randconfig-004-20250927    gcc-10.5.0
arm                        spear3xx_defconfig    clang-17
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250927    gcc-8.5.0
arm64                 randconfig-002-20250927    gcc-11.5.0
arm64                 randconfig-003-20250927    clang-22
arm64                 randconfig-004-20250927    gcc-9.5.0
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250927    gcc-15.1.0
csky                  randconfig-002-20250927    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250927    clang-22
hexagon               randconfig-002-20250927    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250927    clang-20
i386        buildonly-randconfig-002-20250927    gcc-14
i386        buildonly-randconfig-003-20250927    clang-20
i386        buildonly-randconfig-004-20250927    clang-20
i386        buildonly-randconfig-005-20250927    gcc-12
i386        buildonly-randconfig-006-20250927    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250927    gcc-15.1.0
loongarch             randconfig-002-20250927    clang-18
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
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250927    gcc-9.5.0
nios2                 randconfig-002-20250927    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250927    gcc-9.5.0
parisc                randconfig-002-20250927    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                          allyesconfig    gcc-15.1.0
powerpc                   lite5200b_defconfig    clang-22
powerpc               randconfig-001-20250927    gcc-13.4.0
powerpc               randconfig-002-20250927    clang-22
powerpc               randconfig-003-20250927    gcc-8.5.0
powerpc64             randconfig-001-20250927    clang-22
powerpc64             randconfig-002-20250927    gcc-15.1.0
powerpc64             randconfig-003-20250927    gcc-12.5.0
riscv                            allmodconfig    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250927    clang-22
riscv                 randconfig-002-20250927    gcc-15.1.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                          debug_defconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250927    clang-22
s390                  randconfig-002-20250927    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250927    gcc-15.1.0
sh                    randconfig-002-20250927    gcc-15.1.0
sh                          rsk7264_defconfig    gcc-15.1.0
sparc                            alldefconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250927    gcc-11.5.0
sparc                 randconfig-002-20250927    gcc-11.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250927    gcc-15.1.0
sparc64               randconfig-002-20250927    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250927    gcc-14
um                    randconfig-002-20250927    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250927    gcc-14
x86_64      buildonly-randconfig-002-20250927    clang-20
x86_64      buildonly-randconfig-003-20250927    clang-20
x86_64      buildonly-randconfig-004-20250927    gcc-14
x86_64      buildonly-randconfig-005-20250927    gcc-14
x86_64      buildonly-randconfig-006-20250927    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250927    gcc-8.5.0
xtensa                randconfig-002-20250927    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

