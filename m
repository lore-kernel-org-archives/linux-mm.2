Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9381AC9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02EC36B0098; Fri, 16 Jan 2026 21:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F323A6B0099; Fri, 16 Jan 2026 21:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D216B009B; Fri, 16 Jan 2026 21:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDD8D6B0098
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:14:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86C7C13A678
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:14:39 +0000 (UTC)
X-FDA: 84339837078.03.F4B1177
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EA8CC0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:14:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f8PJmVR1;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768616077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+amUerLtkqKke6Iu+Zs8zTWINa6mjZCxrsgvkX2J9Gg=;
	b=q4g1PWyotXxnmw1cybCcYDhq6QanVTCvWmWzbWeDJJZDKMEPOyTsNRKrno9LLF9g1gxUi5
	+YaED5KoYgtNqvJaiKUNZEnvfm/xtZPk6dP1/ABfnuTdF6bdy7aazzPicm3pGeyh80VD+M
	BXAlM6HA8TuWGwUObpNQyj/hI/ML1Ak=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f8PJmVR1;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768616077; a=rsa-sha256;
	cv=none;
	b=yeaWIN0FW8YfNoHpYC5VY9asC+1a5+VPHBjx7/bToAd/KIZ5y/FeNjGJggjsmJGxsofSWM
	1uMma2e4s77UyTxsKJfoPl7zHYOcudtmWccF7dV2SoNMxLczdQGcA/CXC0QYDaRgqkNl7p
	PWXniRKxRmP7dVfYZPPsyv8hCrTDptY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768616077; x=1800152077;
  h=date:from:to:cc:subject:message-id;
  bh=md10WZl4rOGq6pJnkAdU37pxLtFmLiCO2RgdGH2hDFU=;
  b=f8PJmVR17+vuWtwW3cZdp/jOll6Jb+YREH88x6qNKIX3LUhGV6fp/KXj
   WqZkj+/N1RQ0m1AKf7nbheRDhF1jmC79WZesYEyNdBTRpFj88yZ21rpWG
   E//JUMxFy2GgHPAolVkR4NIe6Z1cQfCV7pTuHGNF04+JjGMMAUUyR2qVD
   uqTDvGmjPG4WI5LVCOtuoUdyYt7UAR79a+OJQ+S3LNQ/q0z09SXVf7Td1
   05aE38dxeeoKJwwqiEgKgZSm25mHeTxhzNFNI5jPshdGj83R+CSNB7+Qp
   r+A2hLRn2w3IydUMdg6Gu6WT9NH9KYYgbIN8qxJgqA7+QwY2BTYt3XaMO
   Q==;
X-CSE-ConnectionGUID: x/L6R9XiST+FPOwAvYpw9g==
X-CSE-MsgGUID: O/ppACxYSB23HKdtC3dxEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="80651574"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="80651574"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 18:14:35 -0800
X-CSE-ConnectionGUID: yztDGD1rRjisLYakawBOoA==
X-CSE-MsgGUID: ycpi2jrxSn6xwiIBt/Wwtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="209875348"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 16 Jan 2026 18:14:34 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgvpf-00000000LSi-0ago;
	Sat, 17 Jan 2026 02:14:31 +0000
Date: Sat, 17 Jan 2026 10:13:53 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 46fe65a2c28ecf5df1a7475aba1f08ccf4c0ac1b
Message-ID: <202601171046.GDSUT79c-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 0EA8CC0005
X-Stat-Signature: ohzwo7tnxqekt118sa5ajesj15stw7u9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768616076-567603
X-HE-Meta: U2FsdGVkX1/Qi3mEadI2YOsBRhG6YF9Texj48phnOvjIFoN18yVDkD5haAjfoEYzkatiWvdur9VB+oKSBLdmSQZ5zgXUyECjfPevnwOlnZecHanJ0fsoS3EsxQVnUZBnGXgUEYk/07qmIdUht3GFyRmovUsVwI/NtU3oZRZt+KaAz8HvZLRLyH5WoQOSoZMzGSSgM3fyr8C/1LKL0dyM2O0pEWhAfWYx2i676e5eV2d+G6T6r+Oq6OaCFMx3vUGFhKt1fD3vJh7/qInxOTJufV26Qy1cYMwkNFopiowsc1Q9C+pngmfUS3Raw/Tnr//8DOJ/cMoREjeBOyuoHHed3jNRU/PJYfxbCEUYW1HLGJQFr9a8ceSDH+grlIwVLaEB9EbNLe6BgntNX8AvFyoSc0Ka8iFZv/IqjN/j/Mdf/5zaMEhA2lEqqJn0FGSo4InATRpH2t6U0Fhxi99eyID/Hdb2aHGJtqJsjqe8Vzob5hR+FLUrX4QmezI83958TQV7MFmdZ+zjuhxnCNxAeNSLiHOiaa/7EdusFVPL9QvgGUqN+N9NaOJ6vaEWxh3qPaAeyE7BbefuTWb4oG6KB3ARHFHZhA5aOEh8j5B87o6So/rw9B27bo/aLbz6zlupFFv2sqVcXZ4sBkoR7PmDeFfv80TWKtLbPNnqZO4nMSCGHYwoYVs5Qt++dqTJfM1AkDNW/9CiMQxvGE7EScWFd6xEwepGgIsOZ10cUjri6Dafv7jTHvN4cckgtiUzl0kipClXSjbt3RWKs5Jo50ptcQxOjsLAXO91IklKucyAZwlqmC3k1qRwrKn0Bo0kSmI9xwIGZ+ioVGOoXmFCvKKv/600VGfZPS6MPr6PfYELNICZoSERXyhcf2d0tKjE0TT3zQlj/6DVG1UOqa/zlWblDBaxObWCka8/6j7R3vLtLtDNx+vBBaoks84OLNlfuzLit0y2PKXo5rZgtGMT65qwWm1
 LnnU1B+K
 X+LSf7nJeRqjwbWyuYOm/9Kwia060baU8JZsFo5bRFxOrB8kKc5Cm5H2KAlCvVvEMv5OqBJbT3iO+wIB/toWrwJzWXmOX1DNdF8ngDtzjmnrp5PZUnBVUAykJwzKYKogOpRRrIETg+NlrNycOwPb/q35aLMDFBONAzXqo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 46fe65a2c28ecf5df1a7475aba1f08ccf4c0ac1b  Add linux-next specific files for 20260116

Unverified Warning (likely false positive, kindly check if interested):

    drivers/gpio/gpio-bd72720.c:279:1: sparse: sparse: bad integer constant expression
    drivers/interconnect/mediatek/mt8196.c:381:1: sparse: sparse: bad integer constant expression
    drivers/misc/lkdtm/bugs.c:564 lkdtm_PTR_BOUNDS() warn: potentially one past the end of array 'inst->extra[inst->nr_extra]'

Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-r113-20260115
|   `-- drivers-interconnect-mediatek-mt8196.c:sparse:sparse:bad-integer-constant-expression
|-- csky-randconfig-r131-20260116
|   `-- drivers-gpio-gpio-bd72720.c:sparse:sparse:bad-integer-constant-expression
|-- i386-randconfig-141-20260117
|   `-- drivers-misc-lkdtm-bugs.c-lkdtm_PTR_BOUNDS()-warn:potentially-one-past-the-end-of-array-inst-extra-inst-nr_extra
`-- x86_64-randconfig-161-20260117
    `-- drivers-misc-lkdtm-bugs.c-lkdtm_PTR_BOUNDS()-warn:potentially-one-past-the-end-of-array-inst-extra-inst-nr_extra

elapsed time: 730m

configs tested: 262
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                         haps_hs_defconfig    gcc-15.2.0
arc                   randconfig-001-20260116    gcc-13.4.0
arc                   randconfig-002-20260116    gcc-9.5.0
arm                              alldefconfig    gcc-15.2.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                          pxa3xx_defconfig    clang-22
arm                   randconfig-001-20260116    gcc-15.2.0
arm                   randconfig-002-20260116    gcc-8.5.0
arm                   randconfig-003-20260116    clang-22
arm                   randconfig-004-20260116    gcc-8.5.0
arm                        spear3xx_defconfig    gcc-15.2.0
arm                           stm32_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260116    clang-22
arm64                 randconfig-002-20260116    clang-22
arm64                 randconfig-003-20260116    clang-17
arm64                 randconfig-004-20260116    clang-22
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260116    gcc-15.2.0
csky                  randconfig-002-20260116    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260116    clang-20
hexagon               randconfig-001-20260117    clang-22
hexagon               randconfig-002-20260116    clang-19
hexagon               randconfig-002-20260117    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260116    gcc-14
i386        buildonly-randconfig-002-20260116    clang-20
i386        buildonly-randconfig-003-20260116    gcc-12
i386        buildonly-randconfig-004-20260116    clang-20
i386        buildonly-randconfig-005-20260116    clang-20
i386        buildonly-randconfig-006-20260116    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260116    gcc-14
i386                  randconfig-002-20260116    clang-20
i386                  randconfig-003-20260116    clang-20
i386                  randconfig-004-20260116    gcc-14
i386                  randconfig-005-20260116    gcc-14
i386                  randconfig-006-20260116    clang-20
i386                  randconfig-007-20260116    gcc-14
i386                  randconfig-011-20260116    gcc-14
i386                  randconfig-011-20260117    gcc-14
i386                  randconfig-012-20260116    clang-20
i386                  randconfig-012-20260117    gcc-14
i386                  randconfig-013-20260116    clang-20
i386                  randconfig-013-20260117    gcc-14
i386                  randconfig-014-20260116    clang-20
i386                  randconfig-014-20260117    gcc-14
i386                  randconfig-015-20260116    clang-20
i386                  randconfig-015-20260117    gcc-14
i386                  randconfig-016-20260116    gcc-14
i386                  randconfig-016-20260117    gcc-14
i386                  randconfig-017-20260116    clang-20
i386                  randconfig-017-20260117    gcc-14
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260116    gcc-15.2.0
loongarch             randconfig-001-20260117    clang-22
loongarch             randconfig-002-20260116    gcc-15.2.0
loongarch             randconfig-002-20260117    clang-22
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                         amcore_defconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                        bcm47xx_defconfig    clang-18
mips                           ip30_defconfig    gcc-15.2.0
mips                      loongson3_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260116    gcc-11.5.0
nios2                 randconfig-001-20260117    clang-22
nios2                 randconfig-002-20260116    gcc-11.5.0
nios2                 randconfig-002-20260117    clang-22
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260117    gcc-12.5.0
parisc                randconfig-002-20260117    gcc-15.2.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                    ge_imp3a_defconfig    gcc-15.2.0
powerpc                   motionpro_defconfig    clang-22
powerpc               randconfig-001-20260117    gcc-8.5.0
powerpc               randconfig-002-20260117    clang-22
powerpc                     tqm5200_defconfig    gcc-15.2.0
powerpc                     tqm8540_defconfig    gcc-15.2.0
powerpc                     tqm8548_defconfig    clang-22
powerpc64             randconfig-001-20260117    clang-22
powerpc64             randconfig-002-20260117    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260116    clang-22
riscv                 randconfig-001-20260117    gcc-10.5.0
riscv                 randconfig-002-20260116    clang-22
riscv                 randconfig-002-20260117    gcc-10.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260116    clang-22
s390                  randconfig-001-20260117    gcc-10.5.0
s390                  randconfig-002-20260116    gcc-8.5.0
s390                  randconfig-002-20260117    gcc-10.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260116    gcc-15.2.0
sh                    randconfig-001-20260117    gcc-10.5.0
sh                    randconfig-002-20260116    gcc-14.3.0
sh                    randconfig-002-20260117    gcc-10.5.0
sh                           se7751_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260116    gcc-15.2.0
sparc                 randconfig-001-20260117    gcc-14.3.0
sparc                 randconfig-002-20260116    gcc-13.4.0
sparc                 randconfig-002-20260117    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260116    gcc-10.5.0
sparc64               randconfig-001-20260117    gcc-14.3.0
sparc64               randconfig-002-20260116    gcc-8.5.0
sparc64               randconfig-002-20260117    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260116    gcc-14
um                    randconfig-001-20260117    gcc-14.3.0
um                    randconfig-002-20260116    gcc-14
um                    randconfig-002-20260117    gcc-14.3.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260116    gcc-14
x86_64      buildonly-randconfig-001-20260117    clang-20
x86_64      buildonly-randconfig-002-20260116    clang-20
x86_64      buildonly-randconfig-002-20260117    clang-20
x86_64      buildonly-randconfig-003-20260116    clang-20
x86_64      buildonly-randconfig-003-20260117    clang-20
x86_64      buildonly-randconfig-004-20260116    clang-20
x86_64      buildonly-randconfig-004-20260117    clang-20
x86_64      buildonly-randconfig-005-20260116    clang-20
x86_64      buildonly-randconfig-005-20260117    clang-20
x86_64      buildonly-randconfig-006-20260116    gcc-14
x86_64      buildonly-randconfig-006-20260117    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260116    clang-20
x86_64                randconfig-001-20260117    clang-20
x86_64                randconfig-002-20260116    gcc-14
x86_64                randconfig-002-20260117    clang-20
x86_64                randconfig-003-20260116    clang-20
x86_64                randconfig-003-20260117    clang-20
x86_64                randconfig-004-20260116    clang-20
x86_64                randconfig-004-20260117    clang-20
x86_64                randconfig-005-20260116    gcc-14
x86_64                randconfig-005-20260117    clang-20
x86_64                randconfig-006-20260116    clang-20
x86_64                randconfig-006-20260117    clang-20
x86_64                randconfig-011-20260116    clang-20
x86_64                randconfig-012-20260116    clang-20
x86_64                randconfig-013-20260116    clang-20
x86_64                randconfig-014-20260116    clang-20
x86_64                randconfig-015-20260116    gcc-12
x86_64                randconfig-016-20260116    clang-20
x86_64                randconfig-071-20260116    gcc-14
x86_64                randconfig-072-20260116    clang-20
x86_64                randconfig-073-20260116    gcc-14
x86_64                randconfig-074-20260116    clang-20
x86_64                randconfig-075-20260116    clang-20
x86_64                randconfig-076-20260116    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260116    gcc-11.5.0
xtensa                randconfig-001-20260117    gcc-14.3.0
xtensa                randconfig-002-20260116    gcc-15.2.0
xtensa                randconfig-002-20260117    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

