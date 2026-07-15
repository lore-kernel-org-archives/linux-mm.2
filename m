Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98553C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C8A6B0092; Wed, 15 Jul 2026 00:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDBC6B0093; Wed, 15 Jul 2026 00:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785346B0095; Wed, 15 Jul 2026 00:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38A306B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:22:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 967611C05FC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:22:14 +0000 (UTC)
X-FDA: 84989713788.10.391B0E0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id C617620006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:22:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S16VRBcE;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784089332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rj7YPHT03jZbIOMeN6+aBaVgV/U4EklLIXykuG91lqg=;
	b=nzkXiuqxXPp84Irtd488rnL2TCFuVJehcoLDw48Wc08/5ZrgJu+AcYKsHCAzQ9m69aEG/D
	2OI2TYeTSAdh2eq5FPvtKXw5/X7e2RTuyn+R+CHpcUFTb0YmkOLV6PdM2C7GJiV0LsKVdt
	nXM6U9MDGatkd1hrINzo33tfbJNj9l8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S16VRBcE;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784089332;
	b=MRjTC43Xzl3Z8IBJpLbxcT8PYvXhI9FwWonpBAKjli+hOuusQCXIrrjxilXKyIZlUiTtwz
	0BHQ3qqpN6zPJjC6tRJhny/Su5wOVXa2MSg73OCOwMwewEs1PsgTZnKaxYqjPIxFIx+eid
	BqAoZBKUbk+6Y4Bca4uyV1yGiNwmM6o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784089332; x=1815625332;
  h=date:from:to:cc:subject:message-id;
  bh=yOkM685yJQdbKVpHEhMOVPwInqzc8Xw3E5+TywZRXT0=;
  b=S16VRBcEEmlnGG9vVspSGQ3R+CqnZdUtJPr+J5pM6bYEb2cVH0xxeD6F
   w1wEayop/agxabawg2UzUL0ZkRojrxo2SxpnMaadC1vBL27hMVdxwaxvh
   k06NNMx92a/ED81w1EXhzq4QjuumQ1lmJYc52tu0PfBtQBDsiALNvGeiD
   g5JTR+z2bZDNYU3zDu9LJIfPZtwVDXJ2sMG/cZtVSpj3z4k/0NujCORVb
   ACx4QozNOlXvdL/7VaERPe2R4fUM9bHgilmipguqFFz7K0cIxu0BBHszW
   fDhF2huNZdTmXjuazfC1G5db7wNlWqdHKlaQwY+1Q/h8LSaK2A2bbRrIX
   g==;
X-CSE-ConnectionGUID: mpgBB8S/TPKY5IYP5VIuUg==
X-CSE-MsgGUID: Phj2UQhlQkOHWEVmqrVEQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84571733"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84571733"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:22:10 -0700
X-CSE-ConnectionGUID: hvNO03mgQV+d0iWYqg69PQ==
X-CSE-MsgGUID: uN6TXpdmQpuBO0IRmGbeag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252662372"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 14 Jul 2026 21:22:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wjr8H-00000000NHb-2tuv;
	Wed, 15 Jul 2026 04:22:05 +0000
Date: Wed, 15 Jul 2026 12:21:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 cc2b5f627e8ccbae1188ef2d8be3e451d7f933a5
Message-ID: <202607151249.N5niNXKX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: yzp5zg99dekigak519s9m6r8sopq7zwx
X-Rspamd-Queue-Id: C617620006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784089331-628564
X-HE-Meta: U2FsdGVkX19LlM8GpUijJgwQQsKU27M5YatXZod17EFqD+LXWrU/WOVrHdidliKLdn28vY9FwUfGofRbPQeHR6ooOvBzgC7HTQBZfGkGJ1A6d20y1KJ4lv+M0v30S4FvsdHt0+5nwBnUb7B0GQbsTjM/i3nEJplbT3foYR8o8ynDSBA3y0i4L0bR2Urs2IoVMUyxilTLvWpIUYiU9rWHNYPDiZ7VZ2xoUR36zhm7Q7cvKlhezHytxR1GdDr1SoyuZCCHSu2CYRAcxz0t9xJMU22dr7O1xXa8+fnO96ga2v4lQ02N0lug6tSjq4nr8ghMPIjxZm5PmQGLA2JP4IlDQAZltIOfxErv1Ownyb6OtVluoAbVcxKlsKNy0UoqQYiZmkPu2NW8eQjz3u9aWFxN1oAjgY9bg/dllA84YHGjHNiNqRj7hiRGZqXdXE7ysULfWVp0xRJDX+weMxKaGOAfBJrNEBfZkFhYkXj0+6JqJsDHNe0jVlYgCGeHcFes4MJTWiykE5Dwuhgf5rQkyba/2i/iqThfCV2sZD69CcTjINU7te7aS5yqBSrnjpwHEaJiojgMwqnJpc2iNDiNyYoARvoJ2YmowYevTTjjHaIk1awLfglQhBPcjHdgD0o0ulaqZokGgAe1iqqWK4fZmIcq7GH4W3QrjutpNdY9FJGmh5t3wL+SEBkvKzwUYevBVuNlmri0y/I4k9U3yV/O9Dj0hjuONqCW1BhD13YgscQanQwcVNdqi0hdv0bGdmO2BZoVND0FZcT0aBK3B8mF3Dp6VqpXi1PhnKlY+LMgMqbf2QmlJinsrBaY74bGD/9iIYtkWxs//wjLR/fA9HIXk/4GZ34eDFDeD5OtszCf9JEzVzh6wWjdyj0gmLyCIvIyE62et1X01mkook4w70Ghdbk/ZUAuT29XMgRlZNv8pRl7cnQYAZjUOLfKoeUvHpXpkvJVbOSQHuMrOTF+8i6NdI2
 uAXFBRgz
 7vTIncO0bXt17NHxp/PggyRDWJ4O3nfscVGuegOCBZHJ0P9n+KMIxpaz8gWDm3jkCxDt0kTcq4Na4+SroBZpZNFgel5dSnhjyRp7RXjVg8NrXT1GQ0iASSGv1dmqDReQnTeyU/uWxKaf0HotbXLcxmtjPPMbhVGCOz0a2SIwRPiUORKsWoue2cUlvT1CYtv8QqlWv8UgVel9CvhzxAA0NdCGmhYbGFu1cryMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: cc2b5f627e8ccbae1188ef2d8be3e451d7f933a5  Add linux-next specific files for 20260714

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607150709.CagVDeyK-lkp@intel.com

    drivers/scsi/gvp11.c:444:51: warning: missing braces around initializer [-Wmissing-braces]
    qcom_scm.c:(.text+0x41cc): undefined reference to `of_address_to_resource'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607150800.r5xDoCDS-lkp@intel.com

    ERROR: modpost: "power_supply_reg_notifier" [drivers/usb/dwc3/dwc3.ko] undefined!
    ERROR: modpost: "power_supply_unreg_notifier" [drivers/usb/dwc3/dwc3.ko] undefined!
    arm-linux-gnueabi-ld: core.c:(.text+0x23c0): undefined reference to `power_supply_unreg_notifier'
    core.c:(.text+0x1c60): undefined reference to `power_supply_unreg_notifier'
    core.c:(.text+0x220c): undefined reference to `power_supply_reg_notifier'
    drivers/media/i2c/imx678.c:1152 imx678_init_controls() error: buffer overflow 'min_hmax_4lane' 8 <= 64
    drivers/media/i2c/imx678.c:905 imx678_write_common() error: buffer overflow 'link_freqs_reg_value' 8 <= 64
    ld.lld: error: undefined symbol: power_supply_reg_notifier
    ld.lld: error: undefined symbol: power_supply_unreg_notifier

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-004-20260715
|   |-- arm-linux-gnueabi-ld:core.c:(.text):undefined-reference-to-power_supply_unreg_notifier
|   |-- core.c:(.text):undefined-reference-to-power_supply_reg_notifier
|   `-- core.c:(.text):undefined-reference-to-power_supply_unreg_notifier
|-- hexagon-randconfig-002-20260714
|   |-- ld.lld:error:undefined-symbol:power_supply_reg_notifier
|   `-- ld.lld:error:undefined-symbol:power_supply_unreg_notifier
|-- loongarch-randconfig-r073-20260714
|   |-- drivers-media-i2c-imx678.c-imx678_init_controls()-error:buffer-overflow-min_hmax_4lane
|   `-- drivers-media-i2c-imx678.c-imx678_write_common()-error:buffer-overflow-link_freqs_reg_value
|-- m68k-allmodconfig
|   `-- drivers-scsi-gvp11.c:warning:missing-braces-around-initializer
|-- m68k-defconfig
|   `-- drivers-scsi-gvp11.c:warning:missing-braces-around-initializer
|-- mips-randconfig-r072-20260715
|   |-- ERROR:power_supply_reg_notifier-drivers-usb-dwc3-dwc3.ko-undefined
|   `-- ERROR:power_supply_unreg_notifier-drivers-usb-dwc3-dwc3.ko-undefined
`-- s390-randconfig-r062-20260714
    `-- qcom_scm.c:(.text):undefined-reference-to-of_address_to_resource

elapsed time: 764m

configs tested: 262
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260715    gcc-10.5.0
arc                   randconfig-002-20260715    gcc-10.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-003-20260715    gcc-10.5.0
arm                   randconfig-004-20260715    gcc-10.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260715    gcc-16.1.0
arm64                 randconfig-001-20260715    gcc-9.5.0
arm64                 randconfig-002-20260715    gcc-15.2.0
arm64                 randconfig-002-20260715    gcc-16.1.0
arm64                 randconfig-003-20260715    clang-23
arm64                 randconfig-003-20260715    gcc-16.1.0
arm64                 randconfig-004-20260715    gcc-11.5.0
arm64                 randconfig-004-20260715    gcc-16.1.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260715    gcc-16.1.0
csky                  randconfig-002-20260715    gcc-13.4.0
csky                  randconfig-002-20260715    gcc-16.1.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260714    clang-20
hexagon               randconfig-002-20260714    clang-23
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260715    clang-22
i386        buildonly-randconfig-002-20260715    clang-22
i386        buildonly-randconfig-002-20260715    gcc-14
i386        buildonly-randconfig-003-20260715    clang-22
i386        buildonly-randconfig-003-20260715    gcc-14
i386        buildonly-randconfig-004-20260715    clang-22
i386        buildonly-randconfig-004-20260715    gcc-14
i386        buildonly-randconfig-005-20260715    clang-22
i386        buildonly-randconfig-006-20260715    clang-22
i386        buildonly-randconfig-006-20260715    gcc-14
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260715    clang-22
i386                  randconfig-001-20260715    gcc-14
i386                  randconfig-002-20260715    clang-22
i386                  randconfig-003-20260715    clang-22
i386                  randconfig-003-20260715    gcc-12
i386                  randconfig-004-20260715    clang-22
i386                  randconfig-004-20260715    gcc-14
i386                  randconfig-005-20260715    clang-22
i386                  randconfig-006-20260715    clang-22
i386                  randconfig-006-20260715    gcc-14
i386                  randconfig-007-20260715    clang-22
i386                  randconfig-007-20260715    gcc-14
i386                  randconfig-011-20260715    clang-22
i386                  randconfig-011-20260715    gcc-14
i386                  randconfig-012-20260715    gcc-14
i386                  randconfig-013-20260715    gcc-14
i386                  randconfig-014-20260715    clang-22
i386                  randconfig-014-20260715    gcc-14
i386                  randconfig-015-20260715    clang-22
i386                  randconfig-015-20260715    gcc-14
i386                  randconfig-016-20260715    clang-22
i386                  randconfig-016-20260715    gcc-14
i386                  randconfig-017-20260715    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260714    gcc-16.1.0
loongarch             randconfig-001-20260715    gcc-16.1.0
loongarch             randconfig-002-20260714    gcc-14.3.0
loongarch             randconfig-002-20260715    gcc-16.1.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
m68k                            mac_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm63xx_defconfig    clang-23
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260714    gcc-11.5.0
nios2                 randconfig-001-20260715    gcc-16.1.0
nios2                 randconfig-002-20260714    gcc-11.5.0
nios2                 randconfig-002-20260715    gcc-16.1.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260714    gcc-13.4.0
parisc                randconfig-001-20260715    clang-23
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260714    gcc-11.5.0
parisc                randconfig-002-20260715    clang-23
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260714    clang-17
powerpc               randconfig-001-20260715    clang-23
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260714    clang-17
powerpc               randconfig-002-20260715    clang-23
powerpc64                      randconfig-001    clang-17
powerpc64             randconfig-001-20260714    clang-17
powerpc64             randconfig-001-20260715    clang-23
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260714    clang-23
powerpc64             randconfig-002-20260715    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260715    clang-17
riscv                 randconfig-001-20260715    gcc-15.2.0
riscv                 randconfig-002-20260715    gcc-15.2.0
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260715    gcc-12.5.0
s390                  randconfig-001-20260715    gcc-15.2.0
s390                  randconfig-002-20260715    clang-23
s390                  randconfig-002-20260715    gcc-15.2.0
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260715    gcc-15.2.0
sh                    randconfig-001-20260715    gcc-16.1.0
sh                    randconfig-002-20260715    gcc-15.2.0
sh                    randconfig-002-20260715    gcc-9.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260715    gcc-16.1.0
sparc                 randconfig-002-20260715    gcc-16.1.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260715    clang-23
sparc64               randconfig-001-20260715    gcc-16.1.0
sparc64               randconfig-002-20260715    clang-20
sparc64               randconfig-002-20260715    gcc-16.1.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260715    clang-23
um                    randconfig-001-20260715    gcc-16.1.0
um                    randconfig-002-20260715    gcc-14
um                    randconfig-002-20260715    gcc-16.1.0
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260715    clang-22
x86_64      buildonly-randconfig-001-20260715    gcc-14
x86_64      buildonly-randconfig-002-20260715    gcc-14
x86_64      buildonly-randconfig-003-20260715    gcc-14
x86_64      buildonly-randconfig-004-20260715    gcc-14
x86_64      buildonly-randconfig-005-20260715    clang-22
x86_64      buildonly-randconfig-005-20260715    gcc-14
x86_64      buildonly-randconfig-006-20260715    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260715    clang-22
x86_64                randconfig-002-20260715    clang-22
x86_64                randconfig-003-20260715    clang-22
x86_64                randconfig-004-20260715    clang-22
x86_64                randconfig-004-20260715    gcc-14
x86_64                randconfig-005-20260715    clang-22
x86_64                randconfig-006-20260715    clang-22
x86_64                randconfig-006-20260715    gcc-14
x86_64                randconfig-011-20260715    clang-22
x86_64                randconfig-012-20260715    clang-22
x86_64                randconfig-012-20260715    gcc-14
x86_64                randconfig-013-20260715    clang-22
x86_64                randconfig-014-20260715    clang-22
x86_64                randconfig-015-20260715    clang-22
x86_64                randconfig-016-20260715    clang-22
x86_64                randconfig-071-20260715    gcc-14
x86_64                randconfig-072-20260715    gcc-14
x86_64                randconfig-073-20260715    gcc-14
x86_64                randconfig-074-20260715    gcc-14
x86_64                randconfig-075-20260715    gcc-14
x86_64                randconfig-076-20260715    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260715    gcc-14.3.0
xtensa                randconfig-001-20260715    gcc-16.1.0
xtensa                randconfig-002-20260715    gcc-12.5.0
xtensa                randconfig-002-20260715    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

