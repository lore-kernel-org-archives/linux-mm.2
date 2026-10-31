Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2008606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XroL3Nxk
Received: by kanga.kvack.org (Postfix)
	id 81D3B6B00EF; Sat, 31 Oct 2026 12:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6D66B05B1; Sat, 31 Oct 2026 12:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EBA6B05B2; Sat, 31 Oct 2026 12:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAAF6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:27:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B51A5C09FC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:27:50 +0000 (UTC)
X-FDA: 85383452700.05.F10530E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0153540005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:27:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XroL3Nxk;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793464068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UVVdTSFlwxyqD/9fw01xgyqC8L1ZKUkJ/4Vb6MjowdE=;
	b=qcs5A/Qblbw3ACfPlI0gvoUNuMwjJJGC+K+yUcfEWPdYTXEyVY4lNgNUhCg/ishYFK6tcG
	vZig3uOGPKzxlGgzkGE/zZORU2z5XNLh1KfurDMaSnrxGNFvKR405cFrAVmbBWY9vkZYqx
	Zw5ghkTod8SGWJxMzk6e2MDivGrFro0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793464068;
	b=F2F1Cfct0wDcAhgAZPJJtFHnw2HEYZ4m8teEO/WthC7GsDrz80hbvlTHiYshDknylZLb29
	hEMncJvgnhRWBZBml8syJNYgvuK7HuShjJP1uV21GJS6UWF4b1xIDz/o2LtaGmsOmWF8XB
	FyuhwzOmXnapdjwZnbSJWI6NG+nDlsw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XroL3Nxk;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793464068; x=1825000068;
  h=date:from:to:cc:subject:message-id;
  bh=1JMBdD6kmsJXQXLrXcqnjEnGPYiEwTJuslCd16FCcGY=;
  b=XroL3Nxk5fD4S8FqTgnzW4nvrL45AeNn7ZaVlPMB7b7V4TeHJD3BDnD2
   K7deK09ryA5x/UUHvnxoBFBsylfOEy9fTmd5nqLoTRqLHU5RZsT9zaPlj
   2Toq6dDkqqoKkVqLEA44R2uac7s3nrDzVWSpAzQoM4quPfB+3jhdYoYGL
   ++wxMsQjCWzSTPysmz9KjwYu+VpWDUXE56eKeqDG8RGK6TTga2EN1Gr3o
   vVdE9OX3U6CV70O7BcgChx5VqSdvxQ0P2ULWgmLinri0sq90pqwArVsnk
   BOhJ+9262uHlS1D/Ff2nkJSalkaNzzPCyBVQrfUFOOr3YJnMhkMzSofZq
   w==;
X-CSE-ConnectionGUID: WcFUriz4TOSllcEwY/7VtQ==
X-CSE-MsgGUID: szc0TwThSeaVek66Bohe+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11952"; a="2232492"
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="2232492"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2026 09:27:47 -0700
X-CSE-ConnectionGUID: UB1lXirFR+e/lvukiJcyYQ==
X-CSE-MsgGUID: vcMsiHUZTi2qCpCKgHjBTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="6027981"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 31 Oct 2026 09:27:45 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNBvh-00000000cyi-3zh3;
	Sat, 31 Oct 2026 16:27:41 +0000
Date: Sun, 01 Nov 2026 00:27:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 243e8cdab64129d6207c398f8cf5fbb1962ff7e1
Message-ID: <202611010020.uHV1BRFO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0153540005
X-Stat-Signature: n15sz339nmy9mnbwwwpcy7uarstwd3ks
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793464067-432822
X-HE-Meta: U2FsdGVkX1+7cXzyMvD58tuwkcvxzVI+nbUi179B89PmWefP3+dWwjWoUiNZ/s2mqOEpR8KlFykNLLp1wMNasxIcc5xvdDclCtDdsN8H9sz2raOoUII/XG1lfuNK6R2sdxMoiHGFoyWBZto4ynRmj/jlEhGcQqThnni8T6/EzOJ+J9Eg475OQskrK+eHdEwf73dlfNmCTz6duqlpTVNOtZD1M12A/htXHFxQCIGVmEPfzRqpP5j21ZY3GyoLjjkGUMkGD3SAtc3pUvtgPU+WzIMOK8xsEj35dxP8IS6Y34abNdd7dXptvqnESyWdh7nnHonJXi9Sw1MjVgOWnOVlMdW4calgp70cfNj0yZjNQA3CUeWO5Mh/lww1qDFyOpMdUfp7AFDct9Wv7ipLF7qvG4UBdGUDo2Mz6UdC3HcRfBsYVnFMQ2WWQkm39D2DKT4eNrUCW+IYBRVtYudsdh2zoVdOEal09ZdBDk3gwOqxhEnhLpdbGmNT+vupAa8pd6AlRlN4685ghIFwkkMP53oGjO0uzlU8dMKSM/F7MLDGVhS0hoF4PHt2xcKt50/uAWTsHaN3xJJ8YGZ4NnuK/WUZQ5Q7ZuqtblrfDkepEIUwMmokBLI/mc6sKZnnj9tbmMLxzBZMXA4YUA5HfAnWEsFu1J8h7BS5+maGRQhq5bRyVsdj4JOt1Pbi94GMU6bhLaqC1hzsn1ixLBpT4ukxmHYMYmjX38EaTuxJzP89Meosf+M062nQar9QUjc1uQ5093Q8bWajzCfJunjo6wRJXQAqn2LgYXk9Zd1gBd8esi6ilj1NjcIJLVkG5kkj0JJTHoUUZ0eIftH2eHJo9b7sCGCZzXVcPfOu8Dh2G0IOGlLfMHtXmaiXB5kdzeWNyFN1mOqmb3AFgMfS3PLsHbXtndJsrFLq2ZTYj3GEoDCwDsBMb0L2MEb2fyRQa2LHtC+6PlMimgJwFV6MezUEeMRmale
 R1Rxg1CH
 6DMjAMNDKG/cJVyr4fMDgyEnKtOF7hg8iQa43RhKCZS4oQKECg7U/ZgeHQfU5GZoD+ONrnAdKii+nVdYpTaVHxeCrhTd9TUmIJMZ7N1h/VH8Fdp43Qe6sls7Yar9EfbYTnYi4VCtUIYAaNwyNSwdOhWZ5A4c+Sa6SHtDDeJOoQZtRWE39Bh9pwmlVe4InOqkZCCB07rtRZcSLdNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 966m

configs tested: 166
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261031    gcc-9.5.0
arc                   randconfig-1001-20261031    gcc-8.5.0
arc                     vdk_hs38_smp_defconfig    gcc-16.2.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20261031    clang-17
arm                   randconfig-1001-20261031    gcc-13.5.0
arm                   randconfig-1002-20261031    clang-21
arm                   randconfig-1003-20261031    gcc-13.5.0
arm                           sp7021_defconfig    gcc-16.2.0
arm                          wpcm450_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261031    gcc-8.5.0
arm64                 randconfig-1001-20261031    clang-24
arm64                 randconfig-1002-20261031    gcc-10.5.0
arm64                 randconfig-1003-20261031    gcc-12.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261031    gcc-13.5.0
csky                  randconfig-1001-20261031    gcc-16.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261031    clang-24
hexagon               randconfig-1001-20261031    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261031    clang-22
i386        buildonly-randconfig-1001-20261031    clang-22
i386        buildonly-randconfig-1002-20261031    clang-22
i386        buildonly-randconfig-1003-20261031    clang-22
i386        buildonly-randconfig-1004-20261031    gcc-14
i386        buildonly-randconfig-1005-20261031    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261031    gcc-13
i386                  randconfig-1001-20261031    gcc-14
i386                  randconfig-1002-20261031    clang-22
i386                  randconfig-1003-20261031    gcc-14
i386                  randconfig-1004-20261031    clang-22
i386                  randconfig-1005-20261031    clang-22
i386                  randconfig-1006-20261031    clang-22
i386                  randconfig-1007-20261031    clang-22
i386                  randconfig-1008-20261031    clang-22
i386                  randconfig-1009-20261031    clang-22
i386                  randconfig-1010-20261031    gcc-14
i386                  randconfig-1011-20261031    gcc-12
i386                  randconfig-1012-20261031    gcc-14
i386                  randconfig-1013-20261031    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261031    clang-24
loongarch             randconfig-1001-20261031    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261031    gcc-11.5.0
nios2                 randconfig-1001-20261031    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261031    gcc-15.3.0
parisc                randconfig-1001-20261031    gcc-13.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261031    gcc-12.5.0
powerpc               randconfig-1001-20261031    clang-24
powerpc                      skiroot_defconfig    clang-24
powerpc64             randconfig-1000-20261031    clang-24
powerpc64             randconfig-1001-20261031    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261031    gcc-8.5.0
riscv                 randconfig-1001-20261031    gcc-8.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261031    gcc-12.5.0
s390                  randconfig-1001-20261031    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                             hp6xx_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261031    gcc-9.5.0
sh                    randconfig-1001-20261031    gcc-16.2.0
sh                            se7619_defconfig    gcc-16.2.0
sh                    secureedge5410_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261031    gcc-8.5.0
sparc                 randconfig-1001-20261031    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261031    gcc-12.5.0
sparc64               randconfig-1001-20261031    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261031    gcc-12
um                    randconfig-1001-20261031    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261031    gcc-14
x86_64      buildonly-randconfig-1001-20261031    gcc-14
x86_64      buildonly-randconfig-1002-20261031    gcc-14
x86_64      buildonly-randconfig-1003-20261031    clang-22
x86_64      buildonly-randconfig-1004-20261031    gcc-14
x86_64      buildonly-randconfig-1005-20261031    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261031    gcc-14
x86_64                randconfig-1001-20261031    gcc-14
x86_64                randconfig-1002-20261031    clang-22
x86_64                randconfig-1003-20261031    gcc-14
x86_64                randconfig-1004-20261031    clang-22
x86_64                randconfig-1005-20261031    clang-22
x86_64                randconfig-1006-20261031    gcc-14
x86_64                randconfig-1007-20261031    clang-22
x86_64                randconfig-1008-20261031    clang-22
x86_64                randconfig-1009-20261031    clang-22
x86_64                randconfig-1010-20261031    gcc-14
x86_64                randconfig-1011-20261031    clang-22
x86_64                randconfig-1012-20261031    gcc-12
x86_64                randconfig-1013-20261031    gcc-14
x86_64                randconfig-1014-20261031    gcc-14
x86_64                randconfig-1015-20261031    clang-22
x86_64                randconfig-1016-20261031    gcc-14
x86_64                randconfig-1017-20261031    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261031    gcc-11.5.0
xtensa                randconfig-1001-20261031    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

