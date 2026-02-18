Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCD5E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB706B0088; Wed, 18 Feb 2026 00:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8F06B0089; Wed, 18 Feb 2026 00:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B54E6B008A; Wed, 18 Feb 2026 00:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00D7E6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:19:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FCFB1A02B4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:19:42 +0000 (UTC)
X-FDA: 84456425004.22.7962F12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFDA3A0006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:19:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MNQtpSCl;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771391980; a=rsa-sha256;
	cv=none;
	b=zkGPrBMBnWSQE6vOaGncj8Vd5s+KxpYdV3SaqdFDvKYscIPWOaWjejeoBJD1ml6f/0WuJD
	5dEFg3FFzsVdCQistnKaaycbOyYllyb6641l4o/+PO/91oNR6j6HkTh/j4YHp6FKxB8K/F
	4caSMEgpSxewNLqf6+Q9eetdXQ/8Md4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MNQtpSCl;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771391980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=1OTveafEKIMZ1y7FWe47XzFxX4kNegiIOPXh4FB6DpA=;
	b=Vedcfg38UEEuhqQIbbssvFPrNqzib0WcxnVLHSZuH58KLehTQDyYyFsl87jMQmyY0aXbCI
	LRvbETrtmbvnCYg2zOOnUxFdY90VtRQkMq5tmfCGa61EEXXwZzXiS0NjmerkMvUqqEB2bc
	EcCJDSl1qGRqUFlO4SBgwAQmBE0vg1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771391980; x=1802927980;
  h=date:from:to:cc:subject:message-id;
  bh=t8nS0+jTBefa9YwdzaM0dC4jTIpsSEO0322UkL+V914=;
  b=MNQtpSClgPizxBwh1JBYz6MEHzST3CbS9I9pjfgRlwAp82uGEFFnb2RU
   EvZptYoyhVQn42VDZTnYr8omJUWFwGXDyWYW4+TTRRthoSytnl/xzf3aO
   i6C/Xk0c/HwZ1/IFlOtBZ4Ea74D5aheVXNOZaxbVoUqjD8pAp0lOcl6pk
   VioT9VQqaQdmGkVQgCYoEkk8oDuc2nNetlJMh4jdlhegBMK5RzYPwpgWM
   4s+SQwo3FBRwtmByjf9QkgMc3gBTPhjDu72KfRc271iJk2qB8P/PNer1/
   CvrEoxEvdIJqzmHpHsBwU2C2sfagAhhzzHUs/0X7LiPYk1FpWKVqLDJ8p
   Q==;
X-CSE-ConnectionGUID: /BlCZlGJSb283XtFht3+7Q==
X-CSE-MsgGUID: JFJUBTtiTziiA9k4cUfvtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72533712"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="72533712"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 21:19:38 -0800
X-CSE-ConnectionGUID: kLYg/waoTRa1kKqCSPftLg==
X-CSE-MsgGUID: PfDK+sJHRICuev39ApbqNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="212489145"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 17 Feb 2026 21:19:36 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsZyI-0000000125U-0tSx;
	Wed, 18 Feb 2026 05:19:34 +0000
Date: Wed, 18 Feb 2026 13:18:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 fe9e3edb6a215515d1148d32a5c445c5bdd7916f
Message-ID: <202602181336.NOI7DRGg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: BFDA3A0006
X-Stat-Signature: dz3x3h9sj8sqoc8uzcez9y9xgx1hf1y7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771391979-535522
X-HE-Meta: U2FsdGVkX18R7WI/SlSAWAb/8xeKhW187+se8e8Rl4oImwtulZunj9lVvrggcUv6XJfexCQPkTtVbbI17CFuolO8gBZBqU/nfLROGKhrB7gjx0hAfAc0AK8tl6H3ATdeiF0FT6eQKbQMjNLMvczk5BLhaidtwtIPlatd4nx2OB7NdF8cQFVia3+WJumELzGegSD8mRsQWfVOOOX0s8BROMGk743DBOky921JOywPGoyhH8kXwI9ZUXdfKNd0eIWZO93oW2AvFxuCGru6baEf/juURcifYDk+/iK3IHdaYmm4jQ6q52bpPnqvtQ2LQK8wnELyfFTqqfGwPUj6LxN7m8LiLlifpR7b+DyOXxqauDu4yTuwGl8UzEE5DLzLBIQhKNIra2evxxwEy0Lr3KoSPIDDuXumxF4+o4eMAYkmfz9blIsZdL9q+x5IsMBMLv7od+4jFEZkBF0BLH01Oo/ZcgmyUfMww2vkNJeeJrVjpPCd2w3O3gR4ezWUW3GM1f9uJiJxd4Nj6iRB4x8nz4dBkKwIYoBKceim4tx6+JhJspOTHveJA4v4Ydh7a9BOHdTk/bK3NJNgFMbXpONd01eeWIic3ZJ6S7tb/9P1BxixVtSz28tnCfuDmc8cjpNZt6UxV0lZZLc3JWAEhQ88UFkv4o6GZag6ZYVoLap395/boISTitoyZ8Az0O0DM71XCgWhgCdO5QtFI6u5Z1KYAjq/TxlS1Qi1+0o1GnKwGQhoXfJCwjC5wHGjJbPz5rnM4+cPeud0eDe3rgZ91BN7KM98yBruzeeYEyS2mc/E3Ndfjs5j+BNF+AbicvsIUJjH/hXDg25g/b3QrCrpLhRzWWQok39niZBymMNb1DzFCtFf+wE5gr1lp6Kv1fJskm/FsCS4Rr2aVtOsgR/3oejB//+Ad21jSkCDXaSWzFOpTlCRqCKSYPPywJVQgFwFHMyiOOr64I6SMDJTcaAJD3zRv7V
 5bAv/QNJ
 WnZYioTaJaaES3o3ROYuCpvg7Gcewsi1t8qQkufY3WwC+nF3j3PBpSlPR/RSuH5My391rNcVtHSGD1txcI+OukESTDEhVJoZi2LS1b+PhDyidIya1K+/giI0OSlBoKeRM2jpaVEsZ/bkaW1+Bj9KhbG/b5kY05vf5C41T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fe9e3edb6a215515d1148d32a5c445c5bdd7916f  Add linux-next specific files for 20260217

elapsed time: 762m

configs tested: 261
configs skipped: 4

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
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     haps_hs_smp_defconfig    clang-23
arc                   randconfig-001-20260218    clang-23
arc                   randconfig-001-20260218    gcc-9.5.0
arc                   randconfig-002-20260218    clang-23
arc                   randconfig-002-20260218    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                          exynos_defconfig    clang-23
arm                      footbridge_defconfig    clang-17
arm                        keystone_defconfig    gcc-15.2.0
arm                        mvebu_v5_defconfig    clang-23
arm                         orion5x_defconfig    clang-23
arm                   randconfig-001-20260218    clang-23
arm                   randconfig-002-20260218    clang-23
arm                   randconfig-003-20260218    clang-23
arm                   randconfig-004-20260218    clang-23
arm                         socfpga_defconfig    clang-23
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260218    clang-23
arm64                 randconfig-001-20260218    gcc-8.5.0
arm64                 randconfig-002-20260218    clang-23
arm64                 randconfig-003-20260218    clang-23
arm64                 randconfig-003-20260218    gcc-14.3.0
arm64                 randconfig-004-20260218    clang-23
arm64                 randconfig-004-20260218    gcc-11.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260218    clang-23
csky                  randconfig-001-20260218    gcc-15.2.0
csky                  randconfig-002-20260218    clang-23
csky                  randconfig-002-20260218    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260218    clang-16
hexagon               randconfig-002-20260218    clang-16
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260218    clang-20
i386        buildonly-randconfig-002-20260218    clang-20
i386        buildonly-randconfig-003-20260218    clang-20
i386        buildonly-randconfig-004-20260218    clang-20
i386        buildonly-randconfig-004-20260218    gcc-13
i386        buildonly-randconfig-005-20260218    clang-20
i386        buildonly-randconfig-006-20260218    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260218    clang-20
i386                  randconfig-002-20260218    clang-20
i386                  randconfig-002-20260218    gcc-14
i386                  randconfig-003-20260218    clang-20
i386                  randconfig-003-20260218    gcc-14
i386                  randconfig-004-20260218    clang-20
i386                  randconfig-004-20260218    gcc-13
i386                  randconfig-005-20260218    clang-20
i386                  randconfig-006-20260218    clang-20
i386                  randconfig-007-20260218    clang-20
i386                  randconfig-007-20260218    gcc-14
i386                  randconfig-011-20260218    gcc-12
i386                  randconfig-012-20260218    gcc-14
i386                  randconfig-013-20260218    clang-20
i386                  randconfig-014-20260218    gcc-14
i386                  randconfig-015-20260218    gcc-14
i386                  randconfig-016-20260218    clang-20
i386                  randconfig-017-20260218    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260218    clang-16
loongarch             randconfig-001-20260218    clang-23
loongarch             randconfig-002-20260218    clang-16
loongarch             randconfig-002-20260218    clang-23
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
mips                            gpr_defconfig    clang-18
mips                           ip22_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260218    clang-16
nios2                 randconfig-001-20260218    gcc-11.5.0
nios2                 randconfig-002-20260218    clang-16
nios2                 randconfig-002-20260218    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260218    gcc-8.5.0
parisc                randconfig-002-20260218    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                    adder875_defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      chrp32_defconfig    clang-19
powerpc                      ep88xc_defconfig    clang-23
powerpc                     kmeter1_defconfig    clang-23
powerpc                 mpc8313_rdb_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260218    clang-23
powerpc               randconfig-002-20260218    gcc-8.5.0
powerpc64             randconfig-001-20260218    gcc-8.5.0
powerpc64             randconfig-002-20260218    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260218    clang-23
riscv                 randconfig-002-20260218    clang-23
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260218    clang-23
s390                  randconfig-002-20260218    clang-23
sh                               alldefconfig    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260218    clang-23
sh                    randconfig-001-20260218    gcc-15.2.0
sh                    randconfig-002-20260218    clang-23
sh                    randconfig-002-20260218    gcc-13.4.0
sh                          urquell_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260218    gcc-10.5.0
sparc                 randconfig-001-20260218    gcc-14.3.0
sparc                 randconfig-002-20260218    gcc-10.5.0
sparc                 randconfig-002-20260218    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260218    gcc-10.5.0
sparc64               randconfig-001-20260218    gcc-11.5.0
sparc64               randconfig-002-20260218    gcc-10.5.0
sparc64               randconfig-002-20260218    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260218    clang-23
um                    randconfig-001-20260218    gcc-10.5.0
um                    randconfig-002-20260218    gcc-10.5.0
um                    randconfig-002-20260218    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260218    gcc-14
x86_64      buildonly-randconfig-002-20260218    clang-20
x86_64      buildonly-randconfig-002-20260218    gcc-14
x86_64      buildonly-randconfig-003-20260218    clang-20
x86_64      buildonly-randconfig-003-20260218    gcc-14
x86_64      buildonly-randconfig-004-20260218    gcc-14
x86_64      buildonly-randconfig-005-20260218    gcc-14
x86_64      buildonly-randconfig-006-20260218    clang-20
x86_64      buildonly-randconfig-006-20260218    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260218    clang-20
x86_64                randconfig-001-20260218    gcc-14
x86_64                randconfig-002-20260218    clang-20
x86_64                randconfig-002-20260218    gcc-14
x86_64                randconfig-003-20260218    gcc-14
x86_64                randconfig-004-20260218    clang-20
x86_64                randconfig-004-20260218    gcc-14
x86_64                randconfig-005-20260218    gcc-14
x86_64                randconfig-006-20260218    clang-20
x86_64                randconfig-006-20260218    gcc-14
x86_64                randconfig-011-20260218    clang-20
x86_64                randconfig-011-20260218    gcc-13
x86_64                randconfig-012-20260218    gcc-13
x86_64                randconfig-013-20260218    gcc-13
x86_64                randconfig-013-20260218    gcc-14
x86_64                randconfig-014-20260218    clang-20
x86_64                randconfig-014-20260218    gcc-13
x86_64                randconfig-015-20260218    gcc-13
x86_64                randconfig-016-20260218    gcc-13
x86_64                randconfig-016-20260218    gcc-14
x86_64                randconfig-071-20260218    clang-20
x86_64                randconfig-072-20260218    clang-20
x86_64                randconfig-073-20260218    clang-20
x86_64                randconfig-074-20260218    clang-20
x86_64                randconfig-075-20260218    clang-20
x86_64                randconfig-076-20260218    clang-20
x86_64                randconfig-076-20260218    gcc-14
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
xtensa                randconfig-001-20260218    gcc-10.5.0
xtensa                randconfig-001-20260218    gcc-9.5.0
xtensa                randconfig-002-20260218    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

