Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4913E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168B46B0088; Wed, 18 Feb 2026 21:35:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116FA6B0089; Wed, 18 Feb 2026 21:35:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015C96B008A; Wed, 18 Feb 2026 21:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBA316B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:35:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8519EC174B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:35:23 +0000 (UTC)
X-FDA: 84459639726.07.FC54EF6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF05F160002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:35:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hWLWLrje;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771468521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=dHIH0ifIJWryWimIIm4FdZVbiDXUV3WtYKQUjzcZdvo=;
	b=dLn+Ix9dc745HEkZ4httjgHKzEj6dMXnmrjGq5qcpQJC+IgQyiy34C56Y5rQFe68KN0XQf
	Bri6pzjYp4yjIkrMNERi662Nt8tz2yTQvBAQalI7muykVOlRZKkhMJeeRLF0E1Txv1gV2o
	PJv79BIrIDQojHojdlmw+x6jxgT4MAg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hWLWLrje;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771468521; a=rsa-sha256;
	cv=none;
	b=sD86dLNcFas6HBHU/P1trEB8oBrgAKhRoU7HH/H4d38SWTrkOwZhWfxOssBBqfwV0jcOsy
	EokaC9mKM/Lkvz00Lb2O2N2sZaeXQJqGJZnry+XMG0oxkWg0CZnjPgi58fOK15Yu3/DtNQ
	cxkVQdJCLOXAAfdDgwq/YmFjYVjZuRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771468521; x=1803004521;
  h=date:from:to:cc:subject:message-id;
  bh=z2NpEhmuRU41Y6/CLtAUIxTr7b3Xrm6PhIhkVfXeq3U=;
  b=hWLWLrjeUrdoh6HXruCpP3K4zxC2XvPfV5bQ0SdrJV9vMDnFIjDzNIql
   xwmxa+291aVlrpmjZT0tnvZJszeeA3zaUOYv0xXHXGiIlCzSMf1Wbqt0m
   jpegG1DZwziIpQTxghL5h5r1sI6srZFvnDenyLfQygp9I9vFojIKMRQhG
   cS4Oa5lCNTgHsS9l+WBzcgsVWEuYm800Brrix1VDMSTG5Z7iqyzKs2GTX
   TfqmCVqSO3rK9eKXEPgWhOUrOvG8JFx6TSCGoJOogI36V8/OhjsHY4Z2c
   vjWgFTYZZI73YJNrPqjJA6eHzCW0n2LE1UK29xq46M00rujCVZ3LZaDR8
   g==;
X-CSE-ConnectionGUID: qWoEX6IpTMCdFM0PnfY56g==
X-CSE-MsgGUID: 30EElx2wQda3UW/ik6n8dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="95173034"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="95173034"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 18:35:20 -0800
X-CSE-ConnectionGUID: gi9TmmOVQV+Jw4sAIj578g==
X-CSE-MsgGUID: 4DjGf9A5QJ6n5aUdvLUV+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="214489463"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 18 Feb 2026 18:35:18 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vstsp-000000012u4-1rhw;
	Thu, 19 Feb 2026 02:35:15 +0000
Date: Thu, 19 Feb 2026 10:35:09 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 50f68cc7be0a2cbf54d8f6aaf17df32fb01acc3f
Message-ID: <202602191000.v0LgootR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: sp5kdicm3pwdnuijw1876k4r1k4w4x13
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: BF05F160002
X-HE-Tag: 1771468520-844154
X-HE-Meta: U2FsdGVkX1+EVK5ltjFwlMkcK/K5I9nKSAxzemg/nAnvmdBZkcD98KwBuvJAChdBs6m4pePWLrNBRWPqEl6H4BZrDfJyurPlS4b0ksokXrUwMX5QXfIVPvgtolJF4kbhHhlV9n2CXLu5dqrNbea+5NmZTH1NeqpGsF4HDIal+PlHRiDgmzkDK5ArfESsUE5lxOq7VuiuPlpEMnubV1UaSfZqcCcjqqXk7e7nZTVfZUIEbRvBwPgkeqZ/meVh3J2cmREmHFimeAYkVqlPnBcUTTXFRh7y7NiyhTF7ibxf19IURMzzj5cn5tCayTZAcSTOuHZF3J6kwRw8Ek9iTF7KXphFFOZ23duvEq6YRIaZrXGZyEIfvah6RynTHom0OKWZTWEEanErbOXlXgbuKOV4N2oiyndnLzsCScFEa+eQce0BRdXXb7fAUEy7yFlqRBzyZHQZno8bEeyHuW3s7qqGQal5enbaxaA0rg+X2lrFbB8abOugwLMyE7daLdEEoLwuzlw8ZOoOZqfknkeJNnySAZ52GgfUxanaXphCKZ1ai31qPzbpyDlmcwdDq13QCilAN/+ng1L0VjIDt8ZPa76bR2hhJ6JKzzszfoz/whJEB15xtFxd0LFe3zqjV34n5KH6vEj7mjSjx5No3OpeThgZrVGcpccSriPAh9UCaWg9UeAYnFmfzZM2KZNF8E369pWfcqKXRuDcK+kyXrqMujHJLDZu7Gj4MWf8b7a/Hq0U2saR9dSnDrPo1URjHJ4XdNrNUboy7UBWEOEkMjJOWO3I4kH3lw0hezYtoSnzvk3oGvMvWph4MkEf+jHGIYH/EAaFPM7JASt9wR/yDzsGIMzM/VsOzKUPn7Dk/ogXzg38IIKT5BLz4eMro1iTlS/96OGw67JHmPxPC+1T96mLHx5HDbYOKkDSR1XctquENzPz4cTGG6OQ3LPmLJCRVyu4kjlz0yxpjb2IYZ54CVE2SR2
 +PwyMllm
 KxaIvMMAhvXeMvq0iOS+XGqBbxTwQKo9jZ4ly9cmNQ0hqKIIXoRQNG8HQDBvKL7OvUuBZGhAB4W+q9adU4hkJfFRwJ9u7XmG2rMeHoZjafdRy/d1bEAf8esfqb5UzDjbT0WVEA3s8rLATCSc6q9BVan6QcHr80n5U477f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 50f68cc7be0a2cbf54d8f6aaf17df32fb01acc3f  Add linux-next specific files for 20260218

elapsed time: 751m

configs tested: 274
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260218    gcc-9.5.0
arc                   randconfig-002-20260218    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                     davinci_all_defconfig    clang-23
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                            dove_defconfig    gcc-15.2.0
arm                            mps2_defconfig    clang-23
arm                        multi_v5_defconfig    gcc-15.2.0
arm                        neponset_defconfig    clang-23
arm                        neponset_defconfig    gcc-15.2.0
arm                             pxa_defconfig    gcc-15.2.0
arm                   randconfig-001-20260218    clang-23
arm                   randconfig-002-20260218    clang-23
arm                   randconfig-003-20260218    clang-23
arm                   randconfig-004-20260218    gcc-10.5.0
arm                           spitz_defconfig    gcc-15.2.0
arm                       versatile_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260218    gcc-8.5.0
arm64                 randconfig-001-20260219    gcc-8.5.0
arm64                 randconfig-002-20260218    clang-23
arm64                 randconfig-002-20260219    gcc-8.5.0
arm64                 randconfig-003-20260218    gcc-14.3.0
arm64                 randconfig-003-20260219    gcc-8.5.0
arm64                 randconfig-004-20260218    gcc-11.5.0
arm64                 randconfig-004-20260219    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260218    gcc-15.2.0
csky                  randconfig-001-20260219    gcc-8.5.0
csky                  randconfig-002-20260218    gcc-15.2.0
csky                  randconfig-002-20260219    gcc-8.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260218    clang-16
hexagon               randconfig-001-20260219    clang-17
hexagon               randconfig-002-20260218    clang-16
hexagon               randconfig-002-20260219    clang-17
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260219    gcc-14
i386        buildonly-randconfig-002-20260219    gcc-14
i386        buildonly-randconfig-003-20260219    gcc-14
i386        buildonly-randconfig-004-20260219    gcc-14
i386        buildonly-randconfig-005-20260219    clang-20
i386        buildonly-randconfig-005-20260219    gcc-14
i386        buildonly-randconfig-006-20260219    clang-20
i386        buildonly-randconfig-006-20260219    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260218    clang-20
i386                  randconfig-001-20260219    gcc-14
i386                  randconfig-002-20260218    gcc-14
i386                  randconfig-002-20260219    gcc-14
i386                  randconfig-003-20260218    gcc-14
i386                  randconfig-003-20260219    gcc-14
i386                  randconfig-004-20260218    gcc-13
i386                  randconfig-004-20260219    gcc-14
i386                  randconfig-005-20260218    clang-20
i386                  randconfig-005-20260219    gcc-14
i386                  randconfig-006-20260218    clang-20
i386                  randconfig-006-20260219    gcc-14
i386                  randconfig-007-20260218    gcc-14
i386                  randconfig-007-20260219    gcc-14
i386                  randconfig-011-20260219    clang-20
i386                  randconfig-011-20260219    gcc-14
i386                  randconfig-012-20260219    clang-20
i386                  randconfig-013-20260219    clang-20
i386                  randconfig-013-20260219    gcc-14
i386                  randconfig-014-20260219    clang-20
i386                  randconfig-014-20260219    gcc-13
i386                  randconfig-015-20260219    clang-20
i386                  randconfig-015-20260219    gcc-13
i386                  randconfig-016-20260219    clang-20
i386                  randconfig-016-20260219    gcc-14
i386                  randconfig-017-20260219    clang-20
i386                  randconfig-017-20260219    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260218    clang-23
loongarch             randconfig-001-20260219    clang-17
loongarch             randconfig-002-20260218    clang-23
loongarch             randconfig-002-20260219    clang-17
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                        mvme16x_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                  cavium_octeon_defconfig    clang-23
mips                           gcw0_defconfig    clang-23
mips                          malta_defconfig    clang-23
mips                   sb1250_swarm_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260218    gcc-11.5.0
nios2                 randconfig-001-20260219    clang-17
nios2                 randconfig-002-20260218    gcc-8.5.0
nios2                 randconfig-002-20260219    clang-17
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc         de0_nano_multicore_defconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                generic-32bit_defconfig    gcc-15.2.0
parisc                randconfig-001-20260218    gcc-8.5.0
parisc                randconfig-002-20260218    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                     akebono_defconfig    clang-23
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                  mpc885_ads_defconfig    gcc-15.2.0
powerpc                     ppa8548_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260218    clang-23
powerpc               randconfig-002-20260218    gcc-8.5.0
powerpc64             randconfig-001-20260218    gcc-8.5.0
powerpc64             randconfig-002-20260218    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                    nommu_virt_defconfig    clang-23
riscv                 randconfig-001-20260218    clang-23
riscv                 randconfig-001-20260219    clang-17
riscv                 randconfig-002-20260218    clang-23
riscv                 randconfig-002-20260219    clang-17
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260218    clang-23
s390                  randconfig-001-20260219    clang-17
s390                  randconfig-002-20260218    clang-23
s390                  randconfig-002-20260219    clang-17
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          landisk_defconfig    gcc-15.2.0
sh                    randconfig-001-20260218    gcc-15.2.0
sh                    randconfig-001-20260219    clang-17
sh                    randconfig-002-20260218    gcc-13.4.0
sh                    randconfig-002-20260219    clang-17
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260218    gcc-14.3.0
sparc                 randconfig-002-20260218    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260218    gcc-11.5.0
sparc64               randconfig-002-20260218    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260218    clang-23
um                    randconfig-002-20260218    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
um                           x86_64_defconfig    gcc-15.2.0
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260218    gcc-14
x86_64      buildonly-randconfig-001-20260219    gcc-14
x86_64      buildonly-randconfig-002-20260218    clang-20
x86_64      buildonly-randconfig-002-20260219    gcc-12
x86_64      buildonly-randconfig-003-20260218    clang-20
x86_64      buildonly-randconfig-003-20260219    clang-20
x86_64      buildonly-randconfig-004-20260218    gcc-14
x86_64      buildonly-randconfig-004-20260219    gcc-14
x86_64      buildonly-randconfig-005-20260218    gcc-14
x86_64      buildonly-randconfig-005-20260219    gcc-14
x86_64      buildonly-randconfig-006-20260218    clang-20
x86_64      buildonly-randconfig-006-20260219    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260218    clang-20
x86_64                randconfig-001-20260219    clang-20
x86_64                randconfig-002-20260218    clang-20
x86_64                randconfig-002-20260219    clang-20
x86_64                randconfig-003-20260218    gcc-14
x86_64                randconfig-003-20260219    clang-20
x86_64                randconfig-004-20260218    clang-20
x86_64                randconfig-004-20260219    clang-20
x86_64                randconfig-005-20260218    gcc-14
x86_64                randconfig-005-20260219    clang-20
x86_64                randconfig-006-20260218    clang-20
x86_64                randconfig-006-20260219    clang-20
x86_64                randconfig-011-20260218    clang-20
x86_64                randconfig-011-20260219    gcc-14
x86_64                randconfig-012-20260218    gcc-13
x86_64                randconfig-012-20260219    gcc-14
x86_64                randconfig-013-20260218    gcc-14
x86_64                randconfig-013-20260219    gcc-14
x86_64                randconfig-014-20260218    clang-20
x86_64                randconfig-014-20260219    gcc-14
x86_64                randconfig-015-20260218    gcc-13
x86_64                randconfig-015-20260219    gcc-14
x86_64                randconfig-016-20260218    gcc-14
x86_64                randconfig-016-20260219    gcc-14
x86_64                randconfig-071-20260218    clang-20
x86_64                randconfig-071-20260219    gcc-14
x86_64                randconfig-072-20260218    clang-20
x86_64                randconfig-072-20260219    gcc-14
x86_64                randconfig-073-20260218    clang-20
x86_64                randconfig-073-20260219    gcc-14
x86_64                randconfig-074-20260218    clang-20
x86_64                randconfig-074-20260219    gcc-14
x86_64                randconfig-075-20260218    clang-20
x86_64                randconfig-075-20260219    gcc-14
x86_64                randconfig-076-20260218    gcc-14
x86_64                randconfig-076-20260219    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260218    gcc-9.5.0
xtensa                randconfig-002-20260218    gcc-10.5.0
xtensa                    xip_kc705_defconfig    clang-23

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

