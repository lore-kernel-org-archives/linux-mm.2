Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A332ACA5FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928026B0088; Wed, 30 Sep 2026 09:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D81B6B008A; Wed, 30 Sep 2026 09:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDC96B008C; Wed, 30 Sep 2026 09:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 545496B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:48:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E051AC0786
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:48:49 +0000 (UTC)
X-FDA: 85270559178.03.478C0DF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id A22BB140002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:48:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fPaOVRUu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790776128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=je1Y/KoEXfwXaCqRzHZTQOGDYPg2M23Y1iANCOb6oOI=;
	b=qO7AFQ20msaKqYlwrf0PbsEr87t7I7hqREDQXnL/8RVN/0OnCaRBVS3tN5Nw+QNKIsN4K7
	mQluuE3oauFMRSxcIcH+uSYzG/+wEcd/V5oJrziLwUdRsy/EOWo+B0Vs/pzZkpBUWNgoI4
	WBMvBfBzB3WiZNZGMscKexx7NwqYyqY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fPaOVRUu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790776128;
	b=vF9yaRlkMfD7XSoY++T+bVydMXVPcefb12zVtpg5RTh0A5R+YIRMbSNouLzm8pvEorm3Fe
	XjwQydsv25vKDi6dxdHo0JJN+QpNpSumhr4QTVPTwlEyDsypfCTlRc4O8mjyCZO2U/fysF
	+1C3IuhRtEibNB/qkig10aZK8cLPWDw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790776127; x=1822312127;
  h=date:from:to:cc:subject:message-id;
  bh=HOoNrgvKa7oKYIvpBZnfkmrduUhQxIQVQFa+l8T9z9g=;
  b=fPaOVRUu4QVj1NPwDVkW6ift5w3t9xRQWChILcNz2bHPR45if8qeYI7Y
   03/xDzvnP0hsIo9ZMo8QL3ov7bqqlQ9ODcncgiDsviTpIydd4U/wyBn4y
   ZQq5FcYD+6/E4OCS+pYbYhAGxV3MzC+Dso+WWs1SI+wtaBz+rfcIxKgqt
   Cxsa4IOc12cnPx6EznQaAgd1f4XXAtkyXTe35MrdYE+H30yblgHCQeQmX
   YwTnDnh0ggpwlq+UbC32r1dyNuzahSiWafx8oEh0F6k4OzBr1/RfsFXfE
   nGVY6NcGzSB+AZ+0a1Fj2xM9fVZ3xCzk0g9isJdDf7Loi/v8HYHSE41Hr
   g==;
X-CSE-ConnectionGUID: f6WgliySQqi2K0U7JITXhQ==
X-CSE-MsgGUID: 767wSYawR96g0oZalC3xdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102886740"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102886740"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 06:48:45 -0700
X-CSE-ConnectionGUID: 8zLDpdhTRnOxM8+17QIJ0w==
X-CSE-MsgGUID: 1nF8cm+wS1qDWkJ8I1Mnxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="303629815"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Sep 2026 06:48:43 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBufo-00000000Qgj-3nee;
	Wed, 30 Sep 2026 13:48:40 +0000
Date: Wed, 30 Sep 2026 21:48:08 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 4ae0714adaa1dac4639aa0b8001bce8b03343172
Message-ID: <202609302103.vFs7BLys-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 1od91kkbfq9xc6kfjapczpc6chs43u1q
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A22BB140002
X-HE-Tag: 1790776126-987916
X-HE-Meta: U2FsdGVkX19GruelzZWSeuBu5mwCuqqvtf5dyz9Oum+mzzCC6Vb1yyo/X3JvjIGH5HRD3NjlcogUjWs5Aeb0/yQqmDVU9ng+N7pdcQgeJ22dGRrumNeeTvBnslFauUK2ZgKfSn23PC+z+vjvGuFn97W4tYLrKz1vnBcll1uj33okBE9q1yMTKzGnVESKB+kCvU7Bis++FT2Bl+wYuWSrOSzb0Z1SUZ5+yX1RYJP+gJIeZ71DI9mhTsV4nkHjWy5Be4OdP86Nw4OCAnAzmRxh7tVauzg13rpxlHLKyAGz7XZu+y7Jc2d8xl3OhtBU9oim47bKRbQotmCeOk7XRzBZbBVm7wZ/yf+Fc+TyF3tlWqZzFsJ1MI8FKFQDVV/fuevXC5c2rHqpu65S6uAsW8tmq63mZe9zDggCRY7oOztDSh6wOaLO770a04uJA8QVVZKmMw43e0qWFJfMtP6krbLOuDaM++ze9Cspgyi5+jB4jW3yD1fCKj6MQuAGClbSOJfu72GIZAnHXbKrD063gOoPgLHZ5WDndlnCdZPgxbWKtK4RsFt/5n05vQG6v7GajNbYlMO07VIN+Uu5L6ldWVmEFa6LzSdpf73bNZVJ/eXHZUKjZ0mTnHKK5IGCkdzspOoR2ovSuSCRSdKt9R+mOxC4BEoW/vObmYiur883nKw7ThdSaMr6tqWVoX2pfoQGQeC3E2mzKOLOy2of87FX0Anmhyqn1aO0XZQjZ0IQ5c2RC1401aO6tpiVr/ciFEmd0Or8mIeiGlYiIpg48RPhd5Y2A3BKgh2891i8gtwQz4aGjTxxUUcYypmNw60+jGRAbauvquJWbicLmXaMIBEDnrW2CFi+7eovKwVZb4j378E7b9zhi0AmjsHOknlp/AWr4p9IzEgRoRM/w3i8A28IVosuJTpaQjcENMn5aZBNJOCGI2hNA0AnwoyzqEBhHZL3/tX0Nlp7pfuuNIZy4x9rBzb
 II8YLcbs
 58l8uzXYHbIQ6Pp+KTBDYBQ168aGIqH++rV83mN5OhTGc2GkO3IWMW1jAsKcZsj8X9Iel9MRYoN89GS3mVuJnLTvGMtZbohq/fyTMJeDWb0/a11H+g1g0hR/S4w76lBEMQCuDQzHKlLBDEWu/D8tMAYOAMsVWk/jQTR9QtvTGo9YplItRM73XmzHSSWR3VcOn6lCWgSw8miv64m22c0/Vf240nKcggRAxPJr0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4ae0714adaa1dac4639aa0b8001bce8b03343172  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r2102-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2102-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20260930
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-r2106-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- m68k-randconfig-r2100-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- m68k-randconfig-r2107-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2100-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20260930
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2102-20260930
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 912m

configs tested: 261
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2107-20260930    gcc-8.5.0  cocci
alpha                randconfig-r2304-20260930    gcc-12.5.0 sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260930    gcc-13.4.0
arc                   randconfig-1001-20260930    gcc-11.5.0
arc                  randconfig-r2201-20260930    gcc-10.5.0 smatch
arc                  randconfig-r2202-20260930    gcc-16.1.0 smatch
arc                  randconfig-r2301-20260930    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                          mv78xx0_defconfig    clang-24
arm                   randconfig-1000-20260930    clang-24
arm                   randconfig-1001-20260930    gcc-10.5.0
arm                   randconfig-1002-20260930    clang-17
arm                   randconfig-1003-20260930    gcc-13.4.0
arm                  randconfig-r2101-20260930    clang-24   cocci
arm                  randconfig-r2102-20260930    clang-24   cocci
arm                  randconfig-r2200-20260930    clang-17   smatch
arm                          vf610m4_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260930    clang-24
arm64                 randconfig-1001-20260930    gcc-16.1.0
arm64                 randconfig-1002-20260930    clang-24
arm64                 randconfig-1003-20260930    clang-24
arm64                randconfig-r2102-20260930    gcc-8.5.0  cocci
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260930    gcc-9.5.0
csky                  randconfig-1001-20260930    gcc-16.1.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260930    clang-24
hexagon               randconfig-1001-20260930    clang-24
hexagon              randconfig-r2307-20260930    clang-21   sparse
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260930    clang-22
i386        buildonly-randconfig-1001-20260930    gcc-14
i386        buildonly-randconfig-1002-20260930    gcc-14
i386        buildonly-randconfig-1003-20260930    clang-22
i386        buildonly-randconfig-1004-20260930    gcc-14
i386        buildonly-randconfig-1005-20260930    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260930    gcc-14
i386                  randconfig-1001-20260930    gcc-14
i386                  randconfig-1002-20260930    gcc-13
i386                  randconfig-1003-20260930    clang-22
i386                  randconfig-1004-20260930    gcc-14
i386                  randconfig-1005-20260930    clang-22
i386                  randconfig-1006-20260930    gcc-14
i386                  randconfig-1007-20260930    gcc-14
i386                  randconfig-1008-20260930    clang-22
i386                  randconfig-1009-20260930    clang-22
i386                  randconfig-1010-20260930    gcc-14
i386                  randconfig-1011-20260930    gcc-14
i386                  randconfig-1012-20260930    gcc-14
i386                  randconfig-1013-20260930    clang-22
i386                  randconfig-2100-20260930    clang-22   cocci
i386                  randconfig-2101-20260930    clang-22   cocci
i386                  randconfig-2102-20260930    clang-22   cocci
i386                  randconfig-2103-20260930    clang-22   cocci
i386                  randconfig-2200-20260930    gcc-14     smatch
i386                  randconfig-2300-20260930    gcc-13     sparse
i386                  randconfig-2300-20260930    gcc-14     sparse
i386                  randconfig-2301-20260930    clang-22   sparse
i386                  randconfig-2301-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-13     sparse
i386                  randconfig-2302-20260930    gcc-14     sparse
i386                 randconfig-r2106-20260930    clang-22   cocci
i386                 randconfig-r2202-20260930    gcc-13     smatch
i386                 randconfig-r2303-20260930    clang-24   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260930    clang-24
loongarch             randconfig-1001-20260930    gcc-16.1.0
loongarch            randconfig-r2308-20260930    clang-24   sparse
loongarch            randconfig-r2309-20260930    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2100-20260930    gcc-8.5.0  cocci
m68k                 randconfig-r2106-20260930    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20260930    gcc-12.5.0 cocci
m68k                 randconfig-r2307-20260930    gcc-12.5.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm47xx_defconfig    clang-24
mips                          cobalt_defconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
mips                 randconfig-r2305-20260930    gcc-9.5.0  sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260930    gcc-11.5.0
nios2                 randconfig-1001-20260930    gcc-11.5.0
nios2                randconfig-r2104-20260930    gcc-11.5.0 cocci
nios2                randconfig-r2200-20260930    gcc-10.5.0 smatch
nios2                randconfig-r2301-20260930    gcc-11.5.0 sparse
nios2                randconfig-r2306-20260930    gcc-8.5.0  sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260930    gcc-11.5.0
parisc                randconfig-1001-20260930    gcc-8.5.0
parisc               randconfig-r2303-20260930    gcc-11.5.0 sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       katmai_defconfig    clang-24
powerpc                   mpc866_ads_defconfig    clang-17
powerpc               randconfig-1000-20260930    clang-20
powerpc               randconfig-1001-20260930    clang-19
powerpc              randconfig-r2103-20260930    clang-24   cocci
powerpc              randconfig-r2306-20260930    gcc-12.5.0 sparse
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20260930    clang-24
powerpc64             randconfig-1001-20260930    gcc-8.5.0
powerpc64            randconfig-r2105-20260930    gcc-10.5.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260930    gcc-8.5.0
riscv                 randconfig-1001-20260930    clang-17
riscv                 randconfig-2000-20260930    gcc-14.3.0
riscv                 randconfig-2000-20260930    gcc-15.2.0
riscv                 randconfig-2001-20260930    gcc-14.3.0
riscv                 randconfig-2001-20260930    gcc-8.5.0
riscv                randconfig-r2300-20260930    clang-24   sparse
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260930    clang-24
s390                  randconfig-1001-20260930    clang-18
s390                  randconfig-2000-20260930    clang-24
s390                  randconfig-2000-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-14.3.0
s390                  randconfig-2001-20260930    gcc-8.5.0
s390                 randconfig-r2103-20260930    gcc-9.5.0  cocci
s390                 randconfig-r2104-20260930    gcc-8.5.0  cocci
s390                 randconfig-r2305-20260930    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260930    gcc-13.4.0
sh                    randconfig-1001-20260930    gcc-16.1.0
sh                    randconfig-2000-20260930    gcc-14.3.0
sh                    randconfig-2001-20260930    gcc-12.5.0
sh                    randconfig-2001-20260930    gcc-14.3.0
sh                   randconfig-r2101-20260930    gcc-12.5.0 cocci
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260930    gcc-8.5.0
sparc                 randconfig-1001-20260930    gcc-11.5.0
sparc                 randconfig-2000-20260930    gcc-10.5.0
sparc                 randconfig-2000-20260930    gcc-14.3.0
sparc                 randconfig-2001-20260930    gcc-10.5.0
sparc                 randconfig-2001-20260930    gcc-8.5.0
sparc                randconfig-r2302-20260930    clang-24   sparse
sparc                randconfig-r2308-20260930    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260930    gcc-8.5.0
sparc64               randconfig-1001-20260930    clang-22
sparc64               randconfig-2000-20260930    gcc-10.5.0
sparc64               randconfig-2000-20260930    gcc-8.5.0
sparc64               randconfig-2001-20260930    gcc-10.5.0
sparc64               randconfig-2001-20260930    gcc-9.5.0
sparc64              randconfig-r2304-20260930    clang-24   sparse
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260930    gcc-14
um                    randconfig-1001-20260930    gcc-14
um                    randconfig-2000-20260930    clang-24
um                    randconfig-2000-20260930    gcc-10.5.0
um                    randconfig-2001-20260930    clang-24
um                    randconfig-2001-20260930    gcc-10.5.0
um                   randconfig-r2100-20260930    clang-24   cocci
um                   randconfig-r2105-20260930    gcc-8.5.0  cocci
um                   randconfig-r2201-20260930    clang-17   smatch
um                   randconfig-r2300-20260930    clang-17   sparse
um                   randconfig-r2309-20260930    gcc-12.5.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260930    gcc-14
x86_64      buildonly-randconfig-1001-20260930    clang-22
x86_64      buildonly-randconfig-1002-20260930    gcc-14
x86_64      buildonly-randconfig-1003-20260930    gcc-14
x86_64      buildonly-randconfig-1004-20260930    gcc-14
x86_64      buildonly-randconfig-1005-20260930    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260930    clang-22
x86_64                randconfig-1001-20260930    clang-22
x86_64                randconfig-1002-20260930    gcc-14
x86_64                randconfig-1003-20260930    clang-22
x86_64                randconfig-1004-20260930    clang-22
x86_64                randconfig-1005-20260930    gcc-13
x86_64                randconfig-1006-20260930    gcc-14
x86_64                randconfig-1007-20260930    clang-22
x86_64                randconfig-1008-20260930    clang-22
x86_64                randconfig-1009-20260930    clang-22
x86_64                randconfig-1010-20260930    clang-22
x86_64                randconfig-1011-20260930    gcc-14
x86_64                randconfig-1012-20260930    clang-22
x86_64                randconfig-1013-20260930    clang-22
x86_64                randconfig-1014-20260930    gcc-14
x86_64                randconfig-1015-20260930    clang-22
x86_64                randconfig-1016-20260930    gcc-14
x86_64                randconfig-1017-20260930    clang-22
x86_64                randconfig-2100-20260930    clang-22   cocci
x86_64                randconfig-2101-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    clang-22   cocci
x86_64                randconfig-2102-20260930    gcc-14     cocci
x86_64                randconfig-2103-20260930    clang-22   cocci
x86_64                randconfig-2200-20260930    gcc-14     smatch
x86_64                randconfig-2300-20260930    clang-22   sparse
x86_64                randconfig-2300-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-13     sparse
x86_64                randconfig-2301-20260930    gcc-14     sparse
x86_64                randconfig-2302-20260930    gcc-13     sparse
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
xtensa                randconfig-1000-20260930    gcc-15.2.0
xtensa                randconfig-1001-20260930    gcc-8.5.0
xtensa                randconfig-2000-20260930    gcc-10.5.0
xtensa                randconfig-2000-20260930    gcc-12.5.0
xtensa                randconfig-2001-20260930    gcc-10.5.0
xtensa               randconfig-r2302-20260930    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

