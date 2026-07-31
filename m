Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756D4C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694D86B008C; Fri, 31 Jul 2026 10:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6467E6B0092; Fri, 31 Jul 2026 10:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583846B0093; Fri, 31 Jul 2026 10:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 395356B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:32:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4122A18D0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:32:35 +0000 (UTC)
X-FDA: 85049312670.06.0FA16BE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2479D8000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:32:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VDNACTZl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785508354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=R78FNhzzwH7Em3pQgz6/BfyWl4duMd8DPLHvYdYWkas=;
	b=D/EL068iZdaOdJgXolpnJDbxNXarI/rRU/2h86kGDjNmW7WAFT/xwjZAQoEX4a/8V3U7Pw
	XTg2SvCFfDLft8Ho6rQtmGHCOC91YK/dFXkVGXtcLns/GkVP5/LHfaZ6Nh6h7xCbcYsoLT
	tJ+hnHzCSszIO/EUTyxy+EpnwyO16js=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VDNACTZl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785508354;
	b=ol5noxxCoCu6lqOA+9YzHX1m+4fqqmFMRu6nIU8AXAJ3vxmNowLctuxhtkbIJQfmxWWIiY
	Cq1a0x6PNNCEJO1EFxq1/pBS8HsFCePoHKgmUSNBkRbB1BcUuXc8pS2KcHnXU5zFWs5R6N
	hbtAUR+aJLcD0cXyf5RQpMOq/4XtoU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785508353; x=1817044353;
  h=date:from:to:cc:subject:message-id;
  bh=eA+qpUMzk+socKsCRX4kGfvQe3dPY8NF1KuT4zh55Ws=;
  b=VDNACTZlWQyOwLFU6odPsiu2Bd+mY6rajE+Nphug6UANA8MKnsiTpuKL
   1vONXnxPh+zQzyYHPdXfg056gG3yADMh58TXr8sXTld9RNYs2wKOzePFT
   HnzmYs8x6evs9dRKqsP3G37tNFUWo9HD0a6sypnT29XyIqz6WdDtgW2GQ
   tJoqY+zcxj5IdgqANRJQpqqqqF9Fhtbs0ldOtqwftZMdZFJs562xAk2Px
   BlIxmcCsJAm4UKc/TwfNSOtoTEq57rxBu1gywMVvqkUROJom6+n00Zv1E
   V/2FJiD1D1hO50cCZU2GJEAtOPLckGoZClQMBkqYI69Em892Wy1UVPuFv
   g==;
X-CSE-ConnectionGUID: wcdtYrkDSualnc5lCClMZQ==
X-CSE-MsgGUID: 44IsFlW7QnaFq7lIClhuhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="86085328"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86085328"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:32:32 -0700
X-CSE-ConnectionGUID: U8aBB/S2R56Gx5S09zrCIw==
X-CSE-MsgGUID: Y1Y/0fbcSvSYdTUtqhFt1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="262551831"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 31 Jul 2026 07:32:30 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpoHj-000000001GH-3KRS;
	Fri, 31 Jul 2026 14:32:27 +0000
Date: Fri, 31 Jul 2026 22:31:38 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-ID: <202607312212.u1pPx1f6-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2479D8000B
X-Rspam-User: 
X-Stat-Signature: wx76j87jqj5md7bryujky36734rfsd8z
X-HE-Tag: 1785508352-909342
X-HE-Meta: U2FsdGVkX1/nJHeM43nAE9QAR6IlLjeGc1FQ2eCYuOHqXIY0TAsjAm2maZsMmEjrKvCscmaOgjizJ4f1wkcEc25nXGNWrmt48h1z2ueP6Oc6y4WoMmhSfRWBwuPBrvWDN8fbJtC8kX+PGUFoMF4Di2Ul2dya7P+nqujyhVQJ3gwganfE8PXnIgD1FfdRqE5+mVVQivmxzhXR2Pn8hqriMCNF6QnWr2Iz5JFfIFd6sY5rZ8IneNaiBQz4NYB1bfoVCC4R/Nm+WuGBnJ4Io/AzKbUdWxKJEWRFoXfmNXuBMZ93rJjR/6Du3tDq7JrFia8dWWxHECEGJr61ChWp6XqAyIlk1D9wNxxZbm+FZiTzhLv9j6zyDCrxCNeWcKJVe5z7A/1wusvq5rX4svcA5R8riMboe2Bt1lR6HaYC0pYNyJchlxiEDJ/kPE1zZvqsiIeyilQA3OCr4LM58dgB1zlf8OvRK8OMWvfPkxgAuhjYF8td9pi+xaiDpnxzeHG9/CLSeFQAPevDXkwH3OErjqhA9N7q83dZES4LGmgn7cOyQpNkamGmAbZt8ek9PsBobfbwZRBXwlBgU8nbNKaAZjAruUln8CMZiB7idRidpcDZ4FLY3XvmnyBagkNiIaqNKVSjlRiO3zNASxdM7OHfBI65gfVHBjJgOZhTbETnF4hmaP3vo1ZidFx0dP9B3azqGMe8zAN2GFMWwXEED/DzBt/jkLN5TEMA2qswqqLdAO4JC99YxO+jVr/ircUFHzd8J0iaxYTGB9vfyCtks+Bc4dphsBRLogoJqhzpwvFGUvMbFxScmRqYVfz40prJK4QWSK8i7ReosQHtvCtoD8FqKOlvwJbukgSgN5EhnqVDd3N3vPDzI31IkQF5f+b8LDLqpXsVnLC5orcHGEuFE6M6BlocI7bGiySkUpBJGe+dsAvqpBqe3aNQ53OA9mm8WHIdw1W1vKeH6j9LGhbwlvdRlzZ
 JfZYDiD6
 sYrJ+vHBdD9jQawDM+eVhMX93M5CJIHXyXgBDvTB13it5yPT1Vbuz2N/NMEqSBEgtPtzYVFvHfeaP9KdnrvDDVWflP7RH0lIlkkLcR9mMSoRFiNY+FrQEI/6r6c9jvGQurNlDD0bHhXLUA1ocC6Kmm7yi6qGN2exgRwuZ5ckmAUG+xZE+hdkexr/KlKcDbP2dgdoIenMFnJ442nVtTgat0/+hburN2h/0kPIq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com

    mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Warning ids grouped by kconfigs:

recent_errors
`-- powerpc64-randconfig-r072-20260731
    `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

elapsed time: 795m

configs tested: 150
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    clang-17
arc                  randconfig-001-20260731    gcc-8.5.0
arc                  randconfig-002-20260731    clang-17
arc                  randconfig-002-20260731    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-17
arm                  randconfig-002-20260731    clang-19
arm                  randconfig-003-20260731    clang-17
arm                  randconfig-003-20260731    clang-24
arm                  randconfig-004-20260731    clang-17
arm                  randconfig-004-20260731    clang-24
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    clang-24
arm64                randconfig-002-20260731    gcc-8.5.0
arm64                randconfig-003-20260731    gcc-10.5.0
arm64                randconfig-003-20260731    gcc-8.5.0
arm64                randconfig-004-20260731    gcc-12.5.0
arm64                randconfig-004-20260731    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-8.5.0
csky                 randconfig-002-20260731    gcc-10.5.0
csky                 randconfig-002-20260731    gcc-8.5.0
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260731    clang-22
i386       buildonly-randconfig-001-20260731    gcc-14
i386       buildonly-randconfig-002-20260731    clang-22
i386       buildonly-randconfig-003-20260731    clang-22
i386       buildonly-randconfig-004-20260731    clang-22
i386       buildonly-randconfig-004-20260731    gcc-13
i386       buildonly-randconfig-005-20260731    clang-22
i386       buildonly-randconfig-006-20260731    clang-22
i386       buildonly-randconfig-006-20260731    gcc-14
i386                 randconfig-001-20260731    gcc-14
i386                 randconfig-002-20260731    clang-22
i386                 randconfig-002-20260731    gcc-14
i386                 randconfig-003-20260731    clang-22
i386                 randconfig-003-20260731    gcc-14
i386                 randconfig-004-20260731    gcc-14
i386                 randconfig-005-20260731    gcc-14
i386                 randconfig-006-20260731    gcc-13
i386                 randconfig-006-20260731    gcc-14
i386                 randconfig-007-20260731    gcc-14
i386                 randconfig-011-20260731    clang-22
i386                 randconfig-012-20260731    clang-22
i386                 randconfig-013-20260731    clang-22
i386                 randconfig-013-20260731    gcc-14
i386                 randconfig-014-20260731    clang-22
i386                 randconfig-014-20260731    gcc-14
i386                 randconfig-015-20260731    clang-22
i386                 randconfig-015-20260731    gcc-14
i386                 randconfig-016-20260731    clang-22
i386                 randconfig-016-20260731    gcc-14
i386                 randconfig-017-20260731    clang-22
i386                 randconfig-017-20260731    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    clang-24
loongarch            randconfig-001-20260731    gcc-16.1.0
loongarch            randconfig-002-20260731    clang-24
mips                decstation_r4k_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    clang-24
nios2                randconfig-001-20260731    gcc-8.5.0
nios2                randconfig-002-20260731    clang-24
nios2                randconfig-002-20260731    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260731    gcc-8.5.0
parisc               randconfig-002-20260731    gcc-13.4.0
parisc               randconfig-002-20260731    gcc-8.5.0
powerpc              randconfig-001-20260731    clang-17
powerpc              randconfig-001-20260731    gcc-8.5.0
powerpc              randconfig-002-20260731    clang-24
powerpc              randconfig-002-20260731    gcc-8.5.0
powerpc64            randconfig-001-20260731    gcc-8.5.0
powerpc64            randconfig-002-20260731    gcc-8.5.0
riscv                randconfig-001-20260731    clang-19
riscv                randconfig-002-20260731    clang-19
riscv                randconfig-002-20260731    gcc-12.5.0
s390                 randconfig-001-20260731    clang-19
s390                 randconfig-001-20260731    clang-24
s390                 randconfig-002-20260731    clang-19
s390                 randconfig-002-20260731    clang-21
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260731    clang-19
sh                   randconfig-001-20260731    gcc-16.1.0
sh                   randconfig-002-20260731    clang-19
sh                   randconfig-002-20260731    gcc-16.1.0
sparc                         randconfig-001    gcc-14
sparc                randconfig-001-20260731    gcc-13.4.0
sparc                randconfig-001-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-8.5.0
sparc64              randconfig-001-20260731    clang-20
sparc64              randconfig-001-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-8.5.0
um                   randconfig-001-20260731    gcc-14
um                   randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-001-20260731    clang-22
x86_64     buildonly-randconfig-001-20260731    gcc-14
x86_64     buildonly-randconfig-002-20260731    clang-22
x86_64     buildonly-randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-003-20260731    clang-22
x86_64     buildonly-randconfig-003-20260731    gcc-14
x86_64     buildonly-randconfig-004-20260731    clang-22
x86_64     buildonly-randconfig-004-20260731    gcc-14
x86_64     buildonly-randconfig-005-20260731    clang-22
x86_64     buildonly-randconfig-005-20260731    gcc-14
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260731    clang-22
x86_64               randconfig-001-20260731    gcc-14
x86_64               randconfig-002-20260731    gcc-14
x86_64               randconfig-003-20260731    gcc-14
x86_64               randconfig-004-20260731    gcc-14
x86_64               randconfig-005-20260731    clang-22
x86_64               randconfig-005-20260731    gcc-14
x86_64               randconfig-006-20260731    clang-22
x86_64               randconfig-006-20260731    gcc-14
x86_64               randconfig-011-20260731    clang-22
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    clang-22
x86_64               randconfig-014-20260731    clang-22
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260731    clang-22
x86_64               randconfig-071-20260731    gcc-14
x86_64               randconfig-072-20260731    clang-22
x86_64               randconfig-073-20260731    clang-22
x86_64               randconfig-074-20260731    clang-22
x86_64               randconfig-074-20260731    gcc-14
x86_64               randconfig-075-20260731    clang-22
x86_64               randconfig-075-20260731    gcc-14
x86_64               randconfig-076-20260731    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260731    gcc-14
xtensa               randconfig-001-20260731    gcc-9.5.0
xtensa               randconfig-002-20260731    gcc-11.5.0
xtensa               randconfig-002-20260731    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

