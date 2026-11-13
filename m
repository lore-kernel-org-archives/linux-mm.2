Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158C6606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VO2s4G9u
Received: by kanga.kvack.org (Postfix)
	id 309986B063A; Thu, 12 Nov 2026 20:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293C46B063B; Thu, 12 Nov 2026 20:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EEB6B063C; Thu, 12 Nov 2026 20:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9CC46B063A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:34:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDCC341C5E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:34:44 +0000 (UTC)
X-FDA: 85428376488.06.06B41F9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id B5F6720002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:34:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VO2s4G9u;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794533683;
	b=nXaHxD9UP6XT++l2biqb4n91AKYmBX4XkuJx5AUvlwtPP/HkufXE33G2165vB7JDone6PA
	ZeMXUt6hyfqTvVerWF6yqmBsdGk5nc9qUFMJesYlPHtbXbi4c/RFZ1yp/F9e9Vz7wOZBok
	+AkyfsNUaPzvxhz0BIz0vC32wlROqpM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VO2s4G9u;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794533683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=SmXB1T1DlkWcI+qjh/XbuuEYGGasK1b2JlDP33KWOzc=;
	b=VhskYxQUgmhEdopJ0RiYHdsw+0ph4ksSx8RzTxtKcNCixjl5c3XaFjTpo2T7ltYlp7sStl
	1VwJk1FrWHJS4izVVXcjSswQHrcfNu6TwtZ2E8Bu7NVXaLdRXXXwlqCRzLA3crXJbPQ/4W
	i6l9j8uaypqPbNVSrp0OXlzZNwdKm2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794533682; x=1826069682;
  h=date:from:to:cc:subject:message-id;
  bh=FtFeJ5zQCNT/HA3kx4L1V4YwCttMJZo5UMXnRhn3nMI=;
  b=VO2s4G9uS+HBFGBUPS/bXcVs6ODv6JiY88g0+/OZyXwJGUMMbpuxySJz
   /pnwZgH0DKqK4QZkiHhTVl5/VEZOkbfvsp88u8yyFyfQar+F11GTIZwCx
   HuGj4LSbK12hZbRfOno6gZscIQPEJflxypv3vOHdngFKbg3lsbvrRDybT
   wxBacHZGFJ3UajjymtflFbGGrCTBT0A5lfRJB0w/4QYy8tpJI8SIpqYz7
   BGPeAgzggPbu/W5+O2UCKnGk5hEIWeMKYqNEwlaHJV+Oi2E6s4dLofcLY
   Xuk4D54zAaJL2vYCHrLkwJ3NCn1OaSoIEED/K57My1Wugg0yni0E3SR8U
   g==;
X-CSE-ConnectionGUID: eyUOhV3nR8CGwSkIp7Guxg==
X-CSE-MsgGUID: dm3Q0MRaSomFmV9W5H/H+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3321083"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3321083"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 17:34:39 -0800
X-CSE-ConnectionGUID: baDMv114RDi8CX3eiC68+w==
X-CSE-MsgGUID: d5dDC7+NT624YWRohN4G4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="10576615"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 12 Nov 2026 17:34:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRgBW-000000012IF-1DKt;
	Fri, 13 Nov 2026 01:34:34 +0000
Date: Fri, 13 Nov 2026 09:33:55 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 daed51c9105158768a3949395135aa6e0a04bb7e
Message-ID: <20261113093355.SmU2zVTx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5F6720002
X-Stat-Signature: i1fgmqnq5yktarfyce3fj6akrme5txqp
X-Rspam-User: 
X-HE-Tag: 1794533681-84255
X-HE-Meta: U2FsdGVkX19JObYXRVNFQGW2YFQ0yb20e6c5AeO4P1whly+oR6kEdABn9FWVnlpqN1BcGKIhL3GF52Csc0CKrujutvpmEUX4oh4KyFPe7qsvPpXPqnsopdblBT3uUmbSi9H/GBdD6wCFdEr3GA7mMn9H+RovOLTz4BQ5wSk+hgLu3qW3BrpScI2Z/Gs5j3tdX/8jdJ4yx4rD6IaaYmERV0Cs1Z76Bg85RxKzLCkSQIsP7HrGmvbeJi+3Jlzl8jTjFAQuuJW02MhlrLMW6NQlXmDyoshaoIwsdTo92n9Kog2XTKbJTQeLBwcY5jZ3B1jQgyJtKXTgVzx5BRISuK5HUXC1Om2fKClQUif5/PMSeUPWzhc6MCOO2lnywMzm2dJY7qE9qIPVtE9t65+Os/XOPg+HObss3q/ZoxiQnU6tXsHOsi/r5ZkDvZ2DlgCzU4Z1RMYI0rPW6gobZti68k2yq7KWP4y0zEceAo2gLqOoBdkM8N6BZIV566etcMleFj5h8MjNBZbu9V6CTHCwFTU6487wUx1y+uJqJrKz26O/7sxMLlYmUk4Q4+ugGagtZi3CG0r4I0GzLEGt/XXhPgDVR8w7XHr2P8Fgfm7/LU66a7kgWRXHqcwhM6umo+erLVSDyWNS1MoTOrPix9YjAKMh7aWe0GY6p5oDC/IRZKT6A/MMqAKTg+R8J9V/c2MwPYtRP3mbjsAVQ0hwIcpy7fVk0mwvY/bn5zO7u+GwLw09uWvXMvQS864CJ4L11q/Af0uaSWyIAWo7lgU+Gg8UChkpJFFbc9sXnRPWDwSItIqGa2StB35t70o/ckZBSq1dNSsCUnYkV+Jb4UVt82Nf0G+ObIlm9ZZq/XTBqCkizSeUHPjxXh9AtdIKyvqBnemrzRTqnw82uF/4Ed2jKWz/P+NjOiVk6LgzN49ZyoR55dPS4ZCmp1o5BBZh1EfHFpNY7hu15T6Ygbbk9FP/EG1O/wq
 JLBhOoEb
 PxslXpOh30OT8oYYE3upjTyxiQA+CwiHlehywz+UNDgr7eAU93R/e6y732BzufZfXNDiIcnEKoAr2B4TAFzWC9OXFnhMZl+a1nM24OxaZN7qffBs2E/KwX8As0GkF3EWk1QFjjn1lT5d4x8kZhFHRMuYgr1mq/hrtyL1U1DxB9I+bLCe2WdMRz4mzEp0xh5tmW22o44c0xiJlx7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: daed51c9105158768a3949395135aa6e0a04bb7e  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 992m

configs tested: 233
configs skipped: 19

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261112    clang-24
arc                   randconfig-1001-20261112    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                           ep93xx_defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                          lpc18xx_defconfig    clang-24
arm                   randconfig-1000-20261112    clang-24
arm                   randconfig-1001-20261112    clang-24
arm                   randconfig-1002-20261112    clang-24
arm                   randconfig-1003-20261112    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261112    gcc-14.4.0
arm64                 randconfig-1001-20261112    gcc-14.4.0
arm64                 randconfig-1002-20261112    gcc-14.4.0
arm64                 randconfig-1003-20261112    gcc-14.4.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261112    gcc-14.4.0
csky                  randconfig-1001-20261112    gcc-14.4.0
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261112    clang-17
hexagon               randconfig-1000-20261112    clang-24
hexagon               randconfig-1001-20261112    clang-24
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261112    clang-22
i386        buildonly-randconfig-1000-20261113    clang-22
i386        buildonly-randconfig-1001-20261112    clang-22
i386        buildonly-randconfig-1001-20261112    gcc-14
i386        buildonly-randconfig-1001-20261113    clang-22
i386        buildonly-randconfig-1002-20261112    clang-22
i386        buildonly-randconfig-1002-20261113    clang-22
i386        buildonly-randconfig-1003-20261112    clang-22
i386        buildonly-randconfig-1003-20261113    clang-22
i386        buildonly-randconfig-1004-20261112    clang-22
i386        buildonly-randconfig-1004-20261112    gcc-14
i386        buildonly-randconfig-1004-20261113    clang-22
i386        buildonly-randconfig-1005-20261112    clang-22
i386        buildonly-randconfig-1005-20261112    gcc-14
i386        buildonly-randconfig-1005-20261113    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261112    gcc-14
i386                  randconfig-1001-20261112    gcc-14
i386                  randconfig-1002-20261112    gcc-14
i386                  randconfig-1003-20261112    gcc-14
i386                  randconfig-1004-20261112    gcc-14
i386                  randconfig-1005-20261112    gcc-14
i386                  randconfig-1006-20261112    gcc-14
i386                  randconfig-1007-20261112    clang-22
i386                  randconfig-1007-20261113    clang-22
i386                  randconfig-1008-20261112    clang-22
i386                  randconfig-1008-20261113    clang-22
i386                  randconfig-1009-20261112    clang-22
i386                  randconfig-1009-20261113    clang-22
i386                  randconfig-1010-20261112    clang-22
i386                  randconfig-1010-20261113    clang-22
i386                  randconfig-1011-20261112    clang-22
i386                  randconfig-1011-20261113    clang-22
i386                  randconfig-1012-20261112    clang-22
i386                  randconfig-1012-20261113    clang-22
i386                  randconfig-1013-20261112    clang-22
i386                  randconfig-1013-20261113    clang-22
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261112    clang-24
loongarch             randconfig-1000-20261112    gcc-16.2.0
loongarch             randconfig-1001-20261112    clang-24
loongarch             randconfig-1001-20261112    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                          bigsur_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                       pic32mzda_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261112    clang-24
nios2                 randconfig-1000-20261112    gcc-8.5.0
nios2                 randconfig-1001-20261112    clang-24
nios2                 randconfig-1001-20261112    gcc-11.5.0
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261112    gcc-12.5.0
parisc                randconfig-1000-20261113    gcc-13.5.0
parisc                randconfig-1001-20261112    gcc-12.5.0
parisc                randconfig-1001-20261113    gcc-13.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261112    gcc-12.5.0
powerpc               randconfig-1000-20261113    gcc-13.5.0
powerpc               randconfig-1001-20261112    gcc-12.5.0
powerpc               randconfig-1001-20261113    gcc-13.5.0
powerpc64             randconfig-1000-20261112    gcc-12.5.0
powerpc64             randconfig-1000-20261113    gcc-13.5.0
powerpc64             randconfig-1001-20261112    gcc-12.5.0
powerpc64             randconfig-1001-20261113    gcc-13.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    sh7724_generic_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261112    gcc-8.5.0
sparc                 randconfig-1001-20261112    gcc-8.5.0
sparc                        sparc64_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261112    gcc-8.5.0
sparc64               randconfig-1001-20261112    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261112    gcc-8.5.0
um                    randconfig-1001-20261112    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261112    gcc-14
x86_64      buildonly-randconfig-1000-20261113    clang-22
x86_64      buildonly-randconfig-1001-20261112    gcc-14
x86_64      buildonly-randconfig-1001-20261113    clang-22
x86_64      buildonly-randconfig-1002-20261112    gcc-14
x86_64      buildonly-randconfig-1002-20261113    clang-22
x86_64      buildonly-randconfig-1003-20261112    gcc-14
x86_64      buildonly-randconfig-1003-20261113    clang-22
x86_64      buildonly-randconfig-1004-20261112    gcc-14
x86_64      buildonly-randconfig-1004-20261113    clang-22
x86_64      buildonly-randconfig-1005-20261112    gcc-14
x86_64      buildonly-randconfig-1005-20261113    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1006-20261112    gcc-14
x86_64                randconfig-1007-20261112    gcc-14
x86_64                randconfig-1008-20261112    gcc-14
x86_64                randconfig-1009-20261112    gcc-14
x86_64                randconfig-1010-20261112    gcc-14
x86_64                randconfig-1011-20261112    gcc-14
x86_64                randconfig-1012-20261112    clang-22
x86_64                randconfig-1012-20261113    gcc-14
x86_64                randconfig-1013-20261112    clang-22
x86_64                randconfig-1013-20261113    gcc-14
x86_64                randconfig-1014-20261112    clang-22
x86_64                randconfig-1014-20261113    gcc-14
x86_64                randconfig-1015-20261112    clang-22
x86_64                randconfig-1015-20261113    gcc-14
x86_64                randconfig-1016-20261112    clang-22
x86_64                randconfig-1016-20261113    gcc-14
x86_64                randconfig-1017-20261112    clang-22
x86_64                randconfig-1017-20261113    gcc-14
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
xtensa                randconfig-1000-20261112    gcc-8.5.0
xtensa                randconfig-1001-20261112    gcc-8.5.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

