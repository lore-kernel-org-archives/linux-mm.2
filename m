Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745E9FEA82D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AE66B0005; Wed, 25 Mar 2026 03:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC166B0089; Wed, 25 Mar 2026 03:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DADD6B008A; Wed, 25 Mar 2026 03:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD0E6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:29:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 209D35AC60
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:29:10 +0000 (UTC)
X-FDA: 84583759260.05.EDE1958
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5561B180009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:29:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BkF1yjxk;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=S2eiQdbLAabTCWUScAso26nGlen3M9QfEd7UfRQfoM0=;
	b=6A5Kjg7anNHNr0Tl0Rsd2qSlakepae9O33JcFy01tLur1pPe1RkHLKVD/+9oyJwGvqHXZW
	WLBWbYUtLfij5FvKjjNThxs9ztKsqL0ArizyeDLtWhXB23M8eM0kFUEcCMfua1oyb4qUgp
	Fg9DJ6BU11lm7aKfdxFM0KYK4Uq3yoY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BkF1yjxk;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774423748; a=rsa-sha256;
	cv=none;
	b=gPN7grL8pfwqmfMrshD2W9rSYVKvjWXHMP/u5ft5FEMEEyFE1zze/KKENfJKC9Ocv+dwRp
	RhlMpkRD9VNQXgDEy7eZjek4oNzJQdxKiWkPR+4+iyM0nq5xKzu3Igx/uOz3xoseX6DCxO
	V0JHbWjyaMZFNkFKq03fAtGSdB3tv0c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774423748; x=1805959748;
  h=date:from:to:cc:subject:message-id;
  bh=x86ExHlm4rBDT1l17Evd8gE25+wNPNw08NaF0cpgP7M=;
  b=BkF1yjxkQl8VL4VzX+OhHwBsQszWZZXv/QUiAYgZWrz6p4lRqcGke9Ri
   KKe3MJY3kAfusNywQLlrEnGqX7hoHuQ8wmqptLba6mOYqs0az0wo1JJuA
   /vpRREb8ZhTSpxdDGTUMxNzuLebNWoO/WJl4D9KNLQMwsFZ7/h628w6nA
   H0CQ5eFhhDgPHJR5E2zXhqp7flZkXTHLJhoK6MPR3vuDyljDGfDzEn/Ry
   D9kC+fgIvHBTtN37c5MR0SIRXAwz4vAUGcWOQoVpr0GUHRXPjz275ok2v
   7dKePbkdTo+lFz/GmJ8Jn/dM2fftmN3ZAuR8Nts7F7/cIsXW8y82fN84A
   A==;
X-CSE-ConnectionGUID: S6ue8jWxRo20ABZK3HaMpw==
X-CSE-MsgGUID: GMbJDiW1SnGK3IeeNqG2zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="85764359"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="85764359"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 00:29:06 -0700
X-CSE-ConnectionGUID: bEFl0VV4Sta0VeL817kFVQ==
X-CSE-MsgGUID: QVz9JoUeQ4KQu9tmwy7Q7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="224861949"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 25 Mar 2026 00:29:04 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5Ifl-000000006Px-1nUp;
	Wed, 25 Mar 2026 07:29:01 +0000
Date: Wed, 25 Mar 2026 15:28:16 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 85964cdcad0fac9a0eb7b87a0f9d88cc074b854c
Message-ID: <202603251503.GBWTiJeU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5561B180009
X-Stat-Signature: s1gymd1upnfdhxbm9orbis5gpn9c81am
X-Rspam-User: 
X-HE-Tag: 1774423747-531737
X-HE-Meta: U2FsdGVkX19LtADSyrNQRVarK4cgRLLTbyyCI5FOWGPHnG7n2T6V0lHVueTn8mGgC9g5r2LKhPwh7eCTuxD2/iDfm6JwmxhvVdRJvMxSJKy+0FZo5SKmfogFqTATQ3nvdgmjzSFNkcHZ0C1vH1DS6+Z66jb3q2KmL9IE0f0SW/1eWo43Rvg2VSqrrU0zOcEDu9bKpCEGzrxY+EXJXfIVxFIgeG3vCQPfiAL7bxtz2VFMixsUDEIdNu37aWf8XSQjVWDzwu7lSiB5Qvu8/CqdHkD5FZRS4M7X70H8tChWkGFRzKqdQZNu2bFp08MzHR2Zbm2ZwCcSBCGC0NBQrruysqMkH7RvdMY3WNdTbq9JHmpFZ5aB984MUpZPvVkMSZ6RHddN5LXp3GTK9SyttPCYueeP9Qgf/AUsdZDyFbJr/B1YEbZXVTDTh4ypTHKSl/ukcQeNN1E6H2UNZlI8Aqfqg9eqWvIT1yDCiqFrydkM/qaYPt57xqLPxRcLSes0bkKor/HNwbGe4Swa5YDi862JoEbWhJt7j7bjHv9kSp8XC5UE08cSxKMu0t2CrhNkHekKHW2e3g0xnJE4yyVMg8y9XlyorGyrwKTBXVEZVVBNBwXhQdu2yUu16GAR7NrGE9QZN6mKfwVbh8Y2rHA0fQ1HMuMXLvUnsP+SslfC1u+cc3iYfkSvqpA1eBxNQY6UpzvHULmMbpLDVjAG3WSg0/j7hqqPHTeBXzgU+JEOvTObTMClYA2VWpBV12NqLIlfOrAAvwLtkjuj8l7teIyGsFelC1DbZVz5btwDSMfwPVTTNay5e+y4UCpVIv2RQoJDoDMMAJlqLLjgeBzd3zSy+h8tPXXwKsaxVEYY9XyTcH2rk337o7JGs0Xd8mUtI1Oms5RxxEg5/mS/KBE1xjCF8drlcKSbgxwA8KGeS+JM7xSCtBBgMDAgBARefLhDo0Jr+waKLql5TBTgppMCS4OyxD/
 l60CR1fu
 zV/MEU6HUd3+k1UqNFEDZofRZLlN4SU/vKxa7zThJFfWMY4jN8CTk7PdwnvrQDZxD7a2J7RXl9dH0hQNZwGu5g9Sw+yqHnUULZybOwjdI6PB3Jcfg7fkvE3bsP1BAAS0ZKirgnn0bgNqBDm3Qd8AqEhb4taTlsjOdWsgVSf2sATytRO6yFT8R8333aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 85964cdcad0fac9a0eb7b87a0f9d88cc074b854c  Add linux-next specific files for 20260324

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603250506.A6rmlvj4-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603251229.dyjK0AWy-lkp@intel.com

    ERROR: modpost: "__udivdi3" [fs/nilfs2/nilfs2.ko] undefined!
    bmap.c:(.text+0x239c): undefined reference to `__aeabi_uldivmod'
    include/linux/drbd_protocol.h:587:2: warning: field  within 'struct p_twopc_request' is less aligned than 'union p_twopc_request::(anonymous at include/linux/drbd_protocol.h:587:2)' and is usually due to 'struct p_twopc_request' being packed, which can lead to unaligned accesses [-Wunaligned-access]

Unverified Error/Warning (likely false positive, kindly check if interested):

    error[E0425]: cannot find function `is_vmalloc_addr` in crate `bindings`
    fs/ntfs/mft.c:1417 ntfs_mft_bitmap_extend_allocation_nolock() warn: inconsistent returns '&mftbmp_ni->size_lock'.
    fs/ntfs/mft.c:1849 ntfs_mft_data_extend_allocation_nolock() warn: inconsistent returns '&mft_ni->size_lock'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20260325
|   `-- bmap.c:(.text):undefined-reference-to-__aeabi_uldivmod
|-- arm-randconfig-002-20260325
|   `-- include-linux-drbd_protocol.h:warning:field-within-struct-p_twopc_request-is-less-aligned-than-union-p_twopc_request::(anonymous-at-include-linux-drbd_protocol.h)-and-is-usually-due-to-struct-p_twopc_
|-- riscv-randconfig-r073-20260325
|   `-- error-E0425:cannot-find-function-is_vmalloc_addr-in-crate-bindings
|-- s390-randconfig-r073-20260325
|   |-- fs-ntfs-mft.c-ntfs_mft_bitmap_extend_allocation_nolock()-warn:inconsistent-returns-mftbmp_ni-size_lock-.
|   `-- fs-ntfs-mft.c-ntfs_mft_data_extend_allocation_nolock()-warn:inconsistent-returns-mft_ni-size_lock-.
`-- xtensa-randconfig-r062-20260324
    `-- ERROR:__udivdi3-fs-nilfs2-nilfs2.ko-undefined

elapsed time: 754m

configs tested: 168
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260325    gcc-15.2.0
arc                   randconfig-002-20260325    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260325    gcc-8.5.0
arm                   randconfig-002-20260325    clang-23
arm                   randconfig-003-20260325    clang-23
arm                   randconfig-004-20260325    clang-17
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260325    clang-23
arm64                 randconfig-002-20260325    gcc-11.5.0
arm64                 randconfig-003-20260325    gcc-8.5.0
arm64                 randconfig-004-20260325    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260325    gcc-10.5.0
csky                  randconfig-002-20260325    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260325    clang-19
hexagon               randconfig-002-20260325    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260325    gcc-14
i386        buildonly-randconfig-002-20260325    gcc-14
i386        buildonly-randconfig-003-20260325    clang-20
i386        buildonly-randconfig-004-20260325    clang-20
i386        buildonly-randconfig-005-20260325    clang-20
i386        buildonly-randconfig-006-20260325    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260325    clang-20
i386                  randconfig-002-20260325    clang-20
i386                  randconfig-003-20260325    gcc-14
i386                  randconfig-004-20260325    clang-20
i386                  randconfig-005-20260325    gcc-14
i386                  randconfig-006-20260325    clang-20
i386                  randconfig-007-20260325    clang-20
i386                  randconfig-011-20260325    gcc-14
i386                  randconfig-012-20260325    gcc-14
i386                  randconfig-013-20260325    gcc-14
i386                  randconfig-014-20260325    gcc-14
i386                  randconfig-015-20260325    clang-20
i386                  randconfig-016-20260325    clang-20
i386                  randconfig-017-20260325    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260325    clang-23
loongarch             randconfig-002-20260325    clang-23
m68k                             alldefconfig    gcc-15.2.0
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
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260325    gcc-8.5.0
nios2                 randconfig-002-20260325    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260325    gcc-8.5.0
parisc                randconfig-002-20260325    gcc-14.3.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260325    clang-23
powerpc               randconfig-002-20260325    clang-23
powerpc64             randconfig-001-20260325    clang-23
powerpc64             randconfig-002-20260325    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260325    clang-20
riscv                 randconfig-002-20260325    gcc-14.3.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260325    clang-23
s390                  randconfig-002-20260325    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260325    gcc-15.2.0
sh                    randconfig-002-20260325    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260325    gcc-8.5.0
sparc                 randconfig-002-20260325    gcc-14.3.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260325    clang-23
sparc64               randconfig-002-20260325    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260325    gcc-13
um                    randconfig-002-20260325    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260325    gcc-14
x86_64      buildonly-randconfig-002-20260325    gcc-14
x86_64      buildonly-randconfig-003-20260325    gcc-14
x86_64      buildonly-randconfig-004-20260325    gcc-14
x86_64      buildonly-randconfig-005-20260325    gcc-14
x86_64      buildonly-randconfig-006-20260325    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260325    gcc-14
x86_64                randconfig-002-20260325    gcc-14
x86_64                randconfig-003-20260325    clang-20
x86_64                randconfig-004-20260325    clang-20
x86_64                randconfig-005-20260325    gcc-14
x86_64                randconfig-006-20260325    gcc-12
x86_64                randconfig-011-20260325    clang-20
x86_64                randconfig-012-20260325    gcc-13
x86_64                randconfig-013-20260325    gcc-14
x86_64                randconfig-014-20260325    gcc-14
x86_64                randconfig-015-20260325    clang-20
x86_64                randconfig-016-20260325    gcc-13
x86_64                randconfig-071-20260325    clang-20
x86_64                randconfig-072-20260325    gcc-14
x86_64                randconfig-073-20260325    clang-20
x86_64                randconfig-074-20260325    gcc-14
x86_64                randconfig-075-20260325    gcc-14
x86_64                randconfig-076-20260325    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260325    gcc-13.4.0
xtensa                randconfig-002-20260325    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

