Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A16CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2C26B00C1; Fri, 29 May 2026 13:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3656B00C4; Fri, 29 May 2026 13:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9266B00C8; Fri, 29 May 2026 13:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9C46B00C1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:08:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12B511C0033
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:08:48 +0000 (UTC)
X-FDA: 84821091936.20.5108840
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id DEB001C0011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:08:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AHeqjcRZ;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780074526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=6WCQFAfjsu5x/L30qBRIKFr46HZ0p7NUBJu+E8yOquk=;
	b=u7TaMpNI/SY3VqWfQdsOAP/auEGWcSxsU3mqFHHom1O74OjS70LP/ed6B1HTWpcHDyWmF/
	hI7wKz9h4YuSoL1/nJGBrg/TA7Q+BcvzXdJ2dTeupna+V+J1tPKMkvZK1F5kv7+c8F2pFJ
	WhRZ6upuSMijYSiYUlwEn+VanwUM/bE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AHeqjcRZ;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780074526; a=rsa-sha256;
	cv=none;
	b=EM0xmItwW8J08RY/PGDGx6mcMZc9192vXgA8OlBKGeXdFezIecyMG3yQKBzM0Mv4MQ1YKD
	4Bwo9wfusc43cLGW0QilY1NhBpDMm5Y+Yk569hdRoZRDjgajrohrayZRYp9CMPmY3mJDvt
	iaD+bT9PAO7vNThdGfc4shCdiTa2h9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780074527; x=1811610527;
  h=date:from:to:cc:subject:message-id;
  bh=e15abX/HCDFcaZz/26H+fB/fbx3jOrrYo410IprMlns=;
  b=AHeqjcRZpXnoPguDvd7TfNIWl5v7kdqeX92v32OrTfCFHk48KosF+Sxw
   WQEgdura3rFJyXtsfpG0TxWdhna8FSyJjDEAgDcUF+CCkn1s3Z/jDzxlz
   oR+XrorICW1pK61dFsBEVWd/LqQu1P4uFE13maQlKP7V8AIdNXp+v1kLn
   Y/O75A7lchlMLhBIGJzL0HrjSjt0lilfRcr8xgwmN9R4juaV5pOEZfk2Z
   Hv/e5fnIQm/Gi9jhbw9SUGErwcR8NQEK9IjHE6v8lyeTxAXi/h0gF6qHf
   +9sORaloHa3xYeNgffVInLBt0YWLf2WWmUz4R6PZCWMNAjeGsNJFkYJ4t
   w==;
X-CSE-ConnectionGUID: C24q3d48Q8yCP77yxe2U1w==
X-CSE-MsgGUID: yAZ/Nn/KQxe/523AQ+F6kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="91241187"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="91241187"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:08:44 -0700
X-CSE-ConnectionGUID: sWwF+xQbQ0qatFPzNdZxtA==
X-CSE-MsgGUID: ddGiUpuxSo+m63Q+PTWjYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="238517721"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 May 2026 10:08:41 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wT0hK-000000007Wg-2tw3;
	Fri, 29 May 2026 17:08:38 +0000
Date: Sat, 30 May 2026 01:08:21 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 a4316353f0e3e9dff78d8a7582915117ec01e359
Message-ID: <202605300111.92PXFPgm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEB001C0011
X-Stat-Signature: r4ukngcm77iipkkynj4s4mh79bse8mye
X-HE-Tag: 1780074525-380679
X-HE-Meta: U2FsdGVkX1+O+4l9MFqgrKyQYrEIEVf3KNJIWyr01e6lnkPS5Rz9P+HX1Mhngg2acaViJERUiEc3hfxx4q3N2xSpZI1r+/++LMBcocev370IPALPJpokugukppWsNgQWqoSGWVYdaG4aoeBIuNzpEANqPxU+DTmFeyGDxvK4tMQt29nayKhujvmU7APC/xchUe3Md1ooLx13NyZPoNHmrPj4sJiOrPEKEqy9w9vlzXaIRQQWLbxMF3mwU+UlixN36H+bbSdQ9s1rdIeLqhCHOVMpOoLB6fnOVbObHX3pKXwHyiUoqFXYn0YHQP9vzPY0du7RWI+wO2VgFGX6iGYK1IhBYx/jfhxl9wiisrOtkHXxHpbx/LT4uCiqESbkprGI8lJ16ExYmC8xMwXPX0BszmYRmsLy/JV/04iqNhE3fCDVms1iK1yrUYeU2iT+nKW06aIsmrgJzhw8GqA2pgwVWEfLERKMkH9DT0Z62hREiSYtAybIvrS3ioUeD4lST1zSdHAT7xl2aiVZb3BOXmCIyvT3kn6Hw+ilGR9Klq+nc3EioqX0/uXTDFytHMvViF3JCH2BMqfa4gNtGjHJe6RkCVzkkrKCAhHJ5qPhF8DuN20VZpPF84o7q83A+lR6IoAUoYd2iNXRbfO6b5MLYllxs2hI+PTsecrBVVd3vCBSC2VodSEtTfRIPpOQ6j6ZHEWd6BVgjXUdz4HqUqbXeKLBErk8PJOsn3Km50+8c+7vETChoPcaJsAKskstZvDJkHoJZsHI6zU169a9Sf7vLF5+Os4UkdC/AwP+GBOg4IpkVMs4n7PKBFkLMtV2zJr+8HjMcvdiU2sw4s4WivQRKU6LenNACRee9EmjShDpG8cOvqW/b8rmJUHjSS/8K+/FTwAWgGVI43VZCGZJAUaZvyuirf9aD7YlU41tB4qrMLkdKh3TkaZKBWqrigTtmcl5JMatcZgBC/KjIQnAeNRDdS+
 enmKkD71
 5dw+JOxrgYz3g8+I2lhWTK4nI0mO3eFxETHIEEa+DM96C+H6sYQgUW7AXlXTeZzzbIPoG0Zx1pDctphJeXe0c9zqMOjxpLBUA1PZk+Wahir4ZUg8eASnnU7Acd26EcV+COV7rThIns9teajpoXWmalthtEMze2uCU9/ZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: a4316353f0e3e9dff78d8a7582915117ec01e359  mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes

elapsed time: 736m

configs tested: 269
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260529    clang-23
arc                   randconfig-001-20260529    gcc-14.3.0
arc                   randconfig-002-20260529    clang-23
arc                   randconfig-002-20260529    gcc-10.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                         lpc32xx_defconfig    clang-17
arm                   randconfig-001-20260529    clang-23
arm                   randconfig-001-20260529    gcc-14.3.0
arm                   randconfig-002-20260529    clang-23
arm                   randconfig-002-20260529    gcc-8.5.0
arm                   randconfig-003-20260529    clang-23
arm                   randconfig-003-20260529    gcc-13.4.0
arm                   randconfig-004-20260529    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260529    gcc-8.5.0
arm64                 randconfig-002-20260529    clang-23
arm64                 randconfig-003-20260529    clang-23
arm64                 randconfig-004-20260529    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260529    gcc-15.2.0
csky                  randconfig-002-20260529    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260529    clang-23
hexagon               randconfig-001-20260529    gcc-8.5.0
hexagon               randconfig-002-20260529    clang-23
hexagon               randconfig-002-20260529    gcc-8.5.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260529    gcc-12
i386        buildonly-randconfig-002-20260529    clang-20
i386        buildonly-randconfig-002-20260529    gcc-12
i386        buildonly-randconfig-003-20260529    gcc-12
i386        buildonly-randconfig-004-20260529    gcc-12
i386        buildonly-randconfig-004-20260529    gcc-14
i386        buildonly-randconfig-005-20260529    gcc-12
i386        buildonly-randconfig-005-20260529    gcc-14
i386        buildonly-randconfig-006-20260529    gcc-12
i386        buildonly-randconfig-006-20260529    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260529    gcc-14
i386                  randconfig-002-20260529    gcc-12
i386                  randconfig-002-20260529    gcc-14
i386                  randconfig-003-20260529    clang-20
i386                  randconfig-003-20260529    gcc-14
i386                  randconfig-004-20260529    clang-20
i386                  randconfig-004-20260529    gcc-14
i386                  randconfig-005-20260529    gcc-14
i386                  randconfig-006-20260529    clang-20
i386                  randconfig-006-20260529    gcc-14
i386                  randconfig-007-20260529    gcc-12
i386                  randconfig-007-20260529    gcc-14
i386                           randconfig-011    clang-20
i386                  randconfig-011-20260529    clang-20
i386                  randconfig-011-20260529    gcc-14
i386                           randconfig-012    clang-20
i386                  randconfig-012-20260529    clang-20
i386                  randconfig-012-20260529    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260529    clang-20
i386                  randconfig-013-20260529    gcc-14
i386                           randconfig-014    clang-20
i386                  randconfig-014-20260529    clang-20
i386                  randconfig-014-20260529    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260529    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260529    clang-20
i386                  randconfig-016-20260529    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260529    gcc-13
i386                  randconfig-017-20260529    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260529    gcc-15.2.0
loongarch             randconfig-001-20260529    gcc-8.5.0
loongarch             randconfig-002-20260529    gcc-15.2.0
loongarch             randconfig-002-20260529    gcc-8.5.0
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
nios2                            allmodconfig    clang-23
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260529    gcc-8.5.0
nios2                 randconfig-002-20260529    gcc-8.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                         randconfig-001    clang-19
parisc                         randconfig-001    gcc-13.4.0
parisc                randconfig-001-20260529    clang-19
parisc                randconfig-001-20260529    gcc-8.5.0
parisc                         randconfig-002    clang-19
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260529    clang-19
parisc                randconfig-002-20260529    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 canyonlands_defconfig    clang-23
powerpc                        randconfig-001    clang-19
powerpc                        randconfig-001    gcc-13.4.0
powerpc               randconfig-001-20260529    clang-19
powerpc               randconfig-001-20260529    gcc-12.5.0
powerpc                        randconfig-002    clang-19
powerpc                        randconfig-002    gcc-10.5.0
powerpc               randconfig-002-20260529    clang-19
powerpc64                      randconfig-001    clang-17
powerpc64                      randconfig-001    clang-19
powerpc64             randconfig-001-20260529    clang-19
powerpc64             randconfig-001-20260529    gcc-15.2.0
powerpc64                      randconfig-002    clang-19
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260529    clang-19
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260529    gcc-8.5.0
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260529    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260529    gcc-8.5.0
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260529    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-15.2.0
sh                    randconfig-001-20260529    gcc-15.2.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260529    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260529    gcc-11.5.0
sparc                 randconfig-001-20260529    gcc-8.5.0
sparc                 randconfig-002-20260529    gcc-11.5.0
sparc                 randconfig-002-20260529    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260529    gcc-11.5.0
sparc64               randconfig-002-20260529    gcc-11.5.0
sparc64               randconfig-002-20260529    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260529    gcc-11.5.0
um                    randconfig-001-20260529    gcc-14
um                    randconfig-002-20260529    gcc-11.5.0
um                    randconfig-002-20260529    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260529    gcc-14
x86_64      buildonly-randconfig-002-20260529    gcc-14
x86_64      buildonly-randconfig-003-20260529    gcc-14
x86_64      buildonly-randconfig-004-20260529    clang-20
x86_64      buildonly-randconfig-004-20260529    gcc-14
x86_64      buildonly-randconfig-005-20260529    clang-20
x86_64      buildonly-randconfig-005-20260529    gcc-14
x86_64      buildonly-randconfig-006-20260529    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260529    clang-20
x86_64                randconfig-001-20260529    gcc-14
x86_64                randconfig-002-20260529    clang-20
x86_64                randconfig-003-20260529    clang-20
x86_64                randconfig-003-20260529    gcc-14
x86_64                randconfig-004-20260529    clang-20
x86_64                randconfig-005-20260529    clang-20
x86_64                randconfig-006-20260529    clang-20
x86_64                randconfig-011-20260529    gcc-14
x86_64                randconfig-012-20260529    gcc-14
x86_64                randconfig-013-20260529    clang-20
x86_64                randconfig-014-20260529    clang-20
x86_64                randconfig-015-20260529    gcc-14
x86_64                randconfig-016-20260529    clang-20
x86_64                         randconfig-071    clang-20
x86_64                randconfig-071-20260529    clang-20
x86_64                randconfig-071-20260529    gcc-14
x86_64                         randconfig-072    clang-20
x86_64                randconfig-072-20260529    clang-20
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260529    clang-20
x86_64                         randconfig-074    clang-20
x86_64                randconfig-074-20260529    clang-20
x86_64                randconfig-074-20260529    gcc-14
x86_64                         randconfig-075    clang-20
x86_64                randconfig-075-20260529    clang-20
x86_64                randconfig-075-20260529    gcc-14
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260529    clang-20
x86_64                randconfig-076-20260529    gcc-14
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
xtensa                randconfig-001-20260529    gcc-11.5.0
xtensa                randconfig-002-20260529    gcc-11.5.0
xtensa                randconfig-002-20260529    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

