Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A811C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D346B0088; Thu, 30 Jul 2026 14:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DBE6B008A; Thu, 30 Jul 2026 14:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C906B008C; Thu, 30 Jul 2026 14:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E866B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:39:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B990140273
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:39:04 +0000 (UTC)
X-FDA: 85046305008.29.B6AF0C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA1A320004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:39:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lEsEG29h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785436742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/Whp4I0o87zJ8g9gPpVpcQ7qNGVrWT0goRI3lu1D6Q4=;
	b=KZzPQMYclKrNG+YeJbZ7b49/Fv1HjYJ1xQ0xUR8C+AY2q8CIyg63ziIFnajwBkMX5H57CW
	CgDEYHCRB+CjTTyFGcruHvyJ5CExQol9f/qKUvLGKUDq9fo62XCOFgJWI83hHThkL6RugC
	GozTsl4msbuma0T8ZummDETZu/A7nic=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lEsEG29h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785436742;
	b=2dQdK4Scre9Zi8bx1d0wd8VrEOzHCG7TMABZkWcRAU+KCrsRULfkxNaOGabExlZfvxk2iI
	SconBkppIhN3EsQghkIsq8vSXx9nIgVNpHoa76yXn6UmTHTFQWtuQ0XOIpqSENjtK+lO7/
	4vt4rpVdPpYV/l+LL+0LNEPKqjK/+gw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785436742; x=1816972742;
  h=date:from:to:cc:subject:message-id;
  bh=FiYRzNq//ikoFu5lJJx3OhSlchMi+agI9pTLRjMQID0=;
  b=lEsEG29hIAcPSxB09GS6ujJn1LxZIsWmy5GwXkk632/8n5jD/IsMQtDi
   pPNG5XPVwXPtvNDwbCijetzDJyVdfRUAxjNgXCO1LeUUKfSHq1MYEaEzD
   46vV/SE0vK5hiEdnkiQRPVwe9nuhGNotavKEmYC6WppbiYGiKCBatqos2
   kUBSm7pLfPXf3R7+4EVrigeHhiA6AcU1nkkMv9uvm/TujD5zSbRbkueNS
   XTTAMXbhc8ReHfUj9oI9CYCRBswj2hzNPGK0duPRwGyWI6i7+5KpaFEGY
   MahwNb+FfpjUpqESb4GA+58hOdGPKfTb3xAedPWjCobhP9QM9PnScuCxH
   g==;
X-CSE-ConnectionGUID: bWGSlzbpQsOqZrkGtSOWrw==
X-CSE-MsgGUID: eP8pbyyFQNyW1zj1eCT+Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="85190840"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="85190840"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 11:39:00 -0700
X-CSE-ConnectionGUID: 3+OGcSZaSUydmeOagwMJOw==
X-CSE-MsgGUID: IY885R4iSIW0J8gCeT6IQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="257021696"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 30 Jul 2026 11:38:58 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpVea-00000000hRd-0BBT;
	Thu, 30 Jul 2026 18:38:49 +0000
Date: Fri, 31 Jul 2026 02:38:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 eee677bbc48890b2bcaa42ea7942478302937a09
Message-ID: <202607310219.P81tFJMe-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA1A320004
X-Rspam-User: 
X-Stat-Signature: c13qe76qb7xhiuxqxsoa7benojuk3iba
X-HE-Tag: 1785436741-958198
X-HE-Meta: U2FsdGVkX1+vkHzX5VJHmo1KHWL40xmfX5znbo0/X8w1aozlERZpfB1YyulhBkGnRlgMNM2q/vYaewPjQaBRQ+PWH2TNeYnODilWT4sa/mgWWrJ8sC0KFEafBsl6IO4ZPkXimpKFJWtMZfH2Jk+ZQbUd+bLYqKl0RFsy1awCoZARIRvdAKA0rlzxVgKbBHdd8dWad7mAW3PHdhhUM8n8JPqyTHQTmnch6FcqNcABT/yqAeghFL4Pyyo89G6R4ULgIVSFHxh5zSj9hZgE/oTNxbtCVYTIU0rGOeqdxHs0PTvgqHsErvf/Cm8QDhl4vLAPx4M2+dWqS53TsKOGPHTAenx1QlRBsD4iSs0k7Gxnvh/i7j3LX9TvBHNC5zs4upKNzTDLkViha20Jcbk8sPwQXYRuMRxerN/intgtw0Ugp1VDxFYiz+q20NcsKiWeRguXsjslc/KUEdKNwjQ2FiGg3+3ly2Hgplv04o+x41ICeBs9Ay4lSdeGTGWhJFKwl7Xnc/b6jN19APyoxCU4YzPszkSUoCoG0vLSdaOEvYdurZ7tqt7trfVL56GpWqFADojc+4ayo5bg0bGh9YJApRpGKETQeKWNU+8oAxUIuQtsgRWDoadwg8UJRccF0t6fXxgMGXh+CHf6n5n7D3DZSEFYK7G4fgjag4aPmlz/ERI0frNAG0VwQuSk0ZEj9bnijFFiZgLrX4/XcrpOXRPjAcYJtDVr8so++FpiCN8A2YB9vARWfWFPCU9gvExe+Oaqdg8/s7E6nuAc0ygWoGv35amXbVPQWBnpWK+5QQdEh6CPd6G3IDRP+tgiWLZL9ldsfeam/tnSD+F63HpJT5W8pZr/J8OWc37Tdc5fhqi3jVTBwd9w/c5fHEQKTwYaw3kMH+x3ggng0hyCMBxN5MHFlv5Cmg3I/z9avKs8emjIqISo1uHdOvylCclL6ZXhw9mISTjK3BFfaq7M/FkZ5OXSnwj
 HTIo+UYc
 B7P5fapvn5XOIDxs4jYLqwiKYxAMyGeWLByyNeSVzHa6WDursZduNHGLWvGZ+KL6A7gP84rn9bdHkcOiOKFVGd0uj0SFnvnW6hSSqfxvUo+BbLPxoISWST2a+aCgKSrnbI4Z3WHMamMjqohgCkv+/MVjkZP5Oorym83mSVdwt3C8cijjK9/l+WE9LeysWJKDR7tCy1Hg3i6QWa/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: eee677bbc48890b2bcaa42ea7942478302937a09  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 927m

configs tested: 160
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260730    gcc-11.5.0
arc                  randconfig-001-20260730    gcc-8.5.0
arc                  randconfig-002-20260730    gcc-8.5.0
arm                  randconfig-001-20260730    gcc-8.5.0
arm                  randconfig-002-20260730    gcc-15.2.0
arm                  randconfig-002-20260730    gcc-8.5.0
arm                  randconfig-003-20260730    gcc-13.4.0
arm                  randconfig-003-20260730    gcc-8.5.0
arm                  randconfig-004-20260730    clang-24
arm                  randconfig-004-20260730    gcc-8.5.0
arm                          stm32_defconfig    gcc-16.1.0
arm64                randconfig-001-20260730    gcc-15.2.0
arm64                randconfig-002-20260730    clang-21
arm64                randconfig-002-20260730    gcc-15.2.0
arm64                randconfig-003-20260730    gcc-15.2.0
arm64                randconfig-003-20260730    gcc-8.5.0
arm64                randconfig-004-20260730    gcc-13.4.0
arm64                randconfig-004-20260730    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260730    gcc-13.4.0
csky                 randconfig-001-20260730    gcc-15.2.0
csky                 randconfig-002-20260730    gcc-15.2.0
csky                 randconfig-002-20260730    gcc-16.1.0
hexagon              randconfig-001-20260730    clang-24
hexagon              randconfig-002-20260730    clang-24
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260730    clang-22
i386       buildonly-randconfig-001-20260730    gcc-14
i386       buildonly-randconfig-002-20260730    clang-22
i386       buildonly-randconfig-002-20260730    gcc-14
i386       buildonly-randconfig-003-20260730    gcc-14
i386       buildonly-randconfig-004-20260730    clang-22
i386       buildonly-randconfig-004-20260730    gcc-14
i386       buildonly-randconfig-005-20260730    gcc-14
i386       buildonly-randconfig-006-20260730    gcc-14
i386                 randconfig-001-20260730    gcc-14
i386                 randconfig-002-20260730    clang-22
i386                 randconfig-002-20260730    gcc-14
i386                 randconfig-003-20260730    gcc-14
i386                 randconfig-004-20260730    clang-22
i386                 randconfig-004-20260730    gcc-14
i386                 randconfig-005-20260730    clang-22
i386                 randconfig-005-20260730    gcc-14
i386                 randconfig-006-20260730    gcc-14
i386                 randconfig-007-20260730    gcc-14
i386                 randconfig-011-20260730    clang-22
i386                 randconfig-012-20260730    clang-22
i386                 randconfig-013-20260730    clang-22
i386                 randconfig-014-20260730    clang-22
i386                 randconfig-015-20260730    clang-22
i386                 randconfig-016-20260730    clang-22
i386                 randconfig-017-20260730    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260730    clang-24
loongarch            randconfig-001-20260730    gcc-16.1.0
loongarch            randconfig-002-20260730    clang-24
loongarch            randconfig-002-20260730    gcc-13.4.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260730    clang-24
nios2                randconfig-001-20260730    gcc-11.5.0
nios2                randconfig-002-20260730    clang-24
nios2                randconfig-002-20260730    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260730    gcc-14.3.0
parisc               randconfig-002-20260730    gcc-14.3.0
parisc               randconfig-002-20260730    gcc-16.1.0
powerpc              randconfig-001-20260730    clang-24
powerpc              randconfig-001-20260730    gcc-14.3.0
powerpc              randconfig-002-20260730    gcc-11.5.0
powerpc              randconfig-002-20260730    gcc-14.3.0
powerpc                    tqm8548_defconfig    clang-24
powerpc64            randconfig-001-20260730    clang-24
powerpc64            randconfig-001-20260730    gcc-14.3.0
powerpc64            randconfig-002-20260730    gcc-14.3.0
powerpc64            randconfig-002-20260730    gcc-8.5.0
riscv                         randconfig-001    gcc-15.2.0
riscv                randconfig-001-20260730    gcc-15.2.0
riscv                randconfig-002-20260730    gcc-15.2.0
riscv                randconfig-002-20260730    gcc-9.5.0
s390                 randconfig-001-20260730    clang-17
s390                 randconfig-001-20260730    gcc-15.2.0
s390                 randconfig-002-20260730    gcc-15.2.0
s390                 randconfig-002-20260730    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260730    gcc-13.4.0
sh                   randconfig-001-20260730    gcc-15.2.0
sh                   randconfig-002-20260730    gcc-15.2.0
sh                          se7705_defconfig    gcc-16.1.0
sparc                randconfig-001-20260730    clang-24
sparc                randconfig-001-20260730    gcc-16.1.0
sparc                randconfig-002-20260730    clang-24
sparc                randconfig-002-20260730    gcc-16.1.0
sparc64              randconfig-001-20260730    clang-20
sparc64              randconfig-001-20260730    clang-24
sparc64              randconfig-002-20260730    clang-24
sparc64              randconfig-002-20260730    gcc-14.3.0
um                   randconfig-001-20260730    clang-17
um                   randconfig-001-20260730    clang-24
um                   randconfig-002-20260730    clang-24
x86_64              buildonly-randconfig-001    gcc-14
x86_64     buildonly-randconfig-001-20260730    clang-22
x86_64     buildonly-randconfig-001-20260730    gcc-14
x86_64     buildonly-randconfig-002-20260730    clang-22
x86_64     buildonly-randconfig-002-20260730    gcc-14
x86_64     buildonly-randconfig-003-20260730    clang-22
x86_64     buildonly-randconfig-003-20260730    gcc-14
x86_64     buildonly-randconfig-004-20260730    gcc-14
x86_64     buildonly-randconfig-005-20260730    gcc-14
x86_64     buildonly-randconfig-006-20260730    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260730    clang-22
x86_64               randconfig-002-20260730    clang-22
x86_64               randconfig-002-20260730    gcc-14
x86_64               randconfig-003-20260730    clang-22
x86_64               randconfig-004-20260730    clang-22
x86_64               randconfig-004-20260730    gcc-14
x86_64               randconfig-005-20260730    clang-22
x86_64               randconfig-006-20260730    clang-22
x86_64                        randconfig-011    clang-22
x86_64               randconfig-011-20260730    clang-22
x86_64               randconfig-011-20260730    gcc-12
x86_64               randconfig-012-20260730    clang-22
x86_64               randconfig-012-20260730    gcc-14
x86_64               randconfig-013-20260730    clang-22
x86_64               randconfig-013-20260730    gcc-14
x86_64               randconfig-014-20260730    clang-22
x86_64               randconfig-015-20260730    clang-22
x86_64               randconfig-016-20260730    clang-22
x86_64               randconfig-016-20260730    gcc-12
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260730    gcc-12
x86_64               randconfig-071-20260730    gcc-14
x86_64               randconfig-072-20260730    gcc-12
x86_64               randconfig-072-20260730    gcc-14
x86_64               randconfig-073-20260730    clang-22
x86_64               randconfig-073-20260730    gcc-12
x86_64               randconfig-073-20260730    gcc-14
x86_64               randconfig-074-20260730    gcc-12
x86_64               randconfig-074-20260730    gcc-14
x86_64               randconfig-075-20260730    clang-22
x86_64               randconfig-075-20260730    gcc-12
x86_64               randconfig-075-20260730    gcc-14
x86_64               randconfig-076-20260730    clang-22
x86_64               randconfig-076-20260730    gcc-12
x86_64               randconfig-076-20260730    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260730    clang-24
xtensa               randconfig-001-20260730    gcc-16.1.0
xtensa               randconfig-002-20260730    clang-24
xtensa               randconfig-002-20260730    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

