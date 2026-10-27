Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EB7606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WT+zS295
Received: by kanga.kvack.org (Postfix)
	id D110B6B05E5; Tue, 27 Oct 2026 12:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1A96B05E8; Tue, 27 Oct 2026 12:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEF06B05EA; Tue, 27 Oct 2026 12:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 954ED6B05E5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:42:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BD8F160AA9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:42:01 +0000 (UTC)
X-FDA: 85368973242.29.B7CC4E1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E001C0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:41:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WT+zS295;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=U2+NgVVulxRc8ahHRVCwgPRTd6JNZHZQ/ltArk8SrNU=;
	b=FTDm60RC87YIunJLF4YV5oLNl6S6mjvh/06MhnCMGUjFJ6Moi5Serl2k42fcTaD4olMHeE
	tMG/WfBhDtb/RQv5GVWWtBNKcpmfq6yWdo3kd8G2W+RFQa+VXUB15KK90nWWjDDY4+Ric6
	y1GJ3kZsKEGiXHGgroCchhIn4wTELp0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WT+zS295;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119319;
	b=LQLEYW98wNNUW30mmqA5dlH9mi1uLShUIE7r1eUMJ03PqOrw9WRkhJFZ22rNykkJqj+tEM
	qsXiOPx1orA1duBZf8bSdiwAgi4nu2ZeEzwEqGb5TwCzK5BjlWtu1a4w1gZJ/GhoafImXZ
	6lRM1A3HFBcxEW2t8JfNPDcsl5YpRL0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793119319; x=1824655319;
  h=date:from:to:cc:subject:message-id;
  bh=dFfn4QXTGS2lBVup7ty5eBIeHER8pfxxsVUC3O+sdRc=;
  b=WT+zS295v9yIUGlOJ4qQ3tjaa7d+Pi6QMBA+fU5oxYITi4e34Gd1xo3p
   9JUVxY8Are13foSWUNtwHbv45pDRRyFD5BnFwnK6FsKpslBv+9Pmkwr9u
   F4iz94cxQXgzwqaMrVPmiRZENjY0+TZZqWEgxnypYjhbXWsS7QfmWeH0W
   zjyudWKSU61GYMRjqU3xW/DJmhXzz3PNoGuytUwTtcvtkk35HQXLhnN7q
   RvC4Dtq3ooQlidtjN87V3RgyfL7uhWcEoLVg/ESfqL2nh/SQ+cAs4O8Nr
   niBlVlBUqMVoybxuRE7UUHHhRksZ6d/6Nwx9GU9fN7oyd86lmuUuWy9m4
   g==;
X-CSE-ConnectionGUID: h/QSAlyzQr2OmmwSe4/CcA==
X-CSE-MsgGUID: Wm1JZ3oYSwy6HU/XdwsObw==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1839928"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1839928"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 09:41:57 -0700
X-CSE-ConnectionGUID: 2RfWKlaxRdy4e0fCjvk7pA==
X-CSE-MsgGUID: MnMWm26dTyK9r5CwQ84gHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="4931352"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 27 Oct 2026 09:41:56 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLkFF-00000000XVU-0Ft5;
	Tue, 27 Oct 2026 16:41:53 +0000
Date: Wed, 28 Oct 2026 00:41:16 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7bf01f16a4d05028fbeff4d90bab40df25142a24
Message-ID: <202610280012.QUR2Xaq7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E001C0003
X-Stat-Signature: zcqp4atp9fciz5rxe6gu19b169cnsosq
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793119318-478988
X-HE-Meta: U2FsdGVkX18EUOYBmNQ7CNAxhNu5fn+ia0M3I0rrmPkoGnrObPuNJzu4bSjxgFcXHLaO7BDd8v6ydC/mgpuhQrNyC/Vm9EGqYSScxyxW54nu8wnwPMHamUYdba4QIro7J7r1W9LYdnBZRPcMcDNc4BU+SkGmz6Wx0jwqxgTa51lhGJVmk9C0i/R/nwq5a0vXSHERGsgvEcfC2jX6LaNoMfVqWnSydNtskTOLG9pwMrojRujQ+h/mNYNWRex/c3DPL8C8gH9Itxie9oYQtAil8HBPufhN2JxB5lf6iBhy0SFiOoTrrxvBQOH84yTpHs6eUPfdyhxpBAh3M+o1dXozgisTC3wePPnQCOrWSTdrx/S4briyZN+QDos3gouleLGPTlNLWWwOzNyMBqjGOmdJ5n57MBs++5c4vcDr1bxS44NWd0MGs5PNDpV5vQyYq80c6OoB0DlZSHgR+2ntoPiU7V2R+jZyGWpsmePUVCM1bLxzUsrLxfe+SAsTuHSQhW59pDIrxGsEIVvOiAQy4BZgIJsb/pCbhr1iARdBMXQADijKeVJ9/LqCz5dMd11sXlBCxzGUXiIK1ysdQvNAAtx9uC4mFDM886auQNio+pAhQkYfFf8ZpI/lF8AQKpTZUhBDlE8loGRX/93C3MdGksVmmVJz6J+lONv9q/fUFem698/Y20zSd0Bq0D1jjC2tipCbPq/svIK/460fg+dMMyavTsAERHifXxDdI4ylQS9wdi3g1KGhsW8N9ET6hIFs8AJd1mB3ciouVeohAHXY3AwFMLdZAGS7iedEmO+e1IksTw5WNiSPNjgHJbenZxpcTwItFbceE6tH06tUhD6/jkV1HNbmlHQzUOEBkoLZqH3igzAwjzFzazpcoH/JbUGXXN5r71YP9sV2JQAo/oOp3VzGRS7WEzRE50pe3zmjJDd2LlilbHp679sdmfmfX7FV9A21RiUBLwk877qsbFhFQTf
 FiMLwaAm
 4jy1WmM2UMYrlNORSRY1K23cnIndxhV1EKbZ013F2sM14AjXOkTVSC6lYCDlPPuLYuypcl2bxFFM29U77wJuvcfRH4MTGNw0xtgDsghx3d1otW1wi0O+wadUVJ3bCIrkYFpmcLzoYXMGnW+v+JNDgx0f7+FbWDkX6egacFTyVlTQXtTgAP2UXA85tkDrHw/5M9FPWkQJASQw94OE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7bf01f16a4d05028fbeff4d90bab40df25142a24  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1139m

configs tested: 159
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261027    gcc-10.5.0
arc                   randconfig-1001-20261027    gcc-16.2.0
arm                                allnoconfig    clang-17
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261027    clang-24
arm                   randconfig-1001-20261027    gcc-10.5.0
arm                   randconfig-1002-20261027    gcc-8.5.0
arm                   randconfig-1003-20261027    gcc-10.5.0
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261027    gcc-13.5.0
arm64                 randconfig-1001-20261027    clang-17
arm64                 randconfig-1002-20261027    gcc-8.5.0
arm64                 randconfig-1003-20261027    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261027    gcc-16.2.0
csky                  randconfig-1001-20261027    gcc-16.2.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261027    clang-24
hexagon               randconfig-1001-20261027    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261027    gcc-14
i386        buildonly-randconfig-1001-20261027    gcc-14
i386        buildonly-randconfig-1002-20261027    clang-22
i386        buildonly-randconfig-1003-20261027    gcc-14
i386        buildonly-randconfig-1004-20261027    clang-22
i386        buildonly-randconfig-1005-20261027    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261027    gcc-12
i386                  randconfig-1001-20261027    clang-22
i386                  randconfig-1002-20261027    gcc-14
i386                  randconfig-1003-20261027    gcc-14
i386                  randconfig-1004-20261027    gcc-14
i386                  randconfig-1005-20261027    gcc-12
i386                  randconfig-1006-20261027    clang-22
i386                  randconfig-1007-20261027    gcc-14
i386                  randconfig-1008-20261027    gcc-14
i386                  randconfig-1009-20261027    gcc-14
i386                  randconfig-1010-20261027    clang-22
i386                  randconfig-1011-20261027    gcc-14
i386                  randconfig-1012-20261027    clang-22
i386                  randconfig-1013-20261027    clang-22
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261027    gcc-13.5.0
loongarch             randconfig-1001-20261027    gcc-15.3.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  decstation_r4k_defconfig    gcc-16.2.0
mips                        rbtx49xx_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261027    gcc-8.5.0
nios2                 randconfig-1001-20261027    gcc-8.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261027    gcc-12.5.0
parisc                randconfig-1001-20261027    gcc-10.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                      akebono_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261027    gcc-15.3.0
powerpc               randconfig-1001-20261027    gcc-8.5.0
powerpc                      redwood_defconfig    clang-24
powerpc64             randconfig-1000-20261027    gcc-10.5.0
powerpc64             randconfig-1001-20261027    clang-22
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261027    gcc-15.3.0
riscv                 randconfig-1001-20261027    clang-20
s390                              alldefconfig    gcc-16.2.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261027    gcc-8.5.0
s390                  randconfig-1001-20261027    gcc-9.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261027    gcc-16.2.0
sh                    randconfig-1001-20261027    gcc-16.2.0
sh                           sdk7786_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261027    gcc-14.4.0
sparc                 randconfig-1001-20261027    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261027    clang-20
sparc64               randconfig-1001-20261027    clang-20
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261027    clang-24
um                    randconfig-1001-20261027    clang-20
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261027    clang-22
x86_64      buildonly-randconfig-1001-20261027    gcc-14
x86_64      buildonly-randconfig-1002-20261027    clang-22
x86_64      buildonly-randconfig-1003-20261027    gcc-12
x86_64      buildonly-randconfig-1004-20261027    gcc-14
x86_64      buildonly-randconfig-1005-20261027    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261027    gcc-14
x86_64                randconfig-1001-20261027    gcc-14
x86_64                randconfig-1002-20261027    gcc-14
x86_64                randconfig-1003-20261027    gcc-14
x86_64                randconfig-1004-20261027    clang-22
x86_64                randconfig-1005-20261027    clang-22
x86_64                randconfig-1006-20261027    gcc-14
x86_64                randconfig-1007-20261027    clang-22
x86_64                randconfig-1008-20261027    clang-22
x86_64                randconfig-1009-20261027    gcc-14
x86_64                randconfig-1010-20261027    clang-22
x86_64                randconfig-1011-20261027    gcc-14
x86_64                randconfig-1012-20261027    clang-22
x86_64                randconfig-1013-20261027    clang-22
x86_64                randconfig-1014-20261027    clang-22
x86_64                randconfig-1015-20261027    clang-22
x86_64                randconfig-1016-20261027    clang-22
x86_64                randconfig-1017-20261027    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261027    gcc-8.5.0
xtensa                randconfig-1001-20261027    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

