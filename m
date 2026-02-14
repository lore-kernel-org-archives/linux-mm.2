Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A22CEF584C
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 21:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77ED6B0005; Sat, 14 Feb 2026 16:38:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58FF6B0088; Sat, 14 Feb 2026 16:38:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58006B008A; Sat, 14 Feb 2026 16:38:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 903DB6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:38:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F2655B9C4
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:38:59 +0000 (UTC)
X-FDA: 84444377598.29.A2DBB57
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9691540004
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:38:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TyE9L9SJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771105137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hNCAQAXQIRCpcKPFi8VexrP/9/mewLDwICrOVdRv3qo=;
	b=FADU1bV62AF8940Dg3npoqflHV6Wwfbduc3slavTD9JFZzvwI3GvLYzpdWxRa0liaMx9Rt
	JL5IcOYhKJhgdnr+RXtPMpYClTNki6UlxbHEWjDWY97c++PhAmZ+tha/Q+LeFBvMBCoceF
	crCUk6qAk/S4GxH3GCVj9M0T64JY4O0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771105137; a=rsa-sha256;
	cv=none;
	b=j9Rib7cAMs/WVTP0airC8BeIGH2RghBkCr58oKQsJ1ujoDqvppPHx3JsFLYybey+ZVAib5
	rCpsZQPl58IcIBcyY2kiOKjrwow+QoIuh4+pjVmU8ZZyx1ETlgEmuB3lcQ7IX6R6tzYfxN
	L8E4iGhtNqq8qvDpkN+cBHPK7Jlkee8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TyE9L9SJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771105137; x=1802641137;
  h=date:from:to:cc:subject:message-id;
  bh=hAtqtQbO40GNmmL7sgi66vRRG493cnOlH2knwn63YN0=;
  b=TyE9L9SJP0LEuHDDIvAUGn40h8oKACHVFleXyxdBkzwD2KW/1sQlY/iU
   ZL1rGS4RxwOhEQvQGy94xHcYmb5UTAqOYAFOQTE5cq60qvSI/0uAeD9rb
   TmSw4nwH1qmXMi+QxIokm79fAN6RGb67XgnhAfnuWsMAvwK7L71pAPZu4
   f4V7xu+KjnMmxPKYuXFt7mvVCOQH/8XYk/R/EoqFRKnDdtW50EE6lGYfI
   aHL6UpL/RfLjq9Mem4EFg65sg1HvHK/34opFNEqzO6D6Ax8kYRMjErrVw
   SDTRwnFRXL4C/FfS3EWslGj/R5asRVcCTQLb0K3wP8wmQKWWPs68OK0B8
   Q==;
X-CSE-ConnectionGUID: DxlvzL/nQBCgKfapbahWtw==
X-CSE-MsgGUID: 54iXXsbpQcib1sm3aUYQxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11701"; a="76103193"
X-IronPort-AV: E=Sophos;i="6.21,291,1763452800"; 
   d="scan'208";a="76103193"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2026 13:38:55 -0800
X-CSE-ConnectionGUID: 8UaAbZ0TTEu3gikYrPL2Ig==
X-CSE-MsgGUID: uO2PFwk2QTOEMXZhVJkyjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,291,1763452800"; 
   d="scan'208";a="236221148"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 14 Feb 2026 13:38:53 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vrNLn-00000000wzo-2E2l;
	Sat, 14 Feb 2026 21:38:51 +0000
Date: Sun, 15 Feb 2026 05:38:30 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 f043a93fff9e3e3e648b6525483f59104b0819fa
Message-ID: <202602150521.FnpRwbe6-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 9691540004
X-Stat-Signature: jnorjmskrsm6yqteafpfo9hyxbjhtyiw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771105136-633399
X-HE-Meta: U2FsdGVkX1+uQeFOU3fcjheFdM4EAZQKBphBGJFzIx1g2GdnsZboyTrGF3cwrFqy0jKOr5/QWRHEewLnQ38k/RkG6hoUhiStwta8cyKa1cuj1kNY0Gc2TNGLwlR0YHjKPf9cJ+twbD+mRFEd8ncGwZZ88ctxfQea7U4eFtW/d7JIZTqqOqhmXIHvMqOGP1T6/RmQGbRPEkPTADr/s3UMsMTdehPH4lPRMPHpDOoiA3ebpQuFrerRRTK9M/wWslja6za5ca5tqXFZbVKmGlRQDTbA5GxibTRj+aH6QSBdi+pOon2TsppMl6bDzIlY1+EI5mt4FaMD3/Fy57AmuZUZLG8cYdh7zMFXMvUOJTlyraYuYvuY2fxizfXInx21WsgJATAeRvFRKfbBcfDij/eD+0yyluyRMWQLXN27S7DWGrLj/UsYTpvlM6m1q20mP94NKuM9FS8VmSdojw0N3PuSjay8NfY9toYhBWmpsgCiaL5lBBu2S4QGalZxOKFMFg7ryFXvNZPPfdoSxJo+xQxFppfmEJNNP/eF9aEL+/zKFEKWs+WCl3VMzXt56nzyhiMOCVFyR0MmuYs70HrQ8bFVfcXzjodEAArGGnPs1S/1EXfAElz2cexG4Jmj9rSbtRWMJx7TlHjHOzW29eymkRIm4sECh26u40fo3SlDpliz8hzsZlqyINQoDHHwJM6yx1+zWmZ8UqSDRuBRvOh/EbAdYXY70e1Xpl+h8KNYbNRnVGOqsGgscw3Uo0e2Wvqy5+DWr8AmmMGEI5NsPUBNRJ8MyDPk6O2a72u3ra6/YC9GBQkMKhcgvElG/SaFxNlp5quBibkxKTExq/R6PuZPOt1UCUrmw5xyoj8Nmr821IfaBbGig3SXIL/vH4korTJcMQzmSzD1kv80n3UrE/lylgkaEI4PZcfNxGQk6xGBCmIvENkrwdLo2J/S4d/+NHrrOMydR4bD1YHdQwfl8OIdzAK
 bZ1qYLqn
 iIS3gFxVttokVu/qLYiNwn3nkgYAx36pZgsf31kadHoPTa1qz1r881sfyzHdHW/M+vYjE7p30BMXu3/cn2fsJwIxJ231WKhymUzvMJzzhQmP6A6WoD2dezQfEFNquETFFVvMah+Ptx5z+Gc85+6Tsw03a2toGRlp5x/SU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: f043a93fff9e3e3e648b6525483f59104b0819fa  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

elapsed time: 794m

configs tested: 335
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                 nsimosci_hs_smp_defconfig    gcc-15.2.0
arc                   randconfig-001-20260214    clang-22
arc                   randconfig-001-20260214    gcc-13.4.0
arc                   randconfig-001-20260215    clang-20
arc                   randconfig-002-20260214    clang-22
arc                   randconfig-002-20260214    gcc-9.5.0
arc                   randconfig-002-20260215    clang-20
arc                        vdk_hs38_defconfig    clang-22
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                             mxs_defconfig    clang-22
arm                          pxa910_defconfig    gcc-15.2.0
arm                   randconfig-001-20260214    clang-22
arm                   randconfig-001-20260214    gcc-13.4.0
arm                   randconfig-001-20260215    clang-20
arm                   randconfig-002-20260214    clang-22
arm                   randconfig-002-20260215    clang-20
arm                   randconfig-003-20260214    clang-22
arm                   randconfig-003-20260215    clang-20
arm                   randconfig-004-20260214    clang-22
arm                   randconfig-004-20260214    gcc-8.5.0
arm                   randconfig-004-20260215    clang-20
arm                        spear3xx_defconfig    gcc-15.2.0
arm                        spear6xx_defconfig    clang-22
arm                       versatile_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260214    clang-22
arm64                 randconfig-001-20260215    gcc-8.5.0
arm64                 randconfig-002-20260214    gcc-8.5.0
arm64                 randconfig-002-20260215    gcc-8.5.0
arm64                 randconfig-003-20260214    gcc-14.3.0
arm64                 randconfig-003-20260215    gcc-8.5.0
arm64                 randconfig-004-20260214    gcc-14.3.0
arm64                 randconfig-004-20260215    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260214    gcc-12.5.0
csky                  randconfig-001-20260215    gcc-8.5.0
csky                  randconfig-002-20260214    gcc-14.3.0
csky                  randconfig-002-20260215    gcc-8.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260214    clang-22
hexagon               randconfig-001-20260215    clang-22
hexagon               randconfig-002-20260214    clang-22
hexagon               randconfig-002-20260215    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260214    clang-20
i386        buildonly-randconfig-001-20260215    gcc-14
i386        buildonly-randconfig-002-20260214    clang-20
i386        buildonly-randconfig-002-20260215    gcc-14
i386        buildonly-randconfig-003-20260214    clang-20
i386        buildonly-randconfig-003-20260215    gcc-14
i386        buildonly-randconfig-004-20260214    clang-20
i386        buildonly-randconfig-004-20260215    gcc-14
i386        buildonly-randconfig-005-20260214    clang-20
i386        buildonly-randconfig-005-20260215    gcc-14
i386        buildonly-randconfig-006-20260214    clang-20
i386        buildonly-randconfig-006-20260215    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260214    clang-20
i386                  randconfig-001-20260215    clang-20
i386                  randconfig-002-20260214    clang-20
i386                  randconfig-002-20260215    clang-20
i386                  randconfig-003-20260214    clang-20
i386                  randconfig-003-20260215    clang-20
i386                  randconfig-004-20260214    clang-20
i386                  randconfig-004-20260214    gcc-14
i386                  randconfig-004-20260215    clang-20
i386                  randconfig-005-20260214    clang-20
i386                  randconfig-005-20260215    clang-20
i386                  randconfig-006-20260214    clang-20
i386                  randconfig-006-20260214    gcc-14
i386                  randconfig-006-20260215    clang-20
i386                  randconfig-007-20260214    clang-20
i386                  randconfig-007-20260214    gcc-14
i386                  randconfig-007-20260215    clang-20
i386                  randconfig-011-20260214    gcc-14
i386                  randconfig-011-20260215    clang-20
i386                  randconfig-012-20260214    gcc-14
i386                  randconfig-012-20260215    clang-20
i386                  randconfig-013-20260214    gcc-14
i386                  randconfig-013-20260215    clang-20
i386                  randconfig-014-20260214    gcc-14
i386                  randconfig-014-20260215    clang-20
i386                  randconfig-015-20260214    clang-20
i386                  randconfig-015-20260214    gcc-14
i386                  randconfig-015-20260215    clang-20
i386                  randconfig-016-20260214    clang-20
i386                  randconfig-016-20260214    gcc-14
i386                  randconfig-016-20260215    clang-20
i386                  randconfig-017-20260214    clang-20
i386                  randconfig-017-20260214    gcc-14
i386                  randconfig-017-20260215    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260214    clang-22
loongarch             randconfig-001-20260214    gcc-14.3.0
loongarch             randconfig-001-20260215    clang-22
loongarch             randconfig-002-20260214    clang-22
loongarch             randconfig-002-20260215    clang-22
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
mips                          eyeq6_defconfig    clang-22
mips                        vocore2_defconfig    clang-22
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260214    clang-22
nios2                 randconfig-001-20260214    gcc-10.5.0
nios2                 randconfig-001-20260215    clang-22
nios2                 randconfig-002-20260214    clang-22
nios2                 randconfig-002-20260214    gcc-8.5.0
nios2                 randconfig-002-20260215    clang-22
openrisc                         allmodconfig    clang-22
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
parisc                randconfig-001-20260214    clang-22
parisc                randconfig-001-20260214    gcc-9.5.0
parisc                randconfig-001-20260215    clang-22
parisc                randconfig-002-20260214    clang-22
parisc                randconfig-002-20260214    gcc-15.2.0
parisc                randconfig-002-20260215    clang-22
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                    gamecube_defconfig    clang-22
powerpc                 mpc837x_rdb_defconfig    gcc-15.2.0
powerpc                         ps3_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260214    clang-18
powerpc               randconfig-001-20260214    clang-22
powerpc               randconfig-001-20260215    clang-22
powerpc               randconfig-002-20260214    clang-22
powerpc               randconfig-002-20260215    clang-22
powerpc64                        alldefconfig    gcc-15.2.0
powerpc64             randconfig-001-20260214    clang-22
powerpc64             randconfig-001-20260215    clang-22
powerpc64             randconfig-002-20260214    clang-22
powerpc64             randconfig-002-20260215    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260214    clang-20
riscv                 randconfig-001-20260214    gcc-8.5.0
riscv                 randconfig-001-20260215    gcc-13.4.0
riscv                 randconfig-002-20260214    clang-20
riscv                 randconfig-002-20260214    gcc-14.3.0
riscv                 randconfig-002-20260215    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260214    clang-20
s390                  randconfig-001-20260215    gcc-13.4.0
s390                  randconfig-002-20260214    clang-20
s390                  randconfig-002-20260214    gcc-9.5.0
s390                  randconfig-002-20260215    gcc-13.4.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          r7780mp_defconfig    clang-22
sh                    randconfig-001-20260214    clang-20
sh                    randconfig-001-20260214    gcc-10.5.0
sh                    randconfig-001-20260215    gcc-13.4.0
sh                    randconfig-002-20260214    clang-20
sh                    randconfig-002-20260214    gcc-15.2.0
sh                    randconfig-002-20260215    gcc-13.4.0
sh                           se7619_defconfig    clang-22
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260214    gcc-14.3.0
sparc                 randconfig-001-20260214    gcc-8.5.0
sparc                 randconfig-001-20260215    gcc-9.5.0
sparc                 randconfig-002-20260214    gcc-14.3.0
sparc                 randconfig-002-20260215    gcc-9.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260214    gcc-14.3.0
sparc64               randconfig-001-20260214    gcc-9.5.0
sparc64               randconfig-001-20260215    gcc-9.5.0
sparc64               randconfig-002-20260214    gcc-14.3.0
sparc64               randconfig-002-20260214    gcc-8.5.0
sparc64               randconfig-002-20260215    gcc-9.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260214    gcc-14
um                    randconfig-001-20260214    gcc-14.3.0
um                    randconfig-001-20260215    gcc-9.5.0
um                    randconfig-002-20260214    clang-22
um                    randconfig-002-20260214    gcc-14.3.0
um                    randconfig-002-20260215    gcc-9.5.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260214    clang-20
x86_64      buildonly-randconfig-001-20260214    gcc-13
x86_64      buildonly-randconfig-001-20260215    clang-20
x86_64      buildonly-randconfig-002-20260214    clang-20
x86_64      buildonly-randconfig-002-20260214    gcc-14
x86_64      buildonly-randconfig-002-20260215    clang-20
x86_64      buildonly-randconfig-003-20260214    clang-20
x86_64      buildonly-randconfig-003-20260215    clang-20
x86_64      buildonly-randconfig-004-20260214    clang-20
x86_64      buildonly-randconfig-004-20260215    clang-20
x86_64      buildonly-randconfig-005-20260214    clang-20
x86_64      buildonly-randconfig-005-20260215    clang-20
x86_64      buildonly-randconfig-006-20260214    clang-20
x86_64      buildonly-randconfig-006-20260214    gcc-14
x86_64      buildonly-randconfig-006-20260215    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260214    clang-20
x86_64                randconfig-001-20260215    gcc-14
x86_64                randconfig-002-20260214    clang-20
x86_64                randconfig-002-20260214    gcc-14
x86_64                randconfig-002-20260215    gcc-14
x86_64                randconfig-003-20260214    clang-20
x86_64                randconfig-003-20260214    gcc-14
x86_64                randconfig-003-20260215    gcc-14
x86_64                randconfig-004-20260214    clang-20
x86_64                randconfig-004-20260214    gcc-14
x86_64                randconfig-004-20260215    gcc-14
x86_64                randconfig-005-20260214    clang-20
x86_64                randconfig-005-20260215    gcc-14
x86_64                randconfig-006-20260214    clang-20
x86_64                randconfig-006-20260214    gcc-14
x86_64                randconfig-006-20260215    gcc-14
x86_64                randconfig-011-20260214    clang-20
x86_64                randconfig-012-20260214    gcc-14
x86_64                randconfig-013-20260214    gcc-14
x86_64                randconfig-014-20260214    clang-20
x86_64                randconfig-015-20260214    gcc-14
x86_64                randconfig-016-20260214    gcc-14
x86_64                randconfig-071-20260214    clang-20
x86_64                randconfig-071-20260215    gcc-14
x86_64                randconfig-072-20260214    clang-20
x86_64                randconfig-072-20260215    gcc-14
x86_64                randconfig-073-20260214    clang-20
x86_64                randconfig-073-20260215    gcc-14
x86_64                randconfig-074-20260214    clang-20
x86_64                randconfig-074-20260215    gcc-14
x86_64                randconfig-075-20260214    clang-20
x86_64                randconfig-075-20260214    gcc-14
x86_64                randconfig-075-20260215    gcc-14
x86_64                randconfig-076-20260214    clang-20
x86_64                randconfig-076-20260215    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                       common_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260214    gcc-14.3.0
xtensa                randconfig-001-20260214    gcc-15.2.0
xtensa                randconfig-001-20260215    gcc-9.5.0
xtensa                randconfig-002-20260214    gcc-14.3.0
xtensa                randconfig-002-20260215    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

