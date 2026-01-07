Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F78CF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 04:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5616B0092; Tue,  6 Jan 2026 23:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73196B0093; Tue,  6 Jan 2026 23:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F496B0095; Tue,  6 Jan 2026 23:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856DE6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:17:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34A9386941
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:17:24 +0000 (UTC)
X-FDA: 84303858408.16.EAD90E8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id B829E120009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:17:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XaWkb4R4;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767759442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7Z8X2k2ZHiXhTj+ciwkCbJ2V/1UtEqHXkEI1hSU7ulg=;
	b=pwR4+UmoW8CO09+f7gkm+kumdS/w/UamA9cVUckGTwKb15yVDcTrjz+nHNNCvP4MXESvHZ
	E3bgRxDE9UDBBdLzA8oiaESr03Bl5zINt0lGY0CX9GsYuAayKacawHlJCHJHrS49orN7Rx
	10Xe8ugv9GO/tMmrokNEWKs13nBUMyQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XaWkb4R4;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767759442; a=rsa-sha256;
	cv=none;
	b=juWaysCBUsyYQwX7e2YkUtbAv0YtWvdeJJWomYiLMBJrVHFZ/OoRCN3LLTYrDeyqBFJ1Jo
	SMYmLOWciUVJXlLnZCeXjFyRl4eTF7Y4UJMvt1GVzoa/jHxtaxPQrmmcue8zFoMJ7pkhdo
	Cml0ZImgDhlozMJFSee2qoWEfItLu1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767759442; x=1799295442;
  h=date:from:to:cc:subject:message-id;
  bh=1yhgUgmRZZcreuJW0H3We4kN5GfIv91hoA140IVltVY=;
  b=XaWkb4R4ICWcUkL5qrOnVK4eCZl6Kg7LIIucdGXo0UyMsLOvmUHw7dMe
   WlHEQkULaj56lWQwboJFVuYQL74qOxkdScUrj6nWwZy6O3XtQTWvB7aBR
   4dO9e9WKVIWdDsHk4AcEimO9lEQKaW8GQ61/GtOKBotY0GecpvRlvpwNn
   Iv9u+RjlaHj+rmzbeTZubZoljMBNgIEX2afkaVB7GEuT6TlXyPBQx+GE6
   onw2UxCIEHkulCTK0nAKVn51vtdsXldTmuMHZ4cvhsh1VUmXI13dqU3xX
   BXD1j4s6vAPpOs87qPcaBksFklw1ZCw7/jJZz9Wgjr0B7gY7zrhXvOTYK
   Q==;
X-CSE-ConnectionGUID: +P59dChfRx2HATAo7x7mjg==
X-CSE-MsgGUID: jQj6B9sLQxWv71ylq+Yhxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="80240846"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="80240846"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 20:17:20 -0800
X-CSE-ConnectionGUID: sYkEDrnMRdC8IYmNf7JZsw==
X-CSE-MsgGUID: Htfc/WchRde0Kho1fHG3eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="233525152"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 06 Jan 2026 20:17:19 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdKyy-000000003S5-3EHy;
	Wed, 07 Jan 2026 04:17:16 +0000
Date: Wed, 07 Jan 2026 12:16:35 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 6cd6c12031130a349a098dbeb19d8c3070d2dfbe
Message-ID: <202601071224.F09fvjXs-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Stat-Signature: ib43bc6juq1kxdhc1os74zfbzmp4ey4e
X-Rspam-User: 
X-Rspamd-Queue-Id: B829E120009
X-HE-Tag: 1767759441-986323
X-HE-Meta: U2FsdGVkX19/1BUWBT++WcQWKlutcV/Mg+rwchCcxyaqhNS0JCWAm46M6WCF/lbMw7TOE1Kb40Kb0YC/dArDNcJe8DLGMm9AnTvNwFMkDnzQBE4q2kOX2TpgR7+BleHxNomPpkFHGcYKoNfLqvjHyKyX7vEbTqkbO8k0e9E0G9MHrgDo72PRT7gcv+gW39yJcg24VhQz6P6EXJIXwrKVImskmF/B0oE5nll45y98ngKm6JndSMdpnvyef+YIfDI6LdHPtfy2uGod/LghnY8/slKKwaW0theFuezZGpynPnHzUdphIGQuJ3xUJ/EHOQddnkmVccX732a0dKeUeMCyI5q7LAK9Tor+55A9pIoho7r3PqjqVZJUzc8mV3ZWKT/hkntiocXkG+IqXNvDVYk33dVUZCrvvtpCiaUjj/Amf/zrxlZfCD7ZFlgfIF/eHDjgchpMAUuhklYVwLH1orHFXYRItemy0V3QmBY1o7wdSO2l7LojHqLAE4RLdTeRj9+wUiH84zK3dwVRk4zYjWsFVUhXr6CI/X78IqfjursfDa22v7lt5Hjwqu3glaPQZVI6N+R6Tlcf4+mvsLpNW7ZuHJ5o4rYoBUBXsdzuytVs8K8VjQnthdLfwkInCVf3WlQdbl2AxbZ7h8Zem9HLAk8IJQUWzWcTmx/rLG+mecqSvpTLWiSqKRvysqxmCTkZbeqC0hh/6BnilP/WG7eltUbYlvuuJK2BIYL0Az5UVU2K/bgXnoaZFHAP7zZKjKf3fSV6/gSPfmMGxPkGYx+sPZ/OBe33o3n4tR6CaFlBtjFhh3pYv0GiCvCQfulbeSQWX4hdeCJpj/Azux+rqlWbcU6kI09pq7U6Q9w6ejnk4NMrl8Cj3mGeTE6vs5jU+cYxQqkJyIwX8WaBYSBYikrqveWiuzmyBOl05eYESOvwmgwYSoom3OcrBjUfXT6XBtgq2REThwVbqFN192/4x+tJJkR
 MjkZ4xkO
 4HOYYulbyMpJatCzfftGffJOcsuvprv18FrAX0hHTYc1mxliRyQvKlH2JDs6a2QVyuwXIRyKyoojpr0cuxEtcnT3LPiJqwM3+BTO9EqS1Vi1FgIg+5+uWoqda9S+2oSzBABxVwvx4h7EYcwEAPEpC1gNLYpruSSUaOAO7k7ri2PReGO+Q4AKov0Y9qQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6cd6c12031130a349a098dbeb19d8c3070d2dfbe  Add linux-next specific files for 20260106

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601061424.nbKLNwC5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601061140.6GUe2frS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601071056.FusqsRx2-lkp@intel.com

    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_656' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
    sound/core/pcm_native.c:3308:6: error: cannot jump from this asm goto statement to one of its possible targets

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/amd/amdgpu/psp_v15_0.c:34:1: sparse: sparse: bad integer constant expression
    drivers/phy/spacemit/phy-k1-usb2.c:199:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r113-20260105
|   `-- drivers-phy-spacemit-phy-k1-usb2.c:sparse:sparse:bad-integer-constant-expression
|-- i386-randconfig-017-20260106
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
|-- i386-randconfig-062-20260106
|   `-- drivers-gpu-drm-amd-amdgpu-psp_v15_0.c:sparse:sparse:bad-integer-constant-expression
|-- riscv-allyesconfig
|   `-- sound-core-pcm_native.c:error:cannot-jump-from-this-asm-goto-statement-to-one-of-its-possible-targets
`-- x86_64-randconfig-123-20260105
    `-- fs-ntfs3-inode.c:sparse:sparse:symbol-ntfs_writeback_ops-was-not-declared.-Should-it-be-static

elapsed time: 1566m

configs tested: 141
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20260106    gcc-13.4.0
arc                   randconfig-002-20260106    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                                 defconfig    clang-22
arm                      jornada720_defconfig    clang-22
arm                         nhk8815_defconfig    clang-22
arm                   randconfig-001-20260106    gcc-11.5.0
arm                   randconfig-002-20260106    clang-22
arm                   randconfig-003-20260106    gcc-10.5.0
arm                   randconfig-004-20260106    gcc-8.5.0
arm                         s5pv210_defconfig    gcc-15.1.0
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20260106    clang-22
arm64                 randconfig-002-20260106    gcc-8.5.0
arm64                 randconfig-003-20260106    gcc-9.5.0
arm64                 randconfig-004-20260106    gcc-10.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20260106    gcc-10.5.0
csky                  randconfig-002-20260106    gcc-11.5.0
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260106    clang-22
hexagon               randconfig-002-20260106    clang-17
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260106    clang-20
i386        buildonly-randconfig-002-20260106    clang-20
i386        buildonly-randconfig-003-20260106    gcc-14
i386        buildonly-randconfig-004-20260106    clang-20
i386        buildonly-randconfig-005-20260106    gcc-14
i386        buildonly-randconfig-006-20260106    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260106    clang-20
i386                  randconfig-002-20260106    gcc-14
i386                  randconfig-003-20260106    clang-20
i386                  randconfig-004-20260106    clang-20
i386                  randconfig-005-20260106    clang-20
i386                  randconfig-006-20260106    clang-20
i386                  randconfig-007-20260106    clang-20
i386                  randconfig-011-20260106    clang-20
i386                  randconfig-012-20260106    gcc-14
i386                  randconfig-013-20260106    gcc-14
i386                  randconfig-014-20260106    clang-20
i386                  randconfig-015-20260106    gcc-14
i386                  randconfig-016-20260106    clang-20
i386                  randconfig-017-20260106    gcc-14
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260106    gcc-15.1.0
loongarch             randconfig-002-20260106    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       alldefconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260106    gcc-8.5.0
nios2                 randconfig-002-20260106    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
openrisc                 simple_smp_defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20260106    gcc-8.5.0
parisc                randconfig-002-20260106    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                    gamecube_defconfig    clang-22
powerpc               randconfig-001-20260106    clang-22
powerpc               randconfig-002-20260106    gcc-8.5.0
powerpc64             randconfig-001-20260106    gcc-8.5.0
powerpc64             randconfig-002-20260106    gcc-8.5.0
riscv                             allnoconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260106    gcc-8.5.0
riscv                 randconfig-002-20260106    clang-22
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20260106    gcc-8.5.0
s390                  randconfig-002-20260106    gcc-14.3.0
sh                                allnoconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                          r7780mp_defconfig    gcc-15.1.0
sh                    randconfig-001-20260106    gcc-15.1.0
sh                    randconfig-002-20260106    gcc-10.5.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20260106    gcc-11.5.0
sparc                 randconfig-002-20260106    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260106    clang-22
sparc64               randconfig-002-20260106    gcc-15.1.0
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260106    clang-22
um                    randconfig-002-20260106    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20260106    clang-20
x86_64      buildonly-randconfig-002-20260106    gcc-14
x86_64      buildonly-randconfig-003-20260106    clang-20
x86_64      buildonly-randconfig-004-20260106    gcc-14
x86_64      buildonly-randconfig-005-20260106    clang-20
x86_64      buildonly-randconfig-006-20260106    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260106    gcc-14
x86_64                randconfig-002-20260106    gcc-14
x86_64                randconfig-003-20260106    clang-20
x86_64                randconfig-004-20260106    clang-20
x86_64                randconfig-005-20260106    gcc-14
x86_64                randconfig-006-20260106    gcc-14
x86_64                randconfig-011-20260106    gcc-14
x86_64                randconfig-012-20260106    gcc-13
x86_64                randconfig-013-20260106    gcc-14
x86_64                randconfig-014-20260106    gcc-14
x86_64                randconfig-015-20260106    clang-20
x86_64                randconfig-016-20260106    clang-20
x86_64                randconfig-071-20260106    gcc-14
x86_64                randconfig-072-20260106    clang-20
x86_64                randconfig-073-20260106    clang-20
x86_64                randconfig-074-20260106    clang-20
x86_64                randconfig-075-20260106    gcc-14
x86_64                randconfig-076-20260106    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20260106    gcc-8.5.0
xtensa                randconfig-002-20260106    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

