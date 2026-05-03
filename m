Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9734ACD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 13:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B600C6B0005; Sun,  3 May 2026 09:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10DB6B008A; Sun,  3 May 2026 09:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00276B008C; Sun,  3 May 2026 09:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7E96B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 09:17:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5944F1C1066
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:17:57 +0000 (UTC)
X-FDA: 84726161394.06.F96B9DB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id 270B814000D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:17:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FYLowI2b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777814275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=OoZ/5JE3pYIHXDQVh7gpbzRV4d6xix/BCwBfPoG/s9w=;
	b=r1EzdZcuKiln+9bNyZx2yJQJHynv0Xb4q44i+rHM/bnSCwPCWWXGu2k0wn7DdwfqKWF+PK
	m6hnnvOvv/i7iagTPB13ZYEBNENsM2MHmxI0Lcp4uMWNIvtsywn5EOsa2zAhzgnjQz0a23
	UPk84yHG+MXFj6kFJkJ7CquY45fwcLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777814275; a=rsa-sha256;
	cv=none;
	b=Hwqti5NnvsC8IPzA4SJajLB6hilj6B4Bi9Ko2f9cNlVqT753Bx/JaFLDX86wFyybyuCNmD
	33RI/4bJNCtze7RDzOyqBXH/Ws4wnaoIIk6jxeS2HK3OJPeWknY8sag5MMYYYQzvJggirL
	ZEGctf+Z9lXQAuSm5lSP0g3TbOMk8T0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FYLowI2b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777814274; x=1809350274;
  h=date:from:to:cc:subject:message-id;
  bh=FA/oICrk0l5fnF0DtAR3Yl0cIYuEj/8I0FIfSSW8rQE=;
  b=FYLowI2bT/12k/Gef9KlNIdmKwfuMVNLM0ykcJh0zhwoyOe96fl1N8IM
   lSW/jN3UQwfGitgCiuF6nkVnW3vfKa+nZ4xKKBJ7Kz8fSdaLrVF18xV4y
   xEQh3qVAargogrLqDIfzJ5R3NOTkeB88AW2fqf1a9zsx8B0krA4v3jvRi
   JGzwIFkk7ApUBOJXya9rGmevgNlxwUu686NGAJ1OSVwjgVVwqmIyV2ttw
   rkDC7iIe3JAYIzP+D3OL39b1ZXW++4lnQK2UWNeKYln6HgCvOOp9UmC06
   Je155aKHDMyyjKtd1ACEPvWm0COcM+9GCoKWHgJZOsN882Awn6fCjtVYo
   g==;
X-CSE-ConnectionGUID: Y5gecvdzT7WHjgEgOaNAjw==
X-CSE-MsgGUID: m/Kb69bYRQmzreXRQZsHmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11775"; a="77719882"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="77719882"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 06:17:53 -0700
X-CSE-ConnectionGUID: J5UNBXW7Q1CU/N2pKIL6jQ==
X-CSE-MsgGUID: qjQAudKMQCGZGr5omLlNJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="258644667"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 03 May 2026 06:17:51 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJWhf-000000002Zl-2hfL;
	Sun, 03 May 2026 13:17:47 +0000
Date: Sun, 03 May 2026 21:17:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 312ca1abefe5eac64bce040076802808d3c80cac
Message-ID: <202605032138.oeUyFcz9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 270B814000D
X-Stat-Signature: aete54grjoa1izxkq6115x9g81wd6p43
X-Rspam-User: 
X-HE-Tag: 1777814273-8667
X-HE-Meta: U2FsdGVkX1/SWjCckUyfNOA2cyxt9TYcy4GvP30xlHVgrmM65KJbZkqj6eNjjAvcpoWgQe6OtWxvn05YS0qoO+5ZfsAnpNnf+yhjUIgz5i3nltM0NgyeYfZd5bN0cLN1xy7JrV9TAIDLf1KKjLMr1Gnq4zDuTOZgFqttnAbbKouxyRXNp+8efNjToHSddSieFEbVLsOVRTs7GQZVFxs5/W/0c+4hI+QPSXWOK4qI2DpUBO+WSngov8tHsAIZf3+sLTiPHvThDwGUVHxZrmc0cqkRqAn8d8O69AgazpUhmAMD3B1a+BW5hT1tLuR+UgdVTh1e0AQAamA5f09mfrzANDnqo1n6P3rW3iwdJ+LR7IcsNOqp2+08GruaqlytUVBQ6LRcYMq+AZC6zVCfvlr7hflTfeG2QxYBqBbsKIb8aXxk/u3l8FcYaWB9Enahe+MPbWhACp6f6RAnQCQ4Sv+MIMhjEZI2EUQro/n06RxITFMHXY5i7Qf3PQHqW4skfTtJIGksgFvtVU52wzBN2wTIk4Q/+dWao4LXt+hEDdFl2puhGeWKvHVN0IEPTbfvlecdTqGuACC4OLfKnXnAFQOe5ZzPEi3s7BE7o1mg7omkD4DLAQkqwtCPfNsYvU9oogTlxbu4/svJEYeQeD0dTYfzxTYkx2l71Po8sPUtNy0DMf4ZXvLOS4b2J4fdz1vcYgNLeMLBR/oVVdha08lBGPLezrcPmkjmiJ24xPQbgcOMJPrvsmvF3l2qjOvJnm0RiD8WupGeIW1PMeOSUBADBpLEbCYFJuieuopYG50AdMx+Hjc6OfHpdThO1YnzHsQifl3HCDrnW3339alUapDmL7Jerl155pgZ/82Op8Eupbu73ttJWXYVjbZ1zRYAukiz37Dy4+Oa66f+gyhTJyrSM+JSg5P63RgRIblIIdEVnmoUNutXQcEfb7niCnmneS/cKsnBNFKFk821bzJYA2V/s6P
 zrFWbQdc
 so0YF0uliitslTbDd/fjIv1uTTMohmYuGfkz2ZIPxkQBT5uQoJMmendDubpmlsBRkddsffzo7nZ2U7SgkKuX7x/KsFqK+39QC/kYOdeCmY/UVnNC0x14egWnl/+zVeb8HjWUPdEQNGI2bAQE+u7iWN2SkfDIUUwxbJB59
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 312ca1abefe5eac64bce040076802808d3c80cac  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 744m

configs tested: 262
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              alldefconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260503    gcc-15.2.0
arc                   randconfig-001-20260503    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260503    gcc-10.5.0
arc                   randconfig-002-20260503    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260503    gcc-12.5.0
arm                   randconfig-001-20260503    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260503    clang-23
arm                   randconfig-003-20260503    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260503    clang-23
arm                   randconfig-004-20260503    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                          randconfig-001    gcc-15.2.0
arm64                 randconfig-001-20260503    gcc-15.2.0
arm64                 randconfig-001-20260503    gcc-8.5.0
arm64                          randconfig-002    gcc-15.2.0
arm64                 randconfig-002-20260503    gcc-15.2.0
arm64                 randconfig-002-20260503    gcc-8.5.0
arm64                          randconfig-003    gcc-15.2.0
arm64                 randconfig-003-20260503    clang-17
arm64                 randconfig-003-20260503    gcc-15.2.0
arm64                          randconfig-004    gcc-15.2.0
arm64                 randconfig-004-20260503    clang-23
arm64                 randconfig-004-20260503    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                           randconfig-001    gcc-15.2.0
csky                  randconfig-001-20260503    gcc-15.2.0
csky                           randconfig-002    gcc-15.2.0
csky                  randconfig-002-20260503    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260503    clang-17
hexagon               randconfig-001-20260503    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260503    clang-23
hexagon               randconfig-002-20260503    gcc-11.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260503    clang-20
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260503    clang-20
i386        buildonly-randconfig-002-20260503    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260503    clang-20
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260503    clang-20
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260503    clang-20
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260503    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260503    clang-20
i386                  randconfig-002-20260503    clang-20
i386                  randconfig-002-20260503    gcc-14
i386                  randconfig-003-20260503    clang-20
i386                  randconfig-003-20260503    gcc-14
i386                  randconfig-004-20260503    clang-20
i386                  randconfig-005-20260503    clang-20
i386                  randconfig-005-20260503    gcc-14
i386                  randconfig-006-20260503    clang-20
i386                  randconfig-007-20260503    clang-20
i386                  randconfig-011-20260503    clang-20
i386                  randconfig-012-20260503    clang-20
i386                  randconfig-013-20260503    clang-20
i386                  randconfig-014-20260503    clang-20
i386                  randconfig-015-20260503    gcc-14
i386                  randconfig-016-20260503    gcc-14
i386                  randconfig-017-20260503    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260503    gcc-11.5.0
loongarch             randconfig-001-20260503    gcc-15.2.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260503    clang-20
loongarch             randconfig-002-20260503    gcc-11.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
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
mips                          malta_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260503    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260503    gcc-11.5.0
nios2                 randconfig-002-20260503    gcc-8.5.0
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
parisc                randconfig-001-20260503    gcc-15.2.0
parisc                randconfig-002-20260503    gcc-15.2.0
parisc                randconfig-002-20260503    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260503    clang-23
powerpc               randconfig-001-20260503    gcc-15.2.0
powerpc               randconfig-002-20260503    gcc-14.3.0
powerpc               randconfig-002-20260503    gcc-15.2.0
powerpc64             randconfig-001-20260503    gcc-15.2.0
powerpc64             randconfig-001-20260503    gcc-8.5.0
powerpc64             randconfig-002-20260503    gcc-10.5.0
powerpc64             randconfig-002-20260503    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260503    clang-23
riscv                 randconfig-002-20260503    clang-23
riscv                 randconfig-002-20260503    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260503    clang-23
s390                  randconfig-001-20260503    gcc-14.3.0
s390                  randconfig-002-20260503    clang-23
s390                  randconfig-002-20260503    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260503    clang-23
sh                    randconfig-001-20260503    gcc-13.4.0
sh                    randconfig-002-20260503    clang-23
sh                    randconfig-002-20260503    gcc-12.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260503    gcc-15.2.0
sparc                 randconfig-001-20260503    gcc-8.5.0
sparc                 randconfig-002-20260503    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260503    gcc-11.5.0
sparc64               randconfig-001-20260503    gcc-15.2.0
sparc64               randconfig-002-20260503    gcc-15.2.0
sparc64               randconfig-002-20260503    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260503    clang-17
um                    randconfig-001-20260503    gcc-15.2.0
um                    randconfig-002-20260503    clang-23
um                    randconfig-002-20260503    gcc-15.2.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260503    clang-20
x86_64      buildonly-randconfig-002-20260503    clang-20
x86_64      buildonly-randconfig-002-20260503    gcc-14
x86_64      buildonly-randconfig-003-20260503    clang-20
x86_64      buildonly-randconfig-003-20260503    gcc-14
x86_64      buildonly-randconfig-004-20260503    clang-20
x86_64      buildonly-randconfig-005-20260503    clang-20
x86_64      buildonly-randconfig-005-20260503    gcc-14
x86_64      buildonly-randconfig-006-20260503    clang-20
x86_64      buildonly-randconfig-006-20260503    gcc-14
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260503    gcc-14
x86_64                randconfig-002-20260503    gcc-14
x86_64                randconfig-003-20260503    clang-20
x86_64                randconfig-004-20260503    gcc-14
x86_64                randconfig-005-20260503    gcc-14
x86_64                randconfig-006-20260503    gcc-14
x86_64                randconfig-011-20260503    clang-20
x86_64                randconfig-012-20260503    clang-20
x86_64                randconfig-013-20260503    clang-20
x86_64                randconfig-014-20260503    clang-20
x86_64                randconfig-015-20260503    clang-20
x86_64                randconfig-015-20260503    gcc-14
x86_64                randconfig-016-20260503    clang-20
x86_64                randconfig-016-20260503    gcc-14
x86_64                randconfig-071-20260503    clang-20
x86_64                randconfig-072-20260503    clang-20
x86_64                randconfig-073-20260503    clang-20
x86_64                randconfig-074-20260503    clang-20
x86_64                randconfig-075-20260503    clang-20
x86_64                randconfig-076-20260503    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260503    gcc-11.5.0
xtensa                randconfig-001-20260503    gcc-15.2.0
xtensa                randconfig-002-20260503    gcc-13.4.0
xtensa                randconfig-002-20260503    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

