Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D360C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 18:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D441A6B008A; Thu, 10 Sep 2026 14:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5BE6B008C; Thu, 10 Sep 2026 14:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B016B0092; Thu, 10 Sep 2026 14:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 896FE6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:25:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A9B1A0618
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:25:08 +0000 (UTC)
X-FDA: 85198679496.07.B2F0C51
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf11.hostedemail.com (Postfix) with ESMTP id AFAC940004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:25:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lxwfTh66;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789064706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=MWkDbuQXKswoR0lK+7oUBANr3CDu47jk/zcSPny/dj0=;
	b=S6lmHf2jbU69rd9RREs7qJ4rX72MAvcs5t2mkZvNfdzfby9pDkeZ3XDr6yo/3n2Bqyhccx
	4BstdWJbWv50GyQLOSlCSsXUx2pp5ZxpSSaqfDDk+moQn8fNhy7GhdneMNe7xr5lR9EUDx
	/ekSP4m6iYxB8YTesw9nKNWMi9rWVBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789064706;
	b=JqMymT9LMgX6HvZ+bX9oGeE7mkVDoaam9ZUExNQq4Jm1bkUh8NA5vKNiBCr9C3z2KwNNpY
	OaZh63CHK0SHUkbbASe0pYZGFcHwR8jXF4eyuNsoWJIs40hznn+dMUMxizWzclGO9dj4eo
	hTVjJnKTSHSZTnyt2WVu37CBquZrnr0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lxwfTh66;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789064705; x=1820600705;
  h=date:from:to:cc:subject:message-id;
  bh=tzmxgyjlRh1Bcs8wyT/PurkgjJIxoAotpZY7mffUuHU=;
  b=lxwfTh66dZRbxkX5rf4ZvI+YsduQmAy402ROR1t28TWGF9lEwu2WP23L
   zrw+Nv+cOZLHRAoaJ/utMN73eSMpM+eO5szcmxOKg0IIRf8k7Oltoy0W1
   vh6Qeue8gDYOPgX2Xgcj1nWHRaFacAyFUZrVtjb9pCNr4gz+T60bUsECc
   ifLGbMR+VcPL7GNlCndvKfJHZcSjxd7bZVaHFrynx6lmy9G3Mcxpv2tHe
   oLArTWdyRIPCnMzRneR+JZllZictEhLTpkC5X5qk6HVxOEc8hBJ8MbC3k
   IcYvMxH4QvovpKEsk1FEbO1CgZAa5fX5hF3JUQ0W+Ycc8mLdEBnFMAP2k
   Q==;
X-CSE-ConnectionGUID: 5uqabGNZQ9Sa0mseSmEL/w==
X-CSE-MsgGUID: Y5QNd7QaRh+DyqGMjRpfmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="107039478"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="107039478"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:25:04 -0700
X-CSE-ConnectionGUID: CF7tBJgRRduXNch6kR7lkw==
X-CSE-MsgGUID: racymfY0TZKA2nXeuOcLnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="301601882"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 10 Sep 2026 11:25:03 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4jSF-000000000Pb-44Ty;
	Thu, 10 Sep 2026 18:24:59 +0000
Date: Fri, 11 Sep 2026 02:24:29 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 cf558a250cf4475a8936902b8978fbb6c61016f8
Message-ID: <202609110219.ZSBCJ3ud-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xoj5qmjrm3xpqtj1szm77h4s91r8ynw8
X-Rspamd-Queue-Id: AFAC940004
X-HE-Tag: 1789064705-610608
X-HE-Meta: U2FsdGVkX1/6sMqESYP5C7ZS9Sk7AsiLDOTcfkTCO/1OVMCramQb1MenUPWB05nnqZdVJH0VHTdcymJmiU9TzojZoe8L27wsgM6HPJOvRyZXGlgTxwwSRKOuGfgu3337sq1AWB7InVgUAz1uG3fxmI6m7dFy4t+Ky7yt+l8tk5tZ+12S/mDKemN4F4aPKq9lZfxJa/0zaLEWpeKIsyXDFVqN2sTEAZYebV1p5U+VmTmpTZmWzu0u3/bseSzlqd8uoAGKnUC/JDo6PmkZBBtR5NQMljQnW0g2kK/hwF81VTAQq9nln8Spqa50bQ7dk1awqtSIPzWfe6LqAKC6bjOWQEqIEW6psAczJHp8T3oBiw5pEZVqo9miWUxhocYy0zM9C3uHiMO4ow5IXvQytf8g+tirhDv0XoVXHyCbhyioD1Rkqg4WCYDTelQvlPPLPxCgbBSC/rHxfQTv+sIIsogALX17JjKQRpGFGb8w1UcxfnxB4AjOKIWqVrUVSp9A/FCMTo3vT1OA4H9XyVeBYSET8h+rZXNSZ17PcUwdwKqjrBUrpEtNeU2WpgRgM/OkhGAxY+lF/QIWb46O46vyoQYYoaRieHSmRA2JynDp5nzVDwcsNfQ0/7fv0Gwbe5udd3p7Lw8g8RJJgNk16YCSJokfWPKYN0X7ZI1VJHsHuw/frhiNeGUk+vt3/RhEa3A8rwe9e2q9PVC3ZXiUcr9Sb2ztCISCZJ6ZI/tvOeh4doxjDHrgLzFQVm3QDRdi3en/005/MqtZXbzFtn5W4h/C+3XiVxlPlu7HJttVk+NEEJz+pITOgg4lV4u1kb8Uto57m/p+lqSS92nKvNpVSyE7lPCMqpcdJmJ8/NhQHTiO9v48q++pttWLOAdPzboWcqbHJvoeZbL/+gqruxu4CFUKsD4RcJkNcNETf7kzJ+iE893eikytU1OLCpcghsd11ij3L7/CZj/H7bIBEFFaQFkDmxg
 iAmfp6Zj
 JC9qbjOPR1XFoDBt7x9Rc0TF5dLwjYyxZca8/FnRGaxCSBXYK5PUxBKVy41mZCi5ym3Ly1iCxLMwcGhkSVUhBDwhWMURbxi4w96D/sHP7wH3wWUg1HQ63uPlOwjnu00gbraUoYRtlxxO6aHLD8UKETIjgh8ntu2QgF27XgE7qFSmFTmRgRKzNdIgBdueB7/xBgyND/lOMImuhFhO97qmqaIAIHR75xBAzl/dn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: cf558a250cf4475a8936902b8978fbb6c61016f8  mm/swap, PM: hibernate: atomically replace hibernation pin

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609101047.wFyYfjz9-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-lkp@intel.com

    mm/sparse-vmemmap.c:505:48: error: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
    mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Werror=implicit-function-declaration]
    mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- s390-randconfig-r121-20260910
|   |-- mm-sparse-vmemmap.c:error:implicit-declaration-of-function-device_zone
|   `-- mm-sparse-vmemmap.c:warning:passing-argument-of-vmemmap_shared_tail_page-makes-pointer-from-integer-without-a-cast
`-- x86_64-randconfig-122-20260910
    `-- mm-sparse-vmemmap.c:error:passing-argument-of-vmemmap_shared_tail_page-makes-pointer-from-integer-without-a-cast

elapsed time: 888m

configs tested: 81
configs skipped: 5

tested configs:
alpha               allnoconfig    gcc-16.1.0
alpha              allyesconfig    gcc-16.1.0
arc                allmodconfig    gcc-16.1.0
arc                 allnoconfig    gcc-16.1.0
arc                allyesconfig    gcc-16.1.0
arm                 allnoconfig    clang-17
arm                 allnoconfig    gcc-16.1.0
arm                allyesconfig    gcc-16.1.0
arm64              allmodconfig    clang-24
arm64               allnoconfig    gcc-16.1.0
csky               allmodconfig    gcc-16.1.0
csky                allnoconfig    gcc-16.1.0
hexagon            allmodconfig    clang-24
hexagon            allmodconfig    gcc-16.1.0
hexagon             allnoconfig    clang-24
hexagon             allnoconfig    gcc-16.1.0
i386               allmodconfig    gcc-14
i386                allnoconfig    gcc-14
i386                allnoconfig    gcc-16.1.0
loongarch          allmodconfig    clang-19
loongarch           allnoconfig    clang-20
loongarch           allnoconfig    gcc-16.1.0
m68k               allmodconfig    gcc-16.1.0
m68k                allnoconfig    gcc-16.1.0
m68k               allyesconfig    gcc-16.1.0
microblaze          allnoconfig    gcc-16.1.0
microblaze         allyesconfig    gcc-16.1.0
mips               allmodconfig    gcc-16.1.0
mips                allnoconfig    gcc-16.1.0
mips               allyesconfig    gcc-16.1.0
nios2              allmodconfig    clang-20
nios2              allmodconfig    gcc-11.5.0
nios2               allnoconfig    clang-24
nios2               allnoconfig    gcc-11.5.0
openrisc           allmodconfig    clang-20
openrisc           allmodconfig    gcc-16.1.0
openrisc            allnoconfig    clang-24
openrisc            allnoconfig    gcc-16.1.0
openrisc              defconfig    gcc-16.1.0
parisc             allmodconfig    gcc-16.1.0
parisc              allnoconfig    clang-24
parisc              allnoconfig    gcc-16.1.0
parisc             allyesconfig    clang-17
parisc             allyesconfig    gcc-16.1.0
powerpc            allmodconfig    gcc-16.1.0
powerpc             allnoconfig    clang-24
powerpc             allnoconfig    gcc-16.1.0
riscv              allmodconfig    clang-24
riscv               allnoconfig    clang-24
riscv               allnoconfig    gcc-16.1.0
riscv              allyesconfig    clang-24
riscv                 defconfig    clang-24
s390               allmodconfig    clang-17
s390               allmodconfig    clang-24
s390                allnoconfig    clang-24
s390               allyesconfig    gcc-16.1.0
sh                 allmodconfig    gcc-16.1.0
sh                  allnoconfig    clang-24
sh                  allnoconfig    gcc-16.1.0
sh                 allyesconfig    clang-17
sh                 allyesconfig    gcc-16.1.0
sparc               allnoconfig    clang-24
sparc               allnoconfig    gcc-16.1.0
sparc                 defconfig    gcc-16.1.0
sparc64            allmodconfig    clang-20
um                 allmodconfig    clang-17
um                  allnoconfig    clang-17
um                  allnoconfig    clang-24
um                 allyesconfig    gcc-14
um                 allyesconfig    gcc-16.1.0
x86_64              allnoconfig    clang-22
x86_64              allnoconfig    clang-24
x86_64                    kexec    clang-22
x86_64                 rhel-9.4    clang-22
x86_64            rhel-9.4-func    clang-22
x86_64      rhel-9.4-kselftests    clang-22
x86_64            rhel-9.4-rust    clang-22
xtensa              allnoconfig    clang-24
xtensa              allnoconfig    gcc-16.1.0
xtensa             allyesconfig    clang-20
xtensa             allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

