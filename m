Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD003606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dtlYIa9D
Received: by kanga.kvack.org (Postfix)
	id E4E956B0916; Thu, 22 Oct 2026 07:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF996B0918; Thu, 22 Oct 2026 07:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C0F6B0919; Thu, 22 Oct 2026 07:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA7CE6B0916
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:46:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A40E6C07D0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:46:04 +0000 (UTC)
X-FDA: 85350083448.23.E7C583C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4AF320006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:46:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dtlYIa9D;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669562;
	b=sl9bq4xZWpdrUJb0ghNM6D2Mk//48D1DxlZHi+PSLO4FF7KfYunOoWz0xH8ddDbmABUfLc
	fLjCYUf7485HtOABxLugKbugP6QYnBpMZc0iVRQ0+I4dmC2pNOEdqhyruWPqN1X8ZX3kYx
	0/yNEX3FRsRoyES4va5xDuGJi8WBCcs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dtlYIa9D;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=USbtgh62wFC1WQ6cU2P1Xc6e6Ra4Ga/3qKN+14Dq2pQ=;
	b=F5RqT/SZbDiqnGhMdqvR+Z9BoDNyV/kuAVy4ggin0AE7t9f6ABLv+cCnrMq3FG4qU2jUn2
	/YwFFVjndIAt+rBmw7dFac3bi8ft42UoELYeGvP0hXTSmq2H1yxGk6WShgGQ6LjABeIBsv
	vJSsFf8xnnHCxRWnqtctwAf7wk46fz8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792669562; x=1824205562;
  h=date:from:to:cc:subject:message-id;
  bh=HKxHSVHqAYPZmYpFDbYDrsW4NXQmpQX1pMNdm1jLBBo=;
  b=dtlYIa9D2SAuTRkGfMA7lwbWV6ghr89lOxntc9lnK/l7fxOEjIYD66er
   5PLr9iLpgWKUHAYhltp8iq8DIpLbKXRGGsOcocZLIHDnL5xtRaJbbaFf6
   i7pEps0oJo9Vhwa3Ot8pxnIiuQqRlqQUm6ParjcqANuOCwmDxZErJayt5
   QaNdAIDY/WQ7+MJHc093Dgy7TqZKYPLhmnX4cWzUels+MtX1zk2g9dmrz
   Ig/G3TjPbrXuuGYRkIt6NV22llCK8+zAvntm9nEid1Vm7wq2hD4hLKqVS
   Kn3zCUhdVpGla+lXEZL/x0PfAACVRYx1wvLl8nfHHKFjA4yuBn3oIl6zi
   g==;
X-CSE-ConnectionGUID: cdp9kLndTx6aSHzEVckMWA==
X-CSE-MsgGUID: WVr4aE1kTFCNE9nt8KfeWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1424312"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1424312"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 04:46:00 -0700
X-CSE-ConnectionGUID: fc1UzM6aQ0u7TltgRva7Nw==
X-CSE-MsgGUID: k0aPXvojR7Gbvol0ptSk8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3733808"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 22 Oct 2026 04:45:58 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJrF5-00000000QzS-3xIi;
	Thu, 22 Oct 2026 11:45:55 +0000
Date: Thu, 22 Oct 2026 19:45:52 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
Message-ID: <202610221944.PBO9ny7O-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: nbx5w6sucakonty9jowsef4inmj7nzzb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4AF320006
X-Rspam-User: 
X-HE-Tag: 1792669561-456951
X-HE-Meta: U2FsdGVkX1/DiehsD/6XijKpKJoMZuYeOc893dpOk3qGzI9gt/Lf8Do36AcPi79Bo0XMhwfb8e+SbRV8G5xx182G2oBC7AKEzEjHkxzqGi3kCdtQv/my1edzEY1RfwPlx8lfALKLZw+HBI1tBjn4ZQqcYmAD712S7DYl/1m1Tj7o4PwmvLTsYnA9sd+GVpoLu4Ta5ECf+jaZ/mayuPmK5zE2YNlkI+nOIbnKAxBqBG5+YS5tAfuhJwFEuOTdArXdBtLu/pD6yP5Kl6RyzeHoVSCC8/KA7RSaW7SFD3JwUkLOMuKv641szaHbiSNVX+10AcviuGruzQqyhszK4j6U5YH+NSe3q+wKMWHiIOkXTfXbw7hoyf9fF7Xaknlw/5VUiYStrvQvB+snN1LdOdU7VIjSRcISMsS3amXo/GT5Zv5e338umso1D91ZY4851JuLyJT2E64Yo1iEr62nVYF9MxhZV6s6doDtZrFxLb8YHyzK9chvVNUGvXWC5onN1VfE+PLDxV5vko+AU2JZPXrfR83eauYn1tTItWXkOBlT6CcyoOklNQxa/ofuAVuPwjWrRYUXbYvasoLk2u9mxBN2lKWYackjmubD/riEjMyZKxXrIRPZ6kKopdQzE2cFtRxzVx3uge0JWkeKz+6dHvgOKbFEMFDqxAKerrCyQJMTzhdyicogbTgmhQmivwLodoVprXvQkFTf0EquTH6L3JSfdXg4ines2qpWfPRgkAxdgPW8r2xE3tm2BfEq0jcIk0B5HcqfO/T1OiIU8y2WfILh5sICnwTOgTQTrtFguWdmwgC9WbUi48jLZNCbiurxttbDxYFdLWjBRN1bHtXCeYuPmXX2yowKkzHVLrJNRx+jhZYrlOM4VdJwSMPhoEIGlaLNb6blcUI4ehReA+sIIitw6LGxjDNX7+MUv3vKIH+Hii7SNynDt4u53zJgYhB3A+qyUftIa+tG9XpAQbjPebb
 poaU26sc
 zPIe3+A7vhemekjA75clHJR+u0EU4i6e6AJxvCCMyMTQ3GUFlPgZ5do1/vV2bE6IjrOpHmS/H0WsUzpmqy6YnpJmqbD5+b+0QOskON0fKckaDXAljXOldDiiSUovBLCNs0zvKj/N18ttIGCZICe/7h6MMYlitK6LHQXtGV0BgmJT6/a+Zfyr1xmG9bmlPgQZLaU0/YYNrnc5Jn1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1542m

configs tested: 162
configs skipped: 8

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
arc                   randconfig-1000-20261022    gcc-11.5.0
arc                   randconfig-1001-20261022    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                           collie_defconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                   randconfig-1000-20261022    gcc-10.5.0
arm                   randconfig-1001-20261022    clang-21
arm                   randconfig-1002-20261022    clang-17
arm                   randconfig-1003-20261022    clang-19
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261021    clang-21
arm64                 randconfig-1001-20261021    gcc-13.5.0
arm64                 randconfig-1002-20261021    clang-24
arm64                 randconfig-1003-20261021    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261021    gcc-16.2.0
csky                  randconfig-1001-20261021    gcc-10.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261021    clang-24
hexagon               randconfig-1001-20261021    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261021    gcc-14
i386        buildonly-randconfig-1001-20261021    gcc-14
i386        buildonly-randconfig-1002-20261021    gcc-14
i386        buildonly-randconfig-1003-20261021    clang-22
i386        buildonly-randconfig-1004-20261021    clang-22
i386        buildonly-randconfig-1005-20261021    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261021    clang-22
i386                  randconfig-1001-20261021    gcc-14
i386                  randconfig-1002-20261021    clang-22
i386                  randconfig-1003-20261021    gcc-14
i386                  randconfig-1004-20261021    gcc-14
i386                  randconfig-1005-20261021    clang-22
i386                  randconfig-1006-20261021    gcc-14
i386                  randconfig-1007-20261021    clang-22
i386                  randconfig-1008-20261021    gcc-12
i386                  randconfig-1009-20261021    gcc-14
i386                  randconfig-1010-20261021    clang-22
i386                  randconfig-1011-20261021    clang-22
i386                  randconfig-1012-20261021    clang-22
i386                  randconfig-1013-20261021    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261021    gcc-15.3.0
loongarch             randconfig-1001-20261021    clang-21
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                           multi_defconfig    gcc-16.2.0
m68k                          nettel_defconfig    gcc-16.2.0
m68k                           sun3x_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261021    gcc-11.5.0
nios2                 randconfig-1001-20261021    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261022    gcc-8.5.0
parisc                randconfig-1001-20261022    gcc-15.3.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       chrp32_defconfig    clang-24
powerpc               randconfig-1000-20261022    gcc-14.4.0
powerpc               randconfig-1001-20261022    clang-24
powerpc64             randconfig-1000-20261022    gcc-12.5.0
powerpc64             randconfig-1001-20261022    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261021    gcc-13.5.0
riscv                 randconfig-1001-20261021    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261021    clang-24
s390                  randconfig-1001-20261021    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261021    gcc-16.2.0
sh                    randconfig-1001-20261021    gcc-10.5.0
sh                           rsk7203_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261021    gcc-16.2.0
sparc                 randconfig-1001-20261021    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261021    gcc-8.5.0
sparc64               randconfig-1001-20261021    gcc-11.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261021    clang-24
um                    randconfig-1001-20261021    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261021    gcc-14
x86_64      buildonly-randconfig-1001-20261021    gcc-12
x86_64      buildonly-randconfig-1002-20261021    gcc-14
x86_64      buildonly-randconfig-1003-20261021    gcc-14
x86_64      buildonly-randconfig-1004-20261021    clang-22
x86_64      buildonly-randconfig-1005-20261021    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261021    clang-22
x86_64                randconfig-1001-20261021    clang-22
x86_64                randconfig-1002-20261021    gcc-14
x86_64                randconfig-1003-20261021    gcc-14
x86_64                randconfig-1004-20261021    gcc-14
x86_64                randconfig-1005-20261021    clang-22
x86_64                randconfig-1006-20261021    gcc-14
x86_64                randconfig-1007-20261021    clang-22
x86_64                randconfig-1008-20261021    gcc-14
x86_64                randconfig-1009-20261021    gcc-14
x86_64                randconfig-1010-20261021    gcc-13
x86_64                randconfig-1011-20261021    clang-22
x86_64                randconfig-1012-20261021    gcc-14
x86_64                randconfig-1013-20261021    gcc-13
x86_64                randconfig-1014-20261021    clang-22
x86_64                randconfig-1015-20261021    gcc-14
x86_64                randconfig-1016-20261021    clang-22
x86_64                randconfig-1017-20261021    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261021    gcc-14.4.0
xtensa                randconfig-1001-20261021    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

