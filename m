Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907EAC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 21:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8266B00B5; Fri,  3 Jul 2026 17:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5689B6B00B6; Fri,  3 Jul 2026 17:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E466B00B7; Fri,  3 Jul 2026 17:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6A56B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:37:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AE6C1202D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:37:02 +0000 (UTC)
X-FDA: 84948775884.23.21C4C57
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C6A3C000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:36:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kEADTaMw;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783114620;
	b=4r+QY6vqjcNLTgMbE1v0saBXoLeVXIUQRVuQa90TIbuA2SCNla7NXZmKqMmaRzokECT9c9
	BY3qcB4/NfAbjVDprHNd8359X1McLnIUX9Vtw+42UX3v7Ff2iY0ybZCsWqzXu+fE6oxNz4
	rbSQJVFm+eKW20RTuIaWDC2aWxI7YJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783114620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=HUBjgn5s0ybbcIqyEZLNuBgcOOF4EAkxD/wXPRqhSvQ=;
	b=b7LCTmY56HfBcQfbpcRv1KoqmXDzsiuauV+KYnB5f50zZmn2TsehIDeMeL9UODe819xwxs
	XpAwTuAW3UFpWZYz77jRiVcng4psIZBST/9QK+3OT9D8hZjBTWVHi59H6AWmLd8TOj3R4f
	ETFYAfIwgPa6t7spaXffrgX3kGiBHzc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kEADTaMw;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783114620; x=1814650620;
  h=date:from:to:cc:subject:message-id;
  bh=+ITKh/55VxNFTmE4VEKg/WnbtoaadEq4Vr34DW03hQQ=;
  b=kEADTaMwyIsRrYps9vixu9s1RZUyWJamCUOAUS/BXYxAB/t4nIRv6MVR
   gxzOzEEIhO6Up+DDVgKlhZhGv5X+OVR49R6y9ddk8UbdbLax1Xsnz7dB7
   6/0q045kd4MGkBwvMYWCWbKSZf98OeX2yVbzpOJnS52rHlRUesiZ3evW0
   7pPTLJtyQ1pLOv8Uhh0dCLsBKbmsaqxnQQnO9edCLQPhq+JKhO4mkF14A
   V8yKMdTqTyL/B0hBMzbdM1Ruby9Jm+1o7FP+QSkDsnCkSghfCPuUpGJft
   z3W6dYRz49YEZrMEnEwGb7IHTwa/8Xlp38I3ZEONf+WGRMx0TNGtspOd2
   w==;
X-CSE-ConnectionGUID: IZNtp2ZuSICTjpmo6jYYFw==
X-CSE-MsgGUID: Cx+ySW5NSOKEh6/u+AljIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="84052274"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="84052274"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 14:36:58 -0700
X-CSE-ConnectionGUID: EQV5vAYwR2ynHHSBqvp3gg==
X-CSE-MsgGUID: QCghh/raR2ilC1nTNJ7t0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="276397794"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 03 Jul 2026 14:36:57 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wflZ8-00000000CXN-2PGA;
	Fri, 03 Jul 2026 21:36:54 +0000
Date: Sat, 04 Jul 2026 05:36:24 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:numa_memblks-redundant-work] BUILD SUCCESS
 c12c889655533790d3f8cecbf2dca3456576e8bb
Message-ID: <202607040511.gWjrnxSf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C6A3C000D
X-Stat-Signature: z7m8jtbktkt3dz4hr9cntsno3n1xxfxc
X-HE-Tag: 1783114619-49818
X-HE-Meta: U2FsdGVkX19NkEhqFC+y5yL7hZ+7Chz5JZlljmceP5GYTVFTVxqujs/N3DShWwuaOj4SZux6Q+TwOBgTnGFkdd2TebPZ+SZh7NZds2jBR3dhe7RV6AW6LPwqQMnmL08sXrxZ4uPEFVYPKaOcvdQy1id8vgJKvUEIyGygP5IjbRX0TKM/tNh65B0iJymAH1OUbs5usbU1QSc91fiGLz3pBWpWg/BA+2P8CIpto5HuO8GeaTBjc7BAhQx+PPCn7vzKTgFGtxOx8aLhGE5z4/BKDRw1qCDJ7PuP/iXiUgFXWK8Mek8K1O8Ox+RtTgQwo0SIR6NUSpw5nmdUWPoSh/VPFe3H3ilghuDEh9sCtWjX2AOGUuqYo7+8ZDAteFmVX+hX8oF7sGEEXAjKjbDx/CWys6czvBbwxWFFVeo41dVyznQyFkIJndixFcOL7oNNBGbxEh/V6WO7hmkSppWlizGKlDE8LOkUpRn9bfQLL7mI4mO5MQQB1mR38nV/YHwKAuuzeJkViN24s/p51wcGVq6DFGsof08hB3rPmV4NwjKnQ5GqA1gOHcoLoJOh9OlO5INOcFvt9JeRGYIDoktcYa1Xr5F2xA/Tb2h3zv8C3MIO422DC0uUIIMBIDJVZAVyRX/51w/ZX812t0xGjSEyPcmSVmviGCaVo1aRS6gcynzr+s01SVIu6Wi278aCR0vN9FesRYmPPFzWri4IXmorwPerjkd0gb5RZ46bj0QwRfzJHHSWAaWmDnwt8RE2KtTKnWga+GDqUNoIfS6tvjPyNxu2lfCJmdnP32eViC1p8jIG/5ibpmdJuIm39G3miqAl9akiWnrIKQn9uLmuKcjJpbgZkbum87kTUooyVmsuTSrKeenwRm86isht7DV13XT1ONJRTf5s3guVmWvytUlQ3CW9ADnvl0cqNOcv/8JP6dljcoePiKKTfs9hNtWKyMmO9RLLAF14LSGMuPY4N+Zrmkk
 XcPfgpsV
 CGjkA0gBed4WMtu7gZdDzWJqxf5ERi7y54jzTHosGyZbsU2VhxUcuiYuxaHnKPQsAfdxyNkyfsjUSTvT+lOAEYGq57/rXTkSXINHtffdFzhQ+fBFgNf3e8bPja1bkTXJwZNExjRRoVu57O9/+yIUPMRFVd4WZ+32TBYmko1modzlRJZmi0dCf2vkfeh4X/a7ZAscWnzrG53tbHcZPxZQ0CWG6CF8EaHu6l9zPI5QX1dq4IK9Q/Ok3HFYHytdLG4YsEoLEGIPXLoTk3WQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git numa_memblks-redundant-work
branch HEAD: c12c889655533790d3f8cecbf2dca3456576e8bb  Merge patch series "treewide, numa_memblks: remove redundant work during NUMA init"

elapsed time: 768m

configs tested: 328
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                          axs103_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-8.5.0
arc                   randconfig-001-20260704    gcc-8.5.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-8.5.0
arc                   randconfig-002-20260704    gcc-8.5.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                        keystone_defconfig    gcc-16.1.0
arm                        mvebu_v7_defconfig    clang-23
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-8.5.0
arm                   randconfig-001-20260704    gcc-8.5.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-8.5.0
arm                   randconfig-002-20260704    gcc-8.5.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-8.5.0
arm                   randconfig-003-20260704    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-8.5.0
arm                   randconfig-004-20260704    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-10.5.0
arm64                 randconfig-001-20260703    gcc-10.5.0
arm64                 randconfig-001-20260704    gcc-16.1.0
arm64                          randconfig-002    gcc-10.5.0
arm64                 randconfig-002-20260703    gcc-10.5.0
arm64                 randconfig-002-20260704    gcc-16.1.0
arm64                          randconfig-003    gcc-10.5.0
arm64                 randconfig-003-20260703    gcc-10.5.0
arm64                 randconfig-003-20260704    gcc-16.1.0
arm64                          randconfig-004    gcc-10.5.0
arm64                 randconfig-004-20260703    gcc-10.5.0
arm64                 randconfig-004-20260704    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260703    gcc-10.5.0
csky                  randconfig-001-20260704    gcc-16.1.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260703    gcc-10.5.0
csky                  randconfig-002-20260704    gcc-16.1.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-16.1.0
hexagon               randconfig-001-20260704    gcc-16.1.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-16.1.0
hexagon               randconfig-002-20260704    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260703    clang-22
i386        buildonly-randconfig-001-20260704    gcc-14
i386        buildonly-randconfig-002-20260703    clang-22
i386        buildonly-randconfig-002-20260704    gcc-14
i386        buildonly-randconfig-003-20260703    clang-22
i386        buildonly-randconfig-003-20260704    gcc-14
i386        buildonly-randconfig-004-20260703    clang-22
i386        buildonly-randconfig-004-20260704    gcc-14
i386        buildonly-randconfig-005-20260703    clang-22
i386        buildonly-randconfig-005-20260704    gcc-14
i386        buildonly-randconfig-006-20260703    clang-22
i386        buildonly-randconfig-006-20260704    gcc-14
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260703    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260703    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260703    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260703    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260703    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260703    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260703    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260703    clang-22
i386                  randconfig-011-20260704    gcc-13
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260703    clang-22
i386                  randconfig-012-20260704    gcc-13
i386                           randconfig-013    clang-22
i386                  randconfig-013-20260703    clang-22
i386                  randconfig-013-20260704    gcc-13
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260703    clang-22
i386                  randconfig-014-20260704    gcc-13
i386                           randconfig-015    clang-22
i386                  randconfig-015-20260703    clang-22
i386                  randconfig-015-20260704    gcc-13
i386                           randconfig-016    clang-22
i386                  randconfig-016-20260703    clang-22
i386                  randconfig-016-20260704    gcc-13
i386                           randconfig-017    clang-22
i386                  randconfig-017-20260703    clang-22
i386                  randconfig-017-20260704    gcc-13
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-16.1.0
loongarch             randconfig-001-20260704    gcc-16.1.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-16.1.0
loongarch             randconfig-002-20260704    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
m68k                          hp300_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                          eyeq5_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-16.1.0
nios2                 randconfig-001-20260704    gcc-16.1.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-16.1.0
nios2                 randconfig-002-20260704    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260703    clang-23
parisc                randconfig-001-20260704    clang-23
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260703    clang-23
parisc                randconfig-002-20260704    clang-23
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      chrp32_defconfig    clang-23
powerpc                     ep8248e_defconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260703    clang-23
powerpc               randconfig-001-20260704    clang-23
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260703    clang-23
powerpc               randconfig-002-20260704    clang-23
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260703    clang-23
powerpc64             randconfig-001-20260704    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260703    clang-23
powerpc64             randconfig-002-20260704    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260703    gcc-9.5.0
riscv                 randconfig-001-20260704    gcc-10.5.0
riscv                 randconfig-002-20260703    gcc-9.5.0
riscv                 randconfig-002-20260704    gcc-10.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260703    gcc-9.5.0
s390                  randconfig-001-20260704    gcc-10.5.0
s390                  randconfig-002-20260703    gcc-9.5.0
s390                  randconfig-002-20260704    gcc-10.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                            hp6xx_defconfig    gcc-16.1.0
sh                    randconfig-001-20260703    gcc-9.5.0
sh                    randconfig-001-20260704    gcc-10.5.0
sh                    randconfig-002-20260703    gcc-9.5.0
sh                    randconfig-002-20260704    gcc-10.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260703    gcc-11.5.0
sparc                 randconfig-001-20260704    gcc-16.1.0
sparc                 randconfig-002-20260703    gcc-11.5.0
sparc                 randconfig-002-20260704    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260703    gcc-11.5.0
sparc64               randconfig-001-20260704    gcc-16.1.0
sparc64               randconfig-002-20260703    gcc-11.5.0
sparc64               randconfig-002-20260704    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260703    gcc-11.5.0
um                    randconfig-001-20260704    gcc-16.1.0
um                    randconfig-002-20260703    gcc-11.5.0
um                    randconfig-002-20260704    gcc-16.1.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260703    gcc-14
x86_64      buildonly-randconfig-001-20260704    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260703    gcc-14
x86_64      buildonly-randconfig-002-20260704    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260703    gcc-14
x86_64      buildonly-randconfig-003-20260704    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260703    gcc-14
x86_64      buildonly-randconfig-004-20260704    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260703    gcc-14
x86_64      buildonly-randconfig-005-20260704    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260703    gcc-14
x86_64      buildonly-randconfig-006-20260704    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260703    clang-22
x86_64                randconfig-001-20260704    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260703    clang-22
x86_64                randconfig-002-20260704    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260703    clang-22
x86_64                randconfig-003-20260704    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260703    clang-22
x86_64                randconfig-004-20260704    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260703    clang-22
x86_64                randconfig-005-20260704    clang-22
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260703    clang-22
x86_64                randconfig-006-20260704    clang-22
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260703    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260703    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260703    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260703    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260703    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260703    gcc-14
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260703    clang-22
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260703    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260703    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260703    clang-22
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260703    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260703    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260703    gcc-11.5.0
xtensa                randconfig-001-20260704    gcc-16.1.0
xtensa                randconfig-002-20260703    gcc-11.5.0
xtensa                randconfig-002-20260704    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

