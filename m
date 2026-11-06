Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E709606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qb9HbVen
Received: by kanga.kvack.org (Postfix)
	id 415C26B05B1; Fri,  6 Nov 2026 08:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5616B05B3; Fri,  6 Nov 2026 08:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A60A6B05B6; Fri,  6 Nov 2026 08:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3E086B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:10:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 903DB1C47EC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:10:40 +0000 (UTC)
X-FDA: 85404728640.17.60F7745
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id B446710000F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:10:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qb9HbVen;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793970638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CZy5JsHCWTvRRL5WzajSHd2v2duLZ40xDB1Jjtxw/yU=;
	b=4WujEkQqYdnSseLMHcm3TZIPsxUVvx4SvgVNJ6MvKS4LTWVF9d+oPR+ktGwyPXHYLJcScT
	EsJDEWfGeH0ybFDKjncGubZeZJuPbytLYnZdCEgS75O3SF7rpBjHlmo4/naUb9uVObFHfs
	R7W2OrooJ7iCA9Q+yymWvHxigYKjhQA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qb9HbVen;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793970638;
	b=MuUQPUSMHT8sth22YCs95F4uMybHDRoYKzuIloPrv68Ln5goTZtcxLuQ9YGIF84pnlXUsc
	xM6VXLLFmxVRQgZdtgHPja/yXLWovfebUcOoI43muWLYq9Rbi5pimkz0X1dD6+Ks1Ot5Jh
	/ohnxktkp5h14QBK3WemtkE4KKPJYC4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793970638; x=1825506638;
  h=date:from:to:cc:subject:message-id;
  bh=HneZO/bs1F1XP/bR4iBKXB0PoFurxmsq9qcoX+zI5ow=;
  b=Qb9HbVenmd8qd9T+hJr/Q4q7MuMOTUfMerrzX9rVVu7xdIPgVP8Gcz0c
   rEZlJ+7Em5mEDRHkN1vuyVuimkuFPcFqNTGnDhG2er2OfqrhI/wYeNhTn
   SZneJHEFpGS851/TnZqKHde2zr0ZOqPjYoaGyCufFUBKstdgmdhSRbxxU
   wIweUiEnsy0E9lRsHUT6yYkuk2NYeHOhnynfKP0POCV+UYHSc1PJu6tf3
   dh/35qDMlvQeg4AlzZA7PoTlai5iEJqSC/ZnL0DzOK/7vdZuCM5eK7csO
   EFZ3CyJ275liJ/vjPBLAZfI3vPFErt3kHUwtL/CWNcH89RZORsadsowp0
   g==;
X-CSE-ConnectionGUID: 9W+oNsUbQrivJDnlUJGhig==
X-CSE-MsgGUID: H7yjZ1PCTgKxXBYJRDT6tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2774112"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2774112"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 05:10:37 -0800
X-CSE-ConnectionGUID: vJZnV/jmST2ViJjzRKByig==
X-CSE-MsgGUID: oXvNOsPdTAq47KHKzP1JzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7116374"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 06 Nov 2026 05:10:35 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPJiC-00000000pId-2vLX;
	Fri, 06 Nov 2026 13:10:32 +0000
Date: Fri, 06 Nov 2026 21:09:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
Message-ID: <20261106210945.95nkwbIn-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B446710000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3c1w9caiqwx8siqiyz3eb4ojs8cfu5k5
X-HE-Tag: 1793970637-622924
X-HE-Meta: U2FsdGVkX19WcSU7WkZFdmjL+jiNqD1BHIljHEg/4P24MnGuk9qE+wgHl9UMwioXz2FX6YFpB0iNKsw+2vOoZZnk9JoC9rkptS70byZi1jaUWD2bC7ihVEflfL8vHxLs+TibXfbeQAzcOvlpWxjTsK32QynMQhOIrWssjlhFsIKiTo+Mfk12qA5Vzqo/lqUtMiYD/9ZQZ2o9M1YMMwvy8GdiM1NFBJbzBvQBi12DaULBY+YyWATuvoa7VmfIVZndB8W6vPuA+2VZOOc/JnVWQTMBinjAT7hXgUHw3DpXXgBMUIVWVx8nJoK7IyLAjyspMET1Ss9tENv1NpcZN9RMg8yQjB9FvvFgQdYk+fb9GetMWJYnjGdns6CS3PvxMONFJqRw9gLap2hQ3/HqgShn7JL54TxHTatEZXi/pIgjQ064QvHywA1mVnausK9bmzIK6rV2CYjF446yWE7m2/bQmhxguVn8NbLCymQ4Yd9oENjUeh8uj4FiBGpsp3QDRZmVV3W4f2Rnu4aZ72er8ZG86R06+iXOt7KKJQO0O4Sa+VUSovnxc2yTX05L1jtI6NLlqHe71oMcfKSY4eLRE6ovXMuKbQztyEV/UhYMYSwNNh2afyISefFYGylf+2kz6jTl+MJ4IZivDob7670XtWgFR3qSnDH8xtZl2I4m1ysOKcfY7zLaM9RstTX5ezWym6MCgbmsLGlzdtK5knxrMfIu5CFlgB6EQ324goYwECJSGAJ4mBgo+shTdUAgCgNtqneZ//A6ytpI0P1IpHKLNAeT4ryWIQXpD7t/7xSAve3lGp4GttUM3r9c8f8vLR6oRl5kxCsRfQlpXG4lQ7XX2qh2kdaDsGDA/TGSFeJeQ6FT0Qup0GNlXxK33X76yzNduPTg+BdIuHfWQP+oGYdC7suiDZ3O5ZXXxUoYs/2cE0wtJv8bU0Zl3RXIxZxHrC/J4UUUJWQ9m90pCrH1HJp4Xbb
 3qBx0Qie
 gu1rG3l0tcMTAUSAfI7qALb9J8rsdO3F8K4R4/8mV04U4g/xyujvcYGTZ17XzRlGKEOZmlYjSk7axhePGHEKnCwH51Cj3TSCZ0zz4RPlZU8h4+jgDwJJ5WjIF0F7wXCdkjy0dJTuWApg4oAeNV2Ia7VSrl+ykNH5JAhFZQ9FxTyH+sJfdWgzjWEXxqCqEI0VfZ5iVTKriZHrwPeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b  Add linux-next specific files for 20261105

elapsed time: 1322m

configs tested: 173
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                         nsim_700_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261106    gcc-8.5.0
arc                   randconfig-1001-20261106    gcc-8.5.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261106    gcc-8.5.0
arm                   randconfig-1001-20261106    gcc-8.5.0
arm                   randconfig-1002-20261106    gcc-8.5.0
arm                   randconfig-1003-20261106    gcc-8.5.0
arm                              rpc_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261106    clang-17
arm64                 randconfig-1001-20261106    clang-17
arm64                 randconfig-1002-20261106    clang-17
arm64                 randconfig-1003-20261106    clang-17
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261106    clang-17
csky                  randconfig-1001-20261106    clang-17
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261106    gcc-14.4.0
hexagon               randconfig-1001-20261106    gcc-14.4.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261106    clang-22
i386        buildonly-randconfig-1001-20261106    clang-22
i386        buildonly-randconfig-1002-20261106    clang-22
i386        buildonly-randconfig-1003-20261106    clang-22
i386        buildonly-randconfig-1004-20261106    clang-22
i386        buildonly-randconfig-1005-20261106    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261106    gcc-14
i386                  randconfig-1001-20261106    gcc-14
i386                  randconfig-1002-20261106    gcc-14
i386                  randconfig-1003-20261106    gcc-14
i386                  randconfig-1004-20261106    gcc-14
i386                  randconfig-1005-20261106    gcc-14
i386                  randconfig-1006-20261106    gcc-14
i386                  randconfig-1007-20261106    gcc-14
i386                  randconfig-1008-20261106    gcc-14
i386                  randconfig-1009-20261106    gcc-14
i386                  randconfig-1010-20261106    gcc-14
i386                  randconfig-1011-20261106    gcc-14
i386                  randconfig-1012-20261106    gcc-14
i386                  randconfig-1013-20261106    gcc-14
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261106    gcc-14.4.0
loongarch             randconfig-1001-20261106    gcc-14.4.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                          nettel_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                   cavium_octeon_defconfig    gcc-16.2.0
mips                          db1xxx_defconfig    gcc-16.2.0
mips                       loongson3_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261106    gcc-14.4.0
nios2                 randconfig-1001-20261106    gcc-14.4.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc                   or1klitex_defconfig    gcc-16.2.0
openrisc                  simple_smp_defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261106    clang-19
parisc                randconfig-1001-20261106    clang-19
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                      kmeter1_defconfig    gcc-16.2.0
powerpc                      mpc512x_defconfig    gcc-16.2.0
powerpc                       pcm030_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261106    clang-19
powerpc               randconfig-1001-20261106    clang-19
powerpc                      redwood_defconfig    gcc-16.2.0
powerpc                     sam440ep_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261106    clang-19
powerpc64             randconfig-1001-20261106    clang-19
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261106    gcc-14.4.0
riscv                 randconfig-1001-20261106    gcc-14.4.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261106    gcc-14.4.0
s390                  randconfig-1001-20261106    gcc-14.4.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261106    gcc-14.4.0
sh                    randconfig-1001-20261106    gcc-14.4.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261106    gcc-15.3.0
sparc                 randconfig-1001-20261106    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261106    gcc-15.3.0
sparc64               randconfig-1001-20261106    gcc-15.3.0
um                                alldefconfig    gcc-16.2.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261106    gcc-15.3.0
um                    randconfig-1001-20261106    gcc-15.3.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1006-20261106    clang-22
x86_64                randconfig-1007-20261106    clang-22
x86_64                randconfig-1008-20261106    clang-22
x86_64                randconfig-1009-20261106    clang-22
x86_64                randconfig-1010-20261106    clang-22
x86_64                randconfig-1011-20261106    clang-22
x86_64                randconfig-1012-20261106    gcc-14
x86_64                randconfig-1013-20261106    gcc-14
x86_64                randconfig-1014-20261106    gcc-14
x86_64                randconfig-1015-20261106    gcc-14
x86_64                randconfig-1016-20261106    gcc-14
x86_64                randconfig-1017-20261106    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261106    gcc-15.3.0
xtensa                randconfig-1001-20261106    gcc-15.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

