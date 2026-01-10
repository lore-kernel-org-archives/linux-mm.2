Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984D2D277E1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 10:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336336B0088; Sat, 10 Jan 2026 05:58:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4266B0089; Sat, 10 Jan 2026 05:58:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2A06B008A; Sat, 10 Jan 2026 05:58:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 094196B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:58:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F45888CCF
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 10:58:54 +0000 (UTC)
X-FDA: 84315756588.19.7937E9A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83AF0100007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 10:58:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WkAkw6dX;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768042732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ZwsFIw01T6xr8MPglE4k5NTKKgf4uAQGsK7utIRtCPw=;
	b=4Fc8IT0USrmuI52I9X0kI0hJVSwqdxqcGaS1p4nfO6Fz4Teun/xvBHLZZ1Q2Ur4ziC4z6w
	IixPYrv4ycikZlbHO99LG78UkNh99YlEoX1LQ0EVFmVYViMyfar36vbqWm0P4c0ssnExdY
	2GrTddZLuG7IAPQh9ZoDO/QBPUZGPkc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WkAkw6dX;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768042732; a=rsa-sha256;
	cv=none;
	b=wvNYGbmiQRuPwCDw9hdZEFKC0Tz0rZ3+AaT6CFTNST/oJa50smPAC0kcLkhOf4Akvf5liB
	Utz4QfcsWp/viGngUO6pkkiVuX2wsRz26PR8Z/8fXzMuVNDua23IybaDQmdVk/SQAcVpGs
	pvLkqGaVwR3Y56AevYz8X7jqUDXspJI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768042731; x=1799578731;
  h=date:from:to:cc:subject:message-id;
  bh=37XcmcZ/+2iqj0cPzvXcRWtQr/cA1+9op39wl44g9hs=;
  b=WkAkw6dXycHz2KH33KxfBVeifbmX/F1bXj7j47I7G99JAObH7unJd+A0
   DuWJP31AiUieI7YjB4CyazXsa2DY8qc/HWwhqA6V/4fBgVWu1PeJ63h/y
   tQHmzfCxbh/zLFW8ObtHe6ZRwZJHxXIaGiEi/gLyVZnhrcEfz6/qMmHiQ
   P+jDXQHilJPgCvXElbs3j3PjwNzT8mF8HHzscvwmow/uy+R2uqnFGdO3a
   rO12qvP1TuM1s3gVH/G4p3Rs/nu5oBNvjQ9XL42RmmUT5wEWRVeAOsUI+
   cAL52hPw3oNQxMvlyn6fJ3p3YOkWZkY8MbbiC1zr7+np6M6smZTyCLGqh
   Q==;
X-CSE-ConnectionGUID: wK51Br+pQCK7LnnTCvWUOQ==
X-CSE-MsgGUID: 8XS3pfxCR5eeu4gEe47JYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69558497"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69558497"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2026 02:58:49 -0800
X-CSE-ConnectionGUID: c2cAO71lTya2v3exSvqr2w==
X-CSE-MsgGUID: QieriMDxTNCC/LOglPkKfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="234887521"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 10 Jan 2026 02:58:48 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1veWgA-000000008Z7-1FPx;
	Sat, 10 Jan 2026 10:58:46 +0000
Date: Sat, 10 Jan 2026 18:58:18 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 f56ccc32468ee7885d3a9175e7d2cb608d301521
Message-ID: <202601101813.w6fo8MeL-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 83AF0100007
X-Stat-Signature: c368f5xjuq14wg5m1i9q9hs1xm3ayu9z
X-HE-Tag: 1768042731-276438
X-HE-Meta: U2FsdGVkX18IbREugboMrUE6+1pl2/ZjK4dkFUlCXvB3XzzjwG0jpSQwDxtAAo3wUaNHs1NeOCNTIOs2i3C49+gjmRyJVJssnBZC9WcxkAiHY9qO6EzkPs6lp7AErLfqdA8ic8xYiT53JZMDcz0lXFfkmmguyDRQU9HRtmCE4jzL2zGsMPi9eFl+fVF8OFIPjWpFGd11uKa2oevyWcS5a9HhKKpVGAPO/dX2+bKYn0wr5BYapTabvhFtMRANY6WcEZv/ed0D1Laojdpql61PpMSZRHRnHU2b59vxRXt08TiVgGBLyPf8QWYv8l5gPlL/Ufgju5RUw2GSHiJyg06fLSMyiYbLWlj5gPQlAwQiLSSCa1ACrdaCsyWJ3PLYgBDUVlKG5UJCWMW3DkTmWjtCw+Oi5my+xxET917jXwaq/b/sal3irQIkHl/vhgFMj4ap1PhwEJBdjIKR2SLwlyIKZOPJ+Svp3ZvsMV6Kq+J+8E/AZxvjtkJYuBGdUqMnesMkV5wVOEWQPNc7MdTlpsy45nwNsn8ZGDTXW9k0enwmIx+A3VuPAAxPcsoQW1UxKPDVoL2aW3ljpOsg+FoxSEzSKrXMYVZ+0W1IJjTe06/6bhBbmO3eDmflRJ0u7UGLdBis6/ChdV6V1ugjS5mg/BWxoIk8sheXpg//H2VLUGwYsKfAFBf0bEpSwjqRQ4/JQZtr7iCGS6UvMdLC+gL7dfvlY9tQolRz3Xy9BeRYHbtK/OsEqP8+G6pz4aKSRqLGxjGWEdqhG31uG9jp6jGyGQXphVHe+Xlz3tbv7f4wc0ru50A+24C6dj+WJUf5ixDV4DDNl8bKpO6kyxG1bAj5DXp6blvROhFj74+qpJlOzuTqBqGDKpouXCG0BpHdCe6+vdPFr63oei4zWzNj8RoBlO9w58pAHssalR23fyzZz1t/9P6Wh50MfltPskc/wkjbwGNEg6PnQJsWobDmeqUEbO2
 ffxuGTE5
 +4K3qiQQVHE51vCoLSBubGL/Zm7o0IT+62rLhmt6o9YNxLVB7UW7GExGte8lx4JdO6Elu0tCodWcKpntAEnOcln3KMsD1tv66ddHsm+eKS/i9aL0gp5aoSYMTXrJxt2dX/91ou2nC/ENW44WX93GhCZ/CEXXBzWTzUNpj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: f56ccc32468ee7885d3a9175e7d2cb608d301521  mm/memtest: add underflow detection for size calculation

elapsed time: 1501m

configs tested: 247
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                                 defconfig    gcc-15.2.0
arc                        nsimosci_defconfig    gcc-15.2.0
arc                 nsimosci_hs_smp_defconfig    clang-22
arc                   randconfig-001-20260110    clang-22
arc                   randconfig-001-20260110    gcc-13.4.0
arc                   randconfig-002-20260110    clang-22
arc                   randconfig-002-20260110    gcc-8.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                         bcm2835_defconfig    clang-22
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    clang-22
arm                         orion5x_defconfig    clang-22
arm                   randconfig-001-20260110    clang-22
arm                   randconfig-002-20260110    clang-22
arm                   randconfig-002-20260110    gcc-12.5.0
arm                   randconfig-003-20260110    clang-22
arm                   randconfig-003-20260110    gcc-8.5.0
arm                   randconfig-004-20260110    clang-22
arm                       versatile_defconfig    gcc-15.2.0
arm                        vexpress_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260110    gcc-10.5.0
arm64                 randconfig-001-20260110    gcc-15.2.0
arm64                 randconfig-002-20260110    gcc-10.5.0
arm64                 randconfig-003-20260110    gcc-10.5.0
arm64                 randconfig-003-20260110    gcc-12.5.0
arm64                 randconfig-004-20260110    gcc-10.5.0
arm64                 randconfig-004-20260110    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260110    gcc-10.5.0
csky                  randconfig-001-20260110    gcc-15.2.0
csky                  randconfig-002-20260110    gcc-10.5.0
csky                  randconfig-002-20260110    gcc-15.2.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260110    clang-22
hexagon               randconfig-002-20260110    clang-22
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260110    gcc-14
i386        buildonly-randconfig-002-20260110    gcc-14
i386        buildonly-randconfig-003-20260110    gcc-12
i386        buildonly-randconfig-003-20260110    gcc-14
i386        buildonly-randconfig-004-20260110    clang-20
i386        buildonly-randconfig-004-20260110    gcc-14
i386        buildonly-randconfig-005-20260110    gcc-14
i386        buildonly-randconfig-006-20260110    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260110    gcc-12
i386                  randconfig-001-20260110    gcc-14
i386                  randconfig-002-20260110    gcc-14
i386                  randconfig-003-20260110    gcc-12
i386                  randconfig-003-20260110    gcc-14
i386                  randconfig-004-20260110    clang-20
i386                  randconfig-004-20260110    gcc-14
i386                  randconfig-005-20260110    gcc-14
i386                  randconfig-006-20260110    clang-20
i386                  randconfig-006-20260110    gcc-14
i386                  randconfig-007-20260110    gcc-14
i386                  randconfig-011-20260110    clang-20
i386                  randconfig-011-20260110    gcc-14
i386                  randconfig-012-20260110    gcc-14
i386                  randconfig-013-20260110    gcc-14
i386                  randconfig-014-20260110    clang-20
i386                  randconfig-014-20260110    gcc-14
i386                  randconfig-015-20260110    clang-20
i386                  randconfig-015-20260110    gcc-14
i386                  randconfig-016-20260110    clang-20
i386                  randconfig-016-20260110    gcc-14
i386                  randconfig-017-20260110    clang-20
i386                  randconfig-017-20260110    gcc-14
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260110    clang-22
loongarch             randconfig-002-20260110    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                         amcore_defconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          eyeq6_defconfig    gcc-15.2.0
mips                malta_qemu_32r6_defconfig    gcc-15.2.0
mips                          rb532_defconfig    clang-18
nios2                            allmodconfig    clang-22
nios2                             allnoconfig    clang-22
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260110    clang-22
nios2                 randconfig-001-20260110    gcc-8.5.0
nios2                 randconfig-002-20260110    clang-22
nios2                 randconfig-002-20260110    gcc-11.5.0
openrisc                         allmodconfig    clang-22
openrisc                          allnoconfig    clang-22
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                generic-64bit_defconfig    clang-22
parisc                randconfig-001-20260110    gcc-14.3.0
parisc                randconfig-002-20260110    gcc-13.4.0
parisc                randconfig-002-20260110    gcc-14.3.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                      katmai_defconfig    clang-22
powerpc                 mpc834x_itx_defconfig    clang-16
powerpc               randconfig-001-20260110    gcc-14.3.0
powerpc               randconfig-001-20260110    gcc-8.5.0
powerpc               randconfig-002-20260110    gcc-10.5.0
powerpc               randconfig-002-20260110    gcc-14.3.0
powerpc                     skiroot_defconfig    clang-22
powerpc                     taishan_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260110    gcc-14.3.0
powerpc64             randconfig-002-20260110    clang-22
powerpc64             randconfig-002-20260110    gcc-14.3.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260110    clang-22
riscv                 randconfig-001-20260110    gcc-15.2.0
riscv                 randconfig-002-20260110    clang-22
riscv                 randconfig-002-20260110    gcc-15.2.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260110    gcc-15.2.0
s390                  randconfig-001-20260110    gcc-9.5.0
s390                  randconfig-002-20260110    clang-22
s390                  randconfig-002-20260110    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260110    gcc-15.2.0
sh                    randconfig-002-20260110    gcc-12.5.0
sh                    randconfig-002-20260110    gcc-15.2.0
sh                   rts7751r2dplus_defconfig    clang-22
sh                          sdk7786_defconfig    gcc-15.2.0
sh                           sh2007_defconfig    gcc-15.2.0
sh                        sh7785lcr_defconfig    gcc-15.2.0
sh                            titan_defconfig    clang-22
sparc                             allnoconfig    clang-22
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260110    clang-22
sparc                 randconfig-001-20260110    gcc-14.3.0
sparc                 randconfig-002-20260110    clang-22
sparc                 randconfig-002-20260110    gcc-15.2.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260110    clang-22
sparc64               randconfig-002-20260110    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260110    clang-22
um                    randconfig-001-20260110    gcc-14
um                    randconfig-002-20260110    clang-22
um                    randconfig-002-20260110    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260110    gcc-14
x86_64      buildonly-randconfig-002-20260110    clang-20
x86_64      buildonly-randconfig-002-20260110    gcc-14
x86_64      buildonly-randconfig-003-20260110    clang-20
x86_64      buildonly-randconfig-003-20260110    gcc-14
x86_64      buildonly-randconfig-004-20260110    gcc-14
x86_64      buildonly-randconfig-005-20260110    gcc-14
x86_64      buildonly-randconfig-006-20260110    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260110    clang-20
x86_64                randconfig-002-20260110    clang-20
x86_64                randconfig-002-20260110    gcc-14
x86_64                randconfig-003-20260110    clang-20
x86_64                randconfig-004-20260110    clang-20
x86_64                randconfig-005-20260110    clang-20
x86_64                randconfig-005-20260110    gcc-14
x86_64                randconfig-006-20260110    clang-20
x86_64                randconfig-011-20260110    clang-20
x86_64                randconfig-012-20260110    clang-20
x86_64                randconfig-012-20260110    gcc-14
x86_64                randconfig-013-20260110    clang-20
x86_64                randconfig-013-20260110    gcc-14
x86_64                randconfig-014-20260110    clang-20
x86_64                randconfig-015-20260110    clang-20
x86_64                randconfig-015-20260110    gcc-14
x86_64                randconfig-016-20260110    clang-20
x86_64                randconfig-071-20260110    clang-20
x86_64                randconfig-072-20260110    clang-20
x86_64                randconfig-073-20260110    clang-20
x86_64                randconfig-074-20260110    clang-20
x86_64                randconfig-075-20260110    clang-20
x86_64                randconfig-075-20260110    gcc-14
x86_64                randconfig-076-20260110    clang-20
x86_64                randconfig-076-20260110    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                           allyesconfig    clang-22
xtensa                randconfig-001-20260110    clang-22
xtensa                randconfig-001-20260110    gcc-10.5.0
xtensa                randconfig-002-20260110    clang-22
xtensa                randconfig-002-20260110    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

