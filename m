Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855F0CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972EA6B0005; Thu, 11 Jun 2026 11:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923DE6B0088; Thu, 11 Jun 2026 11:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F6C6B008C; Thu, 11 Jun 2026 11:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 721A66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:29:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B6541206D9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:29:59 +0000 (UTC)
X-FDA: 84868017318.27.ECD722F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD878180009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:29:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J6Bof3Q4;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781191797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UL399tAXUy/yz9wTcGG0E2fauqMYGLmE3R7E5ec7p/o=;
	b=mmwWqGWYdw3i3gwWim0tWbUsmH2WsIgC53g96zQtb4zzMJLVrwWAI990Z9KZX0MZ4kTCnk
	krmstwmVl6U0DR+Pv6nOE9gm556YX7vYcJMBM9CF67Go6tA8igZeBkOx7mkuFukqoKQyeI
	D+Vu8M/oqo/qvrw2jNVeCo2hdUvONhE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J6Bof3Q4;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781191797;
	b=1igJWwvMxNRCurDSD3B435i78M6ABRRtW2fbXNDSb6CIZQIP+vXXAqO2md9dU+2CZipm3M
	++CQUfYgJIdumxs7hsIsB90AZbVWtuji6/TPdHUC4gxdzbLnVoGQCoy3VSzCYP6tVSVdlJ
	YaEXuq4/kAGstbm0iY6AJTq4kjImEB4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781191797; x=1812727797;
  h=date:from:to:cc:subject:message-id;
  bh=r/lgubdyb8HYf/OqAGkJEfFBVHt/7MAg62LHlvRX9mw=;
  b=J6Bof3Q4rHmmqOQxjEcErGyt7tYJ5Yoxxg+qpKsT9x/pvcgMNUqYDyf0
   8IHwTf8IEZuJrQImEIC7ZKy9Wg9av6hwE6MMJbAhRWJyJpM9IXk/M0ZfQ
   1fV4DZMy80JuybwYDRQjVVHOdjuqwEdpxseCLsY0vheAWfIG/SXm0f80a
   co16uBH55VbVQM8BJ0G09nr46BVJbapDYzPYcBePDVA0r6GQ+9xXft/XB
   myIxcLcIkMtTXg9RLU+yfhAtOj9YPcEedxzPcibMAHDbCbUTS6VVRlVHJ
   8aXS21ksjldviwf1qPe7dzg7V70Gc9sAOqs6giEU/6esK1NHEzSQ9R9bi
   g==;
X-CSE-ConnectionGUID: qh+7aNBVR6ayYMHVQEi8pg==
X-CSE-MsgGUID: wvKhnFiqReKeAQEZgoaVWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81143538"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="81143538"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 08:29:55 -0700
X-CSE-ConnectionGUID: pW1YX8IdRHSJ+v6A4KpMsQ==
X-CSE-MsgGUID: 5VmkSIZcR4CWJwTi31Hjjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="248388871"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 11 Jun 2026 08:29:53 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXhLq-00000000NLC-44AW;
	Thu, 11 Jun 2026 15:29:50 +0000
Date: Thu, 11 Jun 2026 23:28:53 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 801c5efa788952095586d076fed1ea4902facff8
Message-ID: <202606112343.XCw5UUJt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD878180009
X-Stat-Signature: o7h8cadcfehrwb9scjrg1dk7wnjwy69n
X-Rspam-User: 
X-HE-Tag: 1781191796-866993
X-HE-Meta: U2FsdGVkX1/3Vmey0ov2+huCEppC50XBXi/qmV/3JWLlRerWMluarRxNnksBP8/wJXO6xX8rVnhvVry6liEp58VjonNHZSnb/v03EVkZKTv3dadsdu1vQiHb9jrRKzn5QwztKNXLS/ewysU2EV5iI2PJSPS5MpMH3l4YAA0OuItKPObg92BW+ekFJBYax+7JebTBsQms2htQ2bETxEHyTnKiDNhnBsCeUN8FtG77uhUk6pvpBo9eR384OVUPIVjSWHNvX/3qwHDiwBfnJYj1XaY53JijcIqQdr5CbGQEbHEMXbQFIYxh5+1ffXgFDgBq7FnEqmbHAsMhBvtHPhcwZrnwhymhMsFiMnsBRQoSf0O0FMUYE/JKG6zwi79UFbkpNkbL3j/gYGJnEAohuPeimid/pHzqIRyy5ELmD08dJbD6eQgB/csSnDLnBCAyDrxfjLA75INulrCGqiXTrpe7L4imt5UeE2BZhNDBUwwOssTGVZ+M1/BSq5CcMUfzaQERIXCpO3sI+j5UghgPiUScp03PUxyiQbJZDIC9+5oPik/XZ9SvIcPt/SiMuSavR62JWg0ZRqck7mJVnnPxEONBK7BzJA3XWpT7BGVfu3PoIvhcqyyabPGM1WI5GMkL+lYhdoBODrHmqTsmHQ298PZaEDAYhgtjfJ55mJaUnExsAYglx8REbOikahkWr8LkvuSKprbD3LalCIDEo9x0rbpkh/CdkDxt+sIjuGseurZGNS/W+CdQQiBNtT/RaUA7+Ac0B/SY/cfxYS+ORZasQ25PP/IwacYubERmlbThlYzOy9TY/MW/JORGYake5iaTLbjvorvcco/9mCR8ZLXIVq78f56h93+ONQjnaF8C4iYA1yZVxPGcQI7oF2uN6Z/QZNXjTCxYIN7FnlwiDfQ00lPRnK0ywsI+AJH6XxXBgb6rrYgpmq3qZlt/hkmwUB79cc7FsqKBFvQuBdNFuF9wLSp
 MjkG6L3H
 xiVbljlm8WkM8RE7mVbgCPnA+bmBLK9t/MbVB77NHnn+leOo6MKa7PObh6WICAXuz/7ONg7Ni4uXtpDNDq8UXYQzq2CkeXgv/KjZG0eV0E2KCk0P364B+FO9hJI5JY/tKgilsgVBzX+5QO+m5XCc/d+TWavCM8oqPU/uJm7SmvBIZkgW+Q8dD1TIQc4GjJza7SvH93ioWV+t/mEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 801c5efa788952095586d076fed1ea4902facff8  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 822m

configs tested: 245
configs skipped: 16

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                        nsim_700_defconfig    gcc-16.1.0
arc                   randconfig-001-20260611    gcc-14.3.0
arc                   randconfig-002-20260611    gcc-14.3.0
arc                   randconfig-002-20260611    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                          pxa910_defconfig    gcc-16.1.0
arm                   randconfig-001-20260611    clang-16
arm                   randconfig-001-20260611    gcc-14.3.0
arm                   randconfig-002-20260611    gcc-10.5.0
arm                   randconfig-002-20260611    gcc-14.3.0
arm                   randconfig-003-20260611    gcc-12.5.0
arm                   randconfig-003-20260611    gcc-14.3.0
arm                   randconfig-004-20260611    clang-17
arm                   randconfig-004-20260611    gcc-14.3.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-002-20260611    clang-23
arm64                 randconfig-003-20260611    gcc-10.5.0
arm64                 randconfig-004-20260611    clang-22
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260611    gcc-16.1.0
csky                  randconfig-002-20260611    gcc-14.3.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260611    clang-16
hexagon               randconfig-001-20260611    clang-23
hexagon               randconfig-002-20260611    clang-16
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260611    clang-22
i386        buildonly-randconfig-002-20260611    clang-22
i386        buildonly-randconfig-003-20260611    clang-22
i386        buildonly-randconfig-004-20260611    clang-22
i386        buildonly-randconfig-005-20260611    clang-22
i386        buildonly-randconfig-005-20260611    gcc-14
i386        buildonly-randconfig-006-20260611    clang-22
i386        buildonly-randconfig-006-20260611    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260611    clang-22
i386                  randconfig-001-20260611    gcc-14
i386                  randconfig-002-20260611    gcc-14
i386                  randconfig-003-20260611    gcc-13
i386                  randconfig-003-20260611    gcc-14
i386                  randconfig-004-20260611    clang-22
i386                  randconfig-004-20260611    gcc-14
i386                  randconfig-005-20260611    gcc-14
i386                  randconfig-006-20260611    clang-22
i386                  randconfig-006-20260611    gcc-14
i386                  randconfig-007-20260611    gcc-14
i386                  randconfig-011-20260611    gcc-14
i386                  randconfig-012-20260611    gcc-14
i386                  randconfig-013-20260611    gcc-14
i386                  randconfig-014-20260611    gcc-12
i386                  randconfig-015-20260611    clang-22
i386                  randconfig-016-20260611    gcc-14
i386                  randconfig-017-20260611    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260611    clang-16
loongarch             randconfig-001-20260611    clang-18
loongarch             randconfig-002-20260611    clang-16
loongarch             randconfig-002-20260611    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
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
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260611    clang-16
nios2                 randconfig-001-20260611    gcc-11.5.0
nios2                 randconfig-002-20260611    clang-16
nios2                 randconfig-002-20260611    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-23
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260611    gcc-8.5.0
parisc                randconfig-002-20260611    gcc-13.4.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-002-20260611    gcc-8.5.0
powerpc                     taishan_defconfig    clang-21
powerpc64             randconfig-001-20260611    gcc-8.5.0
powerpc64             randconfig-002-20260611    gcc-12.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260611    gcc-12.5.0
riscv                 randconfig-001-20260611    gcc-8.5.0
riscv                 randconfig-002-20260611    clang-23
riscv                 randconfig-002-20260611    gcc-12.5.0
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260611    gcc-11.5.0
s390                  randconfig-001-20260611    gcc-12.5.0
s390                  randconfig-002-20260611    clang-23
s390                  randconfig-002-20260611    gcc-12.5.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-23
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260611    gcc-12.5.0
sh                    randconfig-002-20260611    gcc-10.5.0
sh                    randconfig-002-20260611    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260611    gcc-15.2.0
sparc                 randconfig-001-20260611    gcc-16.1.0
sparc                 randconfig-002-20260611    gcc-15.2.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260611    clang-23
sparc64               randconfig-001-20260611    gcc-15.2.0
sparc64               randconfig-002-20260611    gcc-11.5.0
sparc64               randconfig-002-20260611    gcc-15.2.0
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260611    clang-23
um                    randconfig-001-20260611    gcc-15.2.0
um                    randconfig-002-20260611    clang-23
um                    randconfig-002-20260611    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260611    gcc-14
x86_64      buildonly-randconfig-002-20260611    clang-22
x86_64      buildonly-randconfig-002-20260611    gcc-14
x86_64      buildonly-randconfig-003-20260611    clang-22
x86_64      buildonly-randconfig-003-20260611    gcc-14
x86_64      buildonly-randconfig-004-20260611    gcc-14
x86_64      buildonly-randconfig-005-20260611    clang-22
x86_64      buildonly-randconfig-005-20260611    gcc-14
x86_64      buildonly-randconfig-006-20260611    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260611    clang-22
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260611    clang-22
x86_64                         randconfig-003    clang-22
x86_64                randconfig-003-20260611    gcc-12
x86_64                         randconfig-004    clang-22
x86_64                randconfig-004-20260611    clang-22
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260611    gcc-14
x86_64                         randconfig-006    clang-22
x86_64                randconfig-006-20260611    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260611    clang-22
x86_64                randconfig-011-20260611    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260611    gcc-14
x86_64                         randconfig-013    clang-22
x86_64                randconfig-013-20260611    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260611    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260611    gcc-14
x86_64                         randconfig-016    clang-22
x86_64                randconfig-016-20260611    clang-22
x86_64                randconfig-016-20260611    gcc-14
x86_64                randconfig-071-20260611    clang-22
x86_64                randconfig-072-20260611    clang-22
x86_64                randconfig-073-20260611    clang-22
x86_64                randconfig-073-20260611    gcc-14
x86_64                randconfig-074-20260611    clang-22
x86_64                randconfig-075-20260611    clang-22
x86_64                randconfig-076-20260611    clang-22
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
xtensa                randconfig-001-20260611    gcc-15.2.0
xtensa                randconfig-001-20260611    gcc-8.5.0
xtensa                randconfig-002-20260611    gcc-15.2.0
xtensa                randconfig-002-20260611    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

