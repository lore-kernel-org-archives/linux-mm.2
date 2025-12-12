Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8D1D49238
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 15:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC306B0005; Fri, 12 Dec 2025 10:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D776B0007; Fri, 12 Dec 2025 10:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82D26B0008; Fri, 12 Dec 2025 10:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A70A86B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:37:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A2CEB700A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:37:09 +0000 (UTC)
X-FDA: 84211222578.10.FEAFEDC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 645FC12000C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:37:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jLORUkzr;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765553827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ju5zkerIglWaPpGjmbYVJw+6Z09quc8dS5LrfCYHuYA=;
	b=mnanPaXGKki2TF1ofyTgJB8SHBjlSGbuabpnMaJj+16c7dyRkWqwLOyKRm93xXEZKgEByR
	pnZv8rLEF5D9noUW1IUjJ22doMI5xudHJGXKYdxW6r5FHwlGyj2vIoMdy2vTN1jCZCUIZb
	ZX6cVFynUnSfhyPv4/OGHGSef5lDzY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765553827; a=rsa-sha256;
	cv=none;
	b=dkyGYRfbk5PYyW0N9QsZCPgBNjfxJf68uKeQCYaDrMyoKZgzQ+Jx5kFSJZ52WatCdtwsSF
	scfAuNJOYgbNCf05IIl6CAgXJpiZLbpDYD0oKo3Pl+tkEcujZJ6ewArkYfmzw6QSWGHLi+
	+EoXOmcVNYNzrfwxp6p676FAkpysIDs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jLORUkzr;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765553826; x=1797089826;
  h=date:from:to:cc:subject:message-id;
  bh=8Ym/uJK9GHPGhaSTYjVk6z72iuvot93YHum5uO/n7pc=;
  b=jLORUkzrPDXUea5smQJX09dh8B3TQv0g8DDyMKRZRTW12StRm6mirJMN
   3Ee1KPGS80YkptvVgx39RN8jF54/1DYLCmI9d7t6JcH9WwXGfbuu4o8l2
   JytMJC3FKvvxmyMVuFXbNa0ESZDlz0cBDAWEDfbomR/86QRK2jgWrQhCp
   i+21XOXR5PvVW3TXPnu0nbdUiIezzN3JLX91ihE8gQxlk+aGaaHuJ5+uM
   6+1FGpK8sNQRSeEvwSr2AnbKSVXvkkkRwspdFHq/qI8Du8XuTV1pU9+fI
   oFR8Vu4Eeo5B0Zg8VBGR43AFXu6mc9Pz9CBYYVvuV+1x0s+n9yx4+ApkE
   g==;
X-CSE-ConnectionGUID: 81Xr/UFqRUSvhcI+du+7FA==
X-CSE-MsgGUID: pAgdQBbxRYaIMWAmHjDwUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="78927343"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="78927343"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 07:37:05 -0800
X-CSE-ConnectionGUID: FUgz1a/3QZGTGrNtNclOsg==
X-CSE-MsgGUID: 0UiSY9GVTwuOM0t2d4G9RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197935755"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Dec 2025 07:37:03 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vU5CX-000000006Er-2BEM;
	Fri, 12 Dec 2025 15:37:01 +0000
Date: Fri, 12 Dec 2025 23:36:50 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d9771d0dbe18dd643760431870a6abf9b0866bb0
Message-ID: <202512122343.23JgvvLD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: t7jpsxo57jdzb3t8u741tmjp7gfbhccf
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 645FC12000C
X-Rspam-User: 
X-HE-Tag: 1765553826-433012
X-HE-Meta: U2FsdGVkX185RQ2Q43NYubF9pQotccBLRAuNy/8wqWd3ODNV72Y+XcdaTV/msJbqcvkoZYP5pYDxx+WcY0o+2GD+HPU31helz+h0ZexGJJQpNrRTJsXQarqbEBNgRDftNEYK3FUsTVBIVIxJ0oN5lmiqNoV2gIMqcmO1H7nrZDV7X2MNiGc7ErAAqcBVjN/55BGdEnset6vRVwlrc5Pb5Jt17/shbFX/R03y55CYX7EoWfHiVg9H1StIKvApiGfnj2m1nZFjt/kbL8whDvTkWwqaFBU/arJsqsMZCmdzxLK/ra0M1PbsAE5V0XCYa4XMIp3ARRT/C6DccgTLtGrAquUoBbmLbHogmug1VHkb8dXFu+wNJFf+arcjn1Iahl80Ip2C6w9AOHFXb1CLXpI4m1uWv38I7nhq4b6vFetzVrUe26on4i8ADSGEU8eBrE0bbXhw8qs+YUFDDUvk8meB05K+PqAfzsGbEhRo3BT53nsZ/flBaI27lJ5+Bd7i4a4IGTOtPsQ1KIpPxLfeEwTB3/OQj/0dbq2VK1fdNB0lO+Bj8f459jyPh2/NhujUCAe8hf4ONBUsvHyF6xn+Pq7dKa3JsF4lobGnTky9admTqpDsRmNEetRx2jFq1IKzLwm7+4cqNev9qy40kmwPQux2aIiTdMwXafTJ8JLLj0zCWemhdA1Q8Nrci19PLqyiA3lFZzpjvL0xjdONyfDASvESAo+X9WPPezp3bFB0wVy2B5cw0x45ZGTBYbGWxKfVKWRVeY4hOdBZS2SrCXvLwn0RTpYAfEhZonyqdPLS3N6FfGZDrbAXfh4ktT4vzjdmUo304wUCRxPuINtRzeWGyTgAJoxQ/PJE45Q1ZKz88YGv9MUO4BoXW6HmyyL56ah8VYgFnQm5HA69C85fT9k2M6cDRhvBPQ0oYmMVD5QP7ocBlf2TX2hBzMtdkD8X/S3qZ+GnWg2ILrqafVc5k24LbDD
 JvQXmcvE
 rrvR5z19SdOOacLqJ7b9z9nc+c7HN8GK4hDXnL19Jf1hEmYfUFtzbYx4C0rEaI+0r9fMRAgEU/s2XN9ztrc8vPrM1kfK+nHL/V2AWX6ZwympafC2MoJDfyjk9RgGWo4NeMon2x5rRBXcGmOi01naF7X/nwTYkXwh7Gr4I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d9771d0dbe18dd643760431870a6abf9b0866bb0  Add linux-next specific files for 20251212

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.exception.text+0x247): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: make_task_dead
    drivers/pinctrl/mediatek/pinctrl-mt6878.c:1478:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
`-- xtensa-randconfig-r121-20251205
    |-- (.exception.text):dangerous-relocation:windowed-longcall-crosses-1GB-boundary-return-may-fail:make_task_dead
    `-- drivers-pinctrl-mediatek-pinctrl-mt6878.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 793m

configs tested: 217
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                         haps_hs_defconfig    gcc-15.1.0
arc                            hsdk_defconfig    gcc-15.1.0
arc                   randconfig-001-20251212    clang-22
arc                   randconfig-001-20251212    gcc-8.5.0
arc                   randconfig-002-20251212    clang-22
arc                   randconfig-002-20251212    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20251212    clang-22
arm                   randconfig-002-20251212    clang-22
arm                   randconfig-003-20251212    clang-22
arm                   randconfig-003-20251212    gcc-8.5.0
arm                   randconfig-004-20251212    clang-22
arm                   randconfig-004-20251212    gcc-15.1.0
arm                             rpc_defconfig    clang-18
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251212    clang-18
arm64                 randconfig-001-20251212    clang-22
arm64                 randconfig-002-20251212    clang-19
arm64                 randconfig-002-20251212    clang-22
arm64                 randconfig-003-20251212    clang-22
arm64                 randconfig-004-20251212    clang-22
arm64                 randconfig-004-20251212    gcc-8.5.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251212    clang-22
csky                  randconfig-001-20251212    gcc-14.3.0
csky                  randconfig-002-20251212    clang-22
csky                  randconfig-002-20251212    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251212    clang-22
hexagon               randconfig-002-20251212    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251212    gcc-12
i386        buildonly-randconfig-002-20251212    gcc-12
i386        buildonly-randconfig-003-20251212    gcc-14
i386        buildonly-randconfig-004-20251212    gcc-14
i386        buildonly-randconfig-005-20251212    gcc-14
i386        buildonly-randconfig-006-20251212    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251212    clang-20
i386                  randconfig-002-20251212    gcc-14
i386                  randconfig-003-20251212    clang-20
i386                  randconfig-004-20251212    gcc-14
i386                  randconfig-005-20251212    gcc-14
i386                  randconfig-006-20251212    gcc-14
i386                  randconfig-007-20251212    gcc-14
i386                  randconfig-011-20251212    gcc-14
i386                  randconfig-012-20251212    gcc-14
i386                  randconfig-013-20251212    gcc-14
i386                  randconfig-014-20251212    gcc-14
i386                  randconfig-015-20251212    clang-20
i386                  randconfig-015-20251212    gcc-14
i386                  randconfig-016-20251212    gcc-14
i386                  randconfig-017-20251212    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251212    clang-22
loongarch             randconfig-002-20251212    clang-18
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                          rb532_defconfig    clang-18
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251212    gcc-11.5.0
nios2                 randconfig-002-20251212    gcc-8.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251212    gcc-10.5.0
parisc                randconfig-002-20251212    gcc-12.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                    amigaone_defconfig    gcc-15.1.0
powerpc                      ppc64e_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251212    clang-22
powerpc               randconfig-002-20251212    gcc-12.5.0
powerpc64             randconfig-001-20251212    gcc-11.5.0
powerpc64             randconfig-002-20251212    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251212    clang-22
riscv                 randconfig-002-20251212    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251212    clang-22
s390                  randconfig-002-20251212    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251212    gcc-14.3.0
sh                    randconfig-002-20251212    gcc-10.5.0
sh                          sdk7786_defconfig    gcc-15.1.0
sh                        sh7757lcr_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251212    gcc-8.5.0
sparc                 randconfig-002-20251212    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251212    gcc-8.5.0
sparc64               randconfig-002-20251212    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251212    clang-22
um                    randconfig-002-20251212    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251212    clang-20
x86_64      buildonly-randconfig-002-20251212    clang-20
x86_64      buildonly-randconfig-003-20251212    clang-20
x86_64      buildonly-randconfig-004-20251212    clang-20
x86_64      buildonly-randconfig-005-20251212    gcc-14
x86_64      buildonly-randconfig-006-20251212    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251212    gcc-14
x86_64                randconfig-002-20251212    clang-20
x86_64                randconfig-003-20251212    clang-20
x86_64                randconfig-004-20251212    clang-20
x86_64                randconfig-005-20251212    clang-20
x86_64                randconfig-006-20251212    clang-20
x86_64                randconfig-011-20251212    clang-20
x86_64                randconfig-012-20251212    gcc-14
x86_64                randconfig-013-20251212    gcc-14
x86_64                randconfig-014-20251212    clang-20
x86_64                randconfig-015-20251212    gcc-14
x86_64                randconfig-016-20251212    clang-20
x86_64                randconfig-071-20251212    clang-20
x86_64                randconfig-071-20251212    gcc-12
x86_64                randconfig-072-20251212    clang-20
x86_64                randconfig-072-20251212    gcc-14
x86_64                randconfig-073-20251212    clang-20
x86_64                randconfig-074-20251212    clang-20
x86_64                randconfig-074-20251212    gcc-14
x86_64                randconfig-075-20251212    clang-20
x86_64                randconfig-076-20251212    clang-20
x86_64                randconfig-076-20251212    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251212    gcc-8.5.0
xtensa                randconfig-002-20251212    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

