Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA32FD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB3F6B03BA; Tue, 20 Jan 2026 05:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0E56B03BC; Tue, 20 Jan 2026 05:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5906B03BD; Tue, 20 Jan 2026 05:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDD1A6B03BA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:41:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67A7E5634D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:41:02 +0000 (UTC)
X-FDA: 84351999564.02.C150C16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf21.hostedemail.com (Postfix) with ESMTP id B13B81C000E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:40:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=blAkEpps;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=JgysB2GvQRWpp4cbprJuuD5dDEPDb0Qnca138RvZWLY=;
	b=Via3QiI3awqbEvymulsbTPqSHe2A6H5fs3+9hINt7GZoQxqPin2RmuioLE/jg0E3pugn8J
	OYrpzrFmW7HU1vttVjvfR04CszzX3NEBpYxpgTduzj/aoLjE4x9sQR2WyjzXtIMAr204q6
	Dwq/m9ytY74hjl1zAp6ppset6xn65TQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=blAkEpps;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768905659; a=rsa-sha256;
	cv=none;
	b=PJRYyf4ORjg+K71l46NkMMRQWYqPtEXLTPRFkx0c7g0Wi7xZDhdTmFjp5C1D/q8e5XRBOh
	5CI2b0wEJZy3yqbkvGR8L8ClR9uxxGsh4nMQtThH17OpykZHmwxTCn86YcZGjNxEU1XNw8
	FjzYum+0be4gp7IAbNd+sbAXb5GI1tE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768905659; x=1800441659;
  h=date:from:to:cc:subject:message-id;
  bh=LZs6s9KnqBj9+DImqn0ov5oyugjo8bRjY4/fDBJBPW4=;
  b=blAkEpps6LmNmLfM5Rs9Ss0JHAVOPbU7QyXczxA2elQ/gJaC23faZY7a
   BWFCzO2zgIkQfFbETbNyDXBaDGI+y17CesUNUHMV2MN+ugdNerxPF0YfR
   nM/jdOMQ8enQ+P3oDz67W+++Qp7bEQdJk8egOwlIVwtC0gYfnalMJ+zdo
   hKuCcfbAetAC6nRWKvH2B5mDUEotArr2rcED5pNH3wDKy01girSaYy3Ek
   EJXxg2tB4Gf7J8+gkLls+sU+wWYvEMX1/hS4itF0m0mqCWW3y2td817ww
   7vRd0nweKg4LQjvIB8Z9Or+LLreZdcioBNGGroTBmk/5elPwk6+mbTBBQ
   w==;
X-CSE-ConnectionGUID: nt8SWTBRTPiOqnziS/OZ/Q==
X-CSE-MsgGUID: gEyAMD/wSOqQk1Fb4gPgXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="87524119"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="87524119"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 02:40:58 -0800
X-CSE-ConnectionGUID: a9IVDN/MSSGr+0LJpC7EZA==
X-CSE-MsgGUID: 0pWTjuf2RZ+ggEbFBDy9iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="205993892"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Jan 2026 02:40:55 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi9AK-00000000Opn-2CGG;
	Tue, 20 Jan 2026 10:40:52 +0000
Date: Tue, 20 Jan 2026 18:39:55 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 d08c85ac8894995d4b0d8fb48d2f6a3e53cd79ab
Message-ID: <202601201847.OZKIcCOd-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: eiup7gksgaxd8euw47j7w57wmn35nzu1
X-Rspam-User: 
X-Rspamd-Queue-Id: B13B81C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768905658-951432
X-HE-Meta: U2FsdGVkX1+zbQDt6kHHvNgziULg9hsAXpU3L+r0DAAwv6jZlzjnbz1XQNkZ8Xs3t3Tz06uGvn60RYGMGpfUyhNag9GBOpkyPp/tZOOy12X1le49ViRRzdau5PRWRSwA40MfpgRuI90YgqWQoLgGtWQNN9WYd06HytqyAdwEttUJBmzziMZsosEesag7NAlJd0+mg8AgHXf06KJwZk+s7oWJhz+Ay4c/0aHWOyI0ny8VBVlBWTLQOFnRetBg1V1GCboBirW3l4CkACd6heyNKxPoDIbfZ7xykl0k2KDWlT3NSuOTKlyPC2YzTH44X2kRfXcEjsYkG6x5KsQQ0cuzy3F4bFsOjyXVoO37knEzxdn92MEhrHTPRHQB46GiT+hjoh/v/UOeH4e47IEaMck9MWACSfj6+7fp3vzeslWSVkxTyW30o6YTsO5/3VYL6UEP6HNRSxn6I44wLRzueKpE6Qpqj/UJVqT7zFWbKDnnGhnnewCDJ3FF79tasdK4jJ231H/bDj7xT3P1YSZWX26W6BoNOsbAZEECCfZLgGN8Ev7Niv041PKIsQlXR38XxpeEsuvDs+wpuQQF3cNOhLs2kyzj7PD6XoYSGCxtp3qhCoUBIKpseZYa6vR8c7JT+9Na9Ao0705GSNQhfooqmlg1cab3DR/fHSa22C/8CpRNE7u+sacWmwYoE3TRqW724ovNpMia5RAKCn3XwsKEm98j3qTSrRJu2lDcvef2dU5tqOtFZ6kADDqaBJbcwzQ31VNuxtcyZhuMgB7uyMuR+nMbf56wYdg3EtMu+YWc0fF5O09PNovTwfi2Pw6Rah4aaIKj3E80URVlzYFs+jXR0B7/mwHvrurl/7TUx0/WOuVUYdvSsOm7aR9EFNEsrLxj4XMRcTZ2gZBsireJY4HtQMXgxUloRAO35fOkf2x0saSjDXSUG7VtZy38l1WlfVP5HyefM8x2hqkqS3772ZQ0/lm
 sANDV8nx
 yQMzpt/WZXxkDIDhrLl53NbirPW2+DTaSPGKFmKr6DGEqN7Jc1pHjNqNL4niuOPucbSyFs+ET9rusKhzEeCPuzG+lSwAnfbrSMt0fSl62SueC9l1qRwPT2Y9SKiSDDL5ESG1nqDGln6xoRyJhYhr+BSJoqZG7DD7EiPnUBUZvmsSi9dvgM0poGMn6vQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d08c85ac8894995d4b0d8fb48d2f6a3e53cd79ab  Add linux-next specific files for 20260119

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601201710.IdchKtgV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601200750.sFxLwOJr-lkp@intel.com

    Warning: drivers/gpio/gpio-realtek-otto.c:66 cannot understand function prototype: 'struct realtek_gpio_ctrl'

Unverified Warning (likely false positive, kindly check if interested):

    lib/tests/uuid_kunit.c:104:1: sparse: sparse: bad integer constant expression

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r131-20260120
|   `-- lib-tests-uuid_kunit.c:sparse:sparse:bad-integer-constant-expression
|-- i386-randconfig-r132-20260120
|   `-- fs-namei.c:sparse:sparse:cast-truncates-bits-from-constant-value-(123456789abcdef-becomes-89abcdef)
|-- openrisc-allmodconfig
|   `-- Warning:drivers-gpio-gpio-realtek-otto.c-cannot-understand-function-prototype:struct-realtek_gpio_ctrl
|-- x86_64-randconfig-121-20260120
|   `-- lib-tests-uuid_kunit.c:sparse:sparse:bad-integer-constant-expression
`-- x86_64-randconfig-122-20260120
    `-- lib-tests-uuid_kunit.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 721m

configs tested: 268
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                            hsdk_defconfig    gcc-15.2.0
arc                   randconfig-001-20260120    clang-22
arc                   randconfig-001-20260120    gcc-10.5.0
arc                   randconfig-002-20260120    clang-22
arc                   randconfig-002-20260120    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          ixp4xx_defconfig    gcc-15.2.0
arm                        mvebu_v7_defconfig    clang-22
arm                   randconfig-001-20260120    clang-22
arm                   randconfig-002-20260120    clang-22
arm                   randconfig-002-20260120    gcc-13.4.0
arm                   randconfig-003-20260120    clang-22
arm                   randconfig-004-20260120    clang-22
arm                         socfpga_defconfig    clang-22
arm                    vt8500_v6_v7_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260120    gcc-12.5.0
arm64                 randconfig-001-20260120    gcc-15.2.0
arm64                 randconfig-002-20260120    gcc-15.2.0
arm64                 randconfig-002-20260120    gcc-8.5.0
arm64                 randconfig-003-20260120    clang-22
arm64                 randconfig-003-20260120    gcc-15.2.0
arm64                 randconfig-004-20260120    clang-22
arm64                 randconfig-004-20260120    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260120    gcc-15.2.0
csky                  randconfig-002-20260120    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260120    clang-22
hexagon               randconfig-001-20260120    gcc-12.5.0
hexagon               randconfig-002-20260120    clang-22
hexagon               randconfig-002-20260120    gcc-12.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260120    gcc-14
i386        buildonly-randconfig-002-20260120    gcc-14
i386        buildonly-randconfig-003-20260120    gcc-14
i386        buildonly-randconfig-004-20260120    clang-20
i386        buildonly-randconfig-004-20260120    gcc-14
i386        buildonly-randconfig-005-20260120    gcc-14
i386        buildonly-randconfig-006-20260120    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260120    clang-20
i386                  randconfig-001-20260120    gcc-14
i386                  randconfig-002-20260120    clang-20
i386                  randconfig-002-20260120    gcc-12
i386                  randconfig-003-20260120    clang-20
i386                  randconfig-004-20260120    clang-20
i386                  randconfig-005-20260120    clang-20
i386                  randconfig-006-20260120    clang-20
i386                  randconfig-007-20260120    clang-20
i386                  randconfig-007-20260120    gcc-14
i386                  randconfig-011-20260120    clang-20
i386                  randconfig-012-20260120    clang-20
i386                  randconfig-012-20260120    gcc-14
i386                  randconfig-013-20260120    clang-20
i386                  randconfig-014-20260120    clang-20
i386                  randconfig-015-20260120    clang-20
i386                  randconfig-016-20260120    clang-20
i386                  randconfig-017-20260120    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                loongson32_defconfig    clang-22
loongarch             randconfig-001-20260120    gcc-12.5.0
loongarch             randconfig-002-20260120    gcc-12.5.0
loongarch             randconfig-002-20260120    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  cavium_octeon_defconfig    gcc-15.2.0
mips                            gpr_defconfig    clang-18
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260120    gcc-11.5.0
nios2                 randconfig-001-20260120    gcc-12.5.0
nios2                 randconfig-002-20260120    gcc-11.5.0
nios2                 randconfig-002-20260120    gcc-12.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260120    gcc-8.5.0
parisc                randconfig-002-20260120    gcc-8.5.0
parisc                randconfig-002-20260120    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      bamboo_defconfig    clang-22
powerpc                    ge_imp3a_defconfig    gcc-15.2.0
powerpc                     mpc512x_defconfig    clang-22
powerpc                     mpc83xx_defconfig    clang-22
powerpc               randconfig-001-20260120    clang-19
powerpc               randconfig-001-20260120    gcc-8.5.0
powerpc               randconfig-002-20260120    gcc-10.5.0
powerpc               randconfig-002-20260120    gcc-8.5.0
powerpc                     tqm8540_defconfig    gcc-15.2.0
powerpc                     tqm8548_defconfig    clang-22
powerpc64             randconfig-001-20260120    gcc-12.5.0
powerpc64             randconfig-001-20260120    gcc-8.5.0
powerpc64             randconfig-002-20260120    clang-22
powerpc64             randconfig-002-20260120    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260120    gcc-13.4.0
riscv                 randconfig-002-20260120    gcc-10.5.0
riscv                 randconfig-002-20260120    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260120    gcc-13.4.0
s390                  randconfig-001-20260120    gcc-15.2.0
s390                  randconfig-002-20260120    clang-22
s390                  randconfig-002-20260120    gcc-13.4.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260120    gcc-13.4.0
sh                    randconfig-001-20260120    gcc-15.2.0
sh                    randconfig-002-20260120    gcc-11.5.0
sh                    randconfig-002-20260120    gcc-13.4.0
sh                          rsk7201_defconfig    clang-22
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260120    gcc-8.5.0
sparc                 randconfig-002-20260120    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260120    clang-22
sparc64               randconfig-001-20260120    gcc-8.5.0
sparc64               randconfig-002-20260120    clang-20
sparc64               randconfig-002-20260120    gcc-8.5.0
um                               alldefconfig    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260120    gcc-14
um                    randconfig-001-20260120    gcc-8.5.0
um                    randconfig-002-20260120    gcc-14
um                    randconfig-002-20260120    gcc-8.5.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260120    gcc-14
x86_64      buildonly-randconfig-002-20260120    gcc-14
x86_64      buildonly-randconfig-003-20260120    gcc-14
x86_64      buildonly-randconfig-004-20260120    clang-20
x86_64      buildonly-randconfig-004-20260120    gcc-14
x86_64      buildonly-randconfig-005-20260120    gcc-14
x86_64      buildonly-randconfig-006-20260120    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260120    gcc-13
x86_64                randconfig-001-20260120    gcc-14
x86_64                randconfig-002-20260120    gcc-13
x86_64                randconfig-002-20260120    gcc-14
x86_64                randconfig-003-20260120    gcc-14
x86_64                randconfig-004-20260120    gcc-14
x86_64                randconfig-005-20260120    gcc-14
x86_64                randconfig-006-20260120    gcc-13
x86_64                randconfig-006-20260120    gcc-14
x86_64                randconfig-011-20260120    clang-20
x86_64                randconfig-011-20260120    gcc-14
x86_64                randconfig-012-20260120    gcc-12
x86_64                randconfig-012-20260120    gcc-14
x86_64                randconfig-013-20260120    clang-20
x86_64                randconfig-013-20260120    gcc-14
x86_64                randconfig-014-20260120    gcc-14
x86_64                randconfig-015-20260120    clang-20
x86_64                randconfig-015-20260120    gcc-14
x86_64                randconfig-016-20260120    gcc-14
x86_64                randconfig-071-20260120    gcc-14
x86_64                randconfig-072-20260120    gcc-14
x86_64                randconfig-073-20260120    clang-20
x86_64                randconfig-073-20260120    gcc-14
x86_64                randconfig-074-20260120    gcc-14
x86_64                randconfig-075-20260120    clang-20
x86_64                randconfig-075-20260120    gcc-14
x86_64                randconfig-076-20260120    clang-20
x86_64                randconfig-076-20260120    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260120    gcc-13.4.0
xtensa                randconfig-001-20260120    gcc-8.5.0
xtensa                randconfig-002-20260120    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

