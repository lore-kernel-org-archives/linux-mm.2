Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9213F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=la/PIxbG
Received: by kanga.kvack.org (Postfix)
	id 866DE6B05B7; Wed, 11 Nov 2026 21:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818046B05B8; Wed, 11 Nov 2026 21:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706296B05B9; Wed, 11 Nov 2026 21:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFE86B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:44:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BDB716045C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:44:30 +0000 (UTC)
X-FDA: 85424923500.01.96A68CA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id B4EE720002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:44:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="la/PIxbG";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794451468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yeaVwFNeO2sel+/+5zINqdWOxKX5ex5fpz6CbBnNn7A=;
	b=wyN8r0TmLEhA8ZS2YpYt/4m6PPBT4PYKCcwMdDUnz6xzyS5r/2kWOeBD3Et70ofzMuk9Jp
	mCsNjGFRpyifp3wZ4mweibLArl27DYgIIIw10oANFR7AyPNJKvyKyrYijcQ38ifmiBzkmn
	OiEoiZMJVlhLQg5/Pd+UlRpklPNkNLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794451468;
	b=UEHzG8MC2ypA8A72lk37uulBaIfERe+9vez5x7hSa7IbCVgmGN+Dy93L6F98PyICj4wnCh
	6vSG90PF0ZyngaTmE1a44eGnwVFwx6k/8IfwjL08Buv/0gka7blTTmdIi1+omHpBOU8FW6
	ozbWauZ/1M+qjI09lv6tQ6FPPWua7IA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="la/PIxbG";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794451467; x=1825987467;
  h=date:from:to:cc:subject:message-id;
  bh=5lTfnERKSyF5QCm796HvS2k6W5w9UZNZTPutv5zIuJA=;
  b=la/PIxbGovzi9b+Kvc76RsKMVV3trxzw93rhTodiZUf+Szop/spL6i4I
   ENpKAljxNo3K9odg4ADI7ahZWl93IeRrfXt46sxgvDo2zSuWedI/Bk7vl
   HlNoSuNyNPNsSHHCisbzY5icL3eEyHmPFZ8efnTp1SbyEjJyVhlLUc7hQ
   LA84zOo7Iwxym58lXHtyIymBovaTbl2h7UZjW1tDiO/NvriEXlFeRAqc2
   SoNqarL5wslBHr3lJnr54qVmpF32g0R6V37yzzkAZ8OnrImmUKVy/SfUi
   X6ZT/EpfMZIMZkHpc2zBqtwH0PKj2klyA8Zjc7GHh6s5vcqC1bYGAHDrT
   w==;
X-CSE-ConnectionGUID: kLyjj9yLTkW/eGsq1y5jiA==
X-CSE-MsgGUID: gifQkv/0RNyhw2LKgkbNcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3236446"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3236446"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 18:44:26 -0800
X-CSE-ConnectionGUID: M9R8s4TBQzeFOkdqHpK+Fg==
X-CSE-MsgGUID: 6O3HiteBRPmcWCVILj/RNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8880399"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 11 Nov 2026 18:44:25 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRKnW-000000010IL-0i3G;
	Thu, 12 Nov 2026 02:44:22 +0000
Date: Thu, 12 Nov 2026 10:44:21 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5
Message-ID: <20261112104421.RkR72fpe-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: cprrfb7kht5fp5qh4axfcboy1jmdhibk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4EE720002
X-HE-Tag: 1794451467-408274
X-HE-Meta: U2FsdGVkX18fk+okDWaTgybWR97mUc0Ij0tmpw7IB2aI5L/wyBZcJUZLx7Mf2kWUN7Gn1jLgP/0aziDwkqyCTZZxFShFXsyUrSEsb4+zy1kY18hiAVQW46+ngqG6O5hwW9YH8slMK7IItOPRn9dp+4nTu97eK//NjxDOohajIobMyPwlBhmcuwdMoYP86nShGVGl2XxthgOjiyIrKjbi4uAHnj+me2hgOBbHrOzy9TLGfwmvg67Zwm3rQ+k+ecfYAYPDDdDZAqv9SXUpdwbwxzIkPEscqm63FmDR5gRzN0AtVK4UlDOx/0vC4isvVXvD/VK/HZ62UcnDlq7sf9VChb5A9VzzdJMXCTprimWKdQZ0NKzrCbAjDMebsXVvqSfsXn+tl7UA2O68LsBsM6my5v5/r27L2ZqCYtDc9tHF76e8nK5j1VJQyGCgp1JcPa9mNCW8g2Oi2rSeFoUXzbvmIBsvsKjQt6PCI8na5gdqeFQPIEhBx5eDnAQ9s5DOKg2BtRbicCXF59d0d0lW7dv0WdmA3K/AoEHg86kP2N2Ep3WFuuxnmOd6pt5wxBoXw2ZwpEX+RIIbCAqk2/s+EsGEwN2tvNzjBQF4T/LdkjRmTi95GO24OE/x+BA9gcmwe9JKW9IcBremyDx/vt95ZfhYuoApkm77tPY2o3kLiD2VPTmlLNmLoIDt3ovWg5KnU0iTdrEvHjlVn7/giojxxaEB8hZ+xoUH2ZqTcCXuAMjzvHUHZTQkDawS14Ms9vXWc/vNL4R1asDcD5EHBoehN+BxFQOn4u4KD4hZ6Kmkpaq3iA81yk3i7nUzAtYhAWEVO2nsGg2J4gjL3bb6Lh6SZXnhHahLPQbTvkqSIPquMjkzmYe3wXYaHa1c2iBMssdS01fehLdzxkui9GAOXVLYlxmQUbd4LkqfW5Qo1cq9KqbNEMpG6wVCMujCNyk6ieqOLc9Usg75y5S+vR3S1sSWeCT
 zHeB5bTS
 UArs6zFTwKsTLrKfWQG5GDnI4L0219kJXslVynXAe5V0iqDZ7TX3mXj2IQ9oc1cn3sDLlsQQzzrXCB604m6929Ub49VBbKz3C4lRzWjVRi5a7msGuApKNP0S3LrR4aU6cVBYzpU+I4xWOwjQKLl3y0lc9FqnWL8SAu/73lCczdAM+14ZMVJceP50iM42YPjYVYy3irKrJa8U6IaBDDV+haKWOQi8j5+rKGvKq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5  Add linux-next specific files for 20261110

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611112032.TMyPU6Rm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611120249.0rbvGayD-lkp@intel.com

    kernel/bpf/scev.c:3391:5: warning: stack frame size (1088) exceeds limit (1024) in 'bpf_compute_loop_iters' [-Wframe-larger-than]
    mm/shmem.c:1330:13: warning: stack frame size (1056) exceeds limit (1024) in 'shmem_undo_range' [-Wframe-larger-than]

Warning ids grouped by kconfigs:

recent_errors
`-- mips-eyeq6_defconfig
    |-- kernel-bpf-scev.c:warning:stack-frame-size-()-exceeds-limit-()-in-bpf_compute_loop_iters
    `-- mm-shmem.c:warning:stack-frame-size-()-exceeds-limit-()-in-shmem_undo_range

elapsed time: 1471m

configs tested: 170
configs skipped: 4

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261111    gcc-13.5.0
arm64                 randconfig-1001-20261111    gcc-13.5.0
arm64                 randconfig-1002-20261111    gcc-13.5.0
arm64                 randconfig-1003-20261111    gcc-13.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261111    gcc-13.5.0
csky                  randconfig-1001-20261111    gcc-13.5.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261111    clang-17
hexagon               randconfig-1000-20261112    clang-24
hexagon               randconfig-1001-20261111    clang-17
hexagon               randconfig-1001-20261112    clang-24
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261112    clang-22
i386        buildonly-randconfig-1001-20261112    clang-22
i386        buildonly-randconfig-1002-20261112    clang-22
i386        buildonly-randconfig-1003-20261112    clang-22
i386        buildonly-randconfig-1004-20261112    clang-22
i386        buildonly-randconfig-1005-20261112    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261111    gcc-13
i386                  randconfig-1001-20261111    gcc-13
i386                  randconfig-1002-20261111    gcc-13
i386                  randconfig-1003-20261111    gcc-13
i386                  randconfig-1004-20261111    gcc-13
i386                  randconfig-1005-20261111    gcc-13
i386                  randconfig-1006-20261111    gcc-13
i386                  randconfig-1007-20261111    clang-22
i386                  randconfig-1008-20261111    clang-22
i386                  randconfig-1009-20261111    clang-22
i386                  randconfig-1010-20261111    clang-22
i386                  randconfig-1011-20261111    clang-22
i386                  randconfig-1012-20261111    clang-22
i386                  randconfig-1013-20261111    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261111    clang-17
loongarch             randconfig-1000-20261112    clang-24
loongarch             randconfig-1001-20261111    clang-17
loongarch             randconfig-1001-20261112    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261111    clang-17
nios2                 randconfig-1000-20261112    clang-24
nios2                 randconfig-1001-20261111    clang-17
nios2                 randconfig-1001-20261112    clang-24
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261112    gcc-12.5.0
parisc                randconfig-1001-20261112    gcc-12.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc               randconfig-1000-20261112    gcc-12.5.0
powerpc               randconfig-1001-20261112    gcc-12.5.0
powerpc64             randconfig-1000-20261112    gcc-12.5.0
powerpc64             randconfig-1001-20261112    gcc-12.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261111    gcc-16.2.0
sparc                 randconfig-1000-20261112    gcc-8.5.0
sparc                 randconfig-1001-20261111    gcc-16.2.0
sparc                 randconfig-1001-20261112    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261111    gcc-16.2.0
sparc64               randconfig-1000-20261112    gcc-8.5.0
sparc64               randconfig-1001-20261111    gcc-16.2.0
sparc64               randconfig-1001-20261112    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261111    gcc-16.2.0
um                    randconfig-1000-20261112    gcc-8.5.0
um                    randconfig-1001-20261111    gcc-16.2.0
um                    randconfig-1001-20261112    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261111    gcc-14
x86_64      buildonly-randconfig-1000-20261112    gcc-14
x86_64      buildonly-randconfig-1001-20261111    gcc-14
x86_64      buildonly-randconfig-1001-20261112    gcc-14
x86_64      buildonly-randconfig-1002-20261111    gcc-14
x86_64      buildonly-randconfig-1002-20261112    gcc-14
x86_64      buildonly-randconfig-1003-20261111    gcc-14
x86_64      buildonly-randconfig-1003-20261112    gcc-14
x86_64      buildonly-randconfig-1004-20261111    gcc-14
x86_64      buildonly-randconfig-1004-20261112    gcc-14
x86_64      buildonly-randconfig-1005-20261111    gcc-14
x86_64      buildonly-randconfig-1005-20261112    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1006-20261111    clang-22
x86_64                randconfig-1007-20261111    clang-22
x86_64                randconfig-1008-20261111    clang-22
x86_64                randconfig-1009-20261111    clang-22
x86_64                randconfig-1010-20261111    clang-22
x86_64                randconfig-1011-20261111    clang-22
x86_64                randconfig-1012-20261111    gcc-14
x86_64                randconfig-1013-20261111    gcc-14
x86_64                randconfig-1014-20261111    gcc-14
x86_64                randconfig-1015-20261111    gcc-14
x86_64                randconfig-1016-20261111    gcc-14
x86_64                randconfig-1017-20261111    gcc-14
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
xtensa                randconfig-1000-20261111    gcc-16.2.0
xtensa                randconfig-1000-20261112    gcc-8.5.0
xtensa                randconfig-1001-20261111    gcc-16.2.0
xtensa                randconfig-1001-20261112    gcc-8.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

