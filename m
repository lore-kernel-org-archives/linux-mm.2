Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED7F606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 07:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jQzkJ0YU
Received: by kanga.kvack.org (Postfix)
	id 82C136B05B0; Sun, 25 Oct 2026 03:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCC96B05B1; Sun, 25 Oct 2026 03:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2276B05B2; Sun, 25 Oct 2026 03:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA166B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:42:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF7011205E3
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:42:48 +0000 (UTC)
X-FDA: 85360356816.29.F4834D9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id B517F40006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:42:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jQzkJ0YU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792914166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UOamm9FXz+RobRXwLnxToUC0Y6UEC8OdlmShWJTdkvk=;
	b=58lWoemaWlWednGNpAkcIn7nLr2nZpo18syfpBjKtmzXOryXai1W4B2o59JiM39opmZdON
	ag8uWAordEhcXN9hGexJTMhJdmbP0S7ZhhI9o5pmhTfqR8iEEDZp46YxZBTBUJyYERq7Ur
	zBxI/5KzGctr8HzDwQZYpYC8UEhKQ1s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jQzkJ0YU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792914166;
	b=DXlTMtie+vAjozvg4wUbYyPD6j720cVvL69VOhbvCS9QEVpP11o+o9W+sTzNDCsCOJIgZP
	YwypuSvgkcK9w2ZfYtewEt2EDtQq6k+AqAVR+bbkwmFLdCHvas4gAz7ETUMnUaOm+bdsB6
	mKyLxnW/ZPUNoce0Edqz4ZWIQ518x4Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792914166; x=1824450166;
  h=date:from:to:cc:subject:message-id;
  bh=w3qrypn9AR07EOCVuR0E3CRcksGJr7htkZiZcW23iDY=;
  b=jQzkJ0YUssbMUNci2DClvK6ggIDyUVfxWkqDxDrn+zAfeq/RsKWvC1OJ
   GTgxCiX+cvw1RroEqIpOvzl9dDiN+qOAVCPTb9Dszjk5mPStqTFLt5AH6
   wZfwmpSyEQZhKolq7AOYVZyOyQ5lC90zmk1d7xpgSnb3JN2SpqwgqXN5d
   Nc6C+8h96TYoWqPX398WO8wFcGI+DwbTcqoql9rjVMQv5LXnUntQkM+Ff
   VwPxXD9pIgBGIvWoyfZtsqUjRbErrMc17yNf8bu5/CSlynmAoQndt7xS0
   NuzDz7wCB51tliHKmtr4bHRXayONgvE5BWAq1GBahrHJ/zbplvCAZ5MW6
   Q==;
X-CSE-ConnectionGUID: ItWIrK0gQ7ipRYsI59RDuQ==
X-CSE-MsgGUID: D99L7585Qfe6hv9f7V0CoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11945"; a="1480004"
X-IronPort-AV: E=Sophos;i="6.27,177,1787036400"; 
   d="scan'208";a="1480004"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 00:42:45 -0700
X-CSE-ConnectionGUID: CyKTLklPR06WojuShqD8OA==
X-CSE-MsgGUID: W3FI8CxWRu6FJqDVhMxDaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,177,1787036400"; 
   d="scan'208";a="4367660"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 25 Oct 2026 00:42:42 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKssJ-00000000UeQ-0K3X;
	Sun, 25 Oct 2026 07:42:39 +0000
Date: Sun, 25 Oct 2026 15:42:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 09e0a4f618cb8159c993d3140914523fe5d4dfee
Message-ID: <202610251552.ddrndIJh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: B517F40006
X-Rspam-User: 
X-Stat-Signature: h8ywdqrz9355464r7gpuu8jmxwiw9hga
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792914165-816776
X-HE-Meta: U2FsdGVkX19bXHEOiZbGXev3sI8sX9V2+37xFeK9WvBiUXC+sndLtyZxaUfPryZ0IxfG6braJ6DkEonCrhWq6ZZ7ZQkUVt2vpD9FXMIzlRyGLZOUubss3uIihmGHbow+lJDDahmbJ1RPbJn84lcSk2IVGg5M/qDGKl/4JDIK66RDnASJukVd9kzRj5iiErySmeRGqzDDMmNNJTSA1IUSrTAA3M63Q11x/ineXyPmsPA8PAcQC/xGX9vdtiZ+ZV1EZwK7/pbxFOWcjE6zVdXWtw/CYstruTrj6PXdDKyVE2XJ2AUZMYmhTBbV4LHMmY4pPWVHRwREzE3o8NSkBoA1OBAcDDPhp4+DQf1fMa92DcJrsIlYWwqyNFfUzxOi+StwJtZgGhan70AtIL2tFyArsLaoyNCjOZ9ArDsIa3ftRWIflxtGi07eWgYFG67r2iPwy4OD9YLX5cbJhpdfAc1Ppod7ffWuJTEoLwhxJFN79rc6ewxDFPEHczFq1wPZjvfa9G2kaTdB6MtHLmDSo0YjUBNJdR+LkL8yxB+8nRXh4zyRbI6PMuh5v5orSH/dkDpNkesNYp7ZfGHmM15cSMx6yzmdKfRCC1sRWyfg8UXQ1W4V7v1W6zt/aUscKy7O8b5CxmvabTvmUkyzD/WN1CaGahtDabP6wPzk08YaDhHkdJPq5Wp14Ah3sD0bMFZmra0/ofS9Qq8n5J4Fe7MjhEkbSn+BVDQzxpuIvmKdvAb5681vyU7U9e4P9vHscT0VrTjsNAZBSE2KCN5yfqXQubFIEgzYvRKBBqfykioAX7sI3GgoV3/NoAF3G9ZnayMnb9rrsKm8MHGdDpVCZsweDKqsx5AcyZq5t/LqlcBtACmQkPZcotWnvy3XviJRzMSAU34GUC78ekPikVoUjg2fR6bywyxBEyXo5OowMEIwugAg4nYKkItLHBRF+uJdx0hec113d86Y3nAsSDkNweHxYc9
 blG180n0
 p7U+jqhIbCUGEfra8bfGJ/JdUFKDABB1XzXDdmVTpbrcFYiROGAoRtS+pTBc26XIiTwMKO7PqFZINO72EuveQnAIQsk9xzFqnnBLYd/3BbW7uJCIUl9DBCI3BbN9bUwhuV74zYmNodPDCkRIfd5Dk0eJ72qUuUlfpZZuMyrSu8MD36zrDlasgFbhHd3ZAB1Szq4RbyehR1rg3WCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 09e0a4f618cb8159c993d3140914523fe5d4dfee  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1150m

configs tested: 245
configs skipped: 5

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
arc                   randconfig-1000-20261025    clang-24
arc                   randconfig-1001-20261025    clang-24
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    gcc-16.2.0
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261025    clang-24
arm                   randconfig-1001-20261025    clang-24
arm                   randconfig-1002-20261025    clang-24
arm                   randconfig-1003-20261025    clang-24
arm                        spear13xx_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261024    clang-24
arm64                 randconfig-1000-20261025    clang-24
arm64                 randconfig-1001-20261024    clang-24
arm64                 randconfig-1001-20261025    clang-24
arm64                 randconfig-1002-20261024    gcc-10.5.0
arm64                 randconfig-1002-20261025    clang-24
arm64                 randconfig-1003-20261024    clang-19
arm64                 randconfig-1003-20261025    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261024    gcc-16.2.0
csky                  randconfig-1000-20261025    clang-24
csky                  randconfig-1001-20261024    gcc-11.5.0
csky                  randconfig-1001-20261025    clang-24
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261025    clang-24
hexagon               randconfig-1001-20261025    clang-24
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261025    gcc-14
i386        buildonly-randconfig-1001-20261025    gcc-14
i386        buildonly-randconfig-1002-20261025    gcc-14
i386        buildonly-randconfig-1003-20261025    gcc-14
i386        buildonly-randconfig-1004-20261025    gcc-14
i386        buildonly-randconfig-1005-20261025    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261024    clang-22
i386                  randconfig-1000-20261025    clang-22
i386                  randconfig-1001-20261024    clang-22
i386                  randconfig-1001-20261025    clang-22
i386                  randconfig-1002-20261024    clang-22
i386                  randconfig-1002-20261025    clang-22
i386                  randconfig-1003-20261024    gcc-14
i386                  randconfig-1003-20261025    clang-22
i386                  randconfig-1004-20261024    clang-22
i386                  randconfig-1004-20261025    clang-22
i386                  randconfig-1005-20261024    gcc-13
i386                  randconfig-1005-20261025    clang-22
i386                  randconfig-1006-20261024    gcc-14
i386                  randconfig-1006-20261025    clang-22
i386                  randconfig-1007-20261024    gcc-14
i386                  randconfig-1007-20261025    gcc-14
i386                  randconfig-1008-20261024    gcc-14
i386                  randconfig-1008-20261025    gcc-14
i386                  randconfig-1009-20261024    gcc-14
i386                  randconfig-1009-20261025    gcc-14
i386                  randconfig-1010-20261024    clang-22
i386                  randconfig-1010-20261025    gcc-14
i386                  randconfig-1011-20261024    clang-22
i386                  randconfig-1011-20261025    gcc-14
i386                  randconfig-1012-20261024    gcc-14
i386                  randconfig-1012-20261025    gcc-14
i386                  randconfig-1013-20261024    clang-22
i386                  randconfig-1013-20261025    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261025    clang-24
loongarch             randconfig-1001-20261025    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                   decstation_64_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261025    clang-24
nios2                 randconfig-1001-20261025    clang-24
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
parisc                randconfig-1000-20261024    gcc-15.3.0
parisc                randconfig-1000-20261025    clang-24
parisc                randconfig-1001-20261024    gcc-8.5.0
parisc                randconfig-1001-20261025    clang-24
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261024    gcc-12.5.0
powerpc               randconfig-1000-20261025    clang-24
powerpc               randconfig-1001-20261024    gcc-14.4.0
powerpc               randconfig-1001-20261025    clang-24
powerpc                      tqm8555_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261024    clang-19
powerpc64             randconfig-1000-20261025    clang-24
powerpc64             randconfig-1001-20261024    clang-24
powerpc64             randconfig-1001-20261025    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261025    gcc-10.5.0
riscv                 randconfig-1001-20261025    gcc-10.5.0
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261025    gcc-10.5.0
s390                  randconfig-1001-20261025    gcc-10.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                           polaris_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261025    gcc-10.5.0
sh                    randconfig-1001-20261025    gcc-10.5.0
sh                            se7712_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261025    gcc-14
sparc                 randconfig-1001-20261025    gcc-14
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261025    gcc-14
sparc64               randconfig-1001-20261025    gcc-14
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261025    gcc-14
um                    randconfig-1001-20261025    gcc-14
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261025    gcc-14
x86_64      buildonly-randconfig-1001-20261025    gcc-14
x86_64      buildonly-randconfig-1002-20261025    gcc-14
x86_64      buildonly-randconfig-1003-20261025    gcc-14
x86_64      buildonly-randconfig-1004-20261025    gcc-14
x86_64      buildonly-randconfig-1005-20261025    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261024    clang-22
x86_64                randconfig-1000-20261024    gcc-14
x86_64                randconfig-1001-20261024    gcc-14
x86_64                randconfig-1002-20261024    gcc-14
x86_64                randconfig-1003-20261024    gcc-14
x86_64                randconfig-1004-20261024    clang-22
x86_64                randconfig-1004-20261024    gcc-14
x86_64                randconfig-1005-20261024    gcc-14
x86_64                randconfig-1006-20261024    gcc-14
x86_64                randconfig-1006-20261025    clang-22
x86_64                randconfig-1007-20261024    gcc-13
x86_64                randconfig-1007-20261025    clang-22
x86_64                randconfig-1008-20261024    gcc-14
x86_64                randconfig-1008-20261025    clang-22
x86_64                randconfig-1009-20261024    clang-22
x86_64                randconfig-1009-20261025    clang-22
x86_64                randconfig-1010-20261024    gcc-14
x86_64                randconfig-1010-20261025    clang-22
x86_64                randconfig-1011-20261024    clang-22
x86_64                randconfig-1011-20261025    clang-22
x86_64                randconfig-1012-20261024    gcc-14
x86_64                randconfig-1012-20261025    clang-22
x86_64                randconfig-1013-20261024    clang-22
x86_64                randconfig-1013-20261025    clang-22
x86_64                randconfig-1014-20261024    clang-22
x86_64                randconfig-1014-20261025    clang-22
x86_64                randconfig-1015-20261024    clang-22
x86_64                randconfig-1015-20261025    clang-22
x86_64                randconfig-1016-20261024    clang-22
x86_64                randconfig-1016-20261025    clang-22
x86_64                randconfig-1017-20261024    clang-22
x86_64                randconfig-1017-20261025    clang-22
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
xtensa                randconfig-1000-20261025    gcc-14
xtensa                randconfig-1001-20261025    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

