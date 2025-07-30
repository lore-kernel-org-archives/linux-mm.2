Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB90C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 20:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A466E6B009C; Wed, 30 Jul 2025 16:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D676B009D; Wed, 30 Jul 2025 16:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3766B009E; Wed, 30 Jul 2025 16:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A67E6B009C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:02:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAD45112903
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:18 +0000 (UTC)
X-FDA: 83722002756.07.F8DC993
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF2972001B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753905735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U23gvDTOyogvko/SytpMTWjogQZ9As12Xf1sdWgqy94=;
	b=2RjjLX5hVlM3wJUmBb0ViyFB5SRgRjoTj1gb0BIRqwenxTzz+t4uE3rXW4dIZDM0Ex7cMQ
	OhZKKl4o06QX9EtLZfIGrOHm9hoeb7MmJ+RMGvlIPSkahyZR/1DtmdGj3s7xGbV8+7HP7P
	oxZuU4fYrHHLvccVF7KrmydpCNmIcVM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753905735; a=rsa-sha256;
	cv=pass;
	b=gf476fvkL7/sn6buqHWdBrtZwCp653HZsrQR2us5B7ie3SKuFrEITRJsoT26uZI7+Se1I2
	WShwesN9z2+RGbk6qdeCHi4dV7+orCyNltaHS+oUCD4R15llOuTB5xxegarvLCtqjMtgxH
	O3QxAJ9aBt6GfOO05CpuYzAozu/SUuU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29EAE1A0551
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:15 +0000 (UTC)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D48A0C052C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:13 +0000 (UTC)
X-FDA: 83722002546.09.0B2A990
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E8AD10000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:10 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753905731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U23gvDTOyogvko/SytpMTWjogQZ9As12Xf1sdWgqy94=;
	b=XLbpnHPZzgC/qCnH/Ed5F8eK0YECcu9oakLuQp2vyvE3uqeOag+fD3+MmqEBsyDokyo7tl
	UL9bk3g3nTISyPixUVKQ1OHjLLO5Z1ozhU8NMWIUrWFxdK7/DYqQZjrx7OR3WE6aBTbwVQ
	jJET7qrl1SKrXYtc3vQ0iVyVAwCZoAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753905731; a=rsa-sha256;
	cv=none;
	b=hvfSbLEc+E503vVnLjabw9AD8m9TtVnwk030ojos1HXq3PTDwW1YGTso4vIrRfWtU77f0O
	XLvHUOX/aiPMjrnMBvpJyUre8QD6wRJ+L6sR6lsj2FspwGtnk410IRfoX92bRBShNWv1w3
	+owlbK3fUTUhS00r1dRBUmdpAzgLgXA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZKvq9cWx;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753905731; x=1785441731;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=770tGIbsav4wuP6aer2UaxFByHNfwWDxTBOJNSHuKgg=;
  b=ZKvq9cWxVNeogYivK5n8CS2qPJre+/C5X/aFHtVjVv5v8BWvNGhqPUT1
   qhLuQE1XlYBiPSAEeXSamZuzpSuACaW1DR9WK3QmgI98nQu3KW6V3PCng
   KI7k3lYcGidZRZ+NSw1ZTrTMNX7ZVRz+qr6PsyVOP8/CaS8OaGep1lNPb
   MnRO9czpe+1De0Z41Vqr0YTWVpuIQqgVazA598kaqF9ekYVQAJx3OpSqZ
   oJZYgsLvBKaHV379FX3lqxwsADRaNZonXHwpwpsDpx8wOb448r84Z0ZJi
   XI2SuiK8IM0pSaYw2+5SZgzS/lw6atr/ZdO21lWfCERa9XelTsunFLI1I
   A==;
X-CSE-ConnectionGUID: Oag3pEHVRES+z5A4j3938g==
X-CSE-MsgGUID: 676EUSWoSaq3d+zTJNJwog==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="60042767"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="60042767"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 13:02:09 -0700
X-CSE-ConnectionGUID: cfVYNIKKSL6+vC9uHChGiA==
X-CSE-MsgGUID: by+oYlELQqiv2Ftxtntx+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="168363856"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 30 Jul 2025 13:02:07 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhD01-00036Y-0g;
	Wed, 30 Jul 2025 20:02:05 +0000
Date: Thu, 31 Jul 2025 04:01:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 79fb37f39b77bbf9a56304e9af843cd93a7a1916
Message-ID: <202507310435.HBj6RJ9f-lkp@intel.com>
User-Agent: s-nail v14.9.24
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX19HSUjrdRgjN8IBVzjgtHJTqjDBClieJeooJpQ+Io3njTKIeDC1pMwZxsSjt52y2PwZ3bRQiJ+iu6JSwkZv9nii0uej2Wldlo7rnnf2eMmBgDsmjYHrq5uTHS9yPsP6NWNghFfnCnWPTp+iaZQO9AiwSGf5Es960Pn6c0C3HugpZTdMkp3W6dCGzweujNkOyb3aDgKG6r1WWISaqKIXCxPbSuqid2vsAZO4a3L2ThUxiawcuTJSvW+9LjN7sDBABJrwGt+2fJMIBVcZPtxgqx2HrnYAKaTO4sLhll8gBTgLqmeUsg9FR0dG1ANvDzBN0BshNnb/BceOMNgohF1kWLGWlkpPqxJlebur1ZUGf9Xd9uO5D1XXBgjj8666bSn6D//KohwbuYaHVyFUuZo8WwyKkq2YIfq0oPgm4o4nJvrOsonSLz9cGPbrDug+apoDRTBArcaioUXwz2WAt0HXqlb5P3+jBl+LJ0BfKVlaxAEymsfywzEuHzp9mVS/le7fuBrpOaM8D0sumE/GE7ecD52Q0+vqIwpaPiyhtejEcA9u3xuBaiRdq3IgUsUNA4h73dZflyAe+o6DDLqPQHZV1LtGFH/8t9OOUK2zgOr5EW+nbEMR/PUIm2voXL4rxmWy4BMDQ2uKZtm2S8a+uR0SwxNdgYCZaara8ZrvGXimRxoIqctCkPKDasjMjSSYQHimwvDTVLzoz5bkLomTWKT/NHmtZYThnIR7fz8fXXw7gPIUT/NeGTc/XjCIORyP/RCxabIRgtTb3OI/merqRM5FlFYKwsoiiCpta/LRiEeXy9bsgO+3KJn/xqFUqqGlK6Kw49xz7i0sv6FTKhrRkzL3KaKFohfhExy96jYGhbRc15NWVjRjGG6dWfobDCDfc8kWrDm+XT/7BG/0NNvxLIDQUvek0ef1zbH653im+epdBrAnJK7GHBKdQujox/afk4k8BY4XwCJNmmZ
 0c9w1NMi
 IkU6UHvOa3u1rFYVImGt5RYt5xowrvO+CD/jWJ6pm/h1heMrVG6Ck3SR66pYACDAvysLdKRUc2gXtjB0nk371yzUG16CxruDrwQPQ+sNz6eWGaUuqTv7hv3DmrFro+M0NWjvUkpBcC7He3ayWEjxlMO+AO8Tb4uTtYaGe2Jx10IzBNWTWP3xCX/Z1Jt2Cug0L2Thl4KVylta287MzKSoOwAYEFHYCKaQWr/3yMGW+4hhyv0w=
X-Rspamd-Queue-Id: AF2972001B
X-Stat-Signature: yctxunr616amkxa48w6b3omh3811ewmw
X-HE-Tag-Orig: 1753905730-65237
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753905735-996465
X-HE-Meta: U2FsdGVkX1+uWiZooZpV5yIKgWhjEipu6O/BanQAhw3NKpyOngO5hiHJgLvApsOUkhUfzRK6crgnV1NMzq5teCUcoKTP1MEmLqACOaCczcIHisPX4nP6ntYZ16/zX+RlFjRsAGOUX3wP027c4Sc7O/8N4cYZsM42dzc1b1JmQEYzHrf501bRocJo88H7J32ohz7eMLPIyMxDkbTu/isV7ecqEw2UoGwouPHMD2RdOw8NtJZ7EhnV0FBXC5iL6ZkQQ7ZF012bVSLsn5xO0Ae0laeRvilLqUorYAKW1EVoPmBZyv/+b5INK2FTXCq6O6OQzqRUbgPH43bG00q/bCDXtZn2D4dkrlx1mhz/GfTaNW/C1v/YpX0S/vfuzPguvEKXt1am8RN9cxDnsDrdNkehhID7guePNsVAHoslqRyNKG87zO9hAzd4pY2g8Oa+XWjo02Zv6ql8EKzmkc6TvAQZbM6T4Ch+KgfYctXBICvvtBDweVzfOZ7OjHnc+cwGc6M2rLHDQ+T3GhuhOo+5zVm+/r6XIcNKEOZ/attR6HdZLuJLDYA0lfrM8f1dEN6yE/qfB5wLLFNwWKIJhciqF4g3ZxXRVO7VewulINNA0I8WY8u3NodgYa8iFa42Kp53MRpkj8ME6qHnIOqt4FsVBOJu++ikbgNcO9iYAf3w6+4ebQ4P7GuSHPc9uOmeTEXOUgoV+wnasBxNReJ9+TM6QMLULaWsgeTwHoQdq52Zk7CIfF7dcgyHG6uS1QPZQJ9XTF+6x816CTk2PPLkd18R6x9TL97m0/2nycesEl379XRAru8ejiq3MsU/hQXb0ZA7G/XiebmQs9PX0mBLtKvB8Bjl+k5+x/AfWpAFmop8HLYIhCwiICljC8XEpzVgRqhfKOs9Xi44ThtyGSqKdYeyHMohb6zyaPox4dVUBDqtKyw2DPXlkWpplFEl+uZzpnTJ5E3Mxplb+pBBDzusToIulkN
 dbQm9Zug
 bMDjg4qzGMhQPuX+S45USwSfOKJu5cK5gmnglZGB6f1VA0k55+vgcysSsTkrHPQIh9wYRsNCm5ecMh7c+drhH58752Bpn8sg0nzOf4VzEZlx609Y/QJbugPMY57aNHPDg/O5qqeLAkXI9kqKmKkvtFgIrwg830UaMw6gUAcqq4Q6IKL+1PasDb/o7/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git master
branch HEAD: 79fb37f39b77bbf9a56304e9af843cd93a7a1916  Add linux-next speci=
fic files for 20250730

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507032251.5766L2PU-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507040730.OxedSKJE-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507051753.jjZiUKrI-lkp@intel.c=
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
    https://lore.kernel.org/oe-kbuild-all/202507282103.XJ3hBMdC-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507300932.cMHKVE2Y-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507301256.cZlxQ10s-lkp@intel.c=
om
    https://lore.kernel.org/oe-kbuild-all/202507301859.QJFfmnU0-lkp@intel.c=
om

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
    drivers/gpu/drm/msm/msm_gem.c:106:54: error: invalid use of undefined t=
ype 'struct msm_kms'
    drivers/gpu/drm/msm/msm_gem.c:669:1: warning: control reaches end of no=
n-void function [-Wreturn-type]
    drivers/gpu/drm/omapdrm/dss/dispc.c:527:32: warning: stack frame size (=
2688) exceeds limit (2048) in 'dispc_restore_context' [-Wframe-larger-than]
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
    ld.lld: error: undefined symbol: xt_hook_ops_alloc
    ld.lld: error: undefined symbol: xt_proto_fini
    ld.lld: error: undefined symbol: xt_proto_init
    ld.lld: error: undefined symbol: xt_register_targets
    ld.lld: error: undefined symbol: xt_register_template
    ld.lld: error: undefined symbol: xt_unregister_targets
    ld.lld: error: undefined symbol: xt_unregister_template
    security/apparmor/lsm.c:182:23: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]
    security/apparmor/lsm.c:182:44: warning: variable 'rules' set but not u=
sed [-Wunused-but-set-variable]
    vmlinux.o: warning: objtool: f2fs_parse_param+0x80: sibling call from c=
allable instruction with modified stack frame
    vmlinux.o: warning: objtool: register_exec_queue.llvm.10072903789061165=
268+0x84: sibling call from callable instruction with modified stack frame
    vmlinux.o: warning: objtool: watchdog+0x4dc: sibling call from callable=
 instruction with modified stack frame
    xtensa-linux-ld: net/ipv4/netfilter/arp_tables.o:(.init.literal+0x38): =
undefined reference to `xt_register_targets'
    xtensa-linux-ld: net/ipv4/netfilter/arp_tables.o:(.init.literal+0x4): u=
ndefined reference to `xt_proto_init'
    xtensa-linux-ld: net/ipv4/netfilter/arp_tables.o:(.init.literal+0x60): =
undefined reference to `xt_unregister_targets'
    xtensa-linux-ld: net/ipv4/netfilter/arptable_filter.o:(.init.literal+0x=
2c): undefined reference to `xt_register_template'
    xtensa-linux-ld: net/ipv4/netfilter/arptable_filter.o:(.init.literal+0x=
40): undefined reference to `xt_hook_ops_alloc'
    xtensa-linux-ld: net/ipv4/netfilter/arptable_filter.o:(.init.literal+0x=
4c): undefined reference to `xt_unregister_template'

Unverified Error/Warning (likely false positive, kindly check if interested=
):

    drivers/acpi/osl.c:210: undefined reference to `efi'
    ld: drivers/acpi/osl.c:210: undefined reference to `efi'

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
|-- arm-randconfig-004-20250730
|   |-- drivers-gpu-drm-msm-msm_gem.c:error:invalid-use-of-undefined-type-s=
truct-msm_kms
|   `-- drivers-gpu-drm-msm-msm_gem.c:warning:control-reaches-end-of-non-vo=
id-function
|-- arm-randconfig-051-20250730
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
|-- arm-randconfig-052-20250730
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
|-- arm-randconfig-053-20250730
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
|-- arm-randconfig-054-20250730
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
|-- arm-randconfig-055-20250730
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
|-- arm64-randconfig-051-20250730
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
|-- arm64-randconfig-052-20250730
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
|-- arm64-randconfig-053-20250730
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
|-- arm64-randconfig-054-20250730
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
|-- arm64-randconfig-055-20250730
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
|-- csky-randconfig-002-20250730
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- hexagon-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- hexagon-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- i386-randconfig-063-20250730
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
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-omapdrm-dss-dispc.c:warning:stack-frame-size-()-exc=
eeds-limit-()-in-dispc_restore_context
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- loongarch-defconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- loongarch-randconfig-002-20250730
|   |-- vmlinux.o:warning:objtool:f2fs_parse_param:sibling-call-from-callab=
le-instruction-with-modified-stack-frame
|   |-- vmlinux.o:warning:objtool:register_exec_queue.llvm.:sibling-call-fr=
om-callable-instruction-with-modified-stack-frame
|   `-- vmlinux.o:warning:objtool:watchdog:sibling-call-from-callable-instr=
uction-with-modified-stack-frame
|-- loongarch-randconfig-r051-20250730
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- m68k-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- m68k-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- openrisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- openrisc-randconfig-r112-20250730
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
|-- openrisc-randconfig-r131-20250730
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_c=
onfig-was-not-declared.-Should-it-be-static
|-- parisc-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- powerpc-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- riscv-defconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- s390-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-allmodconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-allyesconfig
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sh-randconfig-002-20250730
|   |-- air_en8811h.c:(.text):undefined-reference-to-clk_restore_context
|   `-- air_en8811h.c:(.text):undefined-reference-to-clk_save_context
|-- sparc-randconfig-001-20250730
|   `-- security-apparmor-lsm.c:warning:variable-rules-set-but-not-used
|-- sparc-randconfig-r133-20250730
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
|-- x86_64-randconfig-005-20250730
|   |-- ld.lld:error:undefined-symbol:xt_hook_ops_alloc
|   |-- ld.lld:error:undefined-symbol:xt_proto_fini
|   |-- ld.lld:error:undefined-symbol:xt_proto_init
|   |-- ld.lld:error:undefined-symbol:xt_register_targets
|   |-- ld.lld:error:undefined-symbol:xt_register_template
|   |-- ld.lld:error:undefined-symbol:xt_unregister_targets
|   `-- ld.lld:error:undefined-symbol:xt_unregister_template
|-- x86_64-randconfig-101-20250730
|   |-- drivers-acpi-osl.c:undefined-reference-to-efi
|   `-- ld:drivers-acpi-osl.c:undefined-reference-to-efi
|-- x86_64-randconfig-102-20250730
|   |-- ERROR:__devm_regmap_init_i3c-drivers-hwmon-tmp108.ko-undefined
|   |-- ERROR:i3c_device_do_priv_xfers-drivers-hwmon-lm75.ko-undefined
|   |-- ERROR:i3c_device_match_id-drivers-hwmon-lm75.ko-undefined
|   |-- ERROR:i3cdev_to_dev-drivers-hwmon-lm75.ko-undefined
|   `-- ERROR:i3cdev_to_dev-drivers-hwmon-tmp108.ko-undefined
|-- x86_64-randconfig-r111-20250730
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-ar=
gument-(different-address-spaces)-expected-char-const-str-got-char-const-no=
deref-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-driver_ptr_-got-cha=
r-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-as=
signment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-c=
har-const-noderef-__rcu
`-- xtensa-randconfig-r121-20250730
    |-- xtensa-linux-ld:net-ipv4-netfilter-arp_tables.o:(.init.literal):und=
efined-reference-to-xt_proto_init
    |-- xtensa-linux-ld:net-ipv4-netfilter-arp_tables.o:(.init.literal):und=
efined-reference-to-xt_register_targets
    |-- xtensa-linux-ld:net-ipv4-netfilter-arp_tables.o:(.init.literal):und=
efined-reference-to-xt_unregister_targets
    |-- xtensa-linux-ld:net-ipv4-netfilter-arptable_filter.o:(.init.literal=
):undefined-reference-to-xt_hook_ops_alloc
    |-- xtensa-linux-ld:net-ipv4-netfilter-arptable_filter.o:(.init.literal=
):undefined-reference-to-xt_register_template
    `-- xtensa-linux-ld:net-ipv4-netfilter-arptable_filter.o:(.init.literal=
):undefined-reference-to-xt_unregister_template

elapsed time: 727m

configs tested: 134
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250730    gcc-8.5.0
arc                   randconfig-002-20250730    gcc-14.3.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                       imx_v4_v5_defconfig    clang-22
arm                   randconfig-001-20250730    clang-22
arm                   randconfig-002-20250730    clang-20
arm                   randconfig-003-20250730    gcc-8.5.0
arm                   randconfig-004-20250730    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250730    clang-22
arm64                 randconfig-002-20250730    clang-20
arm64                 randconfig-003-20250730    clang-17
arm64                 randconfig-004-20250730    clang-22
csky                             alldefconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250730    gcc-14.3.0
csky                  randconfig-002-20250730    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250730    clang-20
hexagon               randconfig-002-20250730    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250730    clang-20
i386        buildonly-randconfig-002-20250730    clang-20
i386        buildonly-randconfig-003-20250730    gcc-12
i386        buildonly-randconfig-004-20250730    gcc-12
i386        buildonly-randconfig-005-20250730    clang-20
i386        buildonly-randconfig-006-20250730    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250730    clang-22
loongarch             randconfig-002-20250730    clang-20
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
nios2                 randconfig-001-20250730    gcc-11.5.0
nios2                 randconfig-002-20250730    gcc-9.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250730    gcc-14.3.0
parisc                randconfig-002-20250730    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                      arches_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250730    gcc-8.5.0
powerpc               randconfig-002-20250730    gcc-8.5.0
powerpc               randconfig-003-20250730    clang-22
powerpc                     taishan_defconfig    clang-17
powerpc                     tqm8548_defconfig    clang-22
powerpc                 xes_mpc85xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250730    clang-22
powerpc64             randconfig-002-20250730    clang-22
powerpc64             randconfig-003-20250730    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250730    gcc-10.5.0
riscv                 randconfig-002-20250730    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250730    clang-20
s390                  randconfig-002-20250730    gcc-15.1.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250730    gcc-12.5.0
sh                    randconfig-002-20250730    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250730    gcc-14.3.0
sparc                 randconfig-002-20250730    gcc-14.3.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250730    clang-22
sparc64               randconfig-002-20250730    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250730    gcc-11
um                    randconfig-002-20250730    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250730    gcc-12
x86_64      buildonly-randconfig-002-20250730    clang-20
x86_64      buildonly-randconfig-003-20250730    clang-20
x86_64      buildonly-randconfig-004-20250730    clang-20
x86_64      buildonly-randconfig-005-20250730    clang-20
x86_64      buildonly-randconfig-006-20250730    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250730    gcc-11.5.0
xtensa                randconfig-002-20250730    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


