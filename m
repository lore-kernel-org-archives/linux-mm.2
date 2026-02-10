Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF5FEA3F0D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 07:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9476B0005; Tue, 10 Feb 2026 02:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D609C6B0088; Tue, 10 Feb 2026 02:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C423B6B0089; Tue, 10 Feb 2026 02:17:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B42DD6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:17:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D886B91E2
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:17:34 +0000 (UTC)
X-FDA: 84427691628.19.120531B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1875780002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:17:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="FXYQY+m/";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770707852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/W9c6UPOMRlHH3whdfKrfMw7s7KGCWWqdDSAE+NmIvQ=;
	b=Hbuw+elV6lxZjCy02V7bkhDHfGU3m8udFVxwEXEgOdOz3+rgslhAWbY5mCsDXfhYYYiTj4
	/cnZ1gaYpX7ghEi8St+tU3imMFjcxPoZa4Ye3y5HbYf683HDyNLZ65FEVNINXmcCj7hJbh
	JsU1sjUUhtCRjYKtBO+Bshi9zoVmi2A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="FXYQY+m/";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770707852; a=rsa-sha256;
	cv=none;
	b=bPs43IMj6n34nB6nC0xHBWca4SQYE3XMhKL9fAQai0nLG0DTkxZfBLyOXloW4SoXJ4Wb1s
	sb7fKDezLLL2zsWDz4vIlVxyh0R49srMCm5v9AiZ/hIGHQ5QhK3xnXpA0nOcLjBIT56hLB
	u71Lku4c4AKZFK/J1eM9khvVzx1bxz8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770707852; x=1802243852;
  h=date:from:to:cc:subject:message-id;
  bh=OUG08DwsMkFCov5m2UgXEOegQ++fEq84PGHDkNrgDh8=;
  b=FXYQY+m/MeonPXTQmyeUdTig1pkcOEV1rc1155ZUqr4L02MeHJ61cD0r
   r98R7zpav4vO3SuHctUihc6q5CuovYMrbL04a1aAh02cJSVY7QUR0NF0e
   KqD+ZG0ciTfPWakm04ybr+SOerz4sBPg7osvc0T50k1eKuuub9mRr3jmR
   D9+Mq+KVtWtCmJxIlyP64S303JLLyxmq7/UxNgdFV4Y+EuE2A2V8RTPZW
   1ekiKrz3MtQ4YLsQ+HJ67dUR0x5dfBpalw5cJuxAwC4jg7sZ2BsyfW/Hq
   RIsHvMwH7+jQZb6zhv3JBkBNsAQOJ9sa+pi8CEmKVdyDDKqnZ4iQNVKXz
   Q==;
X-CSE-ConnectionGUID: dTMQosKXR2GGap4mbjmXVQ==
X-CSE-MsgGUID: Jsd2/8hTTpmqpBcEwybXoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71871246"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71871246"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:17:30 -0800
X-CSE-ConnectionGUID: /X8BbIfuQTiH0JoUnN0GkQ==
X-CSE-MsgGUID: iLcilY+FQU2QZcwV4Z9XWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216192207"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Feb 2026 23:17:28 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vphzx-00000000olA-37m2;
	Tue, 10 Feb 2026 07:17:25 +0000
Date: Tue, 10 Feb 2026 15:16:41 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 132737e360b4c0daa7f473faf0f55cb04ee3e15c
Message-ID: <202602101530.dBz4MefP-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1875780002
X-Stat-Signature: dtepwnmuwtxtyzbf8671hyfhdbikpwyu
X-Rspam-User: 
X-HE-Tag: 1770707850-87907
X-HE-Meta: U2FsdGVkX1/5xaDt9oKsIsizV81vEtjAaY4kra62wBW9WvXHap2lMdgHPuveDXSDFA7MDmGoiWLSwb/WxSxTGlLzNFtdQLvUVX2aC/MRiR8tBXwbvWtJVzhZLS3ZISxvSnKa8LlrA03pxE7Zj6QahsmcQbwM1m3jpf4pqq26CT/aoI5MPVid/oNeNBETb4tlkQivlQulXKq435Ut82u3JFc68TKOP/2RQcPPYjwZYreUsI35l7Qx4BAqH8F1ElWdqS5zkjgPTvF+kxGL2bQHZF84YX2OxXKyfImJHC8YeHhEJ0Mafm+6LojLdAS7zGxhdIUBUr9n1GymWRU5BMuOAJIaVK+vsRAAJK4zILxCZhK4PepGysRCkTVEbpgrSo0yZYDdiuCf6u3CONPfouUK0s28gWRDyrCzQ52dCFrYBhuMrDLO0R8x4wVR5EKaTp3JDgsqqILuf453ijNAzGSnqqxTlSPwQhN9svPPCMxq2ZpWhMW4j+B96TelzOJsTieMPCvPD1juqIR5kEE33XLALWR73IuEXIM2OaQLcVygMxoq7Ij6sUwJ1N8RVMFAloeFyt9fRmpMg653jdESiRFeqOYrAByX6z/xhmUjg5WlMXmoR13C6epABE+dA+uHjJFtUl6OonrmlAlK2AP90/m1prvn3V2cO/WURhSZT7x4B7NOib4p+RdvgMUlXZXOUW7786RXomFHIHp40UXUYY2Y1EHcaL5KUQRXFoJUAT8cThjA7hRg1Vb7w9r4W6abXCnHIzHb/STk+OzCpyNEqaUxwUKR5/syln60FzcGWzFMWk0CZFLwfF+XsQxoo/7jtgncWSruGtaey6AHWmJjXTBtIKnxuCxMGiY9SMqr54s79CbUJ2xkF9+nGIpoRLgkz5lw0P37SGpzvEXrqZfAW0cDwSjP/wpF+ruWkEArTZC6bkdlyvy8KSX1GjL8YoR5ZB8RUf8qeb+SFAgoIC65iFT
 MqpuDlFK
 GiiINfTLNviy5sWlMVZm4a9u2f7yoGWrG/qw/4Z1eSOkjxLVQmde0SLcSzah0OATeonBjmINnkQ9N4XbfHvnEqUAK253k1kZKglordkjRNcxJGyuV7wzi1Eiym3a281wKAKY8MubOHZw303MVaW6+exAl58HrL2/GykXb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 132737e360b4c0daa7f473faf0f55cb04ee3e15c  Add linux-next specific files for 20260209

Unverified Warning (likely false positive, kindly check if interested):

    drivers/of/unittest.c:1701 of_unittest_parse_interrupt_map() warn: bitwise AND condition is false here

Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r123-20260209
|   `-- mm-bpf_memcontrol.c:sparse:sparse:symbol-bpf_mem_cgroup_memory_events-was-not-declared.-Should-it-be-static
`-- riscv-randconfig-r072-20260209
    `-- drivers-of-unittest.c-of_unittest_parse_interrupt_map()-warn:bitwise-AND-condition-is-false-here

elapsed time: 828m

configs tested: 262
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
arc                        nsimosci_defconfig    gcc-15.2.0
arc                   randconfig-001-20260210    clang-20
arc                   randconfig-001-20260210    gcc-14.3.0
arc                   randconfig-002-20260210    clang-20
arc                   randconfig-002-20260210    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                       imx_v4_v5_defconfig    gcc-15.2.0
arm                          pxa168_defconfig    clang-22
arm                            qcom_defconfig    clang-22
arm                   randconfig-001-20260210    clang-19
arm                   randconfig-001-20260210    clang-20
arm                   randconfig-002-20260210    clang-20
arm                   randconfig-003-20260210    clang-20
arm                   randconfig-003-20260210    clang-22
arm                   randconfig-004-20260210    clang-20
arm                   randconfig-004-20260210    clang-22
arm                           sama5_defconfig    clang-22
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260210    clang-22
arm64                 randconfig-002-20260210    clang-22
arm64                 randconfig-003-20260210    clang-22
arm64                 randconfig-004-20260210    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260210    clang-22
csky                  randconfig-001-20260210    gcc-14.3.0
csky                  randconfig-002-20260210    clang-22
csky                  randconfig-002-20260210    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260210    clang-22
hexagon               randconfig-002-20260210    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260210    clang-20
i386        buildonly-randconfig-002-20260210    clang-20
i386        buildonly-randconfig-002-20260210    gcc-14
i386        buildonly-randconfig-003-20260210    clang-20
i386        buildonly-randconfig-003-20260210    gcc-14
i386        buildonly-randconfig-004-20260210    clang-20
i386        buildonly-randconfig-005-20260210    clang-20
i386        buildonly-randconfig-006-20260210    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260210    gcc-14
i386                  randconfig-002-20260210    gcc-14
i386                  randconfig-003-20260210    clang-20
i386                  randconfig-003-20260210    gcc-14
i386                  randconfig-004-20260210    gcc-14
i386                  randconfig-005-20260210    gcc-13
i386                  randconfig-005-20260210    gcc-14
i386                  randconfig-006-20260210    gcc-13
i386                  randconfig-006-20260210    gcc-14
i386                  randconfig-007-20260210    clang-20
i386                  randconfig-007-20260210    gcc-14
i386                  randconfig-011-20260210    gcc-14
i386                  randconfig-012-20260210    gcc-14
i386                  randconfig-013-20260210    clang-20
i386                  randconfig-013-20260210    gcc-14
i386                  randconfig-014-20260210    gcc-14
i386                  randconfig-015-20260210    gcc-14
i386                  randconfig-016-20260210    gcc-14
i386                  randconfig-017-20260210    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260210    clang-18
loongarch             randconfig-002-20260210    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                          atari_defconfig    clang-22
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          ath79_defconfig    gcc-15.2.0
mips                     cu1000-neo_defconfig    gcc-15.2.0
mips                          eyeq6_defconfig    clang-22
mips                           ip30_defconfig    clang-22
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260210    gcc-11.5.0
nios2                 randconfig-002-20260210    gcc-11.5.0
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
parisc                randconfig-001-20260210    clang-19
parisc                randconfig-001-20260210    gcc-14.3.0
parisc                randconfig-002-20260210    clang-19
parisc                randconfig-002-20260210    gcc-12.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                  iss476-smp_defconfig    clang-22
powerpc                     kmeter1_defconfig    gcc-15.2.0
powerpc                     ksi8560_defconfig    gcc-15.2.0
powerpc                 mpc832x_rdb_defconfig    gcc-15.2.0
powerpc                  mpc885_ads_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260210    clang-19
powerpc               randconfig-001-20260210    clang-22
powerpc               randconfig-002-20260210    clang-19
powerpc                     tqm8555_defconfig    gcc-15.2.0
powerpc                        warp_defconfig    clang-22
powerpc64             randconfig-001-20260210    clang-19
powerpc64             randconfig-001-20260210    clang-22
powerpc64             randconfig-002-20260210    clang-18
powerpc64             randconfig-002-20260210    clang-19
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260210    gcc-10.5.0
riscv                 randconfig-001-20260210    gcc-11.5.0
riscv                 randconfig-002-20260210    gcc-11.5.0
riscv                 randconfig-002-20260210    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260210    gcc-11.5.0
s390                  randconfig-002-20260210    clang-22
s390                  randconfig-002-20260210    gcc-11.5.0
sh                               alldefconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                             espt_defconfig    gcc-15.2.0
sh                    randconfig-001-20260210    gcc-11.5.0
sh                    randconfig-001-20260210    gcc-14.3.0
sh                    randconfig-002-20260210    gcc-11.5.0
sh                    randconfig-002-20260210    gcc-15.2.0
sh                          rsk7203_defconfig    gcc-15.2.0
sh                           se7750_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260210    gcc-14.3.0
sparc                 randconfig-001-20260210    gcc-15.2.0
sparc                 randconfig-002-20260210    gcc-14.3.0
sparc                 randconfig-002-20260210    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260210    gcc-11.5.0
sparc64               randconfig-001-20260210    gcc-14.3.0
sparc64               randconfig-002-20260210    clang-22
sparc64               randconfig-002-20260210    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260210    clang-19
um                    randconfig-001-20260210    gcc-14.3.0
um                    randconfig-002-20260210    gcc-14
um                    randconfig-002-20260210    gcc-14.3.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260210    clang-20
x86_64      buildonly-randconfig-001-20260210    gcc-14
x86_64      buildonly-randconfig-002-20260210    clang-20
x86_64      buildonly-randconfig-002-20260210    gcc-14
x86_64      buildonly-randconfig-003-20260210    clang-20
x86_64      buildonly-randconfig-003-20260210    gcc-14
x86_64      buildonly-randconfig-004-20260210    gcc-14
x86_64      buildonly-randconfig-005-20260210    clang-20
x86_64      buildonly-randconfig-005-20260210    gcc-14
x86_64      buildonly-randconfig-006-20260210    clang-20
x86_64      buildonly-randconfig-006-20260210    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260210    clang-20
x86_64                randconfig-001-20260210    gcc-14
x86_64                randconfig-002-20260210    clang-20
x86_64                randconfig-002-20260210    gcc-14
x86_64                randconfig-003-20260210    clang-20
x86_64                randconfig-003-20260210    gcc-14
x86_64                randconfig-004-20260210    gcc-14
x86_64                randconfig-005-20260210    gcc-14
x86_64                randconfig-006-20260210    gcc-12
x86_64                randconfig-006-20260210    gcc-14
x86_64                randconfig-071-20260210    clang-20
x86_64                randconfig-071-20260210    gcc-14
x86_64                randconfig-072-20260210    clang-20
x86_64                randconfig-073-20260210    clang-20
x86_64                randconfig-073-20260210    gcc-14
x86_64                randconfig-074-20260210    clang-20
x86_64                randconfig-075-20260210    clang-20
x86_64                randconfig-075-20260210    gcc-14
x86_64                randconfig-076-20260210    clang-20
x86_64                randconfig-076-20260210    gcc-14
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
xtensa                  cadence_csp_defconfig    clang-22
xtensa                randconfig-001-20260210    gcc-14.3.0
xtensa                randconfig-001-20260210    gcc-8.5.0
xtensa                randconfig-002-20260210    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

