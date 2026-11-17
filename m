Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3536606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TJ0arPoC
Received: by kanga.kvack.org (Postfix)
	id 7A07A6B00EF; Tue, 17 Nov 2026 18:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7788B6B05B0; Tue, 17 Nov 2026 18:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DCC6B05B1; Tue, 17 Nov 2026 18:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAF46B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:04:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFD181A05F5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:04:35 +0000 (UTC)
X-FDA: 85446142110.27.787C320
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id E98224000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:04:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TJ0arPoC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf27.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794956674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=guMlWSFCL19BB4ezbXPkNCJp4j4rrvi8cCniBf2A/R0=;
	b=OMhTVfATEso4aUXEk4TBUESPBjpmKcPM797ZZR+thFGh7xBF/aK+i4t6Sefnn8AnhL8wjt
	wDOIEV1AnYCZJOVJJ9e4oIffDVOCeCwnrqAeODHguDMJu+mWHbqV/2IO6g4goMlDDrYIY7
	fs/VZwFuv+2Y1X6F6auFN4tjEUwrfUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794956674;
	b=T7QBz5SfKN3Yo0lJPBuq5HVNq+yXfCL37ErQJm6Va6yJDyJCq2ZzDmwkHlzp47FjhVAG4O
	gorzkMJC9OMjCCp/KDAcTRCluxWPMvQQdZ2vOIcb9DzzcEACOHQRotKYQ2S1CD3AEk2c78
	yXCTnOEY3XWGvQSsd6oDPLAyJqgInfc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TJ0arPoC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf27.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794956669; x=1826492669;
  h=date:from:to:cc:subject:message-id;
  bh=D+g7kqMelYRo4+1Y+2CvcUQhXMvATeYjJdoo8Dcb9dk=;
  b=TJ0arPoCwyiEQFG66FqzY2m0y/4q0cJEZls7CN5VjxKmdSTE2q6NGnrf
   Le+iGYSKXM2EbxacIcQyUT88H2i2MWCFuBjicnC54US8py898haRMahxw
   wLJ6Ya6hfoHIqTC39tXc2HRsX2b9KO9epqMlN9PmoZjaRJ3d+HE/So7/B
   ExVpKzqpdCNfwdjtoaix1TKhlKShkoK5e4zsuqNpBEcgd+Fun8c28Xqf6
   PRn305nu/hPhz81vyB4Nw8i6s3ojmRzRYWJGBORgMA0j5NE/o9+ig8BQS
   xNsNEZH02E+lnsSd8o9MgBNV8UVHKwI1cxkUrsHTDnLVD0vZKZF1VG/07
   g==;
X-CSE-ConnectionGUID: zhoXJgFTQhmj9/0nDbJnEQ==
X-CSE-MsgGUID: 5CrWkI+gQ8eEL47QQVDC1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3632829"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3632829"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 15:04:23 -0800
X-CSE-ConnectionGUID: dCgBVY/ISkujx9enGffJ/w==
X-CSE-MsgGUID: ZC2Q+vhSTuushPSb+iouSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="11780023"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 17 Nov 2026 15:04:22 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTSDq-00000001CcO-1DlW;
	Tue, 17 Nov 2026 23:04:18 +0000
Date: Wed, 18 Nov 2026 07:03:48 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 749a4de370409464cf8501ec5b2451df45c84eb4
Message-ID: <20261118070348.N2bXROb9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E98224000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jyn6cfxjwg3mdjfr1mbx8h4qc3qkp6s3
X-Rspam-User: 
X-HE-Tag: 1794956668-585165
X-HE-Meta: U2FsdGVkX1+m/xCmTG7I9FgvnTWAOZvOAZD2GyK13wxlODQcNdE5m9A1nNUp11Dm9FSV1AjAys31tTaUakIOksCmLK97Ga1RTo8y7N/ALLczpNyp6WteMOxc5Pgj24PuBk7yxHzCpeHgYx22NeYAuV+vS8B2+iBLhs+RCGndR8jtax+P4myJHdYwDiJfSnykCl2oKbCNB2UTLgvww+h97QnUJf9bFjoQKsNGLOHHeh6blj0b4yYofocdp7EWvSZ4dO4ghN+oP1G0ZwJKoDyDRmK/aULvJU7BKpNHo46oAVDnC7V5YEtiRrqwURDU7VjLZV/lUWM0Jzui5WRJr+wv3EpKN+hCtsfQJQGkLaB3QD17wrPFimPd+d7KsH5jyoe1zMAR7cGYiGmzBtBNkXIbst2hE9NSnPHn+FZbJ11PERexX5aY5HTBv6kT4FryLlcAOX1Xmre2561JzcgbCmnBzHuYmLKQsfv0PNZGOLI1Ycd98Mr8Kz9Uh5ah+95KW+iSIN3qGriJsvD9wPzTPQ9Lm37H7kMtVUf6zZ6VWrFZNOwFK0Dwy/uVojcWEmBm9Au2OLPkXTUCSuAb47Ho28sP5GBCK9BzAtmtYw1X4Z9N4AM378n3OMbD4Rx5V03+AqaDWbieVfTF0bdfoHSvXBl9ENKSHnP3HcXfGwqlAmKkO6GBkhntMVnZeQorzMY92EaA7eaDhR0dPsrD5otBFJnu0Kkc6HfoQkwnPRCQUCiTmGbUC8Bvt8gpedvlrd8H76mWy6WUwWzJDuWrY1siO7WaRXqmTdypC93hQdPNbou1tUIlwHSurco1P/PMG88jXdOjUtq0CtnWPrT889o8jZ2Jk0GVtdAKc4Gqt1uDAdWnCBojclRz+we1tlD1WOBkSLBpQUJ52HOj6vhKC1u5O7oJ7QbXo15reyCDJ7D6T3DjTawqOv8Pf2PqkZOSEPrmZP2XVC47UivZMXpme/bDbGt
 cO+pn6pu
 ngauXli5MAtz8+W0PXIUi8iur3OcdkKEqmZMR51THMG1jwJK0sOYl7+gHKpGN7L0jn/3z6mA3x3T+hSpyl0du60F8WOpp3Uug1qnFc0CfDQz9kQxqwdqQ4Zkb8mqMGG/mcF46PRip0REkHXgHlgWwXUkNfHSoCbIW8zWbdETQSas9G7i1WwgBrLuICS4yBJB8JTYPCDbLpnHEUvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 749a4de370409464cf8501ec5b2451df45c84eb4  Add linux-next specific files for 20261116

elapsed time: 1533m

configs tested: 151
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                          haps_hs_defconfig    gcc-16.2.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                       footbridge_defconfig    gcc-16.2.0
arm                         neponset_defconfig    gcc-16.2.0
arm                          orion5x_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261117    gcc-16.2.0
arm64                 randconfig-1001-20261117    gcc-16.2.0
arm64                 randconfig-1002-20261117    gcc-16.2.0
arm64                 randconfig-1003-20261117    gcc-16.2.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261117    gcc-16.2.0
csky                  randconfig-1001-20261117    gcc-16.2.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261117    clang-17
hexagon               randconfig-1001-20261117    clang-17
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261117    clang-22
i386        buildonly-randconfig-1001-20261117    clang-22
i386        buildonly-randconfig-1002-20261117    clang-22
i386        buildonly-randconfig-1003-20261117    clang-22
i386        buildonly-randconfig-1004-20261117    clang-22
i386        buildonly-randconfig-1005-20261117    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261117    gcc-14
i386                  randconfig-1001-20261117    gcc-14
i386                  randconfig-1002-20261117    gcc-14
i386                  randconfig-1003-20261117    gcc-14
i386                  randconfig-1004-20261117    gcc-14
i386                  randconfig-1005-20261117    gcc-14
i386                  randconfig-1006-20261117    gcc-14
i386                  randconfig-1007-20261117    clang-22
i386                  randconfig-1008-20261117    clang-22
i386                  randconfig-1009-20261117    clang-22
i386                  randconfig-1010-20261117    clang-22
i386                  randconfig-1011-20261117    clang-22
i386                  randconfig-1012-20261117    clang-22
i386                  randconfig-1013-20261117    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261117    clang-17
loongarch             randconfig-1001-20261117    clang-17
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            xway_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261117    clang-17
nios2                 randconfig-1001-20261117    clang-17
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                      mpc83xx_defconfig    gcc-16.2.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           sdk7780_defconfig    gcc-16.2.0
sh                      sh7710voipgw_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261117    gcc-15.3.0
sparc                 randconfig-1001-20261117    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261117    gcc-15.3.0
sparc64               randconfig-1001-20261117    gcc-15.3.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261117    gcc-15.3.0
um                    randconfig-1001-20261117    gcc-15.3.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261117    clang-22
x86_64                randconfig-1001-20261117    clang-22
x86_64                randconfig-1002-20261117    clang-22
x86_64                randconfig-1003-20261117    clang-22
x86_64                randconfig-1004-20261117    clang-22
x86_64                randconfig-1005-20261117    clang-22
x86_64                randconfig-1006-20261117    gcc-14
x86_64                randconfig-1007-20261117    gcc-14
x86_64                randconfig-1008-20261117    gcc-14
x86_64                randconfig-1009-20261117    gcc-14
x86_64                randconfig-1010-20261117    gcc-14
x86_64                randconfig-1011-20261117    gcc-14
x86_64                randconfig-1012-20261117    gcc-14
x86_64                randconfig-1013-20261117    gcc-14
x86_64                randconfig-1014-20261117    gcc-14
x86_64                randconfig-1015-20261117    gcc-14
x86_64                randconfig-1016-20261117    gcc-14
x86_64                randconfig-1017-20261117    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261117    gcc-15.3.0
xtensa                randconfig-1001-20261117    gcc-15.3.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

