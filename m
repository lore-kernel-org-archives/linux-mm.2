Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2CDC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC576B00A7; Mon,  4 Aug 2025 14:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D686B00A8; Mon,  4 Aug 2025 14:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2E96B00A9; Mon,  4 Aug 2025 14:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB576B00A7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:25:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD4871A083C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:25:09 +0000 (UTC)
X-FDA: 83739901938.11.5775A66
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38ED314000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:25:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RQiw8R4T;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754331907; a=rsa-sha256;
	cv=none;
	b=jy2OqPLLmxGvQjjP3/lZnpoqYlCoUDuX0vVXYRfF91jMvTawDaYBt41DuvCsCiDDiFnBi9
	HwrVoM0SticEkzooTryCaWBvhgSQw+p+6MlDfoXHKDmszs8PemWQ+dAP2arJ78k339I6Tw
	XpjtWNwLtYjJYD1r1G/ejfn4BBS1ohs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RQiw8R4T;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754331907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sHpos3/07FOBAf/55GOOoY33ga/ZIEY89kb263RXh04=;
	b=OY2Jesutq/xPBP34slb2P/vl1ssqKOHy7iZVL8rLQKLcIXmDfTq4LDwMF8Hut/SohM7L9X
	M5I1jySlTgj6nFZmifVGk2bZTItXM9TaU0dMHH54nvuCv6oRmg3ro+Jb3is6zW4EJ3An0x
	LmhRAJ7LBNo58TdU/2f/IDIXt/B6tic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754331907; x=1785867907;
  h=date:from:to:cc:subject:message-id;
  bh=HTy1ZMRRPbkDrBlSm5caxd6qm4N1FqYeWnmzkVRA1dw=;
  b=RQiw8R4TQ9PiUMn1OqdsuLxvHWGmeswheT6VgV2wrhYnEwJOoWlFGTEw
   A7yS/u0nzoMZvLp9PuhnEFWUKAJeHEyYNVzp/TinkSXXJEMnf9X8luhqu
   WcyCvEwOCvoICRwcbU0ijXeeuwOSNtw7WDoWus1F+KyWnJQwUyL3u19pa
   PfS4NyKFAaPdRrztrTVpRcU6uFxi+R2oxZvb+D1Bid/C3AEIikemLcpb7
   p+SurYkFNbreVVqoblcq0mS5PkVlj85ImasWyTqNBROKYIsdIpsbkHwKC
   Pfo8xkeg983A3fftfMePRYD9H+hkrxzj6EGQ74Ym2W7EqKxYgc8zVIFYG
   w==;
X-CSE-ConnectionGUID: ISlyyBA8SNm36u0+oKWd6g==
X-CSE-MsgGUID: 9Yr6Y5V1RXGixoUuYQMweg==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="56686869"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="56686869"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 11:25:06 -0700
X-CSE-ConnectionGUID: AZ6AZjX0RNuDsfQspUCZrA==
X-CSE-MsgGUID: 60X/1c2sRVy2x4S6T5n+Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164548869"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 04 Aug 2025 11:25:05 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uizrc-0000Bf-3A;
	Mon, 04 Aug 2025 18:24:55 +0000
Date: Tue, 05 Aug 2025 02:24:11 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 5c5a10f0be967a8950a2309ea965bae54251b50e
Message-ID: <202508050258.gObVwDvf-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38ED314000D
X-Stat-Signature: yx69qz36y3jm4tnioqbkeqw6tpfqrpwu
X-HE-Tag: 1754331907-778618
X-HE-Meta: U2FsdGVkX1852MLKsJElZwAdAMki5Gq4/pX4p2ub1mz2fpLTO7PRdMtdV7+QTl0uDClZ6CUTEHrZuE/ZZUOgpNQhEHbFv+McFEefoLnlquQ+H4scNOFH89qHZSvo+aCQJRabH+H/tcJDfI22ZFuarUqDdd52oeTiUVXtja0m4ylw2BM+nlzpUWTuIoY3FwSRdoJwYnHMcIAXH9CAT5BqtgsJm4BhcmjyYsFo8zx4ag64KlrIKRNvxn4wOQ5lcgKSVawJbYy24GZECSENUgF7P74qkVzcM0ndHPfmuGT5hFezBdx7daEs1hDyPGeH8bZR0tagC9ngnIeLGOs+ZLyrXIvQCkKiZsaz0IMGLCjB4cYwO2zvgYQjHwlYZhaMAWZU0OEn98MgfP46KY1TEQsIph9GMGBA1zf/bbAC9kzXgt5IYuC93UcJa3oHGzbctfK4VZUUTBRNR+m2s0BvMVvAYMOnyRvhFsEd7WhaQaQ90W0ozGPaAYXns90AenCeJMJ+/1wk3/c2LMtsu+szH2p8KGG19Bh1jjuoHEzBG4CqHlVI3RbfecoeZJD75AuZxHQAixw7eILJPne5GCsUmNL0TcrzIMuY/V64CN5RgzX6s0/Eg10EaqGVQ8kLBUbFt/JvnqjO0Ar29+d9iDFR1OcTcAI4Gn7ppeaLWIkmCYTOQLbf5hzVR4RYPWKk5MCR/Uzf9DNjmmmsOi28PJE9iht2Gy3HZVTK66pmQ0rV9OkBAzDlPCXNP28SUmZCNNZFDJ0pNIa/KvRtfhew4LfUMSR+ofclU7dsxSAQ3avq9heUmBFtnqjlBRyjc0fa5Bse9YHsExIHNYxj08QMGnLtis6YE91g5C8LcGMZJQntILIMHa9eHZDFmdv2NcKZ9rFS4jzEBkeBTghT5mI6Bu91jSNTOiu1cBIPe61aM/8Hkxjlgnr0HRbWE9P2GIuXLjXicL20DtKUFbrqFvw/CPiKhmU
 aVuO1a0l
 B9sKXqFaAMdrFVnyuKfECtlpgTWW1rfhXgeuN/6XYG8tJrbMK/NR6+n5RDTmOJAOMVamlglPvKxRAjkAC4dJSqkbBUx/95tvt8EMHaMvxodL7dr4mu96U6i2BYM4n3Mk8nZkvr0EJ4QsiYKbS1hEGPWxrxQmuUkcRFLS6TXb/zEtXhh5YjTpyiCx6Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 5c5a10f0be967a8950a2309ea965bae54251b50e  Add linux-next specific files for 20250804

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220705.n9m6UpDd-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507242212.lrePIIjT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com

    kismet: WARNING: unmet direct dependencies detected for MFD_AT91_USART when selected by SERIAL_ATMEL
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 when selected by SM_VIDEOCC_6350
    kismet: WARNING: unmet direct dependencies detected for STACKTRACE when selected by STACKDEPOT
    vmlinux.o: warning: objtool: populate_audio_dp_link_info+0x1fc: sibling call from callable instruction with modified stack frame
    vmlinux.o: warning: objtool: translate_to_dto_source+0x40: sibling call from callable instruction with modified stack frame

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_pt.c:2487 xe_pt_update_ops_run() error: uninitialized symbol 'ifence'.
    drivers/gpu/drm/xe/xe_pt.c:2492 xe_pt_update_ops_run() error: uninitialized symbol 'mfence'.
    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol 'subvolid'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-STACKTRACE-when-selected-by-STACKDEPOT
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-MFD_AT91_USART-when-selected-by-SERIAL_ATMEL
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-when-selected-by-SM_VIDEOCC_6350
|-- loongarch-randconfig-002-20250730
|   |-- vmlinux.o:warning:objtool:populate_audio_dp_link_info:sibling-call-from-callable-instruction-with-modified-stack-frame
|   `-- vmlinux.o:warning:objtool:translate_to_dto_source:sibling-call-from-callable-instruction-with-modified-stack-frame
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|-- um-randconfig-001-20250804
|   `-- drivers-gpu-drm-msm-msm_gem.c:error:incomplete-definition-of-type-struct-msm_kms
`-- x86_64-randconfig-161-20250804
    |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
    |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
    `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.

elapsed time: 724m

configs tested: 134
configs skipped: 5

tested configs:
alpha                            alldefconfig    gcc-15.1.0
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250804    gcc-8.5.0
arc                   randconfig-002-20250804    gcc-13.4.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                        clps711x_defconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20250804    clang-22
arm                   randconfig-002-20250804    clang-22
arm                   randconfig-003-20250804    clang-22
arm                   randconfig-004-20250804    gcc-15.1.0
arm                       versatile_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250804    clang-22
arm64                 randconfig-002-20250804    clang-19
arm64                 randconfig-003-20250804    clang-22
arm64                 randconfig-004-20250804    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250804    gcc-12.5.0
csky                  randconfig-002-20250804    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250804    clang-22
hexagon               randconfig-002-20250804    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250804    clang-20
i386        buildonly-randconfig-002-20250804    gcc-12
i386        buildonly-randconfig-003-20250804    clang-20
i386        buildonly-randconfig-004-20250804    gcc-12
i386        buildonly-randconfig-005-20250804    gcc-12
i386        buildonly-randconfig-006-20250804    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250804    gcc-15.1.0
loongarch             randconfig-002-20250804    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                           virt_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250804    gcc-10.5.0
nios2                 randconfig-002-20250804    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250804    gcc-12.5.0
parisc                randconfig-002-20250804    gcc-14.3.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                 mpc834x_itx_defconfig    clang-16
powerpc               randconfig-001-20250804    gcc-8.5.0
powerpc               randconfig-002-20250804    gcc-13.4.0
powerpc               randconfig-003-20250804    clang-22
powerpc                     tqm5200_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250804    clang-22
powerpc64             randconfig-002-20250804    clang-19
powerpc64             randconfig-003-20250804    clang-16
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250804    gcc-8.5.0
riscv                 randconfig-002-20250804    gcc-13.4.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250804    clang-22
s390                  randconfig-002-20250804    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250804    gcc-14.3.0
sh                    randconfig-002-20250804    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250804    gcc-8.5.0
sparc                 randconfig-002-20250804    gcc-13.4.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250804    gcc-10.5.0
sparc64               randconfig-002-20250804    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250804    clang-22
um                    randconfig-002-20250804    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250804    clang-20
x86_64      buildonly-randconfig-002-20250804    gcc-12
x86_64      buildonly-randconfig-003-20250804    gcc-12
x86_64      buildonly-randconfig-004-20250804    gcc-12
x86_64      buildonly-randconfig-005-20250804    clang-20
x86_64      buildonly-randconfig-006-20250804    gcc-12
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250804    gcc-11.5.0
xtensa                randconfig-002-20250804    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

