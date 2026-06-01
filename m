Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677F7CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73E16B0482; Mon,  1 Jun 2026 13:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BB76B0483; Mon,  1 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9617C6B0484; Mon,  1 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82E1B6B0482
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:22:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 010A7C1E23
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:22:08 +0000 (UTC)
X-FDA: 84832011978.15.E60C46B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf07.hostedemail.com (Postfix) with ESMTP id 448DD4000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:22:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aoIUNct6;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780334527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=L8DyzYWTJCYzoQC7YpGEtMB2i0ijWQCR1+unL/G+drk=;
	b=3FtsPpUyXyEx9jkvbJU/GuRHkNKMv9k084BAzrF5Llyl100vsDfNoUbxyeuCy/8FFL444N
	twWu04FFm3o25LleFSMid1EtV4aqzA6OWJ+GzA4ZJM51rupSDoSiOtq7wDzOTAhkZg+IFK
	4JTwZJF3F7JWXHY9OWUUNvIDxFxN8Zo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aoIUNct6;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780334527;
	b=bqAfB0JLDja1NbzcDaJrFa5cxDKXzqB8K4hDEbjaEgG8LTxaISqMEz308mCoRJEx4WXn9B
	Cn7PlE7vszM/7gV6pGf7LssdksKOL6qUpkZiwSsvihuTvVewP21QQIvM2T5nrKLFsHEtrp
	Ni1nV1nQZ2lkSBtbTGiWjskAq2wE9wM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780334526; x=1811870526;
  h=date:from:to:cc:subject:message-id;
  bh=OTjlpBz81MlpSWZfoZDrW+Dlk+VhKUNJytbFslvPAKk=;
  b=aoIUNct6xi2eUFTVLKgN/Xei5H2RkEmBftUDvKpzPsXX+7XnHBBZMwFe
   9QSnl6+3pOp+PiPIjOrTuVYHGPEdz+BGXUJ6AFkO/uA/SDeMm+DNpHAsX
   GRqX1JWCW4ONnjHMA2qEe5LetNTDwbDz31m5j/H22lstMj7z1vSDo8FHF
   5F1PYmYM1w8PF4jGb3sbqUHT8spRJaJW6xp9rakTCn0RIeaH4SS5pIXyQ
   XSo4tCxg7oJ2Zhj5/JBOKwZyZtDRig8ZQ7kIhCy2WGoB9G40Z/J+Sn5FW
   DSPki13WUxtP83JAS/0UbIqFvs6W3jqrJQ4+qQ2o2788rZm2Sgtz11oNt
   A==;
X-CSE-ConnectionGUID: SkLxYCf2Tj269+tU9vDr4g==
X-CSE-MsgGUID: N1FIFe4VSXSU20DhjcuXHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="98519087"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="98519087"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 10:22:04 -0700
X-CSE-ConnectionGUID: /3Cer83XRkikvwUWdeuNLA==
X-CSE-MsgGUID: 2OTYNnAKSEKzafgd5Iflew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="243463809"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 01 Jun 2026 10:22:03 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wU6Kt-00000000Ara-3lPo;
	Mon, 01 Jun 2026 17:21:59 +0000
Date: Tue, 02 Jun 2026 01:21:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 415489ef1cdfe586b4992662bee65286d50232e6
Message-ID: <202606020122.Di20NyDP-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 448DD4000B
X-Stat-Signature: orgsmesec7b57d3kdg9wiqrgkh7jw4jy
X-Rspam-User: 
X-HE-Tag: 1780334525-626461
X-HE-Meta: U2FsdGVkX18dPuF4jwRX5FcKjTPQDq9KlzT1NVevXibgO4NgctE/z7WnMbew8NOmOQLs/fDFiT+iCgkiy/PTmhGAKDPsVN04SHW8f49P09TbVXUrXcy4DtVfruUNI07jY+CEbAppqUmcr/S+ltF61Nwm1HK8za4exQ2zP1o2Y+HZ09OLPLdL0ezQlfG36DygQ8SiEKxMeXAXYIP8ipoywUn4MvNOApPSpaQznvh5H9lUuAvR228jPNwDx5h4lnbOArDkjVyjEiXgbP3YsSV1snfhKaRlDARXZtM7a4sR056LYNQ/JYBRXkiDLkAzVt5OUOkED9ZP2D3Z2djzAzG3aiy7VmiXfWWv+4eOW91srzffF4iDCJ/WwDtO9Cbw5m1Ep78EGZYv4W5xgyhDk3Ym3u0d3M2om6zOxLdChHaVgKG6Oy0XY9cqc8KdbpEwIG3GqUuzcBxyBEAr80Q7U4ZAYiJLlrVGI6omDS9IPWX3O2pcYNTEDuCmbGFFuKIKiS8LDr8vDo1Q7Bgd5nBPsNqAENNjp4qVXxgEZx4n2VLAvRItYrU8sKubSPsZGA545YopnOuoale4Ljmodz5fiQ+V7cqGy5ojzGQEqmsYxzE93Ni+dZFrw5/v8I31GJaRuTX+O/euaavlPXYOWM6d/wnRS4CGpHQx420IxXRd3EEmTeEIV3rh2sDpCRvQPJdOuG5Um3m37k/Kk1vC1xwATE5pzKTgVPehKF9MWv4BTM1CcY5U2on76IBbITUe77PM5vCqH7uqCe/sIDAbddOB6y8LA9kyemTWy1ox+2AEltjtgtnmCOHfWBP5EX2E85EvjSAoGCnXusZ4c93VR2LojhjZ1esqxxOwOgPgGC7vpC9arBDCRlG9v9oaLd/vCHXrDRYiVLk9I/Bs643yg3vFFUqEFn/ZQ6sHZUVsBsn+9Ie+eQvgbyDbS2yRpA5vYp4VjfqR/Y8OQl+uXMGGXG+Sddr
 ZHxrpU3X
 +gp6zwG+3o38hBystuHe4q7ujnoQqY5WbDAZ7uGMirAH82lnTsiYZtm3BO0Z9C+vIxQUP0CsWlfH6Oi/5xlhdmSdP/JtOC7bKoXfCxCnr8x1oPHxdkFRHC6yBPrBQq41+epb9XyTGbZNM/kpVMgguaUSOT0Sfjw0zTeq4OAZRkgVoGVAMsrvYGm+yQ15xmcjmOgEZcJKGxH8uRuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 415489ef1cdfe586b4992662bee65286d50232e6  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 727m

configs tested: 322
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260601    clang-23
arc                   randconfig-001-20260601    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260601    clang-23
arc                   randconfig-002-20260601    gcc-14.3.0
arc                   randconfig-002-20260601    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    gcc-15.2.0
arm                       imx_v4_v5_defconfig    clang-23
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260601    clang-23
arm                   randconfig-001-20260601    gcc-15.2.0
arm                   randconfig-001-20260601    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260601    clang-23
arm                   randconfig-002-20260601    gcc-11.5.0
arm                   randconfig-002-20260601    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260601    clang-23
arm                   randconfig-003-20260601    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260601    clang-23
arm                   randconfig-004-20260601    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-8.5.0
arm64                 randconfig-001-20260601    gcc-14.3.0
arm64                 randconfig-001-20260601    gcc-8.5.0
arm64                          randconfig-002    gcc-14.3.0
arm64                 randconfig-002-20260601    gcc-8.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260601    gcc-15.2.0
arm64                 randconfig-003-20260601    gcc-8.5.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260601    gcc-14.3.0
arm64                 randconfig-004-20260601    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260601    gcc-14.3.0
csky                  randconfig-001-20260601    gcc-8.5.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260601    gcc-16.1.0
csky                  randconfig-002-20260601    gcc-8.5.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    clang-17
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260601    clang-18
hexagon               randconfig-001-20260601    gcc-11.5.0
hexagon               randconfig-001-20260601    gcc-8.5.0
hexagon                        randconfig-002    clang-23
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260601    clang-23
hexagon               randconfig-002-20260601    gcc-11.5.0
hexagon               randconfig-002-20260601    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-12
i386        buildonly-randconfig-001-20260601    gcc-12
i386        buildonly-randconfig-001-20260601    gcc-14
i386                 buildonly-randconfig-002    gcc-12
i386        buildonly-randconfig-002-20260601    clang-20
i386        buildonly-randconfig-002-20260601    gcc-12
i386                 buildonly-randconfig-003    gcc-12
i386        buildonly-randconfig-003-20260601    gcc-12
i386        buildonly-randconfig-003-20260601    gcc-14
i386                 buildonly-randconfig-004    gcc-12
i386        buildonly-randconfig-004-20260601    clang-20
i386        buildonly-randconfig-004-20260601    gcc-12
i386                 buildonly-randconfig-005    gcc-12
i386        buildonly-randconfig-005-20260601    gcc-12
i386        buildonly-randconfig-005-20260601    gcc-14
i386                 buildonly-randconfig-006    gcc-12
i386        buildonly-randconfig-006-20260601    gcc-12
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260601    gcc-14
i386                  randconfig-002-20260601    clang-20
i386                  randconfig-002-20260601    gcc-14
i386                  randconfig-003-20260601    gcc-14
i386                  randconfig-004-20260601    gcc-14
i386                  randconfig-005-20260601    gcc-14
i386                  randconfig-006-20260601    gcc-14
i386                  randconfig-007-20260601    gcc-14
i386                  randconfig-011-20260601    clang-20
i386                  randconfig-012-20260601    clang-20
i386                  randconfig-013-20260601    gcc-14
i386                  randconfig-014-20260601    clang-20
i386                  randconfig-015-20260601    clang-20
i386                  randconfig-016-20260601    clang-20
i386                  randconfig-017-20260601    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    clang-18
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260601    clang-23
loongarch             randconfig-001-20260601    gcc-11.5.0
loongarch             randconfig-001-20260601    gcc-8.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch                      randconfig-002    gcc-13.4.0
loongarch             randconfig-002-20260601    clang-18
loongarch             randconfig-002-20260601    gcc-11.5.0
loongarch             randconfig-002-20260601    gcc-8.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           gcw0_defconfig    clang-23
mips                           rs90_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260601    gcc-11.5.0
nios2                 randconfig-001-20260601    gcc-8.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260601    gcc-11.5.0
nios2                 randconfig-002-20260601    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260601    gcc-10.5.0
parisc                randconfig-002-20260601    gcc-10.5.0
parisc                randconfig-002-20260601    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260601    gcc-10.5.0
powerpc               randconfig-001-20260601    gcc-14.3.0
powerpc               randconfig-002-20260601    clang-23
powerpc               randconfig-002-20260601    gcc-10.5.0
powerpc                     tqm8560_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260601    gcc-10.5.0
powerpc64             randconfig-001-20260601    gcc-12.5.0
powerpc64             randconfig-002-20260601    gcc-10.5.0
powerpc64             randconfig-002-20260601    gcc-13.4.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260601    clang-23
riscv                 randconfig-001-20260601    gcc-10.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260601    clang-23
riscv                 randconfig-002-20260601    gcc-10.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260601    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260601    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-16.1.0
sh                    randconfig-001-20260601    clang-23
sh                    randconfig-001-20260601    gcc-16.1.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260601    clang-23
sh                    randconfig-002-20260601    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-8.5.0
sparc                 randconfig-001-20260601    gcc-15.2.0
sparc                 randconfig-001-20260601    gcc-8.5.0
sparc                          randconfig-002    gcc-8.5.0
sparc                 randconfig-002-20260601    gcc-15.2.0
sparc                 randconfig-002-20260601    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-8.5.0
sparc64               randconfig-001-20260601    clang-20
sparc64               randconfig-001-20260601    gcc-15.2.0
sparc64               randconfig-001-20260601    gcc-8.5.0
sparc64                        randconfig-002    gcc-8.5.0
sparc64               randconfig-002-20260601    clang-23
sparc64               randconfig-002-20260601    gcc-15.2.0
sparc64               randconfig-002-20260601    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-8.5.0
um                    randconfig-001-20260601    gcc-14
um                    randconfig-001-20260601    gcc-15.2.0
um                    randconfig-001-20260601    gcc-8.5.0
um                             randconfig-002    gcc-8.5.0
um                    randconfig-002-20260601    gcc-14
um                    randconfig-002-20260601    gcc-15.2.0
um                    randconfig-002-20260601    gcc-8.5.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    clang-20
x86_64      buildonly-randconfig-001-20260601    clang-20
x86_64               buildonly-randconfig-002    clang-20
x86_64      buildonly-randconfig-002-20260601    clang-20
x86_64               buildonly-randconfig-003    clang-20
x86_64      buildonly-randconfig-003-20260601    clang-20
x86_64               buildonly-randconfig-004    clang-20
x86_64      buildonly-randconfig-004-20260601    clang-20
x86_64      buildonly-randconfig-004-20260601    gcc-12
x86_64               buildonly-randconfig-005    clang-20
x86_64      buildonly-randconfig-005-20260601    clang-20
x86_64               buildonly-randconfig-006    clang-20
x86_64      buildonly-randconfig-006-20260601    clang-20
x86_64      buildonly-randconfig-006-20260601    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260601    clang-20
x86_64                randconfig-001-20260601    gcc-14
x86_64                randconfig-002-20260601    clang-20
x86_64                randconfig-002-20260601    gcc-14
x86_64                randconfig-003-20260601    clang-20
x86_64                randconfig-004-20260601    clang-20
x86_64                randconfig-005-20260601    clang-20
x86_64                randconfig-006-20260601    clang-20
x86_64                randconfig-011-20260601    clang-20
x86_64                randconfig-012-20260601    clang-20
x86_64                randconfig-012-20260601    gcc-14
x86_64                randconfig-013-20260601    clang-20
x86_64                randconfig-014-20260601    clang-20
x86_64                randconfig-014-20260601    gcc-14
x86_64                randconfig-015-20260601    clang-20
x86_64                randconfig-015-20260601    gcc-14
x86_64                randconfig-016-20260601    clang-20
x86_64                randconfig-016-20260601    gcc-14
x86_64                randconfig-071-20260601    clang-20
x86_64                randconfig-071-20260601    gcc-14
x86_64                randconfig-072-20260601    gcc-14
x86_64                randconfig-073-20260601    clang-20
x86_64                randconfig-073-20260601    gcc-14
x86_64                randconfig-074-20260601    gcc-14
x86_64                randconfig-075-20260601    gcc-14
x86_64                randconfig-076-20260601    gcc-12
x86_64                randconfig-076-20260601    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260601    gcc-15.2.0
xtensa                randconfig-001-20260601    gcc-8.5.0
xtensa                         randconfig-002    gcc-8.5.0
xtensa                randconfig-002-20260601    gcc-15.2.0
xtensa                randconfig-002-20260601    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

