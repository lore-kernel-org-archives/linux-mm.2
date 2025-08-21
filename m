Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5E7CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859BE6B0012; Thu, 21 Aug 2025 10:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCA56B0024; Thu, 21 Aug 2025 10:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2396B009E; Thu, 21 Aug 2025 10:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 596926B0012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AA2C138519
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:22:23 +0000 (UTC)
X-FDA: 83800979766.14.AAFC5A7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6806D140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:22:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EX/NI+Ex";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755786141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=m2pZ9Qz7mwU6NFQdwPTWkmmlBR2RzYWTBksN1R5Vxnc=;
	b=xUNu8hdPVKpqwbugUcUJMq9jGmokD9HQVxrq7SksuSR8W6jcVP9YkDqhMAWSoTnAh7xQ3q
	SVquU+IRWGlRcV1KKJccClxsokg/w6Pv52ssk8Q1JuFp3jmtJJfbU7LCf+hmnyUrj7FrBE
	Ef1T6xa1oR84CmN3sS/MgZi4URIgsCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755786141; a=rsa-sha256;
	cv=none;
	b=fVVzh2FACpSgqs50b2QbVSLKTXwW1hVK3SBSnhRL5r3o3Uh9GFlJOpxaa/7qISqSAfFQNW
	KzvLUZC5QA3+Yi3QlIWz55KFIZwWOZjNgQYZDPZl4VHOnWI8L6LKdAkjLemFElET4NS6Lg
	ALvMPi6Vhdh1CR3UBmn8Q55146T0Z1g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EX/NI+Ex";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755786141; x=1787322141;
  h=date:from:to:cc:subject:message-id;
  bh=nNLHFFtnJBvf/gV/erGpubCXZGvefm8Q7z+MeMwpG2Q=;
  b=EX/NI+Ex03MI7cwykaTF6lPrgp05Q/NYzivL1i4TUDMhWbZVuqm1bbd0
   +j6wBUCRzqMVtDUMG3DF5OwdmByW1j0GAcLD4hRqYA+isUaZmxpbBe5iH
   fS+LzYyyyTjXaANPv2mWMBaFIp9dy+HD+M2DDZWwCI0yoDtT20wBnjL7b
   XKsfO09BC5HGBzsvPO147CUwKHiaHkTxopkWsoMtrFLDyFV9qIMQKcJGy
   UIOu1Y4GxH0RoqjDnEfSiODJFy7nJqaY9EHWx8HjBtjmfVRHejZeKYDDp
   QltX1sIKhaJ4uE6EJLXxvM/rzTqUEg4lfZ4d/FsaAy7OPa+pg8t5ctZyz
   A==;
X-CSE-ConnectionGUID: kemk7jcpTFmw56idYUa6ew==
X-CSE-MsgGUID: n1xCw/kYRLq701LiIT5/CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="45649748"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="45649748"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 07:22:19 -0700
X-CSE-ConnectionGUID: rbHTZK2zRkOaaKituJgkkQ==
X-CSE-MsgGUID: c9bBwDPQS0mLaNzX1ttDIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="167668134"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 21 Aug 2025 07:22:15 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1up6Ai-000KLx-2i;
	Thu, 21 Aug 2025 14:21:57 +0000
Date: Thu, 21 Aug 2025 22:15:30 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 4647c4deadcc17f40858be06bcf416369a8f1d57
Message-ID: <202508212221.qg9V6P14-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6806D140003
X-Stat-Signature: xg11zy5tbm3fgu99e7t643dsq6si6a76
X-Rspam-User: 
X-HE-Tag: 1755786140-779093
X-HE-Meta: U2FsdGVkX18n99beL2+zrcWth4z/k5PQPgKkanZmTf6MnSjRNnUQa+YMga+SKx6i3sV6skgoCLN1HtR86czp1zyFyJx19s5mORukYzWdNTinlajeoJfakCL1HBKhzm7FN6xu3cT4kjOhzCTgOtwD62loiF5CXhREPgX/1O/rSDxy/VwkvKu5RI6fk6ngj7Vsml8HmyaAi5BrUbN/52/ZvfhWKtM5QmybGVB2AEa4g6xO0Wp24w0Azv4hZhv+cyR+eRaBbrSiQ8Hl1TeZCFqiE71FlWG5oT/UlrFQlbJj179bbAqHzSpNSZBvviT9K3SsMqkinhX/RMHmQvriVEYPPApCjD1kIaM8HUMYR+SoQYF776p4fV9QZe1Si5ewBythZvpf3v7f/li5P2+dUlyBGMUm1PeWWI7DaPh2h1CVoeWHa0WL+swW7SxDt7QaYMW0ebPJFxmZppCTcTfPP8/ZK2JUG+vmPmJRmPtaK2b0X8+BIG5zbXtL6SDDy/FSYW/eOoLj8FiH7+RLy6XfLTwCmb1Q+uHrz5LDyYSNUJvfSkNe3xueOfYuZG+yZ/H27xINlTtUz4/vGdx6Zdd1f+YBSLfllFiod/WISvANYXhjfBKMWDQiZ5wnebyrN3xirYHye+lJAi+tFkl0OIz7g5VyKD8WPKNY6/JYZ34RFLeVgA51ptpKPL5vwIQzbOsL0DZlMsaRAdBsH31mX70b/K9mtPiwVB/2uW+bxNHSx/JnYiOeonXIUqmPEO2Nx3CQJHwTR+DsHK3L/KOwixernrP2XaBcmb8cG7SL1lsbh+aCOKB9mu0Z9f3JvlDoaJBauXKZGK3jgNdf5OHN+ecU42A3T8sIP6VI7TWQDjtL0rVJFP1KkOKGhJGmAeyUwSrb6oYqfxvoxWmOjSrtUhis0btY2We6jn03baq7iM178g25RQIW5Y6MKzNNKJIpxH8i+f+SqEio+NXeQMv0LNQY5eU
 MnfqnQuy
 3rsIdvY++dkgrWIyWoDdyNTR57kvELaDtxqmcLK4TI0hSLSfTkPfghaqS7W8FSECvWtgqQ4a4QIAbm+XgTWPC6Pg27gF3jCob+8mjy4JtH9gbSYeUjHjIJ+6YvAh/BEFeltHOoBTpK7ygyObnUIK+KdN/ctR32+dQsoRQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 4647c4deadcc17f40858be06bcf416369a8f1d57  mm: numa,memblock: Use SZ_1M macro to denote bytes to MB conversion

elapsed time: 1453m

configs tested: 105
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                   randconfig-001-20250820    gcc-8.5.0
arc                   randconfig-002-20250820    gcc-11.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                   randconfig-001-20250820    gcc-8.5.0
arm                   randconfig-002-20250820    gcc-15.1.0
arm                   randconfig-003-20250820    gcc-13.4.0
arm                   randconfig-004-20250820    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                 randconfig-001-20250820    gcc-14.3.0
arm64                 randconfig-002-20250820    gcc-14.3.0
arm64                 randconfig-003-20250820    gcc-8.5.0
arm64                 randconfig-004-20250820    gcc-14.3.0
csky                              allnoconfig    gcc-15.1.0
csky                  randconfig-001-20250820    gcc-15.1.0
csky                  randconfig-002-20250820    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon               randconfig-001-20250820    clang-22
hexagon               randconfig-002-20250820    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250820    clang-20
i386        buildonly-randconfig-002-20250820    gcc-12
i386        buildonly-randconfig-003-20250820    gcc-12
i386        buildonly-randconfig-004-20250820    clang-20
i386        buildonly-randconfig-005-20250820    gcc-12
i386        buildonly-randconfig-006-20250820    gcc-11
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch             randconfig-001-20250820    clang-18
loongarch             randconfig-002-20250820    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250820    gcc-11.5.0
nios2                 randconfig-002-20250820    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250820    gcc-8.5.0
parisc                randconfig-002-20250820    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc               randconfig-001-20250820    gcc-12.5.0
powerpc               randconfig-002-20250820    gcc-8.5.0
powerpc               randconfig-003-20250820    gcc-13.4.0
powerpc64             randconfig-001-20250820    clang-22
powerpc64             randconfig-002-20250820    clang-22
powerpc64             randconfig-003-20250820    gcc-15.1.0
riscv                             allnoconfig    gcc-15.1.0
riscv                 randconfig-001-20250820    clang-20
riscv                 randconfig-002-20250820    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                  randconfig-001-20250820    clang-18
s390                  randconfig-002-20250820    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                    randconfig-001-20250820    gcc-15.1.0
sh                    randconfig-002-20250820    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250820    gcc-8.5.0
sparc                 randconfig-002-20250820    gcc-12.5.0
sparc64               randconfig-001-20250820    clang-22
sparc64               randconfig-002-20250820    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                    randconfig-001-20250820    gcc-12
um                    randconfig-002-20250820    gcc-12
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250820    clang-20
x86_64      buildonly-randconfig-002-20250820    gcc-11
x86_64      buildonly-randconfig-003-20250820    clang-20
x86_64      buildonly-randconfig-004-20250820    gcc-12
x86_64      buildonly-randconfig-005-20250820    clang-20
x86_64      buildonly-randconfig-006-20250820    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250820    gcc-8.5.0
xtensa                randconfig-002-20250820    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

