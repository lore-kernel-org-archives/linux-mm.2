Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0EECD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 14:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3716B016A; Fri,  8 May 2026 10:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984916B016B; Fri,  8 May 2026 10:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A286B016C; Fri,  8 May 2026 10:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769E86B016A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:48:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21B1D88033
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:48:15 +0000 (UTC)
X-FDA: 84744532950.25.C5E85C0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2586A000C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:48:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZACB4L1r;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778251693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3/ZnYpfipGA9U3DugtJ1RjVNgolvgVhVhZFQXE90UHM=;
	b=mTooXjJYr8g66CZRqo4hKmtPl0otUaDBXewlTupTdzbLBiU0u9alweOV1ydqKDDtEBbIVH
	zBPpeAMWzw57AYQZo2yvSpADP0OoOx/UoqamuEa8421yhSVdNPS/bGO7ZT/JyHXoOYJslX
	8FW05mTlRSBFvstF6tOdGx0e1DR4Wsk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZACB4L1r;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778251693; a=rsa-sha256;
	cv=none;
	b=IdDZewoyYzZJuTLFqXCdKuzqsEIcJCL/pqh7owqBLxqkJPYGyDEj/yGi1zJikPiB7qHXHL
	49MUOHV40DgWWHKfTpBIKWa5AMAmqOVr4IxHjinBY0JZk0eie5WA1ChIf5Ofnweh32wohK
	dEFoYElMAkVZNck8kxU5LUkpe99uT8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778251692; x=1809787692;
  h=date:from:to:cc:subject:message-id;
  bh=xvsq4CqWPWUSKU0LSjowARx9YXYro/oyt6Bu+ZsgeiM=;
  b=ZACB4L1rf78JcoLMOh9eYbCuQzgtxqr9zuKEIITZTQloElKy1dMkXtaf
   9amzQjsma/lGADBU4E4M6PavSHCn77kJMSXQlII1l8TuB0fDHqOl611fY
   +JDHTf5GnjRGnKQ4cwzxg5Kf6THQUmBwlPFhC50NkTZ/+muswXerkEAzy
   k+//00Umgd1szi98A1nrwx/3gZKP3vEian4JQwSnNky2VI247C3AGNLg6
   8u0YMOvmNU1B4xEgMp2sfzNaK52JQO1h6pfWT2IAceLdFV0vwNIjaO6xA
   JqN2gydmyK0ZTIOQvolMxCEbyOfjTjWUSRq1CjP4jBSqaCUrOaGf5tBhT
   Q==;
X-CSE-ConnectionGUID: S6dR4HfPRguZOYPZZcgaoA==
X-CSE-MsgGUID: FHqOt7GKSB666h5SjEDR1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="89809976"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="89809976"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 07:48:11 -0700
X-CSE-ConnectionGUID: 3vRLHHLLQMWcLwOG0Gzjfg==
X-CSE-MsgGUID: lVAyJOMrRxOgWKvAUT8vFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="237027082"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 08 May 2026 07:48:09 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLMUo-000000000DB-0FqK;
	Fri, 08 May 2026 14:48:06 +0000
Date: Fri, 08 May 2026 22:47:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 830829a264f444b59a708d94915242e961bccc97
Message-ID: <202605082218.34ZE5Ouq-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: F2586A000C
X-Rspamd-Server: rspam06
X-Stat-Signature: ww7a9g8hnyi5q1yfwtwrth7zpfqbam9g
X-HE-Tag: 1778251691-269211
X-HE-Meta: U2FsdGVkX19suYdXIRRs8LSvVcR34U1aVCE0ow2FHWbpnXC8pLatB1uo9HaMaXr2ZhBbz5Up65J9Mrs/v1q4Q6RnHXFvCu43u9k9Lx71HnZBjKmc4P+57v1SMSF489mYQzZPEnpxcsKeNwUfQsgq5kyUJaWQjveZoJgI4cAx9Ins+itoLXtwcsMX03ZcJlvXl1uNsi2aWqyfneQyyZfOIHL6uJHCcD+RO5leMN5+l4dFM0hidEjh7Q3Qb4VVO9+JqGYry6uT24yuQ2aYQozSOeseGI0i++rAD/mwkXW9t4VmdLISg6EWCGAoL5TbRkjK1Q6V8HiQQ6qkP2hq8Dt+PTGAshhRM/HZAtzFBylfVc7MXW9XJ3TPqRXGXGOPh00lYX0LmsjmaAlu0+txK1Ke5W195v66h7Px7/4MDsxjPj3hDNpjiJQEQ6Zck3En6LOFHRCBMRA5BjL/oaFppUthpHmbiXwoISl5feXo7J4Au1c9ctEb848chXO1xPFuYxT6tTiKWL6YeDzspwmDaIwTSoXylRuxRUSBtuhwndQhoNs6Bs1tJDKIzhjdhI2p8j8cxQ+VzdM6Ln3hDQPDg6nwMg11KyEZqkRwVr1CTixFmfyfWmNQVGTRA9zNGPgz7ILRPSMP3OwbaqbOVoP5QnrElAbAcNQx5ilhVvzdDs2DvOHsDx16Xh/s02Qrv/4uIVgjyC3sYMa0n24pgC9c7nAWINIzlRqYk9/0/LAleDvkJgVCeWsDczM9TkONsCYZ3J5IsyarLVb5onT0MUqozt5tOoZeVYu1GLrWnHqYjYfX1Ql8IqNHkHKPvqXitL/I2ITRo8tjEOcEArhffGyOUPxnRXHdLe8QkIDXBjdAfOklWwX5S1C4C9uxz5PFsizA6uVwYDz4QEoe+8MGn32QDHWXU9SJZDIZQNThJxk88yyS9GcWxKrg2/A4q5NwdhvsyqtgNsWcCjs33JfoMrNjtD2
 u05aiNNV
 5XtYT9ejgQTVukC/e7E4192y+vuP1tEoxpLdUHMGdrQmQ6j957LKpJfCM8HjLVM7cI0OfBvZfuQ1Xnp/AyDo3ukO+Vu0WyyIbBGXQP/DtTNDFUB/0HpBx41PNqlf6XJ6ylm0hgGDNOcJTFdSifroobWiThwYtP/9pdiSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 830829a264f444b59a708d94915242e961bccc97  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

elapsed time: 800m

configs tested: 267
configs skipped: 14

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     haps_hs_smp_defconfig    gcc-15.2.0
arc                 nsimosci_hs_smp_defconfig    gcc-15.2.0
arc                            randconfig-001    gcc-8.5.0
arc                   randconfig-001-20260508    gcc-12.5.0
arc                   randconfig-001-20260508    gcc-8.5.0
arc                            randconfig-002    gcc-8.5.0
arc                   randconfig-002-20260508    gcc-12.5.0
arc                   randconfig-002-20260508    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    gcc-15.2.0
arm                        neponset_defconfig    gcc-15.2.0
arm                            randconfig-001    gcc-8.5.0
arm                   randconfig-001-20260508    gcc-12.5.0
arm                   randconfig-001-20260508    gcc-8.5.0
arm                            randconfig-002    gcc-8.5.0
arm                   randconfig-002-20260508    gcc-12.5.0
arm                   randconfig-002-20260508    gcc-8.5.0
arm                            randconfig-003    gcc-8.5.0
arm                   randconfig-003-20260508    gcc-12.5.0
arm                   randconfig-003-20260508    gcc-8.5.0
arm                            randconfig-004    gcc-8.5.0
arm                   randconfig-004-20260508    gcc-12.5.0
arm                   randconfig-004-20260508    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260508    gcc-14.3.0
arm64                 randconfig-002-20260508    gcc-14.3.0
arm64                 randconfig-003-20260508    gcc-14.3.0
arm64                 randconfig-004-20260508    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260508    gcc-14.3.0
csky                  randconfig-002-20260508    gcc-14.3.0
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260508    clang-23
hexagon               randconfig-002-20260508    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260508    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260508    clang-20
i386        buildonly-randconfig-002-20260508    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260508    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260508    clang-20
i386        buildonly-randconfig-004-20260508    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260508    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260508    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260508    gcc-14
i386                  randconfig-002-20260508    gcc-14
i386                  randconfig-003-20260508    gcc-14
i386                  randconfig-004-20260508    gcc-14
i386                  randconfig-005-20260508    gcc-14
i386                  randconfig-006-20260508    gcc-14
i386                  randconfig-007-20260508    gcc-14
i386                  randconfig-011-20260508    clang-20
i386                  randconfig-011-20260508    gcc-13
i386                  randconfig-012-20260508    gcc-13
i386                  randconfig-013-20260508    clang-20
i386                  randconfig-013-20260508    gcc-13
i386                  randconfig-014-20260508    gcc-13
i386                  randconfig-014-20260508    gcc-14
i386                  randconfig-015-20260508    clang-20
i386                  randconfig-015-20260508    gcc-13
i386                  randconfig-016-20260508    clang-20
i386                  randconfig-016-20260508    gcc-13
i386                  randconfig-017-20260508    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260508    clang-23
loongarch             randconfig-002-20260508    clang-23
loongarch             randconfig-002-20260508    gcc-12.5.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                      loongson3_defconfig    gcc-15.2.0
mips                        omega2p_defconfig    clang-23
mips                         rt305x_defconfig    clang-23
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                 randconfig-001-20260508    clang-23
nios2                 randconfig-001-20260508    gcc-11.5.0
nios2                 randconfig-002-20260508    clang-23
nios2                 randconfig-002-20260508    gcc-11.5.0
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
parisc                randconfig-001-20260508    gcc-9.5.0
parisc                randconfig-002-20260508    gcc-9.5.0
parisc64                            defconfig    clang-19
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                       holly_defconfig    clang-23
powerpc               randconfig-001-20260508    gcc-9.5.0
powerpc               randconfig-002-20260508    gcc-9.5.0
powerpc                     tqm8555_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260508    gcc-9.5.0
powerpc64             randconfig-002-20260508    gcc-9.5.0
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                          randconfig-001    gcc-8.5.0
riscv                 randconfig-001-20260508    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260508    clang-23
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                           randconfig-001    gcc-11.5.0
s390                  randconfig-001-20260508    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260508    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                          polaris_defconfig    gcc-15.2.0
sh                             randconfig-001    gcc-15.2.0
sh                    randconfig-001-20260508    clang-23
sh                    randconfig-001-20260508    gcc-15.2.0
sh                             randconfig-002    gcc-14.3.0
sh                    randconfig-002-20260508    clang-23
sh                    randconfig-002-20260508    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260508    gcc-12
sparc                 randconfig-001-20260508    gcc-12.5.0
sparc                 randconfig-002-20260508    gcc-12
sparc                 randconfig-002-20260508    gcc-8.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260508    gcc-12
sparc64               randconfig-001-20260508    gcc-8.5.0
sparc64               randconfig-002-20260508    clang-23
sparc64               randconfig-002-20260508    gcc-12
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260508    gcc-12
um                    randconfig-002-20260508    clang-23
um                    randconfig-002-20260508    gcc-12
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260508    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260508    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260508    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260508    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260508    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260508    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260508    clang-20
x86_64                randconfig-001-20260508    gcc-14
x86_64                randconfig-002-20260508    clang-20
x86_64                randconfig-003-20260508    clang-20
x86_64                randconfig-004-20260508    clang-20
x86_64                randconfig-004-20260508    gcc-14
x86_64                randconfig-005-20260508    clang-20
x86_64                randconfig-006-20260508    clang-20
x86_64                randconfig-006-20260508    gcc-14
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260508    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260508    clang-20
x86_64                randconfig-012-20260508    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260508    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260508    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260508    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260508    gcc-14
x86_64                randconfig-071-20260508    gcc-14
x86_64                randconfig-072-20260508    gcc-14
x86_64                randconfig-073-20260508    gcc-14
x86_64                randconfig-074-20260508    gcc-14
x86_64                randconfig-075-20260508    gcc-14
x86_64                randconfig-076-20260508    gcc-14
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
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260508    gcc-12
xtensa                randconfig-001-20260508    gcc-14.3.0
xtensa                randconfig-002-20260508    gcc-12
xtensa                randconfig-002-20260508    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

