Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFE9CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 01:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A106B0092; Tue,  5 May 2026 21:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301CD6B0093; Tue,  5 May 2026 21:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217736B0095; Tue,  5 May 2026 21:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1040E6B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 21:22:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEE6B120577
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:22:17 +0000 (UTC)
X-FDA: 84735244314.18.43BBDD3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC27BA000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:22:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b6VSzvTX;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778030535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0cm0ifwwN0JCutclMs82LFRzZCYDuo/17o1W1/k91BU=;
	b=Jw9V+VlQqZam86kYEOzaowrH2kb308OKQXrebwO7SbKDRh6NHDhrhotGaZZWJRDBdCvhgf
	Y+XpfcsuIi4gchcGM8ouLT3Evwk56y84KvhEzxbciRAvQ3uNM2NnjvqbMET1iMo0VG4vTs
	uKFgZXQH7sYDbcZcEdb6IfTtd88+iQ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b6VSzvTX;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778030535; a=rsa-sha256;
	cv=none;
	b=Ih7g7FXxJ/VksBOVQLA7sJoLYQecVmP6Fo2VpzlEHTOaPAFV9h+kwo0nJLnTF/DCZblUK0
	cT6gqXaEAtVtVj4aLZxWzMvIx6+UyPJEJP2A6mCbI2dRWU/A9JkTidH4d7owCpjDyx9iii
	vsCRzV4Hsyypinjw2XmBaWum2rQzrcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778030535; x=1809566535;
  h=date:from:to:cc:subject:message-id;
  bh=Ztl6DJaG0TyE9wcP4i7s8ulbIRS3D8N7yZToICFHqWg=;
  b=b6VSzvTX8DxcZpln9wHn2jVJ3gTtihE3sumIUiAb3geTRA1rlhmdxdiq
   LlMKgvDoCM+dpBzLRBhToaDwSnSfGHp1FCFDt54dGFkIk2YL8/XBrYnCH
   RyK3xd3lBHnZbFvCqCh8Z/zB4GVa7y6ZbpWwMU0zVx2Y8/zskevbU/AI5
   caamyc6MvhNgyJneXTohD8PKOCWXZmXODQc+X/ZzCVxEYj+3sjpxLWrfB
   9YP4LGSfg7TiCPBzFvVL6w4Zp/Zq4p9gRFjowqW3urE64dJCOGVM3Dr4R
   vGLvFTDp0zAQOIpOQ0uR3lm1yfQhpQGZfAgx5Vpmlai7MT9LjkGwcexng
   Q==;
X-CSE-ConnectionGUID: K42P3ApgT2mkeu/QGclOyQ==
X-CSE-MsgGUID: 9+cPhG5SSnKZLSMsw0Yh2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="82766762"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="82766762"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 18:22:13 -0700
X-CSE-ConnectionGUID: 4RUGdHY4RhWtLj4OJA/MNg==
X-CSE-MsgGUID: pPVrQ36gTQG9idnozaQniQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="231589458"
Received: from lkp-server01.sh.intel.com (HELO 9ec114424ce8) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 May 2026 18:22:11 -0700
Received: from kbuild by 9ec114424ce8 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wKQxk-000000000aT-33V7;
	Wed, 06 May 2026 01:22:08 +0000
Date: Wed, 06 May 2026 09:21:53 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 intel-xe@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
 Thierry Reding <treding@nvidia.com>
Subject: [linux-next:master] BUILD REGRESSION
 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0
Message-ID: <202605060939.1pVmWmry-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC27BA000A
X-Stat-Signature: 4s96cce17ancf41quedsj5f86ccrhen5
X-HE-Tag: 1778030534-555429
X-HE-Meta: U2FsdGVkX18wzp+n1RTRDWHA22c8oxhni1yiikKpVm5VSMGnl0PuvvrtNhx7egQK9ajVtaVYF00H2/3RmcZrwr35eGKh5csCeWhLbcww+S1RbZWVJY5wxVnclbgXwOg64fl1yqsDQxHqOSjTjp9CTQDj92G45sUOXOl2LGzhV+TttuQuojg5TO1NGrFT27PXQVv4iIiiaSfgsJcJgLxmljSUrgL8uUYymbrdnutHpm1+ldMhelz+ioRJNhnJgebZVjBcv4XRf2h5RHR8AMLm/zGh9moIjLmlb8YVxCNFnV7nyQkx1bp+vYnM7uBG2PHRe1Zht4OeZc/6adJvxEmK0DLD+UXnoO53RFirE5eUJefSAS0Nhr5tOFAJVtCjSPVl1VyQBisOcXS43AvAJy8pGlSAM/cF8SJ+iQOEGZHV/ZoUL2hOD9Qor1/H4L9zSTbz9qCPajWCoR1ZPYkKikAX5EaPZ3BR4upcXtBpvX3gfOeni1fjwjqKxsjbEiufi9442fDWCSdoMbuMT7Y7hCRHvgQSx4P+JpXEn5b+pzyZTwt06i9FOk+De30eal1ppK1xsjnMvRtrEtQFkP+NZn2YiQTVdjYAouuhsi8B0zNK4jrELOTMRvDfWbApvD3YcnHPRb1ifEzw0K6X7oPuYrAwYFGg+9id1ODh3Yts5jeH5SD0UcwoQb/zNLXOMZK6XnBoYGlzT2ass0O2xBNrGTwdrvYN9e/OFQhOYwXij9lkPsZxqihGlafI1P49KB3Zp3D0hYIOWuddV145BGiL2h+vN0/m61WUX+/2CxA31kHGI/8gLWd6RKgoY89atsV7g4YWXtIstglULEzKNmzpW2a6W0etl3+Pnr35mDbIHz7alW0sU0RLQczxZXu6noKlHsZNbVR4YWUOCcxXkJ+E5N0+dcnVs+M55Lf6SxbpwMb8n368ie1Lg6jNQR9S3fNjc37Le7FSG9BTtb2UKOeprmJ
 tI1CPqfX
 UYTVeRFFKlNF7B62QirUQsf0mwNd2WXTjpI5T/7fg/S6EUARKcoyh4w0M5jtWvPc+sg/ea1H1u1+wpLslOWFE6jZxSbrDeU9No0xvc4EJ1qLQRhkdXpe8HwjmXERpEtxjflgXxmL67JbZK1wsvqaq5M+oyoeNUNdW+ZI6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0  Add linux-next specific files for 20260505

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_hw_engine.c:481:1: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    drivers/misc/mei/vsc-fw-loader.c:646:34: sparse: sparse: incorrect type in assignment (different base types)
    ftrace.c:(.text+0x18): undefined reference to `__atomic_fetch_add_8'
    ld: ftrace.c:(.text+0x36): undefined reference to `__atomic_fetch_add_8'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r061-20260505
|   |-- drivers-clk-mmp-clk-pxa1908-apbc.c:Unneeded-semicolon
|   `-- drivers-clk-mmp-clk-pxa1908-apbcp.c:Unneeded-semicolon
|-- arm64-randconfig-r121-20260505
|   `-- drivers-misc-mei-vsc-fw-loader.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-char-usertype-img_cnt-got-restricted-__le16-usertype
|-- i386-buildonly-randconfig-004
|   |-- ftrace.c:(.text):undefined-reference-to-__atomic_fetch_add_8
|   `-- ld:ftrace.c:(.text):undefined-reference-to-__atomic_fetch_add_8
`-- x86_64-dcg_x86_64_defconfig-func
    `-- drivers-gpu-drm-xe-xe_hw_engine.c:warning:the-frame-size-of-bytes-is-larger-than-bytes

elapsed time: 736m

configs tested: 202
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260506    gcc-9.5.0
arc                   randconfig-002-20260506    gcc-12.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260506    clang-23
arm                   randconfig-002-20260506    clang-23
arm                   randconfig-003-20260506    gcc-13.4.0
arm                   randconfig-004-20260506    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260505    gcc-8.5.0
arm64                 randconfig-002-20260505    clang-16
arm64                 randconfig-003-20260505    clang-23
arm64                 randconfig-004-20260505    clang-23
csky                             alldefconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260505    gcc-15.2.0
csky                  randconfig-002-20260505    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260505    clang-23
hexagon               randconfig-002-20260505    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    clang-20
i386        buildonly-randconfig-001-20260505    gcc-13
i386        buildonly-randconfig-001-20260506    clang-20
i386        buildonly-randconfig-001-20260506    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260505    gcc-14
i386        buildonly-randconfig-002-20260506    clang-20
i386        buildonly-randconfig-002-20260506    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260505    clang-20
i386        buildonly-randconfig-003-20260506    clang-20
i386                 buildonly-randconfig-004    clang-20
i386        buildonly-randconfig-004-20260505    clang-20
i386        buildonly-randconfig-004-20260506    clang-20
i386                 buildonly-randconfig-005    clang-20
i386        buildonly-randconfig-005-20260505    gcc-14
i386        buildonly-randconfig-005-20260506    clang-20
i386                 buildonly-randconfig-006    clang-20
i386        buildonly-randconfig-006-20260505    gcc-14
i386        buildonly-randconfig-006-20260506    clang-20
i386        buildonly-randconfig-006-20260506    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260505    gcc-14
i386                  randconfig-002-20260505    gcc-14
i386                  randconfig-003-20260505    clang-20
i386                  randconfig-004-20260505    gcc-14
i386                  randconfig-005-20260505    clang-20
i386                  randconfig-006-20260505    clang-20
i386                  randconfig-007-20260505    gcc-14
i386                  randconfig-011-20260506    clang-20
i386                  randconfig-012-20260506    clang-20
i386                  randconfig-013-20260506    clang-20
i386                  randconfig-014-20260506    clang-20
i386                  randconfig-014-20260506    gcc-14
i386                  randconfig-015-20260506    clang-20
i386                  randconfig-015-20260506    gcc-14
i386                  randconfig-016-20260506    clang-20
i386                  randconfig-017-20260506    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260505    clang-20
loongarch             randconfig-002-20260505    clang-18
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260505    gcc-8.5.0
nios2                 randconfig-002-20260505    gcc-9.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260506    gcc-13.4.0
parisc                randconfig-002-20260506    gcc-10.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260506    gcc-10.5.0
powerpc               randconfig-002-20260506    gcc-8.5.0
powerpc64             randconfig-001-20260506    gcc-8.5.0
powerpc64             randconfig-002-20260506    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260506    gcc-8.5.0
riscv                 randconfig-002-20260506    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260506    gcc-11.5.0
s390                  randconfig-002-20260506    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                         ap325rxa_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260506    gcc-12.5.0
sh                    randconfig-002-20260506    gcc-9.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260506    gcc-15.2.0
sparc                 randconfig-002-20260506    gcc-11.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260506    clang-23
sparc64               randconfig-002-20260506    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260506    gcc-14
um                    randconfig-002-20260506    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260506    clang-20
x86_64      buildonly-randconfig-002-20260506    gcc-14
x86_64      buildonly-randconfig-003-20260506    clang-20
x86_64      buildonly-randconfig-004-20260506    clang-20
x86_64      buildonly-randconfig-005-20260506    gcc-12
x86_64      buildonly-randconfig-006-20260506    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260505    clang-20
x86_64                randconfig-001-20260506    clang-20
x86_64                randconfig-002-20260505    gcc-14
x86_64                randconfig-002-20260506    clang-20
x86_64                randconfig-003-20260505    clang-20
x86_64                randconfig-003-20260506    clang-20
x86_64                randconfig-004-20260505    clang-20
x86_64                randconfig-004-20260506    clang-20
x86_64                randconfig-005-20260505    clang-20
x86_64                randconfig-005-20260506    clang-20
x86_64                randconfig-006-20260505    clang-20
x86_64                randconfig-006-20260506    clang-20
x86_64                randconfig-011-20260505    clang-20
x86_64                randconfig-012-20260505    clang-20
x86_64                randconfig-013-20260505    clang-20
x86_64                randconfig-014-20260505    clang-20
x86_64                randconfig-015-20260505    clang-20
x86_64                randconfig-016-20260505    gcc-14
x86_64                randconfig-071-20260506    clang-20
x86_64                randconfig-071-20260506    gcc-14
x86_64                randconfig-072-20260506    clang-20
x86_64                randconfig-072-20260506    gcc-14
x86_64                randconfig-073-20260506    clang-20
x86_64                randconfig-073-20260506    gcc-14
x86_64                randconfig-074-20260506    clang-20
x86_64                randconfig-075-20260506    clang-20
x86_64                randconfig-075-20260506    gcc-14
x86_64                randconfig-076-20260506    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260506    gcc-15.2.0
xtensa                randconfig-002-20260506    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

