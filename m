Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07E5D715E8
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 12:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBBA86B05BD; Sat, 24 Jan 2026 07:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99066B05BE; Sat, 24 Jan 2026 07:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F6E6B05BF; Sat, 24 Jan 2026 07:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C85F36B05BD
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 07:59:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EF821A027B
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:59:18 +0000 (UTC)
X-FDA: 84366863196.27.5A007ED
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id A78FD40002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 12:59:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fj2Yr4AE;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769259556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VtNYlSM+yFico2bKUoKy27OQWxtr3xQ3D6QYzBhHrh4=;
	b=PNMJZz81tSIyDeycaotzfcIbuklvCn8znM+11L+FNOClorwutLXndLG5IWcjCR3vNuEYXy
	at2KOQlXuzcRgQua1ypsM+NSbfAwQgfrTsKwWHO+/MGKu4W415UGiPs6aUoGcs0o68Pyh5
	qtcgs8BXmkTb25u3dHmBW11Hj9qhXWI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fj2Yr4AE;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769259556; a=rsa-sha256;
	cv=none;
	b=ENpJDsb8v300JwD/HlG0a/nTjuLns0k5Pw1K/g/Z+PaMER/RjA/FoXc9lWgK0A31+xDXGZ
	rnNa6w4KoRzeyzlmmUb/5c0FYgY5dHr+ewMQBPBP7JTloU+qZUq4rqwgsE7xO5exMxwGKK
	Vhbs8uJeZFh20ESmGhShWfEGJf33xFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769259555; x=1800795555;
  h=date:from:to:cc:subject:message-id;
  bh=l7iPyPFbwvjJli6wFZYiykXdKF9c4xZpcJNLNjNIhyc=;
  b=Fj2Yr4AEfO/b/rNVe0LSFdAHn/DOMbPGeR3CalsR/p+UegoQXnR/ioTd
   Ji5XQKqgjOurXB3LKh/ZmfbQWPz0CGCk3nHQd0IMgnqaVqg+n6Ynk4VEh
   g0p1ZOBU0HD3BQjTSxm66kjtv5uhXaxTCni7O6Y74V2aGcRo8VCPF1Ah3
   AQHN4y7QCadSAoiNQutjzg/hy9FmwIMOIz2onQIsFnjQNCK0qYZ8gEzeJ
   mJElvOExTGPdixfbrzANZu404cOrtdKGJlzBciBfsWW0wmm+Bp2aniSvf
   cQ0w2YG/+F47NeOQxfPAXRGOSZZiYn8KuhPTI5V2tnGeGNj2ZoVEbHIoK
   g==;
X-CSE-ConnectionGUID: Q2bMnn8PTSS75aTNxKmYEw==
X-CSE-MsgGUID: WE/W9DVzSna+npXv0YFcog==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="74122112"
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="74122112"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 04:59:13 -0800
X-CSE-ConnectionGUID: WjbNt6kaRNi6wu7eu28K/w==
X-CSE-MsgGUID: aFdbTi6QRVq86N9c/qvCyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,250,1763452800"; 
   d="scan'208";a="207505314"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 24 Jan 2026 04:59:12 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vjdEL-00000000VBm-3Btq;
	Sat, 24 Jan 2026 12:59:09 +0000
Date: Sat, 24 Jan 2026 20:59:00 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 ca3a02fda4da8e2c1cb6baee5d72352e9e2cfaea
Message-ID: <202601242053.dOFWq782-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A78FD40002
X-Stat-Signature: hdka177riyui73wnops1mynxwgs99wah
X-Rspam-User: 
X-HE-Tag: 1769259555-824427
X-HE-Meta: U2FsdGVkX1+0B3SOxjMSkpFjzyDCmIz+IQpU0uoowXGmjraeUAq70SyrZU7GkK4mfrxAsfkN+eKtAhvMf6ePYR7HEigqof+wBuRezPdBl3Z7cF5CeEvIABjvxyNAqO4Pk3W8TdYgSOcqO4Qw/xj8XL4lkKEuNrZAXkh4Sy2dso1UBqUL2hRUCRmzFH9TvfMXO14pqrHmZw9dMUBNLMX07UDlKpJXMG8SDkGGAh/DhHw1tX4Gsu0PSLU6pfL7eIKGemNVct5Xt3bfNwIZ00T8CFl/aAKlKud+5AFcjnGBQtdLvOuuKtciFqX7ivwDBF7mMOVGElIHfsqun1XRKoPMQBy2aAelSFku2uNESLsZCi7k4Ls7kC646YGDiYWzQUbe+Z0v1532GHL0C7cTNJt9Y/2alKnxl3vWsErlHJNVN6g88LKmEHqfUr5mc7mGLaI83nqmT/4z/2pXPt4Dbs4GvHcqZyXRrD7nEvTkqpy6/OwiNvRc6cPi4KEBXEBSGcu7qp2/qIXzgc+cXmD8lkfi3s8CBDZLMuQwN6IpphYd6CTvcsZSmVhp3KrxnwUlRVla51qrVwJL01s1CaiO6LjSXvav+OGypkSt0rjdovhpsvZsvyKmK+p1zrC8fiet0FOcfxrqYwztHzBlODgQOez5Q7qxkc1jq+mjzJSuqFm5bhxKZFIz1Q8Nrc4YWXXcole1Lj2LREQiNe+dKVh3oKYVjUB6jITR+fXKiI6NKc5DStessT+j9KiMHRJ0rNqma6d22VSpLT7CjIV/GViXcnNTuvVwrd+EVcCqCJYpewOSgrRwEjZ+pfEHkNcGjiNZJQsiUJ68AYY2jl5ClwBHIiVoEFpQwojn9uttLNJ3nOU+G+Jh0fb3A7DrprjalznnCVVhbD1Jn5B8BuuLvoBSd7CYUxpgQD5Cf00gd9FptmUC2KJQguxSsUsUMbunDQ2GosLAbvdJFcgh20d8r7kynb6
 rhmqcauT
 3gyaajbWAjznL/i9L5+0Ep/4/R1Zg3mH9b1bP5KN2c7VTv1oLS9d4Z4T+jo/smIOtufAuDJ+oGKkYbcFZlHJHJA00q/THlnzkqEQH1wEtrVcsYvZP8zgDZqYIIIAVsJc/LtlYvL25lFWF7gXwxL7r51dKkucM8bwHj/BJQQc9hSRMlVvFPux7wmj5OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: ca3a02fda4da8e2c1cb6baee5d72352e9e2cfaea  Add linux-next specific files for 20260123

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601240937.0L01qHxn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601241456.ALV97WlP-lkp@intel.com

    ERROR: modpost: "drm_dsc_pps_payload_pack" [drivers/gpu/drm/panel/panel-ilitek-ili9882t.ko] undefined!
    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_461' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_687' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:159 amdgpu_userq_hang_detect_work() warn: can 'queue' even be NULL?

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-allyesconfig
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
|-- sh-allmodconfig
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
|-- x86_64-randconfig-161-20260124
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq.c-amdgpu_userq_hang_detect_work()-warn:can-queue-even-be-NULL
`-- x86_64-randconfig-r072-20260124
    `-- ERROR:drm_dsc_pps_payload_pack-drivers-gpu-drm-panel-panel-ilitek-ili9882t.ko-undefined

elapsed time: 760m

configs tested: 262
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              alldefconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                        nsim_700_defconfig    gcc-15.2.0
arc                   randconfig-001-20260124    clang-18
arc                   randconfig-001-20260124    gcc-14.3.0
arc                   randconfig-002-20260124    clang-18
arc                   randconfig-002-20260124    gcc-13.4.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          pxa910_defconfig    gcc-15.2.0
arm                   randconfig-001-20260124    clang-18
arm                   randconfig-001-20260124    gcc-8.5.0
arm                   randconfig-002-20260124    clang-18
arm                   randconfig-002-20260124    clang-22
arm                   randconfig-003-20260124    clang-18
arm                   randconfig-004-20260124    clang-18
arm                   randconfig-004-20260124    gcc-15.2.0
arm                         s3c6400_defconfig    gcc-15.2.0
arm                           tegra_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260124    clang-22
arm64                 randconfig-001-20260124    gcc-15.2.0
arm64                 randconfig-002-20260124    clang-22
arm64                 randconfig-002-20260124    gcc-15.2.0
arm64                 randconfig-003-20260124    clang-22
arm64                 randconfig-003-20260124    gcc-15.2.0
arm64                 randconfig-004-20260124    gcc-15.2.0
arm64                 randconfig-004-20260124    gcc-9.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260124    gcc-13.4.0
csky                  randconfig-001-20260124    gcc-15.2.0
csky                  randconfig-002-20260124    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260124    clang-22
hexagon               randconfig-002-20260124    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260124    gcc-14
i386        buildonly-randconfig-002-20260124    gcc-14
i386        buildonly-randconfig-003-20260124    gcc-14
i386        buildonly-randconfig-004-20260124    clang-20
i386        buildonly-randconfig-004-20260124    gcc-14
i386        buildonly-randconfig-005-20260124    gcc-14
i386        buildonly-randconfig-006-20260124    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260124    gcc-14
i386                  randconfig-002-20260124    gcc-14
i386                  randconfig-003-20260124    gcc-14
i386                  randconfig-004-20260124    gcc-12
i386                  randconfig-004-20260124    gcc-14
i386                  randconfig-005-20260124    clang-20
i386                  randconfig-005-20260124    gcc-14
i386                  randconfig-006-20260124    gcc-14
i386                  randconfig-007-20260124    gcc-14
i386                  randconfig-011-20260124    clang-20
i386                  randconfig-012-20260124    clang-20
i386                  randconfig-013-20260124    clang-20
i386                  randconfig-014-20260124    clang-20
i386                  randconfig-014-20260124    gcc-14
i386                  randconfig-015-20260124    clang-20
i386                  randconfig-016-20260124    clang-20
i386                  randconfig-016-20260124    gcc-14
i386                  randconfig-017-20260124    clang-20
i386                  randconfig-017-20260124    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                loongson32_defconfig    gcc-15.2.0
loongarch             randconfig-001-20260124    gcc-15.2.0
loongarch             randconfig-002-20260124    gcc-14.3.0
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
mips                  cavium_octeon_defconfig    gcc-15.2.0
mips                     cu1830-neo_defconfig    gcc-15.2.0
mips                malta_qemu_32r6_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260124    gcc-8.5.0
nios2                 randconfig-002-20260124    gcc-11.5.0
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
parisc                randconfig-001-20260124    gcc-8.5.0
parisc                randconfig-002-20260124    gcc-14.3.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                   currituck_defconfig    gcc-15.2.0
powerpc                       eiger_defconfig    clang-22
powerpc               randconfig-001-20260124    clang-22
powerpc               randconfig-002-20260124    clang-22
powerpc                     skiroot_defconfig    clang-22
powerpc64             randconfig-001-20260124    gcc-10.5.0
powerpc64             randconfig-002-20260124    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                    nommu_virt_defconfig    gcc-15.2.0
riscv                 randconfig-001-20260124    gcc-8.5.0
riscv                 randconfig-002-20260124    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260124    gcc-15.2.0
s390                  randconfig-002-20260124    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260124    gcc-15.2.0
sh                    randconfig-002-20260124    gcc-13.4.0
sh                              ul2_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260124    gcc-13.4.0
sparc                 randconfig-001-20260124    gcc-14.3.0
sparc                 randconfig-002-20260124    gcc-13.4.0
sparc                 randconfig-002-20260124    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260124    clang-22
sparc64               randconfig-001-20260124    gcc-13.4.0
sparc64               randconfig-002-20260124    clang-22
sparc64               randconfig-002-20260124    gcc-13.4.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260124    gcc-13.4.0
um                    randconfig-001-20260124    gcc-14
um                    randconfig-002-20260124    clang-18
um                    randconfig-002-20260124    gcc-13.4.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260124    clang-20
x86_64      buildonly-randconfig-002-20260124    clang-20
x86_64      buildonly-randconfig-002-20260124    gcc-14
x86_64      buildonly-randconfig-003-20260124    clang-20
x86_64      buildonly-randconfig-004-20260124    clang-20
x86_64      buildonly-randconfig-005-20260124    clang-20
x86_64      buildonly-randconfig-006-20260124    clang-20
x86_64      buildonly-randconfig-006-20260124    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260124    clang-20
x86_64                randconfig-001-20260124    gcc-13
x86_64                randconfig-002-20260124    clang-20
x86_64                randconfig-002-20260124    gcc-13
x86_64                randconfig-003-20260124    clang-20
x86_64                randconfig-003-20260124    gcc-13
x86_64                randconfig-004-20260124    clang-20
x86_64                randconfig-004-20260124    gcc-13
x86_64                randconfig-005-20260124    gcc-13
x86_64                randconfig-006-20260124    clang-20
x86_64                randconfig-006-20260124    gcc-13
x86_64                randconfig-011-20260124    gcc-12
x86_64                randconfig-011-20260124    gcc-14
x86_64                randconfig-012-20260124    gcc-12
x86_64                randconfig-012-20260124    gcc-14
x86_64                randconfig-013-20260124    clang-20
x86_64                randconfig-013-20260124    gcc-12
x86_64                randconfig-014-20260124    gcc-12
x86_64                randconfig-015-20260124    gcc-12
x86_64                randconfig-015-20260124    gcc-14
x86_64                randconfig-016-20260124    gcc-12
x86_64                randconfig-016-20260124    gcc-14
x86_64                randconfig-071-20260124    gcc-14
x86_64                randconfig-072-20260124    clang-20
x86_64                randconfig-073-20260124    clang-20
x86_64                randconfig-074-20260124    gcc-12
x86_64                randconfig-075-20260124    clang-20
x86_64                randconfig-076-20260124    gcc-14
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
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                  nommu_kc705_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260124    gcc-13.4.0
xtensa                randconfig-001-20260124    gcc-8.5.0
xtensa                randconfig-002-20260124    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

