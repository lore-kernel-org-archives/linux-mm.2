Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1118EC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7162A6B00E6; Thu, 22 Jan 2026 00:57:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3CA6B00E7; Thu, 22 Jan 2026 00:57:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2C46B00E8; Thu, 22 Jan 2026 00:57:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2AA6B00E6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:57:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F25461AEDD2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:57:44 +0000 (UTC)
X-FDA: 84358543248.29.2CB17E3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 476FA120007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:57:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cSf9k/wW";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769061463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=JDNjvBD4kIQ1BQUikYTG0XRNbi9F8P4aMPuaeTCvvSo=;
	b=337fY2iSzFHr75OUpXkeyFmU6P0xFqs7Hd+o+gIr9Ybkq1nLgo7/pYgvl0+crgnI63ScFy
	IkaVUyxNP4cvYzxKuPKoWn7GzSjpNQRvx4nwaaxWv433Ik35us+XbRFuPeQhW0Iuei0xiw
	apSvbsedDDi819SV56CszWQ3Xbdfwfg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cSf9k/wW";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769061463; a=rsa-sha256;
	cv=none;
	b=3cVNaXJ7/alqdHQXxpAUDq/NbS4yKyAs3z9Yp9NQhdukre95Sbf0s/lRbZYXwy2ryelruA
	16OMKd5JnTvLKfHZzO42xa/yt2jGtxCTylKElkQuaNI5b1y3fa6gQktEGDH3ydMzyEPsHg
	rqjOe6OX94z6y7hT+gLz7JMqZN2B7s0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769061463; x=1800597463;
  h=date:from:to:cc:subject:message-id;
  bh=y2uUp2ipGeHRroJNK6az5bTvMpKWbX2BWJbE3AKP/Dk=;
  b=cSf9k/wW4yrd0oBG3pUNMmYJa3I6oBC8Tn8tKQL6WZ2ft4Jx5EW/ezFx
   E1xPTw8HB3RA49T8cI/UsamIgrq1N57wBvLEvIOD5ZA0KSjEGpWiTChoH
   yXeTjh1yYS/g6R3fYVE8U4jgvzz1w5QdMPws3U2aqpJkddmR2Bdo0VQjn
   Pe418aEUswXtBXoGF5SLXvEXEp1FzFAjK0hNm1qzywJqyvZ86AX/bkuoK
   aLJ4we50em3yPn1hGSlzDRkmTvhVySjzao6edV2WYEd+N4ZP4qgiWvh7J
   jIwvgcwj+wcbVwXYthuvpQoH1ZVWkUdxGCKEEEX9r2pWAi2MRVlqAydcN
   g==;
X-CSE-ConnectionGUID: JjQtXTVLS/eFskOoVjBniA==
X-CSE-MsgGUID: rwg8QLUkTKSEfkW6CPKzXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70204463"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70204463"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 21:57:41 -0800
X-CSE-ConnectionGUID: dwpLpXdlQf+5fRjRRa9u4g==
X-CSE-MsgGUID: ZlYzxV93ReC/Si/lJpi5pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="211657050"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 21 Jan 2026 21:57:39 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vinhI-00000000SVL-1sfX;
	Thu, 22 Jan 2026 05:57:36 +0000
Date: Thu, 22 Jan 2026 13:56:37 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 e3b32dcb9f23e3c3927ef3eec6a5842a988fb574
Message-ID: <202601221329.jB8IbCru-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 476FA120007
X-Stat-Signature: u1x613ya9oh76t9im4zysi1rkdjhb3ip
X-Rspam-User: 
X-HE-Tag: 1769061462-719531
X-HE-Meta: U2FsdGVkX1+giiMAlQEd68v0wfWy/o3bwjDWDDdhFv1h228+EG3R3OMxkEwR6MYDQVaQyG6aq6eDqV7GDp/ynFHuUinhbaG7wOxM6vr0qwfILedN8OPBh6r/o3uj4Rd2Wn7LnGV2sKvg77hdnpX19Hjnp8vUAZVU6GAnYZ77Q+S9dTPqRjm5yk54lEj9GinSI77ysYRcGTpYNc3wqkiimD0jKoOkiuNq9I3ffU8x9JPGY3TqvnSyAIi5CQgcRQFZ6eq8WNkgNgJUEfslSoh7K3ME0lxsfQXd6gsysGEvQzIWdNK+i6smm4MK2zaJ6DZpOXgu1QRsZEGzCaltGsphufpR9HNxr3kvGC1rABI4d8o5ZtOCyn1h91FZ0XFlZK7OBchWnN2GAZCS891n01jhq53kphP46XLuef+e2T54YBKW/pcAWWd7EmmX0I7XI96loA5ZAu69Zt3flvz8J1qsx8S4CFpVJ6BqXLfhAtjLVV5zencYCS95i5HMAuA2ZSyuNhsT13DMRqHv1vSt45AksGx1fZKtyHg2IzV6+8Dh1HofHCBWtj4oNOvxp71CKjcpCLZGE9AGllTL0Wj8Z7rLcnkpf9mQozkSIrPxiieFJRZThNdqV3cZfAC0X2e2lBKjKS+VnNmlxurUKhfTnqnub+xJ0Hvi+UlUyfB3Mpf5hCCmcWmE5FRz7/u3EHgOkw56kMO/mwjBDJayb5MVsSMPBSWm/q5rfxx3jv6naZN1CpZlqQ2KzzZLLPnu1smGLsbXYQv2AXinaKg4dZoTLqcIVY3yZ3GpaxVW/wdU+1ob4V0jC4KWY708NB10O2qUUl0jJsb4B4WYGhitynL+1X7wm9b7+ZW+wLbT/s+s/pSh69I5pSFC3YMRB0zFg+/barAhSQ/Jo7qrA4Dv1Q8V23pNNjMAOAhuLvJ9VzOGgBNDRkSVgvNvoaiui7T2SbTMEPja//ao6x5AMO4NGMdzHmZ
 SeQAlo0N
 Q6jgM58dPE3Z79C7yF/aJuzvyT5r//ERXq9fSrPSdwlPeyd1ZVttAgDnZPK9V5vpZ/m2FVsYUYzdMngBHO7SeKH0n/TTb3EVP0tM4nPdJmr6HTovGGW+ecxM7Ns1ef8GZHelvxdETZ431ilrdEqOsggA1xIbNO75XdyMqsLTrzszsTejc+udYiP+x7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e3b32dcb9f23e3c3927ef3eec6a5842a988fb574  Add linux-next specific files for 20260121

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601220948.MUTO60W4-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601221259.2tPZX8j2-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601221358.gzX7tgY3-lkp@intel.com

    drivers/staging/fbtft/fbtft-core.c:368:14: error: 'struct fb_info' has no member named 'dev'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1051 mlx5_lag_modify_device_vports_speed() warn: iterator 'i' not incremented

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r072-20260122
|   `-- drivers-net-ethernet-mellanox-mlx5-core-lag-lag.c-mlx5_lag_modify_device_vports_speed()-warn:iterator-i-not-incremented
|-- nios2-randconfig-002-20260122
|   `-- drivers-staging-fbtft-fbtft-core.c:error:struct-fb_info-has-no-member-named-dev
|-- powerpc64-randconfig-r111-20260121
|   `-- arch-powerpc-mm-book3s64-hash_tlb.c:sparse:sparse:incorrect-type-in-initializer-(different-address-spaces)-expected-void-const-noderef-__percpu-got-struct-ppc64_tlb_batch
`-- x86_64-randconfig-123-20260122
    `-- drivers-hv-mshv_eventfd.c:sparse:sparse:restricted-__poll_t-degrades-to-integer

elapsed time: 722m

configs tested: 208
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260122    gcc-14.3.0
arc                   randconfig-002-20260122    gcc-15.2.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                        keystone_defconfig    gcc-15.2.0
arm                   randconfig-001-20260122    clang-22
arm                   randconfig-002-20260122    gcc-11.5.0
arm                   randconfig-003-20260122    gcc-15.2.0
arm                   randconfig-004-20260122    gcc-13.4.0
arm                         s3c6400_defconfig    gcc-15.2.0
arm                         socfpga_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260122    clang-22
arm64                 randconfig-002-20260122    clang-20
arm64                 randconfig-003-20260122    clang-22
arm64                 randconfig-004-20260122    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260122    gcc-12.5.0
csky                  randconfig-002-20260122    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260122    clang-20
hexagon               randconfig-002-20260122    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260122    clang-20
i386        buildonly-randconfig-002-20260122    gcc-14
i386        buildonly-randconfig-003-20260122    gcc-14
i386        buildonly-randconfig-004-20260122    gcc-14
i386        buildonly-randconfig-005-20260122    gcc-14
i386        buildonly-randconfig-006-20260122    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260122    gcc-14
i386                  randconfig-002-20260122    clang-20
i386                  randconfig-003-20260122    gcc-12
i386                  randconfig-004-20260122    gcc-14
i386                  randconfig-005-20260122    gcc-14
i386                  randconfig-006-20260122    gcc-14
i386                  randconfig-007-20260122    gcc-14
i386                  randconfig-011-20260122    clang-20
i386                  randconfig-012-20260122    clang-20
i386                  randconfig-013-20260122    clang-20
i386                  randconfig-014-20260122    clang-20
i386                  randconfig-015-20260122    clang-20
i386                  randconfig-016-20260122    clang-20
i386                  randconfig-017-20260122    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260122    gcc-15.2.0
loongarch             randconfig-002-20260122    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
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
mips                         db1xxx_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260122    gcc-11.5.0
nios2                 randconfig-002-20260122    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260122    gcc-10.5.0
parisc                randconfig-002-20260122    gcc-12.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                     rainier_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260122    gcc-14.3.0
powerpc               randconfig-002-20260122    clang-22
powerpc64             randconfig-001-20260122    clang-18
powerpc64             randconfig-002-20260122    gcc-12.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv             nommu_k210_sdcard_defconfig    gcc-15.2.0
riscv                 randconfig-001-20260122    clang-18
riscv                 randconfig-002-20260122    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260122    gcc-8.5.0
s390                  randconfig-002-20260122    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          kfr2r09_defconfig    gcc-15.2.0
sh                    randconfig-001-20260122    gcc-15.2.0
sh                    randconfig-002-20260122    gcc-11.5.0
sh                           se7722_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260122    gcc-14.3.0
sparc                 randconfig-002-20260122    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260122    clang-22
sparc64               randconfig-002-20260122    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260122    clang-22
um                    randconfig-002-20260122    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260122    clang-20
x86_64      buildonly-randconfig-002-20260122    clang-20
x86_64      buildonly-randconfig-003-20260122    clang-20
x86_64      buildonly-randconfig-004-20260122    gcc-14
x86_64      buildonly-randconfig-005-20260122    clang-20
x86_64      buildonly-randconfig-006-20260122    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260122    gcc-14
x86_64                randconfig-002-20260122    gcc-13
x86_64                randconfig-003-20260122    clang-20
x86_64                randconfig-004-20260122    clang-20
x86_64                randconfig-005-20260122    clang-20
x86_64                randconfig-006-20260122    gcc-14
x86_64                randconfig-011-20260122    gcc-14
x86_64                randconfig-012-20260122    gcc-14
x86_64                randconfig-013-20260122    clang-20
x86_64                randconfig-014-20260122    clang-20
x86_64                randconfig-015-20260122    clang-20
x86_64                randconfig-016-20260122    gcc-14
x86_64                randconfig-071-20260122    clang-20
x86_64                randconfig-072-20260122    clang-20
x86_64                randconfig-073-20260122    gcc-14
x86_64                randconfig-074-20260122    clang-20
x86_64                randconfig-075-20260122    gcc-14
x86_64                randconfig-076-20260122    clang-20
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
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260122    gcc-8.5.0
xtensa                randconfig-002-20260122    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

