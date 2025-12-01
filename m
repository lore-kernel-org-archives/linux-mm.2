Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9372CD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DAB6B0023; Sun, 30 Nov 2025 21:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E196B0024; Sun, 30 Nov 2025 21:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B696B0026; Sun, 30 Nov 2025 21:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2F7F6B0023
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:56:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AA88140F16
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:56:15 +0000 (UTC)
X-FDA: 84169388310.01.8A213B0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47895120003
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:56:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LByZd8pj;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764557773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=IQWIvGWfb0w1hXo5HSUM7Vji7B3614sxkJGMRoCBaF0=;
	b=kXvWDQAGNNR5/NVFu68IMhGbWRFLaMmIwSDWCzoEK2Teopq1Owy1POVMsp0LunYT1MNyIV
	dyH7lNsWIi7JFZBueT5Lor5fOM0Nwm+HtQwPxj2TQV0ea+Av4/QNtiMBTe6yYEh/97TujW
	h74+i2esWzEIb/JcLu48yviJoS1LB14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764557773; a=rsa-sha256;
	cv=none;
	b=1YWgN/WTPhx9gaoEC+k2+FVrsnUuXzrTwld2epMyWZrnKzqN9ZHnLw+FXnUHNExs/l2k6w
	Moe99s5Xo6LBkKPMk99Drhr+kQj0aW/5GycfBx5SVgFXMoXeNIdoahilN5gprjQaPD+paO
	dK5QEZHAx2GVCoKeQDIleqOtuIngCeo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LByZd8pj;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764557773; x=1796093773;
  h=date:from:to:cc:subject:message-id;
  bh=qKLmfIvAu+PBIJTi1lsknb5FvzOHIpPyUhJhaeFBGpE=;
  b=LByZd8pjWFg6XRQyk5hdRfX126dhOW78ZacW4rJyO7K+fAyqT0HQHviR
   lM+UXupQb3S7UwHkqsl6E6zZiXuJ4f6OKkqqV2+lDFJz2t9FJVDpega8N
   UbAx0mSUJL/DnUL4mRND8HGSYXvZZQmONNn+MWoBd04DHC++/Catp4n5d
   4D+DeaQeMSteZMFFc1WN7lP7aH7agv5gqyxcE8rCN1P8A0/qK+293xPHo
   F4A+WygQJzIpkDxyKcNfKh7c1o6RaROuNyawdUEqcXWV8DC/Zc1j13Xw4
   JPriYStfop8fvWE+00byMsfY4pjXBK3Y+UFfw9J1JhCmhYIsyzp1IA45g
   g==;
X-CSE-ConnectionGUID: UniWjiNeRte1UWiFywK4FQ==
X-CSE-MsgGUID: 8BzO9NKiRqu5/Gi20mz4tA==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="69078870"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="69078870"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2025 18:56:12 -0800
X-CSE-ConnectionGUID: 7gRi+5pmTVm689EuufFv6Q==
X-CSE-MsgGUID: jd1B+u8HTkGwGof+2sPviw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="193202749"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 30 Nov 2025 18:56:11 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vPu5A-000000008HT-18rl;
	Mon, 01 Dec 2025 02:56:08 +0000
Date: Mon, 01 Dec 2025 10:55:53 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 9f0a133cff2757757910e062c769f44f2c6a2868
Message-ID: <202512011046.ioabL0hD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47895120003
X-Stat-Signature: pu7komxhzgpygynrw6z3ottyxrjdwd4a
X-Rspam-User: 
X-HE-Tag: 1764557773-876557
X-HE-Meta: U2FsdGVkX1/gN4MIKCQxvVjhd1/3G/LIsg8/z+BUgJ7KsBfWF9CiqslTxP0DSKPAH5t0feRTIIjL725pbUCeddeG4Npa0wNFXIgikOYCXpJtB0/UJ8InIiRyvVJF487AhkVb0SSKwBoBGGKeSroAC1uwgqNDMLJwGkCSrQgh/5QaTnYfn/M5OpzOztMdLqaseHoV+7l5P252+68oR5mv8Bkm+f+Owg1sxiRKbZcJERB3AHT/Zl3H0tq2GwFzHM95nbzotJGfsgvMEaZaWEoPuV9VAt6C+v2cGECbgxedjjyLRp55jGD63Cq8hJU9Eus00+qm0MFd5+b8fGx/qQrq4lTdi8XvMIgsJH6Ijf0oSfWfSaO2TD+QfRHOUm23hRMweBvCsJQJMiuvgokz8p3wKNyoOLTpS3gF87TqYQr8iWPJIp/4o4GnWlIPYEjONU9fPUDK2+li9jrWJd6o32fMEn/WMILQbKtEs9+E296scHrkUlSvyqbU3bR5cjCJTFUf6/9urTjAwJoLUKW6yrjvt5f81K5BvQdGnSKjJW3AXzL5OkesBjBChy8nofnMyD8CnLJl32IjEv7dCcSvH2wIKv8KVq1tJOm4Z+RTNPgfYCkrjm8P9lIeUUoXnZppTNkRCInaY4jqMkz7LDJ7EY1lHmZHO0Ui/pWWeLWnpvNNQPrag4sH/3eL4sADsgjkloFjGtOChG84zvcK5y/HXnAilfEF+0oL+oycVLuRH9TK0FHnErmTybVFYxCkhFsIBNCDNNrE09bJawwN40ZEwxUGEFAj0F8Q+naKByDJILh/HhKbmFGDu2DZAF9/e2nDqbOedZUnzh5lhC1RMxFmGBr9IfrUymuZ0SSEZzWvUSL4qGcDaWL9rwZoUCuMYT6poht7EFceQBlWwePVYAlFhtOcD6RyeueaBFf5v3R9gigpb5mCm4xUGFlZySmF3Wcw3cpg3gycatk4M8Mf7fd8rMC
 xkGmeJzB
 gi1yIcgpvOkTZQyQVNpdnFRjkbvegVdpegCDACPI0a3Nzv0aTXYU6fT0eu6ZL7xc6WVuNJL23sbZvqfg3m9jnyB9MLFYwTDPK+YdDnEENJhIneibCxqUthNWRw+BFStjuvAJIMis4eeTL4MiKK34lKktozZNIlGWbP++d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 9f0a133cff2757757910e062c769f44f2c6a2868  memblock: only mark/clear KHO scratch memory when needed

elapsed time: 1021m

configs tested: 237
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251130    gcc-12.5.0
arc                   randconfig-001-20251201    clang-20
arc                   randconfig-002-20251130    gcc-8.5.0
arc                   randconfig-002-20251201    clang-20
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    gcc-15.1.0
arm                        mvebu_v7_defconfig    gcc-15.1.0
arm                          pxa168_defconfig    gcc-15.1.0
arm                   randconfig-001-20251130    clang-22
arm                   randconfig-001-20251201    clang-20
arm                   randconfig-002-20251130    clang-19
arm                   randconfig-002-20251201    clang-20
arm                   randconfig-003-20251130    clang-22
arm                   randconfig-003-20251201    clang-20
arm                   randconfig-004-20251130    gcc-15.1.0
arm                   randconfig-004-20251201    clang-20
arm                         s3c6400_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-16
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251201    clang-22
arm64                 randconfig-002-20251201    clang-22
arm64                 randconfig-003-20251201    clang-22
arm64                 randconfig-004-20251201    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251201    clang-22
csky                  randconfig-002-20251201    clang-22
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251201    gcc-15.1.0
hexagon               randconfig-002-20251201    gcc-15.1.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251201    clang-20
i386        buildonly-randconfig-002-20251201    clang-20
i386        buildonly-randconfig-003-20251201    clang-20
i386        buildonly-randconfig-004-20251201    clang-20
i386        buildonly-randconfig-005-20251201    clang-20
i386        buildonly-randconfig-006-20251201    clang-20
i386        buildonly-randconfig-006-20251201    gcc-14
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251201    clang-20
i386                  randconfig-001-20251201    gcc-14
i386                  randconfig-002-20251201    clang-20
i386                  randconfig-003-20251201    clang-20
i386                  randconfig-004-20251201    clang-20
i386                  randconfig-005-20251201    clang-20
i386                  randconfig-005-20251201    gcc-14
i386                  randconfig-006-20251201    clang-20
i386                  randconfig-006-20251201    gcc-14
i386                  randconfig-007-20251201    clang-20
i386                  randconfig-011-20251201    clang-20
i386                  randconfig-011-20251201    gcc-14
i386                  randconfig-012-20251201    gcc-14
i386                  randconfig-013-20251201    clang-20
i386                  randconfig-013-20251201    gcc-14
i386                  randconfig-014-20251201    gcc-14
i386                  randconfig-015-20251201    gcc-14
i386                  randconfig-016-20251201    gcc-14
i386                  randconfig-017-20251201    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251201    gcc-15.1.0
loongarch             randconfig-002-20251201    gcc-15.1.0
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                       rbtx49xx_defconfig    gcc-15.1.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20251201    gcc-15.1.0
nios2                 randconfig-002-20251201    gcc-15.1.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251130    gcc-13.4.0
parisc                randconfig-001-20251201    gcc-13.4.0
parisc                randconfig-002-20251130    gcc-12.5.0
parisc                randconfig-002-20251201    gcc-13.4.0
parisc64                         alldefconfig    gcc-15.1.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc               randconfig-001-20251130    clang-22
powerpc               randconfig-001-20251201    gcc-13.4.0
powerpc               randconfig-002-20251130    clang-16
powerpc               randconfig-002-20251201    gcc-13.4.0
powerpc                     redwood_defconfig    gcc-15.1.0
powerpc                 xes_mpc85xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251130    gcc-14.3.0
powerpc64             randconfig-001-20251201    gcc-13.4.0
powerpc64             randconfig-002-20251130    gcc-14.3.0
powerpc64             randconfig-002-20251201    gcc-13.4.0
riscv                            allmodconfig    clang-16
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251201    clang-22
riscv                 randconfig-002-20251201    clang-22
riscv                 randconfig-002-20251201    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251201    clang-22
s390                  randconfig-002-20251201    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                             espt_defconfig    gcc-15.1.0
sh                    randconfig-001-20251201    clang-22
sh                    randconfig-001-20251201    gcc-12.5.0
sh                    randconfig-002-20251201    clang-22
sh                    randconfig-002-20251201    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251201    gcc-14
sparc                 randconfig-001-20251201    gcc-8.5.0
sparc                 randconfig-002-20251201    gcc-14
sparc                 randconfig-002-20251201    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251201    clang-22
sparc64               randconfig-001-20251201    gcc-14
sparc64               randconfig-002-20251201    gcc-14
sparc64               randconfig-002-20251201    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251201    gcc-14
um                    randconfig-002-20251201    gcc-14
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251201    clang-20
x86_64      buildonly-randconfig-002-20251201    clang-20
x86_64      buildonly-randconfig-003-20251201    clang-20
x86_64      buildonly-randconfig-003-20251201    gcc-14
x86_64      buildonly-randconfig-004-20251201    clang-20
x86_64      buildonly-randconfig-004-20251201    gcc-14
x86_64      buildonly-randconfig-005-20251201    clang-20
x86_64      buildonly-randconfig-005-20251201    gcc-14
x86_64      buildonly-randconfig-006-20251201    clang-20
x86_64      buildonly-randconfig-006-20251201    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251201    clang-20
x86_64                randconfig-001-20251201    gcc-14
x86_64                randconfig-002-20251201    clang-20
x86_64                randconfig-003-20251201    clang-20
x86_64                randconfig-004-20251201    clang-20
x86_64                randconfig-005-20251201    clang-20
x86_64                randconfig-006-20251201    clang-20
x86_64                randconfig-011-20251201    clang-20
x86_64                randconfig-012-20251201    gcc-14
x86_64                randconfig-013-20251201    gcc-14
x86_64                randconfig-014-20251201    gcc-14
x86_64                randconfig-015-20251201    clang-20
x86_64                randconfig-016-20251201    clang-20
x86_64                randconfig-071-20251201    gcc-12
x86_64                randconfig-071-20251201    gcc-14
x86_64                randconfig-072-20251201    gcc-14
x86_64                randconfig-073-20251201    gcc-14
x86_64                randconfig-074-20251201    gcc-14
x86_64                randconfig-075-20251201    gcc-12
x86_64                randconfig-075-20251201    gcc-14
x86_64                randconfig-076-20251201    clang-20
x86_64                randconfig-076-20251201    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251201    gcc-14
xtensa                randconfig-001-20251201    gcc-9.5.0
xtensa                randconfig-002-20251201    gcc-12.5.0
xtensa                randconfig-002-20251201    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

