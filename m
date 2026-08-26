Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCFD7C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9E16B008C; Tue, 25 Aug 2026 21:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6336B6B0092; Tue, 25 Aug 2026 21:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD5F6B0095; Tue, 25 Aug 2026 21:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04A3C6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:14:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0E831A0225
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:14:54 +0000 (UTC)
X-FDA: 85141651308.28.61C5BEC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8570D80004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:14:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hyzoSqry;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787706893;
	b=4Lb4I9k2BD2zEGSXMMIDo581zSJt/oY/WMXFrBGQPddFNeQrD8tHc/5IPShnRZZjOB97eg
	iYPHfVZAXiDK1n4VWHsxaCjeBKda2eysKqk/4FfunKEltjquIyHQeWTVJHCeqNxh6UGNWl
	7t29kf5C4zy0WDBSsVk224cOfh5UT9E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hyzoSqry;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787706893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Loo5aXlqhmEYCzEqQyA8Hdx1Q47uKFDOd40l1mDCRhg=;
	b=m0N716pzq/I834iQXm2tj81yBjea0np5fWy506GhjPoqmYU7vxMjN3qFGSuqRBrX9NYYyI
	cB6JIYzTzrTzZooH1r9nfy63eUctEEU4OH/CcG6JtdRXrdSuqF/T9MI6kFv/WlGmyhIn1x
	9JejzFzBraZBnd1naybYD0vmFzXYvVU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787706891; x=1819242891;
  h=date:from:to:cc:subject:message-id;
  bh=MN9m1g5Yz/k5WhNsRHT4dQtbYlDO4tuN8qaTTI6cHE0=;
  b=hyzoSqry6Tvnl/HariHINB+zZklLngLeLV3Tt2LNSU6KGzoCOIyuFi+/
   VUr2rA9YRlxGm9sCPEl+sM78S0uBXH+4w4rgNGQsFWDaKUwT8LnOL8cXH
   g4DZXLc8hmNg2J0/CpDPt1pjmbOYitjkgfgVX++PZgodLc06ExWEua83E
   Ck//e78yOFBkKM2eVx44oS1ukp+PdDaQKhKiXB6ohmb9ryw0TWkPRHjzv
   izVBEm9FKZyjylTzZyyeTURg3C6etZ86UyScu6Cqkdj3mK8hcCKEn70o+
   SK0GYI9ytv5W9D3EJEAGZETjTpe0XzzJxn5ucWsrO21+58s/wgS4cLvYz
   w==;
X-CSE-ConnectionGUID: NOSIiDpuTAm8dmO/YOHZLg==
X-CSE-MsgGUID: BbaNM6w7Qme1M3wSTVyiIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="92002195"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="92002195"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 18:14:50 -0700
X-CSE-ConnectionGUID: SAdetNXoTXyvgPnReeOsHg==
X-CSE-MsgGUID: Sf/SUP8+Q/CJ/oeYgx/ioA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="271224585"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 25 Aug 2026 18:14:48 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wz2E0-000000006iV-2Odw;
	Wed, 26 Aug 2026 01:14:44 +0000
Date: Wed, 26 Aug 2026 09:14:19 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3
Message-ID: <202608260904.mMJZXd01-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: zgodi7n1wbbx575ercnmc9e73z1bitdd
X-Rspamd-Queue-Id: 8570D80004
X-Rspamd-Server: rspam06
X-HE-Tag: 1787706891-890405
X-HE-Meta: U2FsdGVkX1/Ed3AOmKOuh6sKIjVXWlojtV6DXyVXGp4PgKfJVefb+TJaOybsy78mZ9GyqxC/mYyAOggP5jwQ+NagPy3f47Ue1kdYhscBYXmmuTgpCsmCxokrqNahNsr5D5nc+81XcWF7wfeqz3MzHAPwXP/lC/7iccNs+2MtTCiVucXFntpA1RS/egehsOKrnzx7YaepOQB076kmTWAn1367aY+cZGCd0+sveHoh6SYxREWgLDx6AX0AKA1sVctX4KQpKbfY9Pom96RIyWpr4z8mh+AoYyqqJ9qTqn2zg6Ugvp/R4QuZUA4jWWCB4aAG75fAhtzc5/pGua3nOBR1l1mywp8HnOBZoRp4EVyvBHEaJHKNqBRyyoi2tSnjX5S8pGIKTI+avl+ghR0kF7n1y+9uTCkn/0qq2XM5fZR4OACKPcKIimL72li0uUdpWlXSRvr3gzCqsuY4Pu1U6T42+Xj6D/h3B7ob3bvppO/ZgzcqDHcmacyy6v67bICcnJ51YxIVS+PAAzOf9x56wWVNUPoA7+VlzqHFMngdmSRa1rlZMEcLrtCBsGBerEKjg47+shZZ4UMTsFbvP6zR2tt4hqFJf6Yxago4OQg9AZiNRnmda6M1hd8tfL9M9wz36Tb0Mm1odFZXAZLeZ9UGVkbEh3SdlxyJ09wDT4D0poqSoUchPuRmR93VpzQp9acMTkKJD3ctaJMxZZtbuvVepZT/PNhuuia79HZHGY0ladO8ddscwNyjUD5eBGGq1O6G2A4X0pSsHgsE5IGvBn+HD7Z4IAPCjzYXyBY2rE2lUfXEAEI56iRb7s0e+dtnSYyux0719m7FR7Qud0s/Kmhd4DiZUQ95nPd49ObTFmgCd89PuTFjgf7po+wTF3oBO/Qp7SwEmK8UnoUtadZxpcCNXAoPdd+67EqtjodApKwsEwibyC3E5k/oyjhSutuay37V6rRS2VloQ/jBx32LKtkK1fI
 8Z/5yMJc
 ghxdJH+NsiBR2nMmxnm5L7JLl8CvjUQh5hCBEhIRlZ0R9aVvQteWWRA7Ae20ZT4Azqv9HscWsMYOlG3THPkAOmclYZCKz48loXvz8zDdFRA10b3AHyf9904Y4nvs/WgPFQSZeq3xMu4NZO5fMYXUOU9PcPRGs4NTL8HLpm3pbm53IORcD5VjzcAGNXPf/gFDDNcHGYNCI9xMnkOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 854m

configs tested: 108
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260825    gcc-8.5.0
arc                  randconfig-002-20260825    gcc-8.5.0
arm                  randconfig-001-20260825    clang-20
arm                  randconfig-002-20260825    gcc-8.5.0
arm                  randconfig-003-20260825    clang-24
arm                  randconfig-004-20260825    gcc-13.4.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260825    gcc-13.4.0
arm64                randconfig-002-20260825    clang-24
arm64                randconfig-003-20260825    clang-24
arm64                randconfig-004-20260825    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260825    gcc-11.5.0
csky                 randconfig-002-20260825    gcc-9.5.0
hexagon              randconfig-001-20260825    clang-17
hexagon              randconfig-002-20260825    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260825    clang-22
i386       buildonly-randconfig-002-20260825    gcc-14
i386       buildonly-randconfig-003-20260825    gcc-12
i386       buildonly-randconfig-004-20260825    clang-22
i386       buildonly-randconfig-005-20260825    gcc-14
i386       buildonly-randconfig-006-20260825    gcc-14
i386                 randconfig-001-20260825    clang-22
i386                 randconfig-001-20260826    gcc-14
i386                 randconfig-002-20260825    gcc-14
i386                 randconfig-002-20260826    clang-22
i386                 randconfig-003-20260825    clang-22
i386                 randconfig-003-20260826    clang-22
i386                 randconfig-004-20260826    clang-22
i386                 randconfig-005-20260825    gcc-14
i386                 randconfig-005-20260826    gcc-14
i386                 randconfig-006-20260825    gcc-14
i386                 randconfig-006-20260826    clang-22
i386                 randconfig-007-20260826    gcc-14
i386                 randconfig-011-20260825    gcc-14
i386                 randconfig-012-20260825    clang-22
i386                 randconfig-013-20260825    clang-22
i386                 randconfig-014-20260825    clang-22
i386                 randconfig-015-20260825    clang-22
i386                 randconfig-016-20260825    gcc-13
i386                 randconfig-017-20260825    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260825    gcc-16.1.0
loongarch            randconfig-002-20260825    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260825    gcc-9.5.0
nios2                randconfig-002-20260825    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260825    gcc-12.5.0
parisc               randconfig-002-20260825    gcc-14.3.0
powerpc                     chrp32_defconfig    clang-24
powerpc              randconfig-001-20260825    clang-24
powerpc              randconfig-002-20260825    gcc-8.5.0
powerpc64            randconfig-001-20260825    clang-24
powerpc64            randconfig-002-20260825    clang-24
riscv                randconfig-001-20260825    gcc-13.4.0
riscv                randconfig-002-20260825    gcc-15.2.0
s390                 randconfig-001-20260825    clang-24
s390                 randconfig-002-20260825    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260825    gcc-15.2.0
sh                   randconfig-002-20260825    gcc-9.5.0
sparc                randconfig-001-20260825    gcc-8.5.0
sparc                randconfig-002-20260825    gcc-12.5.0
sparc64              randconfig-001-20260825    gcc-10.5.0
sparc64              randconfig-002-20260825    clang-24
um                   randconfig-001-20260825    gcc-14
um                   randconfig-002-20260825    gcc-12
x86_64              buildonly-randconfig-001    gcc-12
x86_64     buildonly-randconfig-001-20260825    gcc-12
x86_64     buildonly-randconfig-002-20260825    gcc-14
x86_64     buildonly-randconfig-003-20260825    clang-22
x86_64     buildonly-randconfig-004-20260825    gcc-14
x86_64     buildonly-randconfig-005-20260825    clang-22
x86_64     buildonly-randconfig-006-20260825    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260825    clang-22
x86_64               randconfig-002-20260825    clang-22
x86_64               randconfig-003-20260825    clang-22
x86_64               randconfig-004-20260825    clang-22
x86_64               randconfig-005-20260825    clang-22
x86_64               randconfig-006-20260825    gcc-13
x86_64               randconfig-011-20260825    gcc-14
x86_64               randconfig-012-20260825    gcc-14
x86_64               randconfig-013-20260825    clang-22
x86_64               randconfig-014-20260825    gcc-12
x86_64               randconfig-015-20260825    gcc-14
x86_64               randconfig-016-20260825    gcc-14
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260825    clang-22
x86_64               randconfig-072-20260825    clang-22
x86_64               randconfig-073-20260825    clang-22
x86_64               randconfig-074-20260825    gcc-14
x86_64               randconfig-075-20260825    clang-22
x86_64               randconfig-076-20260825    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260825    gcc-14.3.0
xtensa               randconfig-002-20260825    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

