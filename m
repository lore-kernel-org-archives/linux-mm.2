Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBF3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 19:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88EE96B00B5; Fri,  3 Jul 2026 15:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CDE6B00B6; Fri,  3 Jul 2026 15:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B0D6B00B7; Fri,  3 Jul 2026 15:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 403AA6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:25:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB3FB1A029D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:25:20 +0000 (UTC)
X-FDA: 84948444000.17.852CAF4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DE754000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:25:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UVuOenAv;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783106718;
	b=vyUNXSM3UGDjlUmySST+mIQf9H+kIjWL6FeJuHRIPK6e3jIWQgxqcZKeApzPwFhpYXTKsJ
	qEh/2Dp/eyG1WP9fy/G9m1tUtCMq7VoSS6jnlrBKaEmEKJhadcnVGM99JCUR0PeXaxGKBO
	0j4MRRFRfaJN+iY0DgE73UVgRQaF5iA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783106718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/rnCJMqAOQynhBuUvVpLljWGiQ4gvD67pKSullqMetM=;
	b=Kmpkemo0trEeAlkKAAP4yS43C3y8HJgpQdAfdcivfpoxgWXnxw9qyXY3uGkokYmHxcakiJ
	NZnsTBIN1ciGLKVnPwTgsg324irnwl2/78mka9eNb69Cl7cwkPIJnannsIPyTrAsJO3y+Y
	e8+HO2ccPSSvjVA8yUeW7qv1v2YH4xg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UVuOenAv;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783106717; x=1814642717;
  h=date:from:to:cc:subject:message-id;
  bh=zApyDOOildNlZEDGw3i11WhXgA7f73vPpNY9NQU6Wuo=;
  b=UVuOenAvzPzV/Nq94IVvh5ca3OqnZ9uHGdPODw7ThukKTXwl8Sn4KLT7
   goLzsYsDRONNFqJ/2imm0jNxT/miQJeMUOj8bx3T4rzzTDsac6fqHxoMK
   lsJV/+tP0SHKk6rFJNDCR6JmjefTSHX9UWCLX52pRgl3+v8GkTk28YKez
   LbVabMAwvXmrKwvRQVM5kW8B2Ti3v0lQ74lrZPRNUfDoYj4y1xBiPynTk
   tf0ufUiK2JzPREQtPYoJRk8h5ZfIE5/hWhd78RwlO5RZNh0T/j5evJGLs
   mbnbQ8vIOUhWIXJWJcM+ZHMN875ypxxTztsw5ySAGRk30cG1Vh4tPtgbF
   Q==;
X-CSE-ConnectionGUID: XEYGC4SDSkqmlrJ/s5/aqg==
X-CSE-MsgGUID: Xb9RE3aGT+eNJFlibXoDIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="94216942"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="94216942"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 12:25:15 -0700
X-CSE-ConnectionGUID: 6sF+NXEZS3Gs6blB6aQTHw==
X-CSE-MsgGUID: 3MIpNk9zSQqlPToxMtrLaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="252113132"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 03 Jul 2026 12:25:14 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfjVf-00000000CSJ-1l9v;
	Fri, 03 Jul 2026 19:25:11 +0000
Date: Sat, 04 Jul 2026 03:24:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 e031e55776cf9193b4720a253e92539ca536d224
Message-ID: <202607040324.guccBl0b-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 4ygjxheougq83he4ch678scagbiw3qfx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7DE754000B
X-HE-Tag: 1783106717-676265
X-HE-Meta: U2FsdGVkX1/girXepqW2zxM2I7MCPX9Y2p7fD3flr+GZ28dfjgaNV/iVKF+kVb1dVnsQWnmTVW5z3HUz2BgrRmqYYGxX489HL3k8Va2w0k9ohan2lB+GXK+/RO7zfIwqu/COJEyYueLlSLx9Epvm1BY7tmbW6fqqPZQgJP38kVz0JpgRa+FBurGFsUTyB0GTF78cJFGzJWp/85lXlxt5994XbuLy0cnIC6hhrty1mYFTS37Wj8aZsM56oOrESQgZrFBtuYiHHjWK3LednKcrTj+eoU805E2huFtGggUU7mEIKRCqmehpngqZffASYz95DFmjw+txmhlgNHNlcIPSJOJrWNizXLhs0Qr8zwOKhTOQADjDIJRwwuViIVCnE7c0W/C62S28wbOnZK/rvbJ4vIeIbrST9V2vjZIWgVlR9ZkywJFfnOAH6vQ75SKBjnsJBNwsucPJVy+xJwabUvAgDmQmYqi3mJQ+mH/jEgrhhAdlh3CZcs8M5bj3bi+ohqPXzIwfxXF8j1TF9BJGuQq6CYn4u8stpCya0pmsgAFcnjCyeUbfLrs0FB6vfoMOfzY7SLZisW6EWNb9Z94g8W2XDCQ3Bt6ubPGZM57oZf/bA6Fy0LK7jnF15XOEpoy4p4/uIsGXdGTgtA0mUg4FMkCpmxmZXoj9CE0tfBrKyWm7VFuVJq1FJ2pLGhqkFQVCyCBspvAfhJm/7tm5L8oG57sz14DmyuEuXOliQJGCd+j5gbY+xpfufSgyqfiizNad4fmZl517koKxKKpiHCiif3d/529840zRAMv+EN5qQZKVe8UWENRKXSU/7j7U7jU/Xdk0TgSarsYNfChUctn3ulqPNodOMLvg8+PM1xvatGp1IXQT9MFNOQkw6EDNFtRzGWm3uB6xSCCv0Xa59MAJ0+e8/fWf94n83KxzCOETiJ88v5laO8lnQFoDLO4yi+zuTQorvj226wdsQz+6S16WUkt
 7ta0vDG4
 IHLeElxe6yqAnUlC/uxEUlRHwSubdPMtKRpfTT+e0VSQB8bfpOrAQou/qxV+DbvjQb0t6SYpVWzMKMUFqiJiXfzXD8lLxlL8f7Sn/9hkr3ATaRpKlZKC4GvUHT2F2OHnHXjUG2RKYxHyTww28veGLNgrIlKKA9pGbMxPIm/y8fVF4rG5K/LYSsDSV94cHV8PBpzSP5SDCk/wSlsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e031e55776cf9193b4720a253e92539ca536d224  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 747m

configs tested: 317
configs skipped: 6

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
arc                          axs103_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-16.1.0
arc                   randconfig-001-20260703    gcc-8.5.0
arc                   randconfig-001-20260704    gcc-8.5.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-16.1.0
arc                   randconfig-002-20260703    gcc-8.5.0
arc                   randconfig-002-20260704    gcc-8.5.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    gcc-16.1.0
arm                        mvebu_v7_defconfig    clang-23
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-16.1.0
arm                   randconfig-001-20260703    gcc-8.5.0
arm                   randconfig-001-20260704    gcc-8.5.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-16.1.0
arm                   randconfig-002-20260703    gcc-8.5.0
arm                   randconfig-002-20260704    gcc-8.5.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-16.1.0
arm                   randconfig-003-20260703    gcc-8.5.0
arm                   randconfig-003-20260704    gcc-8.5.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-16.1.0
arm                   randconfig-004-20260703    gcc-8.5.0
arm                   randconfig-004-20260704    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-10.5.0
arm64                 randconfig-001-20260703    clang-23
arm64                 randconfig-001-20260703    gcc-10.5.0
arm64                 randconfig-001-20260704    gcc-16.1.0
arm64                          randconfig-002    gcc-10.5.0
arm64                 randconfig-002-20260703    gcc-10.5.0
arm64                 randconfig-002-20260703    gcc-12.5.0
arm64                 randconfig-002-20260704    gcc-16.1.0
arm64                          randconfig-003    gcc-10.5.0
arm64                 randconfig-003-20260703    gcc-10.5.0
arm64                 randconfig-003-20260704    gcc-16.1.0
arm64                          randconfig-004    gcc-10.5.0
arm64                 randconfig-004-20260703    gcc-10.5.0
arm64                 randconfig-004-20260703    gcc-8.5.0
arm64                 randconfig-004-20260704    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-10.5.0
csky                  randconfig-001-20260703    gcc-10.5.0
csky                  randconfig-001-20260703    gcc-12.5.0
csky                  randconfig-001-20260704    gcc-16.1.0
csky                           randconfig-002    gcc-10.5.0
csky                  randconfig-002-20260703    gcc-10.5.0
csky                  randconfig-002-20260704    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-11.5.0
hexagon               randconfig-001-20260703    gcc-16.1.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-11.5.0
hexagon               randconfig-002-20260703    gcc-16.1.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260703    clang-22
i386        buildonly-randconfig-001-20260703    gcc-14
i386        buildonly-randconfig-002-20260703    clang-22
i386        buildonly-randconfig-003-20260703    clang-22
i386        buildonly-randconfig-004-20260703    clang-22
i386        buildonly-randconfig-004-20260703    gcc-14
i386        buildonly-randconfig-005-20260703    clang-22
i386        buildonly-randconfig-005-20260703    gcc-14
i386        buildonly-randconfig-006-20260703    clang-22
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    clang-22
i386                  randconfig-001-20260703    clang-22
i386                           randconfig-002    clang-22
i386                  randconfig-002-20260703    clang-22
i386                           randconfig-003    clang-22
i386                  randconfig-003-20260703    clang-22
i386                           randconfig-004    clang-22
i386                  randconfig-004-20260703    clang-22
i386                           randconfig-005    clang-22
i386                  randconfig-005-20260703    clang-22
i386                           randconfig-006    clang-22
i386                  randconfig-006-20260703    clang-22
i386                           randconfig-007    clang-22
i386                  randconfig-007-20260703    clang-22
i386                           randconfig-011    clang-22
i386                  randconfig-011-20260703    clang-22
i386                  randconfig-011-20260703    gcc-12
i386                  randconfig-011-20260704    gcc-13
i386                           randconfig-012    clang-22
i386                  randconfig-012-20260703    clang-22
i386                  randconfig-012-20260703    gcc-14
i386                  randconfig-012-20260704    gcc-13
i386                           randconfig-013    clang-22
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260703    clang-22
i386                  randconfig-013-20260703    gcc-14
i386                  randconfig-013-20260704    gcc-13
i386                           randconfig-014    clang-22
i386                  randconfig-014-20260703    clang-22
i386                  randconfig-014-20260704    gcc-13
i386                           randconfig-015    clang-22
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260703    clang-22
i386                  randconfig-015-20260703    gcc-14
i386                  randconfig-015-20260704    gcc-13
i386                           randconfig-016    clang-22
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260703    clang-22
i386                  randconfig-016-20260703    gcc-14
i386                  randconfig-016-20260704    gcc-13
i386                           randconfig-017    clang-22
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260703    clang-22
i386                  randconfig-017-20260703    gcc-14
i386                  randconfig-017-20260704    gcc-13
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-11.5.0
loongarch             randconfig-001-20260703    gcc-16.1.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-11.5.0
loongarch             randconfig-002-20260703    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                          hp300_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-11.5.0
nios2                 randconfig-001-20260703    gcc-16.1.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-11.5.0
nios2                 randconfig-002-20260703    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    clang-23
parisc                randconfig-001-20260703    clang-23
parisc                randconfig-001-20260704    clang-23
parisc                         randconfig-002    clang-23
parisc                randconfig-002-20260703    clang-23
parisc                randconfig-002-20260704    clang-23
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                      chrp32_defconfig    clang-23
powerpc                     ep8248e_defconfig    gcc-16.1.0
powerpc                        randconfig-001    clang-23
powerpc               randconfig-001-20260703    clang-23
powerpc               randconfig-001-20260704    clang-23
powerpc                        randconfig-002    clang-23
powerpc               randconfig-002-20260703    clang-23
powerpc               randconfig-002-20260704    clang-23
powerpc64                      randconfig-001    clang-23
powerpc64             randconfig-001-20260703    clang-23
powerpc64             randconfig-001-20260704    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260703    clang-23
powerpc64             randconfig-002-20260704    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260703    gcc-9.5.0
riscv                 randconfig-001-20260704    gcc-10.5.0
riscv                 randconfig-002-20260703    gcc-9.5.0
riscv                 randconfig-002-20260704    gcc-10.5.0
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260703    gcc-9.5.0
s390                  randconfig-001-20260704    gcc-10.5.0
s390                  randconfig-002-20260703    gcc-9.5.0
s390                  randconfig-002-20260704    gcc-10.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                            hp6xx_defconfig    gcc-16.1.0
sh                    randconfig-001-20260703    gcc-9.5.0
sh                    randconfig-001-20260704    gcc-10.5.0
sh                    randconfig-002-20260703    gcc-9.5.0
sh                    randconfig-002-20260704    gcc-10.5.0
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260704    gcc-16.1.0
sparc                 randconfig-002-20260704    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260704    gcc-16.1.0
sparc64               randconfig-002-20260704    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260704    gcc-16.1.0
um                    randconfig-002-20260704    gcc-16.1.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-12
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260703    gcc-14
x86_64               buildonly-randconfig-002    clang-22
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260703    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260703    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260703    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260703    clang-22
x86_64      buildonly-randconfig-005-20260703    gcc-14
x86_64               buildonly-randconfig-006    clang-22
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260703    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    clang-22
x86_64                randconfig-001-20260703    clang-22
x86_64                         randconfig-002    clang-22
x86_64                randconfig-002-20260703    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260703    clang-22
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260703    clang-22
x86_64                         randconfig-005    clang-22
x86_64                randconfig-005-20260703    clang-22
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260703    clang-22
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260703    gcc-13
x86_64                randconfig-011-20260703    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260703    gcc-14
x86_64                         randconfig-013    clang-22
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260703    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260703    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260703    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260703    clang-22
x86_64                randconfig-016-20260703    gcc-14
x86_64                         randconfig-071    clang-22
x86_64                randconfig-071-20260703    clang-22
x86_64                         randconfig-072    clang-22
x86_64                randconfig-072-20260703    clang-22
x86_64                         randconfig-073    clang-22
x86_64                randconfig-073-20260703    clang-22
x86_64                         randconfig-074    clang-22
x86_64                randconfig-074-20260703    clang-22
x86_64                         randconfig-075    clang-22
x86_64                randconfig-075-20260703    clang-22
x86_64                         randconfig-076    clang-22
x86_64                randconfig-076-20260703    clang-22
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                randconfig-001-20260704    gcc-16.1.0
xtensa                randconfig-002-20260704    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

