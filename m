Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FC8CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 07:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300996B0088; Tue,  6 Oct 2026 03:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B09E6B008C; Tue,  6 Oct 2026 03:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0186B0092; Tue,  6 Oct 2026 03:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E18856B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 03:30:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF1B3A0583
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:30:07 +0000 (UTC)
X-FDA: 85291377654.07.7FF0336
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69B0740002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:30:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nl7IGdsO;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791271806;
	b=m2BpaM7+fUJtvPJlY3d9JbAhhgl3H0NcGKTnPbMI6/8IQX9HNbSrJ1gnSxGHDf+ZGAAMBk
	lQoNl2NGmODWaiVzilFr9FvoVcORj4l3zNIm74XDxSMKhFIzapNc3k+pgzizPIBguDTl+3
	aKY0pGYsUZYR1VXMvs0XCS3jttf5O14=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nl7IGdsO;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791271806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=JMDVOAY9jwfZtq+AFh7LYF/mQID5gkT/6IYOYraLF6U=;
	b=BCPkkY38i82FIGQEAoEcWgZG3wqZsfx3/nWHe0lgz7HKWaot+cT9HYHPNPNv4x9u2Y3N6p
	DKF+DSfmxeJQpDdZam0+EdFu2ExnzB2KOXsO/8Vhe6PVNwUNW1drAXsoOTXmDbDMrUhQh1
	xvSAuepKf/egZoVlR3KapV9KvFLeE0s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791271805; x=1822807805;
  h=date:from:to:cc:subject:message-id;
  bh=IKfu4pIBV+iDMDDbCR2G7kxUcMQGoAqodbenjZvTua0=;
  b=Nl7IGdsO0+QPMoXeJQ8pRQ318UkO+4mqraj0KUsTUPeF7luW/J13IGOu
   AtYb3Yb8H0EdBuNXLRJ53PArjCwfjSUVWE2tGNvhAVZ2mArheins3H31E
   UA6J1+IquKVNbiDBkhRL3zdU6dD1bt8Z8z+bafLUEg0FbnaspJP+Z02vZ
   pMT8yfLZmVM8LJ5dnBVcE4j05vLzagvOiUuV8YvzHfP2uCFTx3GoH/ch3
   yWpc4DLoZ0NnjmtIbrE//IeBokekOAzc42hi9PsPXKb2z2H3ABpqE6skz
   5Uvg7xKSWYMLTrjZnL3wgXlRdx/Jc+Mca3AaEgi+ym1UGSegzbLm4DrUH
   w==;
X-CSE-ConnectionGUID: F0zwrUE/SnKv3E3E6w6N3w==
X-CSE-MsgGUID: DTVMGU9zTeOnniRsXlVL3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="2692"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="2692"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 00:30:04 -0700
X-CSE-ConnectionGUID: 9chQM1TdQtO5zAoMc0pakw==
X-CSE-MsgGUID: zUuXrxlcSJO7GiwR23xdHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="303348863"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 06 Oct 2026 00:30:02 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDzcd-000000001Ii-2z8r;
	Tue, 06 Oct 2026 07:29:59 +0000
Date: Tue, 06 Oct 2026 15:29:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 bf1ee2bd5c2da8992f33c8950ef194aaff74ed6c
Message-ID: <202610061509.1b5HH3vz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: us3qomyzs5nhc89w1itjq97ac79388oh
X-Rspamd-Queue-Id: 69B0740002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791271805-710916
X-HE-Meta: U2FsdGVkX185+KwFQtJrT/Kd5Ps4yjkzuOGU9hM4yewhspwDBqvvEIVG9adcwMdKzReNCdCothYkVpf2DRBVDNIuIA6/xgfwKHYOrxT3UjLxzh4TAhRpepxj+v0AJLxxslAn4x0PhkP1J+oLJWEuE0OIl87ukiCQg0WYNlwCQgw/esOGaSFEj4Gx2taFTrrRPgsFmVLuRb9SSDEl6lXa5T9cRt7fN1+yjMUjxbU205GteKaBAxLtfbFwrlXy/h3GYyEhQmgMwjwS9HSMeAPA6I40V+L6ZJbuCYk1pKIH9oYKPDgF8qL9yAWg1SqP+Y1MUjrrGtRC5b5knDXdjmWpYoI4vAE2NXcHVvVeaFUqZS3jBUft1BIQrRIyRa68TEXlArCqTc6DeJiOT/T8SvoAQ9uDeO2iTdHloLT8hL1J1YlNMBESeS92RoHkvv8chSStLt5QD7dbWKmOxQu270Aoby4RAQVkUiWVC9Ez3FLBOP8ONmZmROjPEEbX4bBWDjAhkJHtefB3/P9iwUP0y8bPFTlzhpcsTXNYSlmUCpIoCWnRztICs1RhiiO/pI0nLwtiqMo+L7EyfaXDJpO28g9fOjoNC6fm/3yl9TFzXLJgIC9i6+BKzUPbJ7pYdENYiPQvatG6SXe7gb1J3l+P5MF7OF3xmLq6B3kD2EMCFktSWOGk1uSNESENXAVnMOeuKb42IM18fmRgbYhO9ckh/aWTLR3/LHXJfjyFbNvHjJPAZvG9wIPXAZHsrBIIBVHGYNQYoHjKJT8sXg+PBS4xjuuB9CVMTkfxhl95T0N7kI8eI4QhkHdRnb2nyMgdoVTozuChXfP8actTffAoyO+mbG0+A3a15SbHhYt3QsJcy1a1C8mikW4kXNATXv4vcp3dJ4mIJqLm0547RHbzBxI0WJHiFlpMfY73KNwK5yc2PoIGcAg5zsIrtbxaG+yMc4tb4LZbhJaH1tFnrXTzeuFk9rP
 7jjmh9zR
 WKtNc2XaMzMCgOkNpxnzpio87bOGnQHKVPjTIMCaKH1ElR+/bJSjmBuuutL4rKIPYSmpfIjFGSnhDdI24WyCK4QEby70TW4GrHCv5wQjPU4BI7lG6Oq0C6i1XF8wqbCurvYbLYmjXSuqSkXLOoFj3xbL6HfpCo+tx1g9EQwTTLeq+IBfKmdTnlN8G/y2/aSr1epY+bbJCfyS68cdsY+iAdztePzUp+/W0NSS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: bf1ee2bd5c2da8992f33c8950ef194aaff74ed6c  Add linux-next specific files for 20261005

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202610051807.3sDuXnvJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202610052316.dkfB7EcZ-lkp@intel.com

    arch/arm/boot/dts/nxp/imx/imx6q-novena.dtb: stmpe811@44 (st,stmpe811): 'irq-gpio' does not match any of the regexes: '^pinctrl-[0-9]+$'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202610051608.pBAgujgg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202610052015.jmbMsWHP-lkp@intel.com

    drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c:1535:1: internal compiler error: in final_scan_insn_1, at final.cc:2823
    drivers/perf/cxl_pmu.c:1044 cxl_pmu_probe() warn: right shifting more than type allows 64 vs 64
    fs/ntfs/attrib.c:4719 ntfs_non_resident_attr_expand() warn: missing unwind goto?

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-2403-20260930
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-novena.dtb:stmpe811-(st-stmpe811):irq-gpio-does-not-match-any-of-the-regexes:pinctrl
|-- csky-randconfig-r2101-20261005
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mes.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- i386-randconfig-2200-20261005
|   `-- drivers-perf-cxl_pmu.c-cxl_pmu_probe()-warn:right-shifting-more-than-type-allows-vs
|-- x86_64-randconfig-2200-20261003
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_hdmi_frl.c-hdmi_frl_perform_link_training()-warn:inconsistent-indenting
`-- x86_64-randconfig-2200-20261005
    `-- fs-ntfs-attrib.c-ntfs_non_resident_attr_expand()-warn:missing-unwind-goto

elapsed time: 1104m

configs tested: 389
configs skipped: 7

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    clang-24
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2200-20261005    gcc-9.5.0  smatch
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                          haps_hs_defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    clang-24
arc                   randconfig-1000-20261005    gcc-15.2.0
arc                   randconfig-1000-20261006    clang-24
arc                   randconfig-1001-20261005    gcc-9.5.0
arc                   randconfig-1001-20261006    clang-24
arc                  randconfig-r2202-20261005    gcc-14.3.0 smatch
arc                  randconfig-r2306-20261005    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                         mvebu_v7_defconfig    clang-24
arm                           pxa3xx_defconfig    clang-17
arm                           pxa3xx_defconfig    clang-24
arm                   randconfig-1000-20261005    gcc-8.5.0
arm                   randconfig-1000-20261006    clang-24
arm                   randconfig-1001-20261005    gcc-11.5.0
arm                   randconfig-1001-20261006    clang-24
arm                   randconfig-1002-20261005    gcc-10.5.0
arm                   randconfig-1002-20261006    clang-24
arm                   randconfig-1003-20261005    clang-17
arm                   randconfig-1003-20261006    clang-24
arm                  randconfig-r2107-20261005    clang-24   cocci
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261005    gcc-8.5.0
arm64                 randconfig-1000-20261006    gcc-16.1.0
arm64                 randconfig-1001-20261005    clang-21
arm64                 randconfig-1001-20261006    gcc-16.1.0
arm64                 randconfig-1002-20261005    gcc-8.5.0
arm64                 randconfig-1002-20261006    gcc-16.1.0
arm64                 randconfig-1003-20261005    clang-19
arm64                 randconfig-1003-20261006    gcc-16.1.0
arm64                randconfig-r2103-20261005    gcc-13.4.0 cocci
arm64                randconfig-r2307-20261005    gcc-14.3.0 sparse
arm64                randconfig-r2309-20261005    gcc-15.2.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261005    gcc-16.1.0
csky                  randconfig-1000-20261006    gcc-16.1.0
csky                  randconfig-1001-20261005    gcc-16.1.0
csky                  randconfig-1001-20261006    gcc-16.1.0
csky                 randconfig-r2306-20261005    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261005    clang-22
hexagon               randconfig-1000-20261006    gcc-13.4.0
hexagon               randconfig-1001-20261005    clang-24
hexagon               randconfig-1001-20261006    gcc-13.4.0
hexagon              randconfig-r2107-20261005    clang-24   cocci
hexagon              randconfig-r2308-20261005    clang-24   sparse
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261005    clang-22
i386        buildonly-randconfig-1000-20261006    gcc-14
i386        buildonly-randconfig-1001-20261005    clang-22
i386        buildonly-randconfig-1001-20261006    gcc-14
i386        buildonly-randconfig-1002-20261005    gcc-13
i386        buildonly-randconfig-1002-20261006    gcc-14
i386        buildonly-randconfig-1003-20261005    gcc-14
i386        buildonly-randconfig-1003-20261006    gcc-14
i386        buildonly-randconfig-1004-20261005    clang-22
i386        buildonly-randconfig-1004-20261006    gcc-14
i386        buildonly-randconfig-1005-20261005    gcc-13
i386        buildonly-randconfig-1005-20261006    gcc-14
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261005    gcc-13
i386                  randconfig-1000-20261006    gcc-14
i386                  randconfig-1001-20261005    clang-22
i386                  randconfig-1001-20261006    gcc-14
i386                  randconfig-1002-20261005    clang-22
i386                  randconfig-1002-20261006    gcc-14
i386                  randconfig-1003-20261005    gcc-14
i386                  randconfig-1003-20261006    gcc-14
i386                  randconfig-1004-20261005    clang-22
i386                  randconfig-1004-20261006    gcc-14
i386                  randconfig-1005-20261005    clang-22
i386                  randconfig-1005-20261006    gcc-14
i386                  randconfig-1006-20261005    clang-22
i386                  randconfig-1006-20261006    gcc-14
i386                  randconfig-1007-20261006    clang-22
i386                  randconfig-1007-20261006    gcc-14
i386                  randconfig-1008-20261006    gcc-14
i386                  randconfig-1009-20261006    gcc-14
i386                  randconfig-1010-20261006    gcc-13
i386                  randconfig-1010-20261006    gcc-14
i386                  randconfig-1011-20261006    clang-22
i386                  randconfig-1011-20261006    gcc-14
i386                  randconfig-1012-20261006    clang-22
i386                  randconfig-1012-20261006    gcc-14
i386                  randconfig-1013-20261006    clang-22
i386                  randconfig-1013-20261006    gcc-14
i386                  randconfig-2100-20261005    gcc-14     cocci
i386                  randconfig-2101-20261005    gcc-14     cocci
i386                  randconfig-2102-20261005    clang-22   cocci
i386                  randconfig-2102-20261005    gcc-14     cocci
i386                  randconfig-2103-20261005    clang-22   cocci
i386                  randconfig-2103-20261005    gcc-14     cocci
i386                  randconfig-2200-20261005    gcc-14     smatch
i386                  randconfig-2300-20261005    gcc-14     sparse
i386                  randconfig-2301-20261005    gcc-13     sparse
i386                  randconfig-2302-20261005    clang-22   sparse
i386                 randconfig-r2106-20261005    gcc-14     cocci
i386                 randconfig-r2300-20261005    gcc-14     sparse
i386                 randconfig-r2305-20261005    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261005    clang-18
loongarch             randconfig-1000-20261006    gcc-13.4.0
loongarch             randconfig-1001-20261005    gcc-16.1.0
loongarch             randconfig-1001-20261006    gcc-13.4.0
loongarch            randconfig-r2200-20261005    clang-24   smatch
loongarch            randconfig-r2202-20261005    gcc-16.1.0 smatch
loongarch            randconfig-r2301-20261006    clang-18   sparse
loongarch            randconfig-r2308-20261005    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.1.0
m68k                           amiga_defconfig    clang-24
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2103-20261005    clang-22   cocci
m68k                 randconfig-r2104-20261005    gcc-16.1.0 cocci
m68k                 randconfig-r2306-20261005    gcc-14.3.0 sparse
microblaze                        alldefconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2105-20261005    gcc-8.5.0  cocci
microblaze           randconfig-r2200-20261005    gcc-9.5.0  smatch
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261005    gcc-8.5.0
nios2                 randconfig-1000-20261006    gcc-13.4.0
nios2                 randconfig-1001-20261005    gcc-9.5.0
nios2                 randconfig-1001-20261006    gcc-13.4.0
nios2                randconfig-r2101-20261005    clang-22   cocci
nios2                randconfig-r2104-20261005    clang-24   cocci
nios2                randconfig-r2106-20261005    clang-24   cocci
nios2                randconfig-r2201-20261005    gcc-11.5.0 smatch
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2309-20261005    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261005    gcc-8.5.0
parisc                randconfig-1000-20261006    gcc-14.3.0
parisc                randconfig-1001-20261005    gcc-15.2.0
parisc                randconfig-1001-20261006    gcc-14.3.0
parisc               randconfig-r2102-20261005    gcc-9.5.0  cocci
parisc               randconfig-r2201-20261005    gcc-8.5.0  smatch
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc                       ppc44x_defconfig    clang-17
powerpc               randconfig-1000-20261005    gcc-14.3.0
powerpc               randconfig-1000-20261006    gcc-14.3.0
powerpc               randconfig-1001-20261005    clang-24
powerpc               randconfig-1001-20261006    gcc-14.3.0
powerpc              randconfig-r2301-20261005    gcc-8.5.0  sparse
powerpc                      tqm8548_defconfig    clang-24
powerpc                         warp_defconfig    gcc-16.1.0
powerpc                          wii_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261005    clang-17
powerpc64             randconfig-1000-20261006    gcc-14.3.0
powerpc64             randconfig-1001-20261005    clang-19
powerpc64             randconfig-1001-20261006    gcc-14.3.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                     nommu_virt_defconfig    clang-24
riscv                 randconfig-1000-20261005    gcc-8.5.0
riscv                 randconfig-1000-20261006    clang-24
riscv                 randconfig-1001-20261005    gcc-16.1.0
riscv                 randconfig-1001-20261006    clang-24
riscv                 randconfig-2000-20261005    gcc-13.4.0
riscv                 randconfig-2000-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-8.5.0
riscv                randconfig-r2304-20261005    gcc-13.4.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261005    clang-17
s390                  randconfig-1000-20261006    clang-24
s390                  randconfig-1001-20261005    gcc-16.1.0
s390                  randconfig-1001-20261006    clang-24
s390                  randconfig-2000-20261005    gcc-13.4.0
s390                  randconfig-2000-20261005    gcc-16.1.0
s390                  randconfig-2001-20261005    clang-24
s390                  randconfig-2001-20261005    gcc-16.1.0
s390                 randconfig-r2303-20261005    clang-24   sparse
s390                 randconfig-r2308-20261005    gcc-14.3.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261005    gcc-16.1.0
sh                    randconfig-1000-20261006    clang-24
sh                    randconfig-1001-20261005    gcc-16.1.0
sh                    randconfig-1001-20261006    clang-24
sh                    randconfig-2000-20261005    gcc-12.5.0
sh                    randconfig-2000-20261005    gcc-16.1.0
sh                    randconfig-2001-20261005    gcc-16.1.0
sh                   randconfig-r2105-20261005    gcc-14.3.0 cocci
sh                   randconfig-r2202-20261005    gcc-16.1.0 smatch
sh                   randconfig-r2309-20261005    gcc-14.3.0 sparse
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261005    gcc-15.2.0
sparc                 randconfig-1000-20261006    gcc-14
sparc                 randconfig-1001-20261005    gcc-13.4.0
sparc                 randconfig-1001-20261006    gcc-14
sparc                 randconfig-2000-20261005    clang-17
sparc                 randconfig-2000-20261005    gcc-8.5.0
sparc                 randconfig-2001-20261005    clang-17
sparc                 randconfig-2001-20261005    gcc-16.1.0
sparc                randconfig-r2101-20261005    gcc-16.1.0 cocci
sparc                randconfig-r2307-20261005    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261005    gcc-14.3.0
sparc64               randconfig-1000-20261006    gcc-14
sparc64               randconfig-1001-20261005    gcc-12.5.0
sparc64               randconfig-1001-20261006    gcc-14
sparc64               randconfig-2000-20261005    clang-17
sparc64               randconfig-2000-20261005    gcc-8.5.0
sparc64               randconfig-2001-20261005    clang-17
sparc64               randconfig-2001-20261005    gcc-15.2.0
sparc64              randconfig-r2105-20261005    clang-24   cocci
sparc64              randconfig-r2302-20261005    gcc-15.2.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261005    clang-24
um                    randconfig-1000-20261006    gcc-14
um                    randconfig-1001-20261005    gcc-14
um                    randconfig-1001-20261006    gcc-14
um                    randconfig-2000-20261005    clang-17
um                    randconfig-2000-20261005    clang-24
um                    randconfig-2001-20261005    clang-17
um                   randconfig-r2107-20261005    clang-24   cocci
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261005    gcc-13
x86_64      buildonly-randconfig-1000-20261006    gcc-14
x86_64      buildonly-randconfig-1001-20261005    clang-22
x86_64      buildonly-randconfig-1001-20261006    gcc-14
x86_64      buildonly-randconfig-1002-20261005    clang-22
x86_64      buildonly-randconfig-1002-20261006    gcc-14
x86_64      buildonly-randconfig-1003-20261005    clang-22
x86_64      buildonly-randconfig-1003-20261006    gcc-14
x86_64      buildonly-randconfig-1004-20261005    clang-22
x86_64      buildonly-randconfig-1004-20261006    gcc-14
x86_64      buildonly-randconfig-1005-20261005    gcc-14
x86_64      buildonly-randconfig-1005-20261006    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261005    gcc-14
x86_64                randconfig-1000-20261006    gcc-14
x86_64                randconfig-1001-20261005    gcc-14
x86_64                randconfig-1001-20261006    gcc-14
x86_64                randconfig-1002-20261005    gcc-14
x86_64                randconfig-1002-20261006    gcc-14
x86_64                randconfig-1003-20261005    clang-22
x86_64                randconfig-1003-20261006    gcc-14
x86_64                randconfig-1004-20261005    clang-22
x86_64                randconfig-1004-20261006    gcc-14
x86_64                randconfig-1005-20261005    gcc-14
x86_64                randconfig-1005-20261006    gcc-14
x86_64                randconfig-1006-20261005    gcc-14
x86_64                randconfig-1006-20261006    gcc-14
x86_64                randconfig-1007-20261005    clang-22
x86_64                randconfig-1007-20261006    gcc-14
x86_64                randconfig-1008-20261005    clang-22
x86_64                randconfig-1008-20261006    gcc-14
x86_64                randconfig-1009-20261005    gcc-13
x86_64                randconfig-1009-20261006    gcc-14
x86_64                randconfig-1010-20261005    gcc-14
x86_64                randconfig-1010-20261006    gcc-14
x86_64                randconfig-1011-20261005    gcc-14
x86_64                randconfig-1011-20261006    gcc-14
x86_64                randconfig-1012-20261006    gcc-14
x86_64                randconfig-1013-20261006    clang-22
x86_64                randconfig-1013-20261006    gcc-14
x86_64                randconfig-1014-20261006    clang-22
x86_64                randconfig-1014-20261006    gcc-14
x86_64                randconfig-1015-20261006    clang-22
x86_64                randconfig-1015-20261006    gcc-14
x86_64                randconfig-1016-20261006    gcc-14
x86_64                randconfig-1017-20261006    clang-22
x86_64                randconfig-1017-20261006    gcc-14
x86_64                randconfig-2100-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    gcc-14     cocci
x86_64                randconfig-2102-20261005    clang-22   cocci
x86_64                randconfig-2102-20261005    gcc-14     cocci
x86_64                randconfig-2103-20261005    clang-22   cocci
x86_64                randconfig-2200-20261005    clang-22   smatch
x86_64                randconfig-2300-20261005    clang-22   sparse
x86_64                randconfig-2301-20261005    gcc-14     sparse
x86_64                randconfig-2302-20261005    clang-22   sparse
x86_64               randconfig-r2102-20261005    clang-22   cocci
x86_64               randconfig-r2106-20261005    gcc-12     cocci
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261005    gcc-13.4.0
xtensa                randconfig-1000-20261006    gcc-14
xtensa                randconfig-1001-20261005    gcc-8.5.0
xtensa                randconfig-1001-20261006    gcc-14
xtensa                randconfig-2000-20261005    clang-17
xtensa                randconfig-2000-20261005    gcc-8.5.0
xtensa                randconfig-2001-20261005    clang-17
xtensa                randconfig-2001-20261005    gcc-12.5.0
xtensa               randconfig-r2100-20261005    clang-22   cocci
xtensa               randconfig-r2100-20261005    gcc-8.5.0  cocci
xtensa               randconfig-r2104-20261005    gcc-15.2.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

