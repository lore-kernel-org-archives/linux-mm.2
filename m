Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC7BC9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 08:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7826B008A; Sun, 27 Sep 2026 04:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978A76B008C; Sun, 27 Sep 2026 04:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867CB6B0092; Sun, 27 Sep 2026 04:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59F8B6B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:01:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C141F1409F5
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:01:54 +0000 (UTC)
X-FDA: 85258798548.21.1295F43
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 295C5100002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:01:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkB7tQkW;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790496112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w8P+UibEfVP15szPzDuzmLmGX2UDRIBoROAdnTYa85Y=;
	b=4HTWdGGHNRSDxjMh4vGInDAEdOEW5+knv/HzhshfvjY8W69MA3WIaOmb4WqjIOrEesIjt9
	bUXQnqXLfAtAOxexXAAdkbUA9MB5zLoMow9qmxtfRwd6QIYcuMZUDGbPulAxz/wc8WZKQ1
	gSfHhYYimv+uqMMCYXz6ftmHZAYvhDQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790496112;
	b=ebrbK1LNRihvVSXG70p1+BUnS63ft/7T7/Omw/8/I+kgSKMnNDnRWU54Iqs1fc7ugUZJ+f
	hcRKxBv5+WN+usjJ3BscmPqk88CqV37KlSnWjcvYswWaWBF2KV2xMOMaIaF4bccIqgQ0AF
	SOLhE4aK66OC6dwt9b9WYf4lzJiyjN4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkB7tQkW;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790496112; x=1822032112;
  h=date:from:to:cc:subject:message-id;
  bh=MLJuWrkLySwAHrkDvjZnUGNkMCduRJagpB+b4OtBjy4=;
  b=XkB7tQkW4vjwRK4Zh2N0pZxEmaGFJ+RTUbeOGLoHK9pVCJ+qHomGPC9J
   Nl+og4MYlDdwZqT7o0nUYmW31rM01tWFWa5fqrC51b5vRPSwgi2a71K3l
   l2fA95xEfTiQti9fX8HKZMckJjD2gelXSG8XqmyTAU3iwIB5TaqR9vtgN
   GUniZj2oJG2uFwu1l4g4wQ8oMhN6Kgn0EubX6YWiZOChqzRF0tSjETpOH
   ZekyoV93jyhIgY05TqMY5zBa1vo6Gsc2fRMhSs2iQOIOfqy4hGoDicXAD
   dRunptaGQzR12HYUxuXVDawr1Uraqd+fe84j5it5FCYQJCWATuThdZ+zt
   A==;
X-CSE-ConnectionGUID: 1rvUK21xQtuX18rly31M8A==
X-CSE-MsgGUID: GulzkM2+RR+docoMenBRXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100555949"
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="100555949"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 01:01:48 -0700
X-CSE-ConnectionGUID: 8pBcRg3HSU+eIRc6XfbBrw==
X-CSE-MsgGUID: OzD0moufR7eS1rIV8i1sjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="273358816"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 27 Sep 2026 01:01:46 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAjpP-00000000MgJ-2FeL;
	Sun, 27 Sep 2026 08:01:43 +0000
Date: Sun, 27 Sep 2026 16:00:49 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 b4fc90c82982d98959af08b4320420bcfc01303b
Message-ID: <202609271644.eX9EFdJw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 295C5100002
X-Stat-Signature: tbn5somro9coebcbf8j5qq5g7mdqoqfn
X-Rspam-User: 
X-HE-Tag: 1790496112-421172
X-HE-Meta: U2FsdGVkX1+Bk6gx3p4f/zSo0so6ssyq/NqQV3XqKo0oyoRHLEUQF79c5hT2LbWZqyQMFWrKRWMi0YW8TxhjEOm2qCx+WVyIgCeRnd8/EZsPNJxkuaPlElPduc2cn991LBii5BoQ/Vv8jc4x7/0Y9/1pzJD4yO/VgV7/0DzVUNKumSGS9NTeJgxMBc2eXgTc+HJ0ihRPNZ3lOnpkpOlBp5NQgmKWHOD4d+wXyIq5A+ROWbO36KKOWsjiylK35gsFSDabv5eoYe+T9G6s1lMsG9AndJJbduApkZvfPVXDJ2fDwu41jTfCFNOjrBDhkXwWdM8pL3MJQO9o35m6kdYM+EBN1mpcU1L5JCHi6DQ8oExBw+0Ddm9UiO/GC94lLAsM4qrYTAcPz+l6H17YKnxNLQQIVhw7IOAcBeyhnd2AWDjbnNa5CWaimaSt2VM/AfrzcmRGVCAxEsutBsagnwS6PNwhZnO5Va9M2IUJvRD1rbjng0AoP0xITwlXKO32qm7LpdRNqvzrIzlc7IUY9BR1oofkjN5scYJAT4QmiMhLnTUx0ya2qUpXhEcyFa6q7MvwQET2j0tAuUAgvctvZgIrgasO7DuCyebm0trzges+0I74d4gxErksHC7HfFSHTgcmu2B9d/0ENIVgomBUR+TvhgdM6LrpueDC5u269AzEus1JuCpkEcqIsttZcjq0ualdOOJtc3SJ8mzfnx7LHDIgmcsHidYzAYpon38QgQ8ABI2jwzwOl56VrOi/n1xmkdhyk76X1YFCmVxGSa7E/1UtVJUWza8dsWXO7W6O3+yinC9w+i3uU3GhSNj7XlsJmvE4IJA5jxZVmljJig7QXHYRmBKB03sxNlMwQzEjrJhM6znzVhTfjNYHiNKUuwm4Jt3sZBo7MtrAbDLEOnLWhrh3oqHNu9X91teQ2rBTFI/IitFLG0E5X/g43qRMMV23OY4cjs02tGCp4qHDVpNtWG5
 CPWncLrV
 6q0JI3ygiQ02yQbKIVnv+3UQI9u4KuSyHxsFExOzTgTO/s9ZYyd+U7qnYQN1SUDZUgWozcUV2fWcvFOjofe38bLaIewPIRLTWEhPlEEiFVN+Q0yv8aFMg/wwNXhKW/Fg964679eCESSkxElLEHENCuEXuDMymJ0+I1j3A/IwtjKwCxq49XqakiGZLwhP6xx//yuTSM2gYTTe/mq1BiTIzq7yq7ekKo0trOElk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: b4fc90c82982d98959af08b4320420bcfc01303b  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com

    aarch64-linux-ld: Unexpected GOT/PLT entries detected!
    aarch64-linux-ld: Unexpected run-time procedure linkages detected!
    arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
    fs/proc/task_mmu.c:3450:17: error: implicit declaration of function 'drop_rcu' [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3452:17: error: implicit declaration of function 'reacquire_rcu' [-Werror=implicit-function-declaration]
    fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3452:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
    gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
    hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
    memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
    mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-1002-20260926
|   |-- aarch64-linux-ld:Unexpected-GOT-PLT-entries-detected
|   |-- aarch64-linux-ld:Unexpected-run-time-procedure-linkages-detected
|   |-- arena.c:(.text):undefined-reference-to-__check_safe_pte_update
|   |-- gup.c:(.text):undefined-reference-to-__check_safe_pte_update
|   |-- hugetlbpage.c:(.text):undefined-reference-to-__check_safe_pte_update
|   |-- memory.c:(.text):undefined-reference-to-__check_safe_pte_update
|   `-- mmu.c:(.text):undefined-reference-to-__check_safe_pte_update
|-- powerpc64-randconfig-1001-20260926
|   |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
|   `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu
|-- sparc-randconfig-1001-20260926
|   |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
|   `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu
`-- x86_64-randconfig-1012-20260926
    |-- fs-proc-task_mmu.c:error:call-to-undeclared-function-drop_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations
    `-- fs-proc-task_mmu.c:error:call-to-undeclared-function-reacquire_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations

elapsed time: 1450m

configs tested: 181
configs skipped: 5

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260926    gcc-8.5.0
arc                   randconfig-1001-20260926    gcc-12.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           gemini_defconfig    clang-24
arm                   randconfig-1000-20260926    clang-17
arm                   randconfig-1001-20260926    clang-24
arm                   randconfig-1002-20260926    clang-17
arm                   randconfig-1003-20260926    gcc-8.5.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260926    gcc-9.5.0
arm64                 randconfig-1001-20260926    clang-24
arm64                 randconfig-1002-20260926    gcc-8.5.0
arm64                 randconfig-1003-20260926    gcc-15.2.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260926    gcc-16.1.0
csky                  randconfig-1001-20260926    gcc-16.1.0
csky                 randconfig-r1300-20260926    gcc-13.4.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260926    clang-24
hexagon               randconfig-1001-20260926    clang-19
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260926    gcc-14
i386        buildonly-randconfig-1001-20260926    clang-22
i386        buildonly-randconfig-1002-20260926    gcc-14
i386        buildonly-randconfig-1003-20260926    gcc-14
i386        buildonly-randconfig-1004-20260926    gcc-14
i386        buildonly-randconfig-1005-20260926    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260926    gcc-14
i386                  randconfig-1001-20260926    gcc-14
i386                  randconfig-1002-20260926    gcc-14
i386                  randconfig-1003-20260926    clang-22
i386                  randconfig-1004-20260926    gcc-14
i386                  randconfig-1005-20260926    gcc-14
i386                  randconfig-1006-20260926    clang-22
i386                  randconfig-1007-20260926    gcc-14
i386                  randconfig-1008-20260926    gcc-14
i386                  randconfig-1009-20260926    gcc-14
i386                  randconfig-1010-20260926    clang-22
i386                  randconfig-1011-20260926    gcc-14
i386                  randconfig-1012-20260926    gcc-13
i386                  randconfig-1013-20260926    clang-22
i386                  randconfig-1300-20260926    clang-22   sparse
i386                  randconfig-1301-20260926    gcc-14     sparse
i386                  randconfig-1302-20260926    gcc-13     sparse
i386                 randconfig-r1303-20260926    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260926    gcc-13.4.0
loongarch             randconfig-1001-20260926    clang-18
loongarch            randconfig-r1305-20260926    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                      decstation_defconfig    gcc-16.1.0
mips                           rm200_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260926    gcc-10.5.0
nios2                 randconfig-1001-20260926    gcc-8.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260926    gcc-8.5.0
parisc                randconfig-1001-20260926    gcc-10.5.0
parisc64                             defconfig    gcc-16.1.0
powerpc                      akebono_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                           g5_defconfig    gcc-16.1.0
powerpc                   iss476-smp_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260926    gcc-8.5.0
powerpc               randconfig-1001-20260926    gcc-9.5.0
powerpc64             randconfig-1000-20260926    clang-24
powerpc64             randconfig-1001-20260926    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260926    gcc-15.2.0
riscv                 randconfig-1001-20260926    gcc-9.5.0
riscv                randconfig-r1309-20260926    clang-24   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260926    gcc-15.2.0
s390                  randconfig-1001-20260926    gcc-8.5.0
s390                 randconfig-r1301-20260926    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260926    gcc-10.5.0
sh                    randconfig-1001-20260926    gcc-12.5.0
sh                            se7751_defconfig    gcc-16.1.0
sparc                             alldefconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260926    gcc-14.3.0
sparc                 randconfig-1001-20260926    gcc-12.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260926    clang-20
sparc64               randconfig-1001-20260926    gcc-9.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260926    gcc-14
um                    randconfig-1001-20260926    clang-17
um                   randconfig-r1307-20260926    gcc-14     sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260926    gcc-14
x86_64      buildonly-randconfig-1001-20260926    clang-22
x86_64      buildonly-randconfig-1002-20260926    gcc-14
x86_64      buildonly-randconfig-1003-20260926    gcc-14
x86_64      buildonly-randconfig-1004-20260926    gcc-14
x86_64      buildonly-randconfig-1005-20260926    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260926    gcc-14
x86_64                randconfig-1001-20260926    gcc-14
x86_64                randconfig-1002-20260926    clang-22
x86_64                randconfig-1003-20260926    gcc-14
x86_64                randconfig-1004-20260926    gcc-14
x86_64                randconfig-1005-20260926    gcc-14
x86_64                randconfig-1006-20260926    gcc-12
x86_64                randconfig-1007-20260926    clang-22
x86_64                randconfig-1008-20260926    clang-22
x86_64                randconfig-1009-20260926    gcc-14
x86_64                randconfig-1010-20260926    clang-22
x86_64                randconfig-1011-20260926    gcc-14
x86_64                randconfig-1012-20260926    clang-22
x86_64                randconfig-1013-20260926    gcc-14
x86_64                randconfig-1014-20260926    clang-22
x86_64                randconfig-1015-20260926    clang-22
x86_64                randconfig-1016-20260926    clang-22
x86_64                randconfig-1017-20260926    clang-22
x86_64                randconfig-1300-20260926    clang-22   sparse
x86_64                randconfig-1301-20260926    gcc-13     sparse
x86_64                randconfig-1302-20260926    gcc-13     sparse
x86_64               randconfig-r1306-20260926    clang-22   sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260926    gcc-16.1.0
xtensa                randconfig-1001-20260926    gcc-8.5.0
xtensa               randconfig-r1302-20260926    gcc-11.5.0 sparse
xtensa               randconfig-r1304-20260926    gcc-11.5.0 sparse
xtensa               randconfig-r1308-20260926    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

