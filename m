Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64800106F2E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36626B0005; Thu, 26 Mar 2026 03:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D5B6B0088; Thu, 26 Mar 2026 03:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FBE56B0089; Thu, 26 Mar 2026 03:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4D76B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:44:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CDC6C38B0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:44:08 +0000 (UTC)
X-FDA: 84587425776.29.1F495AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3526880004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:44:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bx75NmXw;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774511046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=p+6dQiMk6RFAg27g2xsfX16Y/EPO+E2x1qBLUWKb/kQ=;
	b=HpLIQ1yxvrRdWYjgom5VmYX4WY8VjHlQ99T5JymoUKA1jKeUW8ocWu1Cfq3e0b3NXWVGck
	8Sm0y1Uxh+hAQfpeNOTAtWkXpRr1d+512BYNJAdKwj0MRPx5x11oPftas/7JANSZy+wAsI
	etBVJDl846vv+/OAh3yAdtCu4l7dUR8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bx75NmXw;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774511046; a=rsa-sha256;
	cv=none;
	b=A9yNe/kH7pFzvxWlWw4uisLS2QJ1k0w1sdkgt48Fl3oO8ReY941R4BjLeZWSkb9XGZHSRN
	16JewWFjWjWseoJwIS5pXuUGFE/VAZkqnsWibSepYHPF3W3Hjf+Os9l4Y7837ZpFyDubaS
	pbXB17yTtJPwb6i/2X1A5QSGFAYbsxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774511046; x=1806047046;
  h=date:from:to:cc:subject:message-id;
  bh=EWrtSPZOCRXSiXaTYXe79tKLlMRev9TODs2l3vF0Y4I=;
  b=bx75NmXwrno1p0cZADL4fsanhCqpSqSiAcwsP/aNtwXK2AUePV4C0A+B
   O3EqCcHez253OL+q3WHaLY+WU2/Ps0gVP7183qvRCajxMbWs7looLWJRL
   VsX2PGHUyFVBVTABb+dvJxDrZPFeRMXZfUf2nSNbq+LJAAgCAiNcqw4os
   gniu/9vZP2U3JiyKh+yBczn8AghGs7AD/Bs3WgKngmwzNvPeUHHDkFWH5
   V0yZcMj3wMhiZZbI7OVjOx4RLJ0sO3aZ4pvJzlWjBmoauQkZmBdgcKOvE
   5WDrp2a7+axLwOauH1jrpk/NJBEevY4vG6Ce7W7WivpHjJp/kbfGFAquf
   g==;
X-CSE-ConnectionGUID: azXKaU4kTFO5TkM4xA1p2g==
X-CSE-MsgGUID: /1gxmhrHTpy3VKp26uBdLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="63112320"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="63112320"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 00:44:05 -0700
X-CSE-ConnectionGUID: BFL2HugaSyOcgAyZsuzSsw==
X-CSE-MsgGUID: Hv8D1UZDSe6LvpabJQCTMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="222025358"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 26 Mar 2026 00:44:03 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5fNo-000000008aL-1GnY;
	Thu, 26 Mar 2026 07:44:00 +0000
Date: Thu, 26 Mar 2026 15:43:42 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 c7fc9cde41be029cf6675befbafcbb2dab40b39b
Message-ID: <202603261534.B0b3xg7V-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3526880004
X-Stat-Signature: 5u333ix51expfq3qntkndd4futifbunr
X-Rspam-User: 
X-HE-Tag: 1774511046-83544
X-HE-Meta: U2FsdGVkX1+skW3t3h1FAPxk5aYdiU2GwX+DVgYqTHUl5CXT/f+bvt3NLuIhpqkfSIPIqen14dfeXTrvoSenDsygeXb4tK5b+xLiflyYRk9OsEFQSd5ruOpa3JEj4PoXIS0uFqsyBjpfFeZH4sOogvaCO1Xo59plpVpuu8naQrViI3VhbJh+41ZpKP4WrrspjOCNt3iSJiehDc3nxv/1c0y7VneY0GE/6h8AxulGe64C14LsQy0lCXpDIl/hsLdFsEJecjXDoQPlDNMSr0Eju7p+vNWdVUSbMZX1kHR6pbroKer2jG5ZmU+plWJDwWpnkLKl7dGgVNFErUjauinIGH2ZDDGw0QevYKhRLOaS9MhqFfkP2tnWf8MfefOCobZudHc2kWvR/Qig4S39jm5OZCDsUxGY97xXXmXyIa2Y/Z298kUosgIRDcK9u4rLWVwjQQseC8gw76GMuWEpGbl2/0j99sfeNXAhktKsjZZkwYo0uW1FreJOs7FNTkLVlsTvcxI0a19brNKR7ivo2p4qOJ4WZqjZVtBQRH4rNFAAHaBKCNPqPZdUFn1lVDmZi0V5SWXsipdj9XONIROfEupCUVrvDQTlPO1t610PfeFd+9WCh5VwjjPsbA+A8wO8Sxsey8vKVxJR9WDo44QHpzX+xZhjIHsfGfx/P8lO6kgb26jvVxdcuJODPKN9ZXpOe5CuIwwB3EGvyxY3IuQ4Dnw0/JH/Zr3ivVOzthhb9pqmPeP14vQll/anc/aQZy/3y0q59E/s9J1geq16oodGGsoHVoRUIgnLV3SYdCOLQb/PtyFrXj3MF+drKeiCf1i/2ZZQrOpsfZlbY1t+gFLOaDnOoZBFKmqKE2XjxlsOCLcU7cOfKfQTjMgeEjesJ3Bvt3cAFBfnfdaWJ35dZgtjT2WHnQK2f9qLJ6o1aHLZ36+V5SoMuWlCEjg0GSmBoDtynDSuHFxUFWQs7fMISrdqqX7
 W/dFHzrS
 bkWc/n8wDBIg6YDyXWvsH7L/habRA2DjCqLiNP0HmC2oouZJil2vuo0HAtyvkIzBcr71qeOa6sqbBr3gF5W887m2DNuVvpsFDBPKKnygtewx2OFf92vzqvag6GP5DbzZsDmNOEU1hphLve+UHLBoyw5uOqN4j/7iEuBzu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: c7fc9cde41be029cf6675befbafcbb2dab40b39b  memblock: warn when freeing reserved memory before memory map is initialized

elapsed time: 761m

configs tested: 170
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260326    gcc-8.5.0
arc                   randconfig-002-20260326    gcc-8.5.0
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                       aspeed_g5_defconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                        keystone_defconfig    gcc-15.2.0
arm                   randconfig-001-20260326    gcc-8.5.0
arm                   randconfig-002-20260326    gcc-8.5.0
arm                   randconfig-003-20260326    gcc-8.5.0
arm                   randconfig-004-20260326    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260326    clang-19
arm64                 randconfig-002-20260326    clang-19
arm64                 randconfig-003-20260326    clang-19
arm64                 randconfig-004-20260326    clang-19
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260326    clang-19
csky                  randconfig-002-20260326    clang-19
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260326    gcc-8.5.0
hexagon               randconfig-002-20260326    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260326    gcc-14
i386        buildonly-randconfig-002-20260326    gcc-14
i386        buildonly-randconfig-003-20260326    gcc-14
i386        buildonly-randconfig-004-20260326    gcc-14
i386        buildonly-randconfig-005-20260326    gcc-14
i386        buildonly-randconfig-006-20260326    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260326    gcc-14
i386                  randconfig-002-20260326    gcc-14
i386                  randconfig-003-20260326    gcc-14
i386                  randconfig-004-20260326    gcc-14
i386                  randconfig-005-20260326    gcc-14
i386                  randconfig-006-20260326    gcc-14
i386                  randconfig-007-20260326    gcc-14
i386                  randconfig-011-20260326    clang-20
i386                  randconfig-012-20260326    clang-20
i386                  randconfig-013-20260326    clang-20
i386                  randconfig-014-20260326    clang-20
i386                  randconfig-015-20260326    clang-20
i386                  randconfig-016-20260326    clang-20
i386                  randconfig-017-20260326    clang-20
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260326    gcc-8.5.0
loongarch             randconfig-002-20260326    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           ip30_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260326    gcc-8.5.0
nios2                 randconfig-002-20260326    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260326    clang-19
parisc                randconfig-002-20260326    clang-19
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc               randconfig-001-20260326    clang-19
powerpc               randconfig-002-20260326    clang-19
powerpc64             randconfig-001-20260326    clang-19
powerpc64             randconfig-002-20260326    clang-19
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260326    clang-23
riscv                 randconfig-002-20260326    clang-23
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260326    clang-23
s390                  randconfig-002-20260326    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-19
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260326    clang-23
sh                    randconfig-002-20260326    clang-23
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260326    gcc-14
sparc                 randconfig-002-20260326    gcc-14
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260326    gcc-14
sparc64               randconfig-002-20260326    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260326    gcc-14
um                    randconfig-002-20260326    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260326    clang-20
x86_64      buildonly-randconfig-002-20260326    clang-20
x86_64      buildonly-randconfig-003-20260326    clang-20
x86_64      buildonly-randconfig-004-20260326    clang-20
x86_64      buildonly-randconfig-005-20260326    clang-20
x86_64      buildonly-randconfig-006-20260326    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260326    clang-20
x86_64                randconfig-002-20260326    clang-20
x86_64                randconfig-003-20260326    clang-20
x86_64                randconfig-004-20260326    clang-20
x86_64                randconfig-005-20260326    clang-20
x86_64                randconfig-006-20260326    clang-20
x86_64                randconfig-011-20260326    gcc-14
x86_64                randconfig-012-20260326    gcc-14
x86_64                randconfig-013-20260326    gcc-14
x86_64                randconfig-014-20260326    gcc-14
x86_64                randconfig-015-20260326    gcc-14
x86_64                randconfig-016-20260326    gcc-14
x86_64                randconfig-071-20260326    gcc-14
x86_64                randconfig-072-20260326    gcc-14
x86_64                randconfig-073-20260326    gcc-14
x86_64                randconfig-074-20260326    gcc-14
x86_64                randconfig-075-20260326    gcc-14
x86_64                randconfig-076-20260326    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260326    gcc-14
xtensa                randconfig-002-20260326    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

