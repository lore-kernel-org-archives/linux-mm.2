Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1B7C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BDD6B0095; Fri, 11 Sep 2026 03:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BCD16B0096; Fri, 11 Sep 2026 03:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAE06B0098; Fri, 11 Sep 2026 03:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5576B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:39:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9C6B1C02AC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:39:38 +0000 (UTC)
X-FDA: 85200681636.09.75E3C37
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id 267E440004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:39:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nv8v4URB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nv8v4URB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789112377;
	b=nDK7SArMcOWv15aulAsIPFgtIqh5FlopF/m58yzPTEWPpLsRXmMGxuxL4fTKAH6ugBwChO
	yrmIMDmUcNG3lkdw0i9ID/N2Pjaj1VMiMWWCjHnj1deBPPC8I+crEyA69A+eMHt9DelaN7
	C6W0JmYwpoQWF8uspqNUSwhej6Hl16s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789112377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=qxNcNl7rMQEnL/l+/+odtjGVY3ViF4ChFtUyvm7rr5o=;
	b=b24TT17uqrQQko1w9DJIJHK2Ah8AGXIWcDQQhYO1GRKfPV6aZMZdEx3pdNdIvJkEwKOeeg
	pzJL8hxzky9cZ0VcIJBIoNk41ya3TUli2VLMQaMIZJcuqti0AbOiuVIwHPaX/oP03rbfmb
	hLnVJ0+pbMhCJXe73R6fvoiiVVPQeF4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789112376; x=1820648376;
  h=date:from:to:cc:subject:message-id;
  bh=fhsEcjNjs8c4XMj5j4L9Vl7rAKfJ3AfRYpFjTphjI3k=;
  b=Nv8v4URBIgynzSpH1dbFnAM2Ck1vCXQGy6byuq0CvUKNKb/A03QRKu3M
   wxAG5WMRNc3j40+k7qqhWW5AM9jwdWYvvgY2fJ68XbnBLiT6UUvA3wPIT
   pli+1vUi06BzuIBqIu4qPMkxyy1XgHjq9cQq/O1UJ5ZQT9AaBzi8jAazB
   fySZSgrgvythcyMGXDNvmlWtnjNnFoMelxK0oZbjhfQopZr72ZiaX5GHP
   7YUs65HRwh+NkidxINCv8jmDeSk1qd/h1eSKbrnRaVHUZZAgWl0oszGaC
   yFrUO9iFrrHbJZPqILGD1A6yqZftIxmhORjFz2cEa6su7B3W6WLRGVJqR
   Q==;
X-CSE-ConnectionGUID: bpsM2WPoRhW/prnFtbcwNQ==
X-CSE-MsgGUID: QIbqnCgBQ+6fUxQUQcOOsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="100925747"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="100925747"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 00:39:35 -0700
X-CSE-ConnectionGUID: qIT2SHh7T9CCg5l3LIfhkA==
X-CSE-MsgGUID: yeOaXVLESye75RqQT5ic+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="265651750"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 11 Sep 2026 00:39:33 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4vr0-000000001EP-2fQ9;
	Fri, 11 Sep 2026 07:39:28 +0000
Date: Fri, 11 Sep 2026 15:38:06 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 07ae2801241e1324e6ad2cc0102ad125d36712a9
Message-ID: <202609111502.vdFP20hM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 267E440004
X-Stat-Signature: 7cwpqudrawtd6subbqf13yzkbmfan5et
X-Rspamd-Server: rspam01
X-HE-Tag: 1789112375-477192
X-HE-Meta: U2FsdGVkX19daCmIQZn87GqrJhX7gVISUNTnGstx5H8maFwGfXZaLZAqzzW1Yn0totCd6ItrwfhXr4XVFgVmMe4PEIAC+VrEt5fcU0/Cj3nQm1+4dXxvfYCEJVuMDVro0F5/KbtFGhDwWLvUCilM9czMYD68KrzzlqEdGUoFSDgtYjkxMZ0mJcPlPQ0znOhm9zLBSHSfBFjubSn6vYkh7jXHaxthJ3Hhc2I1umoOwIgoyYRH0PJ4R5Cub68DqJlKvaAJmBVOs0RU20S09+TcPwtliVckQNwrdufvRpa2X54LwL4t1oVcYNzR+G5J0zx3hdxidiWVSWzHa8PtZIErQ3+vFw3HJ9H97DwAClqusS9z0Kg8WZ+DrpI8ac8Sd8OzgXrKrZVMy0oLQL8Xc+rSfsG2gzhPTJSm1ilAFrF+IXxONDae0GosPgoBLIvLi1b3YQqGvL/F539OXRkBsw0YORt4yzT6lqhnG6HPJTUoCog+x3jLSTZsIvZBsK3XPN90HDUdRBiWRq+u8xegMoX/vmRcX9tes0Vu1s9SkhLdbFwRxYo72/Q/npSDXh4+I8O3ml8aZxE2WDurXkelVh+yMvyxsR3O4lR0XsYq2iVOEqJvtL3vkYx679pwJrdZLufBjkABPhGD1YZxIVzpwBnFkvMQ92S57Yi15J6vVVjFdJrTluKSYAUHnYWTGgAQ6ueY/evGXMvrTWu+sFfHnYGufzRjGvuiZW17aEup4yOhhoZ6MZvPEaHvxOa1PjM9asUrMNgzjyjB1TtRQ6KHxoUnnQdAd7CKevyp/I7kIpLho/gE1Z8Ca+VuOuAx0U7h00cV3Urk31VhgrS89wk4+mivIMOQBIDb7HotndU/fayElk2wyb0bJxiDCstoIdKKHrShZA7H2IfJSRbmdADjsz+xpjic9U5lzUYiLA1CQpjalBh/LErx0c4dDXz90pnuHOlaKOUnWAQMtoPOYuvDNBC
 gFWYiOzc
 it3TKGRQ+QkhnAURqvXSHIMBTHohx89MDOkJovfRBpTZE624EWFV0uUomY4L+yhOKRgI8OMRBM8SKDKU1NBWBE+tyjgy7yRmSyFG42aIu1r1XQCHWiS6D6ZIwyOYSLj8YaOPHa5Xe6tSqN7p4ZD+HA1nmSt2s7NPbzcTO8F3NxVJKzjOnSMcbBuXz7EN6VdF3Vc/SZvCOmKKMorQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 07ae2801241e1324e6ad2cc0102ad125d36712a9  Merge patch series "memblock tests: cover low-address allocations"

elapsed time: 1168m

configs tested: 187
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-24
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260911    clang-24
arc                   randconfig-002-20260911    clang-24
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                       aspeed_g5_defconfig    clang-20
arm                         assabet_defconfig    clang-20
arm                                 defconfig    gcc-16.1.0
arm                          exynos_defconfig    clang-20
arm                   randconfig-001-20260911    clang-24
arm                   randconfig-002-20260911    clang-24
arm                   randconfig-003-20260911    clang-24
arm                   randconfig-004-20260911    clang-24
arm                           sama5_defconfig    gcc-16.1.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260911    gcc-16.1.0
arm64                 randconfig-002-20260911    gcc-16.1.0
arm64                 randconfig-003-20260911    gcc-16.1.0
arm64                 randconfig-004-20260911    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260911    gcc-16.1.0
csky                  randconfig-002-20260911    gcc-16.1.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260911    gcc-12.5.0
hexagon               randconfig-002-20260911    gcc-12.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260911    clang-22
i386        buildonly-randconfig-002-20260911    clang-22
i386        buildonly-randconfig-003-20260911    clang-22
i386        buildonly-randconfig-004-20260911    clang-22
i386        buildonly-randconfig-005-20260911    clang-22
i386        buildonly-randconfig-006-20260911    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260911    clang-22
i386                  randconfig-002-20260911    clang-22
i386                  randconfig-003-20260911    clang-22
i386                  randconfig-004-20260911    clang-22
i386                  randconfig-005-20260911    clang-22
i386                  randconfig-006-20260911    clang-22
i386                  randconfig-007-20260911    clang-22
i386                  randconfig-011-20260911    clang-22
i386                  randconfig-012-20260911    clang-22
i386                  randconfig-013-20260911    clang-22
i386                  randconfig-014-20260911    clang-22
i386                  randconfig-015-20260911    clang-22
i386                  randconfig-016-20260911    clang-22
i386                  randconfig-017-20260911    clang-22
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260911    gcc-12.5.0
loongarch             randconfig-002-20260911    gcc-12.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                                defconfig    clang-24
m68k                       m5249evb_defconfig    gcc-16.1.0
m68k                       m5275evb_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        vocore2_defconfig    clang-20
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-24
nios2                               defconfig    clang-24
nios2                 randconfig-001-20260911    gcc-12.5.0
nios2                 randconfig-002-20260911    gcc-12.5.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                            defconfig    gcc-16.1.0
parisc                           alldefconfig    clang-20
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260911    gcc-8.5.0
parisc                randconfig-002-20260911    gcc-8.5.0
parisc64                            defconfig    clang-24
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                 mpc836x_rdk_defconfig    clang-20
powerpc               randconfig-001-20260911    gcc-8.5.0
powerpc               randconfig-002-20260911    gcc-8.5.0
powerpc64             randconfig-001-20260911    gcc-8.5.0
powerpc64             randconfig-002-20260911    gcc-8.5.0
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                    nommu_k210_defconfig    gcc-16.1.0
riscv                 randconfig-001-20260911    gcc-16.1.0
riscv                 randconfig-002-20260911    gcc-16.1.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260911    gcc-16.1.0
s390                  randconfig-002-20260911    gcc-16.1.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                               allyesconfig    clang-17
sh                        apsh4ad0a_defconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260911    gcc-16.1.0
sh                    randconfig-002-20260911    gcc-16.1.0
sh                           se7619_defconfig    gcc-16.1.0
sh                   sh7770_generic_defconfig    gcc-16.1.0
sh                            shmin_defconfig    clang-20
sh                          urquell_defconfig    clang-20
sparc                             allnoconfig    clang-24
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260911    gcc-13.4.0
sparc                 randconfig-002-20260911    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260911    gcc-13.4.0
sparc64               randconfig-002-20260911    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260911    gcc-13.4.0
um                    randconfig-002-20260911    gcc-13.4.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260911    gcc-14
x86_64      buildonly-randconfig-002-20260911    gcc-14
x86_64      buildonly-randconfig-003-20260911    gcc-14
x86_64      buildonly-randconfig-004-20260911    gcc-14
x86_64      buildonly-randconfig-005-20260911    gcc-14
x86_64      buildonly-randconfig-006-20260911    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260911    clang-22
x86_64                randconfig-002-20260911    clang-22
x86_64                randconfig-003-20260911    clang-22
x86_64                randconfig-004-20260911    clang-22
x86_64                randconfig-005-20260911    clang-22
x86_64                randconfig-006-20260911    clang-22
x86_64                randconfig-011-20260911    gcc-14
x86_64                randconfig-012-20260911    gcc-14
x86_64                randconfig-013-20260911    gcc-14
x86_64                randconfig-014-20260911    gcc-14
x86_64                randconfig-015-20260911    gcc-14
x86_64                randconfig-016-20260911    gcc-14
x86_64                randconfig-071-20260911    gcc-14
x86_64                randconfig-072-20260911    gcc-14
x86_64                randconfig-073-20260911    gcc-14
x86_64                randconfig-074-20260911    gcc-14
x86_64                randconfig-075-20260911    gcc-14
x86_64                randconfig-076-20260911    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                           allyesconfig    clang-20
xtensa                generic_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260911    gcc-13.4.0
xtensa                randconfig-002-20260911    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

