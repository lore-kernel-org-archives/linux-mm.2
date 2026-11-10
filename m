Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9A7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iFMclFST
Received: by kanga.kvack.org (Postfix)
	id E29056B00EF; Tue, 10 Nov 2026 04:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CBB6B05B0; Tue, 10 Nov 2026 04:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7EF6B05B5; Tue, 10 Nov 2026 04:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A86036B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:53:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 419E61C3ED2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:58 +0000 (UTC)
X-FDA: 85418748156.10.12389DB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C2A1100008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iFMclFST;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794304436;
	b=CyQawEiHa6nllcYojq3mexy3X0NxlM1sPYMCRcmXeK1TDPaO62XlmhtFH+EKuLqNT1sLl6
	IdJ/WyPZXnT5FyIKzVKRJ4z2ybTgzBsCQMJ81m6l8x8dXMcqgTe9Ca3LAvo4KPpm9xczBu
	96LYIiXctS5Z/LdAgsPJzIZgcCQZyTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iFMclFST;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794304436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=HBosjtjP35Ehw6AwGUe4Ad3dPc16kXJKcymDYEI2zl0=;
	b=GyFJAm6o8pGWdNPEvlA99uAo4r8X6U3UlUpYL7izQ54VORj5XFAG/+o/24Hd0fhKBjAQML
	vOpSSnlJSJLWfDoLdqrX3zhqhMJiKE4pdF3S/uE2kCrYsN9RgGgPdIVDVbtFVJhMnLnfP4
	X/smcpktBv3f/F7n//S/PizBpCjM1vY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794304436; x=1825840436;
  h=date:from:to:cc:subject:message-id;
  bh=TAPdv/24aFkafoya31huyd/V5WENFn03cTfBGIR7chw=;
  b=iFMclFSTFLoTKT4JWHKr4+eukgEZbTAunM3EbQzdi+pumQecwmpt3Y3j
   KOpPeyGX620epc4JeayyMFgccfdfDEGOesTNjSI0O9UhLL+zyO6fcKajE
   Ijtselva3O+MpaB8v0+wmk3MEqx5/EpcHwbseYmAd3Sg6oPuc/zl05RD2
   gTO3OVmJ8mvvqE9ZmMWGfaeS0jLUPHrgz596r7J2H/56/FdkDhs9/a5rk
   hD8ygVZHwWK0ir2oS/UyGuu6s98sVsbZBwZAXNqzz6OlOXx2HlxAn7A99
   o166YCsND03u8PMLm75loo/YWVoqJ7AJya5kWiIa55udI3HqOusqRuhbw
   A==;
X-CSE-ConnectionGUID: Ot+dmcgXRdWZ+7QUPpw3Wg==
X-CSE-MsgGUID: IOoVa13jTCuajvqRNa92ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2943331"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2943331"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 01:53:55 -0800
X-CSE-ConnectionGUID: RDJmjtBzTH+3mCTwR6j/JA==
X-CSE-MsgGUID: V4Vf4sI4RRmFusA2/uN1+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="9888432"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 10 Nov 2026 01:53:32 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQiXg-00000000wXf-3SDq;
	Tue, 10 Nov 2026 09:53:28 +0000
Date: Tue, 10 Nov 2026 17:52:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 630059a5a632377b9b7b487baccde92b7ae1dd47
Message-ID: <20261110175236.s61w3Az8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 83icgnwa5fbba8nm3c3bfxfz14oftqr6
X-Rspamd-Queue-Id: 7C2A1100008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794304435-58201
X-HE-Meta: U2FsdGVkX1+TeNKYcVHIhEQ5Gpx8plwqfUHlVXerSjZ8Jj7cb2HHHbQ/4AKgPwUgOQDXcdkBRYkKaUrAxAAyWKQfXbvD2qZK9iITLgxZOEBlJBBl2QUlbk++K0YzOPJ5fQFZ2l5CjcYwKHX9q11sOALnmI1Al0W7W3j/gQMOwMFKxQgcH3nPRX3dB+9a9yBAOGgehlVWc/3RJfW8eLiCg/7S8aRHqsGLh+QDQyW6wS4rRad+OTaRVfR6aPeOrUzo5ErdkeV4HOhSSyNAfGtok979V9AsS9ads5KPuXcHjXBVWXdkMDjXiE3fnls3oEiWJvEs+AXd8A0eGaPAgzOCT3y1IPef3UDae8JGJBdIJ0sdP9WSFzq9ky2XDR6otOoZpLm7SL+tzcoeOmoA112FFWopVpfHsqKd/ZPKg5curkFPkGjNU5WZwMa38DELTbAvYO9PXiTinyTNXU7gJ42VipUstCw0rRYpbU+AEPd/P0ibsc+tRo2DEANM6nIJ9z96qcQw5W8x4TMRvmYt2jGrRGYlKeMEl6w4Z4KK52KGmdXpYpVMkcVdwhr06kW2fccHrH3LU5bHPBzIvxB9WNbDELtHPyAj0lkbDEHusnqpuiiHzHwF+CsnkgCU0n90AN5V76WdeNjfSm9AsGdJyTvPz5nRyLqnvFbBkMg/6xljqGIlOaej6O2WLMdHxpZjm+p8+Ab/payy7kysaCkbiAGapCKOMfSFSXvYY5NY+UhbDZbkYH2FxUoTKIuvCTvHvjTwCHYEBIyjrWI0x2SvC+omJUTZSuzd+luRHlgf2QTW8AapCHUQFB8Dy86HBuUW2owr93H2usOc6vDvvayUBP7Mf1AnSaasHWYLbxFgkLfoEOOSTF3Zz1NM78921P20gZ2qM6xiKW8WyKcgsXGaHC2rwdlibZwblO1sq1g06YXCJSH2JIxNgkhS9cW1RC4/xNyWC905Io3DXxM/6hBdbA8
 DhvBlHBG
 irvTucILkZrS6nmKULBNkHVY/+XwVbWGLFkgOUOHCm+3eDH28YJPdM4pUT/465PMqaR1orx7Ig6w4GVXzTZ1I9RC9dzMnGGg0GNijFkaiA55jV+Q4axXxSE1Ufhg4lMj0F7aqbSJpvDFuwzhEqIVkahuy1v6OMR1zhnlwu8EoB86Kte+mdnGF4Up9L+BYR4TLAgahgBkYjROqHGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 630059a5a632377b9b7b487baccde92b7ae1dd47  Add linux-next specific files for 20261109

elapsed time: 1103m

configs tested: 196
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261110    gcc-10.5.0
arc                   randconfig-1001-20261110    gcc-10.5.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                          axm55xx_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                             mmp2_defconfig    gcc-16.2.0
arm                           moxart_defconfig    clang-17
arm                          mv78xx0_defconfig    clang-24
arm                              mxs_defconfig    clang-17
arm                   randconfig-1000-20261110    gcc-10.5.0
arm                   randconfig-1001-20261110    gcc-10.5.0
arm                   randconfig-1002-20261110    gcc-10.5.0
arm                   randconfig-1003-20261110    gcc-10.5.0
arm                           sp7021_defconfig    gcc-16.2.0
arm64                             alldefconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261110    gcc-12.5.0
arm64                 randconfig-1001-20261110    gcc-12.5.0
arm64                 randconfig-1002-20261110    gcc-12.5.0
arm64                 randconfig-1003-20261110    gcc-12.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261110    gcc-12.5.0
csky                  randconfig-1001-20261110    gcc-12.5.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261110    clang-17
hexagon               randconfig-1001-20261110    clang-17
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261110    clang-22
i386        buildonly-randconfig-1001-20261110    clang-22
i386        buildonly-randconfig-1002-20261110    clang-22
i386        buildonly-randconfig-1003-20261110    clang-22
i386        buildonly-randconfig-1004-20261110    clang-22
i386        buildonly-randconfig-1005-20261110    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261110    gcc-14
i386                  randconfig-1001-20261110    gcc-14
i386                  randconfig-1002-20261110    gcc-14
i386                  randconfig-1003-20261110    gcc-14
i386                  randconfig-1004-20261110    gcc-14
i386                  randconfig-1005-20261110    gcc-14
i386                  randconfig-1006-20261110    gcc-14
i386                  randconfig-1007-20261110    clang-22
i386                  randconfig-1008-20261110    clang-22
i386                  randconfig-1009-20261110    clang-22
i386                  randconfig-1010-20261110    clang-22
i386                  randconfig-1011-20261110    clang-22
i386                  randconfig-1012-20261110    clang-22
i386                  randconfig-1013-20261110    clang-22
loongarch                         alldefconfig    clang-24
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261110    clang-17
loongarch             randconfig-1001-20261110    clang-17
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                         m5307c3_defconfig    clang-24
m68k                        m5475evb_defconfig    clang-17
m68k                         stmark2_defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                             gpr_defconfig    clang-24
mips                        lemote2f_defconfig    clang-17
mips                      loongson2k_defconfig    clang-17
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261110    clang-17
nios2                 randconfig-1001-20261110    clang-17
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261110    gcc-14.4.0
parisc                randconfig-1001-20261110    gcc-14.4.0
parisc64                          alldefconfig    gcc-16.2.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                         cell_defconfig    clang-24
powerpc                     ge_imp3a_defconfig    gcc-16.2.0
powerpc                   iss476-smp_defconfig    clang-17
powerpc               randconfig-1000-20261110    gcc-14.4.0
powerpc               randconfig-1001-20261110    gcc-14.4.0
powerpc                   storcenter_defconfig    clang-24
powerpc                         warp_defconfig    clang-24
powerpc                         warp_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261110    gcc-14.4.0
powerpc64             randconfig-1001-20261110    gcc-14.4.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261110    clang-24
riscv                 randconfig-1001-20261110    clang-24
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261110    clang-24
s390                  randconfig-1001-20261110    clang-24
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261110    clang-24
sh                    randconfig-1001-20261110    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261110    gcc-12.5.0
sparc                 randconfig-1001-20261110    gcc-12.5.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261110    gcc-12.5.0
sparc64               randconfig-1001-20261110    gcc-12.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261110    gcc-12.5.0
um                    randconfig-1001-20261110    gcc-12.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261110    gcc-14
x86_64      buildonly-randconfig-1001-20261110    gcc-14
x86_64      buildonly-randconfig-1002-20261110    gcc-14
x86_64      buildonly-randconfig-1003-20261110    gcc-14
x86_64      buildonly-randconfig-1004-20261110    gcc-14
x86_64      buildonly-randconfig-1005-20261110    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261110    gcc-14
x86_64                randconfig-1001-20261110    gcc-14
x86_64                randconfig-1002-20261110    gcc-14
x86_64                randconfig-1003-20261110    gcc-14
x86_64                randconfig-1004-20261110    gcc-14
x86_64                randconfig-1005-20261110    gcc-14
x86_64                randconfig-1006-20261110    gcc-14
x86_64                randconfig-1007-20261110    gcc-14
x86_64                randconfig-1008-20261110    gcc-14
x86_64                randconfig-1009-20261110    gcc-14
x86_64                randconfig-1010-20261110    gcc-14
x86_64                randconfig-1011-20261110    gcc-14
x86_64                randconfig-1012-20261110    gcc-14
x86_64                randconfig-1013-20261110    gcc-14
x86_64                randconfig-1014-20261110    gcc-14
x86_64                randconfig-1015-20261110    gcc-14
x86_64                randconfig-1016-20261110    gcc-14
x86_64                randconfig-1017-20261110    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                        common_defconfig    gcc-16.2.0
xtensa                           iss_defconfig    clang-17
xtensa                randconfig-1000-20261110    gcc-12.5.0
xtensa                randconfig-1001-20261110    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

