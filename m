Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68982C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BF46B007B; Fri,  1 Aug 2025 15:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CDE6B0089; Fri,  1 Aug 2025 15:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3086B008A; Fri,  1 Aug 2025 15:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 501436B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:21:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A10D514017B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:21:46 +0000 (UTC)
X-FDA: 83729158212.23.A4CE7A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 194AEC000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:21:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VXb43G+B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754076104; a=rsa-sha256;
	cv=none;
	b=h8yc6CooYYreLNZzCJglFQoaY8Nioywi/B/7zTaNpQHVaYxpjz04rWoEbDoqzpMcg6dZy0
	1AZ+vYnR6GC9D7iEYSbpVuFr2pe3u61Ser4pLkNJBQitzFbCUYXjZaP4g60liINtjQJ1Br
	5/gfk9soq6Qn/0P7+CPnQ7DREHqknEk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VXb43G+B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754076104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cA3nBN1wwZ/QO7aSjKGaUJpuC4JdkMKkK8G54Ckc/mg=;
	b=f+E4Phc/epVsph34WGuNH2CIvm0iVpJfjFGDDr5A0nl6eyh9iseQ85hjB13AjVxtQWP6o9
	MFo7/eDZReiIGbNb0jQZh/0fddB5X7/zff9JUmVyZSd/dswOtXlf+29lEuvIA6TgkrZlfD
	1QwLdAbws06cvfilhIPv8tkzmGY/mlE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754076103; x=1785612103;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ELOC5W2au1FsckigcImcipzY7e0pyBkvlogGcBEr6Z4=;
  b=VXb43G+B8BMLHMSf69KctZDfDRJrgGQjGHtVUl3H1b6DW01mTPxKTMl2
   QVEx9FSzX3lp0Yp4ST7E4XdtI3nkTNn2qklYKtf8mARrDYUxHNNf4RWMr
   Q3QFN3JMsvhtm9ev1IJafVJcejev+j820cv9OMh9dbmoS44ilMOODM3mi
   pKSA2NFmvoS6qtUr5SqjZgtCVh/PEOrcx9OwEeOMMTYOM7Mi4UhRqZzz2
   FNtVbOH/DisyQflXH6n1vL1EUym0aR1ZmeGR0E20tD05MxoFMs6CPzCwf
   vNdzbcC3lOyxUdM4Lc03PtkCS41jjEBcZWVLDkiCZOxvTbznsoDascuQy
   w==;
X-CSE-ConnectionGUID: wttRbP8/SQmUFaL0I69W0Q==
X-CSE-MsgGUID: 7mwzxrOrQKqBJPL86U5+CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="55633233"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="55633233"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 12:21:40 -0700
X-CSE-ConnectionGUID: guA7pAAvQPC7ovcjHdyi0Q==
X-CSE-MsgGUID: gqrTZt0OSZmCK74RE08WtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163984708"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 01 Aug 2025 12:21:39 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhvJw-0004rs-21;
	Fri, 01 Aug 2025 19:21:36 +0000
Date: Sat, 02 Aug 2025 03:20:46 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 b9ddaa95fd283bce7041550ddbbe7e764c477110
Message-ID: <202508020325.3xlyq0r9-lkp@intel.com>
User-Agent: s-nail v14.9.24
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 194AEC000A
X-Stat-Signature: 6ou6tegfpghrhnpgzwpgrskugate9iwc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754076102-786220
X-HE-Meta: U2FsdGVkX19ZLtksdygapFsJ/EdPwzYEPqRRJJLDO2ABfDP3ufQOZKpTAnuGimTdVeYy9Y8Rw10FM+XFquRhBqCKZb7PHteZY+7aCS9Ec8R+Cv3AvzS0pYCaw2S20PnIa/w3QKncOPo3yJgoseL5ng+VnaK9aaW+nLDtE5pvkWDmnKO0/5POQwFSyEOEVDnIu3ucCyVn15Xs/oP35EzTbXFSs1tghiOTkk7VrSEtmOeDgjbNblPtqCU7Ga0Kt10HR/9wzC/o9CusuOuZmtqdOEOCHPRw+Pt1Jn+qnjbkbA5c3+3z0Ie2t+NllE9okWH26lMLn4kPbsHa2zdWStpI2/fDmUnl+ozTSSFIPfuRn5McspqKn+32jtDtwkbwgz373mZ8qpisBoVrmz2Rh68vBiuIqp6EvDwCXGrkwEDRxK3dWjQk3i0yYQSOP9WMJAidG5uruHqjgEAV005Sl9zS+oP9NRugPuR7EW+/Xn/sp2Vx/+Up85adtQ3OEXL1hOsA00/yweFrkjIBaK7y82v4b3g17Ydv5zRGSpO4WRv80QvwmWwmFnNNe5OenSZePI50Zj3xiH2xnTv8tZpcnvgUOBb8idfAxUEcPkJhrrokNpCac1Vb7aqdz1L2fWD3h8DoZAdu/MVYwpep98znswuI/814BRhNgqE0LPTrWzlq05ClEKM8pE0ZBrkx8xp84TMXl9QLdD/poSjoaFe3rg9zBKvlP3PxWX1JOhB9XhfxzWuUj3gktvHtMIP48V/NJ7PQye0A1DX2y3i9y6pHlHqSWGrr7HX/ltxp+jpeU7AsUa1CURglXknHvjk2CNL9EYi5zsxaIJgWs3YxZqD6wdAmhKUuFbT3qxyszxPv3XjjDuLehrLsKjW7kag1Gh0wH+bY3vbvHlS9gy7OkqUgk9qv8VugRbEs1S5SDuwDfgVxtsU/Sn+sjsW7pdI+50YQpDeBLLTd6gDoGuuJbkZVSZg
 F++cE7E1
 FQWTk3INOHtVakzPzM11THKZNC9GF34lH/wmtkm7ldhSI03TaN4+uckrmzsdrr9o42E3diDdFg0RoKtlV2u17dvBjCTYY+ZCy88jvUQWoa8oudXVJjjd2xiNu4B6sqlgKDu4uLuDYaCrtYtgTCeseOhSlvK1xf1SQEO3Jthi6S+AJ0t0QEDoHRGzNU3JqtlToWmrMLX0E1u2DxmSW4A+RtFtpZ92Pv1NOSXljo919hNIqSvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git master
branch HEAD: b9ddaa95fd283bce7041550ddbbe7e764c477110  Add linux-next speci=
fic files for 20250801

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507032251.5766L2PU-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507040730.OxedSKJE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507051753.jjZiUKrI-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com

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
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2256) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]

Unverified Error/Warning (likely false positive, kindly check if interested=
):

    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol '=
subvolid'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-051-20250801
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
|-- arm-randconfig-052-20250801
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
|-- arm-randconfig-053-20250801
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
|-- arm-randconfig-054-20250801
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
|-- arm-randconfig-055-20250801
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
|-- arm64-randconfig-051-20250801
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
|-- arm64-randconfig-052-20250801
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
|-- arm64-randconfig-053-20250801
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
|-- arm64-randconfig-054-20250801
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
|-- arm64-randconfig-055-20250801
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
|-- loongarch-allyesconfig
|   `-- drivers-gpu-drm-omapdrm-dss-dispc.c:warning:stack-frame-size-()-exc=
eeds-limit-()-in-dispc_restore_context
|-- loongarch-randconfig-r131-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- microblaze-randconfig-r133-20250801
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
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_sec=
ondary
|-- mips-randconfig-r113-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- nios2-randconfig-r122-20250801
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|-- parisc-randconfig-r071-20250801
|   `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-su=
bvolid-.
|-- parisc-randconfig-r111-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- s390-randconfig-r121-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- sparc64-randconfig-r112-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- um-randconfig-r132-20250801
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
`-- x86_64-randconfig-121-20250801
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
    `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu

elapsed time: 724m

configs tested: 132
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250801    gcc-15.1.0
arc                   randconfig-002-20250801    gcc-10.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250801    clang-22
arm                   randconfig-002-20250801    gcc-8.5.0
arm                   randconfig-003-20250801    gcc-10.5.0
arm                   randconfig-004-20250801    gcc-14.3.0
arm                        shmobile_defconfig    gcc-15.1.0
arm                           stm32_defconfig    gcc-15.1.0
arm                        vexpress_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250801    clang-22
arm64                 randconfig-002-20250801    clang-22
arm64                 randconfig-003-20250801    gcc-11.5.0
arm64                 randconfig-004-20250801    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250801    gcc-13.4.0
csky                  randconfig-002-20250801    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250801    clang-22
hexagon               randconfig-002-20250801    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250801    clang-20
i386        buildonly-randconfig-002-20250801    gcc-12
i386        buildonly-randconfig-003-20250801    gcc-12
i386        buildonly-randconfig-004-20250801    gcc-12
i386        buildonly-randconfig-005-20250801    gcc-12
i386        buildonly-randconfig-006-20250801    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250801    gcc-15.1.0
loongarch             randconfig-002-20250801    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250801    gcc-11.5.0
nios2                 randconfig-002-20250801    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250801    gcc-13.4.0
parisc                randconfig-002-20250801    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250801    gcc-13.4.0
powerpc               randconfig-002-20250801    clang-22
powerpc               randconfig-003-20250801    clang-22
powerpc64             randconfig-001-20250801    gcc-8.5.0
powerpc64             randconfig-002-20250801    clang-22
powerpc64             randconfig-003-20250801    gcc-13.4.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250801    clang-22
riscv                 randconfig-002-20250801    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250801    clang-22
s390                  randconfig-002-20250801    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250801    gcc-14.3.0
sh                    randconfig-002-20250801    gcc-11.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250801    gcc-15.1.0
sparc                 randconfig-002-20250801    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250801    gcc-9.5.0
sparc64               randconfig-002-20250801    gcc-15.1.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250801    gcc-12
um                    randconfig-002-20250801    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                           alldefconfig    gcc-12
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250801    gcc-12
x86_64      buildonly-randconfig-002-20250801    clang-20
x86_64      buildonly-randconfig-003-20250801    clang-20
x86_64      buildonly-randconfig-004-20250801    clang-20
x86_64      buildonly-randconfig-005-20250801    gcc-12
x86_64      buildonly-randconfig-006-20250801    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250801    gcc-8.5.0
xtensa                randconfig-002-20250801    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

