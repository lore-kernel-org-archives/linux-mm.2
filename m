Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF479CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74C06B008C; Thu, 30 Apr 2026 04:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D251A6B0092; Thu, 30 Apr 2026 04:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13CF6B0093; Thu, 30 Apr 2026 04:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAC506B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:21:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F6E3160538
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:21:09 +0000 (UTC)
X-FDA: 84714527058.20.930A788
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4E9C80007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:21:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q8bcUoYi;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777537267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=tGeI0TcV+1tyNfIx2rRShfS8bE0Bnx6h7+48OnfD+9k=;
	b=afao0uK7RblcTYFzm+rKBGZCZi6cUlWSbP5a8eCgCYYfHpcXRu5gwK5RrloKgKjQp6u48P
	fCLhjpxKb2W/UMCRn42CdcOBMdvI85BODYa1sQmc0xq+cJzrljivVP547BGRia8e33gDa8
	SgejWrUgleCPoSS3apMexV6hpdBD3iM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777537267; a=rsa-sha256;
	cv=none;
	b=VqTahFzSMciqrbpwrqw3kM/YSobOnzwSanzudtiEfoVsk+togB6NtnbZ303RZ3kJKC5Hep
	GPBFf9IusKSU9MOsEJq71Z0ocWru7ejQSph6r63BP0d0r/44N2LwAvu6dxEUgyJ7Rwj1p8
	YJltcQT/NLaArkBpw3xEJD9YtUuazRg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q8bcUoYi;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777537267; x=1809073267;
  h=date:from:to:cc:subject:message-id;
  bh=e5YUUbVsBnriYW0nJhxqMMyuRi96qeqhwn8a1WW04IU=;
  b=Q8bcUoYiMyzX13Qa/ad2XWdtbL0zw//aCQ/ozQq2staxcVOnAFjQZPqw
   ieg1ojYuwngAcYAkFf4oR7lFj2V60NM00tEi0jGM7fIskDjLdCAaqScyN
   ZzOT+pa+LqBbpmHOPrdHBuceS4jnZNORugJxGFLIDhvX3gXnYs9AkckfC
   kxR8sAtVZHdZTBvJI808G7eNrPx88+HN4ylHaoO6eqOTQNmi0xqAxwA76
   6tNZkteRX97M+ov/NVjFdXFVXKbxHhtM8WxLMk1/Xc0HN6d0YuN1ffrGs
   DAbsC7PW7VL+2UW2MbkXevqEnrMN0+HeqqfAnLhrDg3IfW9Knh9pkY0Ld
   w==;
X-CSE-ConnectionGUID: gdfFrSOdQUqRqBZWOqcTSw==
X-CSE-MsgGUID: MElfcxydSEioPSdwpkj8+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="82344539"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="82344539"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 01:21:05 -0700
X-CSE-ConnectionGUID: 0Yd04r3DRlyvCCWDh1Ezlw==
X-CSE-MsgGUID: xXRWri4BT6W3n6hqr4uiUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="272629444"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 30 Apr 2026 01:21:04 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIMdo-00000000C9c-4AjQ;
	Thu, 30 Apr 2026 08:21:01 +0000
Date: Thu, 30 Apr 2026 16:20:57 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0587fb0c820d86e5b77a975680d79b5176d09abb
Message-ID: <202604301642.qko6fr77-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4E9C80007
X-Stat-Signature: p368yb8yo6esqt6wi9jrtkdb18drmbr6
X-Rspam-User: 
X-HE-Tag: 1777537266-508740
X-HE-Meta: U2FsdGVkX18BRbeTr13MQ+HDhB4Lv8FLu/yTnhycRaCkhUZUKBVfH3aoQ6jXItkpkb5fp/h011DRTV/fRsQoeouD2GCNk4a9x1hW50l0/lzBuKxhQU/qZ7DJWRxEm0ZtNZFOqO1MkO8rQypFor4zDivE0OS2rx+tNgY+HyP4JWyVrNJFoYuGh8OcmvJbNdPD8f/Db+mOY6/ZB6NYB9z2fyfjp2lwynX3rjss3hPHglSwDvKI2e/DRMMYq8mfX1Xk+/NvPhGtf8LE9CrlSZGm4VDDiWVY86rF66ByuuGOi5DCLH7gsysijCEp3WvbwZcv3adz6sMBrKuoDUoszOnyMczNy/jw0QEizS7FmaJU+4yb09vuGTbSGpTdnEVzAqz/i8pZvBt1a+t61d64lLYQFzmOqUoeC65Q6S+1+MLdp8bqNP3ZzI+3WPqUBztW5Y4NTptOuRsvh5BE2Oy/43hjUbDX3RXVbyFjUQ/57gpFhoFq1vk9lF1AQ7RvvaO2t8p7v9e7Aaw9gGjV6lSfcNMp7zXK1TC+/Faw4z1c35M3LzOz697NXzhS9DyqYbbyeJbp3OHORmVffhcq2ig6LcOEafBeNiDHfK7/V7wLuoOjjSFf7/h4P3qSnYQH8AS/GHtqmwdWYTAZBF+g4VYEUYLxP9ytM85ik6xvwSVuzY4Xo+L1hrnJpI0LrsJn+srgpD7ME8+wGzXTYOiO8A4EsliaY8vDoWnT7mfmb6NArHY53fUTP5OCNw8+L+9xTeLOnOo0Mtovwl/cfc6JNfLl+pRKfz8JOrOzmu3llklKQ67xwW56AIvPfsBKga0IF046tf/P6PW2+t+bYkZfsnBkkHg1KfFZpVBPO9ILHRkAPNH0f0JSAQgwjFkoZUtayDZrA26U8UF+jANDRqu1qwaVrSjPZBIY/Ee2TF3D0gGwg20AcMxjzGwSbGH3MNCtT0D+4OTmDgzQjF2mee6X/Z/mxf5
 vGPcKHym
 cwDDLNfdC50L1fZRTEL3dBOGM9Swwdrw1LtwU3D97SjJUw01uiaBvWxn31y3VKmx91PQlPCSFEcgE2KVFj7fS2FoCT03BXMIsK+CA1ryvIVtijX2mQ5bRkK6LnWNsK7705sQsThcOcflyh9V+KrU1ouuatfpyp2hcmTMhLGZkJM03IrS7ajMauLMetA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0587fb0c820d86e5b77a975680d79b5176d09abb  selftests/mm: add writable-file collapse tests for khugepaged

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202604300401.oBmk76Q3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300638.A3yVzhM3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202604300817.QeXlZapz-lkp@intel.com

    arch/riscv/mm/init.c:113:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
    arch/riscv/mm/init.c:116:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
    arch/sh/include/asm/fixmap.h:82:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
    include/asm-generic/fixmap.h:107:26: error: use of undeclared identifier 'PAGE_KERNEL_IO'
    include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function)
    include/asm-generic/fixmap.h:57:24: error: 'PAGE_KERNEL_IO' undeclared (first use in this function)
    include/asm-generic/fixmap.h:77:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:77:2: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Werror=implicit-function-declaration]
    include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
    include/asm-generic/fixmap.h:84:40: error: use of undeclared identifier 'PAGE_KERNEL'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-allmodconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r051-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- csky-randconfig-r113-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allmodconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-allyesconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-randconfig-r052-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-randconfig-r123-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- mips-xway_defconfig
|   |-- include-asm-generic-fixmap.h:error:call-to-undeclared-function-__set_fixmap-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL
|   `-- include-asm-generic-fixmap.h:error:use-of-undeclared-identifier-PAGE_KERNEL_IO
|-- riscv-allmodconfig
|   `-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- riscv-allyesconfig
|   `-- arch-riscv-mm-init.c:warning:implicit-conversion-from-unsigned-long-long-to-u32-(aka-unsigned-int-)-changes-value-from-to
|-- sh-allmodconfig
|   |-- arch-sh-include-asm-fixmap.h:error:PAGE_KERNEL_NOCACHE-undeclared-(first-use-in-this-function)
|   |-- include-asm-generic-fixmap.h:error:PAGE_KERNEL-undeclared-(first-use-in-this-function)
|   `-- include-asm-generic-fixmap.h:error:PAGE_KERNEL_IO-undeclared-(first-use-in-this-function)
|-- xtensa-allyesconfig
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- xtensa-randconfig-r051-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
|-- xtensa-randconfig-r112-20260430
|   `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap
`-- xtensa-randconfig-r122-20260430
    `-- include-asm-generic-fixmap.h:error:implicit-declaration-of-function-__set_fixmap

elapsed time: 796m

configs tested: 160
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260430    gcc-8.5.0
arc                   randconfig-002-20260430    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260430    clang-16
arm                   randconfig-002-20260430    gcc-8.5.0
arm                   randconfig-003-20260430    gcc-12.5.0
arm                   randconfig-004-20260430    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260430    gcc-8.5.0
arm64                 randconfig-002-20260430    clang-23
arm64                 randconfig-003-20260430    clang-23
arm64                 randconfig-004-20260430    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260430    gcc-15.2.0
csky                  randconfig-002-20260430    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260430    clang-23
hexagon               randconfig-002-20260430    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260430    gcc-14
i386        buildonly-randconfig-002-20260430    clang-20
i386        buildonly-randconfig-003-20260430    clang-20
i386        buildonly-randconfig-004-20260430    gcc-14
i386        buildonly-randconfig-005-20260430    gcc-14
i386        buildonly-randconfig-006-20260430    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260430    clang-20
i386                  randconfig-002-20260430    gcc-14
i386                  randconfig-003-20260430    clang-20
i386                  randconfig-004-20260430    clang-20
i386                  randconfig-005-20260430    clang-20
i386                  randconfig-006-20260430    clang-20
i386                  randconfig-007-20260430    gcc-13
i386                  randconfig-011-20260430    clang-20
i386                  randconfig-012-20260430    gcc-14
i386                  randconfig-013-20260430    clang-20
i386                  randconfig-014-20260430    gcc-14
i386                  randconfig-015-20260430    gcc-14
i386                  randconfig-016-20260430    gcc-14
i386                  randconfig-017-20260430    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260430    gcc-14.3.0
loongarch             randconfig-002-20260430    gcc-15.2.0
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
nios2                 randconfig-001-20260430    gcc-11.5.0
nios2                 randconfig-002-20260430    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260430    gcc-12.5.0
parisc                randconfig-002-20260430    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260430    gcc-10.5.0
powerpc               randconfig-002-20260430    clang-23
powerpc64             randconfig-001-20260430    gcc-13.4.0
powerpc64             randconfig-002-20260430    clang-20
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260430    clang-23
riscv                 randconfig-002-20260430    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260430    clang-23
s390                  randconfig-002-20260430    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260430    gcc-12.5.0
sh                    randconfig-002-20260430    gcc-10.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260430    gcc-12.5.0
sparc                 randconfig-002-20260430    gcc-11.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260430    clang-23
sparc64               randconfig-002-20260430    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260430    clang-23
um                    randconfig-002-20260430    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260430    clang-20
x86_64      buildonly-randconfig-002-20260430    clang-20
x86_64      buildonly-randconfig-003-20260430    clang-20
x86_64      buildonly-randconfig-004-20260430    clang-20
x86_64      buildonly-randconfig-005-20260430    gcc-14
x86_64      buildonly-randconfig-006-20260430    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260430    gcc-14
x86_64                randconfig-002-20260430    gcc-12
x86_64                randconfig-003-20260430    gcc-14
x86_64                randconfig-004-20260430    clang-20
x86_64                randconfig-005-20260430    clang-20
x86_64                randconfig-006-20260430    clang-20
x86_64                randconfig-011-20260430    clang-20
x86_64                randconfig-012-20260430    clang-20
x86_64                randconfig-013-20260430    clang-20
x86_64                randconfig-014-20260430    gcc-13
x86_64                randconfig-015-20260430    clang-20
x86_64                randconfig-016-20260430    clang-20
x86_64                randconfig-071-20260430    clang-20
x86_64                randconfig-072-20260430    gcc-13
x86_64                randconfig-073-20260430    clang-20
x86_64                randconfig-074-20260430    clang-20
x86_64                randconfig-075-20260430    gcc-14
x86_64                randconfig-076-20260430    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260430    gcc-12.5.0
xtensa                randconfig-002-20260430    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

