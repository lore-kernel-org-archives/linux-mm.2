Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82411606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cyn5j2lw
Received: by kanga.kvack.org (Postfix)
	id 8EBCD6B00EF; Sat, 14 Nov 2026 16:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C556B05B0; Sat, 14 Nov 2026 16:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DC86B05B1; Sat, 14 Nov 2026 16:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAA26B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:22:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAA93120497
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:22:19 +0000 (UTC)
X-FDA: 85434997998.29.A4DEDB0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id D6B011C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:22:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cyn5j2lw;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794691338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=KP+xhGuqOBCrniIfNXqK5UXjpj2LBeDitK/IHjyAWLs=;
	b=mmKru39XWrEejxH13q4RUyjGHdIriwHHRquDcbSqBbcH95qi4VR4cBQ4a15ZDQaSQlbcu2
	qHT84j0X14+5RBtjazXc9ncx9sfWeSI2IY7HDXPk7T/UMSxfUVAemV/W8Dpepqqa9QT9lT
	XzjwOgVceUFlXEcrX1CKFHfkzoDhU+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794691338;
	b=x0IIsUw12BP8cbGjL1wRDdINw6x9T6CJlcOTotZMjZixf+iStU1zunp+ht7DL7Oz4AN/Td
	7+j3tU//Gts3Sgj3YSCG/ig6yw9DxHnN4l6P2dNCs+SFuZMH13348jHb9V4VsfMYD0TNFg
	wwv01cNJD3SI0yrJKUE9sYZFMuGgIDU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cyn5j2lw;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794691336; x=1826227336;
  h=date:from:to:cc:subject:message-id;
  bh=xwHfC60tUs13wURSEaf5tPhljOfQWW/KWgG0lIYh5R0=;
  b=cyn5j2lw9VppRyMa8zu+xYTNYw5dDOVOYV5uD5yCOYU6LEmoePFTRrFg
   vGdhzMgNPHNFjKG5DrH7OWGgLPWA2wCHSJuHqRASSfoVRgBVid0qWnhfX
   ZLrUU5dtFZw7Q+fs6ZQ9QQVvvQ5ElPWWCkvjG0ej0hFjMU230LVNvfuQX
   pMu2P5j6pWS8W8k2S0fbzSYkjtxYlNATwGIuHCSiXem5O2pfYM/jLFUqM
   ZoEXRn/HXsv+HEpMlR6+hMXn9ECmfQ9zsR2+BXjUkJoWjlSo95aDVJtVi
   XVMIycoZA9wL45c8ZzX/C9no9gi61F+vJJGbsgg2HWuSZLdnq8NwwOJ8d
   A==;
X-CSE-ConnectionGUID: WLEVfyuqQEq6eVF89F22nQ==
X-CSE-MsgGUID: 59ZRRjdaTh2oV3EuXdQpOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11966"; a="3345823"
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="3345823"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 13:22:14 -0800
X-CSE-ConnectionGUID: VxhAk3XCRmiG6twZBbpPeQ==
X-CSE-MsgGUID: 1DpS6jDeS7WkWrIQvEEWsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="9746716"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 14 Nov 2026 13:22:12 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSLCL-0000000160q-2N5A;
	Sat, 14 Nov 2026 21:22:09 +0000
Date: Sun, 15 Nov 2026 05:21:14 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 6ec534d64f85e949a5d58070678dcd7711875a7c
Message-ID: <20261115052113.pCDYACX7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Stat-Signature: gmag5rntr1dnnzcowwtie1rbn1zszw7z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D6B011C0005
X-Rspam-User: 
X-HE-Tag: 1794691335-198324
X-HE-Meta: U2FsdGVkX19aZ6cDU5RmDyHLUNjlpRsBVV0B3AIakoEUxhvckFZS+WZieTv8TGAzatmVBb3JsR3jZr+xJZcx1zJZGvV2B0DnIQqFFSAq84aQeIwveSL7M1gGy+bDqLU86WLYkrhetkeYJZNSrKofQ3rIZzpEIqH9VRqRlgFG+7hlW2b4YJRXi9z1vkkpORH45E3cULM0Jo/RpV5J05HKrnCfs9XRQZrAsvY9g5vRl9pJZ7xZv/I0Ggi1RejkI56tO2/bo0vs31D3eeHvqEaJZhBHngrII6qoEl/zsVJFIoYd6FVlpyqc9nBrtSXFz7VorxmzsjFzQJ2ZL4rFk8dmn88aN0U2jStP8ZQrmId/3BV760e4n/WD1vvu+pKFhJpFL+WKV2SQKEwahEAk0jAnKt64DmITozljjHV6iDCxuXp+VhEX1Fb0NtXe2jBQ6wLr6hLKRuuzgm86NPwQrW0OuxzYqWyjwRkNTi29CnHspqxFyfOQtXVlu7OI+szjnlHpiZKzze8RkaRDt2ZEFmhAM/FIyyTYoSgHSiFcyLdZbe5vhL9L5mTFpWutHIDJFwM1dz+UCyU+ts9hc4o89hehHLeLIYT5etRFLpOpzbIuNg6kbA6yezBjLvX0OqqsT4jZgNfeY5maPnWMP3b1XVayiDubOOlLh14tB0TIXSs12AyhvnaZOlmNnfxrzRt5bKv+YFFwPraBysFbTtKGjy0mk9O2rTaUwQB8xkEzuQN8w4SF4BJ2NPm73KDpqKU8rmhKTZiy4zvySwUuxcUwl3vvY4zdFQiUg0wuzr6ujE80BMeqSBsHMElyYYsiYnQeiK8iUBaz7SLw3g3oXf94bZSnWX5iNP8RqoGTe2hADJOx9MT1vHdMcwzbipthclUlGK+rym4ezdqsgRFO0NfHtj3IR6r23RRw9yV9piBELLUM2t5D1vrsT+0FNFij7s5ndaM3dmjv/gbzq2zW+xzn1Zb
 5nE0PHSB
 UM+/hjxhmGBt7hk7dJ94sXul65X+aiHii1VflTwnY1gpgQNH+X3RCxXYAfkclDSb16xyAkxFxjodzT+dg21FoQVof7ByxIxQsfiD3+qnwAXJsxGB3kIec9mZyDW/gTa42x6pQ2AqUvT3nYdUkrQdVQwryl6iCFAh3Rchs2y/SM57jA2rZyJwtNcGM+gZQKiv2ylEfaUOraNtTleg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 6ec534d64f85e949a5d58070678dcd7711875a7c  mm/madvise: zap markers from guard regions

elapsed time: 793m

configs tested: 344
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261114    gcc-8.5.0
alpha                 randconfig-2001-20261114    gcc-9.5.0
alpha                 randconfig-2200-20261114    gcc-9.5.0  smatch
alpha                randconfig-r2109-20261114    gcc-13.5.0 cocci
alpha                randconfig-r2110-20261114    gcc-16.2.0 cocci
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261115    gcc-11.5.0
arc                   randconfig-1001-20261115    gcc-11.5.0
arc                   randconfig-2000-20261114    gcc-11.5.0
arc                   randconfig-2001-20261114    gcc-13.5.0
arc                   randconfig-2002-20261114    gcc-11.5.0
arc                   randconfig-2003-20261114    gcc-13.5.0
arc                   randconfig-2004-20261114    gcc-8.5.0
arc                   randconfig-2005-20261114    gcc-9.5.0
arc                   randconfig-2200-20261114    gcc-8.5.0  smatch
arc                  randconfig-r2308-20261114    gcc-8.5.0  sparse
arc                  randconfig-r2309-20261114    gcc-8.5.0  sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261115    gcc-11.5.0
arm                   randconfig-1001-20261115    gcc-11.5.0
arm                   randconfig-1002-20261115    gcc-11.5.0
arm                   randconfig-1003-20261115    gcc-11.5.0
arm                   randconfig-2000-20261114    gcc-10.5.0
arm                   randconfig-2001-20261114    gcc-11.5.0
arm                   randconfig-2002-20261114    gcc-10.5.0
arm                   randconfig-2200-20261114    clang-17   smatch
arm                  randconfig-r2106-20261114    clang-17   cocci
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
arm64                 randconfig-2000-20261114    clang-22
arm64                 randconfig-2001-20261114    gcc-14.4.0
arm64                 randconfig-2002-20261114    clang-24
arm64                 randconfig-2200-20261114    clang-17   smatch
arm64                randconfig-r2104-20261114    clang-17   cocci
arm64                randconfig-r2108-20261114    clang-24   cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1001-20261114    gcc-16.2.0
csky                  randconfig-2000-20261114    gcc-16.2.0
csky                  randconfig-2001-20261114    gcc-13.5.0
csky                  randconfig-2200-20261114    gcc-16.2.0 smatch
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1001-20261114    clang-24
hexagon               randconfig-2000-20261114    clang-24
hexagon               randconfig-2001-20261114    clang-24
hexagon               randconfig-2200-20261114    clang-24   smatch
hexagon              randconfig-r2311-20261114    clang-17   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261114    gcc-14
i386        buildonly-randconfig-1001-20261114    gcc-14
i386        buildonly-randconfig-1002-20261114    gcc-14
i386        buildonly-randconfig-1003-20261114    gcc-14
i386        buildonly-randconfig-1004-20261114    gcc-14
i386        buildonly-randconfig-1005-20261114    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261114    gcc-12
i386                  randconfig-1000-20261115    clang-22
i386                  randconfig-1001-20261114    gcc-12
i386                  randconfig-1001-20261115    clang-22
i386                  randconfig-1002-20261114    gcc-12
i386                  randconfig-1002-20261115    clang-22
i386                  randconfig-1003-20261114    gcc-12
i386                  randconfig-1003-20261115    clang-22
i386                  randconfig-1004-20261114    gcc-12
i386                  randconfig-1004-20261115    clang-22
i386                  randconfig-1005-20261114    gcc-12
i386                  randconfig-1005-20261115    clang-22
i386                  randconfig-1006-20261114    gcc-12
i386                  randconfig-1006-20261115    clang-22
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1013-20261114    clang-22
i386                  randconfig-2000-20261114    clang-22
i386                  randconfig-2001-20261114    clang-22
i386                  randconfig-2002-20261114    clang-22
i386                  randconfig-2003-20261114    gcc-14
i386                  randconfig-2004-20261114    gcc-14
i386                  randconfig-2005-20261114    gcc-14
i386                  randconfig-2100-20261114    gcc-14     cocci
i386                  randconfig-2101-20261114    clang-22   cocci
i386                  randconfig-2102-20261114    gcc-14     cocci
i386                  randconfig-2103-20261114    gcc-14     cocci
i386                  randconfig-2104-20261114    gcc-14     cocci
i386                  randconfig-2105-20261114    clang-22   cocci
i386                  randconfig-2200-20261114    gcc-14     smatch
i386                  randconfig-2300-20261114    gcc-12     sparse
i386                  randconfig-2301-20261114    gcc-14     sparse
i386                  randconfig-2302-20261114    gcc-14     sparse
i386                 randconfig-r2100-20261114    gcc-14     cocci
i386                 randconfig-r2306-20261114    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1001-20261114    clang-24
loongarch             randconfig-2000-20261114    clang-22
loongarch             randconfig-2001-20261114    clang-24
loongarch             randconfig-2200-20261114    clang-18   smatch
loongarch            randconfig-r2111-20261114    clang-22   cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261114    gcc-8.5.0
m68k                  randconfig-2001-20261114    gcc-12.5.0
m68k                  randconfig-2200-20261114    gcc-16.2.0 smatch
m68k                 randconfig-r2310-20261114    gcc-14.4.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261114    gcc-15.3.0
microblaze            randconfig-2001-20261114    gcc-9.5.0
microblaze            randconfig-2200-20261114    gcc-9.5.0  smatch
microblaze           randconfig-r2105-20261114    gcc-8.5.0  cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261114    clang-24
mips                  randconfig-2001-20261114    gcc-8.5.0
mips                  randconfig-2002-20261114    gcc-13.5.0
mips                  randconfig-2200-20261114    gcc-15.3.0 smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1001-20261114    clang-24
nios2                 randconfig-2000-20261114    gcc-11.5.0
nios2                 randconfig-2001-20261114    gcc-11.5.0
nios2                 randconfig-2200-20261114    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc              randconfig-2000-20261114    gcc-16.2.0
openrisc              randconfig-2001-20261114    gcc-9.5.0
openrisc              randconfig-2002-20261114    gcc-16.2.0
openrisc              randconfig-2200-20261114    gcc-16.2.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                randconfig-2000-20261114    gcc-13.5.0
parisc                randconfig-2001-20261114    gcc-15.3.0
parisc                randconfig-2200-20261114    gcc-8.5.0  smatch
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-2000-20261114    gcc-8.5.0
powerpc               randconfig-2001-20261114    clang-19
powerpc               randconfig-2002-20261114    clang-21
powerpc               randconfig-2200-20261114    clang-24   smatch
powerpc64             randconfig-2000-20261114    clang-19
powerpc64             randconfig-2001-20261114    gcc-8.5.0
powerpc64             randconfig-2002-20261114    clang-24
powerpc64             randconfig-2200-20261114    clang-17   smatch
powerpc64            randconfig-r2301-20261114    gcc-14.4.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                 randconfig-1000-20261114    gcc-15.3.0
riscv                 randconfig-1001-20261114    gcc-15.3.0
riscv                 randconfig-2000-20261114    clang-24
riscv                 randconfig-2001-20261114    gcc-16.2.0
riscv                 randconfig-2002-20261114    gcc-14.4.0
riscv                 randconfig-2003-20261114    gcc-12.5.0
riscv                 randconfig-2004-20261114    clang-17
riscv                 randconfig-2005-20261114    clang-19
riscv                 randconfig-2200-20261114    clang-24   smatch
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261114    gcc-15.3.0
s390                  randconfig-1001-20261114    gcc-15.3.0
s390                  randconfig-2000-20261114    clang-21
s390                  randconfig-2001-20261114    clang-24
s390                  randconfig-2002-20261114    clang-24
s390                  randconfig-2003-20261114    gcc-12.5.0
s390                  randconfig-2004-20261114    clang-17
s390                  randconfig-2005-20261114    clang-24
s390                  randconfig-2200-20261114    clang-24   smatch
s390                 randconfig-r2305-20261114    clang-24   sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261114    gcc-15.3.0
sh                    randconfig-1001-20261114    gcc-15.3.0
sh                    randconfig-2000-20261114    gcc-16.2.0
sh                    randconfig-2001-20261114    gcc-16.2.0
sh                    randconfig-2002-20261114    gcc-16.2.0
sh                    randconfig-2003-20261114    gcc-16.2.0
sh                    randconfig-2004-20261114    gcc-11.5.0
sh                    randconfig-2005-20261114    gcc-13.5.0
sh                    randconfig-2200-20261114    gcc-9.5.0  smatch
sh                   randconfig-r2300-20261114    gcc-16.2.0 sparse
sh                   randconfig-r2302-20261114    gcc-13.5.0 sparse
sh                   randconfig-r2303-20261114    gcc-15.3.0 sparse
sh                   randconfig-r2304-20261114    gcc-13.5.0 sparse
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc                 randconfig-2000-20261114    gcc-11.5.0
sparc                 randconfig-2001-20261114    gcc-13.5.0
sparc                 randconfig-2200-20261114    gcc-8.5.0  smatch
sparc                randconfig-r2101-20261114    gcc-13.5.0 cocci
sparc                randconfig-r2103-20261114    gcc-8.5.0  cocci
sparc                randconfig-r2107-20261114    gcc-16.2.0 cocci
sparc                randconfig-r2307-20261114    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
sparc64               randconfig-2000-20261114    clang-24
sparc64               randconfig-2001-20261114    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                    randconfig-2000-20261114    clang-24
um                    randconfig-2001-20261114    clang-21
um                    randconfig-2200-20261114    gcc-14     smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261114    gcc-14
x86_64      buildonly-randconfig-1001-20261114    gcc-14
x86_64      buildonly-randconfig-1002-20261114    gcc-14
x86_64      buildonly-randconfig-1003-20261114    gcc-14
x86_64      buildonly-randconfig-1004-20261114    gcc-14
x86_64      buildonly-randconfig-1005-20261114    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1000-20261115    gcc-14
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1001-20261115    gcc-14
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1002-20261115    gcc-14
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1003-20261115    gcc-14
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1004-20261115    gcc-14
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1005-20261115    gcc-14
x86_64                randconfig-1006-20261114    gcc-14
x86_64                randconfig-1007-20261114    gcc-14
x86_64                randconfig-1008-20261114    gcc-14
x86_64                randconfig-1009-20261114    gcc-14
x86_64                randconfig-1010-20261114    gcc-14
x86_64                randconfig-1011-20261114    gcc-14
x86_64                randconfig-1012-20261114    clang-22
x86_64                randconfig-1012-20261115    gcc-14
x86_64                randconfig-1013-20261114    clang-22
x86_64                randconfig-1013-20261115    gcc-14
x86_64                randconfig-1014-20261114    clang-22
x86_64                randconfig-1014-20261115    gcc-14
x86_64                randconfig-1015-20261114    clang-22
x86_64                randconfig-1015-20261115    gcc-14
x86_64                randconfig-1016-20261114    clang-22
x86_64                randconfig-1016-20261115    gcc-14
x86_64                randconfig-1017-20261114    clang-22
x86_64                randconfig-1017-20261115    gcc-14
x86_64                randconfig-2000-20261114    gcc-14
x86_64                randconfig-2001-20261114    gcc-14
x86_64                randconfig-2002-20261114    clang-22
x86_64                randconfig-2003-20261114    gcc-14
x86_64                randconfig-2004-20261114    gcc-14
x86_64                randconfig-2005-20261114    gcc-14
x86_64                randconfig-2100-20261114    gcc-14     cocci
x86_64                randconfig-2101-20261114    gcc-12     cocci
x86_64                randconfig-2102-20261114    clang-22   cocci
x86_64                randconfig-2103-20261114    clang-22   cocci
x86_64                randconfig-2104-20261114    gcc-14     cocci
x86_64                randconfig-2105-20261114    gcc-14     cocci
x86_64                randconfig-2200-20261114    gcc-14     smatch
x86_64                randconfig-2300-20261114    gcc-12     sparse
x86_64                randconfig-2301-20261114    gcc-14     sparse
x86_64                randconfig-2302-20261114    clang-22   sparse
x86_64               randconfig-r2102-20261114    clang-22   cocci
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0
xtensa                randconfig-2000-20261114    gcc-9.5.0
xtensa                randconfig-2001-20261114    gcc-11.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

