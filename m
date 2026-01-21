Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998CDD262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B656B0005; Wed, 21 Jan 2026 00:24:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54076B0088; Wed, 21 Jan 2026 00:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D956B0089; Wed, 21 Jan 2026 00:24:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C840C6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:24:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52E82140526
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:24:44 +0000 (UTC)
X-FDA: 84354831288.02.92268F4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 98E4A1C0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:24:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B0i2pHFF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768973082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0O5pyA8V5L55p6x+BPTFXLlgJnNHQCh892dAl8A1oYA=;
	b=f75mWntqgD6BXDkzEJRlGRwtn1cILhnv3oU9EzZbkt31+M4pu4bsmIUsbC9ZLnAgtpcIGP
	BVi7wg/gkEVFM9ZwFOGCB3UO2lVBVsoReNW5iq/6koaPMdI0q3zvgqI4rr3xrS98pvwFX/
	mYRSXyVwAvgyD8AOErG/19HWw05SW3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768973082; a=rsa-sha256;
	cv=none;
	b=M4oTD687AzXBs33OeOkcVyWEPSGQfpzJi1dOYk+6+Ja+AQfipoV6YQog8XeV8AzzC2XvGa
	9XMB7gMIwu6kCA4UHBfmlxGY4gSh7medjj+xouTknzVo/p2x21G39uVF1eaEGhhlNQNaf3
	FOHi7vk3k5vOlSyk4YmnBYQtUDYmXGM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B0i2pHFF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768973082; x=1800509082;
  h=date:from:to:cc:subject:message-id;
  bh=vnwrjUI9iQbThArUy/KWpVzCwx7djeX95mR1vfQtSpU=;
  b=B0i2pHFFmwAYoioVh5qptPAbWNpkHONnRcqtnK1wLNuwQMoO4RHdcA55
   vtkP0BAeTTmYtH5u1zG6fDv8xKaRn8fxw0cDHp0tiq5QpUx/VxaaR8KQg
   +Yocg6ErB/uYI9za51whX3vGMyM2EXMWaoEkHHoFBKB8td+UcvVDkblQs
   b06Zcrhx2cWwVcvdTz0MK3AVsImS/8MYRDP/T4Z5dlBrYchstZAxv00gO
   +vgOX6g9XFaVYxwgXKq/JJFVx0C2jf0X3OUxDKWeDTmLTMaoaQt/vqLGs
   RSeEfqgvuJXWZIe5b9FvLPnGd2Xzl9UM1tknAXYB7aSKdIBPqTKfRr3K1
   Q==;
X-CSE-ConnectionGUID: Gc3CWThYQTqLbD0rLy5A6w==
X-CSE-MsgGUID: fYpCRpayStS/Nq6f/1SCFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="73821808"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="73821808"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:24:35 -0800
X-CSE-ConnectionGUID: Viw+zaDhSfm1dztwRdYEZQ==
X-CSE-MsgGUID: Kzyxy6OoQzmVXTZHsKAT9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206756859"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Jan 2026 21:24:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1viQhi-00000000Q15-23Iv;
	Wed, 21 Jan 2026 05:24:30 +0000
Date: Wed, 21 Jan 2026 13:23:31 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 053966c344dbd346e71305f530e91ea77916189f
Message-ID: <202601211323.sj4ydGC3-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 98E4A1C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: ss6zwcd4ot18esun4qkcsg5tjoy1oxtp
X-HE-Tag: 1768973081-710783
X-HE-Meta: U2FsdGVkX186aEAgTfKWsgrZNCMEkdqtmP2DiJ2NcCdHXyZyXXucFROC7PjHtsrPWtMtzZRt/WioqW95T6l9lOR5fWrkaLsUZgo3aguehFDfrzWUyQPIxzg9+EOkyB53J75xwL5sVKC3iPbExgdXymfTuUYc+idLZ+ekihqeIrbyiAbXykzXnRTIuzkKRqPUBpcGgRCLt76aNCbJjL5iu+jp4fBnbLJWnAoE1yogg94HH7UY/j5EvFKcbihfBb6KCsmi+0gnX5PScCz3t6QjW6KosER1FwwtdFcYjX3V+FYvn2tvJP9YOQA0h8hVOMNAmzSDYIiqBeLtVZL76dq2uX0XxU0HVMSQcLrHQYZyYPhAxQNUnHCtDgCuh8o/WEJCPtbuyWfN3l7eff3zG/Ta0ycRbaYKrMoe82H+MWsLS9t2uF9R+Iwa2s2ZIcmqlWAuUCXEA5FZ3RQLFWPr0DJCUhqCqXwKrWDiwVQ+JBGXQ10NZfaChjLytlQHWVaHLAdM2gGfU8jGrq5+vLIPU8+Xd2zU4JuYZHfQmCv5n2UXFglddm8Y8JyK7E6YougXpeQ0+e8NbyFs+GhpUG0IDVXMcUp/723SI+lo1lJ9jC/2wypk2ISrruwddvx8x65++OOagulj6DCESAUA/LGkZ672olCgtAGE6Jgwv9qR38A251GH8B6sIcsRC5t3ya0yzyLdai9xncnMpex9S9UxNKQU/07V2lJXowkoNyEb3KXgxZFIkX/56D7SLPi/4nGNinTztO2QfyTs5CjBtLUy87LwK3wAX/BQgEwRwyydOA1mlYM2TK9tMdD5fd7H4QmG4g+Yh+vuuOEHQRQ8x1HtwxfoI9PlBfZhcwYWSK+NMROvDCxw9KJ1+lC4iie4TNF5jNqJVJ+NXnfHgtbVtHhTWVRZmp3DJp4FQZwQeS4kc9bZHLfW3JMpI7QBS5SbqA4lk7kHAW57MwUehNXv8SIc/CK
 vA6pWqqv
 oXaZZkaforMiyz4GZzSA758KxFmZrzWqv9PGNe5ZBLTuqmKgW3IDLNCQEm2cVSPlJ1iEtTyz2srNepRQg6c7eHIMeoMRHeBDaYnle1jaiqGopdNlLMtn0h4r4mhDlJtV3JYfm7SBtxNnWCkCS8nZvdlWuRKove47ku5KeuNQf5x2AMPdg/fTJJsK/WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 053966c344dbd346e71305f530e91ea77916189f  Add linux-next specific files for 20260120

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601210526.OT45dlOZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601210645.11u5Myme-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601210715.vxSStJeF-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601210825.ELrpQeED-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601211041.pcTzwcdp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601210349.B40O8be9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601211049.BNLGTiRl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601211251.gfacfa2w-lkp@intel.com

    WARNING: modpost: drivers/md/dm-verity: section mismatch in reference: dm_verity_init+0x30 (section: .init.text) -> dm_verity_verify_sig_exit (section: .exit.text)
    WARNING: modpost: drivers/md/dm-verity: section mismatch in reference: init_module+0x44 (section: .init.text) -> dm_verity_verify_sig_exit (section: .exit.text)
    arch/riscv/include/asm/uaccess.h:115:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    drivers/phy/phy-google-usb.c:261:(.text+0x6b2): undefined reference to `typec_switch_register'
    drivers/phy/phy-google-usb.c:273:(.text+0x11): undefined reference to `typec_switch_unregister'
    drivers/phy/phy-google-usb.c:82:(.text+0x102): undefined reference to `typec_switch_get_drvdata'
    fs/ext4/ext4.h:1843:1: warning: mutex 'EXT4_SB(sb).s_fc_lock' is still held at the end of function [-Wthread-safety-analysis]
    fs/ext4/ext4.h:1848:2: warning: releasing mutex 'EXT4_SB(sb).s_fc_lock' that was not held [-Wthread-safety-analysis]
    mm/memory.c:1844:12: warning: spinlock 'pmd_lockptr(mm, pmd)' is not held on every path through here [-Wthread-safety-analysis]
    mm/memory.c:1847:3: warning: releasing spinlock 'pmd_lockptr(mm, pmd)' that was not held [-Wthread-safety-analysis]
    mm/memory.c:1865:11: warning: spinlock 'ptl' is not held on every path through here [-Wthread-safety-analysis]

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/mips/include/asm/jump_label.h:42:11: error: unknown instruction, did you mean: b?
    drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c:60:1: sparse: sparse: bad integer constant expression
    drivers/soc/renesas/rzn1_irqmux.c:125:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- loongarch-defconfig
|   `-- WARNING:modpost:drivers-md-dm-verity:section-mismatch-in-reference:init_module-(section:.init.text)-dm_verity_verify_sig_exit-(section:.exit.text)
|-- mips-randconfig-r112-20260121
|   `-- arch-mips-include-asm-jump_label.h:error:unknown-instruction-did-you-mean:b
|-- riscv-randconfig-r064-20260121
|   `-- arch-riscv-include-asm-uaccess.h:warning:cast-to-pointer-from-integer-of-different-size
|-- riscv-randconfig-r123-20260120
|   `-- drivers-soc-renesas-rzn1_irqmux.c:sparse:sparse:bad-integer-constant-expression
|-- s390-randconfig-002-20260121
|   |-- fs-ext4-ext4.h:warning:mutex-EXT4_SB(sb).s_fc_lock-is-still-held-at-the-end-of-function
|   |-- fs-ext4-ext4.h:warning:releasing-mutex-EXT4_SB(sb).s_fc_lock-that-was-not-held
|   |-- mm-memory.c:warning:releasing-spinlock-pmd_lockptr(mm-pmd)-that-was-not-held
|   |-- mm-memory.c:warning:spinlock-pmd_lockptr(mm-pmd)-is-not-held-on-every-path-through-here
|   `-- mm-memory.c:warning:spinlock-ptl-is-not-held-on-every-path-through-here
|-- sparc64-randconfig-002-20260121
|   `-- WARNING:modpost:drivers-md-dm-verity:section-mismatch-in-reference:dm_verity_init-(section:.init.text)-dm_verity_verify_sig_exit-(section:.exit.text)
|-- um-randconfig-001-20260121
|   |-- drivers-phy-phy-google-usb.c:(.text):undefined-reference-to-typec_switch_get_drvdata
|   |-- drivers-phy-phy-google-usb.c:(.text):undefined-reference-to-typec_switch_register
|   `-- drivers-phy-phy-google-usb.c:(.text):undefined-reference-to-typec_switch_unregister
`-- x86_64-randconfig-r133-20260121
    `-- drivers-net-wireless-intel-iwlwifi-cfg-rf-fm.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 726m

configs tested: 177
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260121    gcc-8.5.0
arc                   randconfig-002-20260121    gcc-10.5.0
arc                    vdk_hs38_smp_defconfig    gcc-15.2.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.2.0
arm                         assabet_defconfig    clang-18
arm                                 defconfig    clang-22
arm                   randconfig-001-20260121    clang-20
arm                   randconfig-002-20260121    gcc-15.2.0
arm                   randconfig-003-20260121    clang-18
arm                   randconfig-004-20260121    clang-22
arm                           stm32_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260121    gcc-15.2.0
arm64                 randconfig-002-20260121    clang-22
arm64                 randconfig-003-20260121    clang-22
arm64                 randconfig-004-20260121    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260121    gcc-9.5.0
csky                  randconfig-002-20260121    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260121    clang-19
hexagon               randconfig-002-20260121    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260121    clang-20
i386        buildonly-randconfig-002-20260121    gcc-14
i386        buildonly-randconfig-003-20260121    gcc-13
i386        buildonly-randconfig-004-20260121    clang-20
i386        buildonly-randconfig-005-20260121    clang-20
i386        buildonly-randconfig-006-20260121    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260121    gcc-14
i386                  randconfig-002-20260121    clang-20
i386                  randconfig-003-20260121    clang-20
i386                  randconfig-004-20260121    clang-20
i386                  randconfig-005-20260121    gcc-14
i386                  randconfig-006-20260121    clang-20
i386                  randconfig-007-20260121    clang-20
i386                  randconfig-011-20260121    gcc-14
i386                  randconfig-012-20260121    gcc-14
i386                  randconfig-013-20260121    clang-20
i386                  randconfig-014-20260121    gcc-12
i386                  randconfig-015-20260121    gcc-14
i386                  randconfig-016-20260121    gcc-14
i386                  randconfig-017-20260121    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260121    gcc-15.2.0
loongarch             randconfig-002-20260121    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                         apollo_defconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260121    gcc-11.5.0
nios2                 randconfig-002-20260121    gcc-10.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260121    gcc-9.5.0
parisc                randconfig-002-20260121    gcc-13.4.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                       holly_defconfig    clang-22
powerpc               randconfig-001-20260121    clang-22
powerpc               randconfig-002-20260121    clang-22
powerpc                     tqm8560_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260121    clang-22
powerpc64             randconfig-002-20260121    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260121    clang-16
riscv                 randconfig-002-20260121    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                  randconfig-001-20260121    gcc-9.5.0
s390                  randconfig-002-20260121    clang-22
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                        edosk7760_defconfig    gcc-15.2.0
sh                    randconfig-001-20260121    gcc-14.3.0
sh                    randconfig-002-20260121    gcc-9.5.0
sparc                            alldefconfig    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260121    gcc-8.5.0
sparc                 randconfig-002-20260121    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260121    gcc-13.4.0
sparc64               randconfig-002-20260121    gcc-15.2.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260121    gcc-14
um                    randconfig-002-20260121    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260121    clang-20
x86_64      buildonly-randconfig-002-20260121    clang-20
x86_64      buildonly-randconfig-002-20260121    gcc-14
x86_64      buildonly-randconfig-003-20260121    clang-20
x86_64      buildonly-randconfig-004-20260121    clang-20
x86_64      buildonly-randconfig-005-20260121    clang-20
x86_64      buildonly-randconfig-005-20260121    gcc-13
x86_64      buildonly-randconfig-006-20260121    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260121    clang-20
x86_64                randconfig-002-20260121    gcc-14
x86_64                randconfig-003-20260121    gcc-14
x86_64                randconfig-004-20260121    gcc-14
x86_64                randconfig-005-20260121    clang-20
x86_64                randconfig-006-20260121    clang-20
x86_64                randconfig-011-20260121    gcc-14
x86_64                randconfig-012-20260121    clang-20
x86_64                randconfig-013-20260121    gcc-14
x86_64                randconfig-014-20260121    gcc-14
x86_64                randconfig-015-20260121    clang-20
x86_64                randconfig-016-20260121    gcc-14
x86_64                randconfig-071-20260121    clang-20
x86_64                randconfig-072-20260121    clang-20
x86_64                randconfig-073-20260121    clang-20
x86_64                randconfig-074-20260121    clang-20
x86_64                randconfig-075-20260121    clang-20
x86_64                randconfig-076-20260121    gcc-13
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260121    gcc-14.3.0
xtensa                randconfig-002-20260121    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

