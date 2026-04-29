Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8092CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331F96B0005; Wed, 29 Apr 2026 13:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E31A6B0088; Wed, 29 Apr 2026 13:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9726B008A; Wed, 29 Apr 2026 13:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECDA6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:55:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C4EB8B583
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:55:20 +0000 (UTC)
X-FDA: 84712345200.02.9C05B74
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id C52F5140004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:55:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dgl1uRIW;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777485318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Tkd2r+fplr6j5wNunBmLVKg4Yy8PVrvJL3EK3/WTm8s=;
	b=DZulAsC9TuqNDK4BhRTdXAHtueCjADk8v6aPzxrlaLM0Gt7lA61Dy17Z+krUQUMXarGxZ3
	D3WbDsCC24GfRRU2kODeG7CpFW7YCRuz00jLsLcCUzrR+uY1cQV7UQ56XkA8GHDhvsZm7m
	Gvk+tHBV04FbdIU7h2WXlMOjqnCqUPE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dgl1uRIW;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777485318; a=rsa-sha256;
	cv=none;
	b=CkvcioFFCn++g9kB+qWmfgQk6/4gb5rEAYBY30TsHrPDUa47OwRNy980xqps7/C1W/miYt
	Vy8My6qcs7cXmaOsdWernsNENbNIPafsGNk+R8wJVCLJQ7KI86BnZ36R6dD50dZlEGejEK
	vvdBWpRHxl8ABUlowxhogO6OPYw1bAg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777485318; x=1809021318;
  h=date:from:to:cc:subject:message-id;
  bh=qES5wi9rHeFRKHA56944QIARsJl/dmyOMftYE0DrvjY=;
  b=Dgl1uRIWCEQpWeGe7JIXqCyRf4D3ydiDBMzwEGHxQKyiiq3Rl7InzvCF
   79fFuPOMsq36T47FdczJ41TrX0uBq8FCr/kyjbfi3M3FRKSNUDJ4qQKXX
   6F1fld6T9h4oaDMa5YwcsAA71v7VzqjG6+DFN4cf5AnPTvrC05uQZmYoF
   mXUXnr4DqNTMgIrmeC0MjPUTgCmbIpPTILk/X6L9WNK/h1PL52X9/0m4Q
   d6gbvz9GFQG3pq4KVppm4IlAQbbikn9pVFW0f4xnJQNK941aUsAKs/eOC
   mk61JZ29JK/KahMaMPFG6FmkdbZBtcxJy8bXQxD6mNW7vTSlpRPNN0sX8
   Q==;
X-CSE-ConnectionGUID: rtUZZif5Rcq6bAygsuy99A==
X-CSE-MsgGUID: 24DwWY+uTMKrItdtYIFUmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89884370"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89884370"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 10:55:16 -0700
X-CSE-ConnectionGUID: 3iiTamUzSy2ltJXGS6U1YA==
X-CSE-MsgGUID: IwKwGggbR9qySSnG1HQVkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="236106649"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 29 Apr 2026 10:55:14 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wI97w-00000000BKS-0GTU;
	Wed, 29 Apr 2026 17:55:12 +0000
Date: Thu, 30 Apr 2026 01:54:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 52dc268726a771d68839fb1e06e88b5157062a3f
Message-ID: <202604300126.K1nrQFEC-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C52F5140004
X-Stat-Signature: etcahx5ya5ftk7so5z1qwgkeqfuywoq8
X-HE-Tag: 1777485317-809224
X-HE-Meta: U2FsdGVkX1+Z+XRJEq7PucMMB8aj3ywzPaoj603NcQRu7RQ7HbetRm9JcV+DvEs0r48BmsWdJlbtClNTLhXpU9KBwMj6sQAB6cB4iM6EbZuk3QK2M5Jg1cPtsMfo11EAssONj8m52PdvhC9dxMaxVwuGMdpx3kg8UGeH9YdQC80kaMIEDSwErUB0udex4JmUrP+Otrnukp5su/E7V9Xk+duGAEWDJjrqUaPBxGw1/EAglTpmbV8t5/wxanVSqcrdN9EkSK/U4QEH575i5C5NJk9N+olDTVehzEc+Iixwb0gtsfNMuImWINLaXxDlqr1/WnWWXzDVarDdCFA6zsc219mrh/gUV9JpNNS4HP6WchX4aiSX7639l1DBZ/lXe5bzjFbKatuU2BSVumXUXzOSdNk6vpeHT9Lpomoi5yQJxraG8yH6UUtevjjxKXOakphc0+hS6cj4YFv6rnn2yyYckUPYDa7mZ4PJMyPLtX/18qfeHFDe62fa4XA04lgKssk97SkkJLn6QZ6OEX+unUrVwGNPYYlAVHX6KWo2z/DlFlS6bH+L/sYbbK4lujflHQXBYkZ2f7+wylQPYRhbKkkaW6QSPC0usmjGN5ZZ+wMtr4snCYlE4//aebYmZI8xxJ+KdbgBUUCINpYvbB70nvNDKjk1EQqTsIFDujkp8qqdKw4rfx+bAkVykJRDZx7xaYUViumme/fqX2uL9nAx+wxcqAcpBpKl6ta+z0S5wY1OdqROqJR0xkpYLQTiqeSAnhA7cHffEGivX99Lw/bQJlm2Ju/V5T9H7RxyPPqi3+GfZDqXcxyvfCabOmVH2furUgs7rHK5YJdDIiwAqGv11hFA5Z22kzvKaKvFwTf/PBAapb/vVvTnlX0rH0U6WlJRLgNRRjD/R4i2zOTrVK3NSpFKN7gwiOprB21uJkOudTeN38p05cJrxV1ZcpPFcjy7flr9WT00QfonujRkQS2PA8f
 MugVOwhF
 aKWZQhcXCasr0hFhJA8Eaeo2vJi4/+SG/neQaJXp3EIjtqOk8C0dVWoHNSbmR+roYNGyi3cbQtdD3P1TYZK4l5Jj/iGvLOR4lv7EwHxo39rYQnWwENAXiN+v1n2sAJO4F2TvQ9+lXI4ybTnNpNyeDqRv5e3L/9W4VXjaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 52dc268726a771d68839fb1e06e88b5157062a3f  flush dirty folio so that drop_caches can work

elapsed time: 1162m

configs tested: 93
configs skipped: 2

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
arc                   randconfig-001-20260430    gcc-8.5.0
arc                   randconfig-002-20260430    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                  randconfig-011-20260430    clang-20
i386                  randconfig-012-20260430    gcc-14
i386                  randconfig-013-20260430    clang-20
i386                  randconfig-014-20260430    gcc-14
i386                  randconfig-015-20260430    gcc-14
i386                  randconfig-016-20260430    gcc-14
i386                  randconfig-017-20260430    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch             randconfig-001-20260430    gcc-14.3.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260430    gcc-12.5.0
parisc                randconfig-002-20260430    gcc-8.5.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      pasemi_defconfig    clang-23
powerpc               randconfig-001-20260430    gcc-10.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-002-20260430    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260430    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260430    clang-20
x86_64      buildonly-randconfig-002-20260430    clang-20
x86_64      buildonly-randconfig-003-20260430    clang-20
x86_64      buildonly-randconfig-004-20260430    clang-20
x86_64      buildonly-randconfig-005-20260430    gcc-14
x86_64      buildonly-randconfig-006-20260430    gcc-14
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

