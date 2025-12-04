Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246AED1F9BD
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541C56B0022; Thu,  4 Dec 2025 06:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2A16B0023; Thu,  4 Dec 2025 06:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2916B0029; Thu,  4 Dec 2025 06:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 289936B0022
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:29:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D75481608D7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:29:09 +0000 (UTC)
X-FDA: 84181567218.22.D3081F2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EB7B4000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:29:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a75LgM0S;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764847748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=U1K6dUvfI+c2np3STH/9fDN3rTHD95VECQ478dnHyHM=;
	b=H8RAfyQrofWlBwNAoPwGRNYC+1MH5WrpR5c03F8/lO/YXOgcN0HrndAXvYO3r2leK/3CD6
	iNsijkxMziSPv6RCF+ECaDpCFL80l4GnX1B/K7H91JFpxw9joqY08MpFuZcYpSe5xDrhbT
	bz3MiCQ/zjiBYAHR6wyg0uFb2szrFFk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a75LgM0S;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764847748; a=rsa-sha256;
	cv=none;
	b=qi3Yn4d+3WWK9Jf+V7PtFhOPk8osl/rtZAEuZANY2sNyfelkOFZTOZaszrjoNA8h0DOUc+
	3a3Z3KEKvjmh1yQ8lhYotF2rU2HfBRuTNX2giLDspFFmQyve5myTgjock41/WeukgVCy8C
	MRVE/t2UOlhtQVqETV78RGE+TwJLQJI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764847747; x=1796383747;
  h=date:from:to:cc:subject:message-id;
  bh=YFFFBnrYba0TDpqDr/3eEkesUeD5uy/Dr5CZkOCvaj4=;
  b=a75LgM0SGbZm4S98DG8lulUwF7m0bZka1KRu3TPgVebnx5HRpehQMT/x
   ANfzHYODAgcjQlzguKEBGQJsJ3XHFqldXNLM1sUH/cJ/Zcyp1o2MDcMzT
   dZB5zxI482vmVEsH3AR37Dir0C7XCPcVHzqmR4Nh/6q9YLcQkGyuiC8fy
   vOlARC7ooHFP2W/9y9w9cNOWUfHxAOMlf68ocn9qk+5aSzs3fcg5jXUxM
   +uX8H/KAVlXDzi4x/72QQ13XiCsVx9rmThnOFJCa5PmaWjg7OCp5Im7U+
   brVjkG8aS59iX8FBf7XNz84islOHT6HJKSIyLSjkXKC+vQJPROg7KJtmG
   g==;
X-CSE-ConnectionGUID: yb+rGqf0QHOpqTNgXA0vrA==
X-CSE-MsgGUID: 9i23WJdHShqgnPskcMjU2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66749339"
X-IronPort-AV: E=Sophos;i="6.20,248,1758610800"; 
   d="scan'208";a="66749339"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 03:29:05 -0800
X-CSE-ConnectionGUID: wVMWhK9+S4ia+Xbk7ouZ8g==
X-CSE-MsgGUID: zztyWEetTgy/RtBypVe6Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,248,1758610800"; 
   d="scan'208";a="195771722"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 04 Dec 2025 03:29:04 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vR7W9-00000000DkS-33Dr;
	Thu, 04 Dec 2025 11:29:01 +0000
Date: Thu, 04 Dec 2025 19:28:16 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 6e2c87bd333385cb249e93a83b7e0b7abce1a547
Message-ID: <202512041910.92w2Yy3E-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 9EB7B4000E
X-Rspamd-Server: rspam02
X-Stat-Signature: pud4p7dgwt6bodw4nodqaqex9taknxzc
X-Rspam-User: 
X-HE-Tag: 1764847746-140260
X-HE-Meta: U2FsdGVkX18z4tRP4QpO3+SsZZZYdkIEgGYiEF1BLNzFF48NlAdw3QwZdgaxbBNlR7tpZG3wt0L3Y1ApHcxAx63FqgMIIf79t3hngxtZcxe0go6al8Ru6f0JkMNSfDQY2Yj/Is3J9XeOnYxMlqcspOpfn4bImajBFEyKALWbxjwT3znkuA6ZATfmJrLfwngoKIToVPUeP6ksJgvjLHc9AhJDkYbYGZJhVfRPMguOV1EAKiOLDAnCyrPHma7rQSlaE/N1ImsK01rmkBv98JM41IxTSjwzdT9J7bY4yXVw7oT3YW426EOFSWR+sUVLBx/TwCH3WPDQt9vZB5xbjupmhlSTiQSLwNoJIZtFiIWNOpQHY1Ted+ue3s8fIdLKE77WRmeTeVbMhZV0MGBrCUPYVZ55tNh91hjZ+J/Ww8YGdiZmcZtLCGUhMxTgB0zwxoo+QZh117Lmsc5cHZ/hrYa0K4DwhCeSBGhNjCkUPUJoehG0HhXnE8YPDNuQlBFEij1K1JRqTcVLEroPJTBaJlnEvj4ZQo0q1xtwNgStdpnYLWnQlL7irkeUdhNOtjP4uyc430J9HHwR2O5PlPQ7KwVbAlu1OxbArPyPCqQhnTg/ySmQl814HqZx1iicMCt05CeRp40PKA+IGRYMY0egZOgBJ7vFKCZ2kZ2RYGn9dW3F3GLbSWIYVvRuVqiPXmuUzN8SE5sY8DRiSV1TkOGM1Mf4gT/xed8GWwTKtJJ0dgTep3XR99adX+N8BkeWD/mzBrYjUl44OYUA81SYCIeHO2bUI+tiaT9L61kiTwsDNyouYHZY6/g8wYRqWnMKYi+Ew1PxN6XADfkzoiRTaZgagisdAIRlm5ul96Ta5wTYY8RAF/4xxTlTID0Jnce9nWqYaeHGFunx2uSbNVvKmvAMyKV827zTcsW53HlTc+r4CB62J6eaC/77b/vsHYW5QqxGZs6e7RjTsPu4mJMpm4vNU7F
 UUdGbXns
 yXYihyx2yKL07UQamRQlERaPFQK2WkO3c+LObyYt8MVXRm2PUS6PySS5ySoPp9RxtJwLTun0CXc2ke+qCxVvZx0AFqbqTVi7ntUD+8tov7Wsjvj7kmwJCZwDigv715g/onVTOmw0Y/7yj+oHgfLhlXs8aQQuHXqcqAhHv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 6e2c87bd333385cb249e93a83b7e0b7abce1a547  mm/mm_init: Introduce a boot parameter for check_pages

elapsed time: 1456m

configs tested: 204
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-22
arc                          axs103_defconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251204    gcc-10.5.0
arc                   randconfig-002-20251204    gcc-10.5.0
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    gcc-15.1.0
arm                          ixp4xx_defconfig    gcc-15.1.0
arm                        multi_v5_defconfig    gcc-15.1.0
arm                        mvebu_v5_defconfig    gcc-15.1.0
arm                         orion5x_defconfig    gcc-15.1.0
arm                          pxa3xx_defconfig    clang-22
arm                   randconfig-001-20251204    gcc-10.5.0
arm                   randconfig-002-20251204    gcc-10.5.0
arm                   randconfig-003-20251204    gcc-10.5.0
arm                   randconfig-004-20251204    gcc-10.5.0
arm                           stm32_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251204    gcc-14.3.0
arm64                 randconfig-002-20251204    gcc-14.3.0
arm64                 randconfig-003-20251204    gcc-14.3.0
arm64                 randconfig-004-20251204    gcc-14.3.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251204    gcc-14.3.0
csky                  randconfig-002-20251204    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251204    gcc-15.1.0
hexagon               randconfig-002-20251204    gcc-15.1.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251204    clang-20
i386                  randconfig-002-20251204    clang-20
i386                  randconfig-003-20251204    clang-20
i386                  randconfig-004-20251204    clang-20
i386                  randconfig-005-20251204    clang-20
i386                  randconfig-006-20251204    clang-20
i386                  randconfig-007-20251204    clang-20
i386                  randconfig-011-20251204    gcc-14
i386                  randconfig-012-20251204    gcc-14
i386                  randconfig-013-20251204    gcc-14
i386                  randconfig-014-20251204    gcc-14
i386                  randconfig-015-20251204    gcc-14
i386                  randconfig-016-20251204    gcc-14
i386                  randconfig-017-20251204    gcc-14
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251204    gcc-15.1.0
loongarch             randconfig-002-20251204    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                           sun3_defconfig    clang-22
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                      bmips_stb_defconfig    clang-22
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20251204    gcc-15.1.0
nios2                 randconfig-002-20251204    gcc-15.1.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           alldefconfig    clang-22
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251204    clang-22
parisc                randconfig-002-20251204    clang-22
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                      chrp32_defconfig    clang-22
powerpc                     mpc83xx_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251204    clang-22
powerpc               randconfig-002-20251204    clang-22
powerpc                     tqm8548_defconfig    gcc-15.1.0
powerpc                      tqm8xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251204    clang-22
powerpc64             randconfig-002-20251204    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251204    clang-22
riscv                 randconfig-002-20251204    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251204    clang-22
s390                  randconfig-002-20251204    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                ecovec24-romimage_defconfig    clang-22
sh                            hp6xx_defconfig    clang-22
sh                    randconfig-001-20251204    clang-22
sh                    randconfig-002-20251204    clang-22
sh                          rsk7201_defconfig    gcc-15.1.0
sh                   rts7751r2dplus_defconfig    gcc-15.1.0
sh                          sdk7786_defconfig    gcc-15.1.0
sh                           se7712_defconfig    gcc-15.1.0
sh                   sh7770_generic_defconfig    clang-22
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251204    clang-22
sparc                 randconfig-002-20251204    clang-22
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251204    clang-22
sparc64               randconfig-002-20251204    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251204    clang-22
um                    randconfig-002-20251204    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251204    clang-20
x86_64      buildonly-randconfig-002-20251204    clang-20
x86_64      buildonly-randconfig-003-20251204    clang-20
x86_64      buildonly-randconfig-004-20251204    clang-20
x86_64      buildonly-randconfig-005-20251204    clang-20
x86_64      buildonly-randconfig-006-20251204    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251204    clang-20
x86_64                randconfig-002-20251204    clang-20
x86_64                randconfig-003-20251204    clang-20
x86_64                randconfig-004-20251204    clang-20
x86_64                randconfig-005-20251204    clang-20
x86_64                randconfig-006-20251204    clang-20
x86_64                randconfig-011-20251204    clang-20
x86_64                randconfig-012-20251204    clang-20
x86_64                randconfig-013-20251204    clang-20
x86_64                randconfig-014-20251204    clang-20
x86_64                randconfig-015-20251204    clang-20
x86_64                randconfig-016-20251204    clang-20
x86_64                randconfig-071-20251204    clang-20
x86_64                randconfig-072-20251204    clang-20
x86_64                randconfig-073-20251204    clang-20
x86_64                randconfig-074-20251204    clang-20
x86_64                randconfig-075-20251204    clang-20
x86_64                randconfig-076-20251204    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251204    clang-22
xtensa                randconfig-002-20251204    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

