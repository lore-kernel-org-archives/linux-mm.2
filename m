Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5713CC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 02:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A556B0005; Fri, 10 Jul 2026 22:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B856B0088; Fri, 10 Jul 2026 22:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51C26B008A; Fri, 10 Jul 2026 22:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7870D6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:48:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F27FD14061A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:48:53 +0000 (UTC)
X-FDA: 84974963346.27.D9D6F89
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72DAA180002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:48:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nKwNgtNP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783738132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5Xsf6/FjDj0AEclVPs0xcwd3f1VDMxOxbnLbX7FEkG4=;
	b=EXetOyTDaqikPkd5ZRKFzeGNpKJnlBD8Yr0nSbchDjy7S2C0fmumZbQPTTYDTmmHNFmQg/
	fvoxTFaQsebDFQfZg4YoOT5skHekowWLY1Xyz72yjyPvzqqXHT+K9mvKDqrRShLPhHiGbb
	tSrqCXH7902UZgaEyK0COfhvJPQuTL0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nKwNgtNP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783738132;
	b=XqGu5AjffqzMcnSPqvzYnbaVoIHO5dxUW76Zq+nLFbqM1DQUqhPj++ApN/CDEqc/4tyOQG
	h3DkisHBHSbfkl84mZHGvzHmTbevblaDlZaUDjFIueYP5xh99vukN9y/ndTn9MA6E2i26d
	VMXpxBNE57YPdtHT1fFIh+6dXEGvu3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783738132; x=1815274132;
  h=date:from:to:cc:subject:message-id;
  bh=gIIvoR3ytvUl0ilvGsCPrC5AyUQKrO0qV+oM4au+kFQ=;
  b=nKwNgtNPnfJPjLvKOLuX8BsLhhJkmWhcH0t180R2Vw3uabOOuNI8Cke5
   b/vtxgoMHPmuOgtfzhMvOdyU/cI+KANGxQXRM4F+ze69wOwnZPK3Y1fdT
   ZQwAv5I5c+aLUPnwyO45iBfF4MMfxmam2MHEeJx70cvc7g74Oe5Le5zeq
   dziKwHA9OHkbQUv02/pXCAXPAaP+Jh4wqm3nIK2ncYTDlieQptRI2A2Hk
   dC8XfyKYCx9Wf0TYB6sFUF4oK8DVKaPASIdvPcFmQpntDA4xYPEHwjZJP
   DmXfYN2pqTrt7TaXSvpkjB3fHCd1LoUzDvhfNCxrbbySbrHwaKJlFd/p4
   A==;
X-CSE-ConnectionGUID: QYVM6FLIS7qPrjIWWH9c6w==
X-CSE-MsgGUID: ljnu9hnBQseyVylIlnalEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94788524"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94788524"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 19:48:50 -0700
X-CSE-ConnectionGUID: ukHzTCOmSzeUVWi27EiYQA==
X-CSE-MsgGUID: +ZvYQAn8RbKBkiS62Nf6Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="293234522"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 10 Jul 2026 19:48:47 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wiNll-00000000Jfc-0JwL;
	Sat, 11 Jul 2026 02:48:45 +0000
Date: Sat, 11 Jul 2026 10:48:34 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 bpf@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, netdev@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 bee763d5f341b99cf472afeb508d4988f62a6ca1
Message-ID: <202607111010.tZ8tVeZU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 72DAA180002
X-Stat-Signature: ucsskez6iwghai3f4rajs6szg8hc1uc9
X-HE-Tag: 1783738131-39921
X-HE-Meta: U2FsdGVkX1/+syi3W3Olo02aDuiXh+Quk+49IXsZNHoiaj4da/jjOfiQ1NfV8CyYO0B1v2U3v1BqYGgrrFyBn0fzUWX1ETOKypFzCl0dz808iQKCJxFDWpjJOU6N8p3qXE+CAvlU4dftk2QHJSkzz9susme55C6C4mhFW6FhnbGOzhk8YWG19Wh1hSC7Ksx8TVyBQ7IAL4H+lQZCkjmWPZezvkvPP7BXVjvWh2/oROMgKFH31xTnsgsCv4ysM9ECVNpoyYwSC7QtLdW/vxfuCR9X7PZFzhQNeI1t0YdfkAOkgwKgsVEKSP5G0ct4E6vryzltSCWq/bCEF8v66Oxac+/7OfmNETpi28+uoMT1w6qLfEBRgvN98eD5NSq1aNWzXKy38EW46213eOD9QOWA3zYr4dINdmYuGm9L5Sv7gj0W0uw1qUNc9CgrgJpDq6RP9RowjGZrMb2/aHTec7xwNrSFbShrXBp3UgiomMLTovP1Z6HzafUQt0dXPWhkW/lo/hfJzwcbUd9Ko1yAzINeIpIYVa3WMSvjVftyJuPL+y5SwFkR9uDoVnAor7eWDRcs5/RW8V6NkAI9g7TCWA10r5S4a8rCZSqYBMbStY9QMZTkiIFi6ZuFPNZ9KsmfOCsXH6CKqr06P69HGbPHIbl+KEQiQfqwOfW30miFmS9vfLKJOUB+QP1cFHsj+C7xLZZpA9qkObmdb2HHRkH5RzoxCiCHAMfBKD0tin90PeC3116KSbwS11nU7OtecDmZN2DwlmPDe0vfJ/YRQP2HTKEIYP8ZjCz3E9Zca0Dlqv6LKUwpgadeik3K3gXPaWgWQqhNi306Kx4/d4FY+TJK/v04DvsNDZC2j2gGYvbCEkxldIwGgkYp9Ks55HcKX9ktXIr/eXsTrl3k9pgYu/HCxfUalmuXGVLCt+RMRQfL2tmymMC0tp5VkiGeQLDyKqJa9yQygSth4JMDPy3YPdUZyLt
 4iGy2mob
 BZ3bZla1yUKqjYwK3Ldd2GPEY8Egc9RSwsZsa1kLjOpFM28sBJ3EPr6gssGuFhO4yHcYBuSdtIUSg9+ueTyzglRp54HfqZORUEqM6RxABVL1CzhdgWQXZ9eM8hGC8lUVLUVhamWH5d+19Q0BghNh1INIuYKVvH9BNg04+gLZqdIFNxBRyQykQAXhzbk/x68h1lCZ3q5yNFs5owmH7U+9GjHWlvli29cQekBqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: bee763d5f341b99cf472afeb508d4988f62a6ca1  Add linux-next specific files for 20260710

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607110140.JeJZ6GIa-lkp@intel.com

    csky-linux-ld: apparmorfs.c:(.text+0xff8): undefined reference to `decompress_zstd'
    net/core/filter.c:12578:18: warning: unused variable 'nskb' [-Wunused-variable]
    net/core/filter.c:12578:25: warning: unused variable 'nskb' [-Wunused-variable]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607111003.MvjSYuhg-lkp@intel.com

    drivers/gpu/drm/i915/display/tests/intel_dp_link_test.c:72:59: sparse: sparse: not a function init
    drivers/gpu/drm/i915/display/tests/intel_dp_link_test.c:83:36: sparse: sparse: not a function cleanup

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r123-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- arm64-randconfig-004-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- csky-randconfig-001
|   `-- csky-linux-ld:apparmorfs.c:(.text):undefined-reference-to-decompress_zstd
|-- csky-randconfig-002-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- hexagon-randconfig-001-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- i386-buildonly-randconfig-001-20260710
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- i386-buildonly-randconfig-001-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- i386-buildonly-randconfig-004-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- m68k-randconfig-r073-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- microblaze-randconfig-r122-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- parisc-randconfig-002-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- powerpc64-randconfig-002-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- riscv-randconfig-001-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- sparc64-randconfig-001-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- um-randconfig-001-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- um-randconfig-r054-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- um-randconfig-r111-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- x86_64-buildonly-randconfig-003-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- x86_64-buildonly-randconfig-006-20260711
|   `-- net-core-filter.c:warning:unused-variable-nskb
|-- x86_64-randconfig-121-20260711
|   |-- drivers-gpu-drm-i915-display-tests-intel_dp_link_test.c:sparse:sparse:not-a-function-cleanup
|   `-- drivers-gpu-drm-i915-display-tests-intel_dp_link_test.c:sparse:sparse:not-a-function-init
`-- xtensa-randconfig-002-20260711
    `-- net-core-filter.c:warning:unused-variable-nskb

elapsed time: 743m

configs tested: 319
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260710    gcc-12.5.0
arc                   randconfig-001-20260711    gcc-13.4.0
arc                   randconfig-002-20260710    gcc-10.5.0
arc                   randconfig-002-20260711    gcc-13.4.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260710    gcc-8.5.0
arm                   randconfig-001-20260711    gcc-13.4.0
arm                   randconfig-002-20260710    gcc-16.1.0
arm                   randconfig-002-20260711    gcc-13.4.0
arm                   randconfig-003-20260710    clang-23
arm                   randconfig-003-20260711    gcc-13.4.0
arm                   randconfig-004-20260710    clang-23
arm                   randconfig-004-20260711    gcc-13.4.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-14.3.0
arm64                 randconfig-001-20260710    gcc-8.5.0
arm64                 randconfig-001-20260711    gcc-16.1.0
arm64                          randconfig-002    gcc-8.5.0
arm64                 randconfig-002-20260710    gcc-8.5.0
arm64                 randconfig-002-20260711    gcc-16.1.0
arm64                          randconfig-003    clang-20
arm64                 randconfig-003-20260710    gcc-16.1.0
arm64                 randconfig-003-20260711    gcc-16.1.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260710    gcc-8.5.0
arm64                 randconfig-004-20260711    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-13.4.0
csky                  randconfig-001-20260710    gcc-10.5.0
csky                  randconfig-001-20260711    gcc-16.1.0
csky                           randconfig-002    gcc-14.3.0
csky                  randconfig-002-20260710    gcc-16.1.0
csky                  randconfig-002-20260711    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260710    clang-23
hexagon               randconfig-001-20260711    gcc-16.1.0
hexagon               randconfig-002-20260710    clang-20
hexagon               randconfig-002-20260711    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260711    gcc-14
i386        buildonly-randconfig-002-20260711    gcc-14
i386        buildonly-randconfig-003-20260711    gcc-14
i386        buildonly-randconfig-004-20260711    clang-22
i386        buildonly-randconfig-004-20260711    gcc-14
i386        buildonly-randconfig-005-20260711    gcc-14
i386        buildonly-randconfig-006-20260711    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260710    gcc-14
i386                  randconfig-001-20260711    clang-22
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260710    clang-22
i386                  randconfig-002-20260711    clang-22
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260710    gcc-14
i386                  randconfig-003-20260711    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260710    clang-22
i386                  randconfig-004-20260711    clang-22
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260710    gcc-14
i386                  randconfig-005-20260711    clang-22
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260710    clang-22
i386                  randconfig-006-20260711    clang-22
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260710    clang-22
i386                  randconfig-007-20260711    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260710    gcc-14
i386                  randconfig-011-20260711    gcc-13
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260710    clang-22
i386                  randconfig-012-20260711    gcc-13
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260710    gcc-14
i386                  randconfig-013-20260711    gcc-13
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260710    gcc-14
i386                  randconfig-014-20260711    gcc-13
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260710    clang-22
i386                  randconfig-015-20260711    gcc-13
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260710    gcc-14
i386                  randconfig-016-20260711    gcc-13
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260710    gcc-14
i386                  randconfig-017-20260711    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260710    gcc-12.5.0
loongarch             randconfig-001-20260711    gcc-16.1.0
loongarch             randconfig-002-20260710    clang-18
loongarch             randconfig-002-20260711    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                malta_qemu_32r6_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260710    gcc-8.5.0
nios2                 randconfig-001-20260711    gcc-16.1.0
nios2                 randconfig-002-20260710    gcc-8.5.0
nios2                 randconfig-002-20260711    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260710    gcc-9.5.0
parisc                randconfig-001-20260711    clang-17
parisc                randconfig-002-20260710    gcc-11.5.0
parisc                randconfig-002-20260711    clang-17
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       eiger_defconfig    clang-23
powerpc               randconfig-001-20260710    gcc-14.3.0
powerpc               randconfig-001-20260711    clang-17
powerpc               randconfig-002-20260710    clang-17
powerpc               randconfig-002-20260711    clang-17
powerpc64             randconfig-001-20260710    clang-23
powerpc64             randconfig-001-20260711    clang-17
powerpc64             randconfig-002-20260710    clang-17
powerpc64             randconfig-002-20260711    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260710    clang-17
riscv                 randconfig-001-20260711    gcc-8.5.0
riscv                 randconfig-002-20260710    clang-17
riscv                 randconfig-002-20260711    gcc-8.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260710    gcc-9.5.0
s390                  randconfig-001-20260711    gcc-8.5.0
s390                  randconfig-002-20260710    gcc-8.5.0
s390                  randconfig-002-20260711    gcc-8.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260710    gcc-16.1.0
sh                    randconfig-001-20260711    gcc-8.5.0
sh                    randconfig-002-20260710    gcc-12.5.0
sh                    randconfig-002-20260711    gcc-8.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260710    gcc-15.2.0
sparc                 randconfig-001-20260711    gcc-16.1.0
sparc                 randconfig-002-20260710    gcc-13.4.0
sparc                 randconfig-002-20260711    gcc-16.1.0
sparc                 randconfig-002-20260711    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260710    gcc-15.2.0
sparc64               randconfig-001-20260711    clang-23
sparc64               randconfig-001-20260711    gcc-16.1.0
sparc64               randconfig-002-20260710    gcc-13.4.0
sparc64               randconfig-002-20260711    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260710    gcc-14
um                    randconfig-001-20260711    gcc-14
um                    randconfig-001-20260711    gcc-16.1.0
um                    randconfig-002-20260710    clang-23
um                    randconfig-002-20260711    gcc-14
um                    randconfig-002-20260711    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260710    gcc-14
x86_64      buildonly-randconfig-001-20260711    gcc-14
x86_64      buildonly-randconfig-002-20260710    clang-22
x86_64      buildonly-randconfig-002-20260711    gcc-14
x86_64      buildonly-randconfig-003-20260710    clang-22
x86_64      buildonly-randconfig-003-20260711    gcc-14
x86_64      buildonly-randconfig-004-20260710    clang-22
x86_64      buildonly-randconfig-004-20260711    gcc-14
x86_64      buildonly-randconfig-005-20260710    clang-22
x86_64      buildonly-randconfig-005-20260711    gcc-14
x86_64      buildonly-randconfig-006-20260710    clang-22
x86_64      buildonly-randconfig-006-20260711    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260710    clang-22
x86_64                randconfig-001-20260711    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260710    gcc-14
x86_64                randconfig-002-20260711    gcc-14
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260710    gcc-14
x86_64                randconfig-003-20260711    gcc-14
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260710    clang-22
x86_64                randconfig-004-20260711    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260710    gcc-14
x86_64                randconfig-005-20260711    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260710    clang-22
x86_64                randconfig-006-20260711    gcc-14
x86_64                randconfig-011-20260710    gcc-14
x86_64                randconfig-011-20260711    gcc-14
x86_64                randconfig-012-20260710    gcc-14
x86_64                randconfig-012-20260711    gcc-14
x86_64                randconfig-013-20260710    clang-22
x86_64                randconfig-013-20260711    gcc-14
x86_64                randconfig-014-20260710    clang-22
x86_64                randconfig-014-20260711    gcc-14
x86_64                randconfig-015-20260710    gcc-14
x86_64                randconfig-015-20260711    gcc-14
x86_64                randconfig-016-20260710    clang-22
x86_64                randconfig-016-20260711    gcc-14
x86_64                randconfig-071-20260710    clang-22
x86_64                randconfig-071-20260711    gcc-14
x86_64                randconfig-072-20260710    gcc-14
x86_64                randconfig-072-20260711    gcc-14
x86_64                randconfig-073-20260710    gcc-14
x86_64                randconfig-073-20260711    gcc-14
x86_64                randconfig-074-20260710    clang-22
x86_64                randconfig-074-20260711    gcc-14
x86_64                randconfig-075-20260710    clang-22
x86_64                randconfig-075-20260711    gcc-14
x86_64                randconfig-076-20260710    gcc-14
x86_64                randconfig-076-20260711    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260711    gcc-14.3.0
xtensa                randconfig-001-20260711    gcc-16.1.0
xtensa                randconfig-002-20260710    gcc-9.5.0
xtensa                randconfig-002-20260711    gcc-16.1.0
xtensa                randconfig-002-20260711    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

