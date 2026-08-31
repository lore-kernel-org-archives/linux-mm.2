Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFC7C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA486B008A; Mon, 31 Aug 2026 04:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABA56B008C; Mon, 31 Aug 2026 04:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799E06B0092; Mon, 31 Aug 2026 04:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41CAE6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:16:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B69411A03BE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:16:19 +0000 (UTC)
X-FDA: 85160857278.04.F6A1791
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8F4F312000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:16:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OD66rEDt;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164177;
	b=5ovMvnVpQL+wBNAzyTqB1AO7qjCQxB9HM9qM8DnbTatWQs6qb9WgMBcBh4QNIF3hezlxkf
	ad8xOQomd2xkp1aWA0doqK26JcOgacXtTrXJOJUaecA5EA5EcmIvWGtRL6GRScHf7bbg2Z
	c5P7XDPz50LIgm5pX2MLwtZpQ9sWgbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gmj+qOuzfTsWXIPq76fy+iKHANtTeUQp1sPuZmuPqxw=;
	b=D1IqaeGDOzPdVGLK6s+Xym5kA62oUuAsZlbeS4xHfjy3IUTp/KM88QISwCPhN0jGFYIUtF
	0yQ2UbzUgmC0fw2xcc/sni5lHvhWkERVX1dGqexYc/rgVrMinwh2VmIuDtsCkO40eQsrn2
	cvJylsXwCYHi87HTqnqt9xF3xBF/BKU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OD66rEDt;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788164177; x=1819700177;
  h=date:from:to:cc:subject:message-id;
  bh=0U702yJcbd24Mu5PvfVhwQ/Kix6w1KoMLIReavJw4Cs=;
  b=OD66rEDtCGLFVp9d3KDMwaySXqNvvYR2LidMSSxYw1lHIeG7gErs2UGN
   hI2L4+Le6UESozl2ApQnlreHO45pGpPCbWUTDt0n+EuR+/JsEVvGXsOpP
   9C9xZOd97nP/4SM/wJKOlE9JtzKwseetSTNINwotL7Ec27B6JIUOkkavP
   Q09AbLyu2pqNRcZQVAqDDIRwZh9eh3BVUTWh4FvRHCVAMbH5EGKCzFFoT
   DKGYEEC3+9nNdFEmlf9tJYp0R5Zrzcoe4vjMSAI3+/QLquf+DD0sdR8x5
   mtLf+Vxp/w0Hcn7wlrv93txepJU9o+75o1urfn+6VZMy+GZ32jMkT4c99
   A==;
X-CSE-ConnectionGUID: NqNhEnEPRRiSsRfn27viOw==
X-CSE-MsgGUID: T75pKzDHQjqeNqjwMKdUkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="100076773"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="100076773"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:16:13 -0700
X-CSE-ConnectionGUID: JA2LiJtbSeyyxboh5pUlzg==
X-CSE-MsgGUID: +z45bSEwQyug/K4UVqvIIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="274002441"
Received: from lkp-server01.sh.intel.com (HELO 12c799cf0c09) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 31 Aug 2026 01:16:10 -0700
Received: from kbuild by 12c799cf0c09 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0x9w-000000000NY-31uk;
	Mon, 31 Aug 2026 08:14:38 +0000
Date: Mon, 31 Aug 2026 15:51:44 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 da6c37ed8beb273e3308e42d4bca3ce11b4432fa
Message-ID: <202608311524.TNSAy5ID-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F4F312000C
X-Stat-Signature: fax838n91qmp1dc1r848k3pc7r4pite9
X-HE-Tag: 1788164174-57758
X-HE-Meta: U2FsdGVkX18lL7M8RA9Y6zZikFlrQyu5VNLwvERkmL8+VMSCWbRcKSUpC+bO9B5gaIzkOGh3gknQSQ6jekhN+XftxH9DcWC57jYOtuqAJnwNFdhfcHnlYVwcQg5nBIChDAPpQxzuWBe3BBMlp7RwqSgN+jmxDX0ufGm+Vfkij2zrSXJJWbDyBzgx+xf9L4aCsdNvQCcZN98Z0Kj0XlOsew/6PV9D7iQKCm9Uu1Gupr97Ry1TEmLaOLmWbNtpABMKM8F62YNcocKjHPg5gE/0I4sLwKbXKif1U1/lgeICU30lqEMBqHhS1PkoAIR6zr7vjMRnGNWoatiUupsvfY3c2NJ783+d+p5NKqBIp1khFvumBwa6OUlKwQZOeclbyyCcllSidsZLFRnXFlY+PCVgcCMWTbPs5St28kq5AYRDCKP8TrM4vrvDZs+5O85QiT9rNxNbu8aSP7olixZ+tizTMfzchxrkcQOeK5626iyZD1rEtF5pBLRfVVfmVl3rKgmYtKt+jQQU2vWuzpI03H5z4T9vpyeMsv1uZHnSqcAtYQmoPNkuqgVjELXIA/afUF0dcN/jet/PW22a5JBsBvIW2M26g97sdg3MsD+qJuL4BFfH6YEMhBcY12ODLq4Q8KrRVSmIuu2bBPkOxdTGsVzOV6P3NZqRsmv+uDzKn2W4uF+nmZy1IeqdlXCmWBCXloz/1ZXgOB97eW91UjR6cPBtPvdKWuAVHDKOHQR8WCk2RaK9WQBTv/04MpZSGERxTzW5kq/m7AoxpZPlfIK1wjzkaGvaMmxjfdFP+rASbPOUUfdRgi6itz1M1kmwYvXJ0180+J7xlU4jGCbkuv2yo7GTgorqpVdaC3+kbDjik3Jlq62wsl7PBjuKFxc/3rwpjgjI2uxZUAjfW5cQgRbLctI+pqfUJ8Uz0EJQNXj31O7PbKQ1lBwK5+hK4QOGOVLb6rd+6+TTrrz5bNLaVfIRUKw
 DZOVD2br
 I/spH4l1XLA9Xzr+ZMCbg9Z8aYn0uZzMlaxUSb/vJExMI7yeGLTmfkRRLXuFyJa941H8fXHmx5h3q+kNcCZM6dA94Br4XL5mf0bIWcDD+hi/BC7viXiSHvYVeoR59FZE/QJvxZU+HxgT0RSZI7f2zZEsUslThGnJ8sT4XEGdpbYwAo6f+A9GH/hYd9GLjEVWFWV5wx+6Mjp8/G/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: da6c37ed8beb273e3308e42d4bca3ce11b4432fa  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 848m

configs tested: 166
configs skipped: 4

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
arc                   randconfig-001-20260831    gcc-8.5.0
arc                   randconfig-002-20260831    gcc-14.3.0
arm                               allnoconfig    clang-17
arm                              allyesconfig    gcc-16.1.0
arm                       aspeed_g5_defconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                   randconfig-001-20260831    clang-20
arm                   randconfig-002-20260831    gcc-16.1.0
arm                   randconfig-003-20260831    gcc-14.3.0
arm                   randconfig-004-20260831    gcc-16.1.0
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260831    gcc-16.1.0
arm64                 randconfig-002-20260831    clang-24
arm64                 randconfig-003-20260831    gcc-16.1.0
arm64                 randconfig-004-20260831    clang-21
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260831    gcc-16.1.0
csky                  randconfig-002-20260831    gcc-16.1.0
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                             defconfig    clang-24
hexagon               randconfig-001-20260831    clang-24
hexagon               randconfig-002-20260831    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260831    clang-22
i386        buildonly-randconfig-002-20260831    gcc-14
i386        buildonly-randconfig-003-20260831    clang-22
i386        buildonly-randconfig-004-20260831    gcc-14
i386        buildonly-randconfig-005-20260831    gcc-13
i386        buildonly-randconfig-006-20260831    clang-22
i386                                defconfig    clang-22
i386                  randconfig-001-20260831    clang-22
i386                  randconfig-002-20260831    clang-22
i386                  randconfig-003-20260831    clang-22
i386                  randconfig-004-20260831    gcc-14
i386                  randconfig-005-20260831    gcc-14
i386                  randconfig-006-20260831    gcc-14
i386                  randconfig-007-20260831    clang-22
i386                  randconfig-011-20260831    clang-22
i386                  randconfig-012-20260831    clang-22
i386                  randconfig-013-20260831    gcc-14
i386                  randconfig-014-20260831    gcc-14
i386                  randconfig-015-20260831    gcc-12
i386                  randconfig-016-20260831    gcc-14
i386                  randconfig-017-20260831    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-24
loongarch                loongson64_defconfig    clang-24
loongarch             randconfig-001-20260831    clang-24
loongarch             randconfig-002-20260831    clang-24
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                          eyeq6_defconfig    clang-24
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260831    gcc-11.5.0
nios2                 randconfig-002-20260831    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260831    gcc-8.5.0
parisc                randconfig-002-20260831    gcc-15.2.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260831    clang-21
powerpc               randconfig-002-20260831    clang-21
powerpc64             randconfig-001-20260831    clang-24
powerpc64             randconfig-002-20260831    gcc-14.3.0
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                 randconfig-001-20260831    clang-17
riscv                 randconfig-002-20260831    gcc-8.5.0
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260831    clang-17
s390                  randconfig-002-20260831    clang-24
s390                       zfcpdump_defconfig    clang-22
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                          r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-001-20260831    gcc-14.3.0
sh                    randconfig-002-20260831    gcc-16.1.0
sh                          sdk7780_defconfig    gcc-16.1.0
sh                           se7343_defconfig    gcc-16.1.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260831    gcc-11.5.0
sparc                 randconfig-002-20260831    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64               randconfig-001-20260831    gcc-15.2.0
sparc64               randconfig-002-20260831    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260831    clang-20
um                    randconfig-002-20260831    clang-20
um                           x86_64_defconfig    clang-24
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260831    gcc-14
x86_64      buildonly-randconfig-002-20260831    gcc-14
x86_64      buildonly-randconfig-003-20260831    gcc-13
x86_64      buildonly-randconfig-004-20260831    clang-22
x86_64      buildonly-randconfig-005-20260831    gcc-13
x86_64      buildonly-randconfig-006-20260831    clang-22
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260831    gcc-14
x86_64                randconfig-002-20260831    gcc-14
x86_64                randconfig-003-20260831    gcc-14
x86_64                randconfig-004-20260831    gcc-12
x86_64                randconfig-005-20260831    clang-22
x86_64                randconfig-006-20260831    gcc-14
x86_64                randconfig-011-20260831    clang-22
x86_64                randconfig-012-20260831    clang-22
x86_64                randconfig-013-20260831    gcc-14
x86_64                randconfig-014-20260831    clang-22
x86_64                randconfig-015-20260831    gcc-14
x86_64                randconfig-016-20260831    clang-22
x86_64                randconfig-071-20260831    clang-22
x86_64                randconfig-072-20260831    clang-22
x86_64                randconfig-073-20260831    gcc-14
x86_64                randconfig-074-20260831    clang-22
x86_64                randconfig-075-20260831    clang-22
x86_64                randconfig-076-20260831    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                       common_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260831    gcc-11.5.0
xtensa                randconfig-002-20260831    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

