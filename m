Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7028CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 11:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74D16B012D; Sun, 31 May 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25706B012E; Sun, 31 May 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962DF6B012F; Sun, 31 May 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8564E6B012D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:55:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1642F1C1BF0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 11:55:34 +0000 (UTC)
X-FDA: 84827560188.03.8C73EAE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7164D20002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WOFSz85s;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780228532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=HFP9EN3To/B4e3dCwQsLSHv1RHrwmcIeODCeonzt30w=;
	b=o7L4JHku3uCt2OG2OOOKz+KJVWiGK9iYVHk35wP49Kw2dsf+PTbrMd2ZnHkm7DLKMTv1cT
	vrVVWf/06E5i0tl1lV9HotzpuXXoKJ8E5sQmdU6PWJja1ps0Dq55Ndvdr3HDfDYHH+7dcb
	zn1X7A7lzktoSEQxUKwkOf1V3ELdtQ0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WOFSz85s;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780228532; a=rsa-sha256;
	cv=none;
	b=OJsmj1qYMg8zsoS2vORqWLDV8JoRf3YczoJj5UaCivWR+szYMrv2NzWvEMGCW38NqF4OUZ
	6gN9c6WMhDqSFxaTmCiaCK32B3Shr3GDBRpiLTd6nXm7yLWstgena7bTo3Fhxx6OftMFPh
	pvgR6bgdJ0n3EVEEuUMhb5lzAiJvJQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780228532; x=1811764532;
  h=date:from:to:cc:subject:message-id;
  bh=6v8dWPnZOhlhn3UyURXaq5cVpG4f8vSgBe18p6fd4zY=;
  b=WOFSz85sv3mi0V3r5Zft3yyWu0iO2Dt/ELpDc8gxORqN82o2CzP1Dk0Y
   rtw/5+m7iE8lw47EqeB2mOUMGt9m/v3c30ThPMnvzIdL8YxtvIb5KINFD
   eHOa9DrNgq2YxLWZFvnXFff/7sdrN9uETQzWVexa/f1N/ePObGkKaEnqp
   Z//9KKY60HyxrzOz7MaaA6xCxtnbjsuQabq4CJR5Ga/hru9YUyYt7fJ+s
   2SOXa2ZXWQnDCkuboHyKZDF34WbPn8wizGmUEGuwLU6RRKDT60I0wHXwJ
   nF49crgjHpjsEdCT85C5E6OZLreeqMlb2c4fhSRRZZJj1znh/nPsMlm2y
   Q==;
X-CSE-ConnectionGUID: jkwPgJiWS0+U/MDomELy+g==
X-CSE-MsgGUID: JH+9UhyGTBCIzWfS2r3+hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="84867929"
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="84867929"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 04:55:30 -0700
X-CSE-ConnectionGUID: s2VLralSSbac7LyGd7y0/g==
X-CSE-MsgGUID: XB90MvAyRF+qaAJGCkF5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="273595575"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 31 May 2026 04:55:28 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wTelJ-000000009Nq-0IQu;
	Sun, 31 May 2026 11:55:25 +0000
Date: Sun, 31 May 2026 19:54:45 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d97bc98dadda29f23540b8490592962ebcf545ff
Message-ID: <202605311938.VM5jlJpi-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 8c197iatem4eekojzfec7audcyiywwmu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7164D20002
X-Rspam-User: 
X-HE-Tag: 1780228531-493990
X-HE-Meta: U2FsdGVkX19y9ho7uGRR1wCmPFB7GWq0oiAd1Khgh6MDbjo4KGNRF4xhcdduEuOlhfWUOfHqLIQMxW8n69jZWwJDTNQlTWSwrIDoWlljB3Sj30mYqAvkT0TOwdW5tvb5J//y6u7YXuvVXUyBt1eYDBV+lpg6NqHz/uRIQqSbBR2wkuL+7U4nuUuSEdF6n8a8/rJ0yfNx747Zy0+Eg6dwa8s5LBNJGKddpyWJPdAacAQDsuKnfholPOu+5WHNdA9L+oSNVSxUfCuIy0Aj23mvxyfkVBlxGu5v8eJGUpb1cEPOu4BgcEdiGR1XvIQIpJoorhUAAAbFlFJKI1ktfu3+SKpoDqWyXUPwNY7tObFFD8aJB1h1OpA/MiMxmywlXgFcoBQrfvSYqEcWI2AilFDd+gOiGtCrhE1fqV+ToRM8G0HcoHKagZp9oR4pzH/kCSNuB8U6Zj8oXXNoo4cvNavEGqgpuPG05cSnv2E3po5a1nJqhdaLs2QGGvnVeBwixqSOwzUXYcUq80fiFCZMyvIbUwbrTW3sQrQNay4l5OnMIrBFiqVRZuM4fkMdZFh+eMUhjFMyCI8oRx/0sviXpqh4QKS7QzWGASzIJnB7NY6Dy817AV31j3g04ZPxKLRd/fTBjt2b46DTLbr5qUclwwjUozOXOyEWYMC7LnDeya/ksk/tII2zYqdjuQPkXrhAHta+q9h8IJilfj9NeIID0SnWvPUNhqqyuOlHNQSULNdWtcMvo616J8G6etsSNYRno+bPjefMZ8Vb0XPiJTSHFAvPBjRhoiYokFgBeOflnEiNYrMpQL/AYcwbpKjq8QbE5BBJ4O8G6VtR+71shWIZEyyNyfDP/Z5+1GcwoeyW0XNs3kOFiJqb2OcurYDI3TSAzKv6BHVmORaZ372XtiMn+mzLsOhHkQH09MQdpO2iW8fr5LzSFDWkcAYXp7MtIhQZ8PocK+SlxTuVUgT1z36zyDl
 xSav4xQY
 KfypVrsYTvZWTgw6X/lXR7/pfO62vjNqajGx4MdTbhiMfEI63KKtwuSL1lR5H4YxSKHmrRviAFeKb/3nGlAAQX7Fixtk9oED+s0BJusRAhnesYrUY9VnhOyUy3ApyO3Pb2US1zxvzZDRxtJMHRuhMVj7plpp2KvVFAA8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: d97bc98dadda29f23540b8490592962ebcf545ff  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 730m

configs tested: 292
configs skipped: 20

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260531    gcc-11.5.0
arc                   randconfig-001-20260531    gcc-8.5.0
arc                   randconfig-002-20260531    gcc-11.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                          collie_defconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260531    clang-20
arm                   randconfig-001-20260531    gcc-11.5.0
arm                   randconfig-002-20260531    clang-23
arm                   randconfig-002-20260531    gcc-11.5.0
arm                   randconfig-003-20260531    gcc-10.5.0
arm                   randconfig-003-20260531    gcc-11.5.0
arm                   randconfig-004-20260531    gcc-11.5.0
arm                   randconfig-004-20260531    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-8.5.0
arm64                 randconfig-001-20260531    clang-23
arm64                 randconfig-001-20260531    gcc-10.5.0
arm64                          randconfig-002    gcc-14.3.0
arm64                 randconfig-002-20260531    clang-23
arm64                 randconfig-002-20260531    gcc-12.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260531    clang-23
arm64                 randconfig-003-20260531    gcc-13.4.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260531    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260531    clang-23
csky                  randconfig-001-20260531    gcc-13.4.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260531    clang-23
csky                  randconfig-002-20260531    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260531    clang-23
hexagon               randconfig-002-20260531    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260531    clang-20
i386        buildonly-randconfig-002-20260531    clang-20
i386        buildonly-randconfig-003-20260531    clang-20
i386        buildonly-randconfig-003-20260531    gcc-14
i386        buildonly-randconfig-004-20260531    clang-20
i386        buildonly-randconfig-005-20260531    clang-20
i386        buildonly-randconfig-005-20260531    gcc-14
i386        buildonly-randconfig-006-20260531    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260531    clang-20
i386                  randconfig-001-20260531    gcc-13
i386                  randconfig-002-20260531    clang-20
i386                  randconfig-002-20260531    gcc-13
i386                  randconfig-003-20260531    clang-20
i386                  randconfig-003-20260531    gcc-13
i386                  randconfig-004-20260531    gcc-13
i386                  randconfig-005-20260531    clang-20
i386                  randconfig-005-20260531    gcc-13
i386                  randconfig-006-20260531    gcc-13
i386                  randconfig-006-20260531    gcc-14
i386                  randconfig-007-20260531    clang-20
i386                  randconfig-007-20260531    gcc-13
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260531    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260531    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260531    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260531    clang-20
i386                  randconfig-014-20260531    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260531    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260531    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260531    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260531    clang-23
loongarch             randconfig-001-20260531    gcc-15.2.0
loongarch             randconfig-002-20260531    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                       alldefconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           jazz_defconfig    clang-17
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.2.0
nios2                 randconfig-001-20260531    clang-23
nios2                 randconfig-001-20260531    gcc-11.5.0
nios2                 randconfig-002-20260531    clang-23
nios2                 randconfig-002-20260531    gcc-11.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                    or1ksim_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260531    clang-23
parisc                randconfig-001-20260531    gcc-8.5.0
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260531    clang-23
parisc                randconfig-002-20260531    gcc-12.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260531    clang-17
powerpc               randconfig-001-20260531    clang-23
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260531    clang-23
powerpc                     redwood_defconfig    clang-23
powerpc                     tqm8548_defconfig    clang-23
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260531    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260531    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_k210_defconfig    clang-23
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260531    clang-23
riscv                 randconfig-001-20260531    gcc-8.5.0
riscv                          randconfig-002    gcc-8.5.0
riscv                 randconfig-002-20260531    clang-18
riscv                 randconfig-002-20260531    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-8.5.0
s390                  randconfig-001-20260531    gcc-8.5.0
s390                           randconfig-002    gcc-8.5.0
s390                  randconfig-002-20260531    clang-23
s390                  randconfig-002-20260531    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          r7785rp_defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-8.5.0
sh                    randconfig-001-20260531    gcc-15.2.0
sh                    randconfig-001-20260531    gcc-8.5.0
sh                             randconfig-002    gcc-8.5.0
sh                    randconfig-002-20260531    gcc-14.3.0
sh                    randconfig-002-20260531    gcc-8.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260531    gcc-15.2.0
sparc                 randconfig-001-20260531    gcc-8.5.0
sparc                 randconfig-002-20260531    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260531    gcc-8.5.0
sparc64               randconfig-002-20260531    gcc-10.5.0
sparc64               randconfig-002-20260531    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260531    clang-19
um                    randconfig-001-20260531    gcc-8.5.0
um                    randconfig-002-20260531    gcc-14
um                    randconfig-002-20260531    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260531    clang-20
x86_64      buildonly-randconfig-001-20260531    gcc-13
x86_64      buildonly-randconfig-002-20260531    clang-20
x86_64      buildonly-randconfig-003-20260531    clang-20
x86_64      buildonly-randconfig-004-20260531    clang-20
x86_64      buildonly-randconfig-005-20260531    clang-20
x86_64      buildonly-randconfig-006-20260531    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260531    clang-20
x86_64                randconfig-001-20260531    gcc-14
x86_64                randconfig-002-20260531    gcc-14
x86_64                randconfig-003-20260531    gcc-14
x86_64                randconfig-004-20260531    gcc-14
x86_64                randconfig-005-20260531    clang-20
x86_64                randconfig-005-20260531    gcc-14
x86_64                randconfig-006-20260531    gcc-14
x86_64                randconfig-011-20260531    clang-20
x86_64                randconfig-011-20260531    gcc-14
x86_64                randconfig-012-20260531    clang-20
x86_64                randconfig-012-20260531    gcc-14
x86_64                randconfig-013-20260531    gcc-14
x86_64                randconfig-014-20260531    clang-20
x86_64                randconfig-014-20260531    gcc-14
x86_64                randconfig-015-20260531    clang-20
x86_64                randconfig-015-20260531    gcc-14
x86_64                randconfig-016-20260531    clang-20
x86_64                randconfig-016-20260531    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260531    clang-20
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260531    clang-20
x86_64                randconfig-072-20260531    gcc-14
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260531    clang-20
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260531    clang-20
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260531    clang-20
x86_64                randconfig-075-20260531    gcc-14
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260531    clang-20
x86_64                randconfig-076-20260531    gcc-13
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
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260531    gcc-8.5.0
xtensa                randconfig-002-20260531    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

