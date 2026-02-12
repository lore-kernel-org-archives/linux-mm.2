Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B57FEDF021
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D75B6B0005; Wed, 11 Feb 2026 22:06:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5856E6B0089; Wed, 11 Feb 2026 22:06:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4911E6B008A; Wed, 11 Feb 2026 22:06:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 349E26B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:06:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B133B8C003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:06:05 +0000 (UTC)
X-FDA: 84434315490.22.78E6702
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id CDA6AC000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:06:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ITpkvZ22;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770865564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XWjjTWkboRloK9F8kZDi3yOXRHtuNWMP6JTgCD3CT84=;
	b=rNlf6Zc+ij7w7xWZI+XkUgUQrJv5QggdScx4y56J2N0lKrPynVaiSvYU+IO11/BvrQfgjC
	NBEnFpo0wGBogdcG1XuvPcGreLY1IfxU2dtxawbblAUPyOqARGnRvNj8v9cunCc1zUS0le
	uv/BhQ5FysZ6RGod0VBrIPWlTjpf928=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ITpkvZ22;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770865564; a=rsa-sha256;
	cv=none;
	b=Hz7RLLefKxdek9t9wXoASgK+jt5+9BBVKWEX/LqLtxtG2PcdJZRFrLq9Qok7yWbo8w4Lv4
	7qH0LcxdvOT5+T94VTXRh1SCrR5VGpruIUTfZIYcn/+Y1OT21nFenD0MviP91QNBDs8XCa
	Eas+ivOu4i9Y/tMPljcMLO4khK1q2/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770865563; x=1802401563;
  h=date:from:to:cc:subject:message-id;
  bh=V4/1E1Nwsu5ZpPJeWJjLkiEBjoQ/19WDIVhJ6oxv5nI=;
  b=ITpkvZ22rbQdPzQQ2mkT+/UZ5ZLOEKcz1tifKN3wQ9cz6gBiUe/OmpdO
   rZmkzlqU6lHfrl/c8dV2t9KxovIK0q0+VycIOjcYCGmMxr08I7biVB3vp
   IyMweVf1KV5Un1DJmDDYP+xUfdnD8io0vlpc5YNIDgt98PHX0xKecGw6v
   EjEd0s+QfqzMOE3t9L+7W97L2IMYXcNAOG5FKbr0Ai+RDFZ3JUcwT8Nci
   gmMIEFY0s2oVeVZnHU3OH+OD2gvWpuwh4XzEogbBXj9EiDfNazZr1JDvu
   39+21MnOH+RVNq1uFVjW9nNjHqWChOvCfNYjnYt6THqsF26AvxVjpSb9S
   g==;
X-CSE-ConnectionGUID: mE7TU0E6Qfe8NTLBX9zVgA==
X-CSE-MsgGUID: 8zoNZhOvRt272vjLESCjLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="74630063"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="74630063"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:06:01 -0800
X-CSE-ConnectionGUID: 7J74ShgETXCXeqL0ehzaaw==
X-CSE-MsgGUID: 3GqoFA63SdO6xW5I39rZxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="211316844"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 11 Feb 2026 19:06:00 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqN1h-00000000qaa-40kt;
	Thu, 12 Feb 2026 03:05:57 +0000
Date: Thu, 12 Feb 2026 11:05:37 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 9152bc8cebcb14dc16b03ec81f2377ee8ce12268
Message-ID: <202602121126.m4EU3ZRX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Stat-Signature: mwm8urbumkq4greuwyhax3niy47ds9n9
X-Rspamd-Queue-Id: CDA6AC000A
X-Rspam-User: 
X-HE-Tag: 1770865562-159717
X-HE-Meta: U2FsdGVkX1/QrYYHFmWEwM1jnfv37oZ06gaHg7pBGTP4KYUw9Bq63IvFBaEqnWsS5bSAoMU9RUuGXQncuRpdMB8PufwHov12LQ5ZomCledzafkAsbb71N5EyxucpYesGGa03qjTYnXz8qsTVfBUbNTGcoUgHiMsP4aq5PWj1X68uFIq0+F9r08VxRurvPsSt29StieAoGGjiedXv8w8BVLvTX9ndffvodgIyiGk5XnHd4H8QgPbsE2iQqw6+j4IL4MuTZ1elU/ojsG1iozNyobVAZ6yIkA1HSXW3L0WHox6fRi7GruXWhlPENZ9v+Wy/xStPlhoU+R4NH3zVPbxEbLvVLOmp/mbENwloxcUBkR1Ez6TW6gQERC8zfJ/NuVDQaKzc70rNzqsdUsvWC0DhUHPahU8n/mJ99XsEKFsCLFcemg9h6CsI1lh15sjZzfEUdT62wStuCgKetBRVWgHG2aB4J5w9EJn5avutTQ9QzUV3VDUEzUfLvkvcgFiiVs7YkClLTJuuIg7zlbIEykVOv8Zdwh+GvYRFKid0XIGG3NeLFRf8Fq/qU35fKn9e5L8d+iQzyWHpXq6AQ9HYC2/nqeAo/5NXedklaoNUIOcrvxGIkPednrmH5O61nkDRApv3UkzkNwnAau3fN3LGLkmrKqaYR3X4hSTQrJVVd4S9MCwSf+of1GCVfC8TTFqo1Nl9uPbHCJd38Bf83t0CseqYAbKKdvld5Gau7x0xGv7TV5sxFOxF+YYx3CtGzrrFwmSXqCKfUZh6eQhH8cLNs3Wd8OybYDsPOHNfUaL+lY3WOxzk9Wu5nI9gxReWK7LstMPZ4njtH8H1f5I1lXKKhMD1dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9152bc8cebcb14dc16b03ec81f2377ee8ce12268  Add linux-next specific files for 20260211

Unverified Warning (likely false positive, kindly check if interested):

    drivers/remoteproc/st_slim_rproc.c:126 slim_rproc_start() warn: potential ! vs ~ typo
    drivers/remoteproc/st_slim_rproc.c:165 slim_rproc_stop() warn: potential ! vs ~ typo

Warning ids grouped by kconfigs:

recent_errors
`-- hexagon-randconfig-r073-20260212
    |-- drivers-remoteproc-st_slim_rproc.c-slim_rproc_start()-warn:potential-vs-typo
    `-- drivers-remoteproc-st_slim_rproc.c-slim_rproc_stop()-warn:potential-vs-typo

elapsed time: 729m

configs tested: 207
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260212    gcc-9.5.0
arc                   randconfig-002-20260212    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                          pxa910_defconfig    gcc-15.2.0
arm                   randconfig-001-20260212    gcc-8.5.0
arm                   randconfig-002-20260212    gcc-10.5.0
arm                   randconfig-003-20260212    clang-22
arm                   randconfig-004-20260212    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260212    clang-22
arm64                 randconfig-002-20260212    gcc-10.5.0
arm64                 randconfig-003-20260212    clang-22
arm64                 randconfig-004-20260212    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260212    gcc-15.2.0
csky                  randconfig-002-20260212    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260212    clang-18
hexagon               randconfig-001-20260212    clang-22
hexagon               randconfig-002-20260212    clang-18
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260212    gcc-14
i386        buildonly-randconfig-002-20260212    gcc-14
i386        buildonly-randconfig-003-20260212    clang-20
i386        buildonly-randconfig-004-20260212    gcc-13
i386        buildonly-randconfig-005-20260212    gcc-14
i386        buildonly-randconfig-006-20260212    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260212    clang-20
i386                  randconfig-002-20260212    clang-20
i386                  randconfig-003-20260212    clang-20
i386                  randconfig-004-20260212    clang-20
i386                  randconfig-005-20260212    gcc-14
i386                  randconfig-006-20260212    gcc-14
i386                  randconfig-007-20260212    clang-20
i386                  randconfig-011-20260211    clang-20
i386                  randconfig-012-20260211    clang-20
i386                  randconfig-013-20260211    clang-20
i386                  randconfig-014-20260211    clang-20
i386                  randconfig-015-20260211    clang-20
i386                  randconfig-016-20260211    clang-20
i386                  randconfig-017-20260211    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260212    clang-18
loongarch             randconfig-002-20260212    clang-18
loongarch             randconfig-002-20260212    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
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
mips                           ci20_defconfig    clang-22
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260212    clang-18
nios2                 randconfig-001-20260212    gcc-11.5.0
nios2                 randconfig-002-20260212    clang-18
nios2                 randconfig-002-20260212    gcc-8.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260212    gcc-8.5.0
parisc                randconfig-002-20260212    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                          g5_defconfig    gcc-15.2.0
powerpc                      mgcoge_defconfig    clang-22
powerpc                      pasemi_defconfig    clang-22
powerpc               randconfig-001-20260212    clang-22
powerpc               randconfig-002-20260212    gcc-10.5.0
powerpc64             randconfig-001-20260212    clang-22
powerpc64             randconfig-002-20260212    gcc-11.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260212    gcc-9.5.0
riscv                 randconfig-002-20260212    clang-18
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260212    gcc-15.2.0
s390                  randconfig-002-20260212    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260212    gcc-10.5.0
sh                    randconfig-002-20260212    gcc-12.5.0
sh                             sh03_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260212    gcc-13.4.0
sparc                 randconfig-002-20260212    gcc-14.3.0
sparc                       sparc64_defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260212    gcc-14.3.0
sparc64               randconfig-002-20260212    gcc-13.4.0
um                               alldefconfig    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260212    gcc-14
um                    randconfig-002-20260212    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260212    clang-20
x86_64      buildonly-randconfig-002-20260212    clang-20
x86_64      buildonly-randconfig-003-20260212    gcc-14
x86_64      buildonly-randconfig-004-20260211    gcc-12
x86_64      buildonly-randconfig-004-20260212    clang-20
x86_64      buildonly-randconfig-005-20260212    clang-20
x86_64      buildonly-randconfig-006-20260212    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260211    clang-20
x86_64                randconfig-002-20260211    clang-20
x86_64                randconfig-003-20260211    clang-20
x86_64                randconfig-004-20260211    clang-20
x86_64                randconfig-005-20260211    clang-20
x86_64                randconfig-006-20260211    clang-20
x86_64                randconfig-011-20260212    clang-20
x86_64                randconfig-012-20260212    gcc-14
x86_64                randconfig-013-20260212    clang-20
x86_64                randconfig-014-20260212    gcc-13
x86_64                randconfig-015-20260212    gcc-14
x86_64                randconfig-016-20260212    clang-20
x86_64                randconfig-071-20260212    clang-20
x86_64                randconfig-072-20260212    gcc-14
x86_64                randconfig-073-20260212    gcc-14
x86_64                randconfig-074-20260212    gcc-14
x86_64                randconfig-075-20260212    gcc-14
x86_64                randconfig-076-20260212    clang-20
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
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260212    gcc-8.5.0
xtensa                randconfig-002-20260212    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

