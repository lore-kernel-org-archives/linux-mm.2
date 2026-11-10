Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10F960A2630
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fbk2KXuW
Received: by kanga.kvack.org (Postfix)
	id DD2946B05B3; Tue, 10 Nov 2026 15:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9876B05B5; Tue, 10 Nov 2026 15:39:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF0B6B05BA; Tue, 10 Nov 2026 15:39:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1D546B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 370C7A0454
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:39:03 +0000 (UTC)
X-FDA: 85420373766.12.661B3F7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3861314000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:39:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fbk2KXuW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LKd4GivGkQTs+6RzgvNOgwBwhZpia8JQHTdi2R3T3tw=;
	b=Xeo5hiktSrBWinV/ZCJdscZ7sXXTmep7AVQJtgFbVkxWbzgpQN+yvGewArQo02Irg+mGb4
	cmW8DegefJpUBbYn/Q79Enup1mgUGejVP4aHJ2O03OoB2CqPcFMEjKZg4hEBJhtvDM6SfK
	Xz89Qgd42amvq2dZ6RNfVlOo9KNFbBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343141;
	b=fU4vFyz+JCEehSI12oznqRJo9OEbV9/ACZ2IRFAZ6h7v1qvFNPsgRw/X0HFxJuL0fvRfbt
	yReQegiG6CHBWGA1pTWg6sOkDFqH9q2hNsM4DU2jBx72WlNxCFBImBSpBjduIb9lXTmgOu
	8leQKAZbz/+rjjTfrSeQtYjr+m1qt2U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fbk2KXuW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794343140; x=1825879140;
  h=date:from:to:cc:subject:message-id;
  bh=C12SseTDD1qIdnKlKT13p4DgVIYIDZvRKzFsr6dyFYw=;
  b=fbk2KXuWYeYgKBjw881SZhDXvcP27C/X0zi+oY4R4P71deYJ+h3mLCM5
   FpOcutqD0lghDQo0nit2H8Urin5XHB0VRUsKli4sc6RAts1puSuZCpEMt
   QZNe/CpFpqBTcv3ccYa01NLSbHFG7BrP6wGC5YC3YcWmU1wjzVy8KlUfj
   SBaZtZBQh2X67Twn9wCCqiqB+6ukPvcBnd5k2oOAUaUY+QVK2jS32Mzxd
   bEo8Am39b0rpsujsqsFkNK6cuT+cKDopm7hQVzpdg3dezaXCHloaBAnBf
   /2pavrCPZWCimCOMPuERDenwvHcMv2Z91dIYE+hnqDZbMN9aTt9T0iuHL
   Q==;
X-CSE-ConnectionGUID: bx74uJlJQDi2EFsAFBfCUw==
X-CSE-MsgGUID: FiXVDKLAR5S/W7pJnyWkvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="2994632"
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="2994632"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 12:38:59 -0800
X-CSE-ConnectionGUID: r5NROegQSiiWRGkPg512/w==
X-CSE-MsgGUID: v9GvUIi6SpyXyukUkF7rgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="8336061"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Nov 2026 12:38:58 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQscI-00000000xTL-44sR;
	Tue, 10 Nov 2026 20:38:54 +0000
Date: Wed, 11 Nov 2026 04:38:30 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 488f62a72b8ea866bdb00262e909ea601fa2e707
Message-ID: <20261111043830.Jk4Ux683-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: bza4b3frscy83im8fwctzdomwdh4abog
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3861314000C
X-HE-Tag: 1794343140-139366
X-HE-Meta: U2FsdGVkX19O1/2NpXSzkty3J1CCjX5JZ/KsPvaV/K5Np+4/h+sSCyVY4IASXq8jtzEcDPIFGG6EXTT0PcBo1iuU9JXiIvUxgh7DK3gpDc81PeBcGRZ4bxtZBa274NxEn4tebPHlpkd2ayXwo+FgH14zCkCAIxIWJB9cmFkSeDJ5Z9hhZEf+1qcwJLJ+x8CU6+HFKMO6XKlHVXq2k4kaA8MlWjXqK/1yjgqDDxqQx6irVWjSWWUhMdLJtDuUW6JFXC+ejzxrHC4EwCXFYZ1dxELwNn81E3BgFzMtiZ435qsYgfUAYIbSyGV+Og8cPjdxUj8yX/s2DlLQQ5s7ZF0T4mt4PxIJCk1GU0XF14v5v5GOMgPuxjHexhqNM3OisW6+QSFWF+mN0FKVGXHr/04p4mAR0zbyeH9Q0Kn9lZTPzXC9sSsU8Z3mmZRlXles5ta84WHUkzZPxgvsRIhxXEqT0i6IXVNOsyauq6b6yUyOR/oSWki8sp3wx7hFLNfXEHLGVDI5TNky/qw+2kxJtfI/yKsKxMy5b1IE25/SkLKDH7MI5KCHSFqD+XKyPsbv2CRiYaqEKUgDEIXdsFYHvIcF66Liil3gy1EwK8Ppkg3XxuyhHf8GA0ziFTf476nUDOeqMXQdiMJn9CURBDzJiQb4YeScoLVRPG/GDzkXMzXheBT65YDgC0Z3KIVopAFgJ7LNTUbLbWNztHC7Kq+xdMfuoeVBtmkGE7wsgSqM4Jh/sa/tpaj7gIisMsfzPrtZpWbuuRFI6fqbMPPPy27fg3Rkr6Mp/oiInR7DL+8FpGezHOISc8FpJ4vyO4/joq0bT1ARmUV4iUkxEP3W1h6imh9Ilo9EOQFSw9t/iKnEHwkZLUkYE9qSqQ7lplwhIiyWfDgXswZkDxtRBOm+cXs1rUbBJNbQIkVDfUJAjGEP+4bi6Bmi2ffiLlMGfe37A2xsSYP5CPKZHXYAeHwxB23tYHF
 3pEVf9uU
 aVvW1VN2Q/MXD3wXPiT19c7qufiPGHJMkPYugTxycCT9ASYzl40zMQaTgxWPN3ZrQfUg99riKzZ3A3VrlXscazud8Rp7PYI77ERq7xRZRyNiqwUt4CcRbQAw/mh1irfI372RMo6yydToY5tv3QiUUI2kEVMBk7lclpO7i2i2xIjsm1HF0tCU08AfIKEWZAWlp6b3dATh5ZC9cDhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 488f62a72b8ea866bdb00262e909ea601fa2e707  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 827m

configs tested: 313
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261110    gcc-11.5.0
alpha                 randconfig-2001-20261110    gcc-13.5.0
alpha                 randconfig-2200-20261110    gcc-9.5.0  smatch
alpha                randconfig-r2101-20261110    gcc-14     cocci
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261110    gcc-10.5.0
arc                   randconfig-1000-20261111    gcc-15.3.0
arc                   randconfig-1001-20261110    gcc-10.5.0
arc                   randconfig-1001-20261111    gcc-15.3.0
arc                   randconfig-2000-20261110    gcc-8.5.0
arc                   randconfig-2001-20261110    gcc-13.5.0
arc                   randconfig-2002-20261110    gcc-15.3.0
arc                   randconfig-2003-20261110    gcc-13.5.0
arc                   randconfig-2004-20261110    gcc-11.5.0
arc                   randconfig-2005-20261110    gcc-13.5.0
arc                   randconfig-2200-20261110    gcc-8.5.0  smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    gcc-16.2.0
arm                         mvebu_v5_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261110    gcc-10.5.0
arm                   randconfig-1000-20261111    gcc-15.3.0
arm                   randconfig-1001-20261110    gcc-10.5.0
arm                   randconfig-1001-20261111    gcc-15.3.0
arm                   randconfig-1002-20261110    gcc-10.5.0
arm                   randconfig-1002-20261111    gcc-15.3.0
arm                   randconfig-1003-20261110    gcc-10.5.0
arm                   randconfig-1003-20261111    gcc-15.3.0
arm                   randconfig-2000-20261110    clang-24
arm                   randconfig-2200-20261110    gcc-11.5.0 smatch
arm                  randconfig-r2100-20261110    clang-24   cocci
arm                  randconfig-r2105-20261110    gcc-14     cocci
arm                            spitz_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261110    gcc-12.5.0
arm64                 randconfig-1001-20261110    gcc-12.5.0
arm64                 randconfig-1002-20261110    gcc-12.5.0
arm64                 randconfig-1003-20261110    gcc-12.5.0
arm64                 randconfig-2200-20261110    clang-24   smatch
arm64                randconfig-r2103-20261110    gcc-8.5.0  cocci
arm64                randconfig-r2105-20261110    gcc-10.5.0 cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261110    gcc-12.5.0
csky                  randconfig-1001-20261110    gcc-12.5.0
csky                  randconfig-2000-20261110    gcc-11.5.0
csky                  randconfig-2001-20261110    gcc-11.5.0
csky                  randconfig-2001-20261110    gcc-13.5.0
csky                  randconfig-2200-20261110    gcc-16.2.0 smatch
csky                 randconfig-r2303-20261110    gcc-10.5.0 sparse
csky                 randconfig-r2307-20261110    gcc-10.5.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261110    clang-17
hexagon               randconfig-1000-20261111    clang-17
hexagon               randconfig-1001-20261110    clang-17
hexagon               randconfig-1001-20261111    clang-17
hexagon               randconfig-2000-20261110    clang-17
hexagon               randconfig-2000-20261110    gcc-11.5.0
hexagon               randconfig-2001-20261110    clang-24
hexagon               randconfig-2001-20261110    gcc-11.5.0
hexagon               randconfig-2200-20261110    clang-24   smatch
hexagon              randconfig-r2104-20261110    clang-24   cocci
hexagon              randconfig-r2310-20261110    clang-24   sparse
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261110    clang-22
i386        buildonly-randconfig-1001-20261110    clang-22
i386        buildonly-randconfig-1002-20261110    clang-22
i386        buildonly-randconfig-1003-20261110    clang-22
i386        buildonly-randconfig-1004-20261110    clang-22
i386        buildonly-randconfig-1005-20261110    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261110    gcc-14
i386                  randconfig-1001-20261110    gcc-14
i386                  randconfig-1002-20261110    gcc-14
i386                  randconfig-1003-20261110    gcc-14
i386                  randconfig-1004-20261110    gcc-14
i386                  randconfig-1005-20261110    gcc-14
i386                  randconfig-1006-20261110    gcc-14
i386                  randconfig-1007-20261110    clang-22
i386                  randconfig-1008-20261110    clang-22
i386                  randconfig-1009-20261110    clang-22
i386                  randconfig-1010-20261110    clang-22
i386                  randconfig-1011-20261110    clang-22
i386                  randconfig-1012-20261110    clang-22
i386                  randconfig-1013-20261110    clang-22
i386                  randconfig-2200-20261110    gcc-13     smatch
i386                 randconfig-r2102-20261110    gcc-14     cocci
i386                 randconfig-r2103-20261110    gcc-14     cocci
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    gcc-16.2.0
loongarch             randconfig-1000-20261110    clang-17
loongarch             randconfig-1000-20261111    clang-17
loongarch             randconfig-1001-20261110    clang-17
loongarch             randconfig-1001-20261111    clang-17
loongarch             randconfig-2000-20261110    clang-24
loongarch             randconfig-2001-20261110    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261110    gcc-8.5.0
m68k                  randconfig-2001-20261110    gcc-12.5.0
m68k                  randconfig-2200-20261110    gcc-16.2.0 smatch
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2001-20261110    gcc-8.5.0
microblaze            randconfig-2200-20261110    gcc-8.5.0  smatch
microblaze           randconfig-r2100-20261110    gcc-14     cocci
microblaze           randconfig-r2102-20261110    gcc-14     cocci
microblaze           randconfig-r2104-20261110    gcc-14     cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                            ip22_defconfig    gcc-16.2.0
mips                         maltaup_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261110    gcc-8.5.0
mips                  randconfig-2001-20261110    clang-24
mips                  randconfig-2002-20261110    gcc-13.5.0
mips                  randconfig-2200-20261110    clang-17   smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261110    clang-17
nios2                 randconfig-1000-20261111    clang-17
nios2                 randconfig-1001-20261110    clang-17
nios2                 randconfig-1001-20261111    clang-17
nios2                 randconfig-2000-20261110    gcc-11.5.0
nios2                 randconfig-2001-20261110    gcc-11.5.0
nios2                 randconfig-2200-20261110    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261110    gcc-16.2.0
openrisc              randconfig-2001-20261110    gcc-13.5.0
openrisc              randconfig-2002-20261110    gcc-16.2.0
openrisc              randconfig-2200-20261110    gcc-9.5.0  smatch
openrisc             randconfig-r2309-20261110    gcc-16.2.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261110    gcc-14.4.0
parisc                randconfig-1000-20261111    gcc-15.3.0
parisc                randconfig-1001-20261110    gcc-14.4.0
parisc                randconfig-1001-20261111    gcc-15.3.0
parisc                randconfig-2000-20261110    gcc-13.5.0
parisc                randconfig-2001-20261110    gcc-11.5.0
parisc                randconfig-2200-20261110    gcc-15.3.0 smatch
parisc64                          alldefconfig    gcc-16.2.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       arches_defconfig    gcc-16.2.0
powerpc                      mpc83xx_defconfig    gcc-16.2.0
powerpc                        ppc64_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261110    gcc-14.4.0
powerpc               randconfig-1000-20261111    gcc-15.3.0
powerpc               randconfig-1001-20261110    gcc-14.4.0
powerpc               randconfig-1001-20261111    gcc-15.3.0
powerpc               randconfig-2000-20261110    clang-24
powerpc               randconfig-2001-20261110    clang-24
powerpc               randconfig-2002-20261110    clang-17
powerpc               randconfig-2200-20261110    clang-24   smatch
powerpc              randconfig-r2302-20261110    gcc-8.5.0  sparse
powerpc64                         alldefconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261110    gcc-14.4.0
powerpc64             randconfig-1000-20261111    gcc-15.3.0
powerpc64             randconfig-1001-20261110    gcc-14.4.0
powerpc64             randconfig-1001-20261111    gcc-15.3.0
powerpc64             randconfig-2000-20261110    gcc-8.5.0
powerpc64             randconfig-2001-20261110    gcc-10.5.0
powerpc64             randconfig-2002-20261110    clang-21
powerpc64             randconfig-2200-20261110    clang-24   smatch
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261110    clang-24
riscv                 randconfig-1000-20261111    clang-17
riscv                 randconfig-1001-20261110    clang-24
riscv                 randconfig-1001-20261111    clang-17
riscv                 randconfig-2200-20261110    gcc-8.5.0  smatch
riscv                randconfig-r2311-20261110    gcc-8.5.0  sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261110    clang-24
s390                  randconfig-1000-20261111    clang-17
s390                  randconfig-1001-20261110    clang-24
s390                  randconfig-1001-20261111    clang-17
s390                  randconfig-2200-20261110    clang-18   smatch
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261110    clang-24
sh                    randconfig-1000-20261111    clang-17
sh                    randconfig-1001-20261110    clang-24
sh                    randconfig-1001-20261111    clang-17
sh                    randconfig-2000-20261110    gcc-16.2.0
sh                    randconfig-2001-20261110    gcc-9.5.0
sh                    randconfig-2002-20261110    gcc-16.2.0
sh                    randconfig-2003-20261110    gcc-13.5.0
sh                    randconfig-2004-20261110    gcc-15.3.0
sh                    randconfig-2005-20261110    gcc-9.5.0
sh                    randconfig-2200-20261110    gcc-16.2.0 smatch
sh                   randconfig-r2300-20261110    gcc-9.5.0  sparse
sh                            se7751_defconfig    gcc-16.2.0
sh                   sh7785lcr_32bit_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261110    gcc-12.5.0
sparc                 randconfig-1001-20261110    gcc-12.5.0
sparc                 randconfig-2000-20261110    gcc-11.5.0
sparc                 randconfig-2001-20261110    gcc-8.5.0
sparc                 randconfig-2200-20261110    gcc-13.5.0 smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261110    gcc-12.5.0
sparc64               randconfig-1001-20261110    gcc-12.5.0
sparc64               randconfig-2000-20261110    gcc-14.4.0
sparc64               randconfig-2001-20261110    gcc-8.5.0
sparc64               randconfig-2200-20261110    clang-24   smatch
sparc64              randconfig-r2101-20261110    clang-24   cocci
sparc64              randconfig-r2304-20261110    clang-24   sparse
sparc64              randconfig-r2308-20261110    gcc-12.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261110    gcc-12.5.0
um                    randconfig-1001-20261110    gcc-12.5.0
um                    randconfig-2000-20261110    gcc-14
um                    randconfig-2001-20261110    gcc-14
um                    randconfig-2200-20261110    gcc-14     smatch
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261110    gcc-14
x86_64      buildonly-randconfig-1001-20261110    gcc-14
x86_64      buildonly-randconfig-1002-20261110    gcc-14
x86_64      buildonly-randconfig-1003-20261110    gcc-14
x86_64      buildonly-randconfig-1004-20261110    gcc-14
x86_64      buildonly-randconfig-1005-20261110    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261110    gcc-14
x86_64                randconfig-1001-20261110    gcc-14
x86_64                randconfig-1002-20261110    gcc-14
x86_64                randconfig-1003-20261110    gcc-14
x86_64                randconfig-1004-20261110    gcc-14
x86_64                randconfig-1005-20261110    gcc-14
x86_64                randconfig-1006-20261110    gcc-14
x86_64                randconfig-1007-20261110    gcc-14
x86_64                randconfig-1008-20261110    gcc-14
x86_64                randconfig-1009-20261110    gcc-14
x86_64                randconfig-1010-20261110    gcc-14
x86_64                randconfig-1011-20261110    gcc-14
x86_64                randconfig-1012-20261110    gcc-14
x86_64                randconfig-1013-20261110    gcc-14
x86_64                randconfig-1014-20261110    gcc-14
x86_64                randconfig-1015-20261110    gcc-14
x86_64                randconfig-1016-20261110    gcc-14
x86_64                randconfig-1017-20261110    gcc-14
x86_64                randconfig-2200-20261110    gcc-14     smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261110    gcc-12.5.0
xtensa                randconfig-1001-20261110    gcc-12.5.0
xtensa                randconfig-2000-20261110    gcc-11.5.0
xtensa                randconfig-2000-20261110    gcc-8.5.0
xtensa                randconfig-2001-20261110    gcc-11.5.0
xtensa                randconfig-2001-20261110    gcc-15.3.0
xtensa               randconfig-r2305-20261110    gcc-16.2.0 sparse
xtensa               randconfig-r2306-20261110    gcc-10.5.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

