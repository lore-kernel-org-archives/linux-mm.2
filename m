Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9F6606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=D3JKYF0I
Received: by kanga.kvack.org (Postfix)
	id B223B6B05B1; Thu, 29 Oct 2026 15:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3376B05B4; Thu, 29 Oct 2026 15:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9B06B05B5; Thu, 29 Oct 2026 15:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F97A6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:16:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2BC3A0481
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:16:21 +0000 (UTC)
X-FDA: 85376619762.14.5644CB8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71E1118000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:16:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3JKYF0I;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793301380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=EyacNsi1Pt7KRWo4B0P5Lt5n3rqa086gdIoleJ+a8Fk=;
	b=kqEs9mpr8fRDKJA0cabwtZbcFd7qEMVpUMIHhbrdkmd/0WepXwFulaDycsLr1H6DvGEend
	vLtLTM/z3b/Sxy91VnsZyKXLSygZ/xZd00Q5TOEN16qo/k8HsS5hfkiRS20mXNB/CkDmqg
	0fppiswdjag3BHewgJr8+m9WUSYafLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793301380;
	b=WS0uoKYI8f/oWatlDRAVFlW9mRaFt75tiY4emuFGqeRksGFkb8CJ+MMrn9aPrQ2/Ljd8hh
	drS+RvYjGDlOz4rIFXAsVPmYteBHSlFq6jPRGbPib8ejW4fp4/RLnqAUAnuceMCqnnIsvb
	1szNOZRvXACiI7hbwQJq1EyIkm4YaJw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D3JKYF0I;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793301380; x=1824837380;
  h=date:from:to:cc:subject:message-id;
  bh=jsZRERdKptpSe6ii8cQ8wuzPMMnwBRoNoKRHsz+QgeM=;
  b=D3JKYF0IMeWfYFQMHBFE9EJeL+l7URnvg4jVYV5YGt4anQ4tRCB3ZRwm
   CdpjvOl0b+d4BxOxb0NjGno1sQdPbIn37GhVSxsIqD9fcDe05nG2QvZW9
   CjdUWTDa/aZYAwdL8frFzlFlFpFrfqZ/jStZLux1xQyacd+EE3YAS7/Tw
   5NIfubnHnKfN7Ey6iBhqwKVVLvPnbVkMgofJjTbneCmM+iBYdpHxla8Bm
   Jlah7epBiMGZtzTOtUjdrSfePKrLmT1aZoVNH382KOfwgFXMhQhr55dSP
   QIxPjyGgb+3u6ZSXfMnZ/dkDPU0ZFHf0CNdSkIXuPS+5QfcgQIyhhoBpK
   g==;
X-CSE-ConnectionGUID: K7LrJkj9SBC/BH70i8Az9w==
X-CSE-MsgGUID: JzbMQputS7ScCQHPjzTLpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="1934633"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="1934633"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 12:15:27 -0700
X-CSE-ConnectionGUID: ypNkN7bPQL+P1zWGngso8g==
X-CSE-MsgGUID: iNogW8XYRYSQ0/pNyC0klA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="7005490"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 29 Oct 2026 12:15:25 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMVas-00000000ar2-1hY6;
	Thu, 29 Oct 2026 19:15:22 +0000
Date: Fri, 30 Oct 2026 03:14:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 d865f2677c44cb2171b833d6775cf692756fa8be
Message-ID: <202610300349.tvbNgoYB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71E1118000C
X-Stat-Signature: i8hnuzzhmfc38wxufip4s5cadp9tbbq1
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793301379-371197
X-HE-Meta: U2FsdGVkX19NUMngee9vNSOUSKBezFvnAR35fYN9Nwk/6+mT1SLsqI/zGO4sZS3XNogzTPTa0q8BU6Zmh8OHuZUmTeSaemy977OOKchHa+lg9fLkf9xBwhpx6/sGcfshNYESjInBtQ19F81lWXPyyytCYZLGFtzFU2Qd9MwQUHEadQUtcbnsI/rMP10OcWg02EPrKuld9DLgU0s6Wol0oaldCEH1RXV8C3xEbVM3uZF+1VgYTYLyBsTar0zWaL+PLEoazEX7vV1C0zJPDHKb+G6LAo6QMqw+gehQbOZc2QPZ9gTMqgpaFZJ6nI+PGgs8wJoUiFpoSnBywLuNIbTvpHoA/JetUqfMuu3FDdpw2baf1MglQALeqwV5LxBHiGJCpEid9DPxg+muPmkZOYjcDkcjnVMf2VSFkR3jeArHz3UvB30XGXXTh4E9dk8xbsOYosci08c8JhxZfMy3qp3x19l2WSG4SqQQkzD4UB/R8rLgLPh2Emshi81++OAO4sWXxzi23JQmYL0bWOUt8YZMxuAyQaDMPP7yyiFXd6QtdJ+sIvtS3S0VzGPIuAx425/1mXsMvmRtnjFADt59rgSC9ZrmOZUmErw0oCa6L4idYYASnbRYf42XgGIpp5gGlsq9LYFqFKaHL6w2W9LqShTYBbGhksoCIbryanbC/Y1vdlos3fzZVCptrf/LqZ2B71fNh1ypBdHUldFiY3y3r0TfsnY9mPldpM+c8ctq0CmYHOs6FFdApy3Teyph/o3Xi0qxShrKMaGFb9LvfzPs4ap1BHsVHcL8MRGiV7ZwB7eaAgZBIbadWH4zrDQQeYyuw4uYWe6URx0vO3XjlT3voTxuDvTz6k020G/a6QCj9J0w74u8wxIBa6o9XHWCEk0d8GkQgFxO5r1eFBrUW1ydkhkxkT8JilF/LsjVWIDXzxBRlR+FsQcf93sv9akblMwurLOFT30hj7JDxJvh+7Lcmy1
 akQ/jG5a
 XwMR15ZC54fNvpSi1KP0iBpMcw6mes8yoZTv2Wx17RtYgjwPFGMcsFObMFdE/irY3meilNJ+OmXnMy/AQpPB7e/KE6EsHX7WTtGKuH5Sc4WHmiIibfKxPwrYTkYT0/SmuK/I4EBslSW/QRX0Xf3cyXNUkZXYMU9K1PFjDKB5LlTVGnLG186mTjvLJTVsvoKT3djpZFLU1Uhkq7Vo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: d865f2677c44cb2171b833d6775cf692756fa8be  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1046m

configs tested: 155
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261029    gcc-12.5.0
arc                   randconfig-1001-20261029    gcc-14.4.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                          assabet_defconfig    clang-22
arm                                  defconfig    clang-24
arm                         mvebu_v5_defconfig    gcc-16.2.0
arm                        netwinder_defconfig    gcc-16.2.0
arm                          orion5x_defconfig    clang-21
arm                   randconfig-1000-20261029    clang-22
arm                   randconfig-1001-20261029    clang-18
arm                   randconfig-1002-20261029    clang-19
arm                   randconfig-1003-20261029    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261029    gcc-11.5.0
arm64                 randconfig-1001-20261029    clang-24
arm64                 randconfig-1002-20261029    gcc-8.5.0
arm64                 randconfig-1003-20261029    gcc-13.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261029    gcc-16.2.0
csky                  randconfig-1001-20261029    gcc-10.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261029    clang-22
hexagon               randconfig-1001-20261029    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261029    clang-22
i386        buildonly-randconfig-1001-20261029    clang-22
i386        buildonly-randconfig-1002-20261029    gcc-14
i386        buildonly-randconfig-1003-20261029    gcc-14
i386        buildonly-randconfig-1004-20261029    gcc-14
i386        buildonly-randconfig-1005-20261029    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261029    gcc-14
i386                  randconfig-1001-20261029    gcc-14
i386                  randconfig-1002-20261029    clang-22
i386                  randconfig-1003-20261029    clang-22
i386                  randconfig-1004-20261029    gcc-14
i386                  randconfig-1005-20261029    clang-22
i386                  randconfig-1006-20261029    clang-22
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261029    clang-20
loongarch             randconfig-1001-20261029    gcc-16.2.0
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
mips                            ip30_defconfig    gcc-16.2.0
nios2                             alldefconfig    gcc-11.5.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261029    gcc-8.5.0
nios2                 randconfig-1001-20261029    gcc-10.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261029    gcc-14.4.0
parisc                randconfig-1001-20261029    gcc-8.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  mpc832x_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261029    clang-17
powerpc               randconfig-1001-20261029    gcc-15.3.0
powerpc64             randconfig-1000-20261029    gcc-15.3.0
powerpc64             randconfig-1001-20261029    clang-17
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261029    gcc-13.5.0
riscv                 randconfig-1001-20261029    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261029    clang-24
s390                  randconfig-1001-20261029    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261029    gcc-12.5.0
sh                    randconfig-1001-20261029    gcc-10.5.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261029    gcc-16.2.0
sparc                 randconfig-1001-20261029    gcc-14.4.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261029    clang-24
sparc64               randconfig-1001-20261029    gcc-15.3.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261029    clang-18
um                    randconfig-1001-20261029    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261029    gcc-12
x86_64      buildonly-randconfig-1001-20261029    gcc-14
x86_64      buildonly-randconfig-1002-20261029    clang-22
x86_64      buildonly-randconfig-1003-20261029    gcc-14
x86_64      buildonly-randconfig-1004-20261029    gcc-14
x86_64      buildonly-randconfig-1005-20261029    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261029    clang-22
x86_64                randconfig-1001-20261029    gcc-14
x86_64                randconfig-1002-20261029    clang-22
x86_64                randconfig-1003-20261029    clang-22
x86_64                randconfig-1004-20261029    gcc-14
x86_64                randconfig-1005-20261029    gcc-14
x86_64                randconfig-1006-20261029    gcc-14
x86_64                randconfig-1007-20261029    gcc-14
x86_64                randconfig-1008-20261029    gcc-14
x86_64                randconfig-1009-20261029    gcc-14
x86_64                randconfig-1010-20261029    gcc-13
x86_64                randconfig-1011-20261029    gcc-14
x86_64                randconfig-1012-20261029    gcc-14
x86_64                randconfig-1013-20261029    clang-22
x86_64                randconfig-1014-20261029    clang-22
x86_64                randconfig-1015-20261029    clang-22
x86_64                randconfig-1016-20261029    clang-22
x86_64                randconfig-1017-20261029    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261029    gcc-14.4.0
xtensa                randconfig-1001-20261029    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

