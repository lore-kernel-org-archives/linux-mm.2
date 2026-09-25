Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E860C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E4F6B0088; Fri, 25 Sep 2026 01:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F426B008A; Fri, 25 Sep 2026 01:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E046B008C; Fri, 25 Sep 2026 01:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB746B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:17:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ABECA0574
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:17:27 +0000 (UTC)
X-FDA: 85251126534.19.331228D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf17.hostedemail.com (Postfix) with ESMTP id 57EE540009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:17:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Aqngkt8X;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790313445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ZGu8im0BdimQA9jipJ8y2JOZVc5rDxxueX/dm+Qqkxc=;
	b=yyDMsnW6AtHhJ88H1ldBcY00yVSwFD55zNEAOGO0KeITusyYd5/+EJ9+EHp6ZjinI+nQTj
	Vy+2o7K4LsFRrdQfZQp2zddXNGfGDI4+QNzoicxwVV9BMDruW7HIIdbJBMQ4Dp1BiUtzvr
	PXb71BO3NTK0fN01Q/iqu2w0KMnak50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790313445;
	b=U0vwvH63GeoZiawVRS6Ulz5kCvkSaCfSf549kQyBdg2bzH/okaP9p19zEr/PyMiTbdcQTy
	hdw9IG9St3EdqLHafJytpB5qeU9OWrnKB3uk9RjXCxyCFWcC/CtpvwTpvW4aUW8cYzg9zd
	oZvnTVV6kovIPvRbRwCNls2leTX9YDI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Aqngkt8X;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790313444; x=1821849444;
  h=date:from:to:cc:subject:message-id;
  bh=ocA+jeQduq65zYrZGNwYD6fpXCUtDLMtxZzXY/BT0Tw=;
  b=Aqngkt8XvYglCrLs09ViEOQUbBzeF6boRRRWHyciHkiLG7vd+tmrAjCH
   y7j8ff+q8EaBduHAQDhCk8AM4XeVxj+6vNS5moYnMwQUiNW/owoYFL4VB
   3LVCV+DD6941a5/GAHXDAEsT2alTvy1biBJgzlQw8iB30uaP2W3tnPrtm
   7ZXBXjkraxYB7xfbzP4WTzJQUFYpuAl6mHzN+YWxYf7lds9mcOQEReLwe
   +D+mh5oxw2EYpdfqnriy+htZ0xHQmTO1dheVeaUw9/Eo9U+egA68CTekn
   QNyYvfLsNXZKwtt4C8qAU8hyHHp78dcMPIyJsCvT/GG4tHl3yljjFSjum
   Q==;
X-CSE-ConnectionGUID: 3ebCQA4sTfe3SqtayuQxCw==
X-CSE-MsgGUID: gMp4sORARwqyxQ9PRSmkgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="116622769"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="116622769"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 22:17:23 -0700
X-CSE-ConnectionGUID: sNUbAHFBQIOkXZ1j60qxtQ==
X-CSE-MsgGUID: I7ZaDrJaTWSYqH2WCxwPKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273788923"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 24 Sep 2026 22:17:22 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9yJC-00000000K3K-2zmE;
	Fri, 25 Sep 2026 05:17:18 +0000
Date: Fri, 25 Sep 2026 13:16:48 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 f19407ca08644f728cfe9762bf1d1f6985826c47
Message-ID: <202609251344.89ogZm4T-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57EE540009
X-Stat-Signature: dumhkqmpkfowtcjsigmwgqakiik7bn1k
X-Rspam-User: 
X-HE-Tag: 1790313444-824230
X-HE-Meta: U2FsdGVkX18i7hG4P6zOulMlYmAs4A3YrBpSjusQuNMtt8rKLDWEOEJjXHKZ6Ye0Mq/Egt6NJgHTYkDu94brR/t3pK4NaJ2N+ilgJl6kPELuuQO9SdjVfK09BaQ3KfcupAhJTL4K3BojByuUwwix5shGEVgQxvsXpTSLbrwFYDYk7Q/KqXmQ4n0oEwb7BOks6Lm0dOjz/tCgjGv7ETmTmdWuExjxeyKo00xO0iyYpAVuw3cpwC6q9ielQE5Uo+AalL5c2GI9GuVh2plaZLzh4mJVm3KCkr5+M7MudNyhLbHZyGJDLKkVz5c1rHiedUeXbqSPS324eikOu3n0pw2zoQtt2/wLSOdEw2vn/1CGLHnoDTniTuxVZQ3kalsKyq9LApcDExofJo8FXAHcV6/TXq7XYhfKEWorVAUe8NjH9AVXwnj8huZhi6BApx26t1IySklDA5IsR8iX6vGBNrHNxIaDx0XfHmIGTPp6Uxbm3y9bDDdG9gjxBuc0XQNMNMysiFe6rjaShmh1FA2Wkkad1Z1NXNnYQK6IJuYE0knnHTst1dd2i1xTfL4ij8JaIHMVjAfLHBdFU6mwugFnXxoKLdQz/XxhdXEfOErywrdgw9zy9qtvPN5P0HBk00peTWLUzI0R/LfnXSdOm/Lt9pnsE0+11hImFCMwV03lO8tO2su2CVz40njgIWo9m7IWTIyir7ZDsgKAJfFYksqOYEHc00ZWqRumVVR+ulBmECRhvfbFYTSmMQ/beYshiAUxc0/OMtFDWDdEj6qlDUKoSnR6sKm4zrkleeinEQWdmtLTd436a33CtOdHcDpBeZzZ/UEfDvvV3YD+wrcWOu/giGQVUnjvtXrwcdRgDSX4rli5r0F3YzTYlaIYICuGukvXZ2bWS2l+yDPHrX1g9cZTuFCkpTw8Alp3iU8gRGmYr3a7P6VhsGsGzubNB8mJyLxSPL7h5mzovW0beV4FL0T74yT
 CWC7C/v/
 apga68bZxzuhuDKImG3y+qizrBDt6J7qceei9InlvqOH30fc50Kwx8zmHhfvIlo39DREwg0wG/Q9qMeIfv8Ad2Xnow3Ackn1E1Omv1n44/KgOOQUV9qKl6FdfNG8iv4FdWOVVUhUrr9VzM1zotQ4XskxvbnV2Y5e0GPcnJ51eRs4FWq8HFlM+6rj8HwT9kczYRIh9lxE8nlzS8Nuoh50GBwXj5+dRt1CcX4eR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: f19407ca08644f728cfe9762bf1d1f6985826c47  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com

    fs/proc/task_mmu.c:3450:17: error: implicit declaration of function 'drop_rcu' [-Wimplicit-function-declaration]
    fs/proc/task_mmu.c:3452:17: error: implicit declaration of function 'reacquire_rcu' [-Wimplicit-function-declaration]

Error/Warning ids grouped by kconfigs:

recent_errors
`-- x86_64-randconfig-1002-20260925
    |-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-drop_rcu
    `-- fs-proc-task_mmu.c:error:implicit-declaration-of-function-reacquire_rcu

elapsed time: 772m

configs tested: 263
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260925    clang-24
arc                   randconfig-1000-20260925    gcc-13.4.0
arc                   randconfig-1001-20260925    clang-24
arc                   randconfig-1001-20260925    gcc-11.5.0
arc                  randconfig-r1301-20260925    gcc-11.5.0 sparse
arc                            tb10x_defconfig    gcc-16.1.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                        omap2plus_defconfig    gcc-16.1.0
arm                           pxa910_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260925    clang-24
arm                   randconfig-1000-20260925    gcc-15.2.0
arm                   randconfig-1001-20260925    clang-24
arm                   randconfig-1002-20260925    clang-24
arm                   randconfig-1002-20260925    gcc-11.5.0
arm                   randconfig-1003-20260925    clang-17
arm                   randconfig-1003-20260925    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260925    clang-21
arm64                 randconfig-1000-20260925    clang-24
arm64                 randconfig-1001-20260925    clang-24
arm64                 randconfig-1001-20260925    gcc-16.1.0
arm64                 randconfig-1002-20260925    clang-24
arm64                 randconfig-1003-20260925    clang-24
arm64                 randconfig-1003-20260925    gcc-16.1.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260925    clang-24
csky                  randconfig-1000-20260925    gcc-9.5.0
csky                  randconfig-1001-20260925    clang-24
csky                  randconfig-1001-20260925    gcc-15.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260925    clang-24
hexagon               randconfig-1000-20260925    gcc-9.5.0
hexagon               randconfig-1001-20260925    clang-17
hexagon               randconfig-1001-20260925    gcc-9.5.0
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260925    clang-22
i386        buildonly-randconfig-1001-20260925    clang-22
i386        buildonly-randconfig-1002-20260925    clang-22
i386        buildonly-randconfig-1002-20260925    gcc-13
i386        buildonly-randconfig-1003-20260925    clang-22
i386        buildonly-randconfig-1004-20260925    clang-22
i386        buildonly-randconfig-1004-20260925    gcc-14
i386        buildonly-randconfig-1005-20260925    clang-22
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260925    clang-22
i386                  randconfig-1001-20260925    clang-22
i386                  randconfig-1002-20260925    clang-22
i386                  randconfig-1003-20260925    clang-22
i386                  randconfig-1003-20260925    gcc-14
i386                  randconfig-1004-20260925    clang-22
i386                  randconfig-1004-20260925    gcc-14
i386                  randconfig-1005-20260925    clang-22
i386                  randconfig-1006-20260925    clang-22
i386                  randconfig-1006-20260925    gcc-14
i386                  randconfig-1007-20260925    clang-22
i386                  randconfig-1008-20260925    gcc-14
i386                  randconfig-1009-20260925    clang-22
i386                  randconfig-1010-20260925    clang-22
i386                  randconfig-1011-20260925    gcc-12
i386                  randconfig-1012-20260925    clang-22
i386                  randconfig-1013-20260925    clang-22
i386                  randconfig-1300-20260925    clang-22   sparse
i386                  randconfig-1301-20260925    clang-22   sparse
i386                  randconfig-1301-20260925    gcc-14     sparse
i386                  randconfig-1302-20260925    clang-22   sparse
i386                 randconfig-r1309-20260925    gcc-14     sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260925    clang-24
loongarch             randconfig-1000-20260925    gcc-9.5.0
loongarch             randconfig-1001-20260925    clang-24
loongarch             randconfig-1001-20260925    gcc-9.5.0
loongarch            randconfig-r1303-20260925    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r1304-20260925    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                        bmips_be_defconfig    gcc-16.1.0
mips                 randconfig-r1304-20260925    gcc-12.5.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260925    gcc-9.5.0
nios2                 randconfig-1001-20260925    gcc-11.5.0
nios2                 randconfig-1001-20260925    gcc-9.5.0
nios2                randconfig-r1302-20260925    gcc-11.5.0 sparse
nios2                randconfig-r1306-20260925    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1302-20260925    gcc-12.5.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260925    clang-24
parisc                randconfig-1000-20260925    gcc-11.5.0
parisc                randconfig-1001-20260925    clang-24
parisc                randconfig-1001-20260925    gcc-8.5.0
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                         fsp2_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260925    clang-24
powerpc               randconfig-1001-20260925    clang-24
powerpc               randconfig-1001-20260925    gcc-10.5.0
powerpc              randconfig-r1308-20260925    clang-24   sparse
powerpc                     socrates_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260925    clang-24
powerpc64             randconfig-1001-20260925    clang-24
powerpc64             randconfig-1001-20260925    gcc-12.5.0
powerpc64            randconfig-r1303-20260925    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260925    clang-24
riscv                 randconfig-1001-20260925    clang-24
riscv                randconfig-r1307-20260925    clang-22   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260925    clang-24
s390                  randconfig-1001-20260925    clang-24
s390                  randconfig-1001-20260925    gcc-10.5.0
s390                 randconfig-r1305-20260925    clang-24   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260925    clang-24
sh                    randconfig-1000-20260925    gcc-16.1.0
sh                    randconfig-1001-20260925    clang-24
sh                    randconfig-1001-20260925    gcc-15.2.0
sh                   randconfig-r1300-20260925    gcc-16.1.0 sparse
sh                           rsk7269_defconfig    gcc-16.1.0
sh                    rts7751r2dplus_defconfig    gcc-16.1.0
sh                            sh2007_defconfig    gcc-16.1.0
sh                         sh7763rdp_defconfig    gcc-16.1.0
sh                           urquell_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260925    gcc-12
sparc                 randconfig-1000-20260925    gcc-16.1.0
sparc                 randconfig-1001-20260925    gcc-11.5.0
sparc                 randconfig-1001-20260925    gcc-12
sparc                randconfig-r1300-20260925    gcc-11.5.0 sparse
sparc                randconfig-r1305-20260925    gcc-11.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260925    gcc-12
sparc64               randconfig-1000-20260925    gcc-16.1.0
sparc64               randconfig-1001-20260925    gcc-12
sparc64               randconfig-1001-20260925    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260925    gcc-12
um                    randconfig-1001-20260925    gcc-12
um                    randconfig-1001-20260925    gcc-14
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260925    clang-22
x86_64      buildonly-randconfig-1001-20260925    clang-22
x86_64      buildonly-randconfig-1002-20260925    clang-22
x86_64      buildonly-randconfig-1003-20260925    clang-22
x86_64      buildonly-randconfig-1003-20260925    gcc-14
x86_64      buildonly-randconfig-1004-20260925    clang-22
x86_64      buildonly-randconfig-1005-20260925    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260925    clang-22
x86_64                randconfig-1000-20260925    gcc-14
x86_64                randconfig-1001-20260925    gcc-14
x86_64                randconfig-1002-20260925    gcc-14
x86_64                randconfig-1003-20260925    gcc-14
x86_64                randconfig-1004-20260925    clang-22
x86_64                randconfig-1004-20260925    gcc-14
x86_64                randconfig-1005-20260925    gcc-14
x86_64                randconfig-1006-20260925    gcc-14
x86_64                randconfig-1007-20260925    clang-22
x86_64                randconfig-1008-20260925    clang-22
x86_64                randconfig-1009-20260925    clang-22
x86_64                randconfig-1010-20260925    gcc-14
x86_64                randconfig-1011-20260925    clang-22
x86_64                randconfig-1012-20260925    clang-22
x86_64                randconfig-1013-20260925    gcc-14
x86_64                randconfig-1014-20260925    clang-22
x86_64                randconfig-1015-20260925    clang-22
x86_64                randconfig-1016-20260925    gcc-14
x86_64                randconfig-1017-20260925    clang-22
x86_64                randconfig-1300-20260925    clang-22   sparse
x86_64                randconfig-1300-20260925    gcc-14     sparse
x86_64                randconfig-1301-20260925    clang-22   sparse
x86_64                randconfig-1301-20260925    gcc-14     sparse
x86_64                randconfig-1302-20260925    clang-22   sparse
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                   audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20260925    gcc-12
xtensa                randconfig-1000-20260925    gcc-15.2.0
xtensa                randconfig-1001-20260925    gcc-12
xtensa                randconfig-1001-20260925    gcc-13.4.0
xtensa               randconfig-r1301-20260925    gcc-14.3.0 sparse
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

