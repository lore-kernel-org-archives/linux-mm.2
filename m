Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C24CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F8A6B0099; Tue, 12 May 2026 15:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40D86B009B; Tue, 12 May 2026 15:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F1D6B009F; Tue, 12 May 2026 15:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E04B6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:15:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29BD71405E4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:15:05 +0000 (UTC)
X-FDA: 84759720570.16.F48AC72
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id DFA34C000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:15:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xb0MNy2l;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778613303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=aXKqhfJtzcCrbf8M405Wz60Zz88jLqBBjovy+43zgNQ=;
	b=J5wtlITSN2FN7wax9j5u/t37gF+0SHG2tI6FPVHNZRkyl2ewAdlfT19vhlgwV1JFSG3FlZ
	RlQ7h97ZTVCJcUj4KJooHjLIPYUiJpxgVruKTn5ELVoGPWAMkZeFQNd8YEaD3tJKEP/tBC
	+ssPIgHVrEve0AJTNGJpOCKSYhKq9no=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xb0MNy2l;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778613303; a=rsa-sha256;
	cv=none;
	b=7FX4MJAfDzuxzxnEEzLllR8oCpx57fqJTZztOBCWuKqwdZflMv9kJkcM4CUQbWI5PH/zu6
	sEE39g7OfyUGZDAmxJh8seb08xjtCTmY1IARFo+Q9uQNRxpzMuE0uPvnWPFZKGGaom6kHT
	To+jWj8ofzrAIUS6TyOd46rBLOZDT48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778613302; x=1810149302;
  h=date:from:to:cc:subject:message-id;
  bh=fLnUj5Oo3ItdvS2tfhxisVTi7vQLwdA+UbD22bUQWds=;
  b=Xb0MNy2lLL2TRtDkMhmZacvyrlFERbJdkBvEVvdbL+1A48BaakaU2nEZ
   sA9wyXssMx5JwCSzc8+ZXeqhp6bDv2/Om/uAA4kC0WCZSShjwF5XwhoFR
   dtzrJIZsz/URzcwPmHeWBD6Soldo5sNPLsfmx8DhhzXm6q4wD5mmkxOaK
   8ST/0qYQ2np95ugJzwkuYumKkQ5t2uL3J/sAHc4TVPpDzmqBLb7yaG/gI
   dciul7N5xiokCnJP0y0kImHHZp3kdqVVQYPU2WgDypWVgzXrz6I4ik7je
   Uc8MSzLMXYdhvNTrlxkNvSLqzfF3rkB/xr6heUqZ1kDfccugJe/CbAxfb
   w==;
X-CSE-ConnectionGUID: 4wgSXAt3TJGgglvXMArzlA==
X-CSE-MsgGUID: A4bkDm/0T0iAo9RmA5FeVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83405989"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83405989"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:15:00 -0700
X-CSE-ConnectionGUID: 6sSl0Z4MQvaxRI+IVRICVw==
X-CSE-MsgGUID: yVmodjmWSR2wah+z9RdtMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="242828219"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 12 May 2026 12:14:58 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMsZE-000000002fX-1Jhq;
	Tue, 12 May 2026 19:14:56 +0000
Date: Wed, 13 May 2026 03:14:36 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 30424114b17dd65c098749cedcaef301c1dd2f86
Message-ID: <202605130326.W8qdYEvy-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: wmrqo5puoiqwaa959fs3hxxjd14s47hr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFA34C000E
X-Rspam-User: 
X-HE-Tag: 1778613301-156292
X-HE-Meta: U2FsdGVkX1+WlXA6N2c7D9Hs104yU4ukhFg9KBslrPnUtiYcoOp3i6XoK8C9ZRmw7IjWPBENvydstV5JQzGu0pdUjigxgA6FiEoWeoHGIM53BW2eC3TlV/k1Zs/qQGCDwMizreRSs2NF+tgYQ/YqX4lLn3qMyNKEMGIxp+cib/0xgzQfmgRZO3l940R4ItYUwV+9uurdpjxaljLV7nrSGaWmb+KK0DEFa/fw64IaVGgUOrvyIicWWDTY0rLLnDauUg2WzMeEx6I4DOio64E0uqXBvsWxgAK/ybWtDruayYVuoqr3uQmTzah9mHmry8xTwFjYx0Sefiox2ixJri4Amwc26OciPH7FwBJ+JnY9gp9VAgmtYdNC3PJhe1zO1BLMCFHVsrVndnaQAUIYxKWSbig6KAW4Slrx5o1n/o913A3Gf+3DF3CfqBAZyUC09PifCqWKPxvT0WgYGGzae75HeSj++/Ouu9f+Y4HbciBRJ6zYqVVLXScZJXRuTR1sq1dQKoCDxb2jG2F78mfPgLNfyzUIM2xjkPLzdfH7Dq0y2O81gpuhs/Qkkg3ItVr0TfGaeXQ9nLrY/T0jATgCxH1g5K6AbdKyoCGgRJV5HhfGNfkMYeD/L5M+NQK8CE8vd8o/VLs0FMk5sg3DY9ktBezt+rI0AThodjAMAPZluWx+VSOQYbbz3SlCt8P3E5i1nlCHhIouwUI0bXxsSgg/uGLIBA4dKJcPzcD405cIgs9IEoFIjYoaBfRnTA5T95Ht3ZShbnuk9dSbfrLU6/FSGGNcmA5exdYIwcpwJTDPsTBg3137BGiV6KvxnBA10Xr5/DTpO1i7FHdl95LS3i6J7qKZo7uUqYGw7cQluucfw1WZlLrbFtvwTzrMYlgVAYYjPwB0zbWpYn/SimW/ooXp4K5M2VcIE/LDkkflD9G3YuLzPmz5g5us8WGT69yQAjUQCZSaG1HhLohukxVvkAtI+IO
 re1Yt9DU
 4EoN1SVumEk1mchTgVUim1klzTnWz7O+n+eEVL1xr3H3KoxM2tWN2RdsucVnH0v7pZCkJRMiMaGgsHNqDXZy1wqPlxUcNpKTOeoAUq6gCDAT64NVrCHqnKjGc94pey3Fa3vpV+90o1iQxOGW3g9XEF2nGvZMYhWGhC0Yw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 30424114b17dd65c098749cedcaef301c1dd2f86  mm/memory_hotplug: factor out altmap freeing checks

elapsed time: 760m

configs tested: 337
configs skipped: 15

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
arc                         haps_hs_defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260512    gcc-11.5.0
arc                   randconfig-001-20260512    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260512    gcc-11.5.0
arc                   randconfig-002-20260512    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                      footbridge_defconfig    clang-17
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260512    clang-23
arm                   randconfig-001-20260512    gcc-11.5.0
arm                   randconfig-001-20260512    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260512    gcc-11.5.0
arm                   randconfig-002-20260512    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260512    clang-23
arm                   randconfig-003-20260512    gcc-11.5.0
arm                   randconfig-003-20260512    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260512    gcc-11.5.0
arm                   randconfig-004-20260512    gcc-8.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260512    clang-23
arm64                 randconfig-001-20260512    gcc-12.5.0
arm64                 randconfig-001-20260512    gcc-14.3.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260512    clang-23
arm64                 randconfig-002-20260512    gcc-14.3.0
arm64                 randconfig-002-20260512    gcc-8.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260512    clang-23
arm64                 randconfig-003-20260512    gcc-14.3.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260512    clang-23
arm64                 randconfig-004-20260512    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260512    clang-23
csky                  randconfig-001-20260512    gcc-11.5.0
csky                  randconfig-001-20260512    gcc-14.3.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260512    clang-23
csky                  randconfig-002-20260512    gcc-12.5.0
csky                  randconfig-002-20260512    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260512    clang-23
hexagon               randconfig-001-20260512    gcc-10.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260512    clang-23
hexagon               randconfig-002-20260512    gcc-10.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260512    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260512    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260512    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260512    clang-20
i386        buildonly-randconfig-004-20260512    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260512    clang-20
i386        buildonly-randconfig-005-20260512    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260512    clang-20
i386        buildonly-randconfig-006-20260512    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260512    clang-20
i386                  randconfig-001-20260512    gcc-14
i386                  randconfig-002-20260512    gcc-14
i386                  randconfig-003-20260512    gcc-13
i386                  randconfig-003-20260512    gcc-14
i386                  randconfig-004-20260512    clang-20
i386                  randconfig-004-20260512    gcc-14
i386                  randconfig-005-20260512    clang-20
i386                  randconfig-005-20260512    gcc-14
i386                  randconfig-006-20260512    clang-20
i386                  randconfig-006-20260512    gcc-14
i386                  randconfig-007-20260512    clang-20
i386                  randconfig-007-20260512    gcc-14
i386                           randconfig-011    clang-20
i386                  randconfig-011-20260512    clang-20
i386                  randconfig-011-20260512    gcc-14
i386                           randconfig-012    clang-20
i386                  randconfig-012-20260512    clang-20
i386                           randconfig-013    clang-20
i386                  randconfig-013-20260512    clang-20
i386                           randconfig-014    clang-20
i386                  randconfig-014-20260512    clang-20
i386                           randconfig-015    clang-20
i386                  randconfig-015-20260512    clang-20
i386                  randconfig-015-20260512    gcc-14
i386                           randconfig-016    clang-20
i386                  randconfig-016-20260512    clang-20
i386                  randconfig-016-20260512    gcc-14
i386                           randconfig-017    clang-20
i386                  randconfig-017-20260512    clang-20
i386                  randconfig-017-20260512    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260512    clang-18
loongarch             randconfig-001-20260512    gcc-10.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260512    gcc-10.5.0
loongarch             randconfig-002-20260512    gcc-15.2.0
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
mips                     cu1000-neo_defconfig    gcc-15.2.0
mips                   sb1250_swarm_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260512    gcc-10.5.0
nios2                 randconfig-001-20260512    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260512    gcc-10.5.0
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
parisc                randconfig-001-20260512    gcc-11.5.0
parisc                randconfig-001-20260512    gcc-12.5.0
parisc                randconfig-001-20260513    gcc-8.5.0
parisc                randconfig-002-20260512    gcc-12.5.0
parisc                randconfig-002-20260512    gcc-9.5.0
parisc                randconfig-002-20260513    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260512    clang-23
powerpc               randconfig-001-20260512    gcc-12.5.0
powerpc               randconfig-001-20260513    gcc-8.5.0
powerpc               randconfig-002-20260512    gcc-12.5.0
powerpc               randconfig-002-20260513    gcc-8.5.0
powerpc64             randconfig-001-20260512    gcc-12.5.0
powerpc64             randconfig-001-20260513    gcc-8.5.0
powerpc64             randconfig-002-20260512    gcc-12.5.0
powerpc64             randconfig-002-20260513    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260512    gcc-15.2.0
riscv                 randconfig-001-20260512    gcc-9.5.0
riscv                 randconfig-001-20260513    gcc-15.2.0
riscv                 randconfig-002-20260512    gcc-15.2.0
riscv                 randconfig-002-20260512    gcc-8.5.0
riscv                 randconfig-002-20260513    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260512    clang-18
s390                  randconfig-001-20260512    gcc-15.2.0
s390                  randconfig-001-20260513    gcc-15.2.0
s390                  randconfig-002-20260512    clang-23
s390                  randconfig-002-20260512    gcc-15.2.0
s390                  randconfig-002-20260513    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260512    gcc-15.2.0
sh                    randconfig-001-20260513    gcc-15.2.0
sh                    randconfig-002-20260512    gcc-15.2.0
sh                    randconfig-002-20260513    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                          randconfig-001    gcc-13.4.0
sparc                 randconfig-001-20260512    gcc-13.4.0
sparc                          randconfig-002    gcc-13.4.0
sparc                 randconfig-002-20260512    gcc-12.5.0
sparc                 randconfig-002-20260512    gcc-13.4.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-13.4.0
sparc64               randconfig-001-20260512    gcc-13.4.0
sparc64               randconfig-001-20260512    gcc-14.3.0
sparc64                        randconfig-002    gcc-13.4.0
sparc64               randconfig-002-20260512    gcc-13.4.0
sparc64               randconfig-002-20260512    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-13.4.0
um                    randconfig-001-20260512    gcc-13.4.0
um                    randconfig-001-20260512    gcc-14
um                             randconfig-002    gcc-13.4.0
um                    randconfig-002-20260512    clang-23
um                    randconfig-002-20260512    gcc-13.4.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260512    gcc-14
x86_64      buildonly-randconfig-002-20260512    clang-20
x86_64      buildonly-randconfig-002-20260512    gcc-14
x86_64      buildonly-randconfig-003-20260512    gcc-14
x86_64      buildonly-randconfig-004-20260512    clang-20
x86_64      buildonly-randconfig-004-20260512    gcc-14
x86_64      buildonly-randconfig-005-20260512    gcc-14
x86_64      buildonly-randconfig-006-20260512    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                         randconfig-001    gcc-14
x86_64                randconfig-001-20260512    clang-20
x86_64                randconfig-001-20260512    gcc-14
x86_64                         randconfig-002    gcc-14
x86_64                randconfig-002-20260512    gcc-14
x86_64                         randconfig-003    gcc-14
x86_64                randconfig-003-20260512    gcc-14
x86_64                         randconfig-004    gcc-14
x86_64                randconfig-004-20260512    gcc-12
x86_64                randconfig-004-20260512    gcc-14
x86_64                         randconfig-005    gcc-14
x86_64                randconfig-005-20260512    gcc-14
x86_64                         randconfig-006    gcc-14
x86_64                randconfig-006-20260512    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260512    clang-20
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260512    clang-20
x86_64                         randconfig-013    clang-20
x86_64                randconfig-013-20260512    clang-20
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260512    clang-20
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260512    clang-20
x86_64                randconfig-015-20260512    gcc-14
x86_64                         randconfig-016    clang-20
x86_64                randconfig-016-20260512    clang-20
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260512    clang-20
x86_64                randconfig-071-20260512    gcc-13
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260512    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260512    clang-20
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260512    clang-20
x86_64                randconfig-074-20260512    gcc-14
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260512    clang-20
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260512    clang-20
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
xtensa                         randconfig-001    gcc-13.4.0
xtensa                randconfig-001-20260512    gcc-13.4.0
xtensa                randconfig-001-20260512    gcc-8.5.0
xtensa                         randconfig-002    gcc-13.4.0
xtensa                randconfig-002-20260512    gcc-13.4.0
xtensa                randconfig-002-20260512    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

