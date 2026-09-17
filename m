Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EA7C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603B06B0098; Thu, 17 Sep 2026 06:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3806B0099; Thu, 17 Sep 2026 06:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA7C6B009B; Thu, 17 Sep 2026 06:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDD16B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:01:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF20E1C1ED8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:01:03 +0000 (UTC)
X-FDA: 85222810806.29.B54115A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11B7240006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:01:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLQHSBzm;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=X1PhMh4T4cauNRbyqkwiV3qtUXhLmVXSlR3mTFIfNcs=;
	b=eA39Wo7ixSjHeEKxYorqf+5lJa6WQdm3VP75Dptun/Gz3l2KFrzFyn8XD/4TIBmIBLPvD/
	CWBT2gpJZd2ekEp5CJFvo9wFShwUsjFfMELSXHQqCRleN6OA0c2IPo4IeXwH5z7Tn5NUXF
	UeO+m6cQsMUX6xCMR1OzlTwDUELGR5A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLQHSBzm;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639261;
	b=Yidc+o8Q7ZE9aaLjIngEjJx4Q4RsQBpYC4sVSRVGj8W9sUaKU5o/rf6Nzm1/TGhor0qZ9t
	agUC5v6zd/Oi0TXNws66LrL3mPO3TJAwR1+dJ0NRnnP/yxncknP2xSoCilhcv+EZ0nMgf5
	HK4Jndpy1y0SbffBbFT9ihpckzSsTQg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789639261; x=1821175261;
  h=date:from:to:cc:subject:message-id;
  bh=G86fEbZZ8M9TDNk+OBuP7P6MWjysS3e6TLD6IPKJWQs=;
  b=mLQHSBzmt5A1es8C54oBkg1Mf2HmDqTM2hnsbw+BwI+SiShtz8kTqpt0
   YGLU6bJCoxV03lGQPHDYk/8oIHpYy+LohdUde04MUT0HtEJfEQSaZg4VS
   OHJ4Z9Ge37jqvXTpGNTgfzg17OcOjV0JtGqclUbAq5lOHGjPBOi1DItVN
   /bCPFyNLknSd78AoCtMuyj/0DWZDC8yw/1nNoIwdtHV8yPGgmduN5Bz9N
   1pUtjVQ4pgp1FQJn0JNwuATqCjnTA1ulbEPauDMl/8h5dZO30tdhOgYub
   DwkjHlREPrw6BU2Q/05ieAAq4ykRM87wS2dfix/66B1/HKO36tJDtgr8X
   A==;
X-CSE-ConnectionGUID: USgy2lLoSr26htYc0i9rwA==
X-CSE-MsgGUID: YGFQWDl4RLmOxA6UrqF/EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93872000"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93872000"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 03:01:00 -0700
X-CSE-ConnectionGUID: VyIWqTzPT62dF+DjZodYpw==
X-CSE-MsgGUID: Sfn3PMQxSEKvWxd+1ff2iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="275642088"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 17 Sep 2026 03:00:58 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x78vH-000000007Y9-32kR;
	Thu, 17 Sep 2026 10:00:55 +0000
Date: Thu, 17 Sep 2026 18:00:02 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
Message-ID: <202609171758.049ApqPm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: nnm3f51xsr6aj3gsfg7oitit7uyk4gis
X-Rspamd-Queue-Id: 11B7240006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789639260-339402
X-HE-Meta: U2FsdGVkX18K79Y6u7wYwRafeeuSgaeQNimrzVTUjgLdFcHv1hqzaAwo6uSyA89g2G+iYbCN5CCNfcRoGv0Y+FEdubH5HnNaHP50Rlqv1jZor2lkwpPYoIQCXVPZD89W4UiBA57U+9g7GCwCqrRTDpNWzB50sd2mkuv1hBz7yg11noWzfSmqtFun2wd+cJWqQteaAiejRb9XvYMCv+aMkgJjmACxIPfArRMv+CQNcPaOBr44+3wn28HItLT8Zbs0XeVzTglLkYVTIQ0Jv8YAHx7XojZwauwuNCdjtPYICCu+SXI2EtQ+8+uYhB19FMG6R7oFMbvEM41qKbkgSgIvqYXm9mxqIas5A72Ha3hGQwZnCybztuVmAzGxT4PFhM3cq+8T3ZZ0dnHNpzuuA7mkjXEmpvMMxTGxYmMdMH+OTBWHVhNPgDpwRLvGAhiaIHEPwazee7wX65DwcdtF8FmhB2OrBXrLrEN06ixAfUwAymSQNPyo2q0ugCZ4F1J8CoesRs7WxT+QtKtKtdvuzjzP5m/rSur4/iz7VW0m/BGz4HvV0uU7ldiv2bLXlyxJJWWCixNWj3QQeSWfZSZuDL13UIIltJoPQqtHzSAXfCeuOOMHsRp2hUcOCUwZmoacKlrwG2YEEI+oiZXh3u4EVGSDa6QtMbc+1Du9IX3y7X/tDwYgSQsaTbCBS4l1SkAfCk1rSA3XgTQk+4TlOJYjJTvkoS1f//VHgtPie+kE5JbL9nJrl/cVd+ns8H1rohIpgBdlbQ2UCbUWrf41U4hkLKGsECq5rBLU+xs1ShzT4hqqL/zBAAmpeYgrCsHTrcjFY0poecNQkp8KvHQTaupt/mzGSGIqBW2bF3aEGd3bD3SmAQEP1dcEhs1vD5GPsdd2EK870mE09D+ZAGedKL+87akycKq+BmBGSrZfI1/q5ylE85Vdyo4CcTuxJjIRZ5O4E/Go+i8ktkNnkuWJc8y8eDS
 0J+F3XdO
 XMkJLFUgTBvHiVLpZ1GW64XbSEmTNoWp8ST7MNfsNFRsjz1mxCLUCJWa9kO/u53fCP8d/5IwaEzTQbt08dzYfL81mmfqkveseWnpvQ9EKcKT4J5fqrAt7EdJb+YxMBNke99DoVwVJ00F5jWil0dE4i/We5HmJ+VRnqcs6YM9s8c7X17nXjKSZ1S/DFaaTNDNQMr6td35Rt4Mny3n38FkMA9yZtGv4HPxKIJ66
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com

    fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-1014-20260917
    |-- fs-proc-task_mmu.c:error:call-to-undeclared-function-drop_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations
    `-- fs-proc-task_mmu.c:error:call-to-undeclared-function-reacquire_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations

elapsed time: m

configs tested: 238
configs skipped: 7

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260917    gcc-8.5.0
arc                   randconfig-1001-20260917    gcc-15.2.0
arc                  randconfig-r1300-20260917    gcc-12.5.0 sparse
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g5_defconfig    gcc-16.1.0
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                       integrator_defconfig    clang-24
arm                              pxa_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260917    gcc-8.5.0
arm                   randconfig-1001-20260917    gcc-8.5.0
arm                   randconfig-1002-20260917    clang-17
arm                   randconfig-1003-20260917    gcc-8.5.0
arm                          s5pv210_defconfig    clang-24
arm                            tegra_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260917    gcc-8.5.0
arm64                 randconfig-1001-20260917    gcc-8.5.0
arm64                 randconfig-1002-20260917    clang-24
arm64                 randconfig-1003-20260917    clang-17
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260917    gcc-9.5.0
csky                  randconfig-1001-20260917    gcc-11.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260917    clang-20
hexagon               randconfig-1001-20260917    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260917    clang-22
i386        buildonly-randconfig-1000-20260917    gcc-13
i386        buildonly-randconfig-1001-20260917    gcc-13
i386        buildonly-randconfig-1002-20260917    gcc-13
i386        buildonly-randconfig-1002-20260917    gcc-14
i386        buildonly-randconfig-1003-20260917    clang-22
i386        buildonly-randconfig-1003-20260917    gcc-13
i386        buildonly-randconfig-1004-20260917    clang-22
i386        buildonly-randconfig-1004-20260917    gcc-13
i386        buildonly-randconfig-1005-20260917    clang-22
i386        buildonly-randconfig-1005-20260917    gcc-13
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260917    clang-22
i386                  randconfig-1001-20260917    clang-22
i386                  randconfig-1002-20260917    clang-22
i386                  randconfig-1003-20260917    clang-22
i386                  randconfig-1003-20260917    gcc-14
i386                  randconfig-1004-20260917    clang-22
i386                  randconfig-1005-20260917    clang-22
i386                  randconfig-1006-20260917    clang-22
i386                  randconfig-1007-20260917    clang-22
i386                  randconfig-1007-20260917    gcc-13
i386                  randconfig-1008-20260917    clang-22
i386                  randconfig-1009-20260917    clang-22
i386                  randconfig-1010-20260917    clang-22
i386                  randconfig-1011-20260917    clang-22
i386                  randconfig-1011-20260917    gcc-14
i386                  randconfig-1012-20260917    clang-22
i386                  randconfig-1012-20260917    gcc-12
i386                  randconfig-1013-20260917    clang-22
i386                  randconfig-1300-20260917    gcc-14     sparse
i386                  randconfig-1301-20260917    gcc-14     sparse
i386                  randconfig-1302-20260917    gcc-12     sparse
i386                  randconfig-1302-20260917    gcc-14     sparse
i386                 randconfig-r1305-20260917    clang-22   sparse
i386                 randconfig-r1306-20260917    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260917    clang-24
loongarch             randconfig-1001-20260917    clang-24
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       bmips_stb_defconfig    clang-17
mips                            gcw0_defconfig    clang-24
mips                         omega2p_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260917    gcc-11.5.0
nios2                 randconfig-1001-20260917    gcc-11.5.0
nios2                randconfig-r1307-20260917    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260917    gcc-11.5.0
parisc                randconfig-1001-20260917    gcc-9.5.0
parisc               randconfig-r1309-20260917    gcc-16.1.0 sparse
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                        ebony_defconfig    clang-24
powerpc                           g5_defconfig    clang-24
powerpc               randconfig-1000-20260917    clang-24
powerpc               randconfig-1001-20260917    clang-24
powerpc              randconfig-r1308-20260917    clang-24   sparse
powerpc64             randconfig-1000-20260917    clang-24
powerpc64             randconfig-1001-20260917    clang-22
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv              nommu_k210_sdcard_defconfig    clang-24
riscv                 randconfig-1000-20260917    gcc-16.1.0
riscv                 randconfig-1001-20260917    clang-17
riscv                randconfig-r1303-20260917    gcc-14.3.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260917    clang-17
s390                  randconfig-1001-20260917    clang-20
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260917    gcc-16.1.0
sh                    randconfig-1001-20260917    gcc-11.5.0
sh                   randconfig-r1302-20260917    gcc-11.5.0 sparse
sh                            se7750_defconfig    clang-24
sh                   sh7785lcr_32bit_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260917    clang-17
sparc                 randconfig-1000-20260917    gcc-8.5.0
sparc                 randconfig-1001-20260917    clang-17
sparc                 randconfig-1001-20260917    gcc-15.2.0
sparc                randconfig-r1301-20260917    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260917    clang-17
sparc64               randconfig-1000-20260917    clang-24
sparc64               randconfig-1001-20260917    clang-17
sparc64               randconfig-1001-20260917    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260917    clang-17
um                    randconfig-1000-20260917    gcc-14
um                    randconfig-1001-20260917    clang-17
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260917    gcc-13
x86_64      buildonly-randconfig-1000-20260917    gcc-14
x86_64      buildonly-randconfig-1001-20260917    gcc-14
x86_64      buildonly-randconfig-1002-20260917    gcc-14
x86_64      buildonly-randconfig-1003-20260917    gcc-14
x86_64      buildonly-randconfig-1004-20260917    gcc-14
x86_64      buildonly-randconfig-1005-20260917    clang-22
x86_64      buildonly-randconfig-1005-20260917    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260917    clang-22
x86_64                randconfig-1000-20260917    gcc-14
x86_64                randconfig-1001-20260917    clang-22
x86_64                randconfig-1002-20260917    clang-22
x86_64                randconfig-1002-20260917    gcc-14
x86_64                randconfig-1003-20260917    clang-22
x86_64                randconfig-1004-20260917    clang-22
x86_64                randconfig-1004-20260917    gcc-14
x86_64                randconfig-1005-20260917    clang-22
x86_64                randconfig-1005-20260917    gcc-14
x86_64                randconfig-1006-20260917    gcc-14
x86_64                randconfig-1007-20260917    gcc-14
x86_64                randconfig-1008-20260917    gcc-14
x86_64                randconfig-1009-20260917    clang-22
x86_64                randconfig-1010-20260917    clang-22
x86_64                randconfig-1011-20260917    gcc-14
x86_64                randconfig-1012-20260917    clang-22
x86_64                randconfig-1012-20260917    gcc-14
x86_64                randconfig-1013-20260917    clang-22
x86_64                randconfig-1013-20260917    gcc-14
x86_64                randconfig-1014-20260917    clang-22
x86_64                randconfig-1015-20260917    clang-22
x86_64                randconfig-1016-20260917    clang-22
x86_64                randconfig-1017-20260917    clang-22
x86_64                randconfig-1300-20260917    clang-22   sparse
x86_64                randconfig-1300-20260917    gcc-14     sparse
x86_64                randconfig-1301-20260917    gcc-14     sparse
x86_64                randconfig-1302-20260917    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260917    clang-17
xtensa                randconfig-1000-20260917    gcc-8.5.0
xtensa                randconfig-1001-20260917    clang-17
xtensa                randconfig-1001-20260917    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

