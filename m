Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF690606A331
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QJmOyMJ0
Received: by kanga.kvack.org (Postfix)
	id D05376B05B3; Fri, 27 Nov 2026 10:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D336B05B4; Fri, 27 Nov 2026 10:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E2E6B05B5; Fri, 27 Nov 2026 10:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 831CB6B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:25:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0955DC0427
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:25:05 +0000 (UTC)
X-FDA: 85481272170.16.4A1AD8D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DDD7140007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:25:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QJmOyMJ0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795793103;
	b=ASuWlzYtY6wn3i63SYoL6mykmvnDbH6oVsdd31gewqkJcutZmNeg8KaKi7gm8qw7CJtfF3
	3JTembVeSttQPgXZRsgC8XGUFihEn1jMt9QUDd8SfEmICRNZh5xgmzzfamHojDSf7eC1Jc
	Vv58+n83pEdnlGZPsJuiqyAAYJp9st0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795793103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=1mcpyVzHqYHf/irQ+rML4qhzdQI5nXMqLwZKTZc94xQ=;
	b=4zSMDfmK8urEIaAlRsaf1P+n6iEKzS+krr2kelyZP4g80yDbVrHjDX1mKSW81P9X1XdSqv
	2+Urq128wY+Pt2CFORYxMKtOn3lr98wNxvDBGgFvMt76L01es+ZwTWMgQ+sZKr3z9RzNqE
	QN1mmjDVirZi1p4XSKsUN0+gWhLIpp8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QJmOyMJ0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795793103; x=1827329103;
  h=date:from:to:cc:subject:message-id;
  bh=JXkMHQD6qfeJI/R0CBmftUyhizhiRRmiyHvBDbaDquQ=;
  b=QJmOyMJ0zWwgJz32LsiacnSxypA05bY0W3UVO0v7vcuagRWYriRnmgfL
   hEz3CL9SvuQGx8cI0+vPL2Ka6hVMnPafiL0jI4XOOAwgFPswYNMFfgQgz
   /2L0KErdp1Ki2PsulIxYpPFgk8r2pJIWzMEoL+iHNBF23YzKs1kdrOBj6
   KxLjFNcokwPcUj+NteTREszrJlaHhHbvmLbdVqaBNnfQVEtQLZm7EN76h
   9y6avni4oep6YKgOI7SG+5n6ebxopTW+ZsfluRTXgWrpCVgY2wPVFKwvU
   el9ZLyIPIESwvT4JcZXSf215Qrhax3OzKgq2Ed+5LXUn/W8RFV/gXsral
   g==;
X-CSE-ConnectionGUID: iMGELfz4SgSpXe5WzIu0Nw==
X-CSE-MsgGUID: f6cv5xrKQQe0AnHBZkWJXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11979"; a="4705714"
X-IronPort-AV: E=Sophos;i="6.27,237,1787036400"; 
   d="scan'208";a="4705714"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 07:24:51 -0800
X-CSE-ConnectionGUID: x87V4/S6RmWFeRzqeWINWQ==
X-CSE-MsgGUID: GEE7iC0FQziV82omALfJ8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,237,1787036400"; 
   d="scan'208";a="12411725"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 27 Nov 2026 07:24:50 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWxoc-00000001WHe-3Yh3;
	Fri, 27 Nov 2026 15:24:46 +0000
Date: Fri, 27 Nov 2026 23:24:32 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 a9c48428cbd8d96b26f92631d0db6f8519c5fcc5
Message-ID: <20261127232432.YibRcsS8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 6DDD7140007
X-Stat-Signature: 1fb5d6gxjgib57jd45rq763dun4jyue5
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795793102-383967
X-HE-Meta: U2FsdGVkX1+kmaodTUmxfNQX6W03zi/b1HwX0xJPN7v47OWfwOca75ih4/A7UpUNQtQTF6GX2a0p1s2zq1b/7KmaKdeP2qD05G5kqel6No3im35fB54Bw4gO+z9/mDMTMGqITSu6SR6HIflL5qStuPxJ+RIehatFgoLriNNoKUZzn/f9wnKSp+rZIFqeDswj5ZSnXyTKioPlYU8IOOmbe0BkKhXGdLdGQoTREAFTqoO4nDdJ6/naySlSVlRKNeUkb0hR5sPS2aWde0rHhhdGQ84VkiASF6DooGcRWRm4LSUqckBrI0bMhcvagGM8PEiaM60Y2j3ou5KviGBuzVAc9daI3+dzVwhk02oUgHiJqwYYzQg3SY/ETtAtlDZf/KwOZAoDZAb+PREcNXPaCcR/AZngB0g3xt8FrBjNzY9drQKM4xi276Tsl8qMsf7DqnxwrXDCn1qOGC7YNFhM61lMsGF3Xq0Uren0DvtuXDpdBmc2AXP4ZGTeTRd4QwvlA1OZ54J/89Q5el48bJef13t/ot7EUcSk0QRfHghhKytS7jcoYD1iw3sLI0TfIstKbRFgrIGZr9EZWaUGHJP2pjK9mlwI17Zbj8dM7Yg3J1tmaCJ3p+BORl9+ewKUkb8HeSxjM6hGktVmZ5f8L+ZeUp6VDNqLvtpFD4b4LmE/BRIzTNmeM+BspKiHUILDIaKNFnd/sMy6BT6kkSM09gm2U2wqVC1PjinqanNg21vFILI59tmX17jZBKLaZV6OjkGAOwb28bGpSwo4l/dbVITCdRJjJOZmkPfYDDxSiGB708Lkav5G6BfRS/WFiYwh+novjyOFoKcGIhbQkKDWE6vuJxftWaeFd8KlHeJPUjpkw7Utk6pZG2ULy+UEFDdYXab1l2+zmv7csJa1YPD9r0vY0Aoz7xk4UDVz6y6T8mkOI7PljQpjUG6CAHp0Nu1WB8cdsIg8bgOsVdIsEwNaWyxSqAJ
 HpMowrQo
 cB9aSCzPuIsWDQCqvR4djODT8T61Dob80aEs8PC7G5UdT+hbILAHFH27zRjzGFet/tv5B5p+NXYtADb/+7Lv18m5bU4XdBuGC77lorox3xBDVTtzyYyHJw2YXba+HlwoXGyQHa5JplaUJsHHQ55wOAcL+ev3dfLmaAW5dgUHzFa2GFK0ZQgyJxzVaL3V8MpuWkN6PMyTbgdv+Gyw5yYrErCPKam96GgKldOV+snr8k4Gab+Q3SvRWiGIrZKbaHKOC8J228zhUZ2sh+u2ns7lf1ZyKB75PKcGUSsG491gmtQCtViGgMkr37+xOl6T9SmZS4M+0vN0MvgdK5avo2ExbuCLlpHTp8JSGl9ct3Y/Vn7bctmAAOWuulAvSMe2EfG3AQuwiocCBDIoBblq6pFWCn+5CADoxSunN8XhgRJeTKfbOoeUteVaHl/EwbObltASCvR6BNFG6yB0MYf9NIkCdtR+92eXcfzdStO8P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: a9c48428cbd8d96b26f92631d0db6f8519c5fcc5  Add linux-next specific files for 20261126

elapsed time: 1143m

configs tested: 341
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261126    gcc-15.3.0
alpha                 randconfig-2001-20261126    gcc-13.5.0
alpha                 randconfig-2200-20261126    gcc-9.5.0  smatch
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261127    gcc-8.5.0
arc                   randconfig-1001-20261127    gcc-8.5.0
arc                   randconfig-2000-20261126    gcc-11.5.0
arc                   randconfig-2001-20261126    gcc-8.5.0
arc                   randconfig-2002-20261126    gcc-8.5.0
arc                   randconfig-2003-20261126    gcc-9.5.0
arc                   randconfig-2004-20261126    gcc-15.3.0
arc                   randconfig-2005-20261126    gcc-9.5.0
arc                   randconfig-2200-20261126    gcc-8.5.0  smatch
arc                  randconfig-r2103-20261126    gcc-10.5.0 cocci
arc                  randconfig-r2305-20261126    gcc-16.2.0 sparse
arc                  randconfig-r2310-20261126    gcc-9.5.0  sparse
arc                  randconfig-r2311-20261126    gcc-15.3.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261127    gcc-8.5.0
arm                   randconfig-1001-20261127    gcc-8.5.0
arm                   randconfig-1002-20261127    gcc-8.5.0
arm                   randconfig-1003-20261127    gcc-8.5.0
arm                   randconfig-2000-20261126    gcc-8.5.0
arm                   randconfig-2001-20261126    gcc-11.5.0
arm                   randconfig-2002-20261126    gcc-13.5.0
arm                   randconfig-2200-20261126    gcc-8.5.0  smatch
arm                  randconfig-r2105-20261126    clang-17   cocci
arm                  randconfig-r2107-20261126    clang-17   cocci
arm                  randconfig-r2108-20261126    clang-24   cocci
arm                  randconfig-r2300-20261126    clang-24   sparse
arm                  randconfig-r2308-20261126    clang-17   sparse
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261127    gcc-8.5.0
arm64                 randconfig-1001-20261127    gcc-8.5.0
arm64                 randconfig-1002-20261127    gcc-8.5.0
arm64                 randconfig-1003-20261127    gcc-8.5.0
arm64                 randconfig-2000-20261126    clang-24
arm64                 randconfig-2001-20261126    clang-20
arm64                 randconfig-2002-20261126    clang-24
arm64                 randconfig-2200-20261126    clang-24   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261127    gcc-8.5.0
csky                  randconfig-1001-20261127    gcc-8.5.0
csky                  randconfig-2000-20261126    gcc-16.2.0
csky                  randconfig-2001-20261126    gcc-13.5.0
csky                  randconfig-2200-20261126    gcc-13.5.0 smatch
csky                  randconfig-2200-20261127    gcc-16.2.0 smatch
csky                 randconfig-r2304-20261126    gcc-12.5.0 sparse
csky                 randconfig-r2307-20261126    gcc-16.2.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261127    gcc-9.5.0
hexagon               randconfig-1001-20261127    gcc-9.5.0
hexagon               randconfig-2000-20261126    clang-24
hexagon               randconfig-2001-20261126    clang-17
hexagon               randconfig-2200-20261126    clang-17   smatch
hexagon              randconfig-r2104-20261126    gcc-8.5.0  cocci
hexagon              randconfig-r2303-20261126    gcc-12.5.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261127    clang-22
i386        buildonly-randconfig-1001-20261127    clang-22
i386        buildonly-randconfig-1002-20261127    clang-22
i386        buildonly-randconfig-1003-20261127    clang-22
i386        buildonly-randconfig-1004-20261127    clang-22
i386        buildonly-randconfig-1005-20261127    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261127    clang-22
i386                  randconfig-1001-20261127    clang-22
i386                  randconfig-1002-20261127    clang-22
i386                  randconfig-1003-20261127    clang-22
i386                  randconfig-1004-20261127    clang-22
i386                  randconfig-1005-20261127    clang-22
i386                  randconfig-1006-20261127    clang-22
i386                  randconfig-2000-20261126    clang-22
i386                  randconfig-2001-20261126    clang-22
i386                  randconfig-2002-20261126    clang-22
i386                  randconfig-2003-20261126    gcc-14
i386                  randconfig-2004-20261126    clang-22
i386                  randconfig-2005-20261126    clang-22
i386                  randconfig-2100-20261126    clang-22   cocci
i386                  randconfig-2101-20261126    clang-22   cocci
i386                  randconfig-2102-20261126    gcc-14     cocci
i386                  randconfig-2103-20261126    gcc-12     cocci
i386                  randconfig-2104-20261126    clang-22   cocci
i386                  randconfig-2105-20261126    gcc-14     cocci
i386                  randconfig-2200-20261126    gcc-14     smatch
i386                  randconfig-2300-20261126    gcc-14     sparse
i386                  randconfig-2301-20261126    clang-22   sparse
i386                  randconfig-2302-20261126    gcc-14     sparse
i386                 randconfig-r2102-20261126    clang-22   cocci
i386                 randconfig-r2302-20261126    gcc-14     sparse
i386                 randconfig-r2305-20261126    gcc-12.5.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    gcc-16.2.0
loongarch             randconfig-1000-20261127    gcc-9.5.0
loongarch             randconfig-1001-20261127    gcc-9.5.0
loongarch             randconfig-2000-20261126    gcc-12.5.0
loongarch             randconfig-2001-20261126    clang-18
loongarch             randconfig-2001-20261126    gcc-12.5.0
loongarch             randconfig-2200-20261126    gcc-14.4.0 smatch
loongarch            randconfig-r2105-20261126    clang-24   cocci
loongarch            randconfig-r2109-20261126    clang-24   cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5272c3_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261126    gcc-8.5.0
m68k                  randconfig-2001-20261126    gcc-8.5.0
m68k                  randconfig-2200-20261126    gcc-8.5.0  smatch
m68k                  randconfig-2200-20261127    gcc-9.5.0  smatch
m68k                 randconfig-r2104-20261126    gcc-8.5.0  cocci
microblaze                        alldefconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261126    gcc-15.3.0
microblaze            randconfig-2001-20261126    gcc-8.5.0
microblaze            randconfig-2200-20261126    gcc-9.5.0  smatch
microblaze           randconfig-r2105-20261126    gcc-8.5.0  cocci
microblaze           randconfig-r2106-20261126    gcc-8.5.0  cocci
microblaze           randconfig-r2107-20261126    clang-24   cocci
microblaze           randconfig-r2111-20261126    clang-24   cocci
microblaze           randconfig-r2111-20261126    gcc-8.5.0  cocci
microblaze           randconfig-r2301-20261126    gcc-12.5.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                     maltaup_xpa_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261126    gcc-8.5.0
mips                  randconfig-2001-20261126    gcc-15.3.0
mips                  randconfig-2002-20261126    gcc-9.5.0
mips                 randconfig-r2100-20261126    clang-17   cocci
mips                 randconfig-r2101-20261126    gcc-8.5.0  cocci
mips                 randconfig-r2110-20261126    clang-24   cocci
mips                          rt305x_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261127    gcc-9.5.0
nios2                 randconfig-1001-20261127    gcc-9.5.0
nios2                 randconfig-2000-20261126    gcc-11.5.0
nios2                 randconfig-2000-20261126    gcc-12.5.0
nios2                 randconfig-2001-20261126    gcc-12.5.0
nios2                 randconfig-2001-20261126    gcc-9.5.0
nios2                 randconfig-2200-20261126    gcc-9.5.0  smatch
nios2                randconfig-r2101-20261126    gcc-8.5.0  cocci
nios2                randconfig-r2300-20261126    gcc-12.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261126    gcc-16.2.0
openrisc              randconfig-2001-20261126    gcc-13.5.0
openrisc              randconfig-2002-20261126    gcc-16.2.0
openrisc              randconfig-2200-20261126    gcc-9.5.0  smatch
openrisc             randconfig-r2302-20261126    gcc-12.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261127    gcc-12.5.0
parisc                randconfig-1001-20261127    gcc-12.5.0
parisc                randconfig-2000-20261126    gcc-12.5.0
parisc                randconfig-2000-20261126    gcc-8.5.0
parisc                randconfig-2001-20261126    gcc-12.5.0
parisc                randconfig-2001-20261126    gcc-8.5.0
parisc                randconfig-2200-20261126    gcc-15.3.0 smatch
parisc               randconfig-r2103-20261126    gcc-16.2.0 cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261127    gcc-12.5.0
powerpc               randconfig-1001-20261127    gcc-12.5.0
powerpc               randconfig-2000-20261126    clang-24
powerpc               randconfig-2001-20261126    clang-17
powerpc               randconfig-2002-20261126    clang-24
powerpc               randconfig-2200-20261126    clang-24   smatch
powerpc              randconfig-r2102-20261126    gcc-8.5.0  cocci
powerpc              randconfig-r2301-20261126    clang-18   sparse
powerpc              randconfig-r2306-20261126    gcc-8.5.0  sparse
powerpc                      tqm8560_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261127    gcc-12.5.0
powerpc64             randconfig-1001-20261127    gcc-12.5.0
powerpc64             randconfig-2000-20261126    clang-17
powerpc64             randconfig-2001-20261126    gcc-10.5.0
powerpc64             randconfig-2002-20261126    clang-21
powerpc64             randconfig-2200-20261126    clang-24   smatch
powerpc64            randconfig-r2104-20261126    clang-24   cocci
powerpc64            randconfig-r2108-20261126    clang-24   cocci
powerpc64            randconfig-r2109-20261126    gcc-16.2.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261127    gcc-12.5.0
riscv                 randconfig-1001-20261127    gcc-12.5.0
riscv                 randconfig-2000-20261126    gcc-10.5.0
riscv                 randconfig-2001-20261126    clang-24
riscv                 randconfig-2002-20261126    clang-20
riscv                 randconfig-2003-20261126    gcc-16.2.0
riscv                 randconfig-2004-20261126    gcc-10.5.0
riscv                 randconfig-2005-20261126    clang-24
riscv                 randconfig-2200-20261126    gcc-8.5.0  smatch
riscv                randconfig-r2106-20261126    clang-24   cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261127    gcc-12.5.0
s390                  randconfig-1001-20261127    gcc-12.5.0
s390                  randconfig-2000-20261126    clang-18
s390                  randconfig-2000-20261126    clang-24
s390                  randconfig-2001-20261126    clang-24
s390                  randconfig-2001-20261126    gcc-8.5.0
s390                  randconfig-2002-20261126    clang-24
s390                  randconfig-2003-20261126    clang-18
s390                  randconfig-2003-20261126    clang-24
s390                  randconfig-2004-20261126    clang-24
s390                  randconfig-2004-20261126    gcc-10.5.0
s390                  randconfig-2005-20261126    clang-21
s390                  randconfig-2005-20261126    clang-24
s390                  randconfig-2200-20261126    gcc-16.2.0 smatch
s390                  randconfig-2200-20261127    clang-18   smatch
s390                 randconfig-r2102-20261126    gcc-8.5.0  cocci
s390                 randconfig-r2110-20261126    gcc-9.5.0  cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261127    gcc-12.5.0
sh                    randconfig-1001-20261127    gcc-12.5.0
sh                    randconfig-2000-20261126    gcc-16.2.0
sh                    randconfig-2000-20261126    gcc-9.5.0
sh                    randconfig-2001-20261126    gcc-13.5.0
sh                    randconfig-2001-20261126    gcc-9.5.0
sh                    randconfig-2002-20261126    gcc-11.5.0
sh                    randconfig-2002-20261126    gcc-9.5.0
sh                    randconfig-2003-20261126    gcc-9.5.0
sh                    randconfig-2004-20261126    gcc-16.2.0
sh                    randconfig-2004-20261126    gcc-9.5.0
sh                    randconfig-2005-20261126    gcc-16.2.0
sh                    randconfig-2005-20261126    gcc-9.5.0
sh                    randconfig-2200-20261126    gcc-16.2.0 smatch
sh                   randconfig-r2103-20261126    gcc-8.5.0  cocci
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261127    gcc-14
sparc                 randconfig-1001-20261127    gcc-14
sparc                 randconfig-2000-20261126    gcc-8.5.0
sparc                 randconfig-2001-20261126    gcc-13.5.0
sparc                 randconfig-2200-20261126    gcc-13.5.0 smatch
sparc                randconfig-r2101-20261126    gcc-13.5.0 cocci
sparc                randconfig-r2303-20261126    gcc-11.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261127    gcc-14
sparc64               randconfig-1001-20261127    gcc-14
sparc64               randconfig-2000-20261126    clang-24
sparc64               randconfig-2001-20261126    gcc-8.5.0
sparc64               randconfig-2200-20261126    gcc-12.5.0 smatch
sparc64              randconfig-r2100-20261126    gcc-10.5.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261127    gcc-14
um                    randconfig-1001-20261127    gcc-14
um                    randconfig-2000-20261126    clang-17
um                    randconfig-2001-20261126    clang-17
um                    randconfig-2200-20261126    gcc-12     smatch
um                   randconfig-r2309-20261126    clang-22   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261127    gcc-14
x86_64      buildonly-randconfig-1001-20261127    gcc-14
x86_64      buildonly-randconfig-1002-20261127    gcc-14
x86_64      buildonly-randconfig-1003-20261127    gcc-14
x86_64      buildonly-randconfig-1004-20261127    gcc-14
x86_64      buildonly-randconfig-1005-20261127    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261127    gcc-14
x86_64                randconfig-1001-20261127    gcc-14
x86_64                randconfig-1002-20261127    gcc-14
x86_64                randconfig-1003-20261127    gcc-14
x86_64                randconfig-1004-20261127    gcc-14
x86_64                randconfig-1005-20261127    gcc-14
x86_64                randconfig-2000-20261126    clang-22
x86_64                randconfig-2001-20261126    gcc-14
x86_64                randconfig-2002-20261126    clang-22
x86_64                randconfig-2003-20261126    clang-22
x86_64                randconfig-2004-20261126    clang-22
x86_64                randconfig-2005-20261126    clang-22
x86_64                randconfig-2200-20261126    clang-22   smatch
x86_64                randconfig-2300-20261126    gcc-12     sparse
x86_64                randconfig-2301-20261126    gcc-14     sparse
x86_64                randconfig-2302-20261126    gcc-14     sparse
x86_64               randconfig-r2100-20261126    gcc-8.5.0  cocci
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261127    gcc-14
xtensa                randconfig-1001-20261127    gcc-14
xtensa                randconfig-2000-20261126    gcc-13.5.0
xtensa                randconfig-2001-20261126    gcc-15.3.0
xtensa                randconfig-2200-20261126    gcc-11.5.0 smatch

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

