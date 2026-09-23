Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2496C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B303C6B0093; Wed, 23 Sep 2026 07:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06276B0095; Wed, 23 Sep 2026 07:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5386B0096; Wed, 23 Sep 2026 07:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73ADE6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:02:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D4DC80771
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:02:16 +0000 (UTC)
X-FDA: 85244737872.19.4C51A61
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id 88A1D40013
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:02:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R8A8MO9i;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790161334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/KkRU1NLTm0NG5OlliX+UoXz27Uz92m3LsGTxhMxz4g=;
	b=edE8/HLxxZC08+/3hIFanYl8N+3aZeBbCuxHF2mCDZdjJScySkjBLRijFh4uzYZBjSetAf
	2Vx08RPOE62PLUtYFoQWbq8b3ng3SpisUjylvY4Sav0vV340fHH2+xfqBvkh/6hpTF29/4
	BIIdjyugRaihZN89TYBIrntW57ixrVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790161334;
	b=RB2oaPjcjTpccdw2Vq/DRi0bQKkiE3XXFOV5SHhmQsnjBl5e64Iii9kisIK9zPuXKS4tBU
	KFvk8JCFiKSeL8aORqsB8awES6V4mLZCa7qkhw1WLwC/AZRRV53YaiepoP+X+uesazA6h8
	HurkRJ73DiT8NoA3POieBmH8/DPur/M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R8A8MO9i;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790161335; x=1821697335;
  h=date:from:to:cc:subject:message-id;
  bh=nqTde3JsSd69V0UQEeIidhFd/55FQ+H6onaGQNDpxhM=;
  b=R8A8MO9ix6OKxLZONU8c+nXbd8diC9TNzrUE/hGiqKtv6J1UEiWUiBjA
   UAspenVqQhKqMUl/ADG78G99IL5wRrZPPYq5qO0dza0p7l7ZSbjxYX+s/
   w7OuLWxwWJH7B/d59OruvIbHaBJaqa1KPxsdVnlBACvK54wx6DQDIyJHY
   vm/AGhckUZwfurMqkfBH30WOhHILkZHcc9KYOVk57WiCwLAd6W5LGnSDM
   S6N9kabQ8kizW03PbVvveZM9wU50SNxzX9VHy0E7/sIxjcIV0pQSydq58
   6bnKlLtzhJTcbo7Ryj49R8/gfbD2NF76+xHiUVRdzV6yi4NrPYlt61PXu
   w==;
X-CSE-ConnectionGUID: aCh3HUrgSt+uGV9A4esB/w==
X-CSE-MsgGUID: FxakAslJRLG79RYLwQf7hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="108340644"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="108340644"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 04:02:01 -0700
X-CSE-ConnectionGUID: mxq/bKpNSK2CrWu0YvPCHQ==
X-CSE-MsgGUID: jPqDpC1oRKGjUszPWX8nTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="278289468"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 23 Sep 2026 04:01:58 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x9Kjb-00000000Gy6-2aPg;
	Wed, 23 Sep 2026 11:01:55 +0000
Date: Wed, 23 Sep 2026 19:01:06 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 8d29b5365d528da545c1fe0768a55babadee95d0
Message-ID: <202609231903.l9QgUo5v-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88A1D40013
X-Stat-Signature: js89jx6jtkzirkxzj78n9wdo578knqti
X-Rspam-User: 
X-HE-Tag: 1790161333-90050
X-HE-Meta: U2FsdGVkX19obZukMUjBZS3fCMMSNOC1eFFzA1/CsVVcrvVTk1Pw+ol6Ve0yHWsgGF5HDCJmmaEb8bKvslBBjf1zNyyb2E9l5Lck8x46rfs58PHkBDJSuK7j8C2Zv5pnYKYlRa0vv4rk/Ww7x8vqvqLO4BE6cOJu/DMESJaCg1Xe0023L4eFt6thAYYOy5k3yz9hDi6O/56i/dfve53EjsO6AxFy8OJEqxxDtOec5a0C3Tqac5yLIy9vzyY42aVCwGQgqK5npHXF6OrDOtwv2HxM45s2npDtr9H7bZNSK5nyMvDdgsDI3ie83GuTQj43BES8+LgecZvhhfx5yd9O/sYJbIM4JWsjwC7QyR3c2xDXJaO4uAlMru/YCRFhpSscrulYTEudnStZ08j46W3QdXU3+Z2jxAewAupQXRVViJPMSkB47fASTma2hO9j7Vd8W8YsjHV35g8KHdoWdVJf6cP1/va0jPY15Tzpdx73ps0Xu330W2QcqL49YTDufdU+RRcj/oGSB7XXJz3pDbUyZfhmC4xKft87aaFD6XM0aTAGlLtgJLkEsn+8Axm1WJX70mE9VQLgctoOP+yrrkYXlARcDXyD37S41rTqCuiSUnOHOgPl/jQ4tPG/jtAjcBuInZIehcgvvJiBgq+brZGT4rQUSsfWN9BKxjMwSj4ZI2CZJycbi3oH+llLAz7xL9Q85j2ZBR2a8CPj8Kaxkzv6L+O5d/EG/IJy5oCzwSFEjZAFFmFHaLwBrs76Mu/E0a7FQjMcIEfQZEtx4BybGZtKAG18k/YOATSUXEdZELj9JyT81h9V4iek2b28t9fPXEWyB8P844Ub5cHrF1fztv70MkCUl9tg17TSdDe5/YVniWJfzKoEQN6lkjT7b0LV4VbXJiTwy0bHOCsg6CIfMRaCuj3rr4EewtMBRrIswJPU3PL4hh4ubvaujsON8XoLa0zpBUq/W7jY/65wrz8VzKR
 zj413LcQ
 MSXDegWDyFUoNvrbsF+pPK/JWW7vwGJ8NVho17/+2mJFbjVytvmlECXpNelJww0EEWTktoCywwxyltaR32TE4vNyrnKTQGXUOhQUYQNJMkzpw0ujuw3drnInZDc3zuzrNqK/lzAVYcIIPT6OA1T5QUnX2Wbxz62uXgVhc/SzQFeN41j/E/F0cDzqLaRzdjCsHLWedrPEWGKuLiqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 8d29b5365d528da545c1fe0768a55babadee95d0  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1767m

configs tested: 170
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260923    gcc-8.5.0
arc                   randconfig-1001-20260923    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                        aspeed_g5_defconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20260923    gcc-8.5.0
arm                   randconfig-1001-20260923    clang-24
arm                   randconfig-1002-20260923    gcc-13.4.0
arm                   randconfig-1003-20260923    gcc-15.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260923    clang-24
arm64                 randconfig-1001-20260923    clang-17
arm64                 randconfig-1002-20260923    clang-24
arm64                 randconfig-1003-20260923    clang-18
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260923    gcc-11.5.0
csky                  randconfig-1001-20260923    gcc-9.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260923    clang-24
hexagon               randconfig-1001-20260923    clang-20
hexagon              randconfig-r1305-20260923    clang-17   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260923    clang-22
i386        buildonly-randconfig-1001-20260923    gcc-14
i386        buildonly-randconfig-1002-20260923    gcc-13
i386        buildonly-randconfig-1003-20260923    gcc-14
i386        buildonly-randconfig-1004-20260923    clang-22
i386        buildonly-randconfig-1005-20260923    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260923    clang-22
i386                  randconfig-1001-20260923    clang-22
i386                  randconfig-1002-20260923    clang-22
i386                  randconfig-1003-20260923    clang-22
i386                  randconfig-1004-20260923    gcc-14
i386                  randconfig-1005-20260923    clang-22
i386                  randconfig-1006-20260923    clang-22
i386                  randconfig-1007-20260923    clang-22
i386                  randconfig-1008-20260923    clang-22
i386                  randconfig-1009-20260923    gcc-14
i386                  randconfig-1010-20260923    clang-22
i386                  randconfig-1011-20260923    gcc-14
i386                  randconfig-1012-20260923    gcc-14
i386                  randconfig-1013-20260923    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260923    clang-24
loongarch             randconfig-1001-20260923    clang-24
loongarch            randconfig-r1308-20260923    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r1307-20260923    gcc-15.2.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip28_defconfig    gcc-16.1.0
mips                        lemote2f_defconfig    gcc-16.1.0
mips                       maltaaprp_defconfig    clang-17
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260923    gcc-8.5.0
nios2                 randconfig-1001-20260923    gcc-9.5.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r1309-20260923    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260923    gcc-9.5.0
parisc                randconfig-1001-20260923    gcc-15.2.0
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20260923    clang-17
powerpc               randconfig-1001-20260923    clang-24
powerpc                      tqm8555_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260923    clang-22
powerpc64             randconfig-1001-20260923    clang-24
powerpc64            randconfig-r1303-20260923    clang-17   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                     nommu_virt_defconfig    clang-24
riscv                 randconfig-1000-20260923    clang-24
riscv                 randconfig-1001-20260923    gcc-16.1.0
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260923    clang-24
s390                  randconfig-1001-20260923    gcc-16.1.0
s390                 randconfig-r1300-20260923    clang-20   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260923    gcc-11.5.0
sh                    randconfig-1001-20260923    gcc-9.5.0
sh                            se7619_defconfig    gcc-16.1.0
sh                         sh7757lcr_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260923    gcc-15.2.0
sparc                 randconfig-1001-20260923    gcc-13.4.0
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260923    gcc-14.3.0
sparc64               randconfig-1001-20260923    clang-24
sparc64              randconfig-r1306-20260923    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260923    clang-24
um                    randconfig-1001-20260923    gcc-12
um                   randconfig-r1304-20260923    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260923    gcc-14
x86_64      buildonly-randconfig-1001-20260923    clang-22
x86_64      buildonly-randconfig-1002-20260923    gcc-14
x86_64      buildonly-randconfig-1003-20260923    gcc-14
x86_64      buildonly-randconfig-1004-20260923    gcc-14
x86_64      buildonly-randconfig-1005-20260923    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260923    clang-22
x86_64                randconfig-1001-20260923    gcc-14
x86_64                randconfig-1002-20260923    gcc-13
x86_64                randconfig-1003-20260923    clang-22
x86_64                randconfig-1004-20260923    gcc-14
x86_64                randconfig-1005-20260923    clang-22
x86_64                randconfig-1006-20260923    clang-22
x86_64                randconfig-1007-20260923    gcc-13
x86_64                randconfig-1008-20260923    gcc-14
x86_64                randconfig-1009-20260923    gcc-13
x86_64                randconfig-1010-20260923    clang-22
x86_64                randconfig-1011-20260923    gcc-14
x86_64                randconfig-1012-20260923    gcc-14
x86_64                randconfig-1013-20260923    gcc-14
x86_64                randconfig-1014-20260923    gcc-14
x86_64                randconfig-1015-20260923    gcc-14
x86_64                randconfig-1016-20260923    gcc-14
x86_64                randconfig-1017-20260923    clang-22
x86_64               randconfig-r1301-20260923    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                randconfig-1000-20260923    gcc-9.5.0
xtensa                randconfig-1001-20260923    gcc-11.5.0
xtensa               randconfig-r1302-20260923    gcc-14.3.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

