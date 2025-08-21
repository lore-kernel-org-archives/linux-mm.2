Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC1FCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 00:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070AC8E006A; Thu, 21 Aug 2025 20:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0201F8E0056; Thu, 21 Aug 2025 20:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78B38E006A; Thu, 21 Aug 2025 20:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D33F38E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:00:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F69959A80
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:00:08 +0000 (UTC)
X-FDA: 83802435696.11.D57943E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B39920008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:00:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LV1SdtVT;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755820806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0kahc4iWiUSMStOLGES2Hmi8eq0KtVoBAbmljTT0/KE=;
	b=WEs8M88dZ86KvxX0limza8w4b2tYtIkO96ciI30NUxl0KjQsw6a21Xhbo997/b40NJ1TEc
	JEiDPbMZt7ccBUgd15vU5VlsKPyWhd55zMm/lmUHo51IHDMnhGpELHDkRmWAgopNk479c3
	LQ68LHrRcD0rVzWiWlg6yrDDbIRjQho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LV1SdtVT;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755820806; a=rsa-sha256;
	cv=none;
	b=EHx44KHSrSzJJNA+TDoUIV9/K5ybib1l+SNDUBhUC+obO2oeF3Zc8orTXYpyxSA03WctX3
	P+N4n8jw92TM7JTficQB+MP7SBTUhgpoAkCwQRvynph/7qsucq9y5aXiFnMSTZ+9U/Bs/4
	Mlr9LZeYVhLLYmYOl231WuiAeUurhuU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755820805; x=1787356805;
  h=date:from:to:cc:subject:message-id;
  bh=SKRvmY0OfNbbB0kUdFan1SvwKfHMQB6Tc+sGG4zvvas=;
  b=LV1SdtVTjGVkQZVc1YnN1xru5LZyo6tYsvKIZP1AFvs/qqeiOgDeT1cM
   DTzXCbMJ67HQz8qXjLUvNbMGWhPvLRStY7dkL5QZUUpt/7uyu0S7MV9ra
   KUqO7ZUQaqWzEWPvgvTdNeXH9pkw6+fHGtJUVz82ubLINmBxmJQcKpHay
   AQVOggxgtfyKTIkJBmVykGhGMEAG895n4PLhQ5Gv1sN9DftJzibSZP+jI
   HNaMSloeDAeBctxCaZk+SMVkxIeC1a8Oh8UItkQDWoGKAuYgWPCZ0WPjj
   bhp9wahRg42bQeWuJcFHWmIUpu8iUdYHIhx2QDHcpYU1MOLk971dnt1jn
   A==;
X-CSE-ConnectionGUID: hUPnzhurScC8SotImAJEsQ==
X-CSE-MsgGUID: n9Vc41uKQqWccwgHoHuD7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="68394428"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="68394428"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:00:03 -0700
X-CSE-ConnectionGUID: o/bd6DQgSGyYWJn1PZCAAg==
X-CSE-MsgGUID: d4yXPudSQUel9RkNfsZJZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="172750618"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 21 Aug 2025 17:00:01 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upFCJ-000Klb-0q;
	Thu, 21 Aug 2025 23:59:59 +0000
Date: Fri, 22 Aug 2025 07:59:17 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 66e537433fac24bc002463056156ad9eb61979ff
Message-ID: <202508220711.xHqxn8yA-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Queue-Id: 0B39920008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cby1tg5oo34negyzesrk4dowp1y5ft99
X-HE-Tag: 1755820804-534268
X-HE-Meta: U2FsdGVkX18bxe6RBVWmrscJSlgaN3FtXJ+nBgu7lgECCDrW66Pgx8pA6PIMDeWANcC9WTOtMedOssjiwZAfFD9tUSPwXvaSJbc4BbJV8C6Qoz01KkWPCzQRxHV3x9QUME2XUIE3Nj/0z0n3U2fbGdNErXgiT0cCsHQ9kOGtccBcoFoc2pgaN0msGdEMbVCY8SuIJHxMvUSd3qbm3+Ln4Yd0D7EKkbTY02ChYsn2dfrENXYCdiI6fDhDlTbC7xefc/oMU44CdILw1KJ5PwSuE/bsV93voshy36VSHiZb7eNl9DN4lNCe++xuzBir8q7W5yJKb4sxO+2XBmK5ZZODBLYhCO9UJedbq8CoWjr2V7feBZE3kV0EpFfBWLurzFz9+Tj5piQsKOsvnrP0Kvj1oBARslya3kfXGbv7rNZkSSxbBYyTHPsiVtRIH02V6JuWnouwJ58/BZkfqp8wkcdkZODYo/bZhFRZVlgLJi16Ig8/bws6TVzftzb2D8UGj2rddyNRQO1SYW2nEe4VsRVNhMAcNnx4RaLeYsJ9UHn3XOLH6PHJ2zniNWvFde7bedANaYjIj3ycokSycKbDqtoZU6SSpXPM2j6WKUJEKkQN7caFfmf6FWahBlWClyVi0lCjTZjeMU/Q2hmgX25hsPRcOEWG3VAZbVjqOJ5+5a/LLXQ2uKSdh2NAGfySIhNUCMUYwrkiSil8CuE4ybx8N3Bkssi6EFSzi5O63DevlqgkgSbbrF+yOLo77ybYl14FsvVa+NygD5Trrb0d98AfqMXqMihPz0LYuKC/9WT/XoJzrkZqfSTcCapvC2JAo2xZ+A/1+DJdCjPakXicsBJPAyrekXUL3xcwmCJyqEqUhMd5ucKm9Ik5ue+47BY1VwsIrm5L0XjArWaEJRVUDFc9iVqOxyaF25j/WxD12z9riF8FxJZYbGH3rlaOWvCifmKIKc8Xha4jxD8F7fITpIMC0cT
 xIecu5qL
 sWw+zhbFwvD7Jx4bPoyGsGYT+IkE7E45pwdc3njJTnN8/8HxtIJ9Vfugg6mQJfkxVOdNhsHGxjxyjRji0TFfEcqu//m0kB22uWRNx2pat6/hL40uZDN3Zzz1MyGZigAqFNVjf9iIZldtzT9u2da9/MyCi3uv+8MHszx6Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 66e537433fac24bc002463056156ad9eb61979ff  memblock: drop for_each_free_mem_pfn_range_in_zone_from()

elapsed time: 849m

configs tested: 241
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    clang-19
arc                              allmodconfig    clang-19
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                                 defconfig    clang-19
arc                        nsimosci_defconfig    gcc-15.1.0
arc                   randconfig-001-20250821    gcc-9.5.0
arc                   randconfig-001-20250822    clang-22
arc                   randconfig-002-20250821    gcc-13.4.0
arc                   randconfig-002-20250822    clang-22
arc                           tb10x_defconfig    gcc-15.1.0
arm                              allmodconfig    clang-19
arm                               allnoconfig    clang-22
arm                              allyesconfig    clang-19
arm                                 defconfig    clang-19
arm                   randconfig-001-20250821    gcc-13.4.0
arm                   randconfig-001-20250822    clang-22
arm                   randconfig-002-20250821    clang-22
arm                   randconfig-002-20250822    clang-22
arm                   randconfig-003-20250821    clang-22
arm                   randconfig-003-20250822    clang-22
arm                   randconfig-004-20250821    clang-22
arm                   randconfig-004-20250822    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    clang-19
arm64                 randconfig-001-20250821    clang-22
arm64                 randconfig-001-20250822    clang-22
arm64                 randconfig-002-20250821    clang-22
arm64                 randconfig-002-20250822    clang-22
arm64                 randconfig-003-20250821    gcc-11.5.0
arm64                 randconfig-003-20250822    clang-22
arm64                 randconfig-004-20250821    gcc-13.4.0
arm64                 randconfig-004-20250822    clang-22
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    clang-19
csky                  randconfig-001-20250821    gcc-13.4.0
csky                  randconfig-001-20250822    clang-22
csky                  randconfig-002-20250821    gcc-15.1.0
csky                  randconfig-002-20250822    clang-22
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-19
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-19
hexagon               randconfig-001-20250821    clang-20
hexagon               randconfig-001-20250822    clang-22
hexagon               randconfig-002-20250821    clang-22
hexagon               randconfig-002-20250822    clang-22
i386                             allmodconfig    clang-20
i386                              allnoconfig    clang-20
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20250821    gcc-12
i386        buildonly-randconfig-001-20250822    clang-20
i386        buildonly-randconfig-002-20250821    gcc-12
i386        buildonly-randconfig-002-20250822    clang-20
i386        buildonly-randconfig-003-20250821    clang-20
i386        buildonly-randconfig-003-20250822    clang-20
i386        buildonly-randconfig-004-20250821    gcc-12
i386        buildonly-randconfig-004-20250822    clang-20
i386        buildonly-randconfig-005-20250821    gcc-12
i386        buildonly-randconfig-005-20250822    clang-20
i386        buildonly-randconfig-006-20250821    clang-20
i386        buildonly-randconfig-006-20250822    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20250822    clang-20
i386                  randconfig-002-20250822    clang-20
i386                  randconfig-003-20250822    clang-20
i386                  randconfig-004-20250822    clang-20
i386                  randconfig-005-20250822    clang-20
i386                  randconfig-006-20250822    clang-20
i386                  randconfig-007-20250822    clang-20
i386                  randconfig-011-20250822    gcc-12
i386                  randconfig-012-20250822    gcc-12
i386                  randconfig-013-20250822    gcc-12
i386                  randconfig-014-20250822    gcc-12
i386                  randconfig-015-20250822    gcc-12
i386                  randconfig-016-20250822    gcc-12
i386                  randconfig-017-20250822    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250821    gcc-14.3.0
loongarch             randconfig-001-20250822    clang-22
loongarch             randconfig-002-20250821    gcc-15.1.0
loongarch             randconfig-002-20250822    clang-22
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
microblaze                       alldefconfig    gcc-15.1.0
microblaze                       allmodconfig    clang-19
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    clang-19
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250821    gcc-9.5.0
nios2                 randconfig-001-20250822    clang-22
nios2                 randconfig-002-20250821    gcc-10.5.0
nios2                 randconfig-002-20250822    clang-22
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-12
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250821    gcc-12.5.0
parisc                randconfig-001-20250822    clang-22
parisc                randconfig-002-20250821    gcc-8.5.0
parisc                randconfig-002-20250822    clang-22
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    gcc-15.1.0
powerpc                       ebony_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250821    clang-17
powerpc               randconfig-001-20250822    clang-22
powerpc               randconfig-002-20250821    clang-22
powerpc               randconfig-002-20250822    clang-22
powerpc               randconfig-003-20250821    gcc-9.5.0
powerpc               randconfig-003-20250822    clang-22
powerpc64             randconfig-001-20250822    clang-22
powerpc64             randconfig-002-20250821    clang-22
powerpc64             randconfig-002-20250822    clang-22
powerpc64             randconfig-003-20250821    clang-22
powerpc64             randconfig-003-20250822    clang-22
riscv                            allmodconfig    gcc-15.1.0
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    gcc-15.1.0
riscv                               defconfig    gcc-12
riscv                 randconfig-001-20250821    clang-17
riscv                 randconfig-001-20250822    clang-22
riscv                 randconfig-002-20250821    gcc-9.5.0
riscv                 randconfig-002-20250822    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    gcc-12
s390                  randconfig-001-20250821    gcc-14.3.0
s390                  randconfig-001-20250822    clang-22
s390                  randconfig-002-20250821    clang-18
s390                  randconfig-002-20250822    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-12
sh                    randconfig-001-20250821    gcc-15.1.0
sh                    randconfig-001-20250822    clang-22
sh                    randconfig-002-20250821    gcc-13.4.0
sh                    randconfig-002-20250822    clang-22
sh                          rsk7203_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250821    gcc-14.3.0
sparc                 randconfig-001-20250822    clang-22
sparc                 randconfig-002-20250821    gcc-15.1.0
sparc                 randconfig-002-20250822    clang-22
sparc64                             defconfig    gcc-12
sparc64               randconfig-001-20250821    gcc-8.5.0
sparc64               randconfig-001-20250822    clang-22
sparc64               randconfig-002-20250821    clang-22
sparc64               randconfig-002-20250822    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-12
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250821    clang-19
um                    randconfig-001-20250822    clang-22
um                    randconfig-002-20250821    clang-22
um                    randconfig-002-20250822    clang-22
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250821    clang-20
x86_64      buildonly-randconfig-001-20250822    clang-20
x86_64      buildonly-randconfig-002-20250821    clang-20
x86_64      buildonly-randconfig-002-20250822    clang-20
x86_64      buildonly-randconfig-003-20250821    clang-20
x86_64      buildonly-randconfig-003-20250822    clang-20
x86_64      buildonly-randconfig-004-20250821    gcc-12
x86_64      buildonly-randconfig-004-20250822    clang-20
x86_64      buildonly-randconfig-005-20250821    clang-20
x86_64      buildonly-randconfig-005-20250822    clang-20
x86_64      buildonly-randconfig-006-20250821    clang-20
x86_64      buildonly-randconfig-006-20250822    clang-20
x86_64                              defconfig    clang-20
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20250822    clang-20
x86_64                randconfig-002-20250822    clang-20
x86_64                randconfig-003-20250822    clang-20
x86_64                randconfig-004-20250822    clang-20
x86_64                randconfig-005-20250822    clang-20
x86_64                randconfig-006-20250822    clang-20
x86_64                randconfig-007-20250822    clang-20
x86_64                randconfig-008-20250822    clang-20
x86_64                randconfig-071-20250822    clang-20
x86_64                randconfig-072-20250822    clang-20
x86_64                randconfig-073-20250822    clang-20
x86_64                randconfig-074-20250822    clang-20
x86_64                randconfig-075-20250822    clang-20
x86_64                randconfig-076-20250822    clang-20
x86_64                randconfig-077-20250822    clang-20
x86_64                randconfig-078-20250822    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-12
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-12
x86_64                           rhel-9.4-ltp    gcc-12
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250821    gcc-11.5.0
xtensa                randconfig-001-20250822    clang-22
xtensa                randconfig-002-20250821    gcc-10.5.0
xtensa                randconfig-002-20250822    clang-22
xtensa                    xip_kc705_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

