Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493F5CD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 01:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3466B0088; Wed,  6 May 2026 21:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653C36B008A; Wed,  6 May 2026 21:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590F16B008C; Wed,  6 May 2026 21:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 483546B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 21:59:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 799E4C192F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 01:59:53 +0000 (UTC)
X-FDA: 84738967866.26.5DFF6D5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id D86ED180007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 01:59:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABXp4+m+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778119191; a=rsa-sha256;
	cv=none;
	b=AjX40p/f3o0NNyUKThEnB9ikAIa8n3jkDgg/xyLj1raq/Zy1p4yELyMWK/P3uWytYik92j
	13StnOHqFKRmfLGkCxQZ8dsS6x3U+9rVacJkwBtH4mam2HoPDMRwx1UdmCOTEWxiHaFqSK
	bdVPZxkZlwmRPBak2cc8tY5gnMEStck=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABXp4+m+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778119191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/kHfRg4n1yPc/eTgKebfNV1D0UXa7YO9Fm8a2aVpa1Q=;
	b=5Tw3wP9ijhnHp+kwvPu0A1iwkFqnbOzpJdehtD1nei/Q+DPT5gkySLzGfFFpMA1anMkxet
	PYPkWIkYACjw6EInL4R0lFjcbysyWuU5kWBoHjRm6mSEUlYSVi6aW+vWS+hEU63pOS+QCl
	T9Wb0Mq9S0s7ce973enztPHGc85YcZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778119191; x=1809655191;
  h=date:from:to:cc:subject:message-id;
  bh=9R6Ye33gcR0zMH4A+14HWASjDLlNvZMHPP16kmr7eCs=;
  b=ABXp4+m+0eSXefCCkUh741opDySDTL9HVHTRk+LnuMf6jt2+ZJt1K5QY
   f6yg370d8/pCBmM4GhUHFRj63kq3Y8PW2rKpt0BhD1r2KDN0BxYpPaQY/
   28UnMQ2csAh/woWKaJosbu/SK1CJxDEAK1lgUfA9cxIcBOf48TyvKkD3+
   Gitu9wr/QScNtqv9TIO8k7uv2B0MX7q6E1wrLkPMFeiwXopOdUkHvAHv6
   oZnu1Pk+8DVAd0A1sBBNoT+lvFMakL0c+O8wP1vEkIxULBxNcfpMVViYq
   ykzpNx686IeFvIPILs32gzGlmSSFLbZiuq2euRtUzCGXq+f/VderCqwK8
   w==;
X-CSE-ConnectionGUID: 1th3+OzUQ+SpmyTTXQBpqA==
X-CSE-MsgGUID: fkNhd9wzRr2HmUhVHF8HOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="78911844"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="78911844"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 18:59:49 -0700
X-CSE-ConnectionGUID: hIr+1srqSjautPAY5PNVVA==
X-CSE-MsgGUID: 4XgNQ47cQ7u9KOmHqDYP2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="236432447"
Received: from lkp-server01.sh.intel.com (HELO 9ec114424ce8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 06 May 2026 18:59:47 -0700
Received: from kbuild by 9ec114424ce8 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wKo1g-000000001QD-0CGB;
	Thu, 07 May 2026 01:59:44 +0000
Date: Thu, 07 May 2026 09:59:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 netdev@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: [linux-next:master] BUILD REGRESSION
 735d2f48cadaa9a87e7c7601667878de70c771c5
Message-ID: <202605070954.rAfjsCoD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 4g87gskkhjjc1xihed741dixi74g4wen
X-Rspam-User: 
X-Rspamd-Queue-Id: D86ED180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778119190-384721
X-HE-Meta: U2FsdGVkX18cGzFKrnzAbMUaA8TpNyeDDysQveDisJWu/g0NYie2f1kyyW22FI24n5VVWQc4EY4KSLJuZID9n6p+KoLXrxU/uNpZTvTUlBLUiUCe2uK6ShjRv06V14eoyG/i3Q1aOrvOVuK2wO86dlaNpbMKPvWILXxNJCZR1p/+QUSUBAxyCVsgSQWnjRJ+SCzGiNo3TaC0VHsfM7NYep3lTtnAOrLExGK5XxoewNAwMa798jfsAzsmbI0jcMesxeuZu8YPkFQTflwyI2wUqi07ih014wcHw8co3L7SvvpigaiGNBA4rNONd11R6aUAU4YfWwQUzUuWqV/8KBoJDfHi5HPOcDboNzUUHaxLIPnofPaWbjeqsF1seUgl1fD0C9hQIWKyE/6G3cEqbtgJ+GRjbd3KmscYfdz0iGg5znIHkd3RS08sXxm/uv2KecgV7Tp4D3i+X8Ztg6N7h9ysRsktHR3oX0VHNKmQTQBISn05hh6O96tGkaemHxK6I2pFxi+HzOUQsL1puRPIxOK6rhgw14yoImOo2kQ32V+qit3fl+tGI6dp1gXUNHyN8TvydzzNRXM0/4CkOF9HQfT7PkfQ8NUarGHhr2USMT1gQcmp1FBKrZPsI6Ew9pi9v/nGc6SBBNT0PtKHaZb4dI6OSRdT4d81DQH4wUAfWATF9n3ujhoJajPOwFoDNLYD6oq1A4hNGI4NsPFwpbmYPsEIc7qKvH3tctez7nkSfMWgnELpPIlGOFtNa+uX/N2usMmJSQ73u52sHP9FHAyNqX+LdoyzeiGSKhfTqM8NcjEHOcap0+TYeadw1dbevZFUbJFqK+/cH1BAu7FlcA1NdHphDDQ5fY24YqQLDvJO7h7AJ+maGkVxnRTPYl9O5Rf4mTj9od+SXn+iLu236XBBKEP6EsV++liAda1kaBuhIPzA8PAGbToolacn+5q2zIEVLidvCholhdWFJ+P9A3A9uA4
 9YN/xnOO
 w4NTYjmyvs+1q5Grvw1yVNK5ZnVFkd6fN6Aoy8y0WDMELcG8QZ+H/RdK7SwSXbBnNfy1cRML7q8Tc8A/9AKxpjjF0VErUNI/Y7Zy9YHrnmvGCCNMC+8SU4qyLuLUHiz5PpJkKiG50Ay7iZ51qAPNZUP87j7u2bZQp3QwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 735d2f48cadaa9a87e7c7601667878de70c771c5  Add linux-next specific files for 20260506

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: "__aarch64_ldadd8_relax" [kernel/trace/preemptirq_delay_test.ko] undefined!
    ERROR: modpost: "__aarch64_ldadd8_relax" [kernel/trace/synth_event_gen_test.ko] undefined!
    ERROR: modpost: "__sync_fetch_and_add_8" [io_uring/mock_file.ko] undefined!

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r121-20260505
|   |-- ERROR:__aarch64_ldadd8_relax-kernel-trace-preemptirq_delay_test.ko-undefined
|   `-- ERROR:__aarch64_ldadd8_relax-kernel-trace-synth_event_gen_test.ko-undefined
|-- hexagon-randconfig-r131-20260506
|   `-- drivers-net-bareudp.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-sock-sk-got-struct-sock-noderef-__rcu-sk
`-- parisc-randconfig-002-20260506
    `-- ERROR:__sync_fetch_and_add_8-io_uring-mock_file.ko-undefined

elapsed time: 725m

configs tested: 270
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260507    gcc-10.5.0
arc                   randconfig-001-20260507    gcc-14.3.0
arc                   randconfig-002-20260507    gcc-14.3.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260507    clang-23
arm                   randconfig-002-20260507    gcc-10.5.0
arm                   randconfig-002-20260507    gcc-14.3.0
arm                   randconfig-003-20260507    clang-23
arm                   randconfig-004-20260507    gcc-13.4.0
arm                   randconfig-004-20260507    gcc-14.3.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-8.5.0
arm64                 randconfig-001-20260506    gcc-8.5.0
arm64                 randconfig-001-20260507    gcc-15.2.0
arm64                          randconfig-002    gcc-14.3.0
arm64                 randconfig-002-20260506    gcc-8.5.0
arm64                 randconfig-002-20260507    gcc-15.2.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260506    gcc-11.5.0
arm64                 randconfig-003-20260507    gcc-15.2.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260506    clang-23
arm64                 randconfig-004-20260507    gcc-15.2.0
csky                             alldefconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260506    gcc-15.2.0
csky                  randconfig-001-20260507    gcc-15.2.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260506    gcc-15.2.0
csky                  randconfig-002-20260507    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260506    clang-23
hexagon               randconfig-002-20260506    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-20
i386        buildonly-randconfig-001-20260506    gcc-14
i386        buildonly-randconfig-001-20260507    clang-20
i386        buildonly-randconfig-001-20260507    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260506    gcc-14
i386        buildonly-randconfig-002-20260507    clang-20
i386        buildonly-randconfig-002-20260507    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260506    clang-20
i386        buildonly-randconfig-003-20260507    clang-20
i386        buildonly-randconfig-003-20260507    gcc-14
i386                 buildonly-randconfig-004    clang-20
i386        buildonly-randconfig-004-20260506    clang-20
i386        buildonly-randconfig-004-20260507    clang-20
i386        buildonly-randconfig-004-20260507    gcc-14
i386                 buildonly-randconfig-005    clang-20
i386        buildonly-randconfig-005-20260506    clang-20
i386        buildonly-randconfig-005-20260507    clang-20
i386                 buildonly-randconfig-006    clang-20
i386        buildonly-randconfig-006-20260506    gcc-14
i386        buildonly-randconfig-006-20260507    clang-20
i386        buildonly-randconfig-006-20260507    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260506    gcc-14
i386                  randconfig-002-20260506    gcc-14
i386                  randconfig-003-20260506    gcc-14
i386                  randconfig-004-20260506    clang-20
i386                  randconfig-005-20260506    gcc-14
i386                  randconfig-006-20260506    gcc-14
i386                  randconfig-007-20260506    clang-20
i386                  randconfig-011-20260507    clang-20
i386                  randconfig-011-20260507    gcc-14
i386                  randconfig-012-20260507    clang-20
i386                  randconfig-013-20260507    clang-20
i386                  randconfig-013-20260507    gcc-14
i386                  randconfig-014-20260507    clang-20
i386                  randconfig-014-20260507    gcc-14
i386                  randconfig-015-20260506    gcc-14
i386                  randconfig-015-20260507    clang-20
i386                  randconfig-016-20260507    clang-20
i386                  randconfig-016-20260507    gcc-14
i386                  randconfig-017-20260507    clang-20
i386                  randconfig-017-20260507    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260506    clang-18
loongarch             randconfig-002-20260506    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          hp300_defconfig    gcc-15.2.0
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
nios2                 randconfig-001-20260506    gcc-8.5.0
nios2                 randconfig-002-20260506    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260506    gcc-13.4.0
parisc                randconfig-002-20260506    gcc-10.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260506    gcc-10.5.0
powerpc               randconfig-002-20260506    gcc-8.5.0
powerpc64             randconfig-001-20260506    gcc-8.5.0
powerpc64             randconfig-002-20260506    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260507    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260507    gcc-13.4.0
s390                  randconfig-002-20260507    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260507    gcc-10.5.0
sh                    randconfig-002-20260507    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260506    gcc-15.2.0
sparc                 randconfig-002-20260506    gcc-11.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260506    clang-23
sparc64               randconfig-002-20260506    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260506    gcc-14
um                    randconfig-002-20260506    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260506    clang-20
x86_64      buildonly-randconfig-001-20260507    clang-20
x86_64      buildonly-randconfig-002-20260506    gcc-14
x86_64      buildonly-randconfig-002-20260507    clang-20
x86_64      buildonly-randconfig-003-20260506    clang-20
x86_64      buildonly-randconfig-003-20260507    clang-20
x86_64      buildonly-randconfig-004-20260506    clang-20
x86_64      buildonly-randconfig-004-20260507    clang-20
x86_64      buildonly-randconfig-005-20260506    gcc-12
x86_64      buildonly-randconfig-005-20260507    clang-20
x86_64      buildonly-randconfig-006-20260506    clang-20
x86_64      buildonly-randconfig-006-20260507    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260506    gcc-13
x86_64                randconfig-002-20260506    clang-20
x86_64                randconfig-003-20260506    clang-20
x86_64                randconfig-004-20260506    clang-20
x86_64                randconfig-005-20260506    gcc-14
x86_64                randconfig-006-20260506    clang-20
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260506    clang-20
x86_64                randconfig-011-20260507    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260506    clang-20
x86_64                randconfig-012-20260507    gcc-14
x86_64                         randconfig-013    clang-20
x86_64                randconfig-013-20260506    clang-20
x86_64                randconfig-013-20260507    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260506    clang-20
x86_64                randconfig-014-20260507    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260506    gcc-12
x86_64                randconfig-015-20260507    gcc-14
x86_64                         randconfig-016    clang-20
x86_64                randconfig-016-20260506    gcc-14
x86_64                randconfig-016-20260507    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260506    gcc-14
x86_64                randconfig-071-20260507    clang-20
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260506    gcc-14
x86_64                randconfig-072-20260507    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260506    gcc-14
x86_64                randconfig-073-20260507    clang-20
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260506    clang-20
x86_64                randconfig-074-20260507    clang-20
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260506    gcc-14
x86_64                randconfig-075-20260507    clang-20
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260506    clang-20
x86_64                randconfig-076-20260507    clang-20
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
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260506    gcc-15.2.0
xtensa                randconfig-002-20260506    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

