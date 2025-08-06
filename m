Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4902C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888668E000F; Wed,  6 Aug 2025 12:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FEE8E0003; Wed,  6 Aug 2025 12:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CB88E000F; Wed,  6 Aug 2025 12:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 676458E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:50:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9DB51403E4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:50:13 +0000 (UTC)
X-FDA: 83746920306.23.1402226
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70B1440014
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:50:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cuYS1oSG;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754499012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2UBRtQfliKnxBAkF7YH+GLT3CIGZwLAYxL2HAAtO6Bc=;
	b=VlGiTHeM/OkWbFWZUj/jvwOkaE3f4o/QYUUJFS8A6HIPCPDC3AKkh2BQEIzVD8qvdSPFic
	RICJfP1Xcj3n4VM4VCzlMG4/361ms8vF3+Fr4zwKSIelqCiAMga8fcjJ1f6kzxJVRwt8Kn
	rRvyjNgvSOio2E4YNE9hrHVzHTZvYEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754499012; a=rsa-sha256;
	cv=none;
	b=G8Ik8dypq6AUsGKDHbqjT4sjMz3tjUcwd+m4YVkSk4MJv9dzSs7wh4Jg2TYO5daP7vwYDj
	XeaooGqZ+YjJWPh53jxAsMHklTwv8AAtewPzsDTSQdtzT+97MiVt462vXveu0QnUkunadk
	R0+sotEZgpKYDj/A0Dod6PhUUj6p2+o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cuYS1oSG;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754499012; x=1786035012;
  h=date:from:to:cc:subject:message-id;
  bh=8hD2Qo7C1lkzhFuIzI+0HKnfOBq0XT2z7P0Wj+LcepY=;
  b=cuYS1oSGzpNxjZYbp/BpgqFz2MU4K38tAS9Prbpa4I+TG1ivHrb1fTFm
   4Pg+B7vlILYThwoyZph/TpwnAmEa2AiAcH4sRYnObF/A4rafgnl88kvwL
   pO3ynNmy4awh4jfiRWc19eU+YXwy4mPEwMIacyVc5sQ2pGDxY0CDih2I5
   Y2mwE8SARCPIPQT7qlLyfqhaRzBSmG6HjGg5OZvAQdxx8POxj/kv6xXb0
   BTuiM/2k2U4DCi4j/GrACUfiBXxdYEYLqLhwiQDOo2aD9VlLMc3W9y5Oc
   5aTQQFcV6XpZVdoD0FsGDOFf6cijPmgsIQTNZwX+c71VFdH/DhKw9pGrL
   g==;
X-CSE-ConnectionGUID: LPBHrgIGQqmcK7SIr+GTYg==
X-CSE-MsgGUID: YrYBLC+6QAKJistOmCMRyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56690997"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56690997"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 09:50:11 -0700
X-CSE-ConnectionGUID: K/30RFxZSUyZAbRmjgR6uQ==
X-CSE-MsgGUID: jtOetaZtTkKuQ9kIf/J09g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="168999324"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 06 Aug 2025 09:50:10 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujhL5-0001tt-0G;
	Wed, 06 Aug 2025 16:50:07 +0000
Date: Thu, 07 Aug 2025 00:49:52 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 b7d4e259682caccb51a25283655f2c8f02e32d23
Message-ID: <202508070035.cxqZPBlo-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70B1440014
X-Stat-Signature: pqpc4trsffagb87krfee4x6nujtru6yf
X-Rspam-User: 
X-HE-Tag: 1754499011-678900
X-HE-Meta: U2FsdGVkX1+DH6JCw9Qk44gW9JH9NLm1EM73y+WS0Sxh2nn+VJGG4MHY4biNiVmDIuxbg9S2cSt7WZ2pZV8+bEGeCQyTToDJEBkn/mKU2ReW+Z7jNGEZnlfuST+3s5ZMnUrvYJhaGMGvjFJt3Tn2CenEthcgpT5OYfM3eSTvJnn0YMZzg3QcZFkuQo9osLLtGm2iiippNnHJZZ1g55v/gwRGaiVrdKeSZ7BfQGLABu2ueFiXmRdiiTnj1CF9TSRJA6sMaT5lmKrrvgKIsqciy2X9scheJ25Hth00DglQrcp4C85Fdf6SmUtRVEq1ByUtt498GgTQgEA6EjC6tTG0zIDkggwygpE8oCgjkQBdpSUK/ksB/z9aGuOD/BB77NrJBfAtEmJupr15fa9gnYXO0QWzavmAuo/5ZB7Hcqgh2F1Wp3CjWcW4LyQSKtFBFhqWfguPDbRYx7pR7PnBfFxKB5INwJZ5ER+7lHykqjS0UdnEYQ7f/exBw7Ez8pyR07hZxWVZ/xb7yL8z9p73guHA3cx3Ma0ADMeTVOQxz6IVU7GCPOMTdf8250XiQVl42QtmXxDsi+7lO0GOl3IrfOyToO2t1/P6MeaqvopLp6egUHz3Ez4q91BmPKwUnTnPdeDg21bSEBO6P/COsNiM7Xs7/Tkx3jPDU6kffZ0ih2gfmxLP3LW5krin2YSlK4MxGFRLqgZHI9t+byZmxFHvgDgrDflOexpqWERRIgv24Gy/MW9t11em8UOzemqit7hRHcKY4tYVrDPWk2hyldcNBPCifGrdK3s1FBl5rOe3Ow3K1hPi7PJD7szwC2CjuYu7XY8XwfNTSaK+KvhKclMaeJpYK/+cmXfnXdUNxDxLi92gqo4QDib+QMAyf+z2KzJOxM+YLgYe6ELZr8xn8C5FpuxPh2pourK6LxpbxETaQUl8xuEoquA5IyQold9xG3FNDUfCWz4qNZEkkF15ayKb7Aw
 0q/d7u5k
 vYkGKgwjfSbV3wcHaBrEUMCJCxXlYVXOkW9uSue3PqzCgqW1XzbAQrcapBtBuYUCQ0sNozfAq4seARji0EsPI1Rqh5ZND58br+OGsMMqI+PBq8hpD9Iq72jehAw2r+1sPhILtcCXsiiGLOLJ0qWd+2tsLyKgZITCe+/McIOAuFT7Jvf8wy63nFrAu6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: b7d4e259682caccb51a25283655f2c8f02e32d23  Add linux-next specific files for 20250806

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507271211.hvhQM36m-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com

    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): 'pmic-sleep-hog', 'wakeup-source' do not match any of the regexes: '^(vcc(io|[1-7])-supply)$', '^pinctrl-[0-9]+$'
    arch/arm/boot/dts/nvidia/tegra30-asus-p1801-t.dtb: pmic@2d (ti,tps65911): regulators:vddctrl: Unevaluated properties are not allowed ('nvidia,tegra-cpu-regulator' was unexpected)
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 when selected by SM_VIDEOCC_6350

Unverified Error/Warning (likely false positive, kindly check if interested):

    clang: error: clang frontend command failed with exit code 139 (use -v to see invocation)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-when-selected-by-SM_VIDEOCC_6350
|-- arm-randconfig-051-20250806
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-052-20250806
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-053-20250806
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-054-20250806
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm-randconfig-055-20250806
|   |-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):pmic-sleep-hog-wakeup-source-do-not-match-any-of-the-regexes:(vcc(io-)-supply)-pinctrl
|   `-- arch-arm-boot-dts-nvidia-tegra30-asus-p1801-t.dtb:pmic-2d-(ti-tps65911):regulators:vddctrl:Unevaluated-properties-are-not-allowed-(-nvidia-tegra-cpu-regulator-was-unexpected)
|-- arm64-randconfig-002-20250806
|   `-- drivers-gpu-drm-msm-msm_gem.c:error:incomplete-definition-of-type-struct-msm_kms
|-- csky-randconfig-r111-20250806
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- csky-randconfig-r133-20250806
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- m68k-randconfig-r112-20250806
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|-- nios2-randconfig-r113-20250806
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- um-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- x86_64-randconfig-121-20250806
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
`-- x86_64-randconfig-123-20250806
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
    `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu

elapsed time: 735m

configs tested: 134
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250806    gcc-12.5.0
arc                   randconfig-002-20250806    gcc-11.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                            hisi_defconfig    gcc-15.1.0
arm                       multi_v4t_defconfig    clang-16
arm                       omap2plus_defconfig    gcc-15.1.0
arm                   randconfig-001-20250806    gcc-10.5.0
arm                   randconfig-002-20250806    gcc-13.4.0
arm                   randconfig-003-20250806    gcc-10.5.0
arm                   randconfig-004-20250806    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250806    clang-20
arm64                 randconfig-002-20250806    clang-22
arm64                 randconfig-003-20250806    gcc-9.5.0
arm64                 randconfig-004-20250806    clang-17
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250806    gcc-10.5.0
csky                  randconfig-002-20250806    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250806    clang-18
hexagon               randconfig-002-20250806    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250806    clang-20
i386        buildonly-randconfig-002-20250806    gcc-11
i386        buildonly-randconfig-003-20250806    clang-20
i386        buildonly-randconfig-004-20250806    gcc-12
i386        buildonly-randconfig-005-20250806    gcc-12
i386        buildonly-randconfig-006-20250806    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250806    clang-18
loongarch             randconfig-002-20250806    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        m5407c3_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250806    gcc-10.5.0
nios2                 randconfig-002-20250806    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250806    gcc-15.1.0
parisc                randconfig-002-20250806    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20250806    clang-22
powerpc               randconfig-002-20250806    gcc-14.3.0
powerpc               randconfig-003-20250806    clang-22
powerpc                 xes_mpc85xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20250806    gcc-15.1.0
powerpc64             randconfig-002-20250806    gcc-10.5.0
powerpc64             randconfig-003-20250806    clang-18
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250806    clang-20
riscv                 randconfig-002-20250806    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250806    gcc-14.3.0
s390                  randconfig-002-20250806    gcc-14.3.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250806    gcc-15.1.0
sh                    randconfig-002-20250806    gcc-10.5.0
sh                        sh7763rdp_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250806    gcc-11.5.0
sparc                 randconfig-002-20250806    gcc-13.4.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250806    gcc-8.5.0
sparc64               randconfig-002-20250806    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250806    clang-16
um                    randconfig-002-20250806    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250806    gcc-12
x86_64      buildonly-randconfig-002-20250806    clang-20
x86_64      buildonly-randconfig-003-20250806    gcc-12
x86_64      buildonly-randconfig-004-20250806    gcc-12
x86_64      buildonly-randconfig-005-20250806    clang-20
x86_64      buildonly-randconfig-006-20250806    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250806    gcc-13.4.0
xtensa                randconfig-002-20250806    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

