Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D83ECA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CF46B0088; Tue, 29 Sep 2026 14:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042E06B008A; Tue, 29 Sep 2026 14:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B306B008C; Tue, 29 Sep 2026 14:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD02C6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:21:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34CEA1C3472
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:21:09 +0000 (UTC)
X-FDA: 85267616658.25.6CBA55E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id B513B120004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:21:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFi2h+Jj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790706067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9n0hzC0x8+atkCkPjmB/mDhSBqzGUWw3Sm2TyrM2wQg=;
	b=K3YTnG3Qu648H5AuEUwLWAvApQ7nEpEFWQ8GZ0pI9U7tTdrJEHSVgvR9oG071fbB563eqH
	nyRQD+QMeWmrdnRuzDhEKgGXj2KDeoquStKtewXgKQZ880F3S09HEMv6qaCLpdCQmokhhd
	3fMe5j6Iv2TPPBghakwp8wLqLQ4Z1ys=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFi2h+Jj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790706067;
	b=yOboHq2HOrCuP3yGFg5NfoOFmdabNaa1i+06j5uaLG+aA7UmqMeYYfQt5UT6j4K8hbSs0P
	lJ8gXWTveAKZbRnjAba7LveVPLKtRqIYqkUxuglayR2sZUidL/1jhNQFRf2hfDThBjnWqC
	spr2aa8FKetrxJZpLATfKEKj0f5QORE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790706067; x=1822242067;
  h=date:from:to:cc:subject:message-id;
  bh=5Zhe6pSCykayvbP3WxtEWQGiqMdJ6/ZBjKyH03H2vJs=;
  b=kFi2h+JjRc43GDU+PMq4fg9TjM23t9CEREN8/mxWgPt2XQsD+4Cebe/u
   /U8ONGwe4ZehSplhyjYaInq3CjTn0h6CwhoZJ2CT89S9wCewWoO1KTA+R
   JNCYhqRdraNWE7+IJ4BbaGrAniGgUV3SY5Bl08V3iASDYlLuMh4xxaaj5
   8Yk2qx4EbtTDxtbj8yZJ1YghUcb8JxXqAnbo6EWBB6yYInOTUkv1YovC6
   BeOFDbaHuEE5i+pbVW4uwju2CLuGqG+InplGT+vhdP6XfmlpDR34Jxlzr
   8gPc47tJ1FWr7FkHk7RnrXCv1FhGJ1PE8FpnoHgA0Vg8PaTgwuzjFZujR
   w==;
X-CSE-ConnectionGUID: s1lkhu/PTpa4gP866rGnxg==
X-CSE-MsgGUID: q7qWUz+1R4OOaL30edNo+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90653443"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90653443"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 11:21:06 -0700
X-CSE-ConnectionGUID: L+kQrC2yQPusIgmQqrS7pQ==
X-CSE-MsgGUID: CTTgUhqrSL2N2j3EAGeF2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="313386737"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 Sep 2026 11:21:04 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBcRp-00000000Pf3-2dBD;
	Tue, 29 Sep 2026 18:21:01 +0000
Date: Wed, 30 Sep 2026 02:20:46 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 2ddb90ee544ae97215afc4698dc223293997cc43
Message-ID: <202609300242.tMg440iL-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: cm8y8gcpbxzp84t59mkr9p7gtgc93q3u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B513B120004
X-HE-Tag: 1790706066-868745
X-HE-Meta: U2FsdGVkX18oQJSj8NtIoyxPxGMLW2wZMa7s9JJJ7QREn0lBdQ3ZpQmdFYlG6PnpITKyD2cWB1Xa/M/lWo/yx5IeVH8NU9iC/j+okw6Yrb+/vi3Jp89+k1Wv7T9w9Uh93/N4YwvwqHB6lzv4v6uM8bzpA5sHWXOzLhcyvNP4tLG6JbKQvdBKVYw4pfWRQufg7KueyfWddoeAxSO0k43hZ1lAY5o84SES5TTypCnu/e2Tihv2kBK7Y6hJJ4j8BMEjI0QWvHtGhYESoRvWOcJ5OnRX/JZhZCOeYFUV2nkImpUs5pwIUqctG78jlDY6Nm0c+ddm7D6mzVl8TlTSmGrfmP048hY6AuEZNkrNi9ZX1FL9fcRSoOigX1CgkMcwpmxD4kWt4ejSSmV3PTbLAS3RFORA7UeslJ+nM9G+NpyrhRYrybgqZMFHoIfGfcUMjdFKPOjROSDU0w207L/wksT+9pqZ2joNqHyHaQcr8QAefal7xkIOTSWi7bXuPDXjh4Wjjq7EquhL6aU1IcVyjPtPzFru1LsKDl+VHPYGJAVIlN2Z1A+JO1FSDgOicCR0su84uTfWPcpZ/lLioKxWT8bZwfG8CQuOESTKrwnYPUNe5EAoiZ+cA8sLYGYDKNUHw4GT6gtYUkH0EfyvDFNXa41dA8Jb9O2M4n9anBQwEx510Wzf0RhQqPjHH6q8yr7RtPGf+k/ohYBwxSB5V/H3AR/+ZBOdT+m8SmAFfFiMO6q+DdHuH95RrX5fkZOo9M6y2IXI9pAU3oJxLXV42ZwSR/TgtLQfoY0SidVirq20eyn4qFthArr86DzKMgkn8AocMStc+tQaQZAaYyii4YIy/Zn3TFdjzVyY2TYclFo0ZU7HNcl6U4FoLhAwOStlGS+KRlPMDKbAyDq1sc5mHTkJdNt0Np5FulC+/78r4UB6GunhMl2Vglv/J6w7C5IcN48KSiaCnyTaoqCmcw60QQnNVJw
 AkIxpSGV
 k8RVTrjiuAMewt7o3lamImLpHHObiLzwd1yDOu1IvqISPxzgvhLEe5d4FjhJ8KyXBmSUlIhi0zIsTVJ0Uc/qXhU2tk6lsx8hHG+YbJg+1e7BGCnDPdCXxmJBhbnFQmSSeHymnUeSjZszygQBEVJaNKM7CUHmnbSU41iLju+cGui1s9JyHc+I86ZVJU0J4mWnL3Z4m94nXcO8xtHivZwnCsdwqlpYsTSeePgZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 2ddb90ee544ae97215afc4698dc223293997cc43  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2100-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- hexagon-randconfig-r2105-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2102-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20260929
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- m68k-randconfig-r2102-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2103-20260929
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2200-20260929
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 963m

configs tested: 268
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2100-20260929    gcc-10.5.0 cocci
alpha                randconfig-r2107-20260929    gcc-15.2.0 cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                      nsimosci_hs_defconfig    gcc-16.1.0
arc                   randconfig-1000-20260929    gcc-13.4.0
arc                   randconfig-1001-20260929    gcc-8.5.0
arc                  randconfig-r2103-20260929    clang-22   cocci
arc                  randconfig-r2202-20260929    gcc-16.1.0 smatch
arc                  randconfig-r2309-20260929    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           gemini_defconfig    clang-24
arm                   randconfig-1000-20260929    gcc-11.5.0
arm                   randconfig-1001-20260929    clang-17
arm                   randconfig-1002-20260929    clang-24
arm                   randconfig-1003-20260929    gcc-10.5.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260929    clang-24
arm64                 randconfig-1001-20260929    clang-24
arm64                 randconfig-1002-20260929    clang-24
arm64                 randconfig-1003-20260929    clang-22
arm64                randconfig-r2308-20260929    clang-17   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260929    gcc-16.1.0
csky                  randconfig-1001-20260929    gcc-15.2.0
csky                 randconfig-r2105-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2107-20260929    gcc-16.1.0 cocci
csky                 randconfig-r2309-20260929    gcc-11.5.0 sparse
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260929    clang-24
hexagon               randconfig-1001-20260929    clang-17
hexagon              randconfig-r2105-20260929    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260929    clang-22
i386        buildonly-randconfig-1001-20260929    gcc-14
i386        buildonly-randconfig-1002-20260929    gcc-14
i386        buildonly-randconfig-1003-20260929    clang-22
i386        buildonly-randconfig-1004-20260929    clang-22
i386        buildonly-randconfig-1005-20260929    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260929    clang-22
i386                  randconfig-1001-20260929    clang-22
i386                  randconfig-1002-20260929    gcc-13
i386                  randconfig-1003-20260929    gcc-14
i386                  randconfig-1004-20260929    gcc-14
i386                  randconfig-1005-20260929    clang-22
i386                  randconfig-1006-20260929    clang-22
i386                  randconfig-1007-20260929    gcc-14
i386                  randconfig-1008-20260929    gcc-14
i386                  randconfig-1009-20260929    gcc-14
i386                  randconfig-1010-20260929    gcc-14
i386                  randconfig-1011-20260929    gcc-14
i386                  randconfig-1012-20260929    gcc-14
i386                  randconfig-1013-20260929    gcc-14
i386                  randconfig-2100-20260929    clang-22   cocci
i386                  randconfig-2100-20260929    gcc-13     cocci
i386                  randconfig-2101-20260929    clang-22   cocci
i386                  randconfig-2102-20260929    clang-22   cocci
i386                  randconfig-2103-20260929    clang-22   cocci
i386                  randconfig-2200-20260929    gcc-14     smatch
i386                  randconfig-2300-20260929    clang-22   sparse
i386                  randconfig-2301-20260929    gcc-14     sparse
i386                 randconfig-r2106-20260929    gcc-16.1.0 cocci
i386                 randconfig-r2305-20260929    gcc-14     sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260929    clang-24
loongarch             randconfig-1001-20260929    clang-24
loongarch            randconfig-r2101-20260929    gcc-16.1.0 cocci
loongarch            randconfig-r2102-20260929    clang-24   cocci
loongarch            randconfig-r2107-20260929    clang-22   cocci
loongarch            randconfig-r2201-20260929    clang-24   smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2102-20260929    gcc-8.5.0  cocci
m68k                 randconfig-r2104-20260929    clang-22   cocci
m68k                 randconfig-r2105-20260929    clang-22   cocci
m68k                 randconfig-r2304-20260929    gcc-16.1.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2303-20260929    gcc-14.3.0 sparse
microblaze           randconfig-r2306-20260929    clang-24   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2100-20260929    clang-22   cocci
mips                 randconfig-r2103-20260929    clang-24   cocci
mips                 randconfig-r2106-20260929    gcc-13.4.0 cocci
mips                 randconfig-r2107-20260929    gcc-11.5.0 cocci
mips                 randconfig-r2200-20260929    gcc-12.5.0 smatch
mips                 randconfig-r2301-20260929    gcc-9.5.0  sparse
mips                         vocore2_defconfig    clang-20
nios2                          10m50_defconfig    gcc-11.5.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260929    gcc-8.5.0
nios2                 randconfig-1001-20260929    gcc-8.5.0
nios2                randconfig-r2200-20260929    gcc-11.5.0 smatch
nios2                randconfig-r2306-20260929    gcc-11.5.0 sparse
nios2                randconfig-r2307-20260929    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260929    gcc-15.2.0
parisc                randconfig-1001-20260929    gcc-13.4.0
parisc               randconfig-r2200-20260929    gcc-14.3.0 smatch
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc                        ppc64_defconfig    clang-17
powerpc               randconfig-1000-20260929    clang-17
powerpc               randconfig-1001-20260929    gcc-14.3.0
powerpc              randconfig-r2104-20260929    gcc-16.1.0 cocci
powerpc              randconfig-r2202-20260929    clang-24   smatch
powerpc              randconfig-r2300-20260929    clang-24   sparse
powerpc64             randconfig-1000-20260929    gcc-8.5.0
powerpc64             randconfig-1001-20260929    gcc-12.5.0
powerpc64            randconfig-r2104-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20260929    gcc-15.2.0 cocci
powerpc64            randconfig-r2307-20260929    clang-24   sparse
powerpc64            randconfig-r2309-20260929    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260929    clang-17
riscv                 randconfig-1001-20260929    clang-24
riscv                 randconfig-2000-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260929    gcc-9.5.0
riscv                randconfig-r2100-20260929    clang-24   cocci
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260929    clang-17
s390                  randconfig-1001-20260929    gcc-10.5.0
s390                  randconfig-2000-20260929    clang-24
s390                  randconfig-2000-20260929    gcc-11.5.0
s390                  randconfig-2001-20260929    gcc-11.5.0
s390                  randconfig-2001-20260929    gcc-8.5.0
s390                 randconfig-r2103-20260929    gcc-9.5.0  cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260929    gcc-9.5.0
sh                    randconfig-1001-20260929    gcc-16.1.0
sh                    randconfig-2000-20260929    gcc-11.5.0
sh                    randconfig-2000-20260929    gcc-14.3.0
sh                    randconfig-2001-20260929    gcc-11.5.0
sh                    randconfig-2001-20260929    gcc-16.1.0
sh                   randconfig-r2302-20260929    gcc-16.1.0 sparse
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260929    gcc-8.5.0
sparc                 randconfig-1001-20260929    gcc-15.2.0
sparc                 randconfig-2000-20260929    gcc-12.5.0
sparc                 randconfig-2000-20260929    gcc-14.3.0
sparc                 randconfig-2001-20260929    gcc-12.5.0
sparc                randconfig-r2306-20260929    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260929    clang-20
sparc64               randconfig-1001-20260929    clang-24
sparc64               randconfig-2000-20260929    gcc-12.5.0
sparc64               randconfig-2000-20260929    gcc-8.5.0
sparc64               randconfig-2001-20260929    clang-24
sparc64               randconfig-2001-20260929    gcc-12.5.0
sparc64              randconfig-r2104-20260929    clang-24   cocci
sparc64              randconfig-r2307-20260929    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260929    gcc-14
um                    randconfig-1001-20260929    gcc-14
um                    randconfig-2000-20260929    clang-17
um                    randconfig-2000-20260929    gcc-12.5.0
um                    randconfig-2001-20260929    gcc-12.5.0
um                    randconfig-2001-20260929    gcc-14
um                   randconfig-r2201-20260929    gcc-14     smatch
um                   randconfig-r2202-20260929    clang-24   smatch
um                   randconfig-r2308-20260929    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260929    clang-22
x86_64      buildonly-randconfig-1001-20260929    clang-22
x86_64      buildonly-randconfig-1002-20260929    gcc-14
x86_64      buildonly-randconfig-1003-20260929    gcc-14
x86_64      buildonly-randconfig-1004-20260929    clang-22
x86_64      buildonly-randconfig-1005-20260929    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260929    gcc-13
x86_64                randconfig-1001-20260929    clang-22
x86_64                randconfig-1002-20260929    gcc-14
x86_64                randconfig-1003-20260929    clang-22
x86_64                randconfig-1004-20260929    clang-22
x86_64                randconfig-1005-20260929    clang-22
x86_64                randconfig-1006-20260929    clang-22
x86_64                randconfig-1007-20260929    gcc-13
x86_64                randconfig-1008-20260929    clang-22
x86_64                randconfig-1009-20260929    gcc-13
x86_64                randconfig-1010-20260929    gcc-14
x86_64                randconfig-1011-20260929    gcc-14
x86_64                randconfig-1012-20260929    gcc-14
x86_64                randconfig-1013-20260929    gcc-14
x86_64                randconfig-1014-20260929    clang-22
x86_64                randconfig-1015-20260929    gcc-14
x86_64                randconfig-1016-20260929    gcc-14
x86_64                randconfig-1017-20260929    clang-22
x86_64                randconfig-2100-20260929    clang-22   cocci
x86_64                randconfig-2101-20260929    clang-22   cocci
x86_64                randconfig-2101-20260929    gcc-14     cocci
x86_64                randconfig-2102-20260929    clang-22   cocci
x86_64                randconfig-2102-20260929    gcc-14     cocci
x86_64                randconfig-2103-20260929    clang-22   cocci
x86_64                randconfig-2200-20260929    clang-22   smatch
x86_64                randconfig-2300-20260929    clang-22   sparse
x86_64                randconfig-2301-20260929    clang-22   sparse
x86_64                randconfig-2302-20260929    clang-22   sparse
x86_64               randconfig-r2101-20260929    clang-24   cocci
x86_64               randconfig-r2102-20260929    clang-22   cocci
x86_64               randconfig-r2106-20260929    clang-22   cocci
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260929    gcc-15.2.0
xtensa                randconfig-1001-20260929    gcc-9.5.0
xtensa                randconfig-2000-20260929    gcc-12.5.0
xtensa                randconfig-2000-20260929    gcc-16.1.0
xtensa                randconfig-2001-20260929    gcc-10.5.0
xtensa                randconfig-2001-20260929    gcc-12.5.0
xtensa               randconfig-r2101-20260929    clang-22   cocci
xtensa               randconfig-r2105-20260929    gcc-15.2.0 cocci
xtensa               randconfig-r2308-20260929    gcc-11.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

