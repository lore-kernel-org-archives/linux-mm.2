Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B42606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aqWRqHU8
Received: by kanga.kvack.org (Postfix)
	id F3A276B05B9; Fri, 30 Oct 2026 13:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8EF6B05BA; Fri, 30 Oct 2026 13:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF416B05BB; Fri, 30 Oct 2026 13:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDF506B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:24:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F76E1606CD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:24:44 +0000 (UTC)
X-FDA: 85379967288.12.BD28D0B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF137A0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:24:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aqWRqHU8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793381082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=cjvzieB2xfmCXn6g+QLg66M3I+bYxfDfj3rVMKyJmB4=;
	b=3OOWRedKYOQkkmzhO1VAv3cI5CElEW4zfEuMkbS4Um5vFreNTAacuVd3Zl8pnNn8v5XI2G
	RnAngaKoGcpp79MmObbQvF4GtlupRSwr1IbuVn60/OreL01S8LNVFLlVSfKuggHTfgIMIM
	bTy0I5zOwtazhpOBQkR3zTrEoxufk2U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aqWRqHU8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793381082;
	b=GwcSxFHww0COWO+0JlSJEcNrskNvsEv5cXt2g2Pc+1mXholARqOJLP0JOr0hxriENTTgAX
	6Q1731zFcmC5bFJdZ96NulsVeYX3P/nKyQZ/32RGtTPkpGDQmcPtNfieQde0W0WjgXfpV+
	uBJg5TgFmmYAo+dnNHczYnmFxVcrkfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793381082; x=1824917082;
  h=date:from:to:cc:subject:message-id;
  bh=XmjgKkiq8T6KWlXFBZuxUsxwhzykkYonEf3QZviu7js=;
  b=aqWRqHU8vRDV1csyfbyUJHLw8dlWHaPdTJTaIeHeDkRIQpDc/t8npGf0
   shxmI1W9uSOPI4FtZ26xeCzDazB+DvzIq2KXwsWfR3e2NP2fmWfVf8Mgq
   aQj+x6f4Igojrin5GdZTqtQBS34pQS30ZRFjJHsHQ3BR73Bxp8F/E+F+j
   cUj9TutGdoCCsTBn7KUpLgrAz2MrCmYCA9ZaNVwO07/KFuWdznDFxoQXO
   7MdDE+/OL2bNkItszt4m3CBCuCWRAzCkJNKkEZcz0GKlyuznjxETFXEe1
   HAN4TU4gr05o/zHmrqAnjsrTAtGy+4pf8d+v3R8hlBXVFBz0wT7VyRD9S
   g==;
X-CSE-ConnectionGUID: 2pkh7Ln2QyyqhfZ5TkrxQg==
X-CSE-MsgGUID: /9j1dX+ITJ2MmPY/T1MHQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2185139"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2185139"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 10:24:40 -0700
X-CSE-ConnectionGUID: m5cmepwQR+aJRfHdSWkKNg==
X-CSE-MsgGUID: eQh22w8HSEWmxGnQPOyxUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5893783"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 Oct 2026 10:24:39 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMqLE-00000000c2W-2pDC;
	Fri, 30 Oct 2026 17:24:36 +0000
Date: Sat, 31 Oct 2026 01:24:28 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9c449f885765cf8d80b2c60b1971e774bba51a3f
Message-ID: <202610310125.u2fTWy6p-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: CF137A0006
X-Stat-Signature: 7s1px78kph16dbor5ork4e98cc6m37fm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793381081-638043
X-HE-Meta: U2FsdGVkX1+9IXR3ghzRyQ8QR9mUjQV5UI1xCn5TN9CbzYXF1HlkBh0VhBdPZ16mQuPrblbvphUWHRsyn8fNWGZJjRAVCUwU4y9hKKd/EmR9f7FeXpgeX6fWl0QM/+mPqM713sigaN4PWwl9uFcfbXpbjNXRJc1hZm24P2AfVfJYjXa4veXhEr3SHnH4iCrEAMWtY+u3vIqWr9KYO50cVig/zQzr6KHqbf+6NZc9fvQ5oEzpSKPRREp+VWyUUAawlH0B2xV+ywgWBFQjhbrIKuVThwSh78HQoUS5qBOb5JvUuWVCmGqPOld/4geUZBiYSe3UOELiT3H1/LbtVDKz+ck7qVLeiy8LHawqbm6mvTHE2wjIlcCrfAuV1ahHsZTEJz8szNXN2tpcloyW8L/McrdV0ezpDrCCUDkQhx0zKnX0o43v31vDQjdrGYbOyC3aF5k1WC7kUvlAM6G6dLgRJgz2FgDhByzvJi24Z7NbqgD6hKE5d5owPFb1nEjZmhVg0TYxlZeoJqI/s039IzVmuV1i7r4O8Bx9Q1nbv3kUgqfiK3YLSTxlNx+tPFrLJAb0Rjfds7qWkxgxaNpFvDMsM4c9AxsUSX2pvP6/Kqc5NYHyelGnL1jRWaGXrc9+xP5sRxOI7EHcchj3jAra5cnAKre6AspKiviuseaeGJI3qTXo73cEOnhr+TjjI+nZLY8CPZyfuIHgJbni4JN0he/lPKd0h6HlQwvkX+HTghhOK38Ec9HTxb9QTnRbOU9xi/y0ENvuQ3qS7o7hCokYM95g0muQdIW6ug/8PFHQzr9cAS+0sFNouCVqdRyyq6llEO3KQN0NUe4HDSEq6/QzX+Te6LpK8xKmsoCrrX72yUG2tDXBid10uR8fTPoRxRbZ36e9TKLqH+SFGJA82cILE6mMAQy+vXeXoViX4HkJZvL6zA56AuE950vuBU1EeWNJEjTuibfftAHOK+PPLesu6Qn
 6UmP6xO6
 MvKgo7Nuz2EgGl/edOH+bT0z4b9+jmd2ULTmLbqlPCxM21wow6p04WwjkaF5BHNNhotgi593No2AG1MyCGH58ku/7zphDvkbWCtmwuAVmdApASVMlXL3zcU1YAFs00mKfet7+o+EF5O0xc5uEtijpp1JCQEZVEYKlKFfhXoPtLlyiCe9olvnDBG/pqvigebt9/JXdeqtZ0rInkPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9c449f885765cf8d80b2c60b1971e774bba51a3f  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 929m

configs tested: 154
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261030    gcc-12.5.0
arc                   randconfig-1001-20261030    gcc-10.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261030    clang-19
arm                   randconfig-1001-20261030    gcc-8.5.0
arm                   randconfig-1002-20261030    clang-24
arm                   randconfig-1003-20261030    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261030    clang-24
arm64                 randconfig-1001-20261030    gcc-13.5.0
arm64                 randconfig-1002-20261030    gcc-8.5.0
arm64                 randconfig-1003-20261030    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261030    gcc-16.2.0
csky                  randconfig-1001-20261030    gcc-14.4.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
i386                              alldefconfig    gcc-14
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261030    gcc-14
i386        buildonly-randconfig-1001-20261030    gcc-14
i386        buildonly-randconfig-1002-20261030    clang-22
i386        buildonly-randconfig-1003-20261030    gcc-14
i386        buildonly-randconfig-1004-20261030    gcc-14
i386        buildonly-randconfig-1005-20261030    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261030    clang-22
i386                  randconfig-1001-20261030    clang-22
i386                  randconfig-1002-20261030    gcc-14
i386                  randconfig-1003-20261030    clang-22
i386                  randconfig-1004-20261030    clang-22
i386                  randconfig-1005-20261030    gcc-14
i386                  randconfig-1006-20261030    gcc-14
i386                  randconfig-1008-20261030    gcc-14
i386                  randconfig-1010-20261030    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                        m5275evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261030    gcc-10.5.0
parisc                randconfig-1001-20261030    gcc-16.2.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    currituck_defconfig    clang-24
powerpc                    microwatt_defconfig    gcc-16.2.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.2.0
powerpc                   mpc866_ads_defconfig    clang-17
powerpc               randconfig-1000-20261030    clang-24
powerpc               randconfig-1001-20261030    gcc-11.5.0
powerpc                     socrates_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261030    clang-24
powerpc64             randconfig-1001-20261030    gcc-10.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv              nommu_k210_sdcard_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261030    gcc-13.5.0
riscv                 randconfig-1001-20261030    gcc-15.3.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261030    gcc-9.5.0
s390                  randconfig-1001-20261030    gcc-11.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261030    gcc-12.5.0
sh                    randconfig-1001-20261030    gcc-10.5.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261030    gcc-8.5.0
sparc                 randconfig-1001-20261030    gcc-14.4.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261030    gcc-13.5.0
sparc64               randconfig-1001-20261030    gcc-11.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261030    clang-17
um                    randconfig-1001-20261030    clang-24
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261030    gcc-14
x86_64      buildonly-randconfig-1001-20261030    clang-22
x86_64      buildonly-randconfig-1002-20261030    clang-22
x86_64      buildonly-randconfig-1003-20261030    gcc-14
x86_64      buildonly-randconfig-1004-20261030    gcc-14
x86_64      buildonly-randconfig-1005-20261030    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261030    clang-22
x86_64                randconfig-1001-20261030    gcc-14
x86_64                randconfig-1002-20261030    clang-22
x86_64                randconfig-1003-20261030    gcc-14
x86_64                randconfig-1004-20261030    gcc-14
x86_64                randconfig-1005-20261030    gcc-14
x86_64                randconfig-1006-20261030    gcc-14
x86_64                randconfig-1007-20261030    clang-22
x86_64                randconfig-1008-20261030    gcc-14
x86_64                randconfig-1009-20261030    gcc-14
x86_64                randconfig-1010-20261030    gcc-14
x86_64                randconfig-1011-20261030    clang-22
x86_64                randconfig-1012-20261030    gcc-14
x86_64                randconfig-1013-20261030    clang-22
x86_64                randconfig-1014-20261030    clang-22
x86_64                randconfig-1015-20261030    clang-22
x86_64                randconfig-1016-20261030    clang-22
x86_64                randconfig-1017-20261030    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261030    gcc-10.5.0
xtensa                randconfig-1001-20261030    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

