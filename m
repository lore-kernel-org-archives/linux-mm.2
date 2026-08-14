Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32E5C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 21:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E846B031C; Fri, 14 Aug 2026 17:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C70B6B0712; Fri, 14 Aug 2026 17:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D52C6B0713; Fri, 14 Aug 2026 17:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D847E6B031C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:46:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C493C0247
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:46:17 +0000 (UTC)
X-FDA: 85101208794.05.82495E4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id 694A080004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:46:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjkafyDc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786743975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5L12eV9sQY1vCwwbVMaL1n8bI5rbmJS0JImUkrhvXMw=;
	b=ylQMSU/aXy1T6a4eGUvMuht7Iwyh5qxiZRrPFxlre5Bq3hAL3y465UI9EWmoMLlGabcQSh
	0iiCphEBw8+YpUDIDzl+ep55N142i6pkwanHjvrj/vM2GBTOsMGCmt/kT0DEI6k0CKrUEh
	8UekCo7K1hRZbehn2yscbYapJWNVehY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjkafyDc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786743975;
	b=GLfxAlwRBm5vdh9DQa12kIs53aZBaO6VHj289uL8H2hwDky98pmnDNC9hpVKJMsEM3vCj0
	zgKAFlhi9eltSgKyvLmgBIQqwwB72/iOdwRuxsKfQGTsGFji+kot1Ing9hhO7CfMjGTIwR
	Dsd2cnuJrg8byHKB/8eH4euh2Ao//DM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786743974; x=1818279974;
  h=date:from:to:cc:subject:message-id;
  bh=5icbQX2VJlEt+gAZ3GH5ApZAlYrfxqHnTWTlpRn0QWs=;
  b=YjkafyDcMi4lPlxeqSExYwX8XMcOAThhR4P51fxrJkMPRUZkhYdvBOIo
   fYAYjnvpKULzq0KF2IOWkPP4qcSjCcz9cGEHmCrKfK/3vpvvbBITwMJrm
   14BHm6Jc/Skid9vtzMuZXRx+WoenIwLwgO1XZ8376NUsDhreFx+A86A9F
   RTb3wZ8qyeVXj9exsAYdX2LwfMPMcxPAjqmcJB5u60o4pMBp98JcWIJY6
   orc2X6uz/7kvrpLLuNUABFORY4cX5F98E50HngaAfSFjEfzwArSyTuqhr
   fGDVvhd2KgbdZUgdc3Q2xY3gVdVCCIF9oEKEw97bJNRTfRy1mIecK9RJI
   w==;
X-CSE-ConnectionGUID: 8cPKi9FlSb2fEGXI96x34g==
X-CSE-MsgGUID: vqk046kjRk6vy6eAtDjNhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="86287677"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="86287677"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 14:46:12 -0700
X-CSE-ConnectionGUID: XRPJ+L0RSb6Yc3rFAESRMw==
X-CSE-MsgGUID: Brw3EAkeStumoDoyW/MbXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="260091269"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 14 Aug 2026 14:46:11 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuzj6-00000000aIH-2usI;
	Fri, 14 Aug 2026 21:46:08 +0000
Date: Sat, 15 Aug 2026 05:45:37 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 6c2cdf00fe5205942b5f29e16905603a1717b931
Message-ID: <202608150524.CchPIr2M-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 694A080004
X-Rspamd-Server: rspam07
X-Stat-Signature: cixmrtdt9ch55fr3yn93tu9gb6agioxh
X-HE-Tag: 1786743974-59409
X-HE-Meta: U2FsdGVkX1/dhf3Rzo3cc71Z0AKnnak8W8cTLqkDGb5X31EnQPjP9YDER5zngiEuAlOvhUGarAoZfEo31tPm4S7Reg41lzJDfVZWbv6AsP9oqgvBsXr6Egk1JK7q7AoMNoR2UbjloQR6mbzfOuhyiOGTWjpf4IwP9DAUrZ/wc1dmZ9kkX6/zUfUTDncjArVknkY2mTu/cQi4+9/irTVmEbe/wDZUtBN9vF8zXMNWMHqmy18U8+Wuor2N2O/0ngGrjravY08hiIUm9qUilMZl1RgypFTLegiB8iWQcXpoD7BkDKcrWobsed7domACV4YwNb7n81DrDw+NKjzapa0GQ9sUQyICVnnYZIRbqmzge+8rX/fslC5AaT9bU6hA4gEuueLwGt2ECqSEctEY4c5Kzx17B9QeitRH5RA/U5fk7SCafRGGT/sMwDb9xmX0L1NRKnH8zgHP/n/y2+oHoOcFi8VCUDtJBtnRC+zEYPGzEcuX+I2qj/y5W7OYzVVX5Uxt4IdOFdX67vA6dNwINCrZkE07RX/0N7MKvYsBysDi5eBnK6UcaSuB/PHoq5RcRtm0vlhqDZWh3l5knxrOLjdXjyuXBg6vOe05Z6IJ/Wxu8FzOPKTQTJvISFKRkLC9c6uipCgS9ZaHodWyzYx9ruq/gL+S1GUA8T4tIeRQXQsRjZ+lzdeGF3YPrGk1OAAau7k8ahRH4WU5Omq0BvvSC8CS9ANW9cURn9ph91RUO114TU2BXQ0x+3nUOsnSMBpYva8wuXqGDtjwJFQXXm5uK4HGeKUM6wSVwbt+zMw/U+jAu0FBjalI/RAnrW+uAI3fzb3ichJ9cE6A5ImewF99LAgssmemXWI5rCvSLPWaqxtdUINGcEZMBEXo8xlIVsiwEnJMePMA94qWbb7cRs/kPgTj4U0mu+RQWML8y2rr8OHgt+b6Aq32fNjYrV+4mWUIdM+ZAl4zTJdc6mglcxX6N4L
 en+8MYTl
 nCqlXQ6PcR2RmAjgbYqyaDtP8zM+lNDziKuLh86RQTd+/JhB12bvMhXnmIsDllwc8C7COGDCPZd47E1v2Sy9zO65sPrGDMGdT6XSvea1CzsI2eWz7/wQF4wXAvSvspzq1lTTkuVsvWIHjRp/8LhkqTqMP+NdMYpHCdXmvDpD9ml6ZgdfeH3D06K/wmFQdHgZHvyCzi9zSVGPvU0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 6c2cdf00fe5205942b5f29e16905603a1717b931  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 794m

configs tested: 97
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260814    gcc-10.5.0
arc                  randconfig-002-20260814    gcc-12.5.0
arm                  randconfig-001-20260814    gcc-16.1.0
arm                  randconfig-002-20260814    gcc-10.5.0
arm                  randconfig-003-20260814    gcc-16.1.0
arm                  randconfig-004-20260814    clang-17
arm64                randconfig-001-20260814    gcc-10.5.0
arm64                randconfig-002-20260814    clang-24
arm64                randconfig-003-20260814    clang-19
arm64                randconfig-004-20260814    clang-17
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260814    gcc-16.1.0
csky                 randconfig-002-20260814    gcc-10.5.0
hexagon              randconfig-001-20260814    clang-17
hexagon              randconfig-002-20260814    clang-19
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260814    clang-22
i386       buildonly-randconfig-002-20260814    gcc-13
i386       buildonly-randconfig-003-20260814    clang-22
i386       buildonly-randconfig-004-20260814    clang-22
i386       buildonly-randconfig-005-20260814    gcc-13
i386       buildonly-randconfig-006-20260814    gcc-14
i386                 randconfig-001-20260814    clang-22
i386                 randconfig-002-20260814    gcc-14
i386                 randconfig-003-20260814    gcc-14
i386                 randconfig-004-20260814    clang-22
i386                 randconfig-005-20260814    clang-22
i386                 randconfig-006-20260814    clang-22
i386                 randconfig-007-20260814    clang-22
i386                 randconfig-011-20260814    gcc-14
i386                 randconfig-012-20260814    gcc-12
i386                 randconfig-013-20260814    gcc-12
i386                 randconfig-014-20260814    gcc-14
i386                 randconfig-015-20260814    gcc-12
i386                 randconfig-016-20260814    gcc-14
i386                 randconfig-017-20260814    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260814    gcc-16.1.0
loongarch            randconfig-002-20260814    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260814    gcc-11.5.0
nios2                randconfig-002-20260814    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260814    gcc-15.2.0
parisc               randconfig-002-20260814    gcc-9.5.0
powerpc              randconfig-001-20260814    gcc-8.5.0
powerpc              randconfig-002-20260814    clang-18
powerpc                    tqm5200_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260814    gcc-14.3.0
powerpc64            randconfig-002-20260814    gcc-8.5.0
riscv                randconfig-001-20260814    gcc-14.3.0
riscv                randconfig-002-20260814    clang-24
s390                 randconfig-001-20260814    gcc-11.5.0
s390                 randconfig-002-20260814    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260814    gcc-16.1.0
sh                   randconfig-002-20260814    gcc-16.1.0
sparc                randconfig-001-20260814    gcc-16.1.0
sparc                randconfig-002-20260814    gcc-15.2.0
sparc64              randconfig-001-20260814    gcc-8.5.0
sparc64              randconfig-002-20260814    clang-24
um                   randconfig-001-20260814    gcc-14
um                   randconfig-002-20260814    clang-22
x86_64     buildonly-randconfig-001-20260814    clang-22
x86_64     buildonly-randconfig-002-20260814    clang-22
x86_64     buildonly-randconfig-003-20260814    clang-22
x86_64     buildonly-randconfig-004-20260814    clang-22
x86_64     buildonly-randconfig-005-20260814    clang-22
x86_64     buildonly-randconfig-006-20260814    gcc-14
x86_64               randconfig-001-20260814    gcc-14
x86_64               randconfig-002-20260814    clang-22
x86_64               randconfig-003-20260814    clang-22
x86_64               randconfig-004-20260814    clang-22
x86_64               randconfig-005-20260814    gcc-14
x86_64               randconfig-006-20260814    gcc-14
x86_64               randconfig-011-20260814    clang-22
x86_64               randconfig-012-20260814    gcc-13
x86_64               randconfig-013-20260814    clang-22
x86_64               randconfig-014-20260814    gcc-14
x86_64               randconfig-015-20260814    gcc-14
x86_64               randconfig-016-20260814    clang-22
x86_64               randconfig-071-20260814    gcc-14
x86_64               randconfig-072-20260814    clang-22
x86_64               randconfig-073-20260814    clang-22
x86_64               randconfig-074-20260814    gcc-13
x86_64               randconfig-075-20260814    gcc-14
x86_64               randconfig-076-20260814    clang-22
xtensa               randconfig-001-20260814    gcc-9.5.0
xtensa               randconfig-002-20260814    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

