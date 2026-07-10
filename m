Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F396C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0847E6B0005; Fri, 10 Jul 2026 14:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035326B0088; Fri, 10 Jul 2026 14:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E409E6B008A; Fri, 10 Jul 2026 14:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7E546B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:39:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B426A052D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:34:18 +0000 (UTC)
X-FDA: 84973716996.02.07059DF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id D37A8140008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:34:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ta+Fr0Lf;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783708456;
	b=dyrz3z27JHVYBtueV1mSnwK5jmmDd4GUBekbeXe90gINuWuPMiiKOxYKeIyZvW8c7TGTIC
	i6Uks0ecAXPH42ZrjK+5/nWWuVGuJLAuv950ME+M6Me1qJODAKKJw2PyJIF1zh9B4zebVh
	61einaqVFoUCWPWN09Be6vdLSkkTjMg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ta+Fr0Lf;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783708456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TLvEKIXBLM+5Ujk51K0nkAEsPknBkSdwRaveHakI/HA=;
	b=WNLzbbcooK1hvd8VK20D/c6j5JiqTW9dR59BoJ3GkwjYyYAxyAuylp11LDovmtoBhBWz9W
	osffJlMYL2aFOCyyCQAaa7q+a8Z8X669aG+Af/NQef6qU1uvBeysEeJ6BNXHdFlEf+1B+N
	0CgQnIbaK7gM5M6/zJW2StFuLrdgih4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783708456; x=1815244456;
  h=date:from:to:cc:subject:message-id;
  bh=ZcIjVUKfGR42ZJkIibRURQlrMGo5jsp/NGFaiuKysCM=;
  b=Ta+Fr0Lf6i4F5nA/TqViP3wCxcJKju8y2PeHuCqzcgeyY1M0cpStPe/D
   8TNw4UD1CrbDBJbFETdspif7eeca/mUskwSWXExZtKuYquwJ/djeRCuVH
   KbWz4s4x9+3WGsHTXuD09ve+r8/z8zlxpof+mfZeawjzgW3EYEi/yRyNi
   RTAw3jFcllNpFU9FTl/YTBKO41kkmo1K8mkkdphYwTNh38RXhH8SRjybN
   ubCfv4iMGxSDC+hnbXqdgRYnpnLno3IHKtgVBVc2eEJ3+Zgh7reATkyha
   yxNFKtYA+7z02QfMqv+JgQ2sqPGFMDJhtQF1L5BKtH/aQtU1Yjo/CIK0r
   w==;
X-CSE-ConnectionGUID: LCOZ+k07TICBvms+t4nXZA==
X-CSE-MsgGUID: Bh+Uy+eAQ0um3GD8IEMe/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71932739"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71932739"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 11:34:14 -0700
X-CSE-ConnectionGUID: TPCtsg/PSiqk0+YKAV80cA==
X-CSE-MsgGUID: U5/+YWenT/+AAoriCRNxeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259281299"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 10 Jul 2026 11:34:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wiG37-00000000JG5-3nAE;
	Fri, 10 Jul 2026 18:34:09 +0000
Date: Sat, 11 Jul 2026 02:33:52 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 1e692e85500fd3a971da0241f044f4572b2be8b6
Message-ID: <202607110232.GeLHzsfO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D37A8140008
X-Stat-Signature: 47sbogoggkn4w7ppew57cnzmipo4deyx
X-HE-Tag: 1783708455-816168
X-HE-Meta: U2FsdGVkX1+2iiUStp26+/iZUAB7ddVAy8+3I3CD6SvV8UoxgVje2Xm1VbzyFE6QUbPd6bSZL3REuOl+TzhTUs698ZbXLHJGGSncM5uo5hCJ9oo/5I9mmX14hQlbvi8HP8HZEVT5GT7dFUbHoN7gH0Zeyab7qEHAdPADjXJaFpEdYECG6Nh1T/oy1+3I6pYI7Jc+qIaomW6f2dJtFQlGhdAEfqpaLoN1XO9VhhCEniySSUTgDDk5LMIWpIR2qmukxB0D8rBLeh9HXqLJw4A2SbScC5z0K1wpP1qdr1Ap2uRauu0ZBddAyGLUtC0m53Z6+pGDAMbPpCldz0qgbFVZCUk1S/aCQnhjFHiy74a374IjVo9IbeRyWRdEcMpErAxCY1JYkjtTBkrgq0U05ttdHyAuSsru6HXgrNaKlUEohJH9oAXNP5DeUTNzLZvCCVTjENGPfhuUgD9jw6knIUj/IN2Iu+dJKxWt9ywl5demKLG8HA3nnJDmqWYXjFJA0kpxKW3joV6Oatg2EppaTEGhRsdYbL4LtzWaB3vqhAxIiUSkJe13Is7RRkUh4W6mgZrEI75WxK896XBVZbOUgttGykkTvXZPt4U8nQ9zP8rwsEEihyp69/MHgLBTUt0mGJIAfZFTiGuHvZqqn+1a7Ap04UwPtVzpso9AEqXZNNV/rQugoapDQ0Iqdye+HVXEuQ6d+X0Ad2m9LuQRkDAE+pn3UmJeeXXtj2yWsDhLb5cffHJ/ViShnnGvt4kyaZubW3M5skxrZT3oOCAnQ0k/2W1F/jORVG7jgrg2IJKchT+PWH7jq5cgaylTOyMHDX5zti83X0rNvY05vR52xaoQoTB/+7Tq5I/XzwC/ay5mu8MrQNUmPeE0eEqY8s1OINGc7P74HiHEJR8YRgF6M4UW5nkNTaS+jbU438bcAlrjLUCxjXHdBLBK0faZurhY9PNsn9P5+dr6dGVsFPx2ytWFWt1
 CAWl+CZH
 8MYNgLWUdxBrv3+8oJjYKwjgjcdaI+1ADI0KwRvqx82kHxzyCMJReOrLyrPuJGMM02AADcORmV0H2tHwDCztzcNgIMJkycAHeRUB8jFmgxp/4994vjjKkwOJ770C1AMY7XqVoRLGlCk29YMXtFdyhfnx5FnMHHkUvcQwsYLakmUati09WwoyCvRU8WlqvrdgU+Udg+C5FHAWq1rypnZhc1QP6/p2/ql36QmgL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1e692e85500fd3a971da0241f044f4572b2be8b6  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com

    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
`-- microblaze-randconfig-r071-20260710
    `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

elapsed time: 749m

configs tested: 244
configs skipped: 12

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    clang-23
arc                   randconfig-001-20260710    clang-23
arc                   randconfig-001-20260710    gcc-12.5.0
arc                            randconfig-002    clang-23
arc                   randconfig-002-20260710    clang-23
arc                   randconfig-002-20260710    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                            randconfig-001    clang-23
arm                   randconfig-001-20260710    clang-23
arm                   randconfig-001-20260710    gcc-8.5.0
arm                            randconfig-002    clang-23
arm                   randconfig-002-20260710    clang-23
arm                   randconfig-002-20260710    gcc-16.1.0
arm                            randconfig-003    clang-23
arm                   randconfig-003-20260710    clang-23
arm                            randconfig-004    clang-23
arm                   randconfig-004-20260710    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260710    gcc-10.5.0
arm64                 randconfig-001-20260710    gcc-8.5.0
arm64                 randconfig-002-20260710    gcc-10.5.0
arm64                 randconfig-002-20260710    gcc-8.5.0
arm64                 randconfig-003-20260710    gcc-10.5.0
arm64                 randconfig-003-20260710    gcc-16.1.0
arm64                 randconfig-004-20260710    gcc-10.5.0
arm64                 randconfig-004-20260710    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260710    gcc-10.5.0
csky                  randconfig-002-20260710    gcc-10.5.0
csky                  randconfig-002-20260710    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260710    clang-23
hexagon               randconfig-001-20260710    gcc-12.5.0
hexagon               randconfig-002-20260710    clang-20
hexagon               randconfig-002-20260710    gcc-12.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260710    clang-22
i386        buildonly-randconfig-002-20260710    clang-22
i386        buildonly-randconfig-002-20260710    gcc-14
i386        buildonly-randconfig-003-20260710    clang-22
i386        buildonly-randconfig-003-20260710    gcc-14
i386        buildonly-randconfig-004-20260710    clang-22
i386        buildonly-randconfig-005-20260710    clang-22
i386        buildonly-randconfig-006-20260710    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260710    gcc-14
i386                  randconfig-002-20260710    clang-22
i386                  randconfig-003-20260710    gcc-14
i386                  randconfig-004-20260710    clang-22
i386                  randconfig-005-20260710    gcc-14
i386                  randconfig-006-20260710    clang-22
i386                  randconfig-007-20260710    clang-22
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260710    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260710    clang-22
i386                  randconfig-012-20260710    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260710    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260710    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260710    clang-22
i386                  randconfig-015-20260710    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260710    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260710    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260710    gcc-12.5.0
loongarch             randconfig-002-20260710    clang-18
loongarch             randconfig-002-20260710    gcc-12.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260710    gcc-12.5.0
nios2                 randconfig-001-20260710    gcc-8.5.0
nios2                 randconfig-002-20260710    gcc-12.5.0
nios2                 randconfig-002-20260710    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260710    gcc-9.5.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260710    gcc-11.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       eiger_defconfig    clang-23
powerpc                 mpc836x_rdk_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260710    gcc-14.3.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260710    clang-17
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260710    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260710    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260710    clang-17
riscv                 randconfig-002-20260710    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260710    gcc-9.5.0
s390                  randconfig-002-20260710    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260710    gcc-16.1.0
sh                    randconfig-002-20260710    gcc-12.5.0
sh                   sh7724_generic_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260710    gcc-15.2.0
sparc                 randconfig-002-20260710    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260710    gcc-15.2.0
sparc64               randconfig-002-20260710    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260710    gcc-14
um                    randconfig-002-20260710    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260710    clang-22
x86_64      buildonly-randconfig-001-20260710    gcc-14
x86_64      buildonly-randconfig-002-20260710    clang-22
x86_64      buildonly-randconfig-003-20260710    clang-22
x86_64      buildonly-randconfig-004-20260710    clang-22
x86_64      buildonly-randconfig-005-20260710    clang-22
x86_64      buildonly-randconfig-006-20260710    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260710    clang-22
x86_64                randconfig-002-20260710    gcc-14
x86_64                randconfig-003-20260710    gcc-14
x86_64                randconfig-004-20260710    clang-22
x86_64                randconfig-005-20260710    gcc-14
x86_64                randconfig-006-20260710    clang-22
x86_64                randconfig-011-20260710    clang-22
x86_64                randconfig-011-20260710    gcc-14
x86_64                randconfig-012-20260710    clang-22
x86_64                randconfig-012-20260710    gcc-14
x86_64                randconfig-013-20260710    clang-22
x86_64                randconfig-014-20260710    clang-22
x86_64                randconfig-015-20260710    clang-22
x86_64                randconfig-015-20260710    gcc-14
x86_64                randconfig-016-20260710    clang-22
x86_64                randconfig-071-20260710    clang-22
x86_64                randconfig-071-20260710    gcc-14
x86_64                randconfig-072-20260710    gcc-14
x86_64                randconfig-073-20260710    gcc-14
x86_64                randconfig-074-20260710    clang-22
x86_64                randconfig-074-20260710    gcc-14
x86_64                randconfig-075-20260710    clang-22
x86_64                randconfig-075-20260710    gcc-14
x86_64                randconfig-076-20260710    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-002-20260710    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

