Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F189DC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 19:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702936B008A; Tue, 29 Jul 2025 15:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC316B008C; Tue, 29 Jul 2025 15:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489966B0092; Tue, 29 Jul 2025 15:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25F746B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:11:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4AF7C0221
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:11:03 +0000 (UTC)
X-FDA: 83718244806.21.07F0D70
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf23.hostedemail.com (Postfix) with ESMTP id 075D414000D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:10:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CxVd4aXa;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753816261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q6CtXu+FK6cdXvX38U1qsYTEMdDqOsgLMRMboCME4rY=;
	b=6B/3baMfJJJOmaf8LE7ocIcFvqdpVhjkr6vNAD8RU7pELLxBHIxG5n4c2LRnm59Q9KMKeV
	4UcG/fP9FuV3NU8B9+PSVaQ5DZB2dPj5PL9L7r/9a1WvIw8+34bg4QJcpXwZkfFlsc4lbe
	3wAL01HZdPMfAENYL6Lid8ZN0p/4OMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753816261; a=rsa-sha256;
	cv=none;
	b=yBZYq4i4z7yZVE221QyRS2Fz8l84AUOI3OItd1IxpEAmJfrcdHT+5MEImiaMKzgCF21k/b
	fMcp3C1GurwrWTLITAyNEV5sTGmPOjaWL3oNZxujKRT+D9uToFh9Z8tPTrbNsLMCvLPH7T
	HzKSNcpC5zjDdePaGCKkmsssPhn9WiU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CxVd4aXa;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753816260; x=1785352260;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=LUJ+QlQteGFc4GyqpNimFDfwNVAm5z8IFRUIzDxK9ls=;
  b=CxVd4aXa5CZBTeu4knjJmgidrRYDuEywTO9GDYjBboT5PYwPR50mOvGq
   XH/7WeOpx5a0OJOjuIW+L7J+oWt08Qao7FDXRE40gOWxm1Pk1KLS6N/GP
   KFXNjXr9L8q4CU6A0Ub8o6oXIjry+AEWmvZ4Ar08FzF7YevRkV+UaWIkP
   EekM6BXBwGdPDmSJLA3AO45kE4xGqbMREaCQhkflktj0B0JVomVLdcsjN
   J7/Q7aiWS+rV6Qul/TlUepA3pXib2RTD0EQgUgdFeq0JIq7+TWnRKERka
   yCqnSTYagVyIcXj7sHYKtVlg9Ep9ot+7YeKUIc+WF0EbXr2rWBZ/nrNCw
   A==;
X-CSE-ConnectionGUID: KovXgPCBSq+NQhZg+7H6pQ==
X-CSE-MsgGUID: p+6zpUbzRMaax7lfCEimNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="59748337"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="59748337"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 12:10:58 -0700
X-CSE-ConnectionGUID: pe4t8E0TQIiNVFxdW/NpRQ==
X-CSE-MsgGUID: IW8AUZ8WRqyl1WNdTv0NfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="193780604"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 29 Jul 2025 12:10:56 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugpiv-0001b9-2m;
	Tue, 29 Jul 2025 19:10:53 +0000
Date: Wed, 30 Jul 2025 03:10:23 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 54efec8782214652b331c50646013f8526570e8d
Message-ID: <202507300340.BQx07lUx-lkp@intel.com>
User-Agent: s-nail v14.9.24
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 075D414000D
X-Stat-Signature: bcmcorhbp1s93eishrbtxgo69a7gcfap
X-Rspam-User: 
X-HE-Tag: 1753816259-499650
X-HE-Meta: U2FsdGVkX184E+e9xqwajKx3nD2tutP1rl8lVPbctQmUs+axd7U5FMrkyIPvwkyE2blU0OH7hf0sg8N0iDbhlAc24bxEHQP3fH5n3+s8S4R9g4gmQkgISPQ/k/aeSVf7JimaALUOoqH2ccjSHckRflXrbwTh9DrdQs1Q6x1xUWiIqksOW7YpyxP8FYs7Rpu2lKVr0km63Bzrp7SW8l6BcNqkO6d8tOxDhYhYXcdSgmMNcgkdDLZqRm5kUEuAHf1mwKod+7kPXHvnvLlmSms2E9gfDpmAHnrLR3Fw3N49r92Qw0ouzzKtK9cSHJG0nRxiL2vtmSe2re70p1S+uaMetM3/5dHIvPYn+q6Z6sCRXvEEdMG7pW8FIrJcKHTC+48vOp/qjiMJwsyQWx0wkuoViR7iPam7DsjUMXb8L1ESwQwziYUszkKMNtEmCnTzvhPtVNRvMxejMAqK8m2YMM1k1DN8NPdd7ouB3ImEqF2yh+C7atCj89MzFvbcB2ZPP39K0Ppl5pR9U7lEpG4n6vwFaZVNlcIExgKwH/K8/7SNzzTw/IYmQWPEm/Mmewl57fuY5iSPfTYwzRqjFOc0CX9bmEI6wXcr5D+A4n+xLFmLbGE/R9yEheJUO8S7AuV20HW/UdN0qGihpaRXAV5LSZr0eFT8l4dOmRPZ3Yhr50ZTSnwvlXQQkK8iLnN2KDCGOUlWV9L1yW4ziPpiSzWSj/7JL6vF5QrXeXGxvsJGGcPOb/2gb5vm2QNrC9jLDmJWkaHt43DsfN69sPpBk6VC6XCRU1ylBclNS+ocprv5Rckw0CIwOoJcZjW53XkKzQvR+3VesxgYmifIvgugPxKcFWOmzjz/sXrbBz5Xs1Dye8kXgPgD2mlmhCyvCG/++WM1OxAL+CeQY71YX8k9mm5j7DIZPXPMqynXJTxY8xbGIPmzI3rIHVC+Uvu0qH+lqxEqvp76WQI0fQO+9h5Ywn/pj0B
 vjQI+S2b
 5MbD95Xl1XaeShHsS8WR5+WIVTGdtG0k+pSVpmJFYzTUQFQRyqT8Ykmz2NrTwjowu4614NuKKth79pcOUZo/oREqGqPd4WBtQp5FaoVs7EhsB9WP4FVGsdoDB5mTKemBeFZzNTsCg4fzDrsEj5ulRrT9p045KRLlK5PbUyhAx1DMquAX4W2DCwVm9R04LS2P6k/cINDFPcHgFdx49P5x7W+ELkw1+0VqrObHtuBnJ9Rn0Z9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git master
branch HEAD: 54efec8782214652b331c50646013f8526570e8d  Add linux-next speci=
fic files for 20250729

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507032251.5766L2PU-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507040730.OxedSKJE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507051753.jjZiUKrI-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507110920.eBMJaHSX-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507212021.dc1RGBxE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220705.n9m6UpDd-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507242212.lrePIIjT-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507291837.Eao18ixU-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild/202507141415.H677CuC5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507281810.It1bDuo3-lkp@intel.com

    (.init.text+0x9722): undefined reference to `efi_memblock_x86_reserve_r=
ange'
    ERROR: modpost: "__devm_regmap_init_i3c" [drivers/hwmon/tmp108.ko] unde=
fined!
    ERROR: modpost: "i3c_device_do_priv_xfers" [drivers/hwmon/lm75.ko] unde=
fined!
    ERROR: modpost: "i3c_device_match_id" [drivers/hwmon/lm75.ko] undefined!
    ERROR: modpost: "i3cdev_to_dev" [drivers/hwmon/lm75.ko] undefined!
    ERROR: modpost: "i3cdev_to_dev" [drivers/hwmon/tmp108.ko] undefined!
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911=
): 'pmic-sleep-hog', 'wakeup-source' do not match any of the regexes: '^(vc=
c(io|[1-7])-supply)$', '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911=
): regulators:vddctrl: Unevaluated properties are not allowed ('nvidia,tegr=
a-cpu-regulator' was unexpected)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dtb: pinctrl@80018000 (fsl,=
imx28-pinctrl): 'auart0-2pins@0', 'auart0@0', 'auart1-2pins@0', 'auart1@0',=
 'auart2-2pins@0', 'auart2-2pins@1', 'auart2-pins@0', 'auart3-2pins@0', 'au=
art3-2pins@1', 'auart3@0', 'auart4@0', 'auart4@1', 'can0@0', 'can1@0', 'dua=
rt-4pins@0', 'duart@0', 'duart@1', 'edt-ft5x06-wake@0', 'edt-ft5x06@0', 'fe=
c-3v3-enable@0', 'gpmi-nand@0', 'gpmi-status-cfg@0', 'hog@0', 'i2c0@0', 'i2=
c0@1', 'i2c1@0', 'i2c1@1', 'lcdif-16bit@0', 'lcdif-18bit@0', 'lcdif-24bit@0=
', 'lcdif-sync@0', 'leds@0', 'mac0@0', 'mac0@1', 'mac1@0', 'mmc0-4bit@0', '=
mmc0-8bit@0', 'mmc0-cd-cfg@0', 'mmc0-sck-cfg@0', 'mmc1-4bit@0', 'mmc1-cd-cf=
g@0', 'mmc1-sck-cfg@0', 'mmc2-4bit@0', 'mmc2-4bit@1', 'mmc2-cd-cfg@0', 'mmc=
2-sck-cfg@0', 'mmc2-sck-cfg@1', 'pwm0@0', 'pwm2@0', 'pwm3@0', 'pwm3@1', 'pw=
m4@0', 'pwm7@0', 'saif0@0', 'saif0@1', 'saif1@0', 'spi2@0', 'spi3@0', 'spi3=
@1', 'usb0-vbus-enable@0', 'usb0@0', 'usb0@1', 'usb0id1@0', 'usb0id@0', 'us=
b1-vbus-enable@0', 'usb1@0', 'usb1@1' do not match any of the regexes: '^pi=
nctrl-[0-9]+$', 'gpio@[0-9]+$'
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dtb: pinctrl@80018000 (fsl,=
imx28-pinctrl): compatible: ['fsl,imx28-pinctrl', 'simple-bus'] is too long
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/hog@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/leds@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:200.32-209.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06@0: duplicate unit-address (also used in node /apb@8000000=
0/apbh-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:211.41-217.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06-wake@0: duplicate unit-address (also used in node /apb@80=
000000/apbh-bus@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:211.41-217.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06-wake@0: duplicate unit-address (also used in node /apb@80=
000000/apbh-bus@80000000/pinctrl@80018000/hog@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:211.41-217.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06-wake@0: duplicate unit-address (also used in node /apb@80=
000000/apbh-bus@80000000/pinctrl@80018000/leds@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:211.41-217.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06-wake@0: duplicate unit-address (also used in node /apb@80=
000000/apbh-bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:211.41-217.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/edt-ft5x06-wake@0: duplicate unit-address (also used in node /apb@80=
000000/apbh-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:219.39-225.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/fec-3v3-enable@0: duplicate unit-address (also used in node /apb@800=
00000/apbh-bus@80000000/pinctrl@80018000/hog@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:219.39-225.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/fec-3v3-enable@0: duplicate unit-address (also used in node /apb@800=
00000/apbh-bus@80000000/pinctrl@80018000/leds@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:219.39-225.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/fec-3v3-enable@0: duplicate unit-address (also used in node /apb@800=
00000/apbh-bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:219.39-225.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/fec-3v3-enable@0: duplicate unit-address (also used in node /apb@800=
00000/apbh-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:227.20-235.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/hog@0: duplicate unit-address (also used in node /apb@80000000/apbh-=
bus@80000000/pinctrl@80018000/leds@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:227.20-235.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/hog@0: duplicate unit-address (also used in node /apb@80000000/apbh-=
bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:227.20-235.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/hog@0: duplicate unit-address (also used in node /apb@80000000/apbh-=
bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:237.20-247.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/leds@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:237.20-247.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/leds@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dts:249.43-255.4: Warning (=
unique_unit_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80=
018000/usb0-vbus-enable@0: duplicate unit-address (also used in node /apb@8=
0000000/apbh-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:166.19-174.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpio=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:166.19-174.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpio=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:166.19-174.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpio=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:166.19-174.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpio=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:166.19-174.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpio=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:216.27-225.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:216.27-225.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:216.27-225.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:216.27-225.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:216.27-225.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:238.34-249.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t-4pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:238.34-249.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t-4pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:238.34-249.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t-4pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:238.34-249.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t-4pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:238.34-249.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/duar=
t-4pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:251.30-273.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-nand@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:251.30-273.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-nand@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:251.30-273.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-nand@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:251.30-273.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-nand@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:251.30-273.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-nand@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:275.40-283.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-status-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:275.40-283.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-status-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:275.40-283.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-status-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:275.40-283.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-status-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:275.40-283.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/gpmi=
-status-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh=
-bus@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:285.29-296.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:285.29-296.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:285.29-296.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:285.29-296.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:285.29-296.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:298.36-307.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:298.36-307.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:298.36-307.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:298.36-307.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:298.36-307.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t0-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:309.29-320.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:309.29-320.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:309.29-320.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:309.29-320.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:309.29-320.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:322.36-331.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:322.36-331.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:322.36-331.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:322.36-331.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:322.36-331.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t1-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:333.36-342.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:333.36-342.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:333.36-342.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:333.36-342.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:333.36-342.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:355.34-366.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:355.34-366.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:355.34-366.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:355.34-366.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:355.34-366.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t2-pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:368.29-379.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:368.29-379.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:368.29-379.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:368.29-379.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:368.29-379.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:381.36-390.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:381.36-390.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:381.36-390.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:381.36-390.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:381.36-390.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t3-2pins@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:403.30-412.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t4@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:403.30-412.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t4@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:403.30-412.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t4@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:403.30-412.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t4@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:403.30-412.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/auar=
t4@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:425.25-441.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:425.25-441.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:425.25-441.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:425.25-441.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:425.25-441.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:469.25-482.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:469.25-482.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:469.25-482.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:469.25-482.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:469.25-482.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mac1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:484.35-502.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-8bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:484.35-502.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-8bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:484.35-502.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-8bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:484.35-502.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-8bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:484.35-502.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-8bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:504.35-518.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:504.35-518.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:504.35-518.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:504.35-518.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:504.35-518.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:520.32-526.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:520.32-526.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:520.32-526.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:520.32-526.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:520.32-526.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:528.34-535.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:528.34-535.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:528.34-535.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:528.34-535.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:528.34-535.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc0=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:537.35-551.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:537.35-551.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:537.35-551.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:537.35-551.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:537.35-551.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:553.32-559.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:553.32-559.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:553.32-559.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:553.32-559.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:553.32-559.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:561.34-568.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:561.34-568.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:561.34-568.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:561.34-568.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:561.34-568.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc1=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:571.35-585.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:571.35-585.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:571.35-585.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:571.35-585.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:571.35-585.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-4bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8=
0000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:603.32-609.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:603.32-609.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:603.32-609.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:603.32-609.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:603.32-609.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-cd-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:611.36-618.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:611.36-618.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:611.36-618.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:611.36-618.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:611.36-618.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/mmc2=
-sck-cfg@0: duplicate unit-address (also used in node /apb@80000000/apbh-bu=
s@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:629.25-638.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:629.25-638.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:629.25-638.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:629.25-638.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:629.25-638.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:651.25-660.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:651.25-660.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:651.25-660.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:651.25-660.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:651.25-660.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/i2c1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:673.27-684.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:673.27-684.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:673.27-684.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:673.27-684.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:673.27-684.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
0@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:698.27-706.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:698.27-706.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:698.27-706.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:698.27-706.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:698.27-706.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/saif=
1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@80000=
000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:708.25-716.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:708.25-716.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:708.25-716.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:708.25-716.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:708.25-716.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:718.25-726.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:718.25-726.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:718.25-726.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:718.25-726.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:718.25-726.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:728.25-736.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:728.25-736.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:728.25-736.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:728.25-736.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:728.25-736.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:748.25-756.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm4=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:748.25-756.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm4=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:748.25-756.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm4=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:748.25-756.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm4=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:748.25-756.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm4=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:758.25-766.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm7=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:758.25-766.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm7=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:758.25-766.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm7=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:758.25-766.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm7=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:758.25-766.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/pwm7=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:768.39-799.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-24bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:768.39-799.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-24bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:768.39-799.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-24bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:768.39-799.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-24bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:768.39-799.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-24bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:801.39-826.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-18bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:801.39-826.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-18bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:801.39-826.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-18bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:801.39-826.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-18bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:801.39-826.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-18bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:828.39-851.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-16bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:828.39-851.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-16bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:828.39-851.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-16bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:828.39-851.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-16bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:828.39-851.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-16bit@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus=
@80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:853.37-864.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-sync@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@=
80000000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:853.37-864.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-sync@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@=
80000000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:853.37-864.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-sync@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@=
80000000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:853.37-864.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-sync@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@=
80000000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:853.37-864.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/lcdi=
f-sync@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@=
80000000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:866.25-875.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:866.25-875.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:866.25-875.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:866.25-875.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:866.25-875.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:877.25-886.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:877.25-886.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:877.25-886.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:877.25-886.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:877.25-886.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/can1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:888.25-899.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:888.25-899.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:888.25-899.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:888.25-899.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:888.25-899.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi2=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:901.25-914.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:901.25-914.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:901.25-914.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:901.25-914.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:901.25-914.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/spi3=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:929.25-937.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:929.25-937.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:929.25-937.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:929.25-937.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:929.25-937.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:949.25-957.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:949.25-957.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:949.25-957.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:949.25-957.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:949.25-957.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb1=
@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800000=
00/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:969.30-977.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:969.30-977.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:969.30-977.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:969.30-977.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:969.30-977.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@8000=
0000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:979.31-987.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800=
00000/pinctrl@80018000/edt-ft5x06-wake@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:979.31-987.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800=
00000/pinctrl@80018000/edt-ft5x06@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:979.31-987.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800=
00000/pinctrl@80018000/fec-3v3-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:979.31-987.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800=
00000/pinctrl@80018000/usb0-vbus-enable@0)
    arch/arm/boot/dts/nxp/mxs/imx28.dtsi:979.31-987.7: Warning (unique_unit=
_address_if_enabled): /apb@80000000/apbh-bus@80000000/pinctrl@80018000/usb0=
id1@0: duplicate unit-address (also used in node /apb@80000000/apbh-bus@800=
00000/pinctrl@80018000/usb1-vbus-enable@0)
    arch/arm64/boot/dts/freescale/imx95-15x15-evk-pcie0-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs=
-tx-deemph-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-15x15-evk-pcie0-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is no=
t of type 'array'
    arch/arm64/boot/dts/freescale/imx95-15x15-evk.dtb: phy@4c1f0040 (fsl,im=
x95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs-tx-deemp=
h-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-15x15-evk.dtb: phy@4c1f0040 (fsl,im=
x95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is not of type=
 'array'
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-pcie0-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs=
-tx-deemph-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-pcie0-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is no=
t of type 'array'
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-pcie1-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs=
-tx-deemph-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-pcie1-ep.dtb: phy@4c1f004=
0 (fsl,imx95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is no=
t of type 'array'
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-sof.dtb: phy@4c1f0040 (fs=
l,imx95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs-tx-d=
eemph-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-19x19-evk-sof.dtb: phy@4c1f0040 (fs=
l,imx95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is not of =
type 'array'
    arch/arm64/boot/dts/freescale/imx95-19x19-evk.dtb: phy@4c1f0040 (fsl,im=
x95-usb-phy): Unevaluated properties are not allowed ('fsl,phy-pcs-tx-deemp=
h-3p5db-attenuation-db' was unexpected)
    arch/arm64/boot/dts/freescale/imx95-19x19-evk.dtb: phy@4c1f0040 (fsl,im=
x95-usb-phy): fsl,phy-pcs-tx-deemph-3p5db-attenuation-db: 17 is not of type=
 'array'
    arch/mips/boot/dts/brcm/bcm97346dbsmb.dtb: memc-ddr@2000 (brcm,brcmstb-=
memc-ddr): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/mips/boot/dts/brcm/bcm97360svmb.dtb: memc-ddr@2000 (brcm,brcmstb-m=
emc-ddr): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/mips/boot/dts/brcm/bcm97362svmb.dtb: memc-ddr@2000 (brcm,brcmstb-m=
emc-ddr): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/mips/boot/dts/brcm/bcm97425svmb.dtb: memc-ddr@2000 (brcm,brcmstb-m=
emc-ddr): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/mips/boot/dts/brcm/bcm97435svmb.dtb: memc-ddr@2000 (brcm,brcmstb-m=
emc-ddr): compatible: 'oneOf' conditional failed, one must be fixed:
    drivers/gpu/drm/msm/msm.o: warning: objtool: submit_lock_objects+0x53b:=
 sibling call from callable instruction with modified stack frame
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2256) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2688) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]
    include/linux/compiler.h:69:46: warning: 'byte' is used uninitialized [=
-Wuninitialized]
    kismet: WARNING: unmet direct dependencies detected for MFD_AT91_USART =
when selected by SERIAL_ATMEL
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 whe=
n selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 whe=
n selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 whe=
n selected by SM_VIDEOCC_6350
    kismet: WARNING: unmet direct dependencies detected for STACKTRACE when=
 selected by STACKDEPOT
    ld: (.init.text+0x9770): undefined reference to `efi_init'
    ld: (.init.text+0x9aa4): undefined reference to `efi_mem_type'
    security/apparmor/lsm.c:182:23: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]
    security/apparmor/lsm.c:182:44: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, kindly check if interested=
):

    arch/s390/crypto/phmac_s390.c:426:17-18: WARNING: Unsigned expression c=
ompared with zero: k > 0
    drivers/acpi/osl.c:210: undefined reference to `efi'
    ld: drivers/acpi/osl.c:210: undefined reference to `efi'
    sound/hda/codecs/generic.c:198 parse_user_hints() warn: assigning (-2) =
to unsigned variable 'spec->mixer_nid'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-STACKTRACE-wh=
en-selected-by-STACKDEPOT
|-- alpha-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- alpha-randconfig-r063-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-MFD_AT91_USAR=
T-when-selected-by-SERIAL_ATMEL
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-w=
hen-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-w=
hen-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-w=
hen-selected-by-SM_VIDEOCC_6350
|-- arm-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-randconfig-002-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-randconfig-051-20250729
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)=
-supply)-pinctrl
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-teg=
ra-cpu-regulator-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):auart0-2pins-auart0-auart1-2pins-auart1-auart2-2pins-auart2-2pins-=
auart2-pins-auart3-2pins-auart3-2pins-auart3-auart4-auart4
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):compatible:fsl-imx28-pinctrl-simple-bus-is-too-long
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wa
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enabl
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-usb0-vbus-enable:duplicate-un=
it-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vb
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   `-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|-- arm-randconfig-052-20250729
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)=
-supply)-pinctrl
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-teg=
ra-cpu-regulator-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):auart0-2pins-auart0-auart1-2pins-auart1-auart2-2pins-auart2-2pins-=
auart2-pins-auart3-2pins-auart3-2pins-auart3-auart4-auart4
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):compatible:fsl-imx28-pinctrl-simple-bus-is-too-long
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wa
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enabl
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-usb0-vbus-enable:duplicate-un=
it-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vb
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   `-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|-- arm-randconfig-053-20250729
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)=
-supply)-pinctrl
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-teg=
ra-cpu-regulator-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):auart0-2pins-auart0-auart1-2pins-auart1-auart2-2pins-auart2-2pins-=
auart2-pins-auart3-2pins-auart3-2pins-auart3-auart4-auart4
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):compatible:fsl-imx28-pinctrl-simple-bus-is-too-long
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wa
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enabl
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-usb0-vbus-enable:duplicate-un=
it-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vb
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   `-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|-- arm-randconfig-054-20250729
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)=
-supply)-pinctrl
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-teg=
ra-cpu-regulator-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):auart0-2pins-auart0-auart1-2pins-auart1-auart2-2pins-auart2-2pins-=
auart2-pins-auart3-2pins-auart3-2pins-auart3-auart4-auart4
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):compatible:fsl-imx28-pinctrl-simple-bus-is-too-long
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wa
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enabl
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-usb0-vbus-enable:duplicate-un=
it-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vb
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   `-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|-- arm-randconfig-055-20250729
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)=
-supply)-pinctrl
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65=
911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-teg=
ra-cpu-regulator-was-unexpected)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):auart0-2pins-auart0-auart1-2pins-auart1-auart2-2pins-auart2-2pins-=
auart2-pins-auart3-2pins-auart3-2pins-auart3-auart4-auart4
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:pinctrl-(fsl-imx28-=
pinctrl):compatible:fsl-imx28-pinctrl-simple-bus-is-too-long
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06-wake:duplicate-uni=
t-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbu
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wa
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enabl
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-edt-ft5x06:duplicate-unit-add=
ress-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-ena
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-hog-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-fec-3v3-enable:duplicate-unit=
-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-leds-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-hog:duplicate-unit-address-(a=
lso-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-leds:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dts.-.:Warning-(unique_=
unit_address_if_enabled):apb-apbh-bus-pinctrl-usb0-vbus-enable:duplicate-un=
it-address-(also-used-in-node-apb-apbh-bus-pinctrl-usb1-vb
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart0:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart1:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart2-pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3-2pins:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart3:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-auart4:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-can1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart-4pins:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-duart:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpio:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-nand:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-gpmi-status-cfg:duplicate-unit-address-(=
also-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-i2c1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-16bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-18bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-24bit:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-lcdif-sync:duplicate-unit-address-(also-=
used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mac1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-8bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc0-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc1-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-4bit:duplicate-unit-address-(also-u=
sed-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-cd-cfg:duplicate-unit-address-(also=
-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-mmc2-sck-cfg:duplicate-unit-address-(als=
o-used-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm4:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-pwm7:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif0:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-saif1:duplicate-unit-address-(also-used-=
in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi2:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-spi3:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id1:duplicate-unit-address-(also-use=
d-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb0id:duplicate-unit-address-(also-used=
-in-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-edt-ft5x06-wake-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-fec-3v3-enable-)
|   |-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb0-vbus-enable-)
|   `-- arch-arm-boot-dts-nxp-mxs-imx28.dtsi.-.:Warning-(unique_unit_addres=
s_if_enabled):apb-apbh-bus-pinctrl-usb1:duplicate-unit-address-(also-used-i=
n-node-apb-apbh-bus-pinctrl-usb1-vbus-enable-)
|-- arm64-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm64-randconfig-051-20250729
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx=
-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-ty=
pe-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|-- arm64-randconfig-052-20250729
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx=
-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-ty=
pe-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|-- arm64-randconfig-053-20250729
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx=
-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-ty=
pe-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|-- arm64-randconfig-054-20250729
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx=
-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-ty=
pe-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|-- arm64-randconfig-055-20250729
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-15x15-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie0-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-p=
cs-tx-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-pcie1-ep.dtb:phy-4c1f=
0040-(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-=
of-type-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx=
-deemph-3p5db-attenuation-db-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk-sof.dtb:phy-4c1f0040-=
(fsl-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-ty=
pe-array
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):Unevaluated-properties-are-not-allowed-(-fsl-phy-pcs-tx-dee=
mph-3p5db-attenuation-db-was-unexpected)
|   `-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|-- hexagon-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- hexagon-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- hexagon-randconfig-002-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-randconfig-061-20250729
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-randconfig-062-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- i386-randconfig-063-20250729
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- i386-randconfig-141-20250729
|   `-- sound-hda-codecs-generic.c-parse_user_hints()-warn:assigning-to-uns=
igned-variable-spec-mixer_nid
|-- i386-randconfig-r122-20250729
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-omapdrm-dss-dispc.c:warning:stack-frame-size-()-exc=
eeds-limit-()-in-dispc_restore_context
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- loongarch-allyesconfig
|   |-- drivers-gpu-drm-omapdrm-dss-dispc.c:warning:stack-frame-size-()-exc=
eeds-limit-()-in-dispc_restore_context
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- loongarch-defconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- m68k-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- m68k-allnoconfig
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-STACKTRACE-wh=
en-selected-by-STACKDEPOT
|-- m68k-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- microblaze-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- microblaze-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- microblaze-randconfig-r061-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- microblaze-randconfig-r131-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- microblaze-randconfig-r133-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_e=
ntry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_sec=
ondary
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- mips-randconfig-051-20250729
|   |-- arch-mips-boot-dts-brcm-bcm97346dbsmb.dtb:memc-ddr-(brcm-brcmstb-me=
mc-ddr):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-mips-boot-dts-brcm-bcm97360svmb.dtb:memc-ddr-(brcm-brcmstb-mem=
c-ddr):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-mips-boot-dts-brcm-bcm97362svmb.dtb:memc-ddr-(brcm-brcmstb-mem=
c-ddr):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-mips-boot-dts-brcm-bcm97425svmb.dtb:memc-ddr-(brcm-brcmstb-mem=
c-ddr):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-mips-boot-dts-brcm-bcm97435svmb.dtb:memc-ddr-(brcm-brcmstb-mem=
c-ddr):compatible:oneOf-conditional-failed-one-must-be-fixed:
|-- openrisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- parisc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- parisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-randconfig-003-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-randconfig-r121-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- powerpc64-randconfig-002-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc64-randconfig-r123-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- riscv-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-defconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-randconfig-r051-20250729
|   `-- arch-s390-crypto-phmac_s390.c:WARNING:Unsigned-expression-compared-=
with-zero:k
|-- sh-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sparc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sparc64-randconfig-002-20250729
|   `-- drivers-gpu-drm-msm-msm_gem.c:error:incomplete-definition-of-type-s=
truct-msm_kms
|-- sparc64-randconfig-r113-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- um-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- um-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- um-randconfig-r112-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- x86_64-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- x86_64-buildonly-randconfig-001-20250729
|   |-- (.init.text):undefined-reference-to-efi_memblock_x86_reserve_range
|   |-- include-linux-compiler.h:warning:byte-is-used-uninitialized
|   |-- ld:(.init.text):undefined-reference-to-efi_init
|   `-- ld:(.init.text):undefined-reference-to-efi_mem_type
|-- x86_64-buildonly-randconfig-004-20250729
|   |-- ERROR:__devm_regmap_init_i3c-drivers-hwmon-tmp108.ko-undefined
|   |-- ERROR:i3c_device_do_priv_xfers-drivers-hwmon-lm75.ko-undefined
|   |-- ERROR:i3c_device_match_id-drivers-hwmon-lm75.ko-undefined
|   |-- ERROR:i3cdev_to_dev-drivers-hwmon-lm75.ko-undefined
|   `-- ERROR:i3cdev_to_dev-drivers-hwmon-tmp108.ko-undefined
|-- x86_64-buildonly-randconfig-005-20250729
|   `-- drivers-gpu-drm-msm-msm.o:warning:objtool:submit_lock_objects:sibli=
ng-call-from-callable-instruction-with-modified-stack-frame
|-- x86_64-randconfig-074-20250729
|   |-- drivers-acpi-osl.c:undefined-reference-to-efi
|   `-- ld:drivers-acpi-osl.c:undefined-reference-to-efi
|-- x86_64-randconfig-101-20250729
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- x86_64-randconfig-121-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- x86_64-randconfig-122-20250729
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- x86_64-randconfig-123-20250729
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
`-- x86_64-randconfig-161-20250729
    |-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
    `-- sound-hda-codecs-generic.c-parse_user_hints()-warn:assigning-to-uns=
igned-variable-spec-mixer_nid

elapsed time: 729m

configs tested: 133
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250729    gcc-8.5.0
arc                   randconfig-002-20250729    gcc-8.5.0
arc                        vdk_hs38_defconfig    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250729    gcc-15.1.0
arm                   randconfig-002-20250729    clang-19
arm                   randconfig-003-20250729    clang-22
arm                   randconfig-004-20250729    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250729    clang-17
arm64                 randconfig-002-20250729    gcc-10.5.0
arm64                 randconfig-003-20250729    clang-22
arm64                 randconfig-004-20250729    gcc-11.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250729    gcc-15.1.0
csky                  randconfig-002-20250729    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250729    clang-22
hexagon               randconfig-002-20250729    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250729    gcc-12
i386        buildonly-randconfig-002-20250729    clang-20
i386        buildonly-randconfig-003-20250729    clang-20
i386        buildonly-randconfig-004-20250729    clang-20
i386        buildonly-randconfig-005-20250729    gcc-12
i386        buildonly-randconfig-006-20250729    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250729    gcc-15.1.0
loongarch             randconfig-002-20250729    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                            alldefconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250729    gcc-8.5.0
nios2                 randconfig-002-20250729    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250729    gcc-10.5.0
parisc                randconfig-002-20250729    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250729    clang-22
powerpc               randconfig-002-20250729    gcc-8.5.0
powerpc               randconfig-003-20250729    gcc-11.5.0
powerpc64             randconfig-001-20250729    clang-22
powerpc64             randconfig-002-20250729    clang-16
powerpc64             randconfig-003-20250729    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250729    clang-22
riscv                 randconfig-002-20250729    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250729    gcc-8.5.0
s390                  randconfig-002-20250729    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                         ap325rxa_defconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                         ecovec24_defconfig    gcc-15.1.0
sh                             espt_defconfig    gcc-15.1.0
sh                    randconfig-001-20250729    gcc-14.3.0
sh                    randconfig-002-20250729    gcc-9.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250729    gcc-8.5.0
sparc                 randconfig-002-20250729    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250729    clang-22
sparc64               randconfig-002-20250729    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250729    gcc-12
um                    randconfig-002-20250729    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250729    gcc-12
x86_64      buildonly-randconfig-002-20250729    gcc-12
x86_64      buildonly-randconfig-003-20250729    clang-20
x86_64      buildonly-randconfig-004-20250729    gcc-12
x86_64      buildonly-randconfig-005-20250729    clang-20
x86_64      buildonly-randconfig-006-20250729    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250729    gcc-8.5.0
xtensa                randconfig-002-20250729    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

