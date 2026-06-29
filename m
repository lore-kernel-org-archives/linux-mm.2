Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B4EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED3A6B008A; Mon, 29 Jun 2026 14:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4DA6B0092; Mon, 29 Jun 2026 14:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E8B6B0093; Mon, 29 Jun 2026 14:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64C0A6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:02:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2396C13DF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:02:57 +0000 (UTC)
X-FDA: 84933721194.02.0942A40
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B2DF18000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:02:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KEhZi3mD;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782756176;
	b=1uHIuqsIlCxbr+yozbwUuMwCoG0Qx98cCZ1r69hsTiReOkyK2qhGlgUdvIR1Ka3dO8XM7/
	kuZ1gTYFtPVHuuzN7f/R9Ai48Rfm1EXkoi2T3w7U/NgDn+68aVITGioBCNSaYKHc3OHR5N
	v7YctSwiANsI0+3BqJgSuRrYutET4ik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782756176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=aJ7fw3iY0fwpJVJDfvnw9kPKorpKKFZKI5ba4vWy7N4=;
	b=15lEvRT58Mwap0jYiYIrk6VrugIRMl+9iC8JYoLP4OU5ZtSjyLec62CzC3S/SB89g2dbzS
	7WfPp0i1NG/tMaNVrXNNzats5sIgFlET8lfjxmkpfqMLNz4gY8bZ3DPUEfF48KJD8c8Nva
	SMgyuxT0agkieVQ/epfQQ/k8g2YgQ9M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KEhZi3mD;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782756176; x=1814292176;
  h=date:from:to:cc:subject:message-id;
  bh=5l0nY1p02y8SjK80OikSGKD2/7vY3Cgyi6uQzJ4GQjc=;
  b=KEhZi3mDkFX29BuIr+CbH6ta9EX2+hKdm/raaN8X0q3lmaNnswzaYypd
   1UbNA6YeLPqFCLIZWNcZ38Cm5PSDfxHMTwqDpB5q/mR81Wp9cNlDdP1cz
   RA9mzsfzU9oIhkBA15t12VOj0JJGynPOEJY73Na+eV+j/Fno3a9yzrUbi
   Zmd0u+xdi6HFKy0JakQGUCLJcZavMPrshBa5gnMs5jIabcSOvkgoGcHtr
   TMrt37OLRMUYlu7EUWp+5/RMgcITl2VrqlP9wNqirYl5wVL+IJNDBlbHg
   z8WPwAMe1toZ8Ym8NGmtg5uL0pftKSzTV/p+oJZ/K95gEpjEyOeE8CCZ9
   g==;
X-CSE-ConnectionGUID: 9g9HtajfTgS5DVSKE7K/Jw==
X-CSE-MsgGUID: mwTRyD+KQJ+V52Zb98nXzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="87369459"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="87369459"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 11:02:54 -0700
X-CSE-ConnectionGUID: 6ibuSj+LQZit8Chm+YK6gg==
X-CSE-MsgGUID: 70StOdW5QlinwIlmKt+TzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="276293076"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 29 Jun 2026 11:02:51 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1weGIt-000000007dd-0tjL;
	Mon, 29 Jun 2026 18:02:18 +0000
Date: Tue, 30 Jun 2026 02:01:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 88cefc306c43b58d9bb65c9e96e284306710d961
Message-ID: <202606300228.Vk2LZPOa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B2DF18000B
X-Stat-Signature: ybo8fw6r6mjky687o9ecmja7xo7xsw4n
X-HE-Tag: 1782756174-209640
X-HE-Meta: U2FsdGVkX1+a4+0KjzJW4V5C1HpeCbLTmFevse5iEnFuryxYLZO45prDbjFO1JyqQuhVncvRig5vX2C9yaLhvpYgvQd0Mg60xfJXnPQIeCDIqsWgxocf1XWDf5cbksWXngKJOg82DZ9IerA9q+9GjfrbsWUmbBcHOrAGzoVOrJytBSxvWn2iumhI1vWxfsL/+qwAao4p8X9K8a8WswNltnx1UoUJWFYLJZAXmFpTA8qK7Q0WpmmDgo/lTrM1+CVA2wTjNsFKxQP7JdTdxxJkYW9CBx/oLKkbOv2vKWpExPFQ4r2qdu0rrnM3/QROMTAAM8eAevUYcfwQfXjL+byi1JxKiyl4dveFk0RucricxTttBDOwPhqJpEdL6jzSnD+YJmwxKO7Zdl8Klip+RJqso4Ixub61836pEFKLFYzLAVGvdwyOzh1b1yb5q6PujVsDb5OGXsxqmWKELZ4TU15wIo0gSy2MloBRS07yxqkEa2+gdemDR6YChrlMkJmTbI9L7/hnTfL12ksaj2OdxYLvfHgXYRGeqJ2BN8VPuPOwqr37wl7LRwmttYoAsmrbhBzHwTS4488ta+xyTp5rTPyX+bUOCbthpftNXsEh2T0DgPxyomVdDhe6ZA2ZDXknDnFnXeotNXFOauapeagV0XJUxxF7Sjq9wkGKrG/223t4ol8bJh6V2VSosrJyQD0mOHeKgcPOk4PdA1QF36NbiUj4lrLpwrGPmB9UK3Kpk7IyakR9dB+myJG04VuXK+I3Uh7xSL4fXEON38LHEFknwXIxzap+69d8gmi8NvbtiPUNKYU46LWMDGXuDXmfTemTWr1cMUwgnPyeZwHS+acwxWGzf19hSfOZkt/z7pRf8UlXrdXpR+VjH75/qIa3Rlo3O6dhBDN5Kh1rBgx95uWo5fNdng0WkOeKc7NS2HKXRsqsjZN8w1rUMMbOZb7xOZMsLr4RwxIhonWPoU44SCHoHin
 M1wsBmLJ
 UYRk6f89zAf3ujO89XSyfl/lMwA4eq8mo28pJb3c/RnQLeXx8iS580NNQh5QCKYwnqggV9Kc44i4ASqnsM8XFTeQ7/gOrwjmka6pAc773imQGdXtEGGZ2FI7Takp1wkeaEYehsuXXAYw41FpBiy9Q3sx+BH5WDbAAf6XzDTHwSwD8Jg4x5sqPVftbITEobKPr7L7GGm0+iWfJHwx2xFNzCsKorujLB163OH1P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 88cefc306c43b58d9bb65c9e96e284306710d961  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
    mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-001-20260629
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- csky-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r054-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r131-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-002
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sh-randconfig-r062-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r072-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-001-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-002-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r054-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r063-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-r073-20260629
|   `-- mm-vmalloc.c:warning:unused-variable-start
`-- sparc64-randconfig-r113-20260629
    `-- mm-vmalloc.c:warning:unused-variable-start

elapsed time: 729m

configs tested: 271
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260629    clang-17
arc                   randconfig-001-20260630    clang-23
arc                   randconfig-002-20260629    clang-17
arc                   randconfig-002-20260630    clang-23
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260629    clang-17
arm                   randconfig-001-20260630    clang-23
arm                   randconfig-002-20260629    clang-17
arm                   randconfig-002-20260630    clang-23
arm                   randconfig-003-20260629    clang-17
arm                   randconfig-003-20260630    clang-23
arm                   randconfig-004-20260629    clang-17
arm                   randconfig-004-20260630    clang-23
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260629    gcc-16.1.0
arm64                 randconfig-001-20260630    clang-23
arm64                 randconfig-002-20260629    gcc-16.1.0
arm64                 randconfig-002-20260630    clang-23
arm64                 randconfig-003-20260629    gcc-16.1.0
arm64                 randconfig-003-20260630    clang-23
arm64                 randconfig-004-20260629    gcc-16.1.0
arm64                 randconfig-004-20260630    clang-23
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260629    gcc-16.1.0
csky                  randconfig-001-20260630    clang-23
csky                  randconfig-002-20260629    gcc-16.1.0
csky                  randconfig-002-20260630    clang-23
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260629    gcc-11.5.0
hexagon               randconfig-001-20260630    clang-18
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260629    gcc-11.5.0
hexagon               randconfig-002-20260630    clang-18
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260629    clang-22
i386        buildonly-randconfig-001-20260629    gcc-14
i386        buildonly-randconfig-001-20260630    clang-22
i386        buildonly-randconfig-002-20260629    gcc-13
i386        buildonly-randconfig-002-20260629    gcc-14
i386        buildonly-randconfig-002-20260630    clang-22
i386        buildonly-randconfig-003-20260629    gcc-14
i386        buildonly-randconfig-003-20260630    clang-22
i386        buildonly-randconfig-004-20260629    clang-22
i386        buildonly-randconfig-004-20260629    gcc-14
i386        buildonly-randconfig-004-20260630    clang-22
i386        buildonly-randconfig-005-20260629    gcc-14
i386        buildonly-randconfig-005-20260630    clang-22
i386        buildonly-randconfig-006-20260629    clang-22
i386        buildonly-randconfig-006-20260629    gcc-14
i386        buildonly-randconfig-006-20260630    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260629    clang-22
i386                  randconfig-001-20260630    clang-22
i386                  randconfig-002-20260629    clang-22
i386                  randconfig-002-20260630    clang-22
i386                  randconfig-003-20260629    clang-22
i386                  randconfig-003-20260630    clang-22
i386                  randconfig-004-20260629    clang-22
i386                  randconfig-004-20260630    clang-22
i386                  randconfig-005-20260629    clang-22
i386                  randconfig-005-20260630    clang-22
i386                  randconfig-006-20260629    clang-22
i386                  randconfig-006-20260630    clang-22
i386                  randconfig-007-20260629    clang-22
i386                  randconfig-007-20260630    clang-22
i386                  randconfig-011-20260629    gcc-14
i386                  randconfig-012-20260629    gcc-14
i386                  randconfig-013-20260629    gcc-14
i386                  randconfig-014-20260629    gcc-14
i386                  randconfig-015-20260629    clang-22
i386                  randconfig-015-20260629    gcc-14
i386                  randconfig-016-20260629    clang-22
i386                  randconfig-016-20260629    gcc-14
i386                  randconfig-017-20260629    clang-22
i386                  randconfig-017-20260629    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260629    gcc-11.5.0
loongarch             randconfig-001-20260629    gcc-12.5.0
loongarch             randconfig-001-20260630    clang-18
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260629    gcc-11.5.0
loongarch             randconfig-002-20260630    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-23
mips                       lemote2f_defconfig    gcc-16.1.0
mips                          malta_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260629    gcc-11.5.0
nios2                 randconfig-001-20260630    clang-18
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260629    gcc-11.5.0
nios2                 randconfig-002-20260630    clang-18
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-9.5.0
parisc                randconfig-001-20260629    gcc-9.5.0
parisc                         randconfig-002    gcc-9.5.0
parisc                randconfig-002-20260629    gcc-9.5.0
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-9.5.0
powerpc               randconfig-001-20260629    gcc-9.5.0
powerpc                        randconfig-002    gcc-9.5.0
powerpc               randconfig-002-20260629    gcc-9.5.0
powerpc                         wii_defconfig    gcc-16.1.0
powerpc64                      randconfig-001    gcc-9.5.0
powerpc64             randconfig-001-20260629    gcc-9.5.0
powerpc64                      randconfig-002    gcc-9.5.0
powerpc64             randconfig-002-20260629    gcc-9.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-17
riscv                 randconfig-001-20260629    clang-17
riscv                 randconfig-001-20260630    gcc-9.5.0
riscv                          randconfig-002    clang-17
riscv                 randconfig-002-20260629    clang-17
riscv                 randconfig-002-20260630    gcc-9.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-17
s390                  randconfig-001-20260629    clang-17
s390                  randconfig-001-20260630    gcc-9.5.0
s390                           randconfig-002    clang-17
s390                  randconfig-002-20260629    clang-17
s390                  randconfig-002-20260630    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-17
sh                    randconfig-001-20260629    clang-17
sh                    randconfig-001-20260629    gcc-10.5.0
sh                    randconfig-001-20260630    gcc-9.5.0
sh                             randconfig-002    clang-17
sh                    randconfig-002-20260629    clang-17
sh                    randconfig-002-20260630    gcc-9.5.0
sh                   sh7770_generic_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260629    gcc-15.2.0
sparc                 randconfig-002-20260629    gcc-15.2.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260629    gcc-15.2.0
sparc64               randconfig-002-20260629    gcc-15.2.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260629    gcc-15.2.0
um                    randconfig-002-20260629    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260629    clang-22
x86_64      buildonly-randconfig-002-20260629    clang-22
x86_64      buildonly-randconfig-002-20260629    gcc-14
x86_64      buildonly-randconfig-003-20260629    clang-22
x86_64      buildonly-randconfig-003-20260629    gcc-14
x86_64      buildonly-randconfig-004-20260629    clang-22
x86_64      buildonly-randconfig-005-20260629    clang-22
x86_64      buildonly-randconfig-006-20260629    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260629    gcc-14
x86_64                randconfig-002-20260629    clang-22
x86_64                randconfig-002-20260629    gcc-14
x86_64                randconfig-003-20260629    gcc-14
x86_64                randconfig-004-20260629    gcc-14
x86_64                randconfig-005-20260629    clang-22
x86_64                randconfig-005-20260629    gcc-14
x86_64                randconfig-006-20260629    gcc-14
x86_64                randconfig-011-20260629    gcc-13
x86_64                randconfig-011-20260630    gcc-14
x86_64                randconfig-012-20260629    gcc-13
x86_64                randconfig-012-20260630    gcc-14
x86_64                randconfig-013-20260629    gcc-13
x86_64                randconfig-013-20260630    gcc-14
x86_64                randconfig-014-20260629    gcc-13
x86_64                randconfig-014-20260630    gcc-14
x86_64                randconfig-015-20260629    gcc-13
x86_64                randconfig-015-20260630    gcc-14
x86_64                randconfig-016-20260629    gcc-13
x86_64                randconfig-016-20260630    gcc-14
x86_64                randconfig-071-20260629    clang-22
x86_64                randconfig-072-20260629    clang-22
x86_64                randconfig-073-20260629    clang-22
x86_64                randconfig-074-20260629    clang-22
x86_64                randconfig-075-20260629    clang-22
x86_64                randconfig-076-20260629    clang-22
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
xtensa                randconfig-001-20260629    gcc-15.2.0
xtensa                randconfig-002-20260629    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

