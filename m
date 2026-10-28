Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4D360A260D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fNmqWDGm
Received: by kanga.kvack.org (Postfix)
	id DD9876B05B9; Wed, 28 Oct 2026 09:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D625A6B05BA; Wed, 28 Oct 2026 09:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AC36B05BB; Wed, 28 Oct 2026 09:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9663B6B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:53:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2580DA8B40
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:53:13 +0000 (UTC)
X-FDA: 85372176666.08.47FB994
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf01.hostedemail.com (Postfix) with ESMTP id A37D74000F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:53:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fNmqWDGm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=EZ/4ugvFA15Yu6Na+g54C1TjihOcshtcopxkcUJxWNg=;
	b=AuCWHs+MocvD2EHDlKOlqU463flimU1Lp+MTlJE0gHzp3u7YSZC7D41q8ZSM6wNWbOgh3Q
	yMIoaYnqct9OvjRs7WS8vQgk/8B/req6unq6dpWolqDLdNibhxd3b5WorAAe8Nd3nfIzvb
	coHD7aWYM3ra1auq0vaL0wV/dr8qMrE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fNmqWDGm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195591;
	b=zNEHLl9r2nlLgNGLEezz8BZf21afw0CeRSYOWgjPwPV4jSeAixn9CKEp/7b3PTxhkf7uYp
	dUKDpQLjRT3gnp+0+3MHte2RL5xcKWA8WWxYuiARQdTNB3R12788C81CxmAFMdB82pHAtJ
	R8MbAgCb4Q/I6Sp8E2mMzt9sXEqMoPI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793195591; x=1824731591;
  h=date:from:to:cc:subject:message-id;
  bh=2Z64tFbRRnl1NCtjyFnKTgAEOdfYuWwp0ABUWJPJORw=;
  b=fNmqWDGmPNesshyALPu67u5sC1peQENkSHTcx8xa7E8yManW4xlIHVbe
   9QHdCcKSyfEuOBqbDqbzLwT2ZkwQU5h0eTGprRpilYz/3CGeA4mQdq3Kq
   fFT39Y7/BFI3X8GHgrkJd4sBsOLX2fdr4E+TpvtKQpEExDtXBZsX4gZ90
   rVfAqYabtCjeL06f1OFUgFOUviKzGGGX5pupjtkzMngf2GLaoRygGRI+9
   XbiKkgw0hQs4JeBeyEsuSdbI4NoX+Io/eii+FGTiVoEBiD12TQa8Vqxb8
   920/McAHsW8e7VeJ8+GL2YPfR7PhpLxaD2suzVPwKu1aLNMsvefACjVXn
   g==;
X-CSE-ConnectionGUID: BafAlO2/SqytA/D2Zqgogg==
X-CSE-MsgGUID: 9pnKa62jTZui9cVy2LxfBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1929214"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1929214"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 06:52:28 -0700
X-CSE-ConnectionGUID: 2Avg18UPRyuai7Xu298GTg==
X-CSE-MsgGUID: BPnWOelvSASUiH2YbGO2Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="6666292"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 28 Oct 2026 06:52:17 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xM44b-00000000Ymu-3Vzn;
	Wed, 28 Oct 2026 13:52:13 +0000
Date: Wed, 28 Oct 2026 21:51:54 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 151a134a4e6ec66f69db8750c66006f5207f7a9d
Message-ID: <202610282151.M2bNbEeR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: A37D74000F
X-Stat-Signature: kq48n53ncfpxqetuujny4myzeo4yr16y
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793195590-593319
X-HE-Meta: U2FsdGVkX1+7kaYTDALt9K9qQ6d1/tL+/LUXDYcveBoEItQqJGrHGU/S1l5VvpoJaZOjHef+h9wHdfXn/IMXI+A6tOnqDG/paI0n0/0iA+2NcUI0cHoPPPIpnS23QlCH9eQ+8oXu8mH2oDdPojK0lPpj9VJmcn5GL5quPCvc41uL0GfFG/14AE3cA1oY23yO5LBjlor0oWu8HTLyHX/P7gmYP/JaT1ye9+gzBBBqKfi+S8RmDN/KCSZ4tDEfOJshsGqC7FPww3tz2eEEiuChVDupgcBCJO6/V6NIOnj/Brhy9lIoa9MPpsqecZKfup08ANkB1QPCGDL+zidaRtbUh/t4094V3zOh1F4vekKXD7cZ5sXIxQXd3gp/ZUlsmUKgVWOAY3Frhj2dkf9FjEjqmlgWrnbC/Hq4VScbeU4mMyxxqGHLP2gny3O007iqKGHi1EfGmvb2z4iS4jAPn5n6dpg7LlVrBfBW55gJDl3H3UVX7ormZ4fg7BZFINZyoudSPKjSFOPUuPnyBtgsSpG5OZV0kZPaj84IFPDysFlc7zOEEvB8aUC1pjD0HLeYjGqd3c5gxgbmVfacvdjh0KKlhylqohAP0c2gk5bYUjxrRlujhCYlZbYALy5WUtDEDkvMvYSjE69Gv6yg8EYLzwoHhZWgXZm4Qw38kg8GvCKe1YHURy25PgccKgaSo8V5ji23iF+LGYPZL4kQhbHLLd8ogbFdpL31uafkf0qKLK5Y0g9faGqeOmGD6XEZUHzBDQWz5v0oca605gEie+RzLT1onzT7o6rIIjyx7/nuq55AiUFywnO4ZY0uomdmclJIvjKYENQkvwQrdkuJlBuq2sAQ+dNDytICp+3henWPrfQSta972+z27Kt+++X5YKPRFy2ocJ86iQCNpFCqmRv599uFCvkvSwobxYX0kgMTDwzt0J0TN0zdwtTPcNju/gyYJP3nIYu6ZGIz6x4MeZGsNGg
 1XSfo1q2
 Z4uUmmniiKkFpsF+OCedFawOcHKGSUpKr1BZGsq6PTQB9n/SfBpxRh3cRNYJJPTPTy6KvuftaD4BX7XGqiw8gLwZh/Bnvvh58KDir8mncMDu/Jm3Bd3HAzJs8oWF14Iu3HMnXrZsHkwW4BZFA+g8hf7ELFNdVQF/1YeuMES/Ci1kuNdjP5kkkeyBehJIl2/VXtXMrH0Qs3RNM5U4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 151a134a4e6ec66f69db8750c66006f5207f7a9d  Add linux-next specific files for 20261027

elapsed time: 865m

configs tested: 137
configs skipped: 9

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
arc                   randconfig-1000-20261028    gcc-8.5.0
arc                   randconfig-1001-20261028    gcc-15.3.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261028    clang-24
arm                   randconfig-1001-20261028    gcc-10.5.0
arm                   randconfig-1002-20261028    gcc-11.5.0
arm                   randconfig-1003-20261028    gcc-8.5.0
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261028    clang-24
hexagon               randconfig-1001-20261028    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261028    clang-22
i386        buildonly-randconfig-1001-20261028    gcc-13
i386        buildonly-randconfig-1002-20261028    clang-22
i386        buildonly-randconfig-1003-20261028    clang-22
i386        buildonly-randconfig-1004-20261028    clang-22
i386        buildonly-randconfig-1005-20261028    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261028    clang-22
i386                  randconfig-1001-20261028    gcc-13
i386                  randconfig-1002-20261028    gcc-14
i386                  randconfig-1003-20261028    gcc-14
i386                  randconfig-1004-20261028    clang-22
i386                  randconfig-1005-20261028    clang-22
i386                  randconfig-1006-20261028    clang-22
loongarch                          allnoconfig    clang-20
loongarch             randconfig-1000-20261028    clang-20
loongarch             randconfig-1001-20261028    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                 randconfig-1000-20261028    gcc-9.5.0
nios2                 randconfig-1001-20261028    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261028    gcc-15.3.0
parisc                randconfig-1001-20261028    gcc-9.5.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261028    clang-24
powerpc               randconfig-1001-20261028    clang-24
powerpc64             randconfig-1000-20261028    gcc-10.5.0
powerpc64             randconfig-1001-20261028    clang-19
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1001-20261028    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261028    clang-21
sparc64               randconfig-1001-20261028    clang-20
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261028    clang-19
um                    randconfig-1001-20261028    gcc-12
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261028    clang-22
x86_64      buildonly-randconfig-1001-20261028    clang-22
x86_64      buildonly-randconfig-1002-20261028    gcc-14
x86_64      buildonly-randconfig-1003-20261028    gcc-14
x86_64      buildonly-randconfig-1004-20261028    gcc-14
x86_64      buildonly-randconfig-1005-20261028    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261028    gcc-14
x86_64                randconfig-1001-20261028    clang-22
x86_64                randconfig-1002-20261028    clang-22
x86_64                randconfig-1003-20261028    clang-22
x86_64                randconfig-1004-20261028    clang-22
x86_64                randconfig-1005-20261028    gcc-14
x86_64                randconfig-1006-20261028    gcc-14
x86_64                randconfig-1007-20261028    gcc-14
x86_64                randconfig-1008-20261028    clang-22
x86_64                randconfig-1009-20261028    clang-22
x86_64                randconfig-1010-20261028    gcc-14
x86_64                randconfig-1011-20261028    gcc-14
x86_64                randconfig-1012-20261028    gcc-14
x86_64                randconfig-1013-20261028    gcc-14
x86_64                randconfig-1014-20261028    gcc-12
x86_64                randconfig-1015-20261028    gcc-14
x86_64                randconfig-1016-20261028    gcc-14
x86_64                randconfig-1017-20261028    gcc-14
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261028    gcc-11.5.0
xtensa                randconfig-1001-20261028    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

