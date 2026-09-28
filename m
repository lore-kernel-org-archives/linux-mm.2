Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AB9CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB506B0088; Mon, 28 Sep 2026 08:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392D46B008A; Mon, 28 Sep 2026 08:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D7B6B0092; Mon, 28 Sep 2026 08:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4FA16B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:24:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85A8E401AA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:24:09 +0000 (UTC)
X-FDA: 85263088218.10.EC736B2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 27ABE40004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:24:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d8vaId7+;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790598247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=scwhhS9K+3uXgy6Oy66c5+MHEnYGbWxzZwJSbUBTEuw=;
	b=lCsnYYHCwSSHhujgfJBpED0r4NeGODXm6yogn1VHHOWsrQNPd6XC5GIbtkr3QraJgNK1E4
	6NO5oHzscZc/AB9ImefXv3TxkVfw4moSf2/UGn1qqEGIoy2pf5NFSmG/gsrMm76D5qGlei
	GopEPM55cnIJS+WK+w9y75dR9Cac2hQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d8vaId7+;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790598247;
	b=Da5E2cH6nIlzWmG5MVsldEeVsCY/JMYc7mYVCYz2CBEOMAudtP6xtX46gkEHHf+9pjwROX
	oo1dI1LVfBpmWbqDQJ//sRqDd5OiXMORc70ef4Ni8Cv2UwhGXArsyXNJXOwRZ6SWNLbpAr
	83N8ZkioCyoeuHX/VtggouQegOuPhK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790598246; x=1822134246;
  h=date:from:to:cc:subject:message-id;
  bh=Ic+NKSuUw/CsU2jERGnjvb+vc5GHHxy84NAK1JQIhQo=;
  b=d8vaId7+jbrhVES9bGGifpk1eYB0pzDVE08uQyg2i+Zzhcy9cjOTA+/O
   CC3SaEzKMovqjYYf1EDKSeL82AH18k4rn/c0p9ibmVpury/lRnQCgsa9f
   254nObZu9iMZiKBsO3fyU1tEdp/SbNnXIGUASxD77MNQesjVKaQUhR7Jc
   k0MFJqHOzF2MvBsu5YT0GShvh5jn0ztZNU7dnNdTJf+Pr1C9hr//lqBD3
   rdoI4wrsHeyv+OBXTsobnGpTa0RqVRGCqXVXj8KAYvgtN0n0LSHFe+YF7
   jvbPG1oDlzgEpUCZ0cj31VhEliVA8Mo7lN0C1WBcmaYiIns50Yk8hFIwg
   A==;
X-CSE-ConnectionGUID: IrPcmusNRRqPyVC+6UPQkA==
X-CSE-MsgGUID: d6UEsA5NTz6xrcQ6c7FUXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11918"; a="90423643"
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="90423643"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 05:24:05 -0700
X-CSE-ConnectionGUID: 4XBonCn/Q9mJDJj1r01IMA==
X-CSE-MsgGUID: ZrYRQGp7Q0WliEjGJ8ioXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="273179317"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 28 Sep 2026 05:24:04 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBAOm-00000000Nx5-2cGV;
	Mon, 28 Sep 2026 12:24:00 +0000
Date: Mon, 28 Sep 2026 20:23:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
Message-ID: <202609282019.vrITV7oW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27ABE40004
X-Stat-Signature: ww4qnyjphnou1wkreqa1eqi1wofns69g
X-Rspam-User: 
X-HE-Tag: 1790598245-775824
X-HE-Meta: U2FsdGVkX1+akBp+YQrDRyg76wuzUq9EMiOOi3cP9GLfBdZ1ZHst1A6X7jNC5fT+nRmHDru4ltHRNlCnDKUJIiCB2RDnwN/liuWYHpR/YMQap47zKKTXnn4Dw/iWqf+7e758n6SLZyBrA9ZUV2uyu4WvkvZFIKpp7J+eEa/uSuCwnloAj/x8fGTOz1eUIoNjNxogfhd0eexZab0dOoDb/HNOUh/M3zibEhrpjkVAa8REHi8V2ygoWpb0fzVoMBhV8VjP/4Vy+YxLjzsxeuYcr3UJvbV3EPhUZvggPuuQc/WZQusEdVMr1AnZV2IxQItnRwC4cB4fqclyi6m7PEtzhonGqf24okohqbt4sNKPvZ8VocNNfar9x19yCxU9ECWRx276ymEpfHtEEdVM/0gAwZa9EI46FxPFnc9hs9vvatJ4++k3tMzuSQsKgheL1fZHi+z9EVGlPhFaIzTChwBjyTK0J41OVnKOmc/uT0IWtZOqICBbwFXaOs3utP34RY6qa51tvCXqUiWLz4FUQgOazxO75ylz1EjziEYi9AcJiotUPJZwSGwD6H5WmjRinYcTW0smcYNDzIs2nopyCXgrBE3YsqGoSrGVKl53dQ9vNja/GbgJuXZamutmGpgTFmsyDzFWIklEEu2cvBzXrQ1oRFSNbEbZ4b2WeLmEhGieCLP/Ki4dLm00nLuKHTP3uQru93NQ1IQr+rcOpf1wNzz+nPkPg7vU8r+hYEOzl+hEvBn0BfTDfeEyheTuxy4cKBbv+S47BMiZvDK3MgN3oQqy0UyPsRQ6YA1CXjfT00jMBfPGLJ7WzqizejYHYB+nFGjA+vFEp+RBpshKEZ9Gi8Mos+u8Nlh+J/ZCyKQ18LXNXsiRDL8aj27zI+ilPaj8RfEPnCN78xnOJUESXT3iMoGnypEAe6Dn+Uct3ovO4qrBFX9hOKyUj0nVnPObMyteJb5bR0xgK6CGIy3nM64700B
 +yYkRWxe
 Drx2ATEqkOoAShBwKOSO1nqn8zj6FIvvoI+sH1ONCVAgIRHZSclyRrDKCQWFaZxc8My3/0URGvFzZWpLJ4s9hBRCfccKtQ/RPLfNVrjYLKClWBI2syccWYthYbtmOxm3JX/vI9+/EgI/6+TIen+opQRvVUSsA3HMRordshjQ3YqcURGENrDAkVrd1aQfmH6Zj3dfur3d8QgGbOkKD6Sg2WqEcQYU514oIDbux
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com

    fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-2101-20260927
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20260927
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- nios2-randconfig-r2202-20260927
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- s390-randconfig-r2107-20260927
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-1000-20260928
|   |-- fs-proc-task_mmu.c:error:call-to-undeclared-function-drop_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- fs-proc-task_mmu.c:error:call-to-undeclared-function-reacquire_rcu-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-randconfig-2100-20260927
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20260927
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- xtensa-randconfig-r2100-20260927
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- xtensa-randconfig-r2104-20260927
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 743m

configs tested: 298
configs skipped: 6

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2102-20260927    gcc-8.5.0  cocci
alpha                randconfig-r2103-20260927    clang-24   cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260928    gcc-12.5.0
arc                   randconfig-1001-20260928    gcc-14.3.0
arc                  randconfig-r2104-20260928    gcc-16.1.0 cocci
arc                  randconfig-r2105-20260927    gcc-8.5.0  cocci
arc                  randconfig-r2300-20260927    gcc-9.5.0  sparse
arc                  randconfig-r2303-20260928    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g4_defconfig    clang-20
arm                                  defconfig    clang-24
arm                   randconfig-1000-20260928    gcc-14.3.0
arm                   randconfig-1001-20260928    clang-24
arm                   randconfig-1002-20260928    clang-24
arm                   randconfig-1003-20260928    gcc-12.5.0
arm                  randconfig-r2300-20260927    clang-22   sparse
arm                  randconfig-r2304-20260927    clang-22   sparse
arm                  randconfig-r2304-20260928    clang-24   sparse
arm                        spear13xx_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260928    gcc-15.2.0
arm64                 randconfig-1001-20260928    clang-24
arm64                 randconfig-1002-20260928    gcc-15.2.0
arm64                 randconfig-1003-20260928    gcc-8.5.0
arm64                randconfig-r2305-20260927    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260928    gcc-16.1.0
csky                  randconfig-1001-20260928    gcc-14.3.0
csky                 randconfig-r2301-20260927    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260928    clang-24
hexagon               randconfig-1001-20260928    clang-19
hexagon              randconfig-r2104-20260927    clang-24   cocci
hexagon              randconfig-r2106-20260927    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260928    gcc-14
i386        buildonly-randconfig-1001-20260928    gcc-14
i386        buildonly-randconfig-1002-20260928    gcc-14
i386        buildonly-randconfig-1003-20260928    clang-22
i386        buildonly-randconfig-1004-20260928    gcc-14
i386        buildonly-randconfig-1005-20260928    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260928    clang-22
i386                  randconfig-1001-20260928    gcc-12
i386                  randconfig-1002-20260928    gcc-14
i386                  randconfig-1003-20260928    gcc-14
i386                  randconfig-1004-20260928    gcc-14
i386                  randconfig-1005-20260928    gcc-14
i386                  randconfig-1006-20260928    gcc-14
i386                  randconfig-1007-20260928    gcc-12
i386                  randconfig-1008-20260928    clang-22
i386                  randconfig-1009-20260928    gcc-14
i386                  randconfig-1010-20260928    gcc-14
i386                  randconfig-1011-20260928    clang-22
i386                  randconfig-1012-20260928    clang-22
i386                  randconfig-1013-20260928    clang-22
i386                  randconfig-2100-20260927    clang-22   cocci
i386                  randconfig-2100-20260928    gcc-14     cocci
i386                  randconfig-2101-20260927    clang-22   cocci
i386                  randconfig-2101-20260928    gcc-14     cocci
i386                  randconfig-2102-20260927    clang-22   cocci
i386                  randconfig-2102-20260928    gcc-14     cocci
i386                  randconfig-2103-20260927    clang-22   cocci
i386                  randconfig-2103-20260928    gcc-14     cocci
i386                  randconfig-2200-20260927    clang-22   smatch
i386                  randconfig-2200-20260928    clang-22   smatch
i386                  randconfig-2300-20260927    clang-22   sparse
i386                  randconfig-2300-20260928    clang-22   sparse
i386                  randconfig-2301-20260927    clang-22   sparse
i386                  randconfig-2301-20260928    clang-22   sparse
i386                  randconfig-2302-20260927    clang-22   sparse
i386                  randconfig-2302-20260928    clang-22   sparse
i386                 randconfig-r2107-20260927    clang-24   cocci
i386                 randconfig-r2308-20260927    gcc-14     sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260928    gcc-16.1.0
loongarch             randconfig-1001-20260928    gcc-16.1.0
loongarch            randconfig-r2200-20260927    clang-24   smatch
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                           atari_defconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2304-20260927    gcc-14.3.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2100-20260927    clang-24   cocci
microblaze           randconfig-r2106-20260928    gcc-16.1.0 cocci
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2103-20260927    gcc-8.5.0  cocci
mips                 randconfig-r2305-20260927    clang-22   sparse
mips                           rb532_defconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260928    gcc-8.5.0
nios2                 randconfig-1001-20260928    gcc-10.5.0
nios2                randconfig-r2202-20260927    gcc-8.5.0  smatch
nios2                randconfig-r2202-20260928    gcc-11.5.0 smatch
nios2                randconfig-r2303-20260927    clang-22   sparse
nios2                randconfig-r2307-20260927    gcc-9.5.0  sparse
nios2                randconfig-r2309-20260927    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2106-20260927    clang-24   cocci
openrisc             randconfig-r2200-20260927    gcc-16.1.0 smatch
openrisc             randconfig-r2302-20260928    clang-24   sparse
openrisc             randconfig-r2303-20260927    gcc-16.1.0 sparse
openrisc             randconfig-r2305-20260928    clang-24   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260928    gcc-10.5.0
parisc                randconfig-1001-20260928    gcc-16.1.0
parisc               randconfig-r2100-20260927    gcc-8.5.0  cocci
parisc               randconfig-r2200-20260928    gcc-8.5.0  smatch
parisc               randconfig-r2300-20260928    clang-24   sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20260928    gcc-13.4.0
powerpc               randconfig-1001-20260928    clang-24
powerpc              randconfig-r2103-20260927    gcc-9.5.0  cocci
powerpc                     sam440ep_defconfig    gcc-16.1.0
powerpc                         warp_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260928    clang-24
powerpc64             randconfig-1001-20260928    gcc-13.4.0
powerpc64            randconfig-r2201-20260927    clang-24   smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260928    gcc-13.4.0
riscv                 randconfig-1001-20260928    clang-24
riscv                 randconfig-2000-20260927    clang-24
riscv                 randconfig-2001-20260927    clang-24
riscv                 randconfig-2001-20260927    gcc-11.5.0
riscv                randconfig-r2102-20260927    clang-24   cocci
riscv                randconfig-r2201-20260927    gcc-8.5.0  smatch
riscv                randconfig-r2301-20260927    clang-22   sparse
riscv                randconfig-r2302-20260927    clang-24   sparse
riscv                randconfig-r2306-20260927    clang-21   sparse
riscv                randconfig-r2307-20260927    clang-24   sparse
riscv                randconfig-r2308-20260927    clang-24   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260928    clang-17
s390                  randconfig-1001-20260928    gcc-15.2.0
s390                  randconfig-2000-20260927    clang-24
s390                  randconfig-2001-20260927    clang-24
s390                  randconfig-2001-20260927    gcc-15.2.0
s390                 randconfig-r2101-20260927    clang-24   cocci
s390                 randconfig-r2107-20260927    gcc-15.2.0 cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260928    gcc-12.5.0
sh                    randconfig-1001-20260928    gcc-10.5.0
sh                    randconfig-2000-20260927    clang-24
sh                    randconfig-2000-20260927    gcc-12.5.0
sh                    randconfig-2001-20260927    clang-24
sh                    randconfig-2001-20260927    gcc-14.3.0
sh                   randconfig-r2102-20260927    gcc-16.1.0 cocci
sh                   randconfig-r2107-20260928    gcc-16.1.0 cocci
sh                            se7343_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260928    gcc-12.5.0
sparc                 randconfig-1001-20260928    gcc-16.1.0
sparc                 randconfig-2000-20260927    gcc-16.1.0
sparc                 randconfig-2000-20260928    gcc-13.4.0
sparc                 randconfig-2001-20260927    gcc-16.1.0
sparc                 randconfig-2001-20260928    gcc-13.4.0
sparc                randconfig-r2105-20260927    clang-24   cocci
sparc                randconfig-r2306-20260927    clang-24   sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260928    gcc-8.5.0
sparc64               randconfig-1001-20260928    clang-21
sparc64               randconfig-2000-20260927    clang-24
sparc64               randconfig-2000-20260927    gcc-16.1.0
sparc64               randconfig-2000-20260928    gcc-13.4.0
sparc64               randconfig-2001-20260927    clang-20
sparc64               randconfig-2001-20260927    gcc-16.1.0
sparc64               randconfig-2001-20260928    gcc-13.4.0
sparc64              randconfig-r2101-20260927    gcc-8.5.0  cocci
sparc64              randconfig-r2105-20260928    gcc-16.1.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260928    clang-17
um                    randconfig-1001-20260928    gcc-13
um                    randconfig-2000-20260927    gcc-14
um                    randconfig-2000-20260927    gcc-16.1.0
um                    randconfig-2000-20260928    gcc-13.4.0
um                    randconfig-2001-20260927    clang-22
um                    randconfig-2001-20260927    gcc-16.1.0
um                    randconfig-2001-20260928    gcc-13.4.0
um                   randconfig-r2202-20260927    gcc-14     smatch
um                   randconfig-r2301-20260928    clang-24   sparse
um                   randconfig-r2302-20260927    clang-22   sparse
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260928    gcc-14
x86_64      buildonly-randconfig-1001-20260928    gcc-14
x86_64      buildonly-randconfig-1002-20260928    gcc-14
x86_64      buildonly-randconfig-1003-20260928    gcc-14
x86_64      buildonly-randconfig-1004-20260928    gcc-14
x86_64      buildonly-randconfig-1005-20260928    gcc-12
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260928    clang-22
x86_64                randconfig-1001-20260928    gcc-14
x86_64                randconfig-1002-20260928    gcc-14
x86_64                randconfig-1003-20260928    clang-22
x86_64                randconfig-1004-20260928    gcc-14
x86_64                randconfig-1005-20260928    gcc-14
x86_64                randconfig-1006-20260928    gcc-14
x86_64                randconfig-1007-20260928    clang-22
x86_64                randconfig-1008-20260928    clang-22
x86_64                randconfig-1009-20260928    gcc-14
x86_64                randconfig-1010-20260928    clang-22
x86_64                randconfig-1011-20260928    clang-22
x86_64                randconfig-1012-20260928    clang-22
x86_64                randconfig-1013-20260928    clang-22
x86_64                randconfig-1014-20260928    clang-22
x86_64                randconfig-1015-20260928    gcc-14
x86_64                randconfig-1016-20260928    clang-22
x86_64                randconfig-1017-20260928    clang-22
x86_64                randconfig-2100-20260927    clang-22   cocci
x86_64                randconfig-2100-20260928    gcc-12     cocci
x86_64                randconfig-2101-20260927    clang-22   cocci
x86_64                randconfig-2101-20260928    gcc-12     cocci
x86_64                randconfig-2102-20260927    clang-22   cocci
x86_64                randconfig-2102-20260927    gcc-14     cocci
x86_64                randconfig-2102-20260928    gcc-12     cocci
x86_64                randconfig-2103-20260927    clang-22   cocci
x86_64                randconfig-2103-20260928    gcc-12     cocci
x86_64                randconfig-2200-20260927    gcc-14     smatch
x86_64                randconfig-2200-20260928    gcc-14     smatch
x86_64                randconfig-2300-20260927    clang-22   sparse
x86_64                randconfig-2300-20260927    gcc-14     sparse
x86_64                randconfig-2300-20260928    clang-22   sparse
x86_64                randconfig-2301-20260927    clang-22   sparse
x86_64                randconfig-2301-20260927    gcc-14     sparse
x86_64                randconfig-2301-20260928    clang-22   sparse
x86_64                randconfig-2302-20260927    clang-22   sparse
x86_64                randconfig-2302-20260927    gcc-13     sparse
x86_64                randconfig-2302-20260928    clang-22   sparse
x86_64               randconfig-r2101-20260927    clang-22   cocci
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
xtensa                randconfig-1000-20260928    gcc-8.5.0
xtensa                randconfig-1001-20260928    gcc-12.5.0
xtensa                randconfig-2000-20260927    gcc-16.1.0
xtensa                randconfig-2000-20260927    gcc-8.5.0
xtensa                randconfig-2000-20260928    gcc-13.4.0
xtensa                randconfig-2001-20260927    gcc-16.1.0
xtensa                randconfig-2001-20260928    gcc-13.4.0
xtensa               randconfig-r2100-20260927    gcc-15.2.0 cocci
xtensa               randconfig-r2104-20260927    gcc-11.5.0 cocci
xtensa               randconfig-r2201-20260927    gcc-16.1.0 smatch
xtensa               randconfig-r2309-20260927    clang-24   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

