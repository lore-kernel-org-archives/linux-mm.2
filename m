Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D3CC531F2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F756B0089; Thu, 19 Feb 2026 23:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19BF6B0092; Thu, 19 Feb 2026 23:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2366B0096; Thu, 19 Feb 2026 23:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 982FC6B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:14:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C694140A6A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:14:05 +0000 (UTC)
X-FDA: 84463517250.26.9FE9D25
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A1D1160002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:14:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n1ZkfbS8;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=dqLfw7GGiJei0YN+qd5CWZM+FbwwYCQaQGNKlOtltZg=;
	b=lAOUfBL7nOgrth+u4jK4tHASUlzTksTfLKlTuOAE/rdZhlzTYUHSwyqj7M5qnC+CQlT4fd
	gOsgUjjybQ+5GmTUILJc9TEHbynjEFjAALPghiANLaD9MFtzpODeelRzNh5tEAAg2xoypP
	d5pynYqJ1tnvbhlSBAQdMZaZtHkMpyc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n1ZkfbS8;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560843; a=rsa-sha256;
	cv=none;
	b=CyFjO0U+XZOocQPUELjIfMgvUPJKLFUWeVmgN+vIqgy84MeYHwyLXsM6TVJ1LfURu7RlBT
	48EdZDvgcYbvyY6Q9XD0vQEW8UUlCtpebxUAs10HO8jZSYNze7JsNuhC1lQ32L9zNeqMNt
	M0jyAHyj8lL63E5tGuewW0zJnwVK2HE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771560843; x=1803096843;
  h=date:from:to:cc:subject:message-id;
  bh=/dlq3b1SWb1/EDayMgspiIhB9qAfUlH+dGjpcJTNzag=;
  b=n1ZkfbS860phbWlSvuI46IvNwPqOXmwtEIpJw5M9ZcYrbPPuhpn9vN9n
   7oAWXM6aQRnrmvFCj83dx5gOJNxk4L53wsXNpvWBXjRrSsit/C74KI2oC
   KdTVkoQwWj14lRa+epP9E1H1D1ZH8cKtiGaNYZKoNCpkBxs3cf91ZBK9r
   +NrUABrp59POF51mY0VfcG6geAUMy0Kw4KWdUJKf61ddz9aBUSWoXuyZD
   JqR+ruSO+aTH9ogyVbQlFfz6ia5jp8HcxvO7of2Y51AJWMihindvTsmTK
   bf/kkSFPy+6zvVZHI/a/aq1LGCIkjXdyjYjeEIe8cBuea0EqtKZk4Aizy
   Q==;
X-CSE-ConnectionGUID: bZF61mtBRb+qh7LuxP2pPw==
X-CSE-MsgGUID: tL3cEIXRREeutydfv59LHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72556191"
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="72556191"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 20:14:01 -0800
X-CSE-ConnectionGUID: uimu8WroQZu48k+xFnUsrw==
X-CSE-MsgGUID: RgoVTJq+RuGneumVdWZggg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="213332959"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 19 Feb 2026 20:13:59 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vtHts-000000013oK-3qhf;
	Fri, 20 Feb 2026 04:13:56 +0000
Date: Fri, 20 Feb 2026 12:13:35 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 44982d352c33767cd8d19f8044e7e1161a587ff7
Message-ID: <202602201226.fgHcUqTq-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A1D1160002
X-Stat-Signature: 4przc857brz75bs419enoijf6jujizox
X-HE-Tag: 1771560842-74358
X-HE-Meta: U2FsdGVkX1/Xzf60wfkwztUNKmKso/ySrT9aRdm+dftTZ+HR+4krgY9eyFtUSNpehcIKZF9wMwj+acTqazyyBSQDpPLsvc5Q9Ah3K/a9ALEYAf70b3dSDpaA6tovfika3PDgZ5u+bIOPZd9YHScgx6mUmVZnuM1ovKCZLn7bvtCJHA3O6r3zdZ1Tzl5e5p7KjBWxWf2Nwhf2Qt8l+vT4nB79T2aoOI+/IF+c/UWidsfQ0rBkvrS40rl8Go2xOnZpNW3Ga2wF3icaZYLhJtnf4RnRHNXEC1+SySQ562TC7wWvhZzlB0qwe7WhpFBakYww7wAvU2fI8ZtWCnOZQJRhHjS+xN0qkXpulSL+w+dCBFzAgmI7VmjxQ3gIhoWqFXaOFli/1TsM5aE2WOQV3J02T7HXmRuccz1EH4hRCF8Hy78eh8UgoXQStABEGTS4I1U8bPHBcwV3TnDDolUTHji9DJIt8JrJidM3jyr1vlsowOjIMNj+jvqv11jIEUIkNA4Rg5HkxE9Ampl+ZZEtCozWg1Go+u4pQH+hWg8Qid17XPSdtZ8WECM1qeCeLbh4A67KmbEL878Fb5q3zumfGYIwnpxgpR2dpa4Jqnhi3+2XYV+Vg+6nsNCH9JXqmSbdHJUvppTcm9yLwy1LH9UX45HmXwtUSJ5BCX3PkfmYqG3HhoUkNZzrhNxrkjFTTEwgeUxxd1JzVuysOb+ux6sTJlt/JyJe+WfmA/xecuZmaB7H7wzFMLgwsVIJRx51SVqjRahhs1xHX21H5WwSQ8czfqefM9AOtQhvT+FxsVnWnhWz+sNYOdSYSCmqVrR49+ZxyDmP1KdbQ8kIe1QcLzg3rCc/dEXqpMJbhv7biSkYneGojd5duDkqDSBNA9jFi0uDyqKU92FekKioGqzpWw3InTnr+F1qKk650VgeuZGI6uvOYxtTqe8w+1JvTMecjG7o1iQuZBnqqcnyn7g5OaDRZak
 phWkPHFP
 Q+XGa6GJ4Fhz6iq7k1auGC+a8K1eLTXc1o2kCv1cWKDqjKv+htCuykgdAUyuAWjE9s48IO7PX1AW1etRMGIgXPdhnG6jXqPArVCTEfDCCFCUCTWUQ8tQKmeWwF0w0Sjtpg2ezvg9gdRMNujnejEApsmPgAsl/CbPvncVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 44982d352c33767cd8d19f8044e7e1161a587ff7  Add linux-next specific files for 20260219

elapsed time: 871m

configs tested: 281
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260219    gcc-9.5.0
arc                   randconfig-001-20260220    gcc-8.5.0
arc                   randconfig-002-20260219    gcc-10.5.0
arc                   randconfig-002-20260220    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                       imx_v4_v5_defconfig    clang-23
arm                            mmp2_defconfig    gcc-15.2.0
arm                   randconfig-001-20260219    gcc-15.2.0
arm                   randconfig-001-20260220    gcc-8.5.0
arm                   randconfig-002-20260219    clang-23
arm                   randconfig-002-20260220    gcc-8.5.0
arm                   randconfig-003-20260219    clang-23
arm                   randconfig-003-20260220    gcc-8.5.0
arm                   randconfig-004-20260219    gcc-13.4.0
arm                   randconfig-004-20260220    gcc-8.5.0
arm                        realview_defconfig    gcc-15.2.0
arm                           sama5_defconfig    gcc-15.2.0
arm                    vt8500_v6_v7_defconfig    gcc-15.2.0
arm                         wpcm450_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260219    clang-23
arm64                 randconfig-002-20260219    gcc-8.5.0
arm64                 randconfig-003-20260219    gcc-8.5.0
arm64                 randconfig-004-20260219    gcc-14.3.0
arm64                           snd_defconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260219    gcc-15.2.0
csky                  randconfig-002-20260219    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260220    clang-17
hexagon               randconfig-001-20260220    clang-23
hexagon               randconfig-002-20260220    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260219    gcc-14
i386        buildonly-randconfig-001-20260220    clang-20
i386        buildonly-randconfig-002-20260219    gcc-14
i386        buildonly-randconfig-002-20260220    clang-20
i386        buildonly-randconfig-003-20260219    gcc-14
i386        buildonly-randconfig-003-20260220    clang-20
i386        buildonly-randconfig-004-20260219    gcc-14
i386        buildonly-randconfig-004-20260220    clang-20
i386        buildonly-randconfig-005-20260219    clang-20
i386        buildonly-randconfig-005-20260220    clang-20
i386        buildonly-randconfig-006-20260219    clang-20
i386        buildonly-randconfig-006-20260220    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260219    gcc-14
i386                  randconfig-001-20260220    clang-20
i386                  randconfig-002-20260219    clang-20
i386                  randconfig-002-20260220    clang-20
i386                  randconfig-003-20260219    clang-20
i386                  randconfig-003-20260220    clang-20
i386                  randconfig-004-20260219    clang-20
i386                  randconfig-004-20260220    clang-20
i386                  randconfig-005-20260219    clang-20
i386                  randconfig-005-20260220    clang-20
i386                  randconfig-006-20260219    gcc-14
i386                  randconfig-006-20260220    clang-20
i386                  randconfig-007-20260219    gcc-14
i386                  randconfig-007-20260220    clang-20
i386                  randconfig-011-20260219    gcc-14
i386                  randconfig-011-20260220    gcc-14
i386                  randconfig-012-20260219    clang-20
i386                  randconfig-012-20260220    gcc-14
i386                  randconfig-013-20260219    gcc-14
i386                  randconfig-013-20260220    gcc-14
i386                  randconfig-014-20260219    gcc-13
i386                  randconfig-014-20260220    gcc-14
i386                  randconfig-015-20260219    gcc-13
i386                  randconfig-015-20260220    gcc-14
i386                  randconfig-016-20260219    gcc-14
i386                  randconfig-016-20260220    gcc-14
i386                  randconfig-017-20260219    gcc-14
i386                  randconfig-017-20260220    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260220    clang-23
loongarch             randconfig-002-20260220    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                          atari_defconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                            q40_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
microblaze                      mmu_defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                          ath25_defconfig    gcc-15.2.0
mips                        bcm47xx_defconfig    clang-18
mips                        bcm47xx_defconfig    gcc-15.2.0
mips                         db1xxx_defconfig    gcc-15.2.0
mips                     decstation_defconfig    gcc-15.2.0
mips                malta_qemu_32r6_defconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260220    clang-23
nios2                 randconfig-001-20260220    gcc-9.5.0
nios2                 randconfig-002-20260220    clang-23
nios2                 randconfig-002-20260220    gcc-8.5.0
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
parisc                randconfig-001-20260219    gcc-15.2.0
parisc                randconfig-001-20260220    clang-23
parisc                randconfig-002-20260219    gcc-8.5.0
parisc                randconfig-002-20260220    clang-23
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                        cell_defconfig    gcc-15.2.0
powerpc                   motionpro_defconfig    gcc-15.2.0
powerpc                    mvme5100_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260219    gcc-8.5.0
powerpc               randconfig-001-20260220    clang-23
powerpc               randconfig-002-20260219    clang-23
powerpc               randconfig-002-20260220    clang-23
powerpc                  storcenter_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260219    clang-23
powerpc64             randconfig-001-20260220    clang-23
powerpc64             randconfig-002-20260219    gcc-8.5.0
powerpc64             randconfig-002-20260220    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260219    clang-23
riscv                 randconfig-001-20260220    gcc-11.5.0
riscv                 randconfig-002-20260219    gcc-8.5.0
riscv                 randconfig-002-20260220    gcc-11.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260219    clang-17
s390                  randconfig-001-20260220    gcc-11.5.0
s390                  randconfig-002-20260219    clang-18
s390                  randconfig-002-20260220    gcc-11.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260219    gcc-15.2.0
sh                    randconfig-001-20260220    gcc-11.5.0
sh                    randconfig-002-20260219    gcc-11.5.0
sh                    randconfig-002-20260220    gcc-11.5.0
sh                             shx3_defconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260219    gcc-15.2.0
sparc                 randconfig-002-20260219    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260219    clang-23
sparc64               randconfig-002-20260219    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260219    clang-18
um                    randconfig-002-20260219    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260219    gcc-14
x86_64      buildonly-randconfig-001-20260220    clang-20
x86_64      buildonly-randconfig-002-20260219    gcc-12
x86_64      buildonly-randconfig-002-20260220    clang-20
x86_64      buildonly-randconfig-003-20260219    clang-20
x86_64      buildonly-randconfig-003-20260220    clang-20
x86_64      buildonly-randconfig-004-20260219    gcc-14
x86_64      buildonly-randconfig-004-20260220    clang-20
x86_64      buildonly-randconfig-005-20260219    gcc-14
x86_64      buildonly-randconfig-005-20260220    clang-20
x86_64      buildonly-randconfig-006-20260219    gcc-14
x86_64      buildonly-randconfig-006-20260220    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260220    gcc-14
x86_64                randconfig-002-20260220    gcc-14
x86_64                randconfig-003-20260220    gcc-14
x86_64                randconfig-004-20260220    clang-20
x86_64                randconfig-004-20260220    gcc-14
x86_64                randconfig-005-20260220    clang-20
x86_64                randconfig-005-20260220    gcc-14
x86_64                randconfig-006-20260220    gcc-14
x86_64                randconfig-011-20260219    gcc-14
x86_64                randconfig-012-20260219    gcc-14
x86_64                randconfig-013-20260219    gcc-14
x86_64                randconfig-014-20260219    gcc-14
x86_64                randconfig-015-20260219    gcc-14
x86_64                randconfig-016-20260219    gcc-14
x86_64                randconfig-071-20260219    clang-20
x86_64                randconfig-071-20260220    gcc-14
x86_64                randconfig-072-20260219    gcc-14
x86_64                randconfig-072-20260220    gcc-14
x86_64                randconfig-073-20260219    gcc-14
x86_64                randconfig-073-20260220    gcc-14
x86_64                randconfig-074-20260219    gcc-14
x86_64                randconfig-074-20260220    gcc-14
x86_64                randconfig-075-20260219    clang-20
x86_64                randconfig-075-20260220    gcc-14
x86_64                randconfig-076-20260219    clang-20
x86_64                randconfig-076-20260220    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260219    gcc-15.2.0
xtensa                randconfig-002-20260219    gcc-8.5.0
xtensa                         virt_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

