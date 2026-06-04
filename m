Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9613CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 03:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FFF6B0005; Wed,  3 Jun 2026 23:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F237C6B0088; Wed,  3 Jun 2026 23:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39BA6B008A; Wed,  3 Jun 2026 23:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2DEF6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:55:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 565FBC0475
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:55:44 +0000 (UTC)
X-FDA: 84840866208.30.B315FD6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C2C540002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:55:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SE6csuqy;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780545342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yzoB7F0GHMZgJ7ReIzBZjOmsQkKlnlM78O7azuUyTfI=;
	b=yvJYpIyZuKkNOg3d5e+hfTDHgDKMN74ySKrzKQmRggmHI8zZNfK1zGeVIVVPU9bthF4Suj
	r15i31/fYL2rWao6lIQxqT2BMwyklBfyQ7cUwelNnWYmhcNyFO/RhnONS2+zwEeAy/azWY
	I/Qh+dc1wF2B4MBWgsREKK0DWEDdk/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780545342;
	b=zR913UzorCtpk9N+/3mpse6/496eRIUGvDDh76LJ8D8nFFC1XSsfJeqOP6AOSQcE1Gr62M
	LxbucVC6i2ZiXIALLdFH7p03P7jkG711t8uenRyHPpINSanhXKSmjk1hq1vpd7NnN3Fx+A
	bVATAc8XuHJsKfX2dZLKeDHJ68yFAYE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SE6csuqy;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780545342; x=1812081342;
  h=date:from:to:cc:subject:message-id;
  bh=tytbL4ZFUzgTFt3FeMQW6fXbbVflGJRuVWJ85DVkDIg=;
  b=SE6csuqy0aafLI4JvN3+1MJhjgLutK7xqLv9wDanKwCW7jK9yQL8hnM8
   TvOa/wTpQw4ni5ibvmdrqQWMbpWDkqf68TONWcb1/qUL3/1RAq3/q0umR
   CZMGztYs1NI5bBNEQOEVvk7aCwQypNpoDyfcSh7TiQRoJlIEHVmMcRbEH
   GLz0heQDO2GAp7TyBQYU3SnyiEmFWiNRIcj8uGfmI45WbvQYUtgi1uTGB
   9JfnvGt/KAxJamvYa1ByzTZ8vUvNZtJBNDgy/3PJQKkNzqzj3axec0bNT
   wkvDVYCef9dHvqXb6dEAp41yx5MUH/G2y4QOLtLSHARvjBADPG24sSLAY
   w==;
X-CSE-ConnectionGUID: r+qKnzrLRbmjuKsJ8NJdJw==
X-CSE-MsgGUID: Q/+bvQYlRfq/TylBPjM4sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="81398878"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="81398878"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 20:55:40 -0700
X-CSE-ConnectionGUID: VWV/ddStTF6kgUiqIIMgpQ==
X-CSE-MsgGUID: oSLAQrP8S+eTvRrnXUf00g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="243595298"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 03 Jun 2026 20:55:38 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUzB9-00000000EFa-3wAG;
	Thu, 04 Jun 2026 03:55:35 +0000
Date: Thu, 04 Jun 2026 11:55:29 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 00e06cb773fd81d4f2806a6ee69d1aef8f6dd5ca
Message-ID: <202606041119.OYOBT0Or-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C2C540002
X-Stat-Signature: rfwpn331ibnakg3na1j53q9zyiassmgp
X-HE-Tag: 1780545341-631019
X-HE-Meta: U2FsdGVkX19gyrV7fvKc1rBxTqpgRJxcjexJqJWPPORiwhJvL0aAjR6bqxZiwKNef6xMLKFdB7/kvh2pQlC0c3EDotqxgdGMouef8a2KJPKmaV4WsdaoS8kgCTWmGX2RXKW99vvIxS177Z4CuVIhFDHBJGYabMCNtYzbky+xZq7r7f+RefMC7hv88AX+MYjLWUF55tS4TyzYtnYVK/GUxt376w0H9o004Rppxd0eWz4liK6Gof3mjUj9P9gaV72BCSPaRCoO3dEEt7aQu+XBjQ3usGdYPrT9ceVt6cIlCNPThmv5ANskgPSMWeRY5k06zbIYQyrXOstb33ir14ib3TApLlhVE6rekZAizwt5aNdKxj0e5RTtuusst32GUxqBsqVusYxqp/VWSaTQ5iTJn+CTpZDw/EAlV759CNZ6Vz5C5VOPS11k4Rc6s0+v27yij8LQzfpxe4VbQ8g3krQgMtAinUucEFav2FHIbnZCCDe1/W91cnp8YcEFGoHQ4HzMLw1I36UeiyBZWikGAtSQIaqZyqjCn9inGuZUQKrSo/3GQFF+DN6REsKEndwsqYbrk6eNzi3kwhzIu3MBYlt1uU+AYyKau7lDH0mhbTwyWMCHA1wx5OUQ7JVSwaJFFb6v63kYRLgwJIA9nFONFX+5uvYWh/FoXV948na2Xy/yu3gh3+iEFjdtLiCZXhJOzHM5wr+OrfbeQgXcAyOwj2fMS7TfH3J02Kzmec4HHSHmWRPr+Hu/BtPLKq154bh5VaKBvR8+kfATsFc1zQ/f1zeoVwTd2Ez7/3xLY6e45SvBUldrhwt31P2LYQBRsnMu4hnw4zQIgq6nvzjmX8I5KEoD3Vk21cLRrHCvvO6HWE1clVR8X5jsM1mZzYfaQVleVGEV+c8uLCAj5io5e9BIeAs2/UQBafaDgkU75wF2jBnBK+JI3bcU79H74pgXbI4nU+0df8EfEnzl+Sn1FNh9wsH
 eRO6kdx4
 D/ubc1AoUiSvtUzynGtA4TZLpOVw/p+N6rJ5d6vujyC0IKfT9VnON85jJPm8kB/CStPSr0JHzJmrE8TzgekZLpqYaIm/zpKh/FUs/jyfOIUer8ys2ONavivTIzqxu5YVYR3qdzALsq6DPqAyXIU6Culp7fkooc7nYVp9+jJ1mvxExAtqqiwPRRGmClVYQTrVljOKH+XW3mL8DjkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 00e06cb773fd81d4f2806a6ee69d1aef8f6dd5ca  mm: mm_init: use div64_ul() instead of do_div()

elapsed time: 1823m

configs tested: 262
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260603    gcc-13.4.0
arc                   randconfig-001-20260604    clang-17
arc                   randconfig-002-20260603    gcc-8.5.0
arc                   randconfig-002-20260604    clang-17
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260603    gcc-13.4.0
arm                   randconfig-001-20260604    clang-17
arm                   randconfig-002-20260603    gcc-10.5.0
arm                   randconfig-002-20260604    clang-17
arm                   randconfig-003-20260603    gcc-8.5.0
arm                   randconfig-003-20260604    clang-17
arm                   randconfig-004-20260603    gcc-11.5.0
arm                   randconfig-004-20260604    clang-17
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    gcc-14.3.0
arm64                 randconfig-001-20260603    clang-23
arm64                          randconfig-002    gcc-8.5.0
arm64                 randconfig-002-20260603    gcc-15.2.0
arm64                          randconfig-003    clang-20
arm64                 randconfig-003-20260603    clang-23
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260603    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    gcc-13.4.0
csky                  randconfig-001-20260603    gcc-16.1.0
csky                           randconfig-002    gcc-14.3.0
csky                  randconfig-002-20260603    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                        randconfig-001    clang-17
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260603    clang-16
hexagon               randconfig-001-20260604    gcc-11.5.0
hexagon                        randconfig-002    clang-23
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260603    clang-23
hexagon               randconfig-002-20260604    gcc-11.5.0
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260603    gcc-14
i386        buildonly-randconfig-001-20260604    clang-20
i386        buildonly-randconfig-002-20260603    gcc-14
i386        buildonly-randconfig-002-20260604    clang-20
i386        buildonly-randconfig-003-20260603    clang-22
i386        buildonly-randconfig-003-20260604    clang-20
i386        buildonly-randconfig-004-20260603    gcc-12
i386        buildonly-randconfig-004-20260604    clang-20
i386        buildonly-randconfig-005-20260603    gcc-14
i386        buildonly-randconfig-005-20260604    clang-20
i386        buildonly-randconfig-006-20260603    clang-22
i386        buildonly-randconfig-006-20260604    clang-20
i386                                defconfig    clang-22
i386                  randconfig-001-20260603    gcc-14
i386                  randconfig-002-20260603    gcc-14
i386                  randconfig-003-20260603    gcc-14
i386                  randconfig-004-20260603    gcc-14
i386                  randconfig-005-20260603    clang-20
i386                  randconfig-006-20260603    gcc-12
i386                  randconfig-007-20260603    clang-20
i386                  randconfig-011-20260603    gcc-14
i386                  randconfig-011-20260604    gcc-14
i386                  randconfig-012-20260603    gcc-14
i386                  randconfig-012-20260604    gcc-14
i386                  randconfig-013-20260603    clang-20
i386                  randconfig-013-20260604    gcc-14
i386                  randconfig-014-20260603    clang-20
i386                  randconfig-014-20260604    gcc-14
i386                  randconfig-015-20260603    clang-20
i386                  randconfig-015-20260604    gcc-14
i386                  randconfig-016-20260603    gcc-14
i386                  randconfig-016-20260604    gcc-14
i386                  randconfig-017-20260603    clang-20
i386                  randconfig-017-20260604    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    clang-18
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260603    gcc-16.1.0
loongarch             randconfig-001-20260604    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch                      randconfig-002    gcc-13.4.0
loongarch             randconfig-002-20260603    clang-23
loongarch             randconfig-002-20260604    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-17
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260603    gcc-8.5.0
nios2                 randconfig-001-20260604    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260603    gcc-8.5.0
nios2                 randconfig-002-20260604    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-17
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-17
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260603    gcc-8.5.0
parisc                randconfig-002-20260603    gcc-8.5.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-17
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260603    gcc-11.5.0
powerpc               randconfig-002-20260603    gcc-13.4.0
powerpc64             randconfig-001-20260603    clang-23
powerpc64             randconfig-002-20260603    gcc-11.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-17
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-17
riscv                 randconfig-001-20260603    gcc-8.5.0
riscv                 randconfig-001-20260604    clang-17
riscv                          randconfig-002    clang-17
riscv                 randconfig-002-20260603    gcc-8.5.0
riscv                 randconfig-002-20260604    clang-17
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-17
s390                  randconfig-001-20260603    clang-16
s390                  randconfig-001-20260604    clang-17
s390                           randconfig-002    clang-17
s390                  randconfig-002-20260603    gcc-13.4.0
s390                  randconfig-002-20260604    clang-17
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-17
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                             randconfig-001    clang-17
sh                    randconfig-001-20260603    gcc-10.5.0
sh                    randconfig-001-20260604    clang-17
sh                             randconfig-002    clang-17
sh                    randconfig-002-20260603    gcc-13.4.0
sh                    randconfig-002-20260604    clang-17
sh                  sh7785lcr_32bit_defconfig    gcc-16.1.0
sh                          urquell_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-17
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260603    gcc-8.5.0
sparc                 randconfig-002-20260603    gcc-16.1.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260603    clang-23
sparc64               randconfig-002-20260603    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260603    gcc-14
um                    randconfig-002-20260603    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-17
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260603    gcc-14
x86_64      buildonly-randconfig-001-20260604    gcc-14
x86_64      buildonly-randconfig-002-20260603    gcc-14
x86_64      buildonly-randconfig-002-20260604    gcc-14
x86_64      buildonly-randconfig-003-20260603    clang-20
x86_64      buildonly-randconfig-003-20260604    gcc-14
x86_64      buildonly-randconfig-004-20260603    clang-20
x86_64      buildonly-randconfig-004-20260604    gcc-14
x86_64      buildonly-randconfig-005-20260603    clang-20
x86_64      buildonly-randconfig-005-20260604    gcc-14
x86_64      buildonly-randconfig-006-20260603    gcc-14
x86_64      buildonly-randconfig-006-20260604    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260603    clang-22
x86_64                randconfig-002-20260603    clang-22
x86_64                randconfig-003-20260603    clang-22
x86_64                randconfig-004-20260603    clang-22
x86_64                randconfig-005-20260603    clang-22
x86_64                randconfig-006-20260603    gcc-14
x86_64                randconfig-011-20260603    gcc-14
x86_64                randconfig-012-20260603    gcc-14
x86_64                randconfig-013-20260603    clang-22
x86_64                randconfig-014-20260603    gcc-14
x86_64                randconfig-015-20260603    gcc-14
x86_64                randconfig-016-20260603    clang-22
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260603    clang-20
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260603    gcc-14
x86_64                         randconfig-073    clang-20
x86_64                randconfig-073-20260603    gcc-12
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260603    clang-20
x86_64                         randconfig-075    gcc-13
x86_64                randconfig-075-20260603    clang-20
x86_64                         randconfig-076    clang-20
x86_64                randconfig-076-20260603    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-17
xtensa                            allnoconfig    gcc-15.2.0
xtensa                randconfig-001-20260603    gcc-9.5.0
xtensa                randconfig-002-20260603    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

