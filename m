Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52649FED2CC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE5A6B0088; Thu, 12 Mar 2026 00:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9913E6B008A; Thu, 12 Mar 2026 00:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869DC6B008C; Thu, 12 Mar 2026 00:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7773A6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:56:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3079913BA5F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:56:43 +0000 (UTC)
X-FDA: 84536200686.30.9A61868
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24637140005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:56:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cyryLy42;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773291401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bvVkpQ10EElTaqAMKhW/rMLYMy+pau3OzUVZiCY5KSU=;
	b=ASirOpwfubrNX3nRS9/QNt+hjKNqy4uabbNYwh+Daa3br58LKfjREh2KKOCUcAPB1FNIMl
	Cxs2g6xe/fRx08wCGZuzRAJbA5NCzfwT/v4fCZHnKvMFIMDlfSqzSYb9fsF4W+ozu5QKe+
	sXZmYA0huR/DTo9JvO8XJiAsFPxSddE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773291401; a=rsa-sha256;
	cv=none;
	b=z37bT92BrYN0uXiHaVNzNQ+ug2sFRM9sPDXM5LyMJfdewM3HC0H2NMoJIz+D73+CRYe75J
	XKlUpS9EMXRfucBRtWPfywA4d/6t4lE97sJJLCj7ws17/V3K156ZM2alKwuRG7rNkW0hKv
	A9BJ83EmirspESQJ7vMzs/4qrcoaTpQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cyryLy42;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773291400; x=1804827400;
  h=date:from:to:cc:subject:message-id;
  bh=AjYVWpxVeLxrfRwHw/d3A0rPs4dHtU6ddtfz7j34GdI=;
  b=cyryLy42X6n0mchj02L/MlnV09K9EPjcsg/V9BlbDnFi92Q4atUivSN5
   jy0qmx9yQ5aQP8FdalvD02RqZsCItpR/wkx9Oqw+lR/AOk8QDaV9Twd36
   gVEkeGzi1Ov3/DA23IzC+xadgCjuTWAxZ3LwqMUYAbEjm6x+XGDs6CgtT
   nMwLVhJ/1bdLj53nEzdvv8Dy9M9Xb3EOzLKOjkuhPYJWDgiLL/SJcNRMj
   HSgCFEQKvVFnMMgTTYHJrVD6xiZpIpII+jksXrZ58MCCG5hBWW6WA7xFj
   8HMyx5p2XSpJqFj9hqu2GDAsvtpS727104blPtRs/jbMqZZSdPunaYwwy
   A==;
X-CSE-ConnectionGUID: KZSKS5gBSlut7EY3WwGLlg==
X-CSE-MsgGUID: T75JlOCBQo6QpD1OQWzXRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="77978850"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="77978850"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 21:56:38 -0700
X-CSE-ConnectionGUID: GtzB+sAoQ5SVcVg3YI5rBg==
X-CSE-MsgGUID: sAHk+p0FTw+mtCWayB+CoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="220886146"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Mar 2026 21:56:36 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0Y65-0000000025v-2KyR;
	Thu, 12 Mar 2026 04:56:33 +0000
Date: Thu, 12 Mar 2026 12:55:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 f90aadf1c67c8b4969d1e5e6d4fd7227adb6e4d7
Message-ID: <202603121236.q0z0bhop-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24637140005
X-Stat-Signature: 4487dmqf6npeqenqs5afhpgpzatdj99j
X-Rspam-User: 
X-HE-Tag: 1773291398-749171
X-HE-Meta: U2FsdGVkX19X3pHc6t9QGs/c/1sV0MdUZ9E+g295paZvOIyGKXvn2YneKrRV2txqFtAgd8qYnbkCaODoSB0QnbXfVn3eiJg0UQ1p637T9w7BPnYD3R+M511KPsNcAzQQTMfhOb/AxI9c0FMXdE0EIfonuAPCsf1FxagdYs4O7zvA/UlxYfD1O+FcyYNX2URgh2l03/gqJqObSb6+XeAoglVNIWhnbN9JvSFRlfC5B6LY3c/Dm5b5B1Z4UDGGOLQbXsHu47U2HP2MASuJdvH18Ejl1xf/iEo6GxHDiisNGs/viAoKjMrrRSh2aNlEh0HnCyMs6Jagfe3ZxrCOw4tB0Z8xfBBOpPztnhfTjU2x90AsTDmw+EjspWCui+z5Le/IlLqtshKAYDyjmc4Q/X22oe8ByIfNcqcfx+giR6FgwtbPkdrIh6CGhdec/BK0urkoVibkhVkzi329BD9HEcQCz2YduTOFbp0+XPhWTUJlK7z7y0uG85FX2Bk12nMawRSWkYTjZ8JxMu2KNFmxHRZl4x167ynwxmHNvHnDx1EDZwJ/gSlSBxkLOrK3d8N+BXrtjO1OQsh7zG0K9jeounRsqOgdh8szeX4BtNGoJYG5lHba9UrYcfiuX9VL+A6ppOCrOVoDhFiF3x1LBba0Y5LoZ6k67pZDij8WybgZluohTKpQtLuVbAem6lv+GRzQEqQ+PWz1v4T9F4kZG97kgIVzZxQwWIJ/ngoWddTRg9jW6mvq29M4inhlS204dTc5NS94W/ro+iSc07vJIpt9VmOsCYqC+Wn/IIXoJ2z5rIFlVADSeu0bN5erGf2NusVgur1PPTT/rQ+IoDIY3wrsJ1H+7lxebpPE4oef3lJs6sFAKBUxlFRdSZcx8uGhsntCBb7BxFwJ+ik3uhQLcAW2HhBDON242I9+ZZXpPinxCWJR097S+cEg/xq1jJ0yVzI07beHnEVsfSaiCgzEm8VlFAw
 3OX5Smt3
 Qc9ZMMACBe88DhkKOAg7Ti9te7mLoeOOJ5LQjP9phSctYYBmxcBkvjyIIzEiTEJv8OjWUIX9LCpQ0whQ20oqF7HAoVE1D7/RnlIBGHchf5z+NA5eblw1/gk8wx2AxRxHcyntMyEYECe9Aq776zd1cZMrjG9YkILUB3rLyB0qVMBAXVXRcgHwt1nMZSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f90aadf1c67c8b4969d1e5e6d4fd7227adb6e4d7  Add linux-next specific files for 20260311

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603120516.w7mPa5ZC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603120628.bJhW6n48-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603120912.KzwPUTG9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@intel.com

    arch/arm64/kvm/hyp/nvhe/trace.c:16:10: fatal error: 'simple_ring_buffer.c' file not found
    arch/arm64/kvm/hyp/nvhe/trace.c:16:10: fatal error: simple_ring_buffer.c: No such file or directory
    error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
    include/linux/compiler_types.h:706:38: error: call to '__compiletime_assert_770' declared with attribute error: min(outarg.size, ((loff_t)((long long)(~0ULL >> 1))) - pos) signedness error

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-allmodconfig
|   `-- arch-arm64-kvm-hyp-nvhe-trace.c:fatal-error:simple_ring_buffer.c-file-not-found
|-- arm64-randconfig-001-20260312
|   |-- arch-arm64-kvm-hyp-nvhe-trace.c:fatal-error:simple_ring_buffer.c:No-such-file-or-directory
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(outarg.size-((loff_t)((long-long)(-0ULL-)))-pos)-signedness-error
`-- x86_64-randconfig-002-20260312
    `-- error-E0277:const-kernel::bindings::vm_uffd_ops-cannot-be-shared-between-threads-safely

elapsed time: 744m

configs tested: 198
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260312    gcc-8.5.0
arc                   randconfig-002-20260312    gcc-14.3.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260312    gcc-8.5.0
arm                   randconfig-002-20260312    gcc-11.5.0
arm                   randconfig-003-20260312    gcc-10.5.0
arm                   randconfig-004-20260312    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260312    gcc-8.5.0
arm64                 randconfig-002-20260312    gcc-13.4.0
arm64                 randconfig-003-20260312    clang-18
arm64                 randconfig-004-20260312    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260312    gcc-12.5.0
csky                  randconfig-002-20260312    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260312    clang-23
hexagon               randconfig-002-20260312    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260312    gcc-12
i386        buildonly-randconfig-001-20260312    gcc-14
i386        buildonly-randconfig-002-20260312    gcc-14
i386        buildonly-randconfig-003-20260312    gcc-14
i386        buildonly-randconfig-004-20260312    gcc-12
i386        buildonly-randconfig-004-20260312    gcc-14
i386        buildonly-randconfig-005-20260312    gcc-14
i386        buildonly-randconfig-006-20260312    clang-20
i386        buildonly-randconfig-006-20260312    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260312    gcc-14
i386                  randconfig-002-20260312    gcc-14
i386                  randconfig-003-20260312    gcc-12
i386                  randconfig-004-20260312    gcc-14
i386                  randconfig-005-20260312    gcc-14
i386                  randconfig-006-20260312    gcc-14
i386                  randconfig-007-20260312    gcc-12
i386                  randconfig-011-20260312    clang-20
i386                  randconfig-012-20260312    gcc-14
i386                  randconfig-013-20260312    gcc-14
i386                  randconfig-014-20260312    clang-20
i386                  randconfig-015-20260312    gcc-14
i386                  randconfig-016-20260312    clang-20
i386                  randconfig-017-20260312    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260312    gcc-15.2.0
loongarch             randconfig-002-20260312    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260312    gcc-11.5.0
nios2                 randconfig-002-20260312    gcc-11.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260312    gcc-8.5.0
parisc                randconfig-002-20260312    gcc-14.3.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260312    gcc-8.5.0
powerpc               randconfig-002-20260312    gcc-8.5.0
powerpc64             randconfig-001-20260312    clang-23
powerpc64             randconfig-002-20260312    gcc-14.3.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260312    clang-23
riscv                 randconfig-002-20260312    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260312    gcc-14.3.0
s390                  randconfig-002-20260312    gcc-9.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260312    gcc-12.5.0
sh                    randconfig-002-20260312    gcc-13.4.0
sh                           se7751_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260312    gcc-13.4.0
sparc                 randconfig-002-20260312    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260312    clang-20
sparc64               randconfig-002-20260312    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260312    clang-23
um                    randconfig-002-20260312    clang-20
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260312    gcc-12
x86_64      buildonly-randconfig-001-20260312    gcc-14
x86_64      buildonly-randconfig-002-20260312    gcc-14
x86_64      buildonly-randconfig-003-20260312    clang-20
x86_64      buildonly-randconfig-003-20260312    gcc-14
x86_64      buildonly-randconfig-004-20260312    gcc-14
x86_64      buildonly-randconfig-005-20260312    gcc-14
x86_64      buildonly-randconfig-006-20260312    clang-20
x86_64      buildonly-randconfig-006-20260312    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260312    clang-20
x86_64                randconfig-002-20260312    clang-20
x86_64                randconfig-003-20260312    clang-20
x86_64                randconfig-004-20260312    clang-20
x86_64                randconfig-005-20260312    clang-20
x86_64                randconfig-006-20260312    clang-20
x86_64                randconfig-011-20260312    gcc-14
x86_64                randconfig-012-20260312    gcc-14
x86_64                randconfig-013-20260312    gcc-14
x86_64                randconfig-014-20260312    gcc-14
x86_64                randconfig-015-20260312    clang-20
x86_64                randconfig-016-20260312    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260312    gcc-8.5.0
xtensa                randconfig-002-20260312    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

