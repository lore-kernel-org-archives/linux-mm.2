Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF44CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 20:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E336B008A; Sat,  3 Oct 2026 16:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F696B008C; Sat,  3 Oct 2026 16:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34E16B0092; Sat,  3 Oct 2026 16:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDB76B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:27:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFCCC1A09F8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 20:27:27 +0000 (UTC)
X-FDA: 85282450134.20.5E8F8F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4D0F840007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 20:27:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="akWjui/2";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791059246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UoeJWn0fPhLXS98Z4O0efInfpWZVP65rNjBaaI7nopQ=;
	b=JR56N/a1cUhAoHoIr7QHjhqSAD1v3Mby1Hw3BBWgV5QLvFn0af/C8akNIXEnhFLt6k9GCk
	UlegxW6QJro+ZP85yMebCHICBQzquG93j0HQhzMUenoli+x1hv/HxMWVE0oYfUFhaOA3Br
	YLIZM4Yp5U4wxiNMbt+UtjBIJ2loW9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791059246;
	b=p765gsOQkuvX8QstvRWsxqd1+P6nJRUrFtpjHvjNxtQdqQEQKSi97R25870DJeRSXhW0Fc
	OB/68g91/OTcTsmXftMTZXwZqQqAE4SrnnTFE49smU59b7dNyciqmXV9+HPzkdxLw59K7G
	C3HMJ3bCAk0FrqAKUGMhbzCPPNGJVKs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="akWjui/2";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791059246; x=1822595246;
  h=date:from:to:cc:subject:message-id;
  bh=16zxGmPIU1hfFNrWB5BxvB+ujdVZP2QE4VeU7VlV3Sk=;
  b=akWjui/2SP9n2gWJacNuuciuAfTK8KD0NnRxnOZrEskEb3jynROeawhF
   i70kewbrmkj0j3v4AW0Co2mn5W2jiMxsGzrWRMdZyfTY7G0H4YPffO220
   eFRbyPBYGrUsQPhaQilhymGhY0rWWNQfcX+bjo6hsvgbf6Ob5vOvmrKQV
   dXfiWU1BZguABMWjbDhLCNCm6IvhLZTXyOnZSML9QWFwHK9Ci5o2adj6v
   4VsRPN6n6zPbZRKWNcwcqhu1UytshI3vFGxF234rXsjvktaQ6wnREaXvI
   n9xijXdcVvEnC6Uvfd1kvM3hEXFoBB7qSSY6meOD18nH2JzSoYdSDKzoX
   w==;
X-CSE-ConnectionGUID: VI6yOJxuT0eeT16xJifBgQ==
X-CSE-MsgGUID: M7wmDzh4QWKSf6YCMrvt8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="94662157"
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="94662157"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2026 13:27:24 -0700
X-CSE-ConnectionGUID: k7OaH/oJSPKSbjHwpwIwRA==
X-CSE-MsgGUID: +XaKuzL/Tc2jvLeb3Tt8xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="584340"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 03 Oct 2026 13:27:22 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xD6KF-00000000UBj-2Zqe;
	Sat, 03 Oct 2026 20:27:19 +0000
Date: Sun, 04 Oct 2026 04:27:12 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 763ad0211c7b587344f03bc4d1299810aeb736f4
Message-ID: <202610040408.3LHzXZUE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 3ys8uaaqwutsfr979ag58wxmryh7uuy1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D0F840007
X-HE-Tag: 1791059245-394201
X-HE-Meta: U2FsdGVkX19dcVIhL5LAauREoe2Y17PT+EgxiXBHRCvrniGqKP/U5FOrM5Fmnl0zXsWSXS2WAoHNYyYDC0zoa50og33089Z2S6M15Pm0vLK6Br0hr7+pIuleW5YpL9+eI+T5vw0wbhakb8QeMPbZyaJGSeU1OWWVYZH7jaQ+X19AknyErScmv/lIaE/WCfFrRi+jVkgkr6xxBrjLhOUvlrK5OBfvo2dLg45km0RklhyCSDWdKUcDaEDIVdacwgXzLqJgl4NkFECaRDYg+Nh6LgKRZk1oeNpeBAsEa/QgQ5AvhE/xbtMgazbAX6j1lAN+iMWWNxG4j8fyTCQuwdZaQs9N52jIF/pqnFInQNSpWsM475MZy3LzbdOe7v7pwMpwfjOjXwwCGIh4rZTXQymvOvdEB4zq3yFS/1WtFV1y7HFZgb8wrg3c/fnomaC+64SGu/r+48BAFVSihizAG81mAQFf8UvVFVwxAsi2Z0rbZshjBahsqLUSienQ1VApG//HJc1FiQTz34oSKiojEUS1ToauS6Aqmj1qgNfyn48ZfXhbQYWyVz4WXfALKJKiigzRuZraXATkygB/sVKtThmW+gFdM2fwTfQ+KPRYUx/IdfHzXqR1CYvG3PslfDMC4bN53KUyAWE5f/jrkk6dFzOaRu9Lhu66phLPHnB/PcTd9zjKh3bLzWZKXW1vl6lIj/MddLCUO3uHKunn774d85EiMR9yfEzOBFXbIECczHvMMvcxvKKytKFU7dbSgiQnOdp/qI8ysAnX0PRmUevskBP+TyStZhm5VOOoGdIQoZhCtJ720Qqf1eL0tBqGGoKV84HG7bEttNnMfrUcsETIiX3x+JGzf2jIJkVJnFsWrl1s1zlCU1KM9cn32OtCmQ6ZDQepUDgYpN0o5GTa8pfJIiM0QkgxUftWE/iI3v9HTReY0kEjCums+wOmzsFTe5FKnIj4DvNJkkGUGtZcckPEFks
 RBmtElTw
 lO7ZNpdmkbP+2lBbTX6v/hBxE1D3QqpAdxS8Qel8jId2PTB2CVS0cfPcf9dBvvZ5PodarwQi+tyw+dCYDM22bXZ7mqDpMJZVY87JGk2KTuaiBrlThS3HSe5yemViCpxTzk9N5i8J7G+2VkvXIg8o8Iksupz+burEAXEMF1k99zJEO2sc8PIsyPMTW0t2/AFUSn+M3l6lUfWcYo+giOmobb2r/DWIii0SKFs4C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 763ad0211c7b587344f03bc4d1299810aeb736f4  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2107-20261003
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- alpha-randconfig-r2200-20261003
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-2103-20261003
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- nios2-randconfig-r2202-20261003
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- powerpc-randconfig-r2201-20261003
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- powerpc64-randconfig-r2101-20261003
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2100-20261003
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2200-20261003
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 882m

configs tested: 200
configs skipped: 13

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2105-20261003    gcc-8.5.0  cocci
alpha                randconfig-r2107-20261003    gcc-8.5.0  cocci
alpha                randconfig-r2200-20261003    gcc-8.5.0  smatch
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                       axs103_smp_defconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261003    gcc-13.4.0
arc                   randconfig-1001-20261003    gcc-11.5.0
arc                  randconfig-r2100-20261003    gcc-8.5.0  cocci
arm                                allnoconfig    clang-17
arm                          at91_dt_defconfig    clang-17
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261003    clang-17
arm                   randconfig-1001-20261003    clang-24
arm                   randconfig-1002-20261003    gcc-11.5.0
arm                   randconfig-1003-20261003    gcc-8.5.0
arm                          wpcm450_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261003    gcc-10.5.0
arm64                 randconfig-1001-20261003    clang-17
arm64                 randconfig-1002-20261003    clang-17
arm64                 randconfig-1003-20261003    gcc-8.5.0
arm64                randconfig-r2106-20261003    clang-24   cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261003    gcc-9.5.0
csky                  randconfig-1001-20261003    gcc-11.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261003    clang-17
hexagon               randconfig-1001-20261003    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261003    gcc-14
i386        buildonly-randconfig-1001-20261003    clang-22
i386        buildonly-randconfig-1002-20261003    clang-22
i386        buildonly-randconfig-1003-20261003    clang-22
i386        buildonly-randconfig-1004-20261003    clang-22
i386        buildonly-randconfig-1005-20261003    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261003    clang-22
i386                  randconfig-1001-20261003    clang-22
i386                  randconfig-1002-20261003    clang-22
i386                  randconfig-1003-20261003    clang-22
i386                  randconfig-1004-20261003    clang-22
i386                  randconfig-1005-20261003    clang-22
i386                  randconfig-1006-20261003    gcc-14
i386                  randconfig-2100-20261003    gcc-14     cocci
i386                  randconfig-2101-20261003    clang-22   cocci
i386                  randconfig-2102-20261003    gcc-14     cocci
i386                  randconfig-2103-20261003    clang-22   cocci
i386                  randconfig-2200-20261003    gcc-14     smatch
i386                  randconfig-2300-20261003    clang-22   sparse
i386                  randconfig-2301-20261003    gcc-14     sparse
i386                  randconfig-2302-20261003    gcc-14     sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261003    gcc-14.3.0
loongarch             randconfig-1001-20261003    gcc-16.1.0
loongarch            randconfig-r2304-20261003    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                         stmark2_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                          db1xxx_defconfig    clang-24
mips                 randconfig-r2102-20261003    gcc-13.4.0 cocci
mips                 randconfig-r2305-20261003    gcc-8.5.0  sparse
mips                        rbtx49xx_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261003    gcc-9.5.0
nios2                 randconfig-1001-20261003    gcc-11.5.0
nios2                randconfig-r2202-20261003    gcc-8.5.0  smatch
nios2                randconfig-r2307-20261003    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261003    gcc-11.5.0
parisc                randconfig-1001-20261003    gcc-8.5.0
parisc               randconfig-r2103-20261003    gcc-8.5.0  cocci
parisc               randconfig-r2306-20261003    gcc-9.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20261003    gcc-12.5.0
powerpc               randconfig-1001-20261003    gcc-8.5.0
powerpc              randconfig-r2201-20261003    clang-17   smatch
powerpc              randconfig-r2309-20261003    clang-21   sparse
powerpc64             randconfig-1000-20261003    clang-24
powerpc64             randconfig-1001-20261003    clang-22
powerpc64            randconfig-r2101-20261003    gcc-13.4.0 cocci
riscv                              allnoconfig    gcc-16.1.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261003    clang-24
riscv                 randconfig-1001-20261003    clang-24
riscv                 randconfig-2000-20261003    clang-17
riscv                 randconfig-2001-20261003    gcc-9.5.0
riscv                randconfig-r2308-20261003    gcc-15.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261003    gcc-12.5.0
s390                  randconfig-1001-20261003    clang-24
s390                  randconfig-2000-20261003    clang-24
s390                  randconfig-2001-20261003    gcc-13.4.0
s390                 randconfig-r2104-20261003    clang-17   cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261003    gcc-9.5.0
sh                    randconfig-1001-20261003    gcc-15.2.0
sh                    randconfig-2000-20261003    gcc-16.1.0
sh                    randconfig-2001-20261003    gcc-16.1.0
sh                   randconfig-r2302-20261003    gcc-12.5.0 sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261003    gcc-8.5.0
sparc                 randconfig-1001-20261003    gcc-8.5.0
sparc                 randconfig-2000-20261003    gcc-16.1.0
sparc                 randconfig-2001-20261003    gcc-16.1.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261003    gcc-16.1.0
sparc64               randconfig-1001-20261003    clang-24
sparc64               randconfig-2000-20261003    gcc-8.5.0
sparc64               randconfig-2001-20261003    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261003    clang-17
um                    randconfig-1001-20261003    clang-22
um                    randconfig-2000-20261003    clang-24
um                    randconfig-2001-20261003    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261003    clang-22
x86_64      buildonly-randconfig-1001-20261003    gcc-14
x86_64      buildonly-randconfig-1002-20261003    clang-22
x86_64      buildonly-randconfig-1003-20261003    gcc-14
x86_64      buildonly-randconfig-1004-20261003    clang-22
x86_64      buildonly-randconfig-1005-20261003    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261003    clang-22
x86_64                randconfig-1001-20261003    clang-22
x86_64                randconfig-1002-20261003    clang-22
x86_64                randconfig-1003-20261003    gcc-13
x86_64                randconfig-1004-20261003    clang-22
x86_64                randconfig-1005-20261003    clang-22
x86_64                randconfig-1006-20261003    gcc-14
x86_64                randconfig-1007-20261003    gcc-14
x86_64                randconfig-1008-20261003    gcc-14
x86_64                randconfig-1009-20261003    clang-22
x86_64                randconfig-1010-20261003    gcc-14
x86_64                randconfig-1011-20261003    clang-22
x86_64                randconfig-1012-20261003    clang-22
x86_64                randconfig-1013-20261003    gcc-12
x86_64                randconfig-1014-20261003    gcc-14
x86_64                randconfig-1015-20261003    gcc-14
x86_64                randconfig-1016-20261003    clang-22
x86_64                randconfig-1017-20261003    gcc-14
x86_64                randconfig-2100-20261003    clang-22   cocci
x86_64                randconfig-2101-20261003    clang-22   cocci
x86_64                randconfig-2102-20261003    gcc-14     cocci
x86_64                randconfig-2103-20261003    gcc-13     cocci
x86_64                randconfig-2200-20261003    gcc-14     smatch
x86_64                randconfig-2300-20261003    gcc-14     sparse
x86_64                randconfig-2301-20261003    gcc-14     sparse
x86_64                randconfig-2302-20261003    clang-22   sparse
x86_64               randconfig-r2300-20261003    clang-22   sparse
x86_64               randconfig-r2301-20261003    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                   nommu_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261003    gcc-15.2.0
xtensa                randconfig-1001-20261003    gcc-9.5.0
xtensa                randconfig-2000-20261003    gcc-8.5.0
xtensa                randconfig-2001-20261003    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

