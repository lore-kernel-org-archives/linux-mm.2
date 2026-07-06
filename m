Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2AA5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE21B6B00CA; Mon,  6 Jul 2026 08:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9D56B00CB; Mon,  6 Jul 2026 08:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF256B00CC; Mon,  6 Jul 2026 08:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5CA6B00CA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:05:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1BFF1C77E8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:05:56 +0000 (UTC)
X-FDA: 84958223112.15.674085D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74EB618000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:05:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GacbUJy3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783339555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=29b9+il9tK3mum/VtexmxNg7BoPa5Kw6Xl0cU0hFXho=;
	b=a/ZPBdWhF13XVD7zwOgD+nhrrPRjgdaBfrSkrj1G/M9G8Z00I9JpXP06xdCFG9iYGbadta
	Qvy/JMuAgH2wf79x2hXr2ABD8hLVccO/PMdpIpr1uBKMF+RLHmtfHepmcmJugA2qseCTMW
	L8C6kHxH9vnrj/eKNIKjK267hxP1va8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GacbUJy3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783339555;
	b=dDpaCusNHxRyHbIV1L6bcX0DTlC7TIgxbWyK6SKSCG9L/dcTbbAnHlJaCDPaXBxbk7FS8C
	++/7toFfPE+CBstsKiF0qP1AjRLjeYyJFakwVqHe5l6RMMvU7yZ0J5T83OOhNtTXDebAnW
	cD6QSv5WStSKUrrtuN58yi6+9RCF5LE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783339553; x=1814875553;
  h=date:from:to:cc:subject:message-id;
  bh=5NGVxJ/bCfENHzLm8vVpr0LDa4FBZfdDOtrDUXdJpPQ=;
  b=GacbUJy3BJOpoE5LRIWanYsfERbKFYOTfcazo8J324+P7Zny0e0ituW/
   8QjxSuItRIBoBW3DEAyylt9UIQi15SmMzS7CU9X49qgewIOX1BY1n9NXf
   rQD89vVKaKBxnd0j9TokS+QKL4+gRm9LQPB4fGmTsUSjwvhKYqK1fvVJR
   gklKgJ2NgxLn9Y+J2mR0DqMUig7UsWb/SNfd9se6pe1PqUfpDFFOWFGbK
   /bF34oTSgnLmPP6QaMWnlvqkRbMDt7mufLieIdwbG05HmV8hozFiVJhg5
   ZcIDqWvk4IpAlp5vyvb4U0nzSvTmhToN1FHn/+wcdCGRKt8DmKpENCEFS
   A==;
X-CSE-ConnectionGUID: rGJDqeLfRWGGsWukushQnA==
X-CSE-MsgGUID: r3j3xAfuSIOBerqXlTNF6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11838"; a="83840973"
X-IronPort-AV: E=Sophos;i="6.25,149,1779174000"; 
   d="scan'208";a="83840973"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 05:05:52 -0700
X-CSE-ConnectionGUID: N9Pc3WNASGSbDauLYB/OAQ==
X-CSE-MsgGUID: dWYf0/4NQGe9N6/7C0yakw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,149,1779174000"; 
   d="scan'208";a="249702510"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 06 Jul 2026 05:05:50 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wgi4b-00000000ELD-1PxG;
	Mon, 06 Jul 2026 12:05:27 +0000
Date: Mon, 06 Jul 2026 20:03:52 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 820d5dfede0cd55dcbc89ce96fcfbb11b7c457ba
Message-ID: <202607062041.7bw8I60Y-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74EB618000F
X-Stat-Signature: a1zoimwi5cec4trfiyxmndccirfm3e6t
X-HE-Tag: 1783339553-170760
X-HE-Meta: U2FsdGVkX197Gwj3/91LT0LfBloTL6BNfEdyv5yH838jdrcS5MXirQZVtR70JPflOpQfHcv2D0o7+tm2dmvdQUNiz5Rh2hOXDIbCPCuShvsD/ruUapQUZXzCCNODZOGMTzlV8OjPBsWa9DXp3coXzTlXUN4JWC+5qo+B10axaUY45zZgZIIzZzUY7iBoDEtPXAg1NreH9affrVBV8BlXl96eAjTp7X+1k+LNQlHZBTo77gZh3iYluMhZRm3pGj/4EfXL6/7qps4jUwZ6WBae3B2DzBET0vK1e6/MdJGZg5iJ3fV3kewpnS2wza6RFp2Zgr6WMxSHTyGiEkjj//dqVGNGcaGFqj6VigDdjJRMM7FOjV2B8vYUAmidwkJT/biB+V0kb6ua5p2VA5xAUfmCa7pO8orzzcI2CIkHllAW8H/+UZ2Ib/HCcGZeUv8rPUPp7hdqoCRLif0P5J7DFIBtejx6AaSGAbfXZ30oCjgxUOlCEfothPg1Ls3/BDKrhkHRRj+Sgq0V8qFjzJRtUooZpjZUb5WLoXtJfwmTfhFzEzv+8bvjo2UIA6EAqQ/grKcFNDt75MHiGUOjgddflbDx/IDOJZcCIB4nJg9Tg/eHP6ulsvRuPPxOrz/ul/p9+FRgCRvon23XD8GjH6XQ8Aws6/09V6QQKjlZoYMAtzZVvLitUYaq0UBINNgUd4QlC0SAtnTluV+H7SR5bId3mcoghMH7FuJdFIpjaKZeMNHr3Gs6ltH9SLp5uPvXyB3HM35uu/C5862LsQzKbB2/AbRkCW/DiSZ2UPxhmtisbzYK7XVvG7GrpZMYIuA11C6iIh1pQzqgycoHTNmJAEI9g8KJGOBN9crA6y0xUy5OphC3IzlLnyg4FKoS+vh4FWPJZnl9+vLk4sJtIdwYa/LyLkSFo+i3SpPEMPs20zRHveXqYc1b/JDRgJagh8bkoe4tOET1FeCMzM58DxS8WA63XcD
 glIxgNNT
 zI9RXTDFCK/W+GdjX3gCvAjFlolZfKP2wwyc9pk4aGE9K4gPi78iepL5Vd8oAlboQ6hH3mTfBEQGIZbxhkzH8Q12w1TlB5lmX1MrftXYpNuADz4Gy7Uojtp61UADmnGhyu80ZtlfYW0RtEGQ0fSXWQUJ+VIDRKebhKmQBhtvLWpre4xoZzAObC1AG33CUiliKgR+qJF3hnookQYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 820d5dfede0cd55dcbc89ce96fcfbb11b7c457ba  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 726m

configs tested: 304
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

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
arc                   randconfig-001-20260706    gcc-15.2.0
arc                   randconfig-002-20260706    gcc-15.2.0
arc                   randconfig-002-20260706    gcc-9.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260706    clang-23
arm                   randconfig-001-20260706    gcc-15.2.0
arm                   randconfig-002-20260706    gcc-15.2.0
arm                   randconfig-003-20260706    gcc-13.4.0
arm                   randconfig-003-20260706    gcc-15.2.0
arm                   randconfig-004-20260706    clang-23
arm                   randconfig-004-20260706    gcc-15.2.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260706    clang-17
arm64                 randconfig-001-20260706    gcc-11.5.0
arm64                 randconfig-002-20260706    clang-17
arm64                 randconfig-002-20260706    gcc-11.5.0
arm64                 randconfig-003-20260706    gcc-11.5.0
arm64                 randconfig-003-20260706    gcc-15.2.0
arm64                 randconfig-004-20260706    clang-17
arm64                 randconfig-004-20260706    gcc-11.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260706    gcc-11.5.0
csky                  randconfig-001-20260706    gcc-9.5.0
csky                  randconfig-002-20260706    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260706    clang-17
hexagon               randconfig-001-20260706    gcc-11.5.0
hexagon               randconfig-001-20260706    gcc-16.1.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260706    clang-23
hexagon               randconfig-002-20260706    gcc-11.5.0
hexagon               randconfig-002-20260706    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-12
i386        buildonly-randconfig-001-20260706    clang-22
i386        buildonly-randconfig-001-20260706    gcc-12
i386                 buildonly-randconfig-002    gcc-12
i386        buildonly-randconfig-002-20260706    gcc-12
i386                 buildonly-randconfig-003    gcc-12
i386        buildonly-randconfig-003-20260706    clang-22
i386        buildonly-randconfig-003-20260706    gcc-12
i386                 buildonly-randconfig-004    gcc-12
i386        buildonly-randconfig-004-20260706    clang-22
i386        buildonly-randconfig-004-20260706    gcc-12
i386                 buildonly-randconfig-005    gcc-12
i386        buildonly-randconfig-005-20260706    clang-22
i386        buildonly-randconfig-005-20260706    gcc-12
i386                 buildonly-randconfig-006    gcc-12
i386        buildonly-randconfig-006-20260706    gcc-12
i386        buildonly-randconfig-006-20260706    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260706    clang-22
i386                  randconfig-001-20260706    gcc-14
i386                  randconfig-002-20260706    gcc-14
i386                  randconfig-003-20260706    gcc-14
i386                  randconfig-004-20260706    gcc-14
i386                  randconfig-005-20260706    clang-22
i386                  randconfig-005-20260706    gcc-14
i386                  randconfig-006-20260706    gcc-14
i386                  randconfig-007-20260706    clang-22
i386                  randconfig-007-20260706    gcc-14
i386                  randconfig-011-20260706    clang-22
i386                  randconfig-011-20260706    gcc-14
i386                  randconfig-012-20260706    clang-22
i386                  randconfig-013-20260706    clang-22
i386                  randconfig-013-20260706    gcc-14
i386                  randconfig-014-20260706    clang-22
i386                  randconfig-015-20260706    clang-22
i386                  randconfig-015-20260706    gcc-14
i386                  randconfig-016-20260706    clang-22
i386                  randconfig-017-20260706    clang-22
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260706    gcc-11.5.0
loongarch             randconfig-001-20260706    gcc-16.1.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260706    gcc-11.5.0
loongarch             randconfig-002-20260706    gcc-16.1.0
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
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260706    gcc-11.5.0
nios2                 randconfig-001-20260706    gcc-16.1.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260706    gcc-11.5.0
nios2                 randconfig-002-20260706    gcc-16.1.0
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
parisc                         randconfig-001    gcc-10.5.0
parisc                randconfig-001-20260706    gcc-10.5.0
parisc                randconfig-001-20260706    gcc-14.3.0
parisc                         randconfig-002    gcc-10.5.0
parisc                randconfig-002-20260706    gcc-10.5.0
parisc                randconfig-002-20260706    gcc-16.1.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                     asp8347_defconfig    clang-23
powerpc                      ppc44x_defconfig    clang-17
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260706    gcc-10.5.0
powerpc               randconfig-001-20260706    gcc-9.5.0
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260706    gcc-10.5.0
powerpc               randconfig-002-20260706    gcc-15.2.0
powerpc64                      randconfig-001    gcc-10.5.0
powerpc64             randconfig-001-20260706    gcc-10.5.0
powerpc64             randconfig-001-20260706    gcc-11.5.0
powerpc64                      randconfig-002    gcc-10.5.0
powerpc64             randconfig-002-20260706    gcc-10.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260706    clang-17
riscv                 randconfig-001-20260706    clang-23
riscv                 randconfig-002-20260706    clang-23
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260706    clang-23
s390                  randconfig-002-20260706    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260706    clang-23
sh                    randconfig-001-20260706    gcc-16.1.0
sh                    randconfig-002-20260706    clang-23
sh                    randconfig-002-20260706    gcc-16.1.0
sh                           se7721_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-16.1.0
sparc                 randconfig-001-20260706    gcc-12.5.0
sparc                 randconfig-001-20260706    gcc-14.3.0
sparc                          randconfig-002    gcc-11.5.0
sparc                 randconfig-002-20260706    gcc-14.3.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260706    gcc-14.3.0
sparc64               randconfig-001-20260706    gcc-16.1.0
sparc64                        randconfig-002    clang-20
sparc64               randconfig-002-20260706    gcc-14.3.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    clang-23
um                    randconfig-001-20260706    gcc-14
um                    randconfig-001-20260706    gcc-14.3.0
um                             randconfig-002    clang-23
um                    randconfig-002-20260706    gcc-14
um                    randconfig-002-20260706    gcc-14.3.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260706    clang-22
x86_64      buildonly-randconfig-001-20260706    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260706    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260706    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260706    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260706    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260706    clang-22
x86_64      buildonly-randconfig-006-20260706    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260706    clang-22
x86_64                randconfig-001-20260706    gcc-14
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260706    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260706    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260706    clang-22
x86_64                randconfig-004-20260706    gcc-14
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260706    clang-22
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260706    clang-22
x86_64                randconfig-006-20260706    gcc-13
x86_64                randconfig-011-20260706    gcc-14
x86_64                randconfig-012-20260706    gcc-14
x86_64                randconfig-013-20260706    gcc-14
x86_64                randconfig-014-20260706    gcc-14
x86_64                randconfig-015-20260706    gcc-14
x86_64                randconfig-016-20260706    gcc-14
x86_64                randconfig-071-20260706    gcc-14
x86_64                randconfig-072-20260706    clang-22
x86_64                randconfig-072-20260706    gcc-14
x86_64                randconfig-073-20260706    clang-22
x86_64                randconfig-073-20260706    gcc-14
x86_64                randconfig-074-20260706    clang-22
x86_64                randconfig-074-20260706    gcc-14
x86_64                randconfig-075-20260706    gcc-14
x86_64                randconfig-076-20260706    gcc-14
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
xtensa                         randconfig-001    gcc-8.5.0
xtensa                randconfig-001-20260706    gcc-14.3.0
xtensa                randconfig-001-20260706    gcc-16.1.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260706    gcc-14.3.0
xtensa                randconfig-002-20260706    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

