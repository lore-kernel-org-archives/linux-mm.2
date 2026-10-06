Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763C1CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 02:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C126B0088; Mon,  5 Oct 2026 22:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233566B008C; Mon,  5 Oct 2026 22:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123866B0092; Mon,  5 Oct 2026 22:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9D26B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 22:12:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F7C18052F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:12:39 +0000 (UTC)
X-FDA: 85290577638.14.9716784
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id A44AF80009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:12:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ePCUJoSt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791252757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=eEOa+mHBXFDuyJzcUzlHzm3x+eV2mGBEPEoAGzHLVfo=;
	b=5YDiRMDwuuZoyOqkAbI+DfPYHpiO3dhriZO3TF5/0axcgP9Nkx15YImJwAEntju/QYmDTV
	AJCXcgS94im+eWIyqRtCHROk/U6OPHZSXVtib3o7fIo11LfW/ZdGXc0kpQTcZMh2vN88D9
	1citIz9ZoM8zpnwLCHpKLJ7WVjJqL24=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ePCUJoSt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791252757;
	b=or+Yylj68AGMoNyFt4xOaR+BwtP21li7dhnF9ncmbhWhF7o+evgVwUKgBQpa8v+G22IWnk
	cbajuA9ayOTnfl7mpHad2mjeBby+RaSVidjGC/LLN7uWNoCbfh9VLPEj/zeJ4vo7ndrJu2
	wPmMyhFhf9Kz9dtIJKvz5evpE66c/bo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791252756; x=1822788756;
  h=date:from:to:cc:subject:message-id;
  bh=L4L+95Hno67rlsWF9kSO3Qq0XDxe09ncDEhAsw/DzL0=;
  b=ePCUJoStO7LGrElxP6CqCbqw68HVyrQacbH1ArV4pzA5B+vwA9S0PlZR
   cvZ9eJSPhNiOXbCT2fReZtqe4QmxK1nDtKWLArepj/k5qx9ylLzlvq4H4
   rYzl+/EQahXYRshcS6lEmW6uuGuwtn011yIANi+OzsXMs1B9JT1eo4r7j
   hN5li/Ogmxa/qAiQeDZALKjhknchXYwsKJlCaAC7NzT/9ODxtV+gM+bj5
   iXzh7hdUiPonI9UOJaBicz0VPz54epPOlQCi64O5ib16T2ZPgIfFLsJy3
   j0U9GQtUwqboNn4bgkJc9MGFlqRubO8QMfEF7YbPhwMJX0oqhIFFN360O
   Q==;
X-CSE-ConnectionGUID: lyfCtwqbTjujq6pKvQzDHg==
X-CSE-MsgGUID: IIgEnZm6RLisj/mHy/rJmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="102604946"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102604946"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 19:12:35 -0700
X-CSE-ConnectionGUID: UPtqcd5fT5KIkuoO4N039A==
X-CSE-MsgGUID: Ix7G+qiIQg+bKck7O2dRjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="280246658"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 05 Oct 2026 19:12:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDufO-0000000013g-3pRC;
	Tue, 06 Oct 2026 02:12:30 +0000
Date: Tue, 06 Oct 2026 10:12:09 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0aaec43576cd41474a8e90c919631c0c9fc88417
Message-ID: <202610061005.1lWFUAXm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: A44AF80009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 3orymcxq336zto149zx3abs9beu3ihsr
X-HE-Tag: 1791252756-157668
X-HE-Meta: U2FsdGVkX1/JlGNhVRGWvpMgeIwmnkudZs34Y+nOWwrqLnJXVk2CHERrqlkvE9ojF/fQ+oryMZ92ALHc/R6WYmHadWGVDHIBG00nxUjUQx/pHFn4XEGIL2KdnXnE63mA8+qGbKhBux3wNl0btON7FX+9mY8NUJZpYcoSwtTl0c6i3OFW4zBPE6/aBBypKYknT3ygrIy2ChMyDnif+xBpgYfLviI+Y+N35lXRlizGl5ly+/f913Ud8Z15Qo76i8Hc9xU2zZv9haF8OPfWDcte4hiqcLyOJFznExGksrHntABzcIT2od0dIymQkmhfvk3GntZof19qLGcjCzVu1RFqUDZnehFwYbjVzb5YXF967HKq0ntqFiYDKGmxVjtstkhp46ckPQvWeCVPidsSwZ9oKhulNE1DJbw8DJ8YP8mEJ/vt2Pzmx8bGgogigDaxyUgM2Dt+sMQI6/R+qo7t4PG94U7w2nmsavXLaRhhX0heBHLf6I23FSpJUZgLMhlOAUAhaxvn7JplyFJb1sHeme4YCKI5Wp/Jj/M7RbPUxTm4ELcKKlB6xSKLj48L8P4KpzaKQU34SGLhm1JZR/AW7RPBCMM5ixUtqCH8zUxxvG6UIDOe4iNuqmngWKptj58TcRwyaI7yigRNBN4XKXcWb9hP4SWuelbQxyNqCUB5HJbHMM1gdpHhZdspQXkjnsUPRMTWT0Sg+eObZo/dDVDi2EfNQ3xmCxR53O8ja7V6Ax1aWJUPh/sAtmenWvACuP8K/2cq8MV4pUxl1o1pREOglH32Dfs6CP/7mZY0dXYCOhxLRjxFb7w82X6YHzTDxZdtZCYuH2EUCrZ4YIwUcPkAFg0QqGOuUpofsxyDKR6E7NUfSgTY2B5aZ4Qow6mZbjvckdjAzkiIBPZW7eB2bQVqF4BHmidtaEkaaTQxaxFJYHsOwVyibfOkM5CelUTeAeSSO9KjRHda+XupFAchIxafk3v
 Eo+hh7Ey
 vw/nRzhqlA7XFl/MqPvQKpn+PyB5Jjdy9b1oQlaADC18vEGSjiJWERKKxxqm0mNHQ/NLbTQYnZZTeJ41Q/W6B6LU+WaBntLdcNW6/cAlyQo9dg0pIujPCD33M2wqzQYI/JbFw9oFpC5RBzOuXt6tdVr7WzwJTQyunOGDiImcbLYQ8obd+x+GUEfIwfWXcRaler3sd6pDHV9GlJNMNt3mye1bBLKeIboL6bObM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0aaec43576cd41474a8e90c919631c0c9fc88417  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2106-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2100-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261005
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- m68k-randconfig-r2107-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2100-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20261005
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2200-20261005
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
`-- x86_64-randconfig-r2201-20261005
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 1081m

configs tested: 334
configs skipped: 5

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2106-20261005    gcc-16.1.0 cocci
alpha                randconfig-r2201-20261005    gcc-15.2.0 smatch
alpha                randconfig-r2302-20261005    clang-24   sparse
alpha                randconfig-r2303-20261005    clang-24   sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      haps_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261005    gcc-15.2.0
arc                   randconfig-1000-20261005    gcc-8.5.0
arc                   randconfig-1001-20261005    gcc-8.5.0
arc                   randconfig-1001-20261005    gcc-9.5.0
arc                  randconfig-r2306-20261005    gcc-9.5.0  sparse
arc                  randconfig-r2309-20261005    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                         multi_v7_defconfig    gcc-16.1.0
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20261005    gcc-8.5.0
arm                   randconfig-1001-20261005    gcc-11.5.0
arm                   randconfig-1001-20261005    gcc-8.5.0
arm                   randconfig-1002-20261005    gcc-10.5.0
arm                   randconfig-1002-20261005    gcc-8.5.0
arm                   randconfig-1003-20261005    clang-17
arm                   randconfig-1003-20261005    gcc-8.5.0
arm                          socfpga_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261005    gcc-8.5.0
arm64                 randconfig-1001-20261005    clang-21
arm64                 randconfig-1002-20261005    gcc-8.5.0
arm64                 randconfig-1003-20261005    clang-19
arm64                randconfig-r2103-20261005    gcc-14     cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261005    gcc-16.1.0
csky                  randconfig-1001-20261005    gcc-16.1.0
csky                 randconfig-r2103-20261005    gcc-15.2.0 cocci
csky                 randconfig-r2105-20261005    gcc-15.2.0 cocci
csky                 randconfig-r2105-20261005    gcc-8.5.0  cocci
csky                 randconfig-r2301-20261005    gcc-9.5.0  sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261005    clang-22
hexagon               randconfig-1000-20261005    gcc-16.1.0
hexagon               randconfig-1001-20261005    clang-24
hexagon               randconfig-1001-20261005    gcc-16.1.0
hexagon              randconfig-r2101-20261005    clang-22   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261005    clang-22
i386        buildonly-randconfig-1001-20261005    clang-22
i386        buildonly-randconfig-1002-20261005    gcc-13
i386        buildonly-randconfig-1003-20261005    gcc-14
i386        buildonly-randconfig-1004-20261005    clang-22
i386        buildonly-randconfig-1005-20261005    gcc-13
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261005    clang-22
i386                  randconfig-1000-20261005    gcc-13
i386                  randconfig-1001-20261005    clang-22
i386                  randconfig-1002-20261005    clang-22
i386                  randconfig-1003-20261005    clang-22
i386                  randconfig-1003-20261005    gcc-14
i386                  randconfig-1004-20261005    clang-22
i386                  randconfig-1005-20261005    clang-22
i386                  randconfig-1006-20261005    clang-22
i386                  randconfig-1007-20261005    clang-22
i386                  randconfig-1008-20261005    gcc-14
i386                  randconfig-1009-20261005    clang-22
i386                  randconfig-1010-20261005    gcc-12
i386                  randconfig-1011-20261005    clang-22
i386                  randconfig-1012-20261005    gcc-14
i386                  randconfig-1013-20261005    gcc-14
i386                  randconfig-2100-20261005    gcc-14     cocci
i386                  randconfig-2101-20261005    gcc-14     cocci
i386                  randconfig-2102-20261005    clang-22   cocci
i386                  randconfig-2102-20261005    gcc-14     cocci
i386                  randconfig-2103-20261005    clang-22   cocci
i386                  randconfig-2103-20261005    gcc-14     cocci
i386                  randconfig-2200-20261005    gcc-14     smatch
i386                  randconfig-2300-20261005    clang-22   sparse
i386                  randconfig-2300-20261005    gcc-14     sparse
i386                  randconfig-2301-20261005    clang-22   sparse
i386                  randconfig-2301-20261005    gcc-13     sparse
i386                  randconfig-2302-20261005    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261005    clang-18
loongarch             randconfig-1000-20261005    gcc-16.1.0
loongarch             randconfig-1001-20261005    gcc-16.1.0
loongarch            randconfig-r2100-20261005    clang-22   cocci
loongarch            randconfig-r2202-20261005    gcc-16.1.0 smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                         m5407c3_defconfig    gcc-16.1.0
m68k                 randconfig-r2104-20261005    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20261005    gcc-14.3.0 cocci
m68k                 randconfig-r2303-20261005    gcc-12.5.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2101-20261005    gcc-14     cocci
microblaze           randconfig-r2202-20261005    gcc-9.5.0  smatch
microblaze           randconfig-r2307-20261005    gcc-9.5.0  sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    clang-24
mips                            ip22_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r2107-20261005    gcc-8.5.0  cocci
mips                 randconfig-r2302-20261005    clang-17   sparse
mips                 randconfig-r2306-20261005    gcc-13.4.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261005    gcc-16.1.0
nios2                 randconfig-1000-20261005    gcc-8.5.0
nios2                 randconfig-1001-20261005    gcc-16.1.0
nios2                 randconfig-1001-20261005    gcc-9.5.0
nios2                randconfig-r2304-20261005    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                    de0_nano_defconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2107-20261005    gcc-14.3.0 cocci
openrisc             randconfig-r2300-20261005    gcc-9.5.0  sparse
openrisc             randconfig-r2307-20261005    gcc-15.2.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                 generic-64bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261005    gcc-8.5.0
parisc                randconfig-1001-20261005    gcc-15.2.0
parisc               randconfig-r2104-20261005    gcc-14.3.0 cocci
parisc               randconfig-r2200-20261005    gcc-16.1.0 smatch
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20261005    gcc-14.3.0
powerpc               randconfig-1001-20261005    clang-24
powerpc                      stx_gp3_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261005    clang-17
powerpc64             randconfig-1001-20261005    clang-19
powerpc64            randconfig-r2202-20261005    gcc-12.5.0 smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261005    gcc-8.5.0
riscv                 randconfig-1001-20261005    gcc-16.1.0
riscv                 randconfig-2000-20261005    gcc-13.4.0
riscv                 randconfig-2000-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-16.1.0
riscv                 randconfig-2001-20261005    gcc-8.5.0
riscv                randconfig-r2200-20261005    gcc-10.5.0 smatch
riscv                randconfig-r2305-20261005    clang-24   sparse
riscv                randconfig-r2308-20261005    gcc-9.5.0  sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261005    clang-17
s390                  randconfig-1001-20261005    gcc-16.1.0
s390                  randconfig-2000-20261005    gcc-13.4.0
s390                  randconfig-2000-20261005    gcc-16.1.0
s390                  randconfig-2001-20261005    clang-24
s390                  randconfig-2001-20261005    gcc-16.1.0
s390                 randconfig-r2102-20261005    gcc-8.5.0  cocci
s390                 randconfig-r2300-20261005    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261005    gcc-16.1.0
sh                    randconfig-1001-20261005    gcc-16.1.0
sh                    randconfig-2000-20261005    gcc-12.5.0
sh                    randconfig-2000-20261005    gcc-16.1.0
sh                    randconfig-2001-20261005    gcc-16.1.0
sh                   randconfig-r2100-20261005    gcc-12.5.0 cocci
sh                   randconfig-r2105-20261005    gcc-14.3.0 cocci
sh                   randconfig-r2301-20261005    clang-24   sparse
sh                   randconfig-r2304-20261005    clang-24   sparse
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261005    gcc-15.2.0
sparc                 randconfig-1001-20261005    gcc-13.4.0
sparc                 randconfig-2000-20261005    clang-17
sparc                 randconfig-2000-20261005    gcc-8.5.0
sparc                 randconfig-2001-20261005    clang-17
sparc                 randconfig-2001-20261005    gcc-16.1.0
sparc                randconfig-r2309-20261005    gcc-9.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261005    gcc-14.3.0
sparc64               randconfig-1001-20261005    gcc-12.5.0
sparc64               randconfig-2000-20261005    clang-17
sparc64               randconfig-2000-20261005    gcc-8.5.0
sparc64               randconfig-2001-20261005    clang-17
sparc64               randconfig-2001-20261005    gcc-15.2.0
sparc64              randconfig-r2103-20261005    clang-22   cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-16.1.0
um                    randconfig-1000-20261005    clang-24
um                    randconfig-1001-20261005    gcc-14
um                    randconfig-2000-20261005    clang-17
um                    randconfig-2000-20261005    clang-24
um                    randconfig-2001-20261005    clang-17
um                   randconfig-r2102-20261005    gcc-14     cocci
um                   randconfig-r2106-20261005    gcc-14.3.0 cocci
um                   randconfig-r2201-20261005    gcc-14     smatch
um                   randconfig-r2305-20261005    clang-24   sparse
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261005    gcc-13
x86_64      buildonly-randconfig-1001-20261005    clang-22
x86_64      buildonly-randconfig-1001-20261005    gcc-13
x86_64      buildonly-randconfig-1002-20261005    clang-22
x86_64      buildonly-randconfig-1002-20261005    gcc-13
x86_64      buildonly-randconfig-1003-20261005    clang-22
x86_64      buildonly-randconfig-1003-20261005    gcc-13
x86_64      buildonly-randconfig-1004-20261005    clang-22
x86_64      buildonly-randconfig-1004-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261005    gcc-13
x86_64      buildonly-randconfig-1005-20261005    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261005    gcc-14
x86_64                randconfig-1001-20261005    gcc-14
x86_64                randconfig-1002-20261005    gcc-14
x86_64                randconfig-1003-20261005    clang-22
x86_64                randconfig-1003-20261005    gcc-14
x86_64                randconfig-1004-20261005    clang-22
x86_64                randconfig-1004-20261005    gcc-14
x86_64                randconfig-1005-20261005    gcc-14
x86_64                randconfig-1006-20261005    gcc-14
x86_64                randconfig-1007-20261005    clang-22
x86_64                randconfig-1008-20261005    clang-22
x86_64                randconfig-1009-20261005    gcc-13
x86_64                randconfig-1010-20261005    gcc-14
x86_64                randconfig-1011-20261005    gcc-14
x86_64                randconfig-1012-20261005    gcc-12
x86_64                randconfig-1013-20261005    gcc-14
x86_64                randconfig-1014-20261005    gcc-12
x86_64                randconfig-1015-20261005    clang-22
x86_64                randconfig-1016-20261005    gcc-14
x86_64                randconfig-1017-20261005    gcc-14
x86_64                randconfig-2100-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    clang-22   cocci
x86_64                randconfig-2101-20261005    gcc-14     cocci
x86_64                randconfig-2102-20261005    clang-22   cocci
x86_64                randconfig-2102-20261005    gcc-14     cocci
x86_64                randconfig-2103-20261005    clang-22   cocci
x86_64                randconfig-2200-20261005    clang-22   smatch
x86_64                randconfig-2300-20261005    clang-22   sparse
x86_64                randconfig-2301-20261005    clang-22   sparse
x86_64                randconfig-2301-20261005    gcc-14     sparse
x86_64                randconfig-2302-20261005    clang-22   sparse
x86_64               randconfig-r2100-20261005    gcc-14     cocci
x86_64               randconfig-r2101-20261005    clang-22   cocci
x86_64               randconfig-r2102-20261005    clang-22   cocci
x86_64               randconfig-r2201-20261005    gcc-14     smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                            alldefconfig    gcc-16.1.0
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                 generic_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261005    gcc-13.4.0
xtensa                randconfig-1001-20261005    gcc-8.5.0
xtensa                randconfig-2000-20261005    clang-17
xtensa                randconfig-2000-20261005    gcc-8.5.0
xtensa                randconfig-2001-20261005    clang-17
xtensa                randconfig-2001-20261005    gcc-12.5.0
xtensa               randconfig-r2104-20261005    gcc-15.2.0 cocci
xtensa               randconfig-r2106-20261005    gcc-8.5.0  cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

