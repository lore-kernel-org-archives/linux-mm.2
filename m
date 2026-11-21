Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F3C606A331
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 03:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kM+xDCsg
Received: by kanga.kvack.org (Postfix)
	id 211596B00EF; Fri, 20 Nov 2026 22:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C28B6B05B0; Fri, 20 Nov 2026 22:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2346B05B1; Fri, 20 Nov 2026 22:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA7506B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:35:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD8F5802F8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:35:41 +0000 (UTC)
X-FDA: 85457711682.07.2ACC84B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29BED100005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:35:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kM+xDCsg;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795232140;
	b=BGwjGIrDB5TiN6KW2jTIlq/OwCYyaSo2SS04E2bre5wKtg1au+6SqJduU8iSca1+Mko185
	rlEBIiTrKzYFzMmPpc+v1BG1dTtENqs9SeByltL9BXSiUPm+2RQuLHZiVt8ueQCsoRWhdc
	8x427rxkaSP3ZjeC7B9gREAhxrTN6z4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795232140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=x0wyyb0GDIQasB+NEUF0o6AKWcR3WlqLuusXyeIXgvU=;
	b=8kLYH540NVXm703X/NHRZi7Qg20kLA3W2+7v1e7AUzF4oEbUyJIfQ9S3dQBB8p1AUQ1w8e
	iDZZQqy2bzLA6yRoWcjlYdiIZQc5wCLLaYoCrHssVnnDAiD7fsQG2LrwApRHj1+BZI7xF7
	NQRBjywSPW6KHub9JF+fjB4/jehHUPw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kM+xDCsg;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795232139; x=1826768139;
  h=date:from:to:cc:subject:message-id;
  bh=9cMegaJszlaf49pFneG+rnAewjY+7WBWq9r3mE2PAuE=;
  b=kM+xDCsgm2uaciBpS1tC8pwLwLCJXn4jYELVwcHxcRwWYASEG7KcCarv
   mur9/iuVXk43Nenb0TIQWCXrml7HpD/fNf0qiPiWjdrnmpTqko9qOV6QJ
   71Sx0P256D13PJOg7RsuZfppWIFY4SNzg/TO9DqWKZphOZc6wLYCSBLEw
   jymgCAFdADGIBGLftPXUaDHCJOBJAp/L3BLZo5MBaaEhfqcKetiBz5mlC
   S7bA5TjsQhfp71Q50nYAnxcxhZTE3TU99hZdaxq9Tkiy9Xc+v931W/uTo
   +iUMgCEffKFzBJ20Tbyp/0STmtQ0oByGVFs3ot7Eo6/ECsn+7PjkQLBfl
   w==;
X-CSE-ConnectionGUID: F/DG8MFjTXatBW+xgjq+/g==
X-CSE-MsgGUID: 5w+cheIGSSaGq/3erX8Y0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4032914"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4032914"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 19:35:37 -0800
X-CSE-ConnectionGUID: 8hgLMzGqRz+QK8ZgbUB0LA==
X-CSE-MsgGUID: YVMPVdB8QQeK5vsh+clW5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="10735600"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 20 Nov 2026 19:35:36 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUbsz-00000001JQx-0DMi;
	Sat, 21 Nov 2026 03:35:33 +0000
Date: Sat, 21 Nov 2026 11:35:17 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 adcad7f4e6332cff3d6d7165f41584899f598534
Message-ID: <20261121113517.NfczDB9D-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Rspamd-Queue-Id: 29BED100005
X-Stat-Signature: jm3mznxeutua5x8buzh3o9e5nrhpyko6
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795232138-473959
X-HE-Meta: U2FsdGVkX1/aNJeW8jKEr23coR5dZIz2zCExA1pWv4qBF69Li7mc1+eftMdob8+pjewTgrSwnpEcxXcI9I4IkmLMrdsMZeuWSdVVteUzlymSkWg3i7PsorfKxrv/0xw2I807DGllDsEHmLTosT3VcLhC1yWoSuAKOkubkdjSpqEDkBMJ96Z9h2An/oW4OVRC9/3CdqwjFG09cVo+406youl3H1FWkLxi3dJz1RSb9jBu8wuh8scAy5CXiE/WRF8P6WB0N5KDLspMmIoJZ549EEG0UMgT4Ak/SWjd9PhpCXfwUq6As/BSiqqwERf26MTjSV9fUuQMQK1Ilei13omrvbtl4JN1+IgjTDr6T/fsiLF9OzBMgq5lfEkXFjVI1IBKq9IcfgG+SZDW+pRx8eB+0TMlY3vUGGFtmBslezQYr5TPh367NJb35R3xWd1QCp0ngWq+1aSYRXC25sPPYqhpG7phcdw2F7ls3ACSn6WMckaV1I9kG+oye/BBXO50NiDl8C76W3hgXFBnxnKElhggGC9lz64mK00WV6anasPzDOk/BsJH/zKOJuwc1oncTfBY7dVj+MpM9/TfqGHFsjGGpzF0CDzhbKAtA6bkqqwhyOT78PWhY2qouQDeyFjpia22ymEWceIWSDbp4Eblae21CVzc9otBnrBILqamKL9unANXj7HsMCUpn9lWg0wEUsCuGIntQi2GmK3boF4aCve4EVJuk7g2DidfzR2CP0fw9lsfBSqCgGAhsT01kDpPBk9xN/yi83IEOet0e24R29e4lK1sE7JbgMin6Yum2c528efRnjqcp1DPGREdE4KXO4RE6D27nmdV15Vf85SapgD89ACpNBT1ASSM8owpyP4RQ23VHeI3cmFuxsfYtXutvbprPwDiaomA52fg0AKvIodt9wXahfr8yxQpem+xPOfxQImcWcGIXX911muN3bNlfsDxGAcxPibKtBI3ieGzHPl
 lFADBplb
 euF0P8WBEcKj8QFlenXadEO4KqxLEK7BwPSG4hH7XSO3CyFKUf8tPDvY2tGns4VVBFfLecMWV7y7VdMStLYO4lcm5bYDc/PZTuLGd40iydSHONS/ROGLW/0eIDn6q4I6tgyoIfdBGg1z03Hma6+pRMsGCH+EpxUeQg083ZUJDTdo+90+ANvF5jHKR0BmHctgKSKA6uTE9oYD4EYRxn4JbpG6KWeAUa/V2J0WynGHqfYOpVsddwtTMCb74W3zJx431ghniqarWfNK8QwK3jSkQrsdxAZUcY+sTYc15U6nUPBTyfLRPEPgmJrM+Mb1gJnlfs3UXqF5uGCtp8BE5eurq2jVv8aQFk/txSLudkwH/SPrPZ/1Uw4etfxwNiAItqabS1oK+YU+yqCMbWVJ2YQbxhRCihovVDFjtsHDV2su+JaBOdT650LKHSd3xCLtEC67Kpdzhckbvv7uR9WSYDcXEoSDTamJHJsHOUz9U7kozvUopG7LtofL0Ge56qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: adcad7f4e6332cff3d6d7165f41584899f598534  Add linux-next specific files for 20261119

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/20261120075259.lBe4Stwa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/20261120134933.rRjrKaaL-lkp@intel.com

    {standard input}:54363: Error: operand out of range (0xffffffff not between 0 and 0x3f) `l.slli r11,r2,-1'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/20261120024705.y3mEBTWi-lkp@intel.com

    drivers/platform/asus/asus-wmi.c:2513 asus_new_rfkill() warn: '*rfkill' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r2109-20261120
|   `-- drivers-phy-rockchip-phy-rockchip-inno-usb2.c:Unneeded-variable:ret-Return-on-line
|-- openrisc-randconfig-r2108-20261120
|   `-- standard-input:Error:operand-out-of-range-(-not-between-and-)-l.slli-r11-r2
`-- riscv-randconfig-2200-20261120
    `-- drivers-platform-asus-asus-wmi.c-asus_new_rfkill()-warn:rfkill-is-an-error-pointer-or-valid

elapsed time: 1323m

configs tested: 543
configs skipped: 13

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261119    gcc-10.5.0
alpha                 randconfig-2000-20261120    gcc-15.3.0
alpha                 randconfig-2001-20261119    gcc-8.5.0
alpha                 randconfig-2001-20261120    gcc-15.3.0
alpha                 randconfig-2200-20261119    gcc-12.5.0 smatch
alpha                 randconfig-2200-20261120    gcc-15.3.0 smatch
alpha                randconfig-r2103-20261120    gcc-12.5.0 cocci
alpha                randconfig-r2106-20261120    gcc-16.2.0 cocci
alpha                randconfig-r2303-20261120    clang-17   sparse
alpha                randconfig-r2311-20261119    gcc-13.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                           axs103_defconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                          haps_hs_defconfig    gcc-16.2.0
arc                      haps_hs_smp_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261120    clang-17
arc                   randconfig-1000-20261121    clang-24
arc                   randconfig-1001-20261120    clang-17
arc                   randconfig-1001-20261121    clang-24
arc                   randconfig-2000-20261119    gcc-14.4.0
arc                   randconfig-2000-20261120    gcc-11.5.0
arc                   randconfig-2001-20261119    gcc-16.2.0
arc                   randconfig-2001-20261120    gcc-11.5.0
arc                   randconfig-2002-20261119    gcc-14.4.0
arc                   randconfig-2002-20261120    gcc-11.5.0
arc                   randconfig-2003-20261119    gcc-16.2.0
arc                   randconfig-2003-20261120    gcc-11.5.0
arc                   randconfig-2004-20261119    gcc-14.4.0
arc                   randconfig-2004-20261120    gcc-11.5.0
arc                   randconfig-2005-20261119    gcc-12.5.0
arc                   randconfig-2005-20261120    gcc-11.5.0
arc                   randconfig-2200-20261120    gcc-15.3.0 smatch
arc                  randconfig-r2101-20261120    gcc-16.2.0 cocci
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                          bcm2835_defconfig    clang-24
arm                           collie_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                             hisi_defconfig    gcc-16.2.0
arm                    milbeaut_m10v_defconfig    gcc-16.2.0
arm                         neponset_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261120    clang-17
arm                   randconfig-1000-20261121    clang-24
arm                   randconfig-1001-20261120    clang-17
arm                   randconfig-1001-20261121    clang-24
arm                   randconfig-1002-20261120    clang-17
arm                   randconfig-1002-20261121    clang-24
arm                   randconfig-1003-20261120    clang-17
arm                   randconfig-1003-20261121    clang-24
arm                   randconfig-2000-20261119    gcc-16.2.0
arm                   randconfig-2000-20261120    gcc-8.5.0
arm                   randconfig-2001-20261119    gcc-8.5.0
arm                   randconfig-2001-20261120    gcc-8.5.0
arm                   randconfig-2002-20261119    clang-24
arm                   randconfig-2002-20261120    gcc-8.5.0
arm                   randconfig-2200-20261119    clang-24   smatch
arm                   randconfig-2200-20261120    clang-17   smatch
arm                  randconfig-r2105-20261120    gcc-16.2.0 cocci
arm                  randconfig-r2108-20261120    gcc-14.4.0 cocci
arm                  randconfig-r2305-20261119    gcc-13.5.0 sparse
arm                  randconfig-r2307-20261120    gcc-15.3.0 sparse
arm                  randconfig-r2308-20261119    gcc-8.5.0  sparse
arm                  randconfig-r2310-20261120    gcc-15.3.0 sparse
arm                        spear13xx_defconfig    gcc-16.2.0
arm                         spear3xx_defconfig    gcc-16.2.0
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261120    clang-18
arm64                 randconfig-1000-20261121    gcc-8.5.0
arm64                 randconfig-1001-20261120    clang-18
arm64                 randconfig-1001-20261121    gcc-8.5.0
arm64                 randconfig-1002-20261120    clang-18
arm64                 randconfig-1002-20261121    gcc-8.5.0
arm64                 randconfig-1003-20261120    clang-18
arm64                 randconfig-1003-20261121    gcc-8.5.0
arm64                 randconfig-2000-20261119    gcc-13.5.0
arm64                 randconfig-2000-20261120    gcc-8.5.0
arm64                 randconfig-2001-20261119    clang-24
arm64                 randconfig-2001-20261120    gcc-8.5.0
arm64                 randconfig-2002-20261119    gcc-8.5.0
arm64                 randconfig-2002-20261120    gcc-8.5.0
arm64                 randconfig-2200-20261119    clang-17   smatch
arm64                randconfig-r2301-20261119    gcc-13.5.0 sparse
arm64                randconfig-r2309-20261120    gcc-14     sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261120    clang-18
csky                  randconfig-1000-20261121    gcc-8.5.0
csky                  randconfig-1001-20261120    clang-18
csky                  randconfig-1001-20261121    gcc-8.5.0
csky                  randconfig-2000-20261119    gcc-16.2.0
csky                  randconfig-2000-20261120    gcc-16.2.0
csky                  randconfig-2001-20261119    gcc-16.2.0
csky                  randconfig-2001-20261120    gcc-16.2.0
csky                  randconfig-2200-20261119    gcc-16.2.0 smatch
csky                  randconfig-2200-20261120    gcc-15.3.0 smatch
csky                 randconfig-r2104-20261120    gcc-12.5.0 cocci
csky                 randconfig-r2300-20261120    clang-24   sparse
csky                 randconfig-r2305-20261120    clang-24   sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261120    gcc-10.5.0
hexagon               randconfig-1001-20261120    gcc-10.5.0
hexagon               randconfig-2000-20261119    clang-17
hexagon               randconfig-2000-20261120    gcc-16.2.0
hexagon               randconfig-2001-20261119    clang-24
hexagon               randconfig-2001-20261120    gcc-16.2.0
hexagon               randconfig-2200-20261119    clang-17   smatch
hexagon               randconfig-2200-20261120    clang-17   smatch
hexagon              randconfig-r2111-20261120    gcc-14.4.0 cocci
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261121    gcc-13
i386        buildonly-randconfig-1001-20261121    gcc-13
i386        buildonly-randconfig-1002-20261121    gcc-13
i386        buildonly-randconfig-1003-20261121    gcc-13
i386        buildonly-randconfig-1004-20261121    gcc-13
i386        buildonly-randconfig-1005-20261121    gcc-13
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261120    clang-22
i386                  randconfig-1000-20261121    clang-22
i386                  randconfig-1001-20261120    clang-22
i386                  randconfig-1001-20261121    clang-22
i386                  randconfig-1002-20261120    clang-22
i386                  randconfig-1002-20261121    clang-22
i386                  randconfig-1003-20261120    clang-22
i386                  randconfig-1003-20261121    clang-22
i386                  randconfig-1004-20261120    clang-22
i386                  randconfig-1004-20261121    clang-22
i386                  randconfig-1005-20261120    clang-22
i386                  randconfig-1005-20261121    clang-22
i386                  randconfig-1006-20261120    clang-22
i386                  randconfig-1006-20261121    clang-22
i386                  randconfig-1007-20261120    clang-22
i386                  randconfig-1007-20261121    gcc-14
i386                  randconfig-1008-20261120    clang-22
i386                  randconfig-1008-20261121    gcc-14
i386                  randconfig-1009-20261120    clang-22
i386                  randconfig-1009-20261121    gcc-14
i386                  randconfig-1010-20261120    clang-22
i386                  randconfig-1010-20261121    gcc-14
i386                  randconfig-1011-20261120    clang-22
i386                  randconfig-1011-20261121    gcc-14
i386                  randconfig-1012-20261120    clang-22
i386                  randconfig-1012-20261121    gcc-14
i386                  randconfig-1013-20261120    clang-22
i386                  randconfig-1013-20261121    gcc-14
i386                  randconfig-2000-20261119    gcc-14
i386                  randconfig-2000-20261120    clang-22
i386                  randconfig-2001-20261119    gcc-14
i386                  randconfig-2001-20261120    clang-22
i386                  randconfig-2002-20261119    gcc-14
i386                  randconfig-2002-20261120    clang-22
i386                  randconfig-2003-20261119    clang-22
i386                  randconfig-2003-20261120    clang-22
i386                  randconfig-2004-20261119    gcc-14
i386                  randconfig-2004-20261120    clang-22
i386                  randconfig-2005-20261119    gcc-14
i386                  randconfig-2005-20261120    clang-22
i386                  randconfig-2100-20261119    gcc-14     cocci
i386                  randconfig-2100-20261120    gcc-14     cocci
i386                  randconfig-2101-20261119    gcc-14     cocci
i386                  randconfig-2101-20261120    gcc-14     cocci
i386                  randconfig-2102-20261119    gcc-14     cocci
i386                  randconfig-2102-20261120    gcc-14     cocci
i386                  randconfig-2103-20261119    clang-22   cocci
i386                  randconfig-2103-20261120    gcc-14     cocci
i386                  randconfig-2104-20261119    clang-22   cocci
i386                  randconfig-2104-20261120    gcc-14     cocci
i386                  randconfig-2105-20261119    clang-22   cocci
i386                  randconfig-2105-20261120    gcc-14     cocci
i386                  randconfig-2200-20261119    gcc-14     smatch
i386                  randconfig-2200-20261120    clang-22   smatch
i386                  randconfig-2300-20261119    gcc-13     sparse
i386                  randconfig-2300-20261120    clang-22   sparse
i386                  randconfig-2301-20261119    gcc-14     sparse
i386                  randconfig-2301-20261120    clang-22   sparse
i386                  randconfig-2302-20261119    clang-22   sparse
i386                  randconfig-2302-20261120    clang-22   sparse
i386                 randconfig-r2307-20261120    gcc-14     sparse
i386                 randconfig-r2311-20261120    gcc-15.3.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261120    gcc-10.5.0
loongarch             randconfig-1001-20261120    gcc-10.5.0
loongarch             randconfig-2000-20261119    clang-24
loongarch             randconfig-2000-20261120    clang-24
loongarch             randconfig-2001-20261119    gcc-16.2.0
loongarch             randconfig-2001-20261120    clang-24
loongarch             randconfig-2200-20261119    clang-24   smatch
loongarch             randconfig-2200-20261120    clang-18   smatch
loongarch            randconfig-r2100-20261120    gcc-12.5.0 cocci
loongarch            randconfig-r2101-20261120    gcc-12.5.0 cocci
loongarch            randconfig-r2104-20261120    gcc-16.2.0 cocci
loongarch            randconfig-r2105-20261119    gcc-16.2.0 cocci
loongarch            randconfig-r2107-20261120    gcc-14.4.0 cocci
loongarch            randconfig-r2110-20261119    gcc-16.2.0 cocci
loongarch            randconfig-r2300-20261120    clang-17   sparse
loongarch            randconfig-r2302-20261120    clang-24   sparse
loongarch            randconfig-r2303-20261119    gcc-16.2.0 sparse
loongarch            randconfig-r2303-20261120    clang-24   sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                        bvme6000_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5275evb_defconfig    clang-24
m68k                         mvme147_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261119    gcc-15.3.0
m68k                  randconfig-2000-20261120    gcc-15.3.0
m68k                  randconfig-2001-20261119    gcc-8.5.0
m68k                  randconfig-2001-20261120    gcc-15.3.0
m68k                  randconfig-2200-20261119    gcc-9.5.0  smatch
m68k                  randconfig-2200-20261120    gcc-14.4.0 smatch
m68k                 randconfig-r2106-20261119    gcc-10.5.0 cocci
m68k                 randconfig-r2301-20261120    clang-17   sparse
m68k                 randconfig-r2306-20261120    gcc-14     sparse
m68k                 randconfig-r2310-20261120    gcc-14     sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261119    gcc-14.4.0
microblaze            randconfig-2000-20261120    gcc-15.3.0
microblaze            randconfig-2001-20261119    gcc-12.5.0
microblaze            randconfig-2001-20261120    gcc-15.3.0
microblaze            randconfig-2200-20261119    gcc-12.5.0 smatch
microblaze            randconfig-2200-20261120    gcc-11.5.0 smatch
microblaze           randconfig-r2103-20261119    gcc-8.5.0  cocci
microblaze           randconfig-r2305-20261120    clang-17   sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                          db1xxx_defconfig    clang-24
mips                            ip30_defconfig    clang-24
mips                       loongson1_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261119    gcc-8.5.0
mips                  randconfig-2000-20261120    gcc-9.5.0
mips                  randconfig-2001-20261119    clang-24
mips                  randconfig-2001-20261120    gcc-9.5.0
mips                  randconfig-2002-20261119    clang-21
mips                  randconfig-2002-20261120    gcc-9.5.0
mips                  randconfig-2200-20261119    clang-24   smatch
mips                  randconfig-2200-20261120    clang-24   smatch
mips                 randconfig-r2100-20261120    gcc-16.2.0 cocci
mips                 randconfig-r2106-20261120    gcc-14.4.0 cocci
mips                 randconfig-r2301-20261120    clang-24   sparse
mips                 randconfig-r2310-20261119    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261120    gcc-10.5.0
nios2                 randconfig-1001-20261120    gcc-10.5.0
nios2                 randconfig-2000-20261119    gcc-8.5.0
nios2                 randconfig-2000-20261120    clang-24
nios2                 randconfig-2001-20261119    gcc-11.5.0
nios2                 randconfig-2001-20261120    clang-24
nios2                 randconfig-2200-20261119    gcc-11.5.0 smatch
nios2                 randconfig-2200-20261120    gcc-11.5.0 smatch
nios2                randconfig-r2102-20261119    gcc-11.5.0 cocci
nios2                randconfig-r2103-20261120    gcc-16.2.0 cocci
nios2                randconfig-r2105-20261120    gcc-12.5.0 cocci
nios2                randconfig-r2110-20261120    gcc-16.2.0 cocci
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261119    gcc-16.2.0
openrisc              randconfig-2000-20261120    gcc-9.5.0
openrisc              randconfig-2001-20261119    gcc-16.2.0
openrisc              randconfig-2001-20261120    gcc-9.5.0
openrisc              randconfig-2002-20261119    gcc-16.2.0
openrisc              randconfig-2002-20261120    gcc-9.5.0
openrisc              randconfig-2200-20261119    gcc-16.2.0 smatch
openrisc              randconfig-2200-20261120    gcc-11.5.0 smatch
openrisc             randconfig-r2100-20261119    gcc-16.2.0 cocci
openrisc             randconfig-r2109-20261119    gcc-11.5.0 cocci
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261121    gcc-10.5.0
parisc                randconfig-1001-20261121    gcc-10.5.0
parisc                randconfig-2000-20261119    gcc-16.2.0
parisc                randconfig-2000-20261120    clang-24
parisc                randconfig-2001-20261119    gcc-10.5.0
parisc                randconfig-2001-20261120    clang-24
parisc                randconfig-2200-20261120    gcc-8.5.0  smatch
parisc               randconfig-r2102-20261120    gcc-16.2.0 cocci
parisc               randconfig-r2108-20261119    gcc-15.3.0 cocci
parisc               randconfig-r2111-20261119    gcc-10.5.0 cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       bamboo_defconfig    gcc-16.2.0
powerpc                    bluestone_defconfig    gcc-16.2.0
powerpc                           g5_defconfig    gcc-16.2.0
powerpc                    lite5200b_defconfig    gcc-16.2.0
powerpc                      mpc5200_defconfig    clang-24
powerpc                  mpc834x_itx_defconfig    gcc-16.2.0
powerpc                     mvme5100_defconfig    gcc-16.2.0
powerpc                       pasemi_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261121    gcc-10.5.0
powerpc               randconfig-1001-20261121    gcc-10.5.0
powerpc               randconfig-2000-20261119    clang-19
powerpc               randconfig-2000-20261120    clang-24
powerpc               randconfig-2001-20261119    gcc-8.5.0
powerpc               randconfig-2001-20261120    clang-24
powerpc               randconfig-2002-20261119    clang-24
powerpc               randconfig-2002-20261120    clang-24
powerpc               randconfig-2200-20261119    gcc-13.5.0 smatch
powerpc               randconfig-2200-20261120    clang-17   smatch
powerpc              randconfig-r2304-20261120    clang-17   sparse
powerpc              randconfig-r2307-20261119    clang-24   sparse
powerpc                      skiroot_defconfig    clang-24
powerpc                      tqm8548_defconfig    clang-24
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64                         alldefconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261121    gcc-10.5.0
powerpc64             randconfig-1001-20261121    gcc-10.5.0
powerpc64             randconfig-2000-20261119    gcc-10.5.0
powerpc64             randconfig-2000-20261120    clang-24
powerpc64             randconfig-2001-20261119    gcc-15.3.0
powerpc64             randconfig-2001-20261120    clang-24
powerpc64             randconfig-2002-20261119    gcc-8.5.0
powerpc64             randconfig-2002-20261120    clang-24
powerpc64             randconfig-2200-20261119    clang-24   smatch
powerpc64             randconfig-2200-20261120    gcc-16.2.0 smatch
powerpc64            randconfig-r2109-20261120    gcc-14.4.0 cocci
powerpc64            randconfig-r2306-20261119    gcc-13.5.0 sparse
powerpc64            randconfig-r2309-20261120    gcc-15.3.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261121    clang-17
riscv                 randconfig-1001-20261121    clang-17
riscv                 randconfig-2000-20261120    clang-24
riscv                 randconfig-2001-20261120    clang-24
riscv                 randconfig-2001-20261120    gcc-10.5.0
riscv                 randconfig-2002-20261120    clang-24
riscv                 randconfig-2002-20261120    gcc-8.5.0
riscv                 randconfig-2003-20261120    clang-24
riscv                 randconfig-2004-20261120    clang-20
riscv                 randconfig-2004-20261120    clang-24
riscv                 randconfig-2005-20261120    clang-24
riscv                 randconfig-2005-20261120    gcc-10.5.0
riscv                 randconfig-2200-20261120    gcc-8.5.0  smatch
riscv                randconfig-r2308-20261120    gcc-14     sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261121    clang-17
s390                  randconfig-1001-20261121    clang-17
s390                  randconfig-2000-20261119    gcc-8.5.0
s390                  randconfig-2000-20261120    clang-24
s390                  randconfig-2000-20261120    gcc-8.5.0
s390                  randconfig-2001-20261119    clang-24
s390                  randconfig-2001-20261120    clang-24
s390                  randconfig-2002-20261119    clang-24
s390                  randconfig-2002-20261120    clang-24
s390                  randconfig-2003-20261119    gcc-8.5.0
s390                  randconfig-2003-20261120    clang-24
s390                  randconfig-2004-20261119    clang-22
s390                  randconfig-2004-20261120    clang-24
s390                  randconfig-2004-20261120    gcc-16.2.0
s390                  randconfig-2005-20261119    clang-20
s390                  randconfig-2005-20261120    clang-24
s390                  randconfig-2200-20261119    clang-24   smatch
s390                  randconfig-2200-20261120    clang-17   smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261121    clang-17
sh                    randconfig-1001-20261121    clang-17
sh                    randconfig-2000-20261119    gcc-14.4.0
sh                    randconfig-2000-20261120    gcc-11.5.0
sh                    randconfig-2001-20261119    gcc-16.2.0
sh                    randconfig-2001-20261120    gcc-11.5.0
sh                    randconfig-2002-20261119    gcc-14.4.0
sh                    randconfig-2002-20261120    gcc-11.5.0
sh                    randconfig-2003-20261119    gcc-16.2.0
sh                    randconfig-2003-20261120    gcc-11.5.0
sh                    randconfig-2004-20261119    gcc-14.4.0
sh                    randconfig-2004-20261120    gcc-11.5.0
sh                    randconfig-2005-20261119    gcc-12.5.0
sh                    randconfig-2005-20261120    gcc-11.5.0
sh                    randconfig-2200-20261119    gcc-16.2.0 smatch
sh                    randconfig-2200-20261120    gcc-11.5.0 smatch
sh                   randconfig-r2104-20261119    gcc-14.4.0 cocci
sh                   randconfig-r2111-20261120    gcc-16.2.0 cocci
sh                   randconfig-r2302-20261119    gcc-12.5.0 sparse
sh                   randconfig-r2308-20261120    gcc-15.3.0 sparse
sh                           rsk7201_defconfig    gcc-16.2.0
sh                    secureedge5410_defconfig    gcc-16.2.0
sh                    sh7724_generic_defconfig    gcc-16.2.0
sh                   sh7785lcr_32bit_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261120    clang-24
sparc                 randconfig-1000-20261121    gcc-14
sparc                 randconfig-1001-20261120    clang-24
sparc                 randconfig-1001-20261121    gcc-14
sparc                 randconfig-2000-20261119    gcc-14.4.0
sparc                 randconfig-2000-20261120    gcc-8.5.0
sparc                 randconfig-2001-20261119    gcc-16.2.0
sparc                 randconfig-2001-20261120    gcc-8.5.0
sparc                 randconfig-2200-20261119    gcc-8.5.0  smatch
sparc                 randconfig-2200-20261120    gcc-11.5.0 smatch
sparc                randconfig-r2101-20261119    gcc-16.2.0 cocci
sparc                randconfig-r2110-20261120    gcc-14.4.0 cocci
sparc                randconfig-r2309-20261119    gcc-14.4.0 sparse
sparc64                           alldefconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261120    clang-24
sparc64               randconfig-1000-20261121    gcc-14
sparc64               randconfig-1001-20261120    clang-24
sparc64               randconfig-1001-20261121    gcc-14
sparc64               randconfig-2000-20261119    gcc-8.5.0
sparc64               randconfig-2000-20261120    gcc-8.5.0
sparc64               randconfig-2001-20261119    gcc-9.5.0
sparc64               randconfig-2001-20261120    gcc-8.5.0
sparc64               randconfig-2200-20261119    gcc-13.5.0 smatch
sparc64               randconfig-2200-20261120    gcc-14.4.0 smatch
sparc64              randconfig-r2107-20261119    gcc-8.5.0  cocci
sparc64              randconfig-r2109-20261120    gcc-16.2.0 cocci
sparc64              randconfig-r2300-20261119    gcc-13.5.0 sparse
sparc64              randconfig-r2302-20261120    clang-17   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.2.0
um                    randconfig-1000-20261120    clang-24
um                    randconfig-1000-20261121    gcc-14
um                    randconfig-1001-20261120    clang-24
um                    randconfig-1001-20261121    gcc-14
um                    randconfig-2000-20261119    gcc-13
um                    randconfig-2000-20261120    gcc-8.5.0
um                    randconfig-2001-20261119    clang-21
um                    randconfig-2001-20261120    gcc-8.5.0
um                    randconfig-2200-20261120    clang-24   smatch
um                   randconfig-r2102-20261120    gcc-12.5.0 cocci
um                   randconfig-r2108-20261120    gcc-16.2.0 cocci
um                            x86_64_defconfig    gcc-14
x86_64                            alldefconfig    gcc-16.2.0
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261121    clang-22
x86_64      buildonly-randconfig-1001-20261121    clang-22
x86_64      buildonly-randconfig-1002-20261121    clang-22
x86_64      buildonly-randconfig-1003-20261121    clang-22
x86_64      buildonly-randconfig-1004-20261121    clang-22
x86_64      buildonly-randconfig-1005-20261121    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261121    clang-22
x86_64                randconfig-1001-20261121    clang-22
x86_64                randconfig-1002-20261121    clang-22
x86_64                randconfig-1003-20261121    clang-22
x86_64                randconfig-1004-20261121    clang-22
x86_64                randconfig-1005-20261121    clang-22
x86_64                randconfig-1006-20261121    gcc-14
x86_64                randconfig-1007-20261121    gcc-14
x86_64                randconfig-1008-20261121    gcc-14
x86_64                randconfig-1009-20261121    gcc-14
x86_64                randconfig-1010-20261121    gcc-14
x86_64                randconfig-1011-20261121    gcc-14
x86_64                randconfig-2000-20261119    gcc-14
x86_64                randconfig-2000-20261120    clang-22
x86_64                randconfig-2001-20261119    clang-22
x86_64                randconfig-2001-20261120    clang-22
x86_64                randconfig-2002-20261119    clang-22
x86_64                randconfig-2002-20261120    clang-22
x86_64                randconfig-2003-20261119    gcc-14
x86_64                randconfig-2003-20261120    clang-22
x86_64                randconfig-2004-20261119    gcc-14
x86_64                randconfig-2004-20261120    clang-22
x86_64                randconfig-2005-20261119    clang-22
x86_64                randconfig-2005-20261120    clang-22
x86_64                randconfig-2100-20261119    clang-22   cocci
x86_64                randconfig-2100-20261120    gcc-14     cocci
x86_64                randconfig-2101-20261119    clang-22   cocci
x86_64                randconfig-2101-20261120    gcc-14     cocci
x86_64                randconfig-2102-20261119    clang-22   cocci
x86_64                randconfig-2102-20261120    gcc-14     cocci
x86_64                randconfig-2103-20261119    clang-22   cocci
x86_64                randconfig-2103-20261120    gcc-14     cocci
x86_64                randconfig-2104-20261119    clang-22   cocci
x86_64                randconfig-2104-20261120    gcc-14     cocci
x86_64                randconfig-2105-20261119    clang-22   cocci
x86_64                randconfig-2105-20261120    gcc-14     cocci
x86_64                randconfig-2200-20261119    clang-22   smatch
x86_64                randconfig-2200-20261120    clang-22   smatch
x86_64                randconfig-2300-20261119    clang-22   sparse
x86_64                randconfig-2300-20261120    clang-22   sparse
x86_64                randconfig-2301-20261119    clang-22   sparse
x86_64                randconfig-2301-20261120    clang-22   sparse
x86_64                randconfig-2302-20261119    gcc-14     sparse
x86_64                randconfig-2302-20261120    clang-22   sparse
x86_64               randconfig-r2304-20261119    gcc-14     sparse
x86_64               randconfig-r2304-20261120    clang-24   sparse
x86_64               randconfig-r2311-20261120    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                   cadence_csp_defconfig    gcc-16.2.0
xtensa                        common_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261120    clang-24
xtensa                randconfig-1000-20261121    gcc-14
xtensa                randconfig-1001-20261120    clang-24
xtensa                randconfig-1001-20261121    gcc-14
xtensa                randconfig-2000-20261119    gcc-12.5.0
xtensa                randconfig-2000-20261120    gcc-16.2.0
xtensa                randconfig-2001-20261119    gcc-8.5.0
xtensa                randconfig-2001-20261120    gcc-16.2.0
xtensa                randconfig-2200-20261119    gcc-14.4.0 smatch
xtensa                randconfig-2200-20261120    gcc-9.5.0  smatch
xtensa               randconfig-r2107-20261120    gcc-16.2.0 cocci
xtensa               randconfig-r2306-20261120    gcc-15.3.0 sparse
xtensa                     xip_kc705_defconfig    gcc-16.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

