Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFF7CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86EC6B008C; Mon,  4 May 2026 09:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CCF6B0092; Mon,  4 May 2026 09:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D836B0093; Mon,  4 May 2026 09:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B42206B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:43:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D3BDC0976
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:43:16 +0000 (UTC)
X-FDA: 84729853992.07.A50E90D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8BEE410000E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:43:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVCff5+i;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777902194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=B4l/eNliO1yvd0WyzYwX4CToZW3nCfq8DMpsBhFelHc=;
	b=jYLDAvVyka/F+C99PML1mq4SgLMfUuQ3+1mPVb5K0Iu24N5gjXVo65Udcbn6dl1FVfFFEs
	qWG4rueQA2Xap0M0BfAxx/doo0mXV/TR8P3AV/YRCzR+VzuNsFDt9WloBZtHPI5Q5M+mwh
	lYZrPUuMu17vDBHZ41vDDeRlpQ0xaSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777902194; a=rsa-sha256;
	cv=none;
	b=7IEPcOXgO2OADRh3BjIkUkMY2FYj5a9IcFyoICpsp5N2rajUbZ6VEQv2mP25YugxZEZgeH
	NLZGQ8NHB4S++y64Zfg039ivwJrDqOy4fQg5TInqFCsAvBh8l6IwcrTXhozD5bzX+YL2p6
	xuDc2ihSzXl2+jVjjx2f1lVtBooofQc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVCff5+i;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777902193; x=1809438193;
  h=date:from:to:cc:subject:message-id;
  bh=lXUFBMKtKHMcP4YG/D/l3S4QZNbwuhzVGbFID+Lb5BE=;
  b=FVCff5+i+650zXV+Bo8TQ8KzNcMLoIfXQ4jXzHjwOG4qyRBmywIHlEKK
   JAmfVcTztxw62OfTNJLCw2TwaYe7r7QMdtwGlLok2lCg0gwzgzv3TwW+/
   RLx51w/shiUA/5djeRZMtlYpnPslhbo2FnYZd20in0iVRq1YIJWtLpZka
   DOZajpIzHQ8XH19WoE643ZDELTrXBRP5FJUvqGDynSkHNCf+dEniNj8VD
   fIKWq8JP3X0IEnIPJmQkvIpWRprHColP9NjBlURqxjEYMle6r0PxBSNUI
   QWSKKlfXhn0eJ14IFJ3thg9e2o1aXQroASX3BVXmEzRpEJ2tYDve7Un/V
   w==;
X-CSE-ConnectionGUID: pU0L2QOWQli2ypnIhwOXTA==
X-CSE-MsgGUID: bDB90lFpStmiXPh+12C9Pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78620002"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="78620002"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:43:12 -0700
X-CSE-ConnectionGUID: Nr4KljfoSr2ErPoOoYf4ng==
X-CSE-MsgGUID: a+Qp9JQJT+W3IVXkmgsVWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="258868695"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 May 2026 06:43:10 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJtZa-000000003m5-49kP;
	Mon, 04 May 2026 13:43:03 +0000
Date: Mon, 04 May 2026 21:42:13 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7480614ff12ced7ceb0d80be8ada5218a575d62a
Message-ID: <202605042102.lNTjHz0k-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BEE410000E
X-Rspamd-Server: rspam04
X-Stat-Signature: ipjc177qnqee8m6itzato4ty7dxc7a5q
X-HE-Tag: 1777902193-598421
X-HE-Meta: U2FsdGVkX18Zt6VYKD/ums2Fvv0KZVAHO/uyYQJ9oQEo2VL8L3Bd2r1eWDZ26I8z9Rl/tCsMb9VuE2AmgJ1bNNx5xKz9zlCfLdnwE8GH0FshlW5RphZvcjqgYudMoHT/O1wsz5mD+2bP1NZd+KM+p72xLzWi6I3Ibi0TEMoPf/N7pGcP9fkemQYJzM7scGHIxNfE9dIjt8WGfllBxOB1zg2j6WW2ZzBKimu5FARdzjd3+uUhAzPLhIQg0aGmq+VSpnFkbSqGSA8PGMPRp1wpLOH6h/kysg8bHdGnXOSmdrDzEzUf5/kLFIDSFZ8Sn/j1KphgkLcfBAVnOHhG3Pme7dEda80QyOfywARKjLbr9Xs3U+gRqFreT26iArn+S0ATmAd9Ma0sbhhl4HLGYNTfz+fRGuNHNNWQBwI6EuEZXPS2bMFlG5BgoJ6uhkhyFT89nbLcIgXXpCddltBZ5nOGoC5JzbpphuOhuHX0VKPIwSiio8o8Jy6oej/d2AfZa2GPlFJp9cKU987XcPa0ZUUJ0x4601dKwTNSPs2FXP1W6BWdjTa741FE382QnkP8w5uVw5XkpSqAQJfvMBrvpKEJVewPQwS2/b4c3MgE6LQV7GvD66j0E1vPuLuhV9UkvaaMSrLyhf4d2y6t3WKYQo7XSbaHKVKkp5mjXnOL9JmmZ3CGyhiAcdzjamABAya1vh4rG+RcjcQkY551kM7BGzN0G9qK8ndcTxudUk+Vkd9Vz8iRZBby5fPphmM4O7HPI+DpTZcwTtGxhTZjD3NzLcBzIBqhsC+EQR1vzbgJSNRetfiSFS/vYqNYCio2lVuJV6UoU/whPVhLFewWU2xQUFRBNWaZ7UbywcMHuuEhBNMe+jxvt2Jkyls7KkunTSEtMECIZFZZmGdb7/Lnc42BYOZVkuaMxu7fCMPyZjpEDM7fCS3MgpcXLXeIUyxk9n3Q9nUqIWyKfDqzgHvLLvmzwu9
 5tDjh69P
 6SjqWLyR76Clrz4HNgeI1keXUpUIp3iXZ9dHieAzkhSZH0o/7LyLQk3QQE/wb8S2kJQmfJHQOQrbbkHhid6g9qPPVzKbvBcG3X0bHTC+AdItODvmdC5po5jkunAKayejmsFVgNCYEmPqcYNaTjFIPq/iw5f0XpW87lFkg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7480614ff12ced7ceb0d80be8ada5218a575d62a  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

elapsed time: 786m

configs tested: 155
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260504    gcc-12.5.0
arc                   randconfig-002-20260504    gcc-13.4.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260504    clang-20
arm                   randconfig-002-20260504    clang-23
arm                   randconfig-003-20260504    gcc-13.4.0
arm                   randconfig-004-20260504    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260504    gcc-8.5.0
arm64                 randconfig-002-20260504    gcc-8.5.0
arm64                 randconfig-003-20260504    clang-23
arm64                 randconfig-004-20260504    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260504    gcc-15.2.0
csky                  randconfig-002-20260504    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260504    clang-23
hexagon               randconfig-002-20260504    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260504    gcc-14
i386        buildonly-randconfig-002-20260504    gcc-14
i386        buildonly-randconfig-003-20260504    gcc-12
i386        buildonly-randconfig-004-20260504    gcc-14
i386        buildonly-randconfig-005-20260504    gcc-14
i386        buildonly-randconfig-006-20260504    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260504    clang-20
i386                  randconfig-002-20260504    gcc-14
i386                  randconfig-003-20260504    gcc-14
i386                  randconfig-004-20260504    gcc-14
i386                  randconfig-005-20260504    gcc-14
i386                  randconfig-006-20260504    clang-20
i386                  randconfig-007-20260504    clang-20
i386                  randconfig-011-20260504    clang-20
i386                  randconfig-012-20260504    clang-20
i386                  randconfig-013-20260504    clang-20
i386                  randconfig-014-20260504    clang-20
i386                  randconfig-015-20260504    clang-20
i386                  randconfig-016-20260504    gcc-13
i386                  randconfig-017-20260504    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260504    clang-18
loongarch             randconfig-002-20260504    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           ip22_defconfig    gcc-15.2.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260504    gcc-11.5.0
nios2                 randconfig-002-20260504    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260504    gcc-13.4.0
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260504    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260504    gcc-12.5.0
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260504    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260504    gcc-10.5.0
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260504    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260504    gcc-8.5.0
riscv                 randconfig-002-20260504    gcc-8.5.0
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260504    clang-23
s390                  randconfig-002-20260504    gcc-13.4.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260504    gcc-10.5.0
sh                    randconfig-002-20260504    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260504    gcc-12
x86_64      buildonly-randconfig-002-20260504    clang-20
x86_64      buildonly-randconfig-003-20260504    clang-20
x86_64      buildonly-randconfig-004-20260504    gcc-14
x86_64      buildonly-randconfig-005-20260504    clang-20
x86_64      buildonly-randconfig-006-20260504    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260504    clang-20
x86_64                randconfig-002-20260504    clang-20
x86_64                randconfig-003-20260504    gcc-14
x86_64                randconfig-004-20260504    clang-20
x86_64                randconfig-005-20260504    clang-20
x86_64                randconfig-006-20260504    clang-20
x86_64                randconfig-011-20260504    gcc-14
x86_64                randconfig-012-20260504    gcc-14
x86_64                randconfig-013-20260504    gcc-14
x86_64                randconfig-014-20260504    gcc-14
x86_64                randconfig-015-20260504    clang-20
x86_64                randconfig-016-20260504    clang-20
x86_64                randconfig-071-20260504    clang-20
x86_64                randconfig-072-20260504    gcc-14
x86_64                randconfig-073-20260504    clang-20
x86_64                randconfig-074-20260504    clang-20
x86_64                randconfig-075-20260504    gcc-14
x86_64                randconfig-076-20260504    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

