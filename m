Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED499606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DQENUZTM
Received: by kanga.kvack.org (Postfix)
	id 0FAA96B03CB; Fri, 23 Oct 2026 13:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABCC6B03CC; Fri, 23 Oct 2026 13:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC986B03CD; Fri, 23 Oct 2026 13:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5BE96B03CB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:51:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 434CC80199
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:51:30 +0000 (UTC)
X-FDA: 85354633140.13.CD31210
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DFD840006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:51:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=DQENUZTM;
	spf=temperror (imf11.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=intel.com (policy=temperror)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792777885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0jWfNLgp/P53a4Igz6agrxEFVXR7AaXBdmL6jWQ5ArY=;
	b=GZSWW3niD1llnlIEYz5c2IoZxzbkrZTZboUqOuxJ+1hkfs4QczJrV0PVN4YJJKAWfpA5M9
	rDiV9t/5b81NbFwEGNqWvHFze58Qz7jymmxumkuw/OUZNrzrxC9l5xdB0mIztP9HjxFVJ3
	B4wUxdOfNxQ5P/rmPXc2I1HQtgNKV00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792777885;
	b=Po20R4y1ke3WVgk6CMOvpS+Wgpi2490bn8QQua3/ohOkDm7q2sezHKnvnosxIwoisEn0u2
	m0Vv+3kY0itSMrNsSFqAUEOmgvawYoVqk0A4Y2F+Dj1JTrtuLcOnrV3ALkVVCjPjHp2x+a
	JLTIw6nMwRTCGU4vdsQ6NFIxGH1khV8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=DQENUZTM;
	spf=temperror (imf11.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=intel.com (policy=temperror)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792777880; x=1824313880;
  h=date:from:to:cc:subject:message-id;
  bh=zfi/3pNWgX5nqHQDs7AP0Jh06G+96u3YpSQtQqSKxlI=;
  b=DQENUZTM/hJ88bk2olgD8v62cYXaMYdfcT4WfVGchFDAycBZde97/mJ9
   pUrKMP58ds+b4jO36WxjfslfICEfAYXm/3sUFNM20iSK6Zzaktjnyx/OE
   Ic4YRIFvQxk8lQtO58V5bM57XPhvvUJWfhgFtVOrsBwxD96CVJgHxC5Vp
   NeaPk0eTM3MtnkiQ2hHXkGM7gZDSc2WuNzQEe2MeZWyDG48Nf9XAsagDW
   lf6akeX1CBND9vKI3w5G6a63jazs11wwe8/pNhEDqZ4fogVsv/AKCAC5h
   O49i5Ga058l0fdky+Dn8s8Ot7/BI4qNorZTd9r1OkeQYeM0K/fQygppqO
   w==;
X-CSE-ConnectionGUID: IeHSU3+DShuDbmt+sPtSAQ==
X-CSE-MsgGUID: qKCnAAlyQIubrp3qw12gzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1546139"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1546139"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 10:51:16 -0700
X-CSE-ConnectionGUID: QHkCnv67TnivzPaejiEV6A==
X-CSE-MsgGUID: IL3Axxy6SW2ukmzdZNWWbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3696480"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 23 Oct 2026 10:51:15 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKJQ8-00000000T5K-3VA1;
	Fri, 23 Oct 2026 17:51:12 +0000
Date: Sat, 24 Oct 2026 01:50:46 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab
Message-ID: <202610240135.uFA85jSq-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DFD840006
X-Stat-Signature: oqag84sdqt6nadudf8yitawunse1sebm
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792777880-620485
X-HE-Meta: U2FsdGVkX1/OFPZl5KuwcLEAc1y5h09ee1FsiMbJpyHFz1TRrBBigwZOFsaThtkpt4ffLDfxbvUCdLJWC+x722z97HHWfgeI6hpjysc2fkm54IcPDaxVJPX/Bm0Sh2IDOqHoGq5KOQUrq2z1ImbvAu0WBRiEEvlbiKnLiOKCKWdSqOttRPjf7fF9REhWf/91dUqkvS/ubskL3hveJhmKuWxaCQZmmOixjrjhmEhlytMQv3KhaEFC87M8PS2KGbLGFsMcr4MVYSaZZf9bqCUNXZ59LiBZDP6bF224WwUe+Xwld7udWfVQMCu5dsH7H9L7+0E7b4TIjsOV6IbmK7KyaAw+r099yfWRrb0gEaUOov0/vhXoadOfx3Z9tlpbB4oL73BsLMGEN0SwApVPI2mtEi+bM7CtpRpHzC+MPxOrVCQ9eHPh5D+NCvK2/9V3lfNqPFrjXL6LMdvintHMw2LNnhzuFQlySXUsWW9cFhOxXy7JNweU5JONKXov/gIYApXXm69dyan2AemCxPh0b0JsjMDlrbv576mfoolIEybywEWNiW6kC8Ta9w84b6+7f2mbEkwbg2WYiyhT1LEw/GxBcmQp8USdqZC+RdW7DfgcPWQirx3GTBj1UT1k5Qe1oOufajsziDfb9/dfP12Zod/DMIVHp6EiyCIaCfSqzADsEP4VQz3ngsqpZlPEQIyxK/ZcASkR4FYU6ffRK2qGp584o9vfnadzHVNXXOYcnkgHTmUv/sVdzr+CogrIE2xps+6pefHEW+VgEVGVIa/klo1+I6tjXoV84vwrywqqER+LfWRYbIG+1KnUwkHegWlqbPSJiUhVoX1EkA3vH5ZdjjWXC+RUMF0npaXLjpybIAg+/DmVnC3PXETvVvDp0QK2VDHrp4uiTq/gGKKhYSDnVehqXVW1BV1oy4u7OcnHJERGrFer2Kv42VbKV440gpmDa32r6kKSHlM056Vha6xqfWb
 xoKzsPFa
 HjRWIqn3BgG3iAXgtetArSdrDOxyPNyK7Q4XeJ6eSs1OCvweWPmH6JXMBva/3ayO7ZJ/heai/lj+xWRV9FyYSBGvS676zPcatxpHmH76+YZGWdjw1onb6XTwIWIxNCVj/olo6ObyUdb4tfoU3pteA3cMRDpe7Key9Zi6RIwkygy/G18klBPuIQxMpqgZEChxkSHwNiA9aNwCzoOELrt8IZQZt+WA/41UFC5TtE7gsC3hW6rF8ArX3AieLLqo0FBw6+0YhehbZ56XTyqi595uNSH+uzk29rndPKbt2FPu8Z39keQAv+wa2nWL1zGs7VxT/Jg29rvo0fZ8MlxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab  Add linux-next specific files for 20261022

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202610232206.jTTTXj8l-lkp@intel.com

    Warning: drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c:204 function parameter 'readonly' not described in 'amdgpu_ttm_map_buffer'
    arch/openrisc/include/asm/page.h:50:29: error: request for member 'pgd' in something not a structure or union
    arch/openrisc/include/asm/page.h:54:25: error: incompatible types when initializing type 'int' using type 'pgd_t'
    arch/powerpc/kernel/irq.c:116:(.text+0x22b8): undefined reference to `irq_proc_emit_counts'
    include/asm-generic/pgtable-nop4d.h:9:18: error: unknown type name 'pgd_t'; did you mean 'pid_t'?
    include/linux/mm.h:3639:22: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
    include/linux/pgtable.h:1544:13: error: implicit declaration of function 'pgd_none'; did you mean 'pud_none'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:1546:22: error: implicit declaration of function 'pgd_bad'; did you mean 'pud_bad'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:167:38: error: implicit declaration of function 'p4d_offset'; did you mean 'pmd_offset'? [-Wimplicit-function-declaration]
    include/linux/pgtable.h:167:38: error: passing argument 1 of 'pud_offset' makes pointer from integer without a cast [-Wint-conversion]
    irq.c:(.text+0x1d08): undefined reference to `irq_proc_emit_counts'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-allmodconfig
|   |-- drivers-net-wireless-intel-iwlwifi-pcie-tx.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-spi-spi-bcm2835.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   `-- kernel-workqueue.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- openrisc-allmodconfig
|   |-- arch-openrisc-include-asm-page.h:error:incompatible-types-when-initializing-type-int-using-type-pgd_t
|   |-- arch-openrisc-include-asm-page.h:error:request-for-member-pgd-in-something-not-a-structure-or-union
|   |-- include-asm-generic-pgtable-nop4d.h:error:unknown-type-name-pgd_t
|   |-- include-linux-mm.h:error:pointer-integer-type-mismatch-in-conditional-expression
|   |-- include-linux-pgtable.h:error:implicit-declaration-of-function-p4d_offset
|   |-- include-linux-pgtable.h:error:implicit-declaration-of-function-pgd_bad
|   |-- include-linux-pgtable.h:error:implicit-declaration-of-function-pgd_none
|   |-- include-linux-pgtable.h:error:passing-argument-of-pud_offset-makes-pointer-from-integer-without-a-cast
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-function-parameter-readonly-not-described-in-amdgpu_ttm_map_buffer
|-- powerpc64-randconfig-1000-20261021
|   `-- arch-powerpc-kernel-irq.c:(.text):undefined-reference-to-irq_proc_emit_counts
`-- powerpc-randconfig-1001-20261023
    `-- irq.c:(.text):undefined-reference-to-irq_proc_emit_counts

elapsed time: 1722m

configs tested: 72
configs skipped: 8

tested configs:
alpha                     allnoconfig    gcc-16.2.0
alpha                    allyesconfig    gcc-16.2.0
arc                      allmodconfig    gcc-16.2.0
arc                       allnoconfig    gcc-16.2.0
arc                      allyesconfig    gcc-16.2.0
arc          randconfig-1000-20261023    gcc-8.5.0
arc          randconfig-1001-20261023    gcc-8.5.0
arm                       allnoconfig    clang-17
arm                      allyesconfig    gcc-16.2.0
arm          randconfig-1000-20261023    clang-24
arm          randconfig-1001-20261023    gcc-8.5.0
arm          randconfig-1002-20261023    clang-17
arm          randconfig-1003-20261023    gcc-14.4.0
arm64                     allnoconfig    gcc-16.2.0
csky                     allmodconfig    gcc-16.2.0
csky                      allnoconfig    gcc-16.2.0
hexagon                  allmodconfig    clang-24
hexagon                   allnoconfig    clang-24
i386                      allnoconfig    gcc-14
loongarch                 allnoconfig    clang-20
m68k                     allmodconfig    gcc-16.2.0
m68k                      allnoconfig    gcc-16.2.0
m68k                     allyesconfig    gcc-16.2.0
m68k                  multi_defconfig    gcc-16.2.0
microblaze                allnoconfig    gcc-16.2.0
microblaze               allyesconfig    gcc-16.2.0
mips                      allnoconfig    gcc-16.2.0
mips                     allyesconfig    gcc-16.2.0
mips               lemote2f_defconfig    gcc-16.2.0
mips                omega2p_defconfig    clang-17
nios2                    allmodconfig    gcc-11.5.0
nios2                     allnoconfig    gcc-11.5.0
nios2        randconfig-1000-20261023    gcc-10.5.0
nios2        randconfig-1001-20261023    gcc-11.5.0
openrisc                 allmodconfig    gcc-16.2.0
openrisc                  allnoconfig    gcc-16.2.0
parisc                    allnoconfig    gcc-16.2.0
parisc                   allyesconfig    gcc-16.2.0
powerpc                   allnoconfig    gcc-16.2.0
powerpc            amigaone_defconfig    gcc-16.2.0
powerpc                fsp2_defconfig    gcc-16.2.0
powerpc            ge_imp3a_defconfig    gcc-16.2.0
powerpc          iss476-smp_defconfig    gcc-16.2.0
riscv                     allnoconfig    gcc-16.2.0
riscv        randconfig-1001-20261023    gcc-13.5.0
s390                     allmodconfig    clang-24
s390                      allnoconfig    clang-24
s390         randconfig-1000-20261023    gcc-8.5.0
s390         randconfig-1001-20261023    gcc-9.5.0
sh                       allmodconfig    gcc-16.2.0
sh                        allnoconfig    gcc-16.2.0
sh                       allyesconfig    gcc-16.2.0
sh           randconfig-1000-20261023    gcc-10.5.0
sh           randconfig-1001-20261023    gcc-16.2.0
sh          sh7785lcr_32bit_defconfig    gcc-16.2.0
sparc                     allnoconfig    gcc-16.2.0
sparc64                  allmodconfig    clang-20
um                       allmodconfig    clang-17
um                        allnoconfig    clang-17
um                       allyesconfig    gcc-14
x86_64                    allnoconfig    clang-22
x86_64                          kexec    clang-22
x86_64       randconfig-1001-20261024    gcc-14
x86_64       randconfig-1002-20261024    gcc-14
x86_64                       rhel-9.4    gcc-14
x86_64                   rhel-9.4-bpf    gcc-14
x86_64                  rhel-9.4-func    gcc-14
x86_64            rhel-9.4-kselftests    gcc-14
x86_64                 rhel-9.4-kunit    gcc-14
x86_64                   rhel-9.4-ltp    gcc-14
xtensa                    allnoconfig    gcc-16.2.0
xtensa                   allyesconfig    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

