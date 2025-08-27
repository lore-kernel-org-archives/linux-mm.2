Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BABBCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A123A8E011E; Tue, 26 Aug 2025 23:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9FE8E0105; Tue, 26 Aug 2025 23:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926B48E011E; Tue, 26 Aug 2025 23:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80C8C8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:36:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48AF713983B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:36:59 +0000 (UTC)
X-FDA: 83821126158.11.24A4303
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF4E1120003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:36:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W/t+IltW";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756265817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=osf2lC7q38sNCnKuyHhBN8JOUYIvz4KkJg1qo705u0E=;
	b=Bv95OQy5BEcs8xWN0sJixFfZawraU5ee0IBMxRoNTTGhTKaVbTWz7r+Vfblih0ZcAN3XaU
	5JuM+bRY1LxH48jG25G+mpZ8IcOvo+c7zIw4lRu3UxKUg8rswUrEEfw22aRs6XkjW2YHHr
	DCOJtB3p/PjSU5G61oug47eaHjw6JKo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W/t+IltW";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756265817; a=rsa-sha256;
	cv=none;
	b=SKYYhQcmie/eyKT8fN628dAGOlnJzT+yneHKF3/euLBERds0RcWsE+MZfUAzR1CySjyyww
	RNXu8OJuV/29unusbnXNJ9aKF0gtatEdiByh5VQEZUvvmh/JtDoHlpeXFxb6vfbIgfs1Ya
	jSt21QaQJ+5crgoB1r8tT3lzuxCduJo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756265817; x=1787801817;
  h=date:from:to:cc:subject:message-id;
  bh=xWpjumiHx1/HDK3jMXqWkS/QwDDbw8/Y4Z9oCeGx3zY=;
  b=W/t+IltW1zGz0XshtaVsotbYSyPWwHUWFhLLQ3vzCPLisfG65DBOApD3
   FOJs2oG4s++xSNZrkD23PoQeHCDKgk/WDRvJFeZO+cyfFf03oEB/inXpI
   uBD5tFC/DG8unApmqx7b+LP9mLRxEcAK6zcloypHgkveYj2vFny5gyjva
   CyR4ZP80JTpLNzpFTvEGXktmG0IOoO3UoMb6hJDX33LL3H2jZCedkHBJb
   zgroYmOeW26PEcuCJhUuLkdhqfpRr7IkG8oFI7mgBMOCX4H3rO0CgEwGO
   oudb4DRBhLtx1O+fR/OBcEtZ4eU1Aq9CgKnn0zugmgLIcW3AnUobjGU7h
   A==;
X-CSE-ConnectionGUID: RpNqpTLfTK6uBJUJoctbRg==
X-CSE-MsgGUID: JR4eULpZQ7K2GhjQCN+QLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69884192"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69884192"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 20:36:55 -0700
X-CSE-ConnectionGUID: HY3T7u3QR2KFH9CHV5Ztrg==
X-CSE-MsgGUID: 3Y/SqUP6R9aEtyQGtafJnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169917853"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 26 Aug 2025 20:36:54 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ur6xF-000SdT-1Z;
	Wed, 27 Aug 2025 03:36:27 +0000
Date: Wed, 27 Aug 2025 11:35:38 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 b3dcc9d1d806fb1e175f85978713eef868531da4
Message-ID: <202508271132.nhmZourN-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF4E1120003
X-Stat-Signature: 1izqisejhgmc9hm4yywyqjb4yqkxkjgy
X-Rspam-User: 
X-HE-Tag: 1756265816-799640
X-HE-Meta: U2FsdGVkX1+OMxo34Vxgl4TkUOhw5tKZ5LDZDWjv9XziKxRXCX50RbzbBb/FO5rCY/aOZ3rUNTXY/Gm88fHLI2wMYPrA/oLixszvbpCJwXdyh7EE0EAIgGdV9vO7Ln7gJaKe1pge0i5/QUq2uB0KgeD0Rc5+rnVd1hb93f69M+4IXJ2MKi7halcr2ncfDvfNiqLmpogAwLtTM6K64ka2TFtkvfn1x5tohSbeg70T0RjqwzL7tV8qTKmTK5GZ3xctqeIcPefLRBLVWSpLYcpMGRs9hwoT+or5KjlnRxxanFLbJl2Hm6mCsQ2CSJCHAIhyRGyTVP3gDyrN4h8jHj3/cQmclGNvRkEzA33CH6Bh3QIqoATDkcTsUTqwk6g/Z7lC4rYodyttbnKcJ4JVtApstbKdWBnY37A+70ICCHELbB92NPYF9oq6OLzi4WollkwXgH523QSv7flQ8D2EllNXmuGyhzqU8RGs3DJzIxk00inwJAxUYhMghiY7VZRtF1XrFKFyixm9HweWHPcerMFDosgIprd9QhCBcGArjAIK6hmM0/g8ltIFwMAEhJMAqtX0V4CkW7hPF5/zfRNwX4h1z1z46mtgPtfDvd8nqEnqK9qhigjvrDU36zKvXFDdBRf+k+OHHYJ0BpVZAJb0k1thjj/CYaJkpiiGhlUwB9L7P2bCNzLYPETpHEJzW6oPKCBy3fdn8S5B1Y8istgWRv6yXyLZeOQiWdAcbRvB7VUBdVHzktra5vcUiXjMXU/Q6mUo10KSWLvgQ9XiBOetYHSS+HFAEIwpX4dHTZScssjEa+aKmrBwF9mOtYooiLH7+nej6inxWJAL5Nwgv1u/dGjcYrIJBVVUlbGfiqZg7znoLUFxKG+0sFBJ43JO75OPVL7Ik0M8DDj4vEUMhkOnoF5r5DhXAeCmRyS6AEKqCLswUO82DesGvcVMqKzhBexcK/4eBAcwxjrNAwCQYogFvvG
 rv/E5Swr
 Rxcto1gfGIAlVds/1C8nAPoXRS22GQfy4ZO3XL6eHruI/WejfZvcsJlxoswcyD3QoNoa2SGrEw5X6spf8p7hcNj6hTTdsOZGmG/nPNW/Zw0DhzsVQi9j8vPEv5dqAc5ax4Orvyhl7RSxwigMGoWg+e1xPtD+c2V1nYl//
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: b3dcc9d1d806fb1e175f85978713eef868531da4  memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT

elapsed time: 1154m

configs tested: 134
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                          axs103_defconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250826    gcc-11.5.0
arc                   randconfig-002-20250826    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                           imxrt_defconfig    clang-22
arm                   randconfig-001-20250826    gcc-12.5.0
arm                   randconfig-002-20250826    gcc-13.4.0
arm                   randconfig-003-20250826    gcc-8.5.0
arm                   randconfig-004-20250826    gcc-10.5.0
arm                           sunxi_defconfig    gcc-15.1.0
arm                           tegra_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250826    clang-22
arm64                 randconfig-002-20250826    gcc-8.5.0
arm64                 randconfig-003-20250826    clang-22
arm64                 randconfig-004-20250826    gcc-8.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250826    gcc-15.1.0
csky                  randconfig-002-20250826    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250826    clang-19
hexagon               randconfig-002-20250826    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250826    gcc-12
i386        buildonly-randconfig-002-20250826    gcc-12
i386        buildonly-randconfig-003-20250826    clang-20
i386        buildonly-randconfig-004-20250826    gcc-12
i386        buildonly-randconfig-005-20250826    clang-20
i386        buildonly-randconfig-006-20250826    gcc-12
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250826    gcc-14.3.0
loongarch             randconfig-002-20250826    gcc-14.3.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250826    gcc-8.5.0
nios2                 randconfig-002-20250826    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250826    gcc-8.5.0
parisc                randconfig-002-20250826    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250826    gcc-8.5.0
powerpc               randconfig-002-20250826    clang-22
powerpc               randconfig-003-20250826    gcc-13.4.0
powerpc                     skiroot_defconfig    clang-22
powerpc64             randconfig-001-20250826    gcc-10.5.0
powerpc64             randconfig-002-20250826    gcc-11.5.0
powerpc64             randconfig-003-20250826    gcc-14.3.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250826    gcc-8.5.0
riscv                 randconfig-002-20250826    gcc-11.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250826    clang-22
s390                  randconfig-002-20250826    clang-18
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                          r7780mp_defconfig    gcc-15.1.0
sh                    randconfig-001-20250826    gcc-11.5.0
sh                    randconfig-002-20250826    gcc-9.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250826    gcc-13.4.0
sparc                 randconfig-002-20250826    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250826    gcc-8.5.0
sparc64               randconfig-002-20250826    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250826    gcc-12
um                    randconfig-002-20250826    clang-17
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250826    clang-20
x86_64      buildonly-randconfig-002-20250826    clang-20
x86_64      buildonly-randconfig-003-20250826    gcc-12
x86_64      buildonly-randconfig-004-20250826    clang-20
x86_64      buildonly-randconfig-005-20250826    gcc-12
x86_64      buildonly-randconfig-006-20250826    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250826    gcc-11.5.0
xtensa                randconfig-002-20250826    gcc-8.5.0
xtensa                         virt_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

