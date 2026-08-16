Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02228C5DF67
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 00:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E29E6B038F; Sat, 15 Aug 2026 20:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793946B0390; Sat, 15 Aug 2026 20:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683696B0391; Sat, 15 Aug 2026 20:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4040A6B038F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 20:05:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B45C3A04D1
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 00:05:31 +0000 (UTC)
X-FDA: 85105188462.23.15B7ECC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31E9B120003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 00:05:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CNJ3Eb7o;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786838730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jYR/ejTsnTXTeX+NjHiy2sQRXo353/BXZCQRfkZ1HsQ=;
	b=5dayTYIkyBiU/DlM4z4mmhGGM72/8uzqyZOo8PWTwMznpC6Us3YjdKy+xuXoYwgLYqZwIL
	qHo+TXQonIejrdeST03UEKE7lxMYPokq4ulCgW5stxOrSFlKUdXkIuOrT7p8W7xLfe/6VG
	qsacdXbwLW9Xx+T70mA3haalpARNsCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786838730;
	b=l+9rmqWlxEwyDXLA+yZ4++VbIvhOdkhfut7IZcfBYtHzLr6GrDUSErn7QSOBFoIZ+afUpB
	ZBXpnjAUM1qLWq9J2quhwWV32hRE5e5IrNnXA02kRgwXoWs2Dl2INJbON3Co1VCK12XPQT
	5rS37BHaHZpmnUEjehekZe2A6hOniW8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CNJ3Eb7o;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786838729; x=1818374729;
  h=date:from:to:cc:subject:message-id;
  bh=VaOQwjUn/5W+Vxjff4nmO2RENY8dlbFq5sFTlodLZMY=;
  b=CNJ3Eb7o7uZyziXveoWbMVTjPt2GAzG8YYeCHoswR4U3jxIPSTsPBIDx
   8iTn8Y+f7N5sZk77WJlci7UQAJlsLSDiGUoRByKWCa7rqSFsZM8QZjC6u
   q9FKUSUUda0V0pYUdDeVq5KE5ejfZ9r/OkDJ3hP1Oc5Na7TxcGaTFVbGI
   9jWcq/l+XKBBDv6cbSzJbWpbldr6FlOaQ4bPFGbeQNt/TkWbG07s2lZqC
   saJcsX/sJPOwW/hOdlcxUL5qw+kbhReWxMaXtA3jERAeCc3iyl9sjoxKK
   v5GjIa1siMP0grcfrIMe64ifyUN9VUjhLUeBVAnBhJu5kO55zO1U/efpa
   w==;
X-CSE-ConnectionGUID: gZdqeadcROWeJoQCPm1ciA==
X-CSE-MsgGUID: EjfEHJQkSdOCKtHPkfxJog==
X-IronPort-AV: E=McAfee;i="6800,10657,11876"; a="87576795"
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="87576795"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2026 17:05:24 -0700
X-CSE-ConnectionGUID: 9rGtrACvRVu6jWmeacnoYQ==
X-CSE-MsgGUID: /4g+NdXbTxK1B4enuqfjWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="261284156"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 15 Aug 2026 17:05:23 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wvONM-00000000cYo-0uUj;
	Sun, 16 Aug 2026 00:05:20 +0000
Date: Sun, 16 Aug 2026 08:05:08 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 33f61b12d297562321533c048e034b1fb21c1cf3
Message-ID: <202608160855.VZWST6gY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: nbcwkz96qsitcpd71rgsq8y4ex6fmi6g
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31E9B120003
X-HE-Tag: 1786838728-738970
X-HE-Meta: U2FsdGVkX1/bSBuRFuHLmsUiCwFW90+9/V1FovVXSIziQN6kLoEzpbORFeupGdHeMZURmIFFO0OiujnQqkbtDmmPEXEmgQNGv64/fdmUnas7IMvH9eDnQzBKd/ypkdbCyc/vLqHZKzkx8zdw6s9hD/fCoD0Nzff00bDLEPpTamuloREDKkDhe2VHPW2wuSAeaL5uTDL9OpRmmPkqchBzfPR0uUdIa3KDnZtXrr/qbk1DLu+sSUbS6i8Eu9HpRTWrQ6Iu+RHU1BRH0Fa8YT86kbrJcu7diV6BC8uTz8koTR8g60HTLg7KLeTpMIDKAr/K6rtCEflog7Zk5yt2abq0ytEK0vaCANFsW8s37+V3UjucMUkmmno8o918XSlan+hmSY43kvpnIHJR5hBRGK2WZyOutH5zgAmYDgWbMzTFfnI1qRnHU5R9moLVhlgOsHsy4qVrmuGEzCRKpuuy3Lh0mpWpt3OKRbUnhp2l+qhIH7p/PUQJmuhqaNMzlolDbyVrsbJaO+pQg8fN8NzG1EFVfdHQhrR//044FjXoF6J8bLv91mXyxyafnufzKX6egmVEM1UjX3EAFaHKMFVfk171pFtmtRnJy3glU+u0OdrONaDYtDOifOmgV4t+f/FzhqaWCjtyZRwBwSlBsBN74TsFTOKiNkfc4dPJ4kTLfu1p3ANmcluaFB6RGR2miRKdt8TpxgyzCIOt8eecUsXENOvsweSFsFanI2HF6r2uGehv6zJlXe5ICDjWCP5wyfSPxgnNz04799HcJHiUChFba8pLKV/fadT+za1u9p0xgZUyGfE2CLQzeUsHLmz5d1p9VLqHjBj0g6JmTd2g1gOUILWwFiiRsn5awdCqL6VBMyJTySoEAUe2gzSeRln77UTj/4HBhPagwA8M6+KRmuSWEdee0ULsCna6g1Q0TytwFjsmELF67wbwN2+4HeWuz979YReheGCWvK5mrctlXIqZMcO
 XFlhV4DT
 Vwd1K3HMJABJso9JtqOYB9qduHnTkZcdzm3j/bcMifmnV3j/2onESTHC+pqCu/PiVRFVgmqgdbBusg6cqUyC657t4l1yCNIuttVlIZvjrvgLMenRe/T8guT9klj8wirBqSHgBqnmEk+P6OF7ehLpK4maxzrpxmrHSbpr4zkM+mOGhHrRhVEpKKlP4v5VVJ+LqgDtESH6Rkn5jg7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 33f61b12d297562321533c048e034b1fb21c1cf3  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 773m

configs tested: 99
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260815    gcc-11.5.0
arc                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-001-20260815    clang-21
arm                  randconfig-002-20260815    gcc-8.5.0
arm                  randconfig-003-20260815    clang-17
arm                  randconfig-004-20260815    gcc-8.5.0
arm64                randconfig-001-20260815    clang-24
arm64                randconfig-002-20260815    gcc-8.5.0
arm64                randconfig-003-20260815    clang-17
arm64                randconfig-004-20260815    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260815    gcc-13.4.0
csky                 randconfig-002-20260815    gcc-15.2.0
hexagon              randconfig-001-20260815    clang-24
hexagon              randconfig-002-20260815    clang-22
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260815    gcc-14
i386       buildonly-randconfig-002-20260815    gcc-14
i386       buildonly-randconfig-003-20260815    gcc-14
i386       buildonly-randconfig-004-20260815    gcc-14
i386       buildonly-randconfig-005-20260815    gcc-14
i386       buildonly-randconfig-006-20260815    clang-22
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260815    clang-22
i386                 randconfig-002-20260815    clang-22
i386                 randconfig-003-20260815    gcc-14
i386                 randconfig-004-20260815    clang-22
i386                 randconfig-005-20260815    gcc-14
i386                 randconfig-006-20260815    gcc-14
i386                 randconfig-007-20260815    gcc-14
i386                 randconfig-011-20260815    clang-22
i386                 randconfig-012-20260815    gcc-14
i386                 randconfig-013-20260815    clang-22
i386                 randconfig-014-20260815    clang-22
i386                 randconfig-015-20260815    clang-22
i386                 randconfig-016-20260815    gcc-14
i386                 randconfig-017-20260815    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260815    clang-18
loongarch            randconfig-002-20260815    clang-18
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260815    gcc-8.5.0
nios2                randconfig-002-20260815    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260815    gcc-8.5.0
parisc               randconfig-002-20260815    gcc-16.1.0
powerpc              randconfig-001-20260815    gcc-9.5.0
powerpc              randconfig-002-20260815    clang-17
powerpc64            randconfig-001-20260815    gcc-11.5.0
powerpc64            randconfig-002-20260815    gcc-8.5.0
riscv                randconfig-001-20260815    gcc-8.5.0
riscv                randconfig-002-20260815    gcc-8.5.0
s390                 randconfig-001-20260815    clang-24
s390                 randconfig-002-20260815    clang-21
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260815    gcc-16.1.0
sh                   randconfig-002-20260815    gcc-11.5.0
sparc                randconfig-001-20260815    gcc-8.5.0
sparc                randconfig-002-20260815    gcc-16.1.0
sparc64              randconfig-001-20260815    clang-20
sparc64              randconfig-002-20260815    gcc-8.5.0
um                   randconfig-001-20260815    clang-24
um                   randconfig-002-20260815    clang-24
x86_64     buildonly-randconfig-001-20260815    clang-22
x86_64     buildonly-randconfig-002-20260815    gcc-14
x86_64     buildonly-randconfig-003-20260815    gcc-14
x86_64     buildonly-randconfig-004-20260815    gcc-14
x86_64     buildonly-randconfig-005-20260815    gcc-14
x86_64     buildonly-randconfig-006-20260815    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260815    gcc-13
x86_64               randconfig-002-20260815    clang-22
x86_64               randconfig-003-20260815    clang-22
x86_64               randconfig-004-20260815    clang-22
x86_64               randconfig-005-20260815    clang-22
x86_64               randconfig-006-20260815    gcc-14
x86_64               randconfig-011-20260815    clang-22
x86_64               randconfig-012-20260815    gcc-14
x86_64               randconfig-013-20260815    clang-22
x86_64               randconfig-014-20260815    clang-22
x86_64               randconfig-015-20260815    gcc-14
x86_64               randconfig-016-20260815    gcc-14
x86_64               randconfig-071-20260815    clang-22
x86_64               randconfig-072-20260815    clang-22
x86_64               randconfig-073-20260815    gcc-12
x86_64               randconfig-074-20260815    clang-22
x86_64               randconfig-075-20260815    clang-22
x86_64               randconfig-076-20260815    clang-22
xtensa               randconfig-001-20260815    gcc-8.5.0
xtensa               randconfig-002-20260815    gcc-8.5.0
xtensa                        virt_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

