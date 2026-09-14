Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2E5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02C86B0095; Mon, 14 Sep 2026 14:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2A76B0096; Mon, 14 Sep 2026 14:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B276B0098; Mon, 14 Sep 2026 14:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873696B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:10:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E75A71A0214
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:10:32 +0000 (UTC)
X-FDA: 85213157904.10.0ACB770
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6EB48100007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:10:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hpd5rZcz;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=oWCXcVfLtQr6ddalMOnL4Mdl52oIkpQGwqSUXYxtox4=;
	b=aEYIDrYYcUJeOdOpi/Ua72tfbf/zpJX+w56hDhE6RYsSfnCMzXjFlZGD+qBFu0em7FlUZ2
	BfIP+Oucf+APiI1hB+EItaRWpAoeIN4cMGCvD+lY/Ef9h3cUaIKJ2zRJzzpjYqTlb0J9D7
	hed+tZaFBz/P1HIdB2+Dau7nBf7XMvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409431;
	b=wMUbqKA5YEKSIZs1jbDiT/C7pwFPoT56JHpgujSLmJM2VWC4I0Gwe3OkTZMYScoCaO7Rre
	nvTjmafO8r8BTV2dJQQ9zgNlt50dRG8UxQjeGX0KaKfMoNP8dwkbjQHrWPJWIqL1CwdAeE
	G5KUU9sxg0ZR3R3VKpophLcMO8T+TvM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hpd5rZcz;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789409431; x=1820945431;
  h=date:from:to:cc:subject:message-id;
  bh=MiwZ84eooslCy29ZODfQcIPQQBjyRjsLXggEacsmzkE=;
  b=hpd5rZczYEVhpD6Py6CZNVHImAlTvTTAcfPvYSWGl52XXh8Sx7Q7j5Qz
   HGx1vhDHA123FDi+mTUN8FgtnhtpldOX3h03iZrDAp+UYY9L7Cdo/NfhI
   tcyMsd02moQSRzmZ+AIpBMBvZWVamhWWtkiivDpxP2OVIeJAhj0V6MNQc
   9FTpMSM3f0ygS2BPb9KmlKpyWE0qAWXAcHC9IZFV/Lpu7XDqbOhvXDFGi
   +pYJsrut/9Cy4aWXN8i/1yGGUb0Lyl0X2p3nbPa5f9UgC3ec3J8llbMV4
   4N545tm3I9EFlrEAnZezFQKQ+lEEi4PbLZdjf7vP315ktolM5/55QJu5x
   A==;
X-CSE-ConnectionGUID: bu43MsvxRLSR97Z6Ycy3rg==
X-CSE-MsgGUID: odT40OBwQNa0kCH9mM16XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="107138686"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="107138686"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 11:10:30 -0700
X-CSE-ConnectionGUID: wEJv1fMfT2u17HiTdtVafA==
X-CSE-MsgGUID: GRU8T2+6TFSFQsqFjP0lag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="274652774"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 14 Sep 2026 11:10:27 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6B8K-000000003Ip-3gZM;
	Mon, 14 Sep 2026 18:10:24 +0000
Date: Tue, 15 Sep 2026 02:10:03 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 383fc05d4650b021f3c17e36a145106dcc61a294
Message-ID: <202609150259.5zswfxI5-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: ye8f63fdh51k8d9nwkczsag356hk5mri
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EB48100007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789409430-101086
X-HE-Meta: U2FsdGVkX1/n/71jKHFs3D5vYYp5WCxDYPPJvbu4uA9XDAEXEtMhj7NDo6SJkNqHRXE8dLHLDURiAeHWjfG+GBhDfIBYjgy9cHWkzE0y8ZGOohBXrtsaXbzAZ1TGvgO0VbPMnp261/1UHa2U9boxUUOLIXMSBI8DTHpnXsH48pFWUHFXH9rsy8xEHGZMgZCIBA1cIqUeuPha0QvbfWjIX7rb1jG8uODwr/xuzo2BQiWaeApzI/YFKxICvFN7tmJbhVIVrTwyt/kcGy2kw+UagHZN5fq7lnK8gBoJJbWMV47TLRN8JexKeO4vqa2M7/jYgYWQE2IsPlgdKz18FnznpQmhJOP2mpndkkgP0DLtNRhXltP0ymp9cc/WnwaTQLqbUaVcKcbLIaukKjpuHgN4IhGk7tgiDPwapPCbYPT+ZtOHa6Uv7d94LzFwHBaqoJKlMqT4kskTg+KD4lW9Ih/caJ+NMXKjcx5NHsS0rBk5Ql7NLYMLvqTle/xhR7/r5JqyehuZ3dbVEG1KC8OQWlY6UEKb1P/iapCAw/kUMIlPDptnMr2ObPRkUUUzd4kQYj+MJ0YVkHLEzpzVYOp2RiI+pH2LfWcNvFpe51rM4WgfgWgjxpkZlaEC8icSXv/RvHRYOaq0uWo+QQpLCe79d/ZmMYqb9mK3gvWQNnqWpGFbHNItabccT/B2JvdWps2bb9UVCIUTqWYOQuRSlXlGMqOtB9P9Ekh4KlsKxHiePYJl2grUkGMZ+Dv4PANs2LnHB8lcGjTlr8Oj6jwgfFVj5rGRaPiQbRLCNWdGAe6GnOTTQbzZUwqQVDGy6xbKGeriQXChkqP9vibHqR3TLk04yRnkOijonALc0y7W0SyygZDoc9HlHAi3NgSssOIXU1di7WHg16QPIe3Cl+ZHmZ5IasyMk+0dv5/RosKfABnx/3Wck2aSmTMWvOJyIRPGcMdA42uF0QKqJwaD+TFsZ+bdCRV
 R4a17x7O
 cmqlXnRii7IaDV30e1/DFAsXl+5RY7o8uc6EaHk2ZyQiz7WewNZl8x7PI9Y2zRP09/N2ujs8rczxSWfwRHMdSHyLx8vD4fu6Alf9PWVNWPuYh9QYqNMB7CCtkqVP34NNAQYXZJz4sSNLQmCUScloFBdj5JDrIKPl8hzYnTQxYPz2r2NqvU8AcwxNNz4RskwZ4TkAa3SIm+445QFCyR8vQ2OuKTWHPMMEz563C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 383fc05d4650b021f3c17e36a145106dcc61a294  mm/swap, PM: hibernate: atomically replace hibernation pin

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com

    fs/proc/task_mmu.c:187:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
    fs/proc/task_mmu.c:195:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r131-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
|-- csky-randconfig-002-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
|-- i386-randconfig-016-20260913
|   |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
|   `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used
`-- openrisc-randconfig-r111-20260913
    |-- fs-proc-task_mmu.c:warning:drop_rcu-defined-but-not-used
    `-- fs-proc-task_mmu.c:warning:reacquire_rcu-defined-but-not-used

elapsed time: 2626m

configs tested: 365
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r121-20260914    gcc-12.5.0 sparse
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                 nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-001-20260913    gcc-8.5.0
arc                   randconfig-001-20260914    gcc-13.4.0
arc                   randconfig-002-20260913    gcc-16.1.0
arc                   randconfig-002-20260914    gcc-13.4.0
arc                        vdk_hs38_defconfig    gcc-16.1.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                           omap1_defconfig    gcc-16.1.0
arm                   randconfig-001-20260913    gcc-8.5.0
arm                   randconfig-001-20260914    gcc-13.4.0
arm                   randconfig-002-20260913    clang-17
arm                   randconfig-002-20260914    gcc-13.4.0
arm                   randconfig-003-20260913    clang-17
arm                   randconfig-003-20260914    gcc-13.4.0
arm                   randconfig-004-20260913    gcc-10.5.0
arm                   randconfig-004-20260914    gcc-13.4.0
arm                       spear13xx_defconfig    gcc-16.1.0
arm                    vt8500_v6_v7_defconfig    gcc-14
arm64                            allmodconfig    clang-24
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260913    gcc-8.5.0
arm64                 randconfig-001-20260914    gcc-9.5.0
arm64                 randconfig-002-20260913    gcc-8.5.0
arm64                 randconfig-002-20260914    gcc-9.5.0
arm64                 randconfig-003-20260913    gcc-10.5.0
arm64                 randconfig-003-20260914    gcc-9.5.0
arm64                 randconfig-004-20260913    gcc-16.1.0
arm64                 randconfig-004-20260914    gcc-9.5.0
arm64                randconfig-r132-20260914    gcc-14 sparse
csky                             allmodconfig    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260913    gcc-16.1.0
csky                  randconfig-001-20260914    gcc-9.5.0
csky                  randconfig-002-20260913    gcc-16.1.0
csky                  randconfig-002-20260914    gcc-9.5.0
csky                 randconfig-r122-20260914    gcc-12.5.0 sparse
csky                 randconfig-r131-20260914    gcc-13.4.0 sparse
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260913    clang-17
hexagon               randconfig-001-20260914    gcc-13.4.0
hexagon               randconfig-002-20260913    clang-24
hexagon               randconfig-002-20260914    gcc-13.4.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260913    gcc-14
i386        buildonly-randconfig-001-20260914    gcc-14
i386        buildonly-randconfig-002-20260913    clang-22
i386        buildonly-randconfig-002-20260914    gcc-14
i386        buildonly-randconfig-003-20260913    gcc-14
i386        buildonly-randconfig-003-20260914    gcc-14
i386        buildonly-randconfig-004-20260913    gcc-14
i386        buildonly-randconfig-004-20260914    gcc-14
i386        buildonly-randconfig-005-20260913    clang-22
i386        buildonly-randconfig-005-20260914    gcc-14
i386        buildonly-randconfig-006-20260913    gcc-14
i386        buildonly-randconfig-006-20260914    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260913    clang-22
i386                  randconfig-001-20260914    clang-22
i386                  randconfig-002-20260913    gcc-14
i386                  randconfig-002-20260914    clang-22
i386                  randconfig-003-20260913    gcc-13
i386                  randconfig-003-20260914    clang-22
i386                  randconfig-004-20260913    clang-22
i386                  randconfig-004-20260914    clang-22
i386                  randconfig-005-20260913    gcc-14
i386                  randconfig-005-20260914    clang-22
i386                  randconfig-006-20260913    gcc-14
i386                  randconfig-006-20260914    clang-22
i386                  randconfig-007-20260913    clang-22
i386                  randconfig-007-20260914    clang-22
i386                  randconfig-011-20260913    clang-22
i386                  randconfig-011-20260914    clang-22
i386                  randconfig-012-20260913    clang-22
i386                  randconfig-012-20260914    clang-22
i386                  randconfig-013-20260913    gcc-14
i386                  randconfig-013-20260914    clang-22
i386                  randconfig-014-20260913    gcc-14
i386                  randconfig-014-20260914    clang-22
i386                  randconfig-015-20260913    gcc-12
i386                  randconfig-015-20260914    clang-22
i386                  randconfig-016-20260913    gcc-14
i386                  randconfig-016-20260914    clang-22
i386                  randconfig-017-20260913    clang-22
i386                  randconfig-017-20260914    clang-22
i386                  randconfig-061-20260914    gcc-12 sparse
i386                  randconfig-061-20260914    gcc-14 sparse
i386                  randconfig-062-20260914    gcc-14 sparse
i386                  randconfig-063-20260914    gcc-14 sparse
i386                 randconfig-r132-20260914    gcc-13.4.0 sparse
i386                 randconfig-r134-20260914    gcc-14 sparse
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260913    clang-24
loongarch             randconfig-001-20260914    gcc-13.4.0
loongarch             randconfig-002-20260913    gcc-16.1.0
loongarch             randconfig-002-20260914    gcc-13.4.0
m68k                             allmodconfig    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-24
m68k                                defconfig    gcc-16.1.0
m68k                       m5275evb_defconfig    gcc-16.1.0
m68k                        mvme16x_defconfig    gcc-14
m68k                 randconfig-r111-20260914    gcc-12.5.0 sparse
m68k                 randconfig-r113-20260914    gcc-12.5.0 sparse
microblaze                        allnoconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
microblaze           randconfig-r123-20260914    gcc-12.5.0 sparse
mips                             allmodconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-24
mips                           ci20_defconfig    clang-24
mips                  decstation_64_defconfig    gcc-16.1.0
mips                 decstation_r4k_defconfig    gcc-16.1.0
mips                           ip32_defconfig    gcc-14
mips                      maltasmvp_defconfig    gcc-16.1.0
mips                 randconfig-r134-20260914    gcc-13.4.0 sparse
nios2                            allmodconfig    gcc-11.5.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-24
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-24
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260913    gcc-10.5.0
nios2                 randconfig-001-20260914    gcc-13.4.0
nios2                 randconfig-002-20260913    gcc-11.5.0
nios2                 randconfig-002-20260914    gcc-13.4.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r112-20260914    gcc-12.5.0 sparse
parisc                           allmodconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260913    gcc-8.5.0
parisc                randconfig-001-20260914    gcc-8.5.0
parisc                randconfig-001-20260915    gcc-8.5.0
parisc                randconfig-002-20260913    gcc-9.5.0
parisc                randconfig-002-20260914    gcc-8.5.0
parisc                randconfig-002-20260915    gcc-8.5.0
parisc               randconfig-r133-20260914    gcc-13.4.0 sparse
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                      arches_defconfig    gcc-16.1.0
powerpc                          g5_defconfig    gcc-16.1.0
powerpc                    ge_imp3a_defconfig    gcc-14
powerpc                         ps3_defconfig    gcc-16.1.0
powerpc               randconfig-001-20260913    clang-24
powerpc               randconfig-001-20260914    gcc-8.5.0
powerpc               randconfig-001-20260915    gcc-8.5.0
powerpc               randconfig-002-20260913    clang-24
powerpc               randconfig-002-20260914    gcc-8.5.0
powerpc               randconfig-002-20260915    gcc-8.5.0
powerpc64             randconfig-001-20260913    gcc-8.5.0
powerpc64             randconfig-001-20260914    gcc-8.5.0
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260913    clang-17
powerpc64             randconfig-002-20260914    gcc-8.5.0
powerpc64             randconfig-002-20260915    gcc-8.5.0
riscv                            alldefconfig    gcc-16.1.0
riscv                            allmodconfig    clang-24
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260913    gcc-14.3.0
riscv                 randconfig-001-20260914    gcc-13.4.0
riscv                 randconfig-002-20260913    gcc-12.5.0
riscv                 randconfig-002-20260914    gcc-13.4.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                              allnoconfig    clang-24
s390                             allyesconfig    gcc-16.1.0
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260913    clang-20
s390                  randconfig-001-20260914    gcc-13.4.0
s390                  randconfig-002-20260913    clang-24
s390                  randconfig-002-20260914    gcc-13.4.0
sh                               allmodconfig    gcc-16.1.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                 kfr2r09-romimage_defconfig    gcc-16.1.0
sh                    randconfig-001-20260913    gcc-16.1.0
sh                    randconfig-001-20260914    gcc-13.4.0
sh                    randconfig-002-20260913    gcc-14.3.0
sh                    randconfig-002-20260914    gcc-13.4.0
sh                           se7705_defconfig    gcc-14
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260913    gcc-8.5.0
sparc                 randconfig-001-20260914    gcc-16.1.0
sparc                 randconfig-002-20260913    gcc-15.2.0
sparc                 randconfig-002-20260914    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260913    clang-21
sparc64               randconfig-001-20260914    gcc-16.1.0
sparc64               randconfig-002-20260913    clang-20
sparc64               randconfig-002-20260914    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260913    clang-24
um                    randconfig-001-20260914    gcc-16.1.0
um                    randconfig-002-20260913    clang-24
um                    randconfig-002-20260914    gcc-16.1.0
um                   randconfig-r133-20260914    gcc-14 sparse
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           alldefconfig    gcc-16.1.0
x86_64                           allmodconfig    clang-22
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260913    gcc-14
x86_64      buildonly-randconfig-001-20260914    gcc-14
x86_64      buildonly-randconfig-002-20260913    gcc-14
x86_64      buildonly-randconfig-002-20260914    gcc-14
x86_64      buildonly-randconfig-003-20260913    gcc-14
x86_64      buildonly-randconfig-003-20260914    gcc-14
x86_64      buildonly-randconfig-004-20260913    clang-22
x86_64      buildonly-randconfig-004-20260914    gcc-14
x86_64      buildonly-randconfig-005-20260913    clang-22
x86_64      buildonly-randconfig-005-20260914    gcc-14
x86_64      buildonly-randconfig-006-20260913    gcc-14
x86_64      buildonly-randconfig-006-20260914    gcc-14
x86_64                              defconfig    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260913    clang-22
x86_64                randconfig-001-20260914    gcc-14
x86_64                randconfig-002-20260913    gcc-14
x86_64                randconfig-002-20260914    gcc-14
x86_64                randconfig-003-20260913    gcc-14
x86_64                randconfig-004-20260913    gcc-14
x86_64                randconfig-004-20260914    gcc-14
x86_64                randconfig-005-20260913    gcc-14
x86_64                randconfig-006-20260913    clang-22
x86_64                randconfig-011-20260913    gcc-14
x86_64                randconfig-011-20260914    clang-22
x86_64                randconfig-012-20260913    gcc-14
x86_64                randconfig-012-20260914    clang-22
x86_64                randconfig-013-20260913    clang-22
x86_64                randconfig-013-20260914    clang-22
x86_64                randconfig-014-20260913    clang-22
x86_64                randconfig-014-20260914    clang-22
x86_64                randconfig-015-20260913    clang-22
x86_64                randconfig-015-20260914    clang-22
x86_64                randconfig-016-20260913    clang-22
x86_64                randconfig-016-20260914    clang-22
x86_64                randconfig-071-20260913    clang-22
x86_64                randconfig-072-20260913    clang-22
x86_64                randconfig-073-20260913    gcc-14
x86_64                randconfig-074-20260913    gcc-14
x86_64                randconfig-075-20260913    clang-22
x86_64                randconfig-076-20260913    gcc-13
x86_64                randconfig-121-20260914    clang-22 sparse
x86_64                randconfig-121-20260914    gcc-14 sparse
x86_64                randconfig-122-20260914    gcc-14 sparse
x86_64                randconfig-123-20260914    gcc-14 sparse
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260913    gcc-13.4.0
xtensa                randconfig-001-20260914    gcc-16.1.0
xtensa                randconfig-002-20260913    gcc-15.2.0
xtensa                randconfig-002-20260914    gcc-16.1.0
xtensa               randconfig-r131-20260914    gcc-14 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

