Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BACCCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 03:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BA06B0088; Fri, 16 Oct 2026 23:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DEF6B008A; Fri, 16 Oct 2026 23:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2556B6B008C; Fri, 16 Oct 2026 23:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0EA36B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:00:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37961C012A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:00:19 +0000 (UTC)
X-FDA: 85330614558.14.9592BF8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5551E140006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:00:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MB3CTKqP;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792206017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=u872lPv/kjcJ/WRcgwNqrV6ImQeskciYC3NKoPNf3JM=;
	b=BuCtOptlS8FRPqUv8w2NzWp/mvCUtEyX12s3IbgKJ0qvNJtsqrefXnx0Lod6B+lmb9IE3C
	isNIC26cjfQEsK9/h1ztl3hzTiv7V9gEBKOvugbTre7Vn0u814W1vPsIEbN3XIYCmzlKCL
	aTV62O0f/Q3m8uXanW23inklL6A4Q/Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MB3CTKqP;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792206017;
	b=DO/8qRBvx4Wi9+0LdpLnnyp17W40CwDO4GGdTlyHtF4y7hCpP+ywnXbDbQcJIiNtMk2hZy
	breS6UUh1JALGzFSsJSD5WFznp7M3r2phFeqcZT2nLatjpllXjz4+QNPlr2qzyeN5DWmuS
	/Xz8/4hmh6ifFcAtMrLVIUv4XqluyS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792206016; x=1823742016;
  h=date:from:to:cc:subject:message-id;
  bh=yhkxpKG7hbFe7QFxlmahDP4c51CYA/HTlvgm6wjdRbg=;
  b=MB3CTKqPdWfAMfbsDhUYvuU94krawxoSmyIhLDjvVR7kLvDH9Jn+DWA7
   ilNYdMMyfhBmXFSyepmhVn7Ur0mQuUQ9JS8Fjh+hL7B0Soiq2YZu0Qakz
   /dmi+M54c0Wku3hkVS4PEQ/QAOuSnCXOLMohX7lpHABl4D1dMg+S33pac
   Te0LA/uBMI4zukg/5kVLVuJ/UIDkIobByIPDojrP9c6a2bOrJ4ktKnhCQ
   kYo2w9r4cmyw4HP9Ey/8f5CFwl6ySWBmFvjukVqf9C8cOA9YGxbz0AlM6
   oAzNhdr7T1zoFNsBRw2tNZQulguUHG2dipKhD8IWurwitLMw0a75+G2GP
   g==;
X-CSE-ConnectionGUID: JbNCgliJSo2IFTX8v6q/jQ==
X-CSE-MsgGUID: A8odlxjZS1K6Yi8W/RstNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11937"; a="1090295"
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="1090295"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 20:00:15 -0700
X-CSE-ConnectionGUID: NN3EKJJKSDeys0y3LUpJQg==
X-CSE-MsgGUID: 7Uv9Dm1WT+e1EagwLGq+sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,163,1787036400"; 
   d="scan'208";a="2144040"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 16 Oct 2026 20:00:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHueY-00000000IzS-40RJ;
	Sat, 17 Oct 2026 03:00:10 +0000
Date: Sat, 17 Oct 2026 10:59:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
Message-ID: <202610171013.FZ7lgaJX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: gjk338o7ngqaskgoyzrmmio43r6ond11
X-Rspamd-Queue-Id: 5551E140006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792206016-730615
X-HE-Meta: U2FsdGVkX18jqcayCe+Xda4lxmpyO9Mv3A7CtgoF9cZJMNYl4QPjYmy69QmvC6OrvTTg+CbcwFipn6H4lhEkC2Wgv+kLfOdb8wXIpwuVvK4riRO2pD+wDr4u7AlLZRVejFtLfM7hrfMPQZaacNQqqJx7Fka+pRJXWdPXSSpMpUMQTmVbKqf+wr+Q/W13pJXkBTNNpBYTh4j9a6YwcQ9sV6URIdhL/CrIvwskI4N8Q2ySCVhfuaelEubneN1EeYz4jfAP89uPocrWe4WwiKcD15oLXW/5jsElZF1oIgDTYRRq1eJmS0a/Id4aVzGIyOl3Wwd7/oujKToPFZT3ckXE2M0ZoyawydxnuhS5DQUpfQN5nqk9ZCOUnCsmppzZp9a5RNSweIcWg0Xkaio2+m8FdJ2hM4PE1hmpEuXRgLlX6Fwpque1m4bqWKG9/4ZAlQGVYF47omLFOet7ynrbU6byXRDb9WpBIIdPs++4u0I2p6BApcgDU5Eqk+i6WRrBcCJrwB3ERsTxdmy76C0Fu+uapz/yG2dAsupiSRbpwpiLCqWdpmgljl78KUVcGTP896uKcPX4k1YH+ORBzgt0OU7i1w4HA9gBaVBSSiaCJc2hAtnJP0u1yBOjQRpaAmMPq0ePlLmacWRfq/tp/MjGwoPeY/v1hFCqxRXP/yIpa4pKMtwGwRf/M299CDiYFGuGQK5pDSXiuo2SSpKaXkw4Zbi7g4mp2PVMxZBGwXZl+hs8mLqjoVlzSsLDAG3OvpupEXPhRmn4OSplSxk3i/InvaaBmpJEZEzen/3dn36qnMJaf2CEd3N1pDx+Bz5G01ZxeTfQSFOcfxk2D4YVS0EvhrW8JuIXrt3XLRafR4MI3GZ4/Ahk3BJBSi9mKyBvJXo/yQPRQ9Gboc65t9iD4RrWWrXZICfrJPb6cgBuwXY/925Zn2mHIoblmjvs1/he1IPlpoxy3mt5zty44wqoYdfNpHx
 bkv3gNEq
 YulCrQ0s6gQG+vSxC02uMFSO3MHySTWotebn1o/MmRzBiujQLN64FH3nHbKo+UQCAomuUXQ3xpWkHWCiDNi6pTGbfCPrVH2Q8L+N2u7SPUm6ec55mrwTVe2pEHe5YNVblf1ksg5KqF7f7B37oIOwAoZmyjpFK2nVsFYUErQKh1Z9VsSd0W+B/79Jl5IkBDCkqLhdwprnx3ylUBtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596  riscv: mm: exclude invalid THP PMDs from page table check

elapsed time: 804m

configs tested: 245
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2202-20261016    gcc-15.2.0 smatch
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261017    gcc-12.5.0
arc                   randconfig-1001-20261017    gcc-10.5.0
arc                   randconfig-2000-20261016    gcc-8.5.0
arc                   randconfig-2001-20261016    gcc-8.5.0
arc                  randconfig-r2107-20261016    gcc-8.5.0  cocci
arc                  randconfig-r2305-20261016    gcc-13.4.0 sparse
arc                  randconfig-r2308-20261016    gcc-15.2.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                          lpc18xx_defconfig    clang-24
arm                             qcom_defconfig    clang-24
arm                   randconfig-1000-20261017    gcc-8.5.0
arm                   randconfig-1001-20261017    clang-20
arm                   randconfig-1002-20261017    gcc-10.5.0
arm                   randconfig-1003-20261017    clang-22
arm                   randconfig-2000-20261016    gcc-12.5.0
arm                   randconfig-2001-20261016    gcc-8.5.0
arm                              rpc_defconfig    clang-19
arm                            sunxi_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261016    gcc-8.5.0
arm64                 randconfig-1001-20261016    clang-19
arm64                 randconfig-1002-20261016    gcc-8.5.0
arm64                 randconfig-1003-20261016    clang-17
arm64                 randconfig-2000-20261016    gcc-13.4.0
arm64                 randconfig-2001-20261016    clang-18
arm64                randconfig-r2100-20261016    gcc-9.5.0  cocci
arm64                randconfig-r2310-20261016    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261016    gcc-13.4.0
csky                  randconfig-1001-20261016    gcc-11.5.0
csky                  randconfig-2000-20261016    gcc-16.1.0
csky                  randconfig-2001-20261016    gcc-12.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261016    clang-24
hexagon               randconfig-1001-20261016    clang-17
hexagon               randconfig-2000-20261016    clang-22
hexagon               randconfig-2001-20261016    clang-22
hexagon              randconfig-r2103-20261016    clang-17   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261017    clang-22
i386        buildonly-randconfig-1001-20261017    gcc-14
i386        buildonly-randconfig-1002-20261017    clang-22
i386        buildonly-randconfig-1003-20261017    gcc-14
i386        buildonly-randconfig-1004-20261017    clang-22
i386        buildonly-randconfig-1005-20261017    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261017    gcc-14
i386                  randconfig-1001-20261017    clang-22
i386                  randconfig-1002-20261017    gcc-14
i386                  randconfig-1003-20261017    gcc-14
i386                  randconfig-1004-20261017    gcc-14
i386                  randconfig-1005-20261017    gcc-14
i386                  randconfig-1006-20261017    gcc-14
i386                  randconfig-1007-20261016    clang-22
i386                  randconfig-1008-20261016    gcc-14
i386                  randconfig-1009-20261016    gcc-13
i386                  randconfig-1010-20261016    clang-22
i386                  randconfig-1011-20261016    clang-22
i386                  randconfig-1012-20261016    gcc-14
i386                  randconfig-1013-20261016    gcc-12
i386                  randconfig-2000-20261016    clang-22
i386                  randconfig-2001-20261016    clang-22
i386                  randconfig-2100-20261016    gcc-14     cocci
i386                  randconfig-2101-20261016    clang-22   cocci
i386                  randconfig-2102-20261016    clang-22   cocci
i386                  randconfig-2103-20261016    gcc-14     cocci
i386                  randconfig-2104-20261016    clang-22   cocci
i386                  randconfig-2105-20261016    clang-22   cocci
i386                  randconfig-2200-20261016    clang-22   smatch
i386                  randconfig-2300-20261016    gcc-14     sparse
i386                  randconfig-2301-20261016    clang-22   sparse
i386                  randconfig-2302-20261016    clang-22   sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261016    gcc-16.1.0
loongarch             randconfig-1001-20261016    clang-24
loongarch             randconfig-2000-20261016    gcc-16.1.0
loongarch             randconfig-2001-20261016    clang-18
loongarch            randconfig-r2304-20261016    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2104-20261016    gcc-8.5.0  cocci
microblaze           randconfig-r2105-20261016    gcc-12.5.0 cocci
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261016    gcc-11.5.0
nios2                 randconfig-1001-20261016    gcc-8.5.0
nios2                 randconfig-2000-20261016    gcc-8.5.0
nios2                 randconfig-2001-20261016    gcc-11.5.0
nios2                randconfig-r2309-20261016    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2301-20261016    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261016    gcc-15.2.0
parisc                randconfig-1000-20261017    gcc-10.5.0
parisc                randconfig-1001-20261017    gcc-8.5.0
parisc                randconfig-2000-20261016    gcc-8.5.0
parisc                randconfig-2001-20261016    gcc-10.5.0
parisc               randconfig-r2307-20261016    gcc-8.5.0  sparse
parisc               randconfig-r2311-20261016    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       pmac32_defconfig    clang-24
powerpc               randconfig-1000-20261017    clang-17
powerpc               randconfig-1001-20261017    gcc-15.2.0
powerpc               randconfig-2000-20261016    gcc-11.5.0
powerpc               randconfig-2001-20261016    gcc-9.5.0
powerpc64             randconfig-1000-20261017    clang-20
powerpc64             randconfig-1001-20261017    gcc-8.5.0
powerpc64             randconfig-2000-20261016    clang-24
powerpc64             randconfig-2001-20261016    gcc-8.5.0
powerpc64            randconfig-r2110-20261016    gcc-16.1.0 cocci
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261017    clang-19
riscv                 randconfig-1001-20261017    clang-24
riscv                 randconfig-2000-20261016    clang-24
riscv                 randconfig-2001-20261016    clang-24
riscv                randconfig-r2102-20261016    gcc-9.5.0  cocci
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261017    clang-24
s390                  randconfig-1001-20261017    clang-24
s390                  randconfig-2000-20261016    clang-24
s390                  randconfig-2001-20261016    gcc-8.5.0
s390                 randconfig-r2108-20261016    clang-24   cocci
s390                 randconfig-r2303-20261016    clang-17   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                           landisk_defconfig    gcc-16.1.0
sh                           lboxre2_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261017    gcc-16.1.0
sh                    randconfig-1001-20261017    gcc-10.5.0
sh                    randconfig-2000-20261016    gcc-16.1.0
sh                    randconfig-2001-20261016    gcc-12.5.0
sh                   randconfig-r2106-20261016    gcc-14.3.0 cocci
sh                   randconfig-r2111-20261016    gcc-15.2.0 cocci
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261016    gcc-16.1.0
sparc                 randconfig-1001-20261016    gcc-15.2.0
sparc                 randconfig-2000-20261016    gcc-16.1.0
sparc                 randconfig-2001-20261016    gcc-12.5.0
sparc                randconfig-r2200-20261016    gcc-8.5.0  smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261016    clang-20
sparc64               randconfig-1001-20261016    clang-24
sparc64               randconfig-2000-20261016    clang-24
sparc64               randconfig-2001-20261016    clang-24
sparc64              randconfig-r2109-20261016    gcc-13.4.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261016    gcc-14
um                    randconfig-1001-20261016    gcc-14
um                    randconfig-2000-20261016    clang-17
um                    randconfig-2001-20261016    gcc-14
um                   randconfig-r2101-20261016    clang-24   cocci
um                   randconfig-r2300-20261016    clang-17   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261017    gcc-14
x86_64      buildonly-randconfig-1001-20261017    clang-22
x86_64      buildonly-randconfig-1002-20261017    gcc-14
x86_64      buildonly-randconfig-1003-20261017    gcc-12
x86_64      buildonly-randconfig-1004-20261017    clang-22
x86_64      buildonly-randconfig-1005-20261017    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261017    gcc-14
x86_64                randconfig-1001-20261017    clang-22
x86_64                randconfig-1002-20261017    clang-22
x86_64                randconfig-1003-20261017    gcc-12
x86_64                randconfig-1004-20261017    gcc-14
x86_64                randconfig-1005-20261017    gcc-12
x86_64                randconfig-1006-20261017    clang-22
x86_64                randconfig-1007-20261017    clang-22
x86_64                randconfig-1008-20261017    gcc-12
x86_64                randconfig-1009-20261017    gcc-14
x86_64                randconfig-1010-20261017    gcc-13
x86_64                randconfig-1011-20261017    clang-22
x86_64                randconfig-1012-20261016    gcc-14
x86_64                randconfig-1013-20261016    gcc-12
x86_64                randconfig-1014-20261016    gcc-14
x86_64                randconfig-1015-20261016    gcc-14
x86_64                randconfig-1016-20261016    clang-22
x86_64                randconfig-1017-20261016    clang-22
x86_64                randconfig-2000-20261016    clang-22
x86_64                randconfig-2001-20261016    gcc-14
x86_64                randconfig-2100-20261016    gcc-14     cocci
x86_64                randconfig-2101-20261016    clang-22   cocci
x86_64                randconfig-2102-20261016    clang-22   cocci
x86_64                randconfig-2103-20261016    clang-22   cocci
x86_64                randconfig-2104-20261016    clang-22   cocci
x86_64                randconfig-2105-20261016    gcc-14     cocci
x86_64                randconfig-2200-20261016    gcc-14     smatch
x86_64                randconfig-2300-20261016    clang-22   sparse
x86_64                randconfig-2301-20261016    clang-22   sparse
x86_64                randconfig-2302-20261016    clang-22   sparse
x86_64               randconfig-r2201-20261016    gcc-14     smatch
x86_64               randconfig-r2302-20261016    clang-22   sparse
x86_64               randconfig-r2306-20261016    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261016    gcc-11.5.0
xtensa                randconfig-1001-20261016    gcc-9.5.0
xtensa                randconfig-2000-20261016    gcc-12.5.0
xtensa                randconfig-2001-20261016    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

