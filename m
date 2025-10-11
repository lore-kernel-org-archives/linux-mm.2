Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A939CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 03:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CAA8E0011; Fri, 10 Oct 2025 23:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C628E000E; Fri, 10 Oct 2025 23:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4038E0011; Fri, 10 Oct 2025 23:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EABE8E000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 23:51:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD17759386
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:51:15 +0000 (UTC)
X-FDA: 83984458110.17.4D77947
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4816140010
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:51:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ME+ZW1MR;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760154674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/U20gycZVipjlK4HTfuuX9XaQ7xH/+zLh3TGI3AoOhU=;
	b=hSEwZUlB/6RQGEe7It60FIxRO7MG80nXiWCjJCKkZXiKZvB27PDrCkfxTljb/sdQredGjG
	qaWTAnIMD0eDUABCnekx/VKvPaGyCGgqhyxh7cMgVHmXQhd6/+LKKfdk2d31KHgD9k+Y3u
	pCWj7PkJAuQV0UMVgEMElSHO45I/dzw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ME+ZW1MR;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760154674; a=rsa-sha256;
	cv=none;
	b=xfqprAurayk615ZSX+sF7K0YK14/qejikFu0Kyj6civ4PzmwsceqSTy3WSD168XEckf5YF
	Is4IQ63SH48coUqCFQO7preLuG+jvSggUj7GFvyp1QER2PecO9TxanMqVd4yMULomrPC9+
	C0xDkJ6GQtejuOsSqThlqwQufOsu2rQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760154673; x=1791690673;
  h=date:from:to:cc:subject:message-id;
  bh=U7Sli1+6MhJjtsV5owgoct+UFJzZ6Z0A1DeGADW2W88=;
  b=ME+ZW1MRQdl/FFHfcSdyQ90hr/D0wl/ahr8wZ73TVVEZOouUHjDU5SFy
   raPVh8Sw30aUOQNnlCEbIwWONxzcKkHtI5hz73QApYkCF/zEbK/VT+q3x
   OIiwD/RVFkIl0KmV3yuThuPhRwbPDefzDEia45PIM9m5J7VDgYkoz1Kzr
   wVjKmzp3tb+8iFH0PXkrOfmvgQ3A1LuCUS0bhxv+dC6dU4Q+HZmdSBM7X
   uH9nfN0HvJ60xzowq+jdYqmHAiK6x6hOzXj3IhW6tMa16NUkpMBD/nM8y
   IwqOIWDiFOVTDvuDAbwbLazDI9i0JvnGLzzB2pQMrJdVmmtutUSjrni0W
   w==;
X-CSE-ConnectionGUID: chBu7NtZT2+RAqL9SIVUHw==
X-CSE-MsgGUID: KX6AH+UmSqy0LEq/ozT/oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62528264"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62528264"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 20:51:11 -0700
X-CSE-ConnectionGUID: e1u+xjfhTqiF1q0A9D+c2g==
X-CSE-MsgGUID: QzMaMwrHQoiCOGtbYDodAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="186409469"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 10 Oct 2025 20:51:07 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7QdM-0003V5-1o;
	Sat, 11 Oct 2025 03:51:04 +0000
Date: Sat, 11 Oct 2025 11:50:35 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 2b763d4652393c90eaa771a5164502ec9dd965ae
Message-ID: <202510111155.jKQ9FpwX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4816140010
X-Stat-Signature: f4e34ydy6eujpks78kkh811inoszxcj8
X-Rspam-User: 
X-HE-Tag: 1760154672-952301
X-HE-Meta: U2FsdGVkX1+a2FzyuMItHym7A5PJ5OC5uKd6GvIIgmO51KQrWFiaoJOuj68HDhD3hFHlgm41YbVwIBmr1+xMlNLxMkUQansjfexVWYabxUAgEpiDwBF0a6h5mDe+mI6c0Rto5bUBtV64V6lGQmrD78qk8+8TJ2rn23528jLDEqFXGPmMOA/wzh4oTmBXdN4cziMTzc447oEvbL6u2k4rcpS9g0RJ90Ref2+aJ9a4rR6rcwr0DSznSamcUZT5sosE5cZ4MVPD3MGGYMW6KvSn6I3w9onpMap+ZBml4QHmfvRn2RfMy9wAfPNKhCzWufe03ZARmwN5sOgNSWrn+rS9iDZQNywOUaawdApzYvNrM/ixmNgqHWJAQglBrgyfbJ+Msh2FhywsQ0u5fu7CqJ3A63rwWzqt99AKYRFAV0+XdEIObiH4UIc+m6PGycK46JzAfgwyTlbqdG1DcdmXJw4KUmLplkRg5ExMy+srFVW5ks4wvwXzk93D4leFJBMtrG4piNcnIeYv92UVBe2NZCpdLjvzGvvKVmJozS5SbpycFbmUPxEV7thWENNhpOPk3xCaGUAKefY1jD79Hc7+8THliJqLL5RMM0eKB9N36QFxWZ8KFx4M9kmnOHTNpsBcdICp0kD1pyfHuzQI8lhBe4o+EfH7FeiZN0dPHbgMw1b6q5MTxKcrJ6/zIKNvkdcWrDT8HIDmdRGWbMHe7c7sJdEzmPyBowgUC35Pt/9sojPcNzLSLtqhQHpdWDt0911dFYFmqo0Zc+f5RVuj9xO72LybCAU4VvlsOJBpn8r1kjVqs1I3UR4NNpFrULf98yIE6sevbc1tk1weU/jb0zLJduWqxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 2b763d4652393c90eaa771a5164502ec9dd965ae  Add linux-next specific files for 20251010

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509181807.I4frBSXx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509190923.UgSxMzx5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509192136.CR5pSGKJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509200214.i2QX7iwD-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509231815.d1EjWp8Y-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509251326.SYA3QL9j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509252250.uv5q12aK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510031615.GardRYTk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510032336.PjyL10gR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510040140.njOfkDkC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510040434.KzlnjhdR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510110109.hIUbuESQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510110331.X9JFTlLK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510100941.GZGMq64U-lkp@intel.com

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
    drivers/hwmon/gpd-fan.c:231:9: error: implicit declaration of function 'outb' [-Wimplicit-function-declaration]
    drivers/hwmon/gpd-fan.c:244:16: error: implicit declaration of function 'inb' [-Wimplicit-function-declaration]
    fs/smb/client/inode.c:1813:13: warning: variable 'sillyname_len' set but not used [-Wunused-but-set-variable]
    fs/smb/client/inode.c:1813:6: warning: variable 'sillyname_len' set but not used [-Wunused-but-set-variable]
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: "hid_haptic_check_pressure_unit" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_feature_mapping" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_init" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_input_configured" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_input_mapping" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_pressure_increase" [drivers/hid/hid-multitouch.ko] undefined!
    ERROR: modpost: "hid_haptic_pressure_reset" [drivers/hid/hid-multitouch.ko] undefined!
    kernel/liveupdate/kexec_handover.c:1335 kho_release_scratch() warn: iterator 'i' not incremented
    kernel/liveupdate/kexec_handover.c:978 kho_preserve_vmalloc() warn: missing error code 'err'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arm-allmodconfig
|   |-- ERROR:__ffsdi2-drivers-spi-spi-amlogic-spifc-a4.ko-undefined
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- arm-allyesconfig
|   |-- arm-linux-gnueabi-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- arm-qcom_defconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- arm-randconfig-051-20251010
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
|-- arm-randconfig-052-20251010
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
|-- arm-randconfig-053-20251010
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
|-- arm-randconfig-054-20251010
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
|-- arm-randconfig-055-20251010
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
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- arm64-randconfig-051-20251010
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
|-- arm64-randconfig-052-20251010
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
|-- arm64-randconfig-053-20251010
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
|-- arm64-randconfig-054-20251010
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
|-- arm64-randconfig-055-20251010
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
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- hexagon-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-buildonly-randconfig-005-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-buildonly-randconfig-006-20251010
|   |-- drivers-hwmon-gpd-fan.c:error:implicit-declaration-of-function-inb
|   `-- drivers-hwmon-gpd-fan.c:error:implicit-declaration-of-function-outb
|-- i386-randconfig-001-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-002-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-005-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-006-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-007-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-011-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-012-20251010
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-012-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-014-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-015-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-016-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-017-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-061-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-062-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- i386-randconfig-063-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- loongarch-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- loongarch-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- loongarch-defconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- m68k-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- m68k-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- m68k-defconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- microblaze-allmodconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   |-- mips-linux-ld:spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|   `-- spi-amlogic-spifc-a4.c:(.text.aml_sfc_set_bus_width):undefined-reference-to-__ffsdi2
|-- openrisc-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allmodconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- powerpc-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- powerpc-ps3_defconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- riscv-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- riscv-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- s390-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- s390-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- s390-defconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- sh-allmodconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allmodconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-randconfig-002-20251010
|   |-- ERROR:hid_haptic_check_pressure_unit-drivers-hid-hid-multitouch.ko-undefined
|   |-- ERROR:hid_haptic_feature_mapping-drivers-hid-hid-multitouch.ko-undefined
|   |-- ERROR:hid_haptic_init-drivers-hid-hid-multitouch.ko-undefined
|   |-- ERROR:hid_haptic_input_configured-drivers-hid-hid-multitouch.ko-undefined
|   |-- ERROR:hid_haptic_input_mapping-drivers-hid-hid-multitouch.ko-undefined
|   |-- ERROR:hid_haptic_pressure_increase-drivers-hid-hid-multitouch.ko-undefined
|   `-- ERROR:hid_haptic_pressure_reset-drivers-hid-hid-multitouch.ko-undefined
|-- um-allmodconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- um-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-allyesconfig
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-kexec
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-001-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-002-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-004-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-005-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-006-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-007-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-008-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-072-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-073-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-074-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-075-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-076-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-077-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-121-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-122-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-123-20251011
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-randconfig-161-20251010
|   |-- kernel-liveupdate-kexec_handover.c-kho_preserve_vmalloc()-warn:missing-error-code-err
|   `-- kernel-liveupdate-kexec_handover.c-kho_release_scratch()-warn:iterator-i-not-incremented
|-- x86_64-rhel-9.4
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-rhel-9.4-func
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-rhel-9.4-kselftests
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- x86_64-rhel-9.4-rust
|   `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|-- xtensa-allyesconfig
|   |-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
`-- xtensa-randconfig-001-20251011
    `-- fs-smb-client-inode.c:warning:variable-sillyname_len-set-but-not-used

elapsed time: 872m

configs tested: 268
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
arc                          axs101_defconfig    clang-22
arc                                 defconfig    clang-19
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251010    gcc-12.5.0
arc                   randconfig-001-20251011    clang-22
arc                   randconfig-002-20251010    gcc-8.5.0
arc                   randconfig-002-20251011    clang-22
arm                              allmodconfig    clang-19
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-19
arm                                 defconfig    clang-22
arm                            qcom_defconfig    clang-22
arm                   randconfig-001-20251010    gcc-8.5.0
arm                   randconfig-001-20251011    clang-22
arm                   randconfig-002-20251010    gcc-13.4.0
arm                   randconfig-002-20251011    clang-22
arm                   randconfig-003-20251010    gcc-8.5.0
arm                   randconfig-003-20251011    clang-22
arm                   randconfig-004-20251010    gcc-8.5.0
arm                   randconfig-004-20251011    clang-22
arm                           stm32_defconfig    clang-22
arm                           tegra_defconfig    clang-22
arm                         wpcm450_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251010    gcc-14.3.0
arm64                 randconfig-001-20251011    clang-22
arm64                 randconfig-002-20251010    clang-19
arm64                 randconfig-002-20251011    clang-22
arm64                 randconfig-003-20251010    clang-17
arm64                 randconfig-003-20251011    clang-22
arm64                 randconfig-004-20251010    gcc-15.1.0
arm64                 randconfig-004-20251011    clang-22
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251010    gcc-15.1.0
csky                  randconfig-001-20251011    gcc-8.5.0
csky                  randconfig-002-20251010    gcc-10.5.0
csky                  randconfig-002-20251011    gcc-8.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251010    clang-22
hexagon               randconfig-001-20251011    gcc-8.5.0
hexagon               randconfig-002-20251010    clang-18
hexagon               randconfig-002-20251011    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    clang-20
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251010    gcc-14
i386        buildonly-randconfig-001-20251011    clang-20
i386        buildonly-randconfig-002-20251010    clang-20
i386        buildonly-randconfig-002-20251011    clang-20
i386        buildonly-randconfig-003-20251010    clang-20
i386        buildonly-randconfig-003-20251011    clang-20
i386        buildonly-randconfig-004-20251010    gcc-14
i386        buildonly-randconfig-004-20251011    clang-20
i386        buildonly-randconfig-005-20251010    gcc-14
i386        buildonly-randconfig-005-20251011    clang-20
i386        buildonly-randconfig-006-20251010    gcc-14
i386        buildonly-randconfig-006-20251011    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251011    gcc-14
i386                  randconfig-002-20251011    gcc-14
i386                  randconfig-003-20251011    gcc-14
i386                  randconfig-004-20251011    gcc-14
i386                  randconfig-005-20251011    gcc-14
i386                  randconfig-006-20251011    gcc-14
i386                  randconfig-007-20251011    gcc-14
i386                  randconfig-011-20251011    clang-20
i386                  randconfig-012-20251011    clang-20
i386                  randconfig-013-20251011    clang-20
i386                  randconfig-014-20251011    clang-20
i386                  randconfig-015-20251011    clang-20
i386                  randconfig-016-20251011    clang-20
i386                  randconfig-017-20251011    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251010    clang-22
loongarch             randconfig-001-20251011    gcc-8.5.0
loongarch             randconfig-002-20251010    gcc-15.1.0
loongarch             randconfig-002-20251011    gcc-8.5.0
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
mips                        omega2p_defconfig    clang-22
mips                           xway_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20251010    gcc-11.5.0
nios2                 randconfig-001-20251011    gcc-8.5.0
nios2                 randconfig-002-20251010    gcc-9.5.0
nios2                 randconfig-002-20251011    gcc-8.5.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-14
openrisc                            defconfig    gcc-15.1.0
openrisc                       virt_defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251010    gcc-8.5.0
parisc                randconfig-001-20251011    gcc-8.5.0
parisc                randconfig-002-20251010    gcc-12.5.0
parisc                randconfig-002-20251011    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     mpc5200_defconfig    clang-22
powerpc                         ps3_defconfig    clang-22
powerpc               randconfig-001-20251010    clang-22
powerpc               randconfig-001-20251011    gcc-8.5.0
powerpc               randconfig-002-20251010    gcc-15.1.0
powerpc               randconfig-002-20251011    gcc-8.5.0
powerpc               randconfig-003-20251010    clang-22
powerpc               randconfig-003-20251011    gcc-8.5.0
powerpc64             randconfig-001-20251010    clang-22
powerpc64             randconfig-001-20251011    gcc-8.5.0
powerpc64             randconfig-002-20251010    gcc-14.3.0
powerpc64             randconfig-002-20251011    gcc-8.5.0
powerpc64             randconfig-003-20251010    gcc-13.4.0
powerpc64             randconfig-003-20251011    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-14
riscv                 randconfig-001-20251010    clang-22
riscv                 randconfig-001-20251011    clang-22
riscv                 randconfig-002-20251010    gcc-9.5.0
riscv                 randconfig-002-20251011    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-14
s390                  randconfig-001-20251010    gcc-14.3.0
s390                  randconfig-001-20251011    clang-22
s390                  randconfig-002-20251010    clang-22
s390                  randconfig-002-20251011    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                        edosk7760_defconfig    gcc-15.1.0
sh                            hp6xx_defconfig    gcc-15.1.0
sh                    randconfig-001-20251010    gcc-15.1.0
sh                    randconfig-001-20251011    clang-22
sh                    randconfig-002-20251010    gcc-15.1.0
sh                    randconfig-002-20251011    clang-22
sh                           se7750_defconfig    clang-22
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251010    gcc-11.5.0
sparc                 randconfig-001-20251011    clang-22
sparc                 randconfig-002-20251010    gcc-8.5.0
sparc                 randconfig-002-20251011    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251010    clang-20
sparc64               randconfig-001-20251011    clang-22
sparc64               randconfig-002-20251010    gcc-10.5.0
sparc64               randconfig-002-20251011    clang-22
um                               alldefconfig    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251010    gcc-14
um                    randconfig-001-20251011    clang-22
um                    randconfig-002-20251010    gcc-14
um                    randconfig-002-20251011    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251010    clang-20
x86_64      buildonly-randconfig-001-20251011    clang-20
x86_64      buildonly-randconfig-002-20251010    clang-20
x86_64      buildonly-randconfig-002-20251011    clang-20
x86_64      buildonly-randconfig-003-20251010    clang-20
x86_64      buildonly-randconfig-003-20251011    clang-20
x86_64      buildonly-randconfig-004-20251010    clang-20
x86_64      buildonly-randconfig-004-20251011    clang-20
x86_64      buildonly-randconfig-005-20251010    gcc-14
x86_64      buildonly-randconfig-005-20251011    clang-20
x86_64      buildonly-randconfig-006-20251010    gcc-14
x86_64      buildonly-randconfig-006-20251011    clang-20
x86_64                              defconfig    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251011    gcc-14
x86_64                randconfig-002-20251011    gcc-14
x86_64                randconfig-003-20251011    gcc-14
x86_64                randconfig-004-20251011    gcc-14
x86_64                randconfig-005-20251011    gcc-14
x86_64                randconfig-006-20251011    gcc-14
x86_64                randconfig-007-20251011    gcc-14
x86_64                randconfig-008-20251011    gcc-14
x86_64                randconfig-071-20251011    clang-20
x86_64                randconfig-072-20251011    clang-20
x86_64                randconfig-073-20251011    clang-20
x86_64                randconfig-074-20251011    clang-20
x86_64                randconfig-075-20251011    clang-20
x86_64                randconfig-076-20251011    clang-20
x86_64                randconfig-077-20251011    clang-20
x86_64                randconfig-078-20251011    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251010    gcc-8.5.0
xtensa                randconfig-001-20251011    clang-22
xtensa                randconfig-002-20251010    gcc-9.5.0
xtensa                randconfig-002-20251011    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

