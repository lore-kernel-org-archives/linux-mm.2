Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D9FC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 04:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8F46B007B; Sat,  1 Aug 2026 00:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869BE6B0088; Sat,  1 Aug 2026 00:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757746B008A; Sat,  1 Aug 2026 00:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39F396B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:00:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8554120208
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:00:17 +0000 (UTC)
X-FDA: 85051348074.27.E5FD188
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id B98ADA0006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:00:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pp6Y7scz;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785556815;
	b=HOPR7HA2pQKhXiYZSHQmu8O41e5iE/epE0ecEliydSpCnMbJooQdH8Hj7Gw4h1iEfGyJgx
	Znn3XqWTbryjjInVsxBMkSXBCDFK3AXRaohAv7htZhHqST1LvwgnhP0pkBOjdbLBI3sYd7
	rWH1v8yviuUdvQbgDP0nQAA6hAifTvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pp6Y7scz;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785556815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7ApH4QkiqPNgNnpjR0pMvRisqbHHlBUkcRi45oPDtyQ=;
	b=iNhcYPN+rgwPdVNa8ZT4CTUmPMizkX+3y9mZN4uSAV9oQDiDf/vh5OjtHyt9L74W9TRHG+
	7ZSNDy6pav3qj/Q0c+LQIGjmdQrxynG/rXShYiwLpm0Cz8+ARv9ay/A8Ugfwo/S/lka0ze
	w+jTkoBOwjvKcUU4FvRoK6Q84T5g27o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785556815; x=1817092815;
  h=date:from:to:cc:subject:message-id;
  bh=7nUDrQMpdp8B/2IGadLa7D6zOIyf/M5G8NhUW2iIuk8=;
  b=Pp6Y7sczVtS62FyuhLEaBK7q3USd4YXYuhVt5RmugXBUsXrqYaPc3D4P
   SR+qVZUIgI8CZaFhEWDjCvzhOpXPIGattPijxcS1ezh+N8Nmjlbw1rQU7
   Blq+C6iuXp5Z+CMRqby9lpXKZ3VgAkfb95AvguGU6UPk0fSedYeZM6zc4
   0ZFaV6A3pqtTCzP6fT1aIw6K5RAbBs5OvuyacxfdEog1m4J5Ru5VQpdz+
   DJZNrzAJcKJ23zSLDkEHEpZB8+0/xzf0T7TtSmq7EufE0gWMzuhQicTFM
   yE4HfG9dJR/rgQdr6FvxQq5PWU3Dj4wVZuHJKnJkeWGs/9wwMrP1PRFzT
   g==;
X-CSE-ConnectionGUID: hAyEPLG/QqSVwRFrCLIiFg==
X-CSE-MsgGUID: TGVxAJFfSpmWzv+QCC5tqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="97336113"
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="97336113"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 21:00:14 -0700
X-CSE-ConnectionGUID: DnDHkbO4SiOvaw0fp3jpaw==
X-CSE-MsgGUID: udX62kEaTQOIj+Cs9er0RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,197,1779174000"; 
   d="scan'208";a="259491084"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 31 Jul 2026 21:00:12 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wq0tN-000000002iv-3aKB;
	Sat, 01 Aug 2026 04:00:09 +0000
Date: Sat, 01 Aug 2026 11:59:32 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 9e25ce807d1c5df0fb7ec68cc9eb4253ac4bd055
Message-ID: <202608011116.FOaI6WWp-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: yi5m6zjtg4jh3f53c7ep1w7djyhwc79o
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B98ADA0006
X-Rspam-User: 
X-HE-Tag: 1785556814-413832
X-HE-Meta: U2FsdGVkX1+Nm0eyDheng3d9sEzjRLfoiL5QuED+QNt4C+brRGJH4nT2wmDUjy1iPXjZDk4GmwewAZxuuU53kvlyhLx3tr2usA+QH74aoI5tWjCdjyALxoY4J4menNB22WFYRTA54z5BfzYgGIgmG11bk0bzKkpdaiwLTzn2YLFzCkPrk78i61zYAnblQQ2+ySunnsN8LBqhhLmCRGmjnqPE4GJtS6YJgAKarp1jI/cuyr9cyywCqvVTGiNgsdGAhcYrL7yWRKZV+5oW2ya+2i/Y8F7f6sWXaxYGAAhaA1gAc+ab1XFjqX2zABCw9y2XoJYLOekrC0li0a02Sv7mUJauo+XvAkkPU3h2BOGsdnrhm451FFMZ8SeuBO1pm16UzaV8xO+u/oriv/OztK/z531QStrqlL731pB5cRIU7MNOL66/fNNkgMgJFuVgy89K/ziGD2Q2mR/h9oo/t+0OHIC5lB/84kehR/B/1PfGprfF+4MkrGH3rsyntKZEjEkHcbwe1IbWoLKJ/ObPenM/W55FZAeQm3l4k7AY/tykySfDN4SfW4FRMt55GSdhT1zwkAzOMxozqRRj9Cx92z+Ja0kB3ALsbeNZ0iwu/lj9Xu/hfD+sPBHLynWZRy5boq99BafPk+YKud2pBV6pR5LLPAk/QVfKo9fxlPgg0tBJhLE9wlkjb+UO2ReUjlSS8CbwH2eksavBcNVfFfsAGLjCsmxshh1IRrXAht/vF/9LRWniu8qs3o3JnwG17yG3RJKOncmLCOjqI/f8IVaTWqydcQO5aGv5IjeM360q7qbboe3JERY36iRjFAMaNZiDytdASX3XS4QVqM3WL783S7HUXaq4TaXv6kom/+nrhepBZW/tg8MdN0A0qShpl01BACMP0leKyemlJpdXG/nkNhmly4MZ67Ty4LCrvUW0His+kJ82mtS7NrUzsPCKZzCJhNRzEx5xi4QH5p5M9VqTwTv
 amJ1L235
 tE4ePZCrHVWE3phtUHUkURJ7lZ5sYK5CED8UNfHvEqzGkH9v6OG/5rzebU6eYLjPeev/xrza0HlJNghEQbLoeDDupyaWgLlrb0q1BEG2IgHpqw84Ny+8bboRd4omNmdiQLjnbYPDQ6N0XYyWmAFF/mT9n46B9PPX6UO18F8AEQhqrJmTb1wYA4UP8aw56TwwxYoujCFoMf05tcpu4nMEqQRuD8v0E3FJBbzj6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9e25ce807d1c5df0fb7ec68cc9eb4253ac4bd055  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
    mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses

Warning ids grouped by kconfigs:

recent_errors
|-- hexagon-randconfig-r072-20260801
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
|-- i386-randconfig-141-20260801
|   `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses
`-- powerpc-randconfig-r073-20260801
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 786m

configs tested: 102
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    gcc-8.5.0
arc                  randconfig-002-20260731    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-19
arm                  randconfig-003-20260731    clang-24
arm                  randconfig-004-20260731    clang-24
arm                          u8500_defconfig    gcc-16.1.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    clang-24
arm64                randconfig-003-20260731    gcc-10.5.0
arm64                randconfig-004-20260731    gcc-12.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-16.1.0
csky                 randconfig-002-20260731    gcc-10.5.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260801    clang-22
i386       buildonly-randconfig-002-20260801    clang-22
i386       buildonly-randconfig-003-20260801    clang-22
i386       buildonly-randconfig-004-20260801    clang-22
i386       buildonly-randconfig-005-20260801    gcc-14
i386       buildonly-randconfig-006-20260801    gcc-14
i386                 randconfig-001-20260801    clang-22
i386                 randconfig-002-20260801    gcc-14
i386                 randconfig-003-20260801    clang-22
i386                 randconfig-004-20260801    clang-22
i386                 randconfig-005-20260801    clang-22
i386                 randconfig-006-20260801    clang-22
i386                 randconfig-007-20260801    clang-22
i386                 randconfig-011-20260801    clang-22
i386                 randconfig-012-20260801    gcc-14
i386                 randconfig-013-20260801    gcc-14
i386                 randconfig-014-20260801    clang-22
i386                 randconfig-015-20260801    clang-22
i386                 randconfig-016-20260801    gcc-14
i386                 randconfig-017-20260801    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    gcc-16.1.0
loongarch            randconfig-002-20260731    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    gcc-8.5.0
nios2                randconfig-002-20260731    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260801    gcc-11.5.0
parisc               randconfig-002-20260801    gcc-9.5.0
powerpc              randconfig-001-20260801    clang-20
powerpc              randconfig-002-20260801    gcc-10.5.0
powerpc64            randconfig-001-20260801    clang-24
powerpc64            randconfig-002-20260801    clang-24
riscv                randconfig-001-20260801    gcc-14.3.0
riscv                randconfig-002-20260801    clang-20
s390                 randconfig-001-20260801    gcc-15.2.0
s390                 randconfig-002-20260801    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260801    gcc-16.1.0
sh                   randconfig-002-20260801    gcc-16.1.0
sparc                randconfig-001-20260801    gcc-8.5.0
sparc                randconfig-002-20260801    gcc-11.5.0
sparc64              randconfig-001-20260801    gcc-9.5.0
sparc64              randconfig-002-20260801    gcc-15.2.0
um                   randconfig-001-20260801    clang-17
um                   randconfig-002-20260801    gcc-14
x86_64     buildonly-randconfig-001-20260731    clang-22
x86_64     buildonly-randconfig-002-20260731    clang-22
x86_64     buildonly-randconfig-003-20260731    clang-22
x86_64     buildonly-randconfig-004-20260731    clang-22
x86_64     buildonly-randconfig-005-20260731    clang-22
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260801    clang-22
x86_64               randconfig-002-20260801    gcc-14
x86_64               randconfig-003-20260801    gcc-14
x86_64               randconfig-004-20260801    clang-22
x86_64               randconfig-005-20260801    gcc-14
x86_64               randconfig-006-20260801    gcc-14
x86_64               randconfig-011-20260731    clang-22
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    clang-22
x86_64               randconfig-014-20260731    clang-22
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260801    gcc-14
x86_64               randconfig-072-20260801    gcc-14
x86_64               randconfig-073-20260801    clang-22
x86_64               randconfig-074-20260801    gcc-14
x86_64               randconfig-075-20260801    clang-22
x86_64               randconfig-076-20260801    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260801    gcc-9.5.0
xtensa               randconfig-002-20260801    gcc-15.2.0
xtensa                        virt_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

