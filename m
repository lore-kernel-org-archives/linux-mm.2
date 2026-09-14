Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C9EC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382AB6B0096; Mon, 14 Sep 2026 14:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3592E6B0098; Mon, 14 Sep 2026 14:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A3B6B0099; Mon, 14 Sep 2026 14:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAB176B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:13:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7EF61C1BF5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:13:33 +0000 (UTC)
X-FDA: 85213165506.11.54AA9E6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3FFEFC0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:13:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U9HKEtUy;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Zbl+vVXCGmAEfROZEqBLXSo/jdCJbX9fXV8rg+IcYVY=;
	b=mhHWEJELICIrvq61yDL6faBMe4uiZE8NWlGPVqLDJiUqLJ45hemAr7qBeZzYzzAqKmzVol
	7Vw0ihXXvCQilSSjJ4eiw72feK41a+m1z99Bz+fO4m9Dtgh5L89admputvUZ7tUGMkgpR6
	mqwoYeE9Fl+5zbQF3CKm0cbE9Npmt6o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U9HKEtUy;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409612;
	b=7lY+0FBwzSmrgQfbeVQx2WowctlKBlMRmpMvoWzEGZtzFFzsK4R0J2U1X/dnD/UMEFBTe7
	K7kRl7aeAk1A+rMS3dwyeA1601X1qK6Upwm+mbZ9RbVGydwlV3xFUrgRPVabl8o17ec6WZ
	qfzMkdtoJoJ6G97B7PVNtQixLWF24L8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789409612; x=1820945612;
  h=date:from:to:cc:subject:message-id;
  bh=EncH5EY9BbPJtpcRItsL4ARUApf7wSQiaVUWqoE8NHs=;
  b=U9HKEtUyhPxPBAdNdbHdho3WFAKSIXHa9GnOBm+jds9RYwkh/TUAg0W2
   24dsb9iKrJdBnmOZfU0ZhplP4aPa64swUaaPNMbbHikQu7OmO3wCEb2M5
   5WfXYO7d/5pHDcjsgSOsl8CB19UkXR3EN1gIzxYaSI9cdCvOrm4a/rnmG
   224dZLSZgrWW3W+sk3kzL0V1R9Zjhgy7QZNdDEzcGg9JiRtdE5Zghm/l8
   GBtRkpD7XNjhVUfiDfwca9wTC182qvSz2PaJtwRwMZSTVlJONqcDd2All
   egB6eFKemXZaOZ4rgAWSTdSJQNNMgdpP17oMzMjU7OFP5EOGmV8xypq1b
   A==;
X-CSE-ConnectionGUID: /c191ktDQdSsNFML3sFRvA==
X-CSE-MsgGUID: JHRvMHaJQ4Wsy4BhLESgcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="271577"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="271577"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 11:13:30 -0700
X-CSE-ConnectionGUID: cfJoBVLtSXieZ9zVWIJJ3Q==
X-CSE-MsgGUID: hzc3/Q2cS9+yoLE6RTJvVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="270079246"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 14 Sep 2026 11:13:28 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6BBG-000000003KX-0MbO;
	Mon, 14 Sep 2026 18:13:26 +0000
Date: Tue, 15 Sep 2026 02:12:25 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 68142f986ff04b2b70b31db00f719bf690f64a9a
Message-ID: <202609150222.0YOc8UAe-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3FFEFC0009
X-Stat-Signature: qpkp1pehcnt9xeafec39q74hpdnkcry6
X-Rspam-User: 
X-HE-Tag: 1789409610-242383
X-HE-Meta: U2FsdGVkX1+vf6N/gtsjlT0J7Tv3ks5E8TdfptiN/ujAyNbfDxD/8SqChKSzvesIIp48v9aZUByvp6RtyFtzUSLX816X4ndLrSUaTbH+CfYWU80ldgM/obXiUdRRn0C3cDt26wWim/rxxVctK/DEQzbB8okTup2MPLpQgICrdh4bhqOBBoQ3Qx3BXtpWmLVHSo/tdz7lDAwFsg2XDMXtpZgm7BoYH9hU06dm3TbrivOInbCG6sN8VKvk+eGC/EwSjlk3NJz0SKlWzBC/TnQqHPN/Wda7aowa9lfVUmn61F6P5JQiRcjKpR7zPctjx9M+rwM4Lk/DEBuPRRZmh/4Z+NjD7srg8BRqSkNcsCiGmT0gSSKf7puZXqD5RPZh35EdyijQlpy7VuMS/KvHSwO13g2bqHs2g2ccypEsIpC6b4+XWx0mGmebn4nL1XWvggJjRseYvZaHOy7JNjLNDqK5qI0NE467DK0uCaE8xK1UaF+kS21cZ4L69le23XuD4oX9Z2yX5iOuczSzXsXKK2h4KjpoPXtE44OUBcT9787qoQ7sLwn3DFaUCnGpR4s98wV0+LpsoUbf4G88YW7ggsANRxn793gQ9ucmTtdMZPjxwhLclhQAkaB4/8v2iReODxIhneoIKuMSt+MN5fGzEuIoc3fYb219lRJ85Z02D/gMArhkOmQmBttUzvb/5vyt/UH2GQOIw3Jxc/QWPddCEtbzRnof0PXp9Y01phwl4o0V1VdQ3lLuPLSEMypB0C306LZHLhLB7cIkx5JzC3osVhV7aXilmC+LC5zILLaTjiYBGAsbOERZHZIS3oqxkG4GYmg7s7dzvhIqGtU8tEJ09dCNfYLpAXLQJcxDz0D6FYe733tySihky/j2toGle0plbXVxQEC0NFWKEi9Du6SETDQPBiY2rYdm4/clBVXw+Tpn4ADC3JEZuQomsTMtdlYw9o8LVeyVl5PfoANf3vJZDIb
 YRgt4GO6
 iz1tMy5q6+o5jePChVytPz/g61FZ5wHKA19FNZQ/xZTH0KT+HZ79zSB1AonrAi1y1KK2RBzAG185ClYrF01AxC+VE2Vx3Y6hXZ0YYo29ttyT6zoYJjaoDYZAFBOfkh/8ACpr4uXZwbAiIQujSCBWBRqoRkAxkLwMeGFW1z/08aLluhY6IA+iclLr3tvJz6NLNuAMCsf1E2QO2Wzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 68142f986ff04b2b70b31db00f719bf690f64a9a  Add linux-next specific files for 20260911

Error/Warning (recently discovered and may have been fixed):

    drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_connector.c:3690:23: warning: 'parse_edid_cea' defined but not used [-Wunused-function]

Unverified Error/Warning (likely false positive, kindly check if interested):

    Warning: drivers/usb/host/octeon-hcd.c:381 struct member 'sof_timer' not described in 'octeon_hcd'
    drivers/scsi/ipr.c:3202:1: internal compiler error: in final_scan_insn_1, at final.c:3074

Error/Warning ids grouped by kconfigs:

recent_errors
|-- csky-randconfig-002-20260914
|   `-- drivers-scsi-ipr.c:internal-compiler-error:in-final_scan_insn_1-at-final.c
|-- mips-cavium_octeon_defconfig
|   `-- Warning:drivers-usb-host-octeon-hcd.c-struct-member-sof_timer-not-described-in-octeon_hcd
`-- x86_64-randconfig-014-20260914
    `-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm_connector.c:warning:parse_edid_cea-defined-but-not-used

elapsed time: 2608m

configs tested: 376
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r123-20260914    gcc-8.5.0 sparse
alpha                randconfig-r132-20260914    gcc-12.5.0 sparse
arc                              alldefconfig    gcc-16.1.0
arc                              allmodconfig    clang-24
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                              allyesconfig    gcc-16.1.0
arc                      axs103_smp_defconfig    gcc-16.1.0
arc                      axs103_smp_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                         haps_hs_defconfig    clang-24
arc                   randconfig-001-20260913    gcc-8.5.0
arc                   randconfig-001-20260914    gcc-13.4.0
arc                   randconfig-002-20260913    gcc-16.1.0
arc                   randconfig-002-20260914    gcc-13.4.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                              allyesconfig    gcc-16.1.0
arm                         at91_dt_defconfig    clang-17
arm                     davinci_all_defconfig    clang-17
arm                                 defconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                          gemini_defconfig    gcc-16.1.0
arm                            mps2_defconfig    clang-24
arm                   randconfig-001-20260913    gcc-8.5.0
arm                   randconfig-001-20260914    gcc-13.4.0
arm                   randconfig-002-20260913    clang-17
arm                   randconfig-002-20260914    gcc-13.4.0
arm                   randconfig-003-20260913    clang-17
arm                   randconfig-003-20260914    gcc-13.4.0
arm                   randconfig-004-20260913    gcc-10.5.0
arm                   randconfig-004-20260914    gcc-13.4.0
arm                  randconfig-r112-20260914    gcc-8.5.0 sparse
arm                  randconfig-r134-20260914    gcc-8.5.0 sparse
arm                         socfpga_defconfig    gcc-16.1.0
arm                        spear3xx_defconfig    clang-24
arm                           stm32_defconfig    gcc-16.1.0
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
arm64                randconfig-r122-20260914    gcc-8.5.0 sparse
arm64                randconfig-r131-20260914    clang-24 sparse
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260913    gcc-16.1.0
csky                  randconfig-001-20260914    gcc-9.5.0
csky                  randconfig-002-20260913    gcc-16.1.0
csky                  randconfig-002-20260914    gcc-9.5.0
hexagon                          allmodconfig    clang-24
hexagon                           allnoconfig    clang-24
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-24
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260913    clang-17
hexagon               randconfig-001-20260914    gcc-13.4.0
hexagon               randconfig-002-20260913    clang-24
hexagon               randconfig-002-20260914    gcc-13.4.0
hexagon              randconfig-r133-20260914    gcc-12.5.0 sparse
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
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
i386                  randconfig-061-20260914    gcc-14 sparse
i386                  randconfig-062-20260914    gcc-14 sparse
i386                  randconfig-063-20260914    gcc-14 sparse
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
loongarch            randconfig-r131-20260914    gcc-12.5.0 sparse
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                             allyesconfig    gcc-16.1.0
m68k                          amiga_defconfig    gcc-16.1.0
m68k                                defconfig    clang-24
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze                          defconfig    gcc-16.1.0
microblaze                      mmu_defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-24
mips                  cavium_octeon_defconfig    gcc-16.1.0
mips                         db1xxx_defconfig    gcc-16.1.0
mips                     decstation_defconfig    gcc-16.1.0
mips                        qi_lb60_defconfig    clang-17
nios2                            allmodconfig    clang-20
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
nios2                randconfig-r131-20260914    gcc-8.5.0 sparse
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-24
openrisc                          allnoconfig    gcc-16.1.0
openrisc                   de0_nano_defconfig    clang-24
openrisc                            defconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260913    gcc-8.5.0
parisc                randconfig-001-20260914    gcc-8.5.0
parisc                randconfig-002-20260913    gcc-9.5.0
parisc                randconfig-002-20260914    gcc-8.5.0
parisc64                            defconfig    clang-24
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-24
powerpc                           allnoconfig    gcc-16.1.0
powerpc                    gamecube_defconfig    clang-19
powerpc                   motionpro_defconfig    clang-24
powerpc                  mpc866_ads_defconfig    clang-24
powerpc                      pasemi_defconfig    clang-24
powerpc               randconfig-001-20260913    clang-24
powerpc               randconfig-001-20260914    gcc-8.5.0
powerpc               randconfig-002-20260913    clang-24
powerpc               randconfig-002-20260914    gcc-8.5.0
powerpc                    socrates_defconfig    clang-24
powerpc64             randconfig-001-20260913    gcc-8.5.0
powerpc64             randconfig-001-20260914    gcc-8.5.0
powerpc64             randconfig-002-20260913    clang-17
powerpc64             randconfig-002-20260914    gcc-8.5.0
powerpc64            randconfig-r133-20260914    gcc-8.5.0 sparse
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
riscv                randconfig-r113-20260914    gcc-8.5.0 sparse
riscv                randconfig-r132-20260914    gcc-8.5.0 sparse
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-24
s390                              allnoconfig    clang-24
s390                              allnoconfig    clang-24
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
sh                                  defconfig    gcc-16.1.0
sh                ecovec24-romimage_defconfig    gcc-16.1.0
sh                               j2_defconfig    gcc-16.1.0
sh                          r7780mp_defconfig    clang-24
sh                          r7780mp_defconfig    gcc-16.1.0
sh                    randconfig-001-20260913    gcc-16.1.0
sh                    randconfig-001-20260914    gcc-13.4.0
sh                    randconfig-002-20260913    gcc-14.3.0
sh                    randconfig-002-20260914    gcc-13.4.0
sh                          rsk7269_defconfig    gcc-16.1.0
sh                      rts7751r2d1_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260913    gcc-8.5.0
sparc                 randconfig-001-20260914    gcc-16.1.0
sparc                 randconfig-002-20260913    gcc-15.2.0
sparc                 randconfig-002-20260914    gcc-16.1.0
sparc                randconfig-r133-20260914    gcc-8.5.0 sparse
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-24
sparc64                             defconfig    clang-24
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260913    clang-21
sparc64               randconfig-001-20260914    gcc-16.1.0
sparc64               randconfig-002-20260913    clang-20
sparc64               randconfig-002-20260914    gcc-16.1.0
sparc64              randconfig-r121-20260914    gcc-8.5.0 sparse
sparc64              randconfig-r134-20260914    gcc-12.5.0 sparse
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-14
um                                  defconfig    clang-24
um                                  defconfig    clang-24
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260913    clang-24
um                    randconfig-001-20260914    gcc-16.1.0
um                    randconfig-002-20260913    clang-24
um                    randconfig-002-20260914    gcc-16.1.0
um                   randconfig-r111-20260914    gcc-8.5.0 sparse
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    clang-24
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-24
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
x86_64                randconfig-003-20260914    gcc-14
x86_64                randconfig-004-20260913    gcc-14
x86_64                randconfig-004-20260914    gcc-14
x86_64                randconfig-005-20260913    gcc-14
x86_64                randconfig-005-20260914    gcc-14
x86_64                randconfig-006-20260913    clang-22
x86_64                randconfig-006-20260914    gcc-14
x86_64                randconfig-011-20260913    gcc-14
x86_64                randconfig-011-20260914    clang-22
x86_64                randconfig-012-20260913    gcc-14
x86_64                randconfig-012-20260914    clang-22
x86_64                randconfig-012-20260914    gcc-14
x86_64                randconfig-013-20260913    clang-22
x86_64                randconfig-013-20260914    clang-22
x86_64                randconfig-013-20260914    gcc-14
x86_64                randconfig-014-20260913    clang-22
x86_64                randconfig-014-20260914    clang-22
x86_64                randconfig-014-20260914    gcc-14
x86_64                randconfig-015-20260913    clang-22
x86_64                randconfig-015-20260914    clang-22
x86_64                randconfig-016-20260913    clang-22
x86_64                randconfig-016-20260914    clang-22
x86_64                randconfig-071-20260913    clang-22
x86_64                randconfig-071-20260914    clang-22
x86_64                randconfig-072-20260913    clang-22
x86_64                randconfig-072-20260914    clang-22
x86_64                randconfig-073-20260913    gcc-14
x86_64                randconfig-073-20260914    clang-22
x86_64                randconfig-074-20260913    gcc-14
x86_64                randconfig-074-20260914    clang-22
x86_64                randconfig-074-20260914    gcc-12
x86_64                randconfig-075-20260913    clang-22
x86_64                randconfig-075-20260914    clang-22
x86_64                randconfig-076-20260913    gcc-13
x86_64                randconfig-076-20260914    clang-22
x86_64                randconfig-121-20260914    gcc-14 sparse
x86_64                randconfig-122-20260914    gcc-14 sparse
x86_64                randconfig-123-20260914    gcc-14 sparse
x86_64               randconfig-r134-20260914    gcc-14 sparse
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                           alldefconfig    clang-24
xtensa                            allnoconfig    clang-24
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                       common_defconfig    gcc-16.1.0
xtensa                randconfig-001-20260913    gcc-13.4.0
xtensa                randconfig-001-20260914    gcc-16.1.0
xtensa                randconfig-002-20260913    gcc-15.2.0
xtensa                randconfig-002-20260914    gcc-16.1.0
xtensa               randconfig-r132-20260914    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

