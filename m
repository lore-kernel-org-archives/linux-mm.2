Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D86C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 16:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3B06B00DE; Wed, 23 Jul 2025 12:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C586B00E0; Wed, 23 Jul 2025 12:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BCE6B00E1; Wed, 23 Jul 2025 12:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A35B6B00DE
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:20:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADB0D8014B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:20:46 +0000 (UTC)
X-FDA: 83696042892.20.4C501F2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0806CC0016
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:20:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DDg21bXf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753287644; a=rsa-sha256;
	cv=none;
	b=lDVtRPMmv0GruMO4njgSp/WEHa/O9fkkdVGLC6BR6o5IMShga5diflzolV3kqGhls4r8k1
	xYuVaGvm4FdzyZ6ehv+D2nMvso5GX6MZLby4XV7FHmonOu5rsdTeX8EeqAlBAXm+2h0JRK
	vAY3lF5cdzYWSlLq9X6sDFg7zl44My4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DDg21bXf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753287644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mxlFBOHDU809QrF0xkA/MXzrIMiX0Fk7HRF/W+ac960=;
	b=fnD8bSYHg4qXj00MoDGwg4jKjr72coc3xvd2Vz3cULJhLZgjFJjynumcSovFW+8kPeHloF
	EJhXw9sKFBIqdgnsijuzBlr/9RkzQw2IIrylCm0V3R4pTYrYp/p0Y8yccUjwr+/eh0eOtt
	eUm8S6ORw0CKSSJkaY1p5rWygQy6QkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753287643; x=1784823643;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ncaEeTZp5OP8rpYK+pFBhgZVmwIaba4Ia7dwf/hPjXA=;
  b=DDg21bXf6bkJX2nZ6JB3vJynm+daJcQtWXibGmaAysNsO7ZPS5q2izsE
   MfCzM7+7OYxcmpAksAJYox78rvF3XsRHfOFDkLdtiUW7JWrJCrWAOCkkk
   5QJ3wHXU85TU3e9yz8z10B2NQnF/3Qz8lLShT+Y1uy+jJKRsx1LrKhqx4
   b1rP9k2j4JObELzIrGlNboKutWaGzWsSCz8+OuvO2Xqghwr7ISGPqMVLV
   rtqU6uG3zgIN9k3sIQUB+2MFCfUSGWaeY+Ssfl9s4YAzJOmwnbfo3ocQI
   o/qcFTWFC1GIfon+lwFORRZTR5m0DkJ6SrThaQH8nBhDIDd6pjktWn+Yb
   g==;
X-CSE-ConnectionGUID: qJXbENWVRt+KPZYSwReXJQ==
X-CSE-MsgGUID: GzM4EUuTQxerTMDT/eBNng==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59236576"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="59236576"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:20:37 -0700
X-CSE-ConnectionGUID: uQU6pEr4SJqQctUmx353vg==
X-CSE-MsgGUID: JpJTdOaES4StKnEBhmUfnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163673205"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 23 Jul 2025 09:20:34 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uecCl-000JXH-2u;
	Wed, 23 Jul 2025 16:20:31 +0000
Date: Thu, 24 Jul 2025 00:19:38 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 a933d3dc1968fcfb0ab72879ec304b1971ed1b9a
Message-ID: <202507240011.mQ2XdeOy-lkp@intel.com>
User-Agent: s-nail v14.9.24
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0806CC0016
X-Stat-Signature: 5hxfo7ksim7dkmhxsnrgcwq69f14nr9d
X-HE-Tag: 1753287642-987167
X-HE-Meta: U2FsdGVkX1/zkyd/0yPuTc2OiuKbxuIwozOH4yWsGcgtWzyPTe3bscOqf/hXoo4e7d8A+U8Pzq9c8hVpylEOfEhtyGhVfYtaUO3gtQALCAwuyw1WfyqfjGA7dJRpI/sWjkz1uPzjEBb+TLiQCES7D/tAHDM2/u+bcDQtZuk6tvmIcdY44yYW1MKKq83RsbYCn9o4Yv/+13ldgOH7B4YgN6jFDaV61uXbBnZev3IWIFZ5DNWYORoBC62eLdXGFGX+9bUa1IMRP55YQwTFYWNDN5cOsahz5FTEBgTAJt0lKCC3GcWUOXdDbxFlVt9GX+OBVliR3b0CvsnKtoxIQ1yiYt4jNDGiL13YexoyX4JyC2W4SGQMaeHdODlJiQD3rBL/purmjYELuIlN/iRIunnqkr8PM23E2WUpw9IxDUihEN45LC3d3jjUSaJr4jS0eJocOr/um6kYhM5ItkAfl1XNTjbtO/rt5UycRzDaZYRX4qURWbGNGYCYJY7CzIyS/KS0tS4qD47z8qMjcXdI6Pa2sjueWljrY+YBIfjk+QlW4hznVsTzU4kuBsCIKbEW+sJpgKGwg33hY+qIwxHDQGaT2ATbAAJ9WDdweYyqj5tHbrIJRbL90LQm3ebJnXrQU4Tg4rfoalLJo6jiW7A1vCCsEeYNeY3mGn+gmhRCyDNnu58ONDOtxdKdzPktRYoIZKbQWeHua6t7P9rv/rZi+S438EV7hAYSTem54n6aaV4s29gnwXkZ/wMgbLjdqyfq7Pj0Ap5xQ1PhIg+9Ymjlnih3+y3fZZ+DqGBR/1a/pAG3NgpKLS6YhVi3DltLdyb4gv3wH8NGFeRtS0VAuxrNYEmIMRals8HSivEd4oJpxYxDYZDRcWyNNyeDTZObNME62bBMPCgHyg/to0ECMB6OssF0cYpiu7Q00DT3s1rshxbAysIIpR2bQvdLiwY9FLiuwjL8/iXv/W1Lmz0Br57Ysbu
 A4H0tkn7
 BUi7ZrEwT1VKdat//r4X+G0lJpl5uHMtk3+fs08a9V4iFA32+sX17JxRQ0k1SWmTpOH1/pxjjOYXm0BncTsU59bdheX+8Gaii+CEwAmm6d2y9pWAfDfDstmcUnbmV5OVxOt3oY/MnmMhKTJBB6Cuc8qvUddYz78OZXlqxngEeHuMj/SR0BBjmFhhHImGfMFo6Kv9p2eh2k3ceZFsN4z/diRUO85FHy36yhpYX8Mt3U4RQgDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git master
branch HEAD: a933d3dc1968fcfb0ab72879ec304b1971ed1b9a  Add linux-next speci=
fic files for 20250723

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202506250015.DUfXQi3y-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507032251.5766L2PU-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507040730.OxedSKJE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507051753.jjZiUKrI-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507130334.ddFcXn4N-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507190707.dEpevroQ-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507191215.XtOfM64r-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507212021.dc1RGBxE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220705.n9m6UpDd-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild/202506280217.Pq2Hur19-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202506281631.qxLRO5eu-lkp@intel.com

    arch/arm/boot/dts/nxp/mxs/imx28-amarula-rmm.dtb: /apb@80000000/apbh-bus=
@80000000/interrupt-controller@80000000: failed to match any schema with co=
mpatible: ['fsl,imx28-icoll', 'fsl,icoll']
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
    arch/arm64/boot/dts/apm/apm-mustang.dtb: pcppll@17000100 (apm,xgene-pcp=
pll-clock): 'type' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/apm/apm-mustang.dtb: socpll@17000120 (apm,xgene-soc=
pll-clock): 'type' does not match any of the regexes: '^pinctrl-[0-9]+$'
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
    arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dtb: /sound: failed to ma=
tch any schema with compatible: ['fairphone,fp4-sndcard']
    arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dtb: service@4 (qcom,q6af=
e): Unevaluated properties are not allowed ('usbd' was unexpected)
    arch/arm64/kvm/vgic/vgic-mmio.c:1094:3: warning: variable 'len' is used=
 uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    drivers/gpu/drm/msm/msm_gem.c:106:54: error: invalid use of undefined t=
ype 'struct msm_kms'
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2256) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2688) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 whe=
n selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 whe=
n selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 whe=
n selected by SM_VIDEOCC_6350
    kismet: WARNING: unmet direct dependencies detected for STACKTRACE when=
 selected by STACKDEPOT
    security/apparmor/lsm.c:182:23: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]
    security/apparmor/lsm.c:182:44: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, kindly check if interested=
):

    drivers/net/dsa/b53/b53_common.c:1961 b53_arl_op() error: uninitialized=
 symbol 'fwd_entry'.
    fs/bcachefs/btree_update.c:371 __btree_trans_update_by_path() error: un=
initialized symbol 'cmp'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-STACKTRACE-wh=
en-selected-by-STACKDEPOT
|-- alpha-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arc-randconfig-r133-20250723
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-w=
hen-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-w=
hen-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-w=
hen-selected-by-SM_VIDEOCC_6350
|-- arm-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-randconfig-001-20250723
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- arm-randconfig-051-20250723
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:apb-apbh-bus-interr=
upt-controller:failed-to-match-any-schema-with-compatible:fsl-imx28-icoll-f=
sl-icoll
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
|-- arm-randconfig-052-20250723
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:apb-apbh-bus-interr=
upt-controller:failed-to-match-any-schema-with-compatible:fsl-imx28-icoll-f=
sl-icoll
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
|-- arm-randconfig-053-20250723
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:apb-apbh-bus-interr=
upt-controller:failed-to-match-any-schema-with-compatible:fsl-imx28-icoll-f=
sl-icoll
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
|-- arm-randconfig-054-20250723
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:apb-apbh-bus-interr=
upt-controller:failed-to-match-any-schema-with-compatible:fsl-imx28-icoll-f=
sl-icoll
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
|-- arm-randconfig-055-20250723
|   |-- arch-arm-boot-dts-nxp-mxs-imx28-amarula-rmm.dtb:apb-apbh-bus-interr=
upt-controller:failed-to-match-any-schema-with-compatible:fsl-imx28-icoll-f=
sl-icoll
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
|-- arm64-randconfig-002-20250723
|   |-- arch-arm64-kvm-vgic-vgic-mmio.c:warning:variable-len-is-used-uninit=
ialized-whenever-if-condition-is-false
|   `-- drivers-gpu-drm-msm-msm_gem.c:error:incomplete-definition-of-type-s=
truct-msm_kms
|-- arm64-randconfig-051-20250723
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:pcppll-(apm-xgene-pcppll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:socpll-(apm-xgene-socpll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
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
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:service-(qcom-q6a=
fe):Unevaluated-properties-are-not-allowed-(-usbd-was-unexpected)
|   `-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:sound:failed-to-m=
atch-any-schema-with-compatible:fairphone-fp4-sndcard
|-- arm64-randconfig-052-20250723
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:pcppll-(apm-xgene-pcppll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:socpll-(apm-xgene-socpll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
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
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:service-(qcom-q6a=
fe):Unevaluated-properties-are-not-allowed-(-usbd-was-unexpected)
|   `-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:sound:failed-to-m=
atch-any-schema-with-compatible:fairphone-fp4-sndcard
|-- arm64-randconfig-053-20250723
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:pcppll-(apm-xgene-pcppll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:socpll-(apm-xgene-socpll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
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
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:service-(qcom-q6a=
fe):Unevaluated-properties-are-not-allowed-(-usbd-was-unexpected)
|   `-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:sound:failed-to-m=
atch-any-schema-with-compatible:fairphone-fp4-sndcard
|-- arm64-randconfig-054-20250723
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:pcppll-(apm-xgene-pcppll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:socpll-(apm-xgene-socpll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
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
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:service-(qcom-q6a=
fe):Unevaluated-properties-are-not-allowed-(-usbd-was-unexpected)
|   `-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:sound:failed-to-m=
atch-any-schema-with-compatible:fairphone-fp4-sndcard
|-- arm64-randconfig-055-20250723
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:pcppll-(apm-xgene-pcppll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-apm-apm-mustang.dtb:socpll-(apm-xgene-socpll-cl=
ock):type-does-not-match-any-of-the-regexes:pinctrl
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
|   |-- arch-arm64-boot-dts-freescale-imx95-19x19-evk.dtb:phy-4c1f0040-(fsl=
-imx95-usb-phy):fsl-phy-pcs-tx-deemph-3p5db-attenuation-db:is-not-of-type-a=
rray
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:service-(qcom-q6a=
fe):Unevaluated-properties-are-not-allowed-(-usbd-was-unexpected)
|   `-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:sound:failed-to-m=
atch-any-schema-with-compatible:fairphone-fp4-sndcard
|-- arm64-randconfig-r112-20250723
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- csky-randconfig-002-20250723
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- csky-randconfig-r121-20250723
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- csky-randconfig-r131-20250723
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- hexagon-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- hexagon-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-randconfig-141-20250723
|   `-- drivers-net-dsa-b53-b53_common.c-b53_arl_op()-error:uninitialized-s=
ymbol-fwd_entry-.
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
|-- loongarch-randconfig-001-20250723
|   `-- drivers-gpu-drm-msm-msm_gem.c:error:invalid-use-of-undefined-type-s=
truct-msm_kms
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
|-- mips-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- openrisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- parisc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- parisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- parisc-randconfig-r111-20250723
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|-- parisc-randconfig-r132-20250723
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- powerpc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-defconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-randconfig-r123-20250723
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- s390-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sparc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- um-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- um-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- um-randconfig-r113-20250723
|   |-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-restricted-acr_flags_t-usertype-alloc_flags-got-unsig=
ned-long-assigned-total_mapped
|   `-- mm-page_alloc.c:sparse:sparse:incorrect-type-in-argument-(different=
-base-types)-expected-unsigned-long-nr_migrated-got-restricted-acr_flags_t-=
usertype-alloc_flags
|-- x86_64-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- x86_64-randconfig-104-20250723
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
`-- x86_64-randconfig-161-20250723
    `-- fs-bcachefs-btree_update.c-__btree_trans_update_by_path()-error:uni=
nitialized-symbol-cmp-.

elapsed time: 776m

configs tested: 132
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250723    gcc-8.5.0
arc                   randconfig-002-20250723    gcc-9.5.0
arm                              alldefconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250723    gcc-13.4.0
arm                   randconfig-002-20250723    gcc-13.4.0
arm                   randconfig-003-20250723    clang-16
arm                   randconfig-004-20250723    clang-22
arm                        spear6xx_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250723    clang-22
arm64                 randconfig-002-20250723    clang-16
arm64                 randconfig-003-20250723    clang-16
arm64                 randconfig-004-20250723    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250723    gcc-12.5.0
csky                  randconfig-002-20250723    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250723    clang-22
hexagon               randconfig-002-20250723    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250723    clang-20
i386        buildonly-randconfig-002-20250723    clang-20
i386        buildonly-randconfig-003-20250723    clang-20
i386        buildonly-randconfig-004-20250723    clang-20
i386        buildonly-randconfig-005-20250723    gcc-11
i386        buildonly-randconfig-006-20250723    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250723    gcc-15.1.0
loongarch             randconfig-002-20250723    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                       bmips_be_defconfig    gcc-15.1.0
mips                           jazz_defconfig    clang-17
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250723    gcc-8.5.0
nios2                 randconfig-002-20250723    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250723    gcc-8.5.0
parisc                randconfig-002-20250723    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250723    gcc-10.5.0
powerpc               randconfig-002-20250723    gcc-8.5.0
powerpc               randconfig-003-20250723    gcc-12.5.0
powerpc                     tqm8540_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250723    clang-22
powerpc64             randconfig-002-20250723    clang-22
powerpc64             randconfig-003-20250723    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250723    gcc-9.5.0
riscv                 randconfig-002-20250723    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250723    clang-22
s390                  randconfig-002-20250723    clang-20
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250723    gcc-12.5.0
sh                    randconfig-002-20250723    gcc-9.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250723    gcc-8.5.0
sparc                 randconfig-002-20250723    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250723    gcc-12.5.0
sparc64               randconfig-002-20250723    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250723    gcc-12
um                    randconfig-002-20250723    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250723    gcc-12
x86_64      buildonly-randconfig-002-20250723    gcc-11
x86_64      buildonly-randconfig-003-20250723    gcc-11
x86_64      buildonly-randconfig-004-20250723    clang-20
x86_64      buildonly-randconfig-005-20250723    gcc-12
x86_64      buildonly-randconfig-006-20250723    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250723    gcc-13.4.0
xtensa                randconfig-002-20250723    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

