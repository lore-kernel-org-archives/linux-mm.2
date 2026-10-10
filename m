Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DCECA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA436B009D; Sat, 10 Oct 2026 17:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B8D6B009E; Sat, 10 Oct 2026 17:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4599B6B009F; Sat, 10 Oct 2026 17:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE8B6B009D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:13:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79737160609
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:13:25 +0000 (UTC)
X-FDA: 85307967570.24.8754742
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF26F40006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:13:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NxBQS4rx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666803;
	b=Rfwo1YhUWrVA0g5xmwUCR7W+d4vBNVMjrpoSXRphh5zdmwm5mnnkr2GH00WC1/Wu2GtPG6
	2H7iHNcdLJ67navBKrZo9+gYvGnw5m7TxqeaxSdBNFcxzKdk3qE8bdQgT4dtUVCb26sjjy
	G6Q1e7oEJwISrZK/TT/f7K2GFtLDG4U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NxBQS4rx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=FSQ1KaNfV4mQcPDLwabAusQEQfRxDjMpV1r7PoiffCA=;
	b=0d/7B1WabOKfiBbGPQ4XpUfKre4p+eFareUdADSlH1OaNSmGBdLLAtCtzBSpyjOl65VN5Z
	pjMWIWwq4v9mMmGCciyS3WkuL7eqLiMi/UJN4VJ5oyEHxDph51adkWmS1aascjd9CpdDIp
	6aqAfemAyT9CJJ2vlDZdfUAKJ13d4UQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791666804; x=1823202804;
  h=date:from:to:cc:subject:message-id;
  bh=P2rmUV31idzLIclPV+jHFjLk5/uGmFmi5f4bePKbfoQ=;
  b=NxBQS4rxH/JPvwxxbI9XapIrZjx4CuJJ8l9v868DXhdGohCJYLQOEwkG
   266Z2y5YlTcnfoN2IOzS8pQE4fdoNZ1wQRYzICytkxQQYI3V7Zjs4mvHA
   iLiEqy0h6okeXDqSB1eiJFIdBpF0fNi70rb61biZwLbJaLPQGxuAEeSaS
   3p1Bjc7Uv723gCyA4KgfnNAOir+55Bd0/veW0Cr3MuhvlUA3WCvxOeSNv
   YoTcH9pzQ0YOvnwiZVOoTBiMQqsGmFOoPb0RqYojocO6/YNXV0/qu/rtw
   +rKoqFBDPdnzUPu2kX51dbOOtqdy7UwgSP2NV8hHjEKTclH3FF0tPBDSn
   Q==;
X-CSE-ConnectionGUID: Ae6DDuo+SfW/i34L6+qXhw==
X-CSE-MsgGUID: w61Xhmh1SJWMEX/UftyAEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="435243"
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="435243"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2026 14:13:22 -0700
X-CSE-ConnectionGUID: FVvwz/7tRNWlpmSyM5nB7w==
X-CSE-MsgGUID: DX32KBMoT2+mOC2hGUV2cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,150,1787036400"; 
   d="scan'208";a="576658"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 10 Oct 2026 14:13:20 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFeNZ-00000000A5U-1I0r;
	Sat, 10 Oct 2026 21:13:17 +0000
Date: Sun, 11 Oct 2026 05:12:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
Message-ID: <202610110532.qAJHziS6-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: dswt7o3krzh4bfnzx1qn9pc5sf5tiyg5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF26F40006
X-HE-Tag: 1791666802-419420
X-HE-Meta: U2FsdGVkX1/e8clNjvOKHKD7C7VQDJpe6uZzf8m9oqC7bA3YaiGmPdr70yQafPQ3GapSH3tYbIujc2I/fwQr72Kb6LNbrTCtNWVsZbXVJdtpIOJjz5R/D5DhxRF0P3EVO5qmZSd51ChyozU/mwNledLit/gfn4jgmaX/Duk3q/9YjHFbn+MYmKqiaRKNusRM1LfR3hZXFr7/PVJWvK72Rg2nym0MQXBP4sd+zcgXnuF5xART9OqR9py737cKej5+69U2iX+WqgQyj3TunHab4tekpldJPM0YCi1UFNG1fbPjfDv06ONDP4+wX2KbDekwFo0fHhs3lpOBCZrJfQayAa/x1mw7yAfVNqyyz9+//Bcpb2yUyP11K8DFJkWLZObHDdn9OqUxu4ceGuGiqi4+9zqR1yGiMhHj+awMy1B66WWTV3bf5J3YxpGMFYNKVcRpaEvckrQvLMh+LdRt+U5XEuDEJfImou5gXKdTxoc9jQKGgENVDb9x9YdtabFstJvfOhqC9VNvPKSIYgnEEGc0A66ENHVpjo5H6qvzTWK3ZlYM8QcNW8SeEK/1W/rak+TaZx0SaeGPYIukCtpBJxqx6EG9fk3FQzqnYMUOTONLaBY4GczWlNsM+mb1MgmmzEMMVcKTay5YnCQUpFwUyFHoPIkUu8ahRd0l1Zxn2v1OFILfVFLXyib2Zykkc+XpvXZSs5eX+bzK43EXS6xxoxnbUBqky9RLcB77fi2kdU/Oy3ghPkO9+vXvqxYPk5fZJaORKHYIM2+soeT+gZzcps5l8hysd8g0jaB8aODM6cGXKQbvUviihmYk7R/WkkquGGb29mFdD4Vmdapp2p0JoiW3wqxZsNzN25m4/o5ktn1JVhDm0P2o6Z8wAo4wpFQfF+zQL0aitDqJBcRNEud5LZkv3/N432hMbXQ62yqWFQQh+STzWXjsJxcJyFy7L/icwuXRlttygSASr4oXMOeJT1l
 nkx7ZrsT
 pRk1+6JqbivAHfYWHU9EsnAfBi6uki2qnPdadP+m8kDr/QeOKhidPnjbCU37TZqYooppyXUO1Jtau3QHjmGO14oE+/AMgA+Gt0dEc0zEr5w7h1baMpfb1gc8tvG4FRMxmJSeX/CvaM901GzeyB6Ql81jGv/12pym0/2s20DNNS0wAUzVxi0es8mYDRF5FbnJ0qCwCrBz1lWT8SLhCZmgfrdMiujFdr15G45c/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4  sh: drop include/asm/sparsemem.h

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- loongarch-randconfig-r2102-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- powerpc-randconfig-r2202-20261009
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- sh-randconfig-r2106-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-allnoconfig
|-- x86_64-randconfig-2100-20261009
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- xtensa-randconfig-r2101-20261009
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 988m

configs tested: 336
configs skipped: 16

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2100-20261009    clang-18   cocci
alpha                randconfig-r2103-20261009    gcc-10.5.0 cocci
alpha                randconfig-r2104-20261009    gcc-9.5.0  cocci
alpha                randconfig-r2300-20261009    gcc-8.5.0  sparse
alpha                randconfig-r2305-20261009    gcc-8.5.0  sparse
alpha                randconfig-r2308-20261009    gcc-14     sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261010    gcc-15.2.0
arc                   randconfig-1001-20261010    gcc-13.4.0
arc                  randconfig-r2106-20261009    gcc-15.2.0 cocci
arc                  randconfig-r2107-20261009    gcc-9.5.0  cocci
arc                  randconfig-r2201-20261009    gcc-16.1.0 smatch
arc                  randconfig-r2202-20261009    gcc-8.5.0  smatch
arc                  randconfig-r2300-20261009    gcc-16.1.0 sparse
arc                  randconfig-r2302-20261009    gcc-11.5.0 sparse
arc                  randconfig-r2302-20261009    gcc-8.5.0  sparse
arc                  randconfig-r2302-20261009    gcc-9.5.0  sparse
arc                  randconfig-r2303-20261009    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           ep93xx_defconfig    clang-24
arm                            omap1_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261010    clang-24
arm                   randconfig-1001-20261010    gcc-15.2.0
arm                   randconfig-1002-20261010    gcc-8.5.0
arm                   randconfig-1003-20261010    gcc-8.5.0
arm                  randconfig-r2105-20261009    gcc-9.5.0  cocci
arm                  randconfig-r2106-20261009    clang-17   cocci
arm                  randconfig-r2107-20261009    gcc-15.2.0 cocci
arm                  randconfig-r2200-20261009    clang-24   smatch
arm                  randconfig-r2301-20261009    gcc-16.1.0 sparse
arm                  randconfig-r2302-20261009    gcc-10.5.0 sparse
arm                  randconfig-r2305-20261009    gcc-11.5.0 sparse
arm                  randconfig-r2306-20261009    clang-24   sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261010    gcc-8.5.0
arm64                 randconfig-1001-20261010    gcc-10.5.0
arm64                 randconfig-1002-20261010    clang-20
arm64                 randconfig-1003-20261010    clang-24
arm64                randconfig-r2104-20261009    gcc-9.5.0  cocci
arm64                randconfig-r2105-20261009    clang-24   cocci
arm64                randconfig-r2107-20261009    gcc-9.5.0  cocci
arm64                randconfig-r2202-20261009    gcc-10.5.0 smatch
arm64                randconfig-r2303-20261009    gcc-10.5.0 sparse
arm64                randconfig-r2305-20261009    gcc-10.5.0 sparse
arm64                randconfig-r2307-20261009    gcc-11.5.0 sparse
arm64                randconfig-r2309-20261009    gcc-11.5.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261010    gcc-16.1.0
csky                  randconfig-1001-20261010    gcc-13.4.0
csky                 randconfig-r2306-20261009    gcc-11.5.0 sparse
csky                 randconfig-r2307-20261009    clang-24   sparse
csky                 randconfig-r2308-20261009    clang-17   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261010    clang-24
hexagon               randconfig-1001-20261010    clang-17
hexagon              randconfig-r2103-20261009    clang-19   cocci
hexagon              randconfig-r2304-20261009    gcc-11.5.0 sparse
hexagon              randconfig-r2308-20261009    clang-24   sparse
hexagon              randconfig-r2309-20261009    gcc-14     sparse
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261010    gcc-13
i386        buildonly-randconfig-1001-20261010    clang-22
i386        buildonly-randconfig-1002-20261010    gcc-14
i386        buildonly-randconfig-1003-20261010    gcc-14
i386        buildonly-randconfig-1004-20261010    clang-22
i386        buildonly-randconfig-1005-20261010    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1007-20261010    gcc-14
i386                  randconfig-1008-20261010    gcc-14
i386                  randconfig-1009-20261010    gcc-14
i386                  randconfig-1010-20261010    gcc-14
i386                  randconfig-1011-20261010    clang-22
i386                  randconfig-1012-20261010    clang-22
i386                  randconfig-1013-20261010    clang-22
i386                  randconfig-2100-20261009    clang-22   cocci
i386                  randconfig-2101-20261009    clang-22   cocci
i386                  randconfig-2101-20261009    gcc-14     cocci
i386                  randconfig-2102-20261009    clang-22   cocci
i386                  randconfig-2102-20261009    gcc-14     cocci
i386                  randconfig-2103-20261009    clang-22   cocci
i386                  randconfig-2200-20261009    gcc-14     smatch
i386                  randconfig-2300-20261009    clang-22   sparse
i386                  randconfig-2301-20261009    clang-22   sparse
i386                  randconfig-2301-20261009    gcc-14     sparse
i386                  randconfig-2302-20261009    clang-22   sparse
i386                  randconfig-2302-20261009    gcc-14     sparse
i386                 randconfig-r2201-20261009    gcc-14     smatch
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261010    clang-24
loongarch             randconfig-1001-20261010    clang-18
loongarch            randconfig-r2102-20261009    clang-24   cocci
loongarch            randconfig-r2103-20261009    gcc-16.1.0 cocci
loongarch            randconfig-r2200-20261009    gcc-16.1.0 smatch
loongarch            randconfig-r2202-20261009    clang-18   smatch
loongarch            randconfig-r2303-20261009    gcc-11.5.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2100-20261009    gcc-16.1.0 cocci
m68k                 randconfig-r2100-20261009    gcc-8.5.0  cocci
m68k                 randconfig-r2304-20261009    gcc-8.5.0  sparse
m68k                 randconfig-r2307-20261009    gcc-9.5.0  sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2301-20261009    gcc-16.1.0 sparse
microblaze           randconfig-r2306-20261009    gcc-10.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                          db1xxx_defconfig    clang-24
mips                             gpr_defconfig    clang-24
mips                 randconfig-r2102-20261009    clang-19   cocci
mips                 randconfig-r2102-20261009    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261009    gcc-9.5.0  cocci
mips                 randconfig-r2304-20261009    gcc-16.1.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261010    gcc-11.5.0
nios2                 randconfig-1001-20261010    gcc-11.5.0
nios2                randconfig-r2101-20261009    gcc-8.5.0  cocci
nios2                randconfig-r2102-20261009    gcc-8.5.0  cocci
nios2                randconfig-r2300-20261009    gcc-10.5.0 sparse
nios2                randconfig-r2304-20261009    gcc-8.5.0  sparse
nios2                randconfig-r2306-20261009    gcc-9.5.0  sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2105-20261009    gcc-9.5.0  cocci
openrisc             randconfig-r2107-20261009    clang-17   cocci
openrisc             randconfig-r2107-20261009    clang-24   cocci
openrisc             randconfig-r2107-20261009    gcc-13.4.0 cocci
openrisc             randconfig-r2300-20261009    gcc-13.4.0 sparse
openrisc             randconfig-r2300-20261009    gcc-8.5.0  sparse
openrisc             randconfig-r2305-20261009    gcc-16.1.0 sparse
openrisc             randconfig-r2306-20261009    gcc-14     sparse
openrisc             randconfig-r2308-20261009    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261010    gcc-9.5.0
parisc                randconfig-1001-20261010    gcc-8.5.0
parisc               randconfig-r2101-20261009    clang-18   cocci
parisc               randconfig-r2103-20261009    gcc-8.5.0  cocci
parisc               randconfig-r2302-20261009    gcc-8.5.0  sparse
parisc               randconfig-r2305-20261009    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                  canyonlands_defconfig    clang-22
powerpc                       chrp32_defconfig    clang-24
powerpc               randconfig-1000-20261010    gcc-8.5.0
powerpc               randconfig-1001-20261010    clang-24
powerpc              randconfig-r2100-20261009    clang-19   cocci
powerpc              randconfig-r2103-20261009    clang-18   cocci
powerpc              randconfig-r2104-20261009    gcc-15.2.0 cocci
powerpc              randconfig-r2200-20261009    clang-17   smatch
powerpc              randconfig-r2202-20261009    clang-24   smatch
powerpc              randconfig-r2301-20261009    gcc-8.5.0  sparse
powerpc              randconfig-r2308-20261009    clang-24   sparse
powerpc64             randconfig-1000-20261010    clang-24
powerpc64             randconfig-1001-20261010    clang-24
powerpc64            randconfig-r2100-20261009    gcc-8.5.0  cocci
powerpc64            randconfig-r2101-20261009    gcc-16.1.0 cocci
powerpc64            randconfig-r2101-20261009    gcc-8.5.0  cocci
powerpc64            randconfig-r2200-20261009    clang-24   smatch
powerpc64            randconfig-r2301-20261009    gcc-8.5.0  sparse
powerpc64            randconfig-r2304-20261009    gcc-10.5.0 sparse
powerpc64            randconfig-r2309-20261009    gcc-9.5.0  sparse
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261010    clang-19
riscv                 randconfig-1001-20261010    clang-24
riscv                 randconfig-2000-20261009    gcc-13.4.0
riscv                 randconfig-2000-20261009    gcc-16.1.0
riscv                 randconfig-2001-20261009    gcc-15.2.0
riscv                 randconfig-2001-20261009    gcc-16.1.0
riscv                randconfig-r2102-20261009    gcc-8.5.0  cocci
riscv                randconfig-r2106-20261009    clang-24   cocci
riscv                randconfig-r2306-20261009    clang-17   sparse
riscv                randconfig-r2307-20261009    clang-17   sparse
riscv                randconfig-r2308-20261009    gcc-9.5.0  sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261010    clang-24
s390                  randconfig-1001-20261010    clang-24
s390                  randconfig-2000-20261009    clang-21
s390                  randconfig-2000-20261009    gcc-16.1.0
s390                  randconfig-2001-20261009    gcc-15.2.0
s390                  randconfig-2001-20261009    gcc-16.1.0
s390                 randconfig-r2104-20261009    clang-24   cocci
s390                 randconfig-r2105-20261009    gcc-15.2.0 cocci
s390                 randconfig-r2202-20261009    clang-18   smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261010    gcc-11.5.0
sh                    randconfig-1001-20261010    gcc-13.4.0
sh                    randconfig-2000-20261009    gcc-16.1.0
sh                    randconfig-2001-20261009    gcc-16.1.0
sh                   randconfig-r2106-20261009    gcc-12.5.0 cocci
sh                   randconfig-r2301-20261009    gcc-10.5.0 sparse
sh                   randconfig-r2303-20261009    gcc-12.5.0 sparse
sh                   randconfig-r2309-20261009    gcc-12.5.0 sparse
sh                            se7705_defconfig    gcc-16.1.0
sh                            se7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261010    gcc-8.5.0
sparc                 randconfig-1001-20261010    gcc-8.5.0
sparc                 randconfig-2000-20261009    clang-17
sparc                 randconfig-2000-20261009    gcc-8.5.0
sparc                 randconfig-2001-20261009    clang-17
sparc                 randconfig-2001-20261009    gcc-14.3.0
sparc                randconfig-r2100-20261009    gcc-8.5.0  cocci
sparc                randconfig-r2200-20261009    gcc-16.1.0 smatch
sparc                randconfig-r2201-20261009    gcc-11.5.0 smatch
sparc                randconfig-r2302-20261009    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261010    clang-24
sparc64               randconfig-1001-20261010    gcc-16.1.0
sparc64               randconfig-2000-20261009    clang-17
sparc64               randconfig-2000-20261009    gcc-9.5.0
sparc64               randconfig-2001-20261009    clang-17
sparc64               randconfig-2001-20261009    clang-24
sparc64              randconfig-r2101-20261009    clang-19   cocci
sparc64              randconfig-r2102-20261009    clang-18   cocci
sparc64              randconfig-r2103-20261009    gcc-8.5.0  cocci
sparc64              randconfig-r2104-20261009    clang-17   cocci
sparc64              randconfig-r2106-20261009    gcc-9.5.0  cocci
sparc64              randconfig-r2201-20261009    clang-24   smatch
sparc64              randconfig-r2305-20261009    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261010    gcc-14
um                    randconfig-1001-20261010    gcc-14
um                    randconfig-2000-20261009    clang-17
um                    randconfig-2000-20261009    clang-21
um                    randconfig-2001-20261009    clang-17
um                   randconfig-r2105-20261009    clang-17   cocci
um                   randconfig-r2200-20261009    gcc-14     smatch
um                   randconfig-r2201-20261009    clang-24   smatch
um                   randconfig-r2303-20261009    gcc-16.1.0 sparse
um                   randconfig-r2304-20261009    gcc-8.5.0  sparse
um                   randconfig-r2309-20261009    clang-24   sparse
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261010    gcc-14
x86_64      buildonly-randconfig-1001-20261010    gcc-13
x86_64      buildonly-randconfig-1002-20261010    clang-22
x86_64      buildonly-randconfig-1003-20261010    clang-22
x86_64      buildonly-randconfig-1004-20261010    gcc-13
x86_64      buildonly-randconfig-1005-20261010    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261010    gcc-14
x86_64                randconfig-1001-20261010    gcc-14
x86_64                randconfig-1002-20261010    clang-22
x86_64                randconfig-1003-20261010    clang-22
x86_64                randconfig-1004-20261010    gcc-14
x86_64                randconfig-1005-20261010    gcc-13
x86_64                randconfig-1006-20261010    clang-22
x86_64                randconfig-1007-20261010    clang-22
x86_64                randconfig-1008-20261010    clang-22
x86_64                randconfig-1009-20261010    clang-22
x86_64                randconfig-1010-20261010    clang-22
x86_64                randconfig-1011-20261010    gcc-14
x86_64                randconfig-1012-20261010    gcc-14
x86_64                randconfig-1013-20261010    gcc-14
x86_64                randconfig-1014-20261010    gcc-14
x86_64                randconfig-1015-20261010    gcc-14
x86_64                randconfig-1016-20261010    gcc-14
x86_64                randconfig-1017-20261010    clang-22
x86_64                randconfig-2100-20261009    clang-22   cocci
x86_64                randconfig-2101-20261009    clang-22   cocci
x86_64                randconfig-2102-20261009    clang-22   cocci
x86_64                randconfig-2103-20261009    clang-22   cocci
x86_64                randconfig-2103-20261009    gcc-13     cocci
x86_64                randconfig-2200-20261009    gcc-14     smatch
x86_64                randconfig-2300-20261009    clang-22   sparse
x86_64                randconfig-2300-20261009    gcc-14     sparse
x86_64                randconfig-2301-20261009    clang-22   sparse
x86_64                randconfig-2302-20261009    clang-22   sparse
x86_64               randconfig-r2104-20261009    clang-22   cocci
x86_64               randconfig-r2105-20261009    gcc-14     cocci
x86_64               randconfig-r2300-20261009    gcc-11.5.0 sparse
x86_64               randconfig-r2301-20261009    gcc-11.5.0 sparse
x86_64               randconfig-r2303-20261009    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261009    gcc-14     sparse
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
xtensa                randconfig-1000-20261010    gcc-9.5.0
xtensa                randconfig-1001-20261010    gcc-15.2.0
xtensa                randconfig-2000-20261009    clang-17
xtensa                randconfig-2000-20261009    gcc-10.5.0
xtensa                randconfig-2001-20261009    clang-17
xtensa                randconfig-2001-20261009    gcc-8.5.0
xtensa               randconfig-r2101-20261009    gcc-8.5.0  cocci
xtensa               randconfig-r2309-20261009    clang-17   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

