Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF04CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4066E6B00A6; Tue, 30 Jun 2026 14:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8576B00A8; Tue, 30 Jun 2026 14:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD506B00A9; Tue, 30 Jun 2026 14:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F170F6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:30:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73A4B4059F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:30:47 +0000 (UTC)
X-FDA: 84937420134.02.C9E96CC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id CBC738001B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:30:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ie79YEYD;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782844245;
	b=tQCqR0rW4wjIq6UmkvNk4tuqKXF86cxX1MIFK9IMIABANMMGUoK46kX9VN7vfhmif0zaCa
	VVXIU55yYrzWhIFkXw2MpuTe/UlJo05pcN24tgWGZuZdTa13082MnlnTvbAvANlE3jB1tG
	lWPTNlnJay7tHYY1CgaXKtAa85OJm8o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782844245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vIaC+LL2gcG/NtVWzE9SIvyhNn816b8BLuQfR31svhM=;
	b=PC9xsROJmn635zgbvfeKGt/yoY3vFuxUb/W4Qo3eYs3K4w9wJYWJHZsWuY3LVC/qS213Pf
	VOLNg/pXe2R0VE1Fb1bUXl76BMDVZnRxL3AtasF171B2nn16wCnT46MvrMezyfJmKHcXnN
	LMo1X/MeD84bYeT65jLOoGksGPFzXtQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ie79YEYD;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782844245; x=1814380245;
  h=date:from:to:cc:subject:message-id;
  bh=NX7S8Br6+AJyw7Jeox3iPoLm79TW6KhFQ6bnXuRg1es=;
  b=ie79YEYDO0tiWkRF1pEiEcXys43KQFSvpSPGgpyts3IdYqoPkYn6jfVO
   LfAy7TX02z1NLXlScbsvo+av6VUOacPO5iaoCG+D448Vfh5Ku2U0n9nJQ
   xGuSA4LsT8ID+um6JH3+dUlzv4ak3wF4/XD11pwrTG0U7vP86MUSPalgs
   Ck8L/W+TSQG5bzGgw8LmI5TM9m5ibLl5ZSgQw1EC62+bDIoF3AZ2r3VqJ
   yK6ejPPin09PTUNN2hda+Ph7/rDj0jKoEJdieNkwqFf3Pk537hP+4HRgF
   QwcWgJrV84uNSX647PX5IZ4nL9+z2ygx7pn/hvKLpteFW04OtaoyN9rT5
   g==;
X-CSE-ConnectionGUID: Vhjdw08eSL+2w3i7s87i/g==
X-CSE-MsgGUID: i1B0vdvNQ5eGUbnnYYyxoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="83438353"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="83438353"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 11:30:43 -0700
X-CSE-ConnectionGUID: 0Th9mMKwTGCMs9d2skpgXg==
X-CSE-MsgGUID: t0T8Iy7/STqIzGcRaY+Qvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="276635443"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 30 Jun 2026 11:30:41 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wedEE-000000008Zr-1FYb;
	Tue, 30 Jun 2026 18:30:38 +0000
Date: Wed, 01 Jul 2026 02:30:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 15654b0268cd65b4e673510c0377774e61b86397
Message-ID: <202607010249.92RC46mZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: wwtgf9hqzaefnirsz54aawaaadp5rnja
X-Rspamd-Queue-Id: CBC738001B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782844244-898398
X-HE-Meta: U2FsdGVkX19TPikBVtntNcfus/HzupH84VACFqj/iYX4BXLP0zPAB2kp+wGONG+ZkUyQMeyif7NqFZH/ys6TYx0FMd9paF4NwbM6n+GPywh4GCMg1uQU8xkG3e3B1cCB0ty5s7UaQ4rIu+O2QjaKgs2Yilsu0/By5/oMiZxst07FSDDYGyjoEsN6O8G9wMg3evPUtJAc+P0YbP0qJePIfWzIalejdqLUCOdEN5Kt1ffNaVzfpWTi63yrJ5HE9x+JvAxzqmhVpZ27t4Bu0zISR9lSWXBBxaKGM8Gu9cvARYBnJDD4187W6pGszwWb0+t3uINe4YL3GJcyT1yF0Sb32AlhqV0Jk3tRUJAbXxHa200dkh0UKXRReQZ+w/AomWzgq5tBc0/MLoLs6efWzHBdUsbnvKlSVnu22aTZPTKUvnd8EuEpT5VuVwEtXuxKvTL2/VNPshFK0Fx3XvE3nCfiI49xiPnq8K5pnTDvgBiub+/7FN5TmyX39W71Zms71GgX6BfyhLgjI59ZOPwzh5DAS4Q4rOYPm4p2oHGf6O5+2Op2ljGwurWSD9qIrvQvUvb/xqPQCJeeET6S74DoBM1XeCNGD+/s2gKloHMENAvPjQGjbTlXu/DqaU7YOmhUGRa+i6u73TxTV6wibJR9Qi4YZIw2LD/Y5tFEeV89DodYRJSt/m7g3MzeofcbhRae4++N52OCE5YGDRXB7zBVTz57nt77X1jMaccK/qOh+Fkz69W/vhtmu+brAYG38e2AjAqkYhF3CGOq+ysed6DA4JhJgYCPqdrA26X4ZiVAEor3FW0O0EG+7Ok4dxVpx9DHx7SbX5VotX8tpgZmepheaVV+wusBYFTO9Dmb+7576Q9bA//t/zHg/31uEe7tUuqWrBIAsQza7PU225yAetsK+ABGyeLdeDFZZg6toRmZFi1JgWGU4j5jtGs1yaumpDJL3DzyyXV+QBATKfNrxF0mcKl
 dh3yWVYt
 83/smtx+eRifc2rih2v3wvYjLvsedptdpbVeTPZmFhNKCcQRLfIWh/CAVHeI/ShD37VWUdt3ZXn4dWcUt33Xu54S3o8jpgozX49pKBzS9e08fQi6sXzH8eSxyd5LMkzmSN2Dj/Vdc+H/tINm9WquSlMdTm05PHmMvsoIub7HQgPHsnQbJs10gkKMGycvv4qD0ljb+bTah8bkPeldZbffplekVzOeFSirKi4mR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 15654b0268cd65b4e673510c0377774e61b86397  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com

    mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
    mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- arc-randconfig-r121-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- csky-randconfig-r072-20260630
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-buildonly-randconfig-001
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-051-20260630
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- i386-randconfig-141
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- loongarch-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- loongarch-randconfig-r063-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-allyesconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- m68k-defconfig
|   |-- mm-vmalloc.c:warning:unused-variable-start
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- openrisc-randconfig-r134-20260630
|   `-- mm-zsmalloc.c:warning:obj_to_class_idx-defined-but-not-used
|-- sh-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sh-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-allnoconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r053-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc-randconfig-r071-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-allmodconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-defconfig
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-001-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
|-- sparc64-randconfig-002-20260630
|   `-- mm-vmalloc.c:warning:unused-variable-start
`-- sparc64-randconfig-r111-20260630
    `-- mm-vmalloc.c:warning:unused-variable-start

elapsed time: 776m

configs tested: 319
configs skipped: 17

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
arc                   randconfig-001-20260630    clang-23
arc                   randconfig-001-20260630    gcc-12.5.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260630    clang-23
arc                   randconfig-002-20260630    gcc-10.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260630    clang-23
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-002-20260630    clang-23
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-003-20260630    clang-23
arm                   randconfig-003-20260630    gcc-8.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-004-20260630    clang-23
arm                   randconfig-004-20260630    gcc-8.5.0
arm                   randconfig-004-20260701    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260630    clang-17
arm64                 randconfig-001-20260630    clang-23
arm64                 randconfig-002-20260630    clang-23
arm64                 randconfig-003-20260630    clang-23
arm64                 randconfig-004-20260630    clang-23
arm64                 randconfig-004-20260630    gcc-10.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260630    clang-23
csky                  randconfig-001-20260630    gcc-14.3.0
csky                  randconfig-002-20260630    clang-23
csky                  randconfig-002-20260630    gcc-16.1.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260630    clang-18
hexagon               randconfig-002-20260630    clang-18
hexagon               randconfig-002-20260630    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                 buildonly-randconfig-001    clang-22
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260630    clang-22
i386                 buildonly-randconfig-002    clang-22
i386        buildonly-randconfig-002-20260630    clang-22
i386                 buildonly-randconfig-003    clang-22
i386        buildonly-randconfig-003-20260630    clang-22
i386        buildonly-randconfig-003-20260630    gcc-13
i386                 buildonly-randconfig-004    clang-22
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260630    clang-22
i386                 buildonly-randconfig-005    clang-22
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260630    clang-22
i386                 buildonly-randconfig-006    clang-22
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260630    clang-22
i386        buildonly-randconfig-006-20260630    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260630    clang-22
i386                  randconfig-002-20260630    clang-22
i386                  randconfig-003-20260630    clang-22
i386                  randconfig-003-20260630    gcc-14
i386                  randconfig-004-20260630    clang-22
i386                  randconfig-005-20260630    clang-22
i386                  randconfig-006-20260630    clang-22
i386                  randconfig-007-20260630    clang-22
i386                           randconfig-011    gcc-12
i386                  randconfig-011-20260630    gcc-12
i386                  randconfig-011-20260630    gcc-14
i386                           randconfig-012    gcc-12
i386                  randconfig-012-20260630    clang-22
i386                  randconfig-012-20260630    gcc-12
i386                           randconfig-013    gcc-12
i386                  randconfig-013-20260630    gcc-12
i386                           randconfig-014    gcc-12
i386                  randconfig-014-20260630    clang-22
i386                  randconfig-014-20260630    gcc-12
i386                           randconfig-015    gcc-12
i386                  randconfig-015-20260630    gcc-12
i386                  randconfig-015-20260630    gcc-14
i386                           randconfig-016    gcc-12
i386                  randconfig-016-20260630    gcc-12
i386                           randconfig-017    gcc-12
i386                  randconfig-017-20260630    clang-22
i386                  randconfig-017-20260630    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260630    clang-18
loongarch             randconfig-001-20260630    clang-23
loongarch             randconfig-002-20260630    clang-18
m68k                             alldefconfig    gcc-16.1.0
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
mips                      malta_kvm_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260630    clang-18
nios2                 randconfig-001-20260630    gcc-11.5.0
nios2                 randconfig-002-20260630    clang-18
nios2                 randconfig-002-20260630    gcc-11.5.0
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
parisc                randconfig-001-20260630    clang-22
parisc                randconfig-001-20260630    gcc-13.4.0
parisc                randconfig-002-20260630    clang-22
parisc                randconfig-002-20260630    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260630    clang-17
powerpc               randconfig-001-20260630    clang-22
powerpc               randconfig-002-20260630    clang-22
powerpc64             randconfig-001-20260630    clang-22
powerpc64             randconfig-001-20260630    clang-23
powerpc64             randconfig-002-20260630    clang-22
powerpc64             randconfig-002-20260630    gcc-14.3.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    gcc-9.5.0
riscv                 randconfig-001-20260630    clang-23
riscv                 randconfig-001-20260630    gcc-9.5.0
riscv                          randconfig-002    gcc-9.5.0
riscv                 randconfig-002-20260630    clang-23
riscv                 randconfig-002-20260630    gcc-9.5.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    gcc-9.5.0
s390                  randconfig-001-20260630    gcc-9.5.0
s390                           randconfig-002    gcc-9.5.0
s390                  randconfig-002-20260630    clang-23
s390                  randconfig-002-20260630    gcc-9.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    gcc-9.5.0
sh                    randconfig-001-20260630    gcc-16.1.0
sh                    randconfig-001-20260630    gcc-9.5.0
sh                             randconfig-002    gcc-9.5.0
sh                    randconfig-002-20260630    gcc-16.1.0
sh                    randconfig-002-20260630    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    clang-17
sparc                 randconfig-001-20260630    clang-17
sparc                 randconfig-001-20260630    gcc-8.5.0
sparc                          randconfig-002    clang-17
sparc                 randconfig-002-20260630    clang-17
sparc                 randconfig-002-20260630    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    clang-17
sparc64               randconfig-001-20260630    clang-17
sparc64               randconfig-001-20260630    gcc-11.5.0
sparc64                        randconfig-002    clang-17
sparc64               randconfig-002-20260630    clang-17
sparc64               randconfig-002-20260630    gcc-8.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-17
um                    randconfig-001-20260630    clang-17
um                             randconfig-002    clang-17
um                    randconfig-002-20260630    clang-17
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    clang-22
x86_64      buildonly-randconfig-001-20260630    clang-22
x86_64               buildonly-randconfig-002    clang-22
x86_64      buildonly-randconfig-002-20260630    clang-22
x86_64      buildonly-randconfig-002-20260630    gcc-14
x86_64               buildonly-randconfig-003    clang-22
x86_64      buildonly-randconfig-003-20260630    clang-22
x86_64               buildonly-randconfig-004    clang-22
x86_64      buildonly-randconfig-004-20260630    clang-22
x86_64               buildonly-randconfig-005    clang-22
x86_64      buildonly-randconfig-005-20260630    clang-22
x86_64               buildonly-randconfig-006    clang-22
x86_64      buildonly-randconfig-006-20260630    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260630    clang-22
x86_64                randconfig-001-20260630    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260630    clang-22
x86_64                randconfig-002-20260630    gcc-14
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260630    clang-22
x86_64                randconfig-003-20260630    gcc-14
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260630    clang-22
x86_64                randconfig-004-20260630    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260630    clang-22
x86_64                randconfig-005-20260630    gcc-14
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260630    gcc-14
x86_64                randconfig-011-20260630    clang-22
x86_64                randconfig-011-20260630    gcc-14
x86_64                randconfig-012-20260630    gcc-14
x86_64                randconfig-013-20260630    gcc-14
x86_64                randconfig-014-20260630    clang-22
x86_64                randconfig-014-20260630    gcc-14
x86_64                randconfig-015-20260630    clang-22
x86_64                randconfig-015-20260630    gcc-14
x86_64                randconfig-016-20260630    gcc-14
x86_64                         randconfig-071    gcc-13
x86_64                randconfig-071-20260630    clang-22
x86_64                randconfig-071-20260630    gcc-13
x86_64                randconfig-071-20260630    gcc-14
x86_64                         randconfig-072    gcc-13
x86_64                randconfig-072-20260630    clang-22
x86_64                randconfig-072-20260630    gcc-13
x86_64                randconfig-072-20260630    gcc-14
x86_64                         randconfig-073    gcc-13
x86_64                randconfig-073-20260630    clang-22
x86_64                randconfig-073-20260630    gcc-13
x86_64                         randconfig-074    gcc-13
x86_64                randconfig-074-20260630    clang-22
x86_64                randconfig-074-20260630    gcc-13
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260630    clang-22
x86_64                randconfig-075-20260630    gcc-13
x86_64                randconfig-075-20260630    gcc-14
x86_64                         randconfig-076    gcc-13
x86_64                randconfig-076-20260630    clang-22
x86_64                randconfig-076-20260630    gcc-13
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
xtensa                         randconfig-001    clang-17
xtensa                randconfig-001-20260630    clang-17
xtensa                randconfig-001-20260630    gcc-15.2.0
xtensa                         randconfig-002    clang-17
xtensa                randconfig-002-20260630    clang-17
xtensa                randconfig-002-20260630    gcc-13.4.0
xtensa                    smp_lx200_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

