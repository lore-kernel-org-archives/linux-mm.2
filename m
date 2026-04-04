Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE070E88D78
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 03:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40D56B0005; Fri,  3 Apr 2026 23:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1626B0089; Fri,  3 Apr 2026 23:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFC66B008A; Fri,  3 Apr 2026 23:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99AA96B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 23:08:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EA0114039F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:08:09 +0000 (UTC)
X-FDA: 84619389498.07.134E75C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42FF410000B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:08:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dFtWWoR3;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775272087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=EUIOPvz+1bi4BxG513T7dn1UHcs4HyiyP/u/sXRKG0U=;
	b=LsuIsG1Sx0gEFeZQxjC97fnOD8uaKXWSqaTTjoHTq2/5Ots4TIZTEUNwF7UpIS7zxA244d
	7FOcuRJ5oHjCVuQATZvywGEsLa08DTcjp5W9YgF4v/jtopJwmnX4mvofu/WE2PHxs+W19n
	dShzQPgUu3eqYaz1QKv13pnk+GVHm2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775272087; a=rsa-sha256;
	cv=none;
	b=JtEuWnCK6YMJCBsO0bf9dK4yEk3jWA9XDhzEprg0sZzOdJlZ1VZm2EfLgiwoG7LgtQFGgc
	sgZpW8CA+aOKNNhCEgW5lnTppA/3FBWWL7WlYxjoDcV+4n6k1xgzqTX5FWsUxkfarFdgzw
	J9nyB6f0AFkw/pr1CD6MkqkAnwsLYho=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dFtWWoR3;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775272086; x=1806808086;
  h=date:from:to:cc:subject:message-id;
  bh=oY9dm+h5Y0NS7r/8ImnxZO88mvG+6thZzYzRQzlmA0A=;
  b=dFtWWoR3qoTBsyD2Wv53ERRAoHIx+e0bYUSYGX5kSTNQfsVBRj52Q1Ub
   ZC3lW3j4KpMCJWkAjmbbLUjfeP6JV+rXpG7plcONyxaafmXAPk+giUuCO
   1M63K+5AwzODk2wa4VLDeo12k1Tfs/t98eTl2i87tyZUlJjxbNWzsc7lm
   sOAdqsfTx+ZCf83GTZ8wsy6GPj8mi7yiohACsCtl5WoG4OtEsUkZIIJN2
   86YwSIiiHkhrbU4JcLes98c5TQ8Fj1mmuTfOZ9cpSSPyOgdS7zC1D/9te
   I9tSetjwRvRivgTbJp2tfHI5P0spX+fFa8VIf92TSc0+dj7O7MWYZsFLC
   g==;
X-CSE-ConnectionGUID: ZiegTcE9TJSmM0kW87Wajw==
X-CSE-MsgGUID: If3RD7mPR3idihKz4zG21A==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="75499024"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="75499024"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 20:08:05 -0700
X-CSE-ConnectionGUID: wPfH6a88Qt6fZPAThp4MBg==
X-CSE-MsgGUID: X7XQ0DkbTI+J6YWvK3SAjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="257870807"
Received: from lkp-server01.sh.intel.com (HELO 3afb7d003cac) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 03 Apr 2026 20:08:03 -0700
Received: from kbuild by 3afb7d003cac with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8rMe-000000000SH-1SoW;
	Sat, 04 Apr 2026 03:08:00 +0000
Date: Sat, 04 Apr 2026 11:07:25 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 d5759519805c54786c00765ca1303e6d7a0676ca
Message-ID: <202604041117.DyqGQyC2-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Stat-Signature: x5w1zbpe4tme1k9btt65ch7jmnn8ir8w
X-Rspamd-Queue-Id: 42FF410000B
X-Rspam-User: 
X-HE-Tag: 1775272086-628123
X-HE-Meta: U2FsdGVkX19vHS6fl7TP6IosbqmUDFbyGgqPRAa3hf6XzO4ZUtqVpavlkQx3ObWdxcJ4bgZVewHxprAcQkovQkpOiV5E6n7EGoAFZRARm56RuZD/+zTFPTpXKJ0OYD10YsqzKAf2ghEkaiT1qe/QClYOEgS4PBloIlYE9IzsyWWlWqzixho8tqkGkrRNqINhooOJ0QqTE5O/MtRCer1VsDAC+PQujgCQKv6aFWlEQet8dz8k0YeDUvkfhu7X1AvLn8ZPFTHb7ahkeJo6oEI29fcB+oR09uzjhhJH42YTMRJ3x8PgUdH/1f02fxi1pRBPBNsHDrh43fhbc3va3bUWjLLgoRn5zQV0qlFhgA0k8LnkKKzQSj2zdVYshUkkxX0eHWvZEsPxNjSuR2aHyMWdbH8YFYvhvjEA04MMpVlwg/fZlt5OvRnH5ugEWue3SIaVsTNg+rJR/NwUUCi+q0JGlmuu7rD1Ywryj0lXOnGtVhPmo5Hgsnu+zrBATw89naWFNPhkRayWaZWy/NiZowwC9lSQC05uBHu7V/mQsPLIy/c7kPqRbSD1kBcuJmAtSKTcNvXZIKlzMKNfYLxcH2jAHv+tue4vXi89tGabPSH7RfE+aGsLGLDxRh4Ic+w8rN8gUSE3yAudQgNB4GIoGu2pMvCdf5oTTpAHv+Dk8mMtjgFtt/WEs6rqdHKc9WeBB2tMOfYzMWFjYk4E8IBAEieo5xh/frLi+omnL+99CYnosbu7axPSrXhVFiurto/gytaV/M+IxCLStPn/sBzci8146CmsjSygbPoBuvVHlZzFLwN1pYPccMwfLaVJn0f6DmqyN5XkPSjMkQcTIoXugyzd/CF1/7qydq4x5G4yv2pU50mFpL/d8GMK8PzBUzbVWUdwWBImaW0id0VxTnO+ZXe8W0OCkddM4iVMRdXT02vmx6zBbWl/rnpDc8u4VRg/JyYrGTy2pu542CzBdeCVyf5
 p9j9kVUp
 qjV684zlmdemDpEgUg1rsVwtIlTHAAF2Y1VMEzSNxTBx5ujAIGz8W9U1goJ+wA5ZLsQhPW7a/XTidu7hEOWfiNPj1Rh3mG7aiTw8zsvgCwG1WkX0DFy7g2d3uZsTukulYnurUwQS0tJdjHbRf52RoP0ZnUpYmzWaWF5N/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: d5759519805c54786c00765ca1303e6d7a0676ca  x86/alternative: delay freeing of smp_locks section

elapsed time: 739m

configs tested: 193
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260404    gcc-15.2.0
arc                   randconfig-002-20260404    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260404    gcc-15.2.0
arm                   randconfig-002-20260404    gcc-15.2.0
arm                   randconfig-003-20260404    gcc-15.2.0
arm                   randconfig-004-20260404    gcc-15.2.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260404    gcc-15.2.0
arm64                 randconfig-002-20260404    gcc-15.2.0
arm64                 randconfig-003-20260404    gcc-15.2.0
arm64                 randconfig-004-20260404    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260404    gcc-15.2.0
csky                  randconfig-002-20260404    gcc-15.2.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260404    gcc-15.2.0
hexagon               randconfig-002-20260404    gcc-15.2.0
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260404    clang-20
i386        buildonly-randconfig-002-20260404    clang-20
i386        buildonly-randconfig-003-20260404    clang-20
i386        buildonly-randconfig-004-20260404    clang-20
i386        buildonly-randconfig-005-20260404    clang-20
i386        buildonly-randconfig-006-20260404    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260404    clang-20
i386                  randconfig-002-20260404    clang-20
i386                  randconfig-003-20260404    clang-20
i386                  randconfig-004-20260404    clang-20
i386                  randconfig-005-20260404    clang-20
i386                  randconfig-006-20260404    clang-20
i386                  randconfig-007-20260404    clang-20
i386                  randconfig-011-20260404    clang-20
i386                  randconfig-012-20260404    clang-20
i386                  randconfig-013-20260404    clang-20
i386                  randconfig-014-20260404    clang-20
i386                  randconfig-015-20260404    clang-20
i386                  randconfig-016-20260404    clang-20
i386                  randconfig-017-20260404    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260404    gcc-15.2.0
loongarch             randconfig-002-20260404    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                      mmu_defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                        omega2p_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260404    gcc-15.2.0
nios2                 randconfig-002-20260404    gcc-15.2.0
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260404    gcc-10.5.0
parisc                randconfig-002-20260404    gcc-10.5.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                     mpc83xx_defconfig    clang-23
powerpc               randconfig-001-20260404    gcc-10.5.0
powerpc               randconfig-002-20260404    gcc-10.5.0
powerpc64             randconfig-001-20260404    gcc-10.5.0
powerpc64             randconfig-002-20260404    gcc-10.5.0
riscv                            alldefconfig    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260404    clang-20
riscv                 randconfig-002-20260404    clang-20
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260404    clang-20
s390                  randconfig-002-20260404    clang-20
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                        apsh4ad0a_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260404    clang-20
sh                    randconfig-002-20260404    clang-20
sh                           se7751_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260404    clang-20
sparc                 randconfig-001-20260404    gcc-15.2.0
sparc                 randconfig-002-20260404    clang-20
sparc                 randconfig-002-20260404    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260404    clang-20
sparc64               randconfig-001-20260404    gcc-14.3.0
sparc64               randconfig-002-20260404    clang-20
sparc64               randconfig-002-20260404    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260404    clang-20
um                    randconfig-002-20260404    clang-20
um                    randconfig-002-20260404    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260404    gcc-13
x86_64      buildonly-randconfig-002-20260404    gcc-13
x86_64      buildonly-randconfig-003-20260404    gcc-13
x86_64      buildonly-randconfig-004-20260404    gcc-13
x86_64      buildonly-randconfig-005-20260404    gcc-13
x86_64      buildonly-randconfig-006-20260404    gcc-13
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260404    gcc-14
x86_64                randconfig-002-20260404    gcc-14
x86_64                randconfig-003-20260404    gcc-14
x86_64                randconfig-004-20260404    gcc-14
x86_64                randconfig-005-20260404    gcc-14
x86_64                randconfig-006-20260404    gcc-14
x86_64                randconfig-011-20260404    gcc-14
x86_64                randconfig-012-20260404    gcc-14
x86_64                randconfig-013-20260404    gcc-14
x86_64                randconfig-014-20260404    gcc-14
x86_64                randconfig-015-20260404    gcc-14
x86_64                randconfig-016-20260404    gcc-14
x86_64                randconfig-071-20260404    gcc-14
x86_64                randconfig-072-20260404    gcc-14
x86_64                randconfig-073-20260404    gcc-14
x86_64                randconfig-074-20260404    gcc-14
x86_64                randconfig-075-20260404    gcc-14
x86_64                randconfig-076-20260404    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260404    clang-20
xtensa                randconfig-001-20260404    gcc-11.5.0
xtensa                randconfig-002-20260404    clang-20
xtensa                randconfig-002-20260404    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

