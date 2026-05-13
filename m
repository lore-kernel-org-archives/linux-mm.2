Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 229E7CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327FB6B0095; Wed, 13 May 2026 14:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8446B0096; Wed, 13 May 2026 14:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6F46B0098; Wed, 13 May 2026 14:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 053E86B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:37:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A5691C1050
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:37:18 +0000 (UTC)
X-FDA: 84763254156.29.E71D0B2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id E54BAA000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:37:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GaRXCl+p;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778697436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4gAo62f9+PX4PH5nNfK7XU3YDR4bJl71LsBmqauyxbQ=;
	b=EdprtwXPJEUNuDmMzReA0OpsbjgwdO8sly8QqFZ7K4bQ05vi5yJoIjK+Z0xRhkdpReahKR
	/kFYeKIpKxGxUeQ8knZioAJPUvoJX/SJ6wzomiYbIySicKR5187qty/rUIUOwdEv2l4agy
	WUAiuKI8t4riSF6iW7uaW17lljOjAcM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GaRXCl+p;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778697436; a=rsa-sha256;
	cv=none;
	b=VaQp0IeN32w8tnsvPU+Y8tXJvOYo+zoNB3Dvsr89Cfo66z+UqzqJQ5NkzoXGzmZorFIDtr
	dwF820JZX5tWGtRuxXACLKwFHrTE8FbovxN0lkGfD8x0yP0LB8SEfXLYed1YHdhtbi604n
	s6rctYZ1nJ1G2sMSfwUFMbXewd7u9UE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778697436; x=1810233436;
  h=date:from:to:cc:subject:message-id;
  bh=KkwjqngUn3yyqONCywdbNwk2+HEXMQ0bcSipeqW1zwo=;
  b=GaRXCl+pkSN3eSVFhzIHoRCdknMI96zXPzY8r6pqlyOYuW53rXl9yple
   fOdsn+X7ACHlIA02spLLFFnknbAuqhb7BWHm0ps7VLMqPBlXVWKt5/wnu
   gmf0zIZMNQDeSPNlPOrIOot9DHe80qKHFcFggQhYzPaFn25B98UnDY00W
   eE6gncWV8Wn54M3q3nMGPZGeT0kWxvAER65UgOeKBKdDIwGvAVEYs64sl
   t3e8pHS+jdYYLmwFP81/54GzxS8xD9f3ylVt/xuSYknpQT3FdSf7CfQup
   RXImhBTd/k2VXurVWoZM0uziemO0s5HrLf7SwQBmosAUdBAdmre5AL1fI
   A==;
X-CSE-ConnectionGUID: ME1uZFRpSi2gSHK3/ifbYA==
X-CSE-MsgGUID: wfoTwQm0SbGlkgjNoCex+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83505940"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="83505940"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 11:37:15 -0700
X-CSE-ConnectionGUID: W1SEZYX2QYeOt/9W8BieVw==
X-CSE-MsgGUID: h03F4QpSTpOkcqMFH33MJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="243128340"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 May 2026 11:37:13 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNESE-000000004rb-2HYF;
	Wed, 13 May 2026 18:37:10 +0000
Date: Thu, 14 May 2026 02:36:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 2c3f468717231305523ddcd94d91c0d5e4a72419
Message-ID: <202605140240.m60BM8lM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E54BAA000D
X-Rspam-User: 
X-Stat-Signature: emngssod6z9de75ugddrk73gxr6dmrfo
X-HE-Tag: 1778697435-649764
X-HE-Meta: U2FsdGVkX1962SsgwKweqU6ARM4zKu2LzQ5/OpJT/Kxg7rzINnf04p32Bmcgqttb0/S2mf5yKKedIqS8qXnv1CkkY4R3SiMkITX7Qf+96cIZJPgAC3L4TOAa+qz/G6H1UsYwqfJzKGoV9DaVJ8uTseSv3pCqV/pEV0lhGUDkFr2GnetrjPIRzA5v9D5M2UfQ9hF08L5FHB6YWtbryqZZ+w6A5/Na90+5QF7SK7sPXE6j6B6/Ios3m2A8PjV+ABI2SulKFGq10jA5Ql0me0bA42S8WSIDIiJ6ZPLBcws4AtLsgWtvu1Npez41Xxd17trfhBaP1GcAhPxNBwnUMOnyLmAIov8GGpJyABsh2R3mGCudxaZuPwpOG8mZ0vagJeuyFFkcsf8nxomxQJutbi7qhP0v8QLRIAbRJUwpOmN4FWrsT2KIJ0V4Ym3kJjBFrPgXlG8r8NHUSXma+2UF/BcD+Y5eiH+lY7AJXxUA6/7jwaPdWpDNqXxWq+eJCzdslogbkP+QDrQ4VgHHIdLZ8l74x7Le8shxDPgCtdaenwfQvC38euwE+5Nq6Q0c8Z7AJwVNM01YlQ3LdxI49w3Aw9w3EUX5VR93NFSnI7aSGP2EyvGj19gnPl+GfaEQ5wrtgL043fKV/6qpvRIcPo8IR4Yikhq1o/JqvosO0/K2l6gtRv/Xv4+8U4hcajspQzP+8Tpp6cjFG62JcGQUGsuMqkUfl/7B4YOe/M6Q7jy42nPerNmUBmMT1CI5hvlNssDUVKhvdq7HGZyvaN3UUlV9wb+BxrQjnY+497VejrSoB0TxcKvj+gOpx9b6AanI1wn7Bogi5+j5WUy2KTmSjN4CdzXb1owHEphgu1ENZHDItc6DzUOTPigNdhng2DKHXD7TCiWNuEZloHAgOgxOQT1msJx+mXwbtPmRY95KculKK6kmUcOgjPHZQcaRuY8aWBbAIjE64YXnWt8AfBapaq1lIfB
 XQPRfZr3
 gvZ5lMkRQZlq/5/g0fRcCYbFNVrqLFf2EtiQdr62v7Rc609RBShpScud6goWd57DDt8YznFVjERHsLTBsdEIj7NSGz+Rf3lDgEN3fB3vmekYeprt/H42rMSMCHNZwH4AQDwTaeJibDIan8gdMxyz3ms63euXEnpJ7VWRXEexRWxvwqbkcimp1TWTpgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2c3f468717231305523ddcd94d91c0d5e4a72419  mm/hugetlb_cma: restrict hugetlb_cma parameter to gigantic-page alignment

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com

    mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- arm-randconfig-003-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- csky-randconfig-r073-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- i386-randconfig-141
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- i386-randconfig-141-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- m68k-randconfig-r071-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- parisc-randconfig-r072-20260513
|   `-- include-linux-damon.h-damon_rand()-warn:always-true-condition-(span-(-))-(-u32max-u32max)
|-- sh-allmodconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-allnoconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-allyesconfig
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
|-- sh-randconfig-001-20260513
|   `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used
`-- sh-randconfig-r062-20260513
    `-- mm-oom_kill.c:warning:kill_all_shared_mm-defined-but-not-used

elapsed time: 748m

configs tested: 276
configs skipped: 17

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
arc                   randconfig-001-20260513    gcc-14.3.0
arc                   randconfig-001-20260513    gcc-8.5.0
arc                   randconfig-002-20260513    gcc-14.3.0
arc                   randconfig-002-20260513    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                          ixp4xx_defconfig    gcc-15.2.0
arm                   randconfig-001-20260513    gcc-14.3.0
arm                   randconfig-001-20260513    gcc-8.5.0
arm                   randconfig-002-20260513    gcc-14.3.0
arm                   randconfig-003-20260513    gcc-13.4.0
arm                   randconfig-003-20260513    gcc-14.3.0
arm                   randconfig-004-20260513    clang-23
arm                   randconfig-004-20260513    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260513    clang-23
arm64                 randconfig-001-20260513    gcc-12.5.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260513    clang-23
arm64                 randconfig-002-20260513    gcc-12.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260513    clang-23
arm64                 randconfig-003-20260513    gcc-12.5.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260513    clang-17
arm64                 randconfig-004-20260513    clang-23
arm64                 randconfig-004-20260513    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260513    clang-23
csky                  randconfig-001-20260513    gcc-12.5.0
csky                  randconfig-001-20260513    gcc-13.4.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260513    clang-23
csky                  randconfig-002-20260513    gcc-10.5.0
csky                  randconfig-002-20260513    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260513    clang-23
hexagon               randconfig-001-20260513    gcc-11.5.0
hexagon               randconfig-001-20260513    gcc-8.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260513    clang-23
hexagon               randconfig-002-20260513    gcc-11.5.0
hexagon               randconfig-002-20260513    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260513    clang-20
i386        buildonly-randconfig-002-20260513    clang-20
i386        buildonly-randconfig-002-20260513    gcc-14
i386        buildonly-randconfig-003-20260513    clang-20
i386        buildonly-randconfig-004-20260513    clang-20
i386        buildonly-randconfig-005-20260513    clang-20
i386        buildonly-randconfig-006-20260513    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260513    clang-20
i386                  randconfig-001-20260513    gcc-14
i386                  randconfig-002-20260513    clang-20
i386                  randconfig-003-20260513    clang-20
i386                  randconfig-003-20260513    gcc-14
i386                  randconfig-004-20260513    clang-20
i386                  randconfig-004-20260513    gcc-14
i386                  randconfig-005-20260513    clang-20
i386                  randconfig-005-20260513    gcc-12
i386                  randconfig-006-20260513    clang-20
i386                  randconfig-006-20260513    gcc-14
i386                  randconfig-007-20260513    clang-20
i386                  randconfig-011-20260513    clang-20
i386                  randconfig-012-20260513    clang-20
i386                  randconfig-012-20260513    gcc-14
i386                  randconfig-013-20260513    clang-20
i386                  randconfig-014-20260513    clang-20
i386                  randconfig-015-20260513    clang-20
i386                  randconfig-016-20260513    clang-20
i386                  randconfig-017-20260513    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260513    clang-19
loongarch             randconfig-001-20260513    gcc-11.5.0
loongarch             randconfig-001-20260513    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260513    clang-23
loongarch             randconfig-002-20260513    gcc-11.5.0
loongarch             randconfig-002-20260513    gcc-8.5.0
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
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260513    gcc-11.5.0
nios2                 randconfig-001-20260513    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260513    gcc-11.5.0
nios2                 randconfig-002-20260513    gcc-8.5.0
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
parisc                randconfig-001-20260513    gcc-8.5.0
parisc                randconfig-002-20260513    gcc-8.5.0
parisc                randconfig-002-20260513    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260513    gcc-8.5.0
powerpc               randconfig-002-20260513    gcc-8.5.0
powerpc64             randconfig-001-20260513    gcc-8.5.0
powerpc64             randconfig-002-20260513    clang-23
powerpc64             randconfig-002-20260513    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260513    clang-17
riscv                 randconfig-001-20260513    gcc-15.2.0
riscv                 randconfig-002-20260513    clang-23
riscv                 randconfig-002-20260513    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260513    clang-23
s390                  randconfig-001-20260513    gcc-15.2.0
s390                  randconfig-002-20260513    gcc-12.5.0
s390                  randconfig-002-20260513    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                 kfr2r09-romimage_defconfig    gcc-15.2.0
sh                    randconfig-001-20260513    gcc-15.2.0
sh                    randconfig-002-20260513    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260513    gcc-11.5.0
sparc                 randconfig-002-20260513    gcc-11.5.0
sparc                 randconfig-002-20260513    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260513    gcc-11.5.0
sparc64               randconfig-001-20260513    gcc-8.5.0
sparc64               randconfig-002-20260513    gcc-11.5.0
sparc64               randconfig-002-20260513    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260513    gcc-11.5.0
um                    randconfig-001-20260513    gcc-14
um                    randconfig-002-20260513    clang-23
um                    randconfig-002-20260513    gcc-11.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260513    gcc-12
x86_64      buildonly-randconfig-002-20260513    gcc-12
x86_64      buildonly-randconfig-003-20260513    gcc-12
x86_64      buildonly-randconfig-004-20260513    gcc-12
x86_64      buildonly-randconfig-005-20260513    gcc-12
x86_64      buildonly-randconfig-006-20260513    gcc-12
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260513    clang-20
x86_64                randconfig-001-20260513    gcc-13
x86_64                randconfig-002-20260513    clang-20
x86_64                randconfig-002-20260513    gcc-14
x86_64                randconfig-003-20260513    clang-20
x86_64                randconfig-004-20260513    clang-20
x86_64                randconfig-005-20260513    clang-20
x86_64                randconfig-006-20260513    clang-20
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260513    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260513    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260513    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260513    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260513    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260513    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260513    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260513    gcc-12
x86_64                randconfig-072-20260513    gcc-14
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260513    gcc-12
x86_64                randconfig-073-20260513    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260513    gcc-14
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260513    gcc-14
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260513    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260513    gcc-11.5.0
xtensa                randconfig-001-20260513    gcc-8.5.0
xtensa                randconfig-002-20260513    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

