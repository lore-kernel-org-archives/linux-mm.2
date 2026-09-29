Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F89CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 19:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28E66B0088; Tue, 29 Sep 2026 15:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9DB6B008A; Tue, 29 Sep 2026 15:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFD26B008C; Tue, 29 Sep 2026 15:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 712AD6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:10:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC089160628
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:10:11 +0000 (UTC)
X-FDA: 85267740222.18.A0F17E1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D15DA000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:10:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvoJieI2;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790709010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=OUQKaGulNPyH8C7oCM2zCYESvH0WP2+iA81osuUA0l0=;
	b=eucIfbUrCzeFpIdmk7tuiim4yKcovoYVPRHJ8/mes7tmYWonlXsUFrji9nREghwvQ9UKOW
	m6PGt6yg/Nd5LwQa+YkjmOvbkKIXANoAHDGnFDq7u20TqMFpnPWhEV/83WMGuP1muwjhde
	sbb6WpyHAxWUOjjNLbeOx1KOWm/Ue94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790709010;
	b=CHaKXsi7pwM6oGKwFvPn6DYjCy0cVu7PMiYDE4Nx+mAhprLpbesMXP7CELMhlL/vnQGzaP
	7RtjsnoFX0rH1d5AVz/YNdGcMiNeR2dC0MiZa7KlbCmCTJ4SxphTgyF1lly+nOEFKWz/R4
	uRmu+TA5ODi3cseB9mwVmfuVkXUg/3k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvoJieI2;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790709009; x=1822245009;
  h=date:from:to:cc:subject:message-id;
  bh=6Ntg0WRfoPeM5k6VNnu8B7hppLYo048TO2uugaRQwPc=;
  b=mvoJieI2ucN6yO06qODZxxMzMESRXtDGqt0sJAVibQh4J9J0+h9Dku0d
   KoDdD8kJIOzwLN2LB222iM+ZB/HdL92yABWF0eqGUUxRX81hNME8zPeuM
   pwqPA5s9W2kHFxuMHt8kRKEWVEH4y/dVg2XV5ZLnly3YZUYJBfgUYs9Gt
   qPU2eA62joXcvcme/T3M6/MUMhXsp8ycNc8/nx1dtGdCF6q/4rBU39xjG
   SLR0VWWwk5TlWbzV26UeyKNp9FQfEyi7F+F4Z9kKqEoZIfo8o3fxORmvm
   4gWcvPEFwG49INoJdphjJCkZ7kLfO6Tvl0NbALsCiToMHZO5lRCJpGAKL
   Q==;
X-CSE-ConnectionGUID: Eg3LSPxjSsmO3KQY0Rwo3Q==
X-CSE-MsgGUID: PDtporwuSQmdRATejS7kjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90387738"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90387738"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 12:10:08 -0700
X-CSE-ConnectionGUID: 5we409cVSkW2cIXT6JNWgA==
X-CSE-MsgGUID: 8QMQ3CjnTGy/cE0xacIeEg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 29 Sep 2026 12:10:06 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBdDH-00000000Ph3-20qn;
	Tue, 29 Sep 2026 19:10:03 +0000
Date: Wed, 30 Sep 2026 03:09:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 6375e61c01e93e35ee7acd336a689ac1fae4b509
Message-ID: <202609300341.XNENLUI0-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D15DA000C
X-Stat-Signature: tk3pg5atxhsjze8mk1aospxzfwna4zip
X-HE-Tag: 1790709008-819079
X-HE-Meta: U2FsdGVkX19TNUIP8FeK+7rpU2tO05i9056hDeq0PgbN/BAkuMJcugSaeZ1XqzCiqaa3DO5pXUgSs2QHwH4+qkwaWAjllHJSTNFvjpKqGG7H9ZjAzw803YJn1JRSgO7zhmcMEsFYVayyRGKzLdwPwfikqF2ToRQOBbIMfOgsimrKd3c0F9NZsYNUBjyCdNslSZG6d693b4mtH8b8HKJ07z+3o6CGPtq67BnQDQQvVawXNBUoodoCiHzukDEg77Jezre7CQN+HLLQhlG/J/tf8SSJfqIG8LG+Fn56YfIZu77duA3RmyYzV70TIPDYGRTJjK7i/KKwjHsLDm2m7K6vA6Y1/YB1fsigEXjk7Rf2ljbCGpiAV+h2Ou0yMwnOJnFCtktowWADPJdqFOPvP/LK1G+mlg/eUSJ7up0zZ4wR9YbcyGMLXGFMGnqlq0ffca4SXbll7t1Y4IE+LfCHuMKcRBm79iUMByP1i8TzTeZcpcawO7zrUCd/3CocRGsbn0Hs7fcyuPMmZ08J8uwhqs+HE9F6rVaQ66Mz4qkc2Qj8MGJiMvjd213nCYKjMIf69SV/v53P8N3MlOOVm4pgC1SrNmKFm+3cIb0P95LX/Mu9URhObyz5HD8TAYUlppin3L/U6ktSf+G+RFuETSnmFehlmfe0zdV/Oo5BXIGmVexhdOjq7m70EZKJXEZiKyMHu22UfYGHBY0oEc9GbLwg3zbw1E45TWLl21FibxtvD4w6UT4kYorzWxNnirrw3nwnmPan5ZRGxzlIyrGEvpNUQhefQC94B5cOReKxcDRZ4kqAXngRy5L0ifTAg9TQXIpRrdwCstEAm0SSn0x9LAVZlHMjQ1KlAvf/T+wq1CEHmozBnc1rEU3/p86qGoMQXgJ4nmIAgTyk9PFLrr7H5Kwkqb+toJ6l99ByR3/3+IL+MFRJ/jGJoMV1VfHGK4TmpmzBLWJim8NPq6Ue88JP+5/Jv5I
 ould2Iwe
 Fp6PIykUpw/u0biD1vJf61ONiu3hsa+XY+3NZk/TMc6/jVs0vwtEYLj+ZFHWfbVugANIKWEVXbIrP2azW/OV/437/R0+AeLpizXqL8jap2CFlwotbbzqN3Ygj5b9BpyUloybiM0RVE+643AhwJ2xlynNXVnyyRnHRvJSuFA3iI0b+azKQEU+rWx/bS5a69zAEx5S8+WQzip1+p6kOcZQAjQkfdWvCaIkkPtbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6375e61c01e93e35ee7acd336a689ac1fae4b509  Add linux-next specific files for 20260928

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609290155.PQiaOalK-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609290349.4ad3d90o-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609290408.BOs7sk55-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609291109.9RGna4XZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609291109.OIsGTysr-lkp@intel.com

    Documentation/filesystems/api-summary:20: ./fs/dcache.c:2010: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
    arch/arm64/boot/dts/qcom/sdm670-google-bonito-tianma.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
    arch/arm64/boot/dts/qcom/sdm670-google-sargo.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
    drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:11: error: call to undeclared function 'devm_drm_of_get_bridge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:16: error: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:18: error: implicit declaration of function 'devm_drm_of_get_bridge'; did you mean 'devm_drm_put_bridge'? [-Wimplicit-function-declaration]
    drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:9: error: incompatible integer to pointer conversion assigning to 'struct drm_bridge *' from 'int' [-Wint-conversion]
    drivers/gpu/drm/verisilicon/vs_bridge.c:306:14: error: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    drivers/gpu/drm/verisilicon/vs_bridge.c:306:16: error: implicit declaration of function 'devm_drm_of_get_bridge'; did you mean 'devm_drm_put_bridge'? [-Wimplicit-function-declaration]
    drivers/gpu/drm/verisilicon/vs_bridge.c:306:7: error: incompatible integer to pointer conversion assigning to 'struct drm_bridge *' from 'int' [-Wint-conversion]
    drivers/gpu/drm/verisilicon/vs_bridge.c:306:9: error: call to undeclared function 'devm_drm_of_get_bridge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_guc_pc.c:1400:17: sparse: sparse: Trying to use reserved word 'break' as identifier
    drivers/gpu/drm/xe/xe_guc_pc.c:1400:17: sparse: sparse: Trying to use reserved word 'switch' as identifier

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-2404-20260927
|   |-- arch-arm64-boot-dts-qcom-sdm670-google-bonito-tianma.dtb:clock-controller-(qcom-gcc-sdm670):power-domains-is-a-required-property
|   `-- arch-arm64-boot-dts-qcom-sdm670-google-sargo.dtb:clock-controller-(qcom-gcc-sdm670):power-domains-is-a-required-property
|-- arm64-randconfig-r2306-20260929
|   |-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-break-as-identifier
|   `-- drivers-gpu-drm-xe-xe_guc_pc.c:sparse:sparse:Trying-to-use-reserved-word-switch-as-identifier
|-- i386-buildonly-randconfig-1001-20260929
|   |-- drivers-gpu-drm-bridge-synopsys-dw-mipi-dsi.c:error:assignment-to-struct-drm_bridge-from-int-makes-pointer-from-integer-without-a-cast
|   `-- drivers-gpu-drm-bridge-synopsys-dw-mipi-dsi.c:error:implicit-declaration-of-function-devm_drm_of_get_bridge
|-- i386-buildonly-randconfig-1005-20260929
|   |-- drivers-gpu-drm-bridge-synopsys-dw-mipi-dsi.c:error:call-to-undeclared-function-devm_drm_of_get_bridge-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-gpu-drm-bridge-synopsys-dw-mipi-dsi.c:error:incompatible-integer-to-pointer-conversion-assigning-to-struct-drm_bridge-from-int
|   |-- drivers-gpu-drm-verisilicon-vs_bridge.c:error:call-to-undeclared-function-devm_drm_of_get_bridge-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-gpu-drm-verisilicon-vs_bridge.c:error:incompatible-integer-to-pointer-conversion-assigning-to-struct-drm_bridge-from-int
|-- parisc-randconfig-r2200-20260929
|   |-- drivers-gpu-drm-verisilicon-vs_bridge.c:error:assignment-to-struct-drm_bridge-from-int-makes-pointer-from-integer-without-a-cast
|   `-- drivers-gpu-drm-verisilicon-vs_bridge.c:error:implicit-declaration-of-function-devm_drm_of_get_bridge
`-- x86_64-allnoconfig
    `-- Documentation-filesystems-api-summary:.-fs-dcache.c:WARNING:Block-quote-ends-without-a-blank-line-unexpected-unindent.-docutils

elapsed time: 976m

configs tested: 343
configs skipped: 11

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260929    clang-17
arc                   randconfig-1000-20260929    gcc-13.4.0
arc                   randconfig-1000-20260930    gcc-11.5.0
arc                   randconfig-1001-20260929    clang-17
arc                   randconfig-1001-20260929    gcc-8.5.0
arc                   randconfig-1001-20260930    gcc-11.5.0
arc                  randconfig-r2106-20260928    gcc-16.1.0 cocci
arc                  randconfig-r2201-20260929    gcc-10.5.0 smatch
arc                  randconfig-r2309-20260929    gcc-9.5.0  sparse
arc                     vdk_hs38_smp_defconfig    gcc-16.1.0
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.1.0
arm                         clps711x_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                          lpc32xx_defconfig    clang-17
arm                              mxs_defconfig    gcc-16.1.0
arm                          orion5x_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260929    clang-17
arm                   randconfig-1000-20260929    gcc-11.5.0
arm                   randconfig-1000-20260930    gcc-11.5.0
arm                   randconfig-1001-20260929    clang-17
arm                   randconfig-1001-20260930    gcc-11.5.0
arm                   randconfig-1002-20260929    clang-17
arm                   randconfig-1002-20260929    clang-24
arm                   randconfig-1002-20260930    gcc-11.5.0
arm                   randconfig-1003-20260929    clang-17
arm                   randconfig-1003-20260929    gcc-10.5.0
arm                   randconfig-1003-20260930    gcc-11.5.0
arm                  randconfig-r2106-20260929    gcc-10.5.0 cocci
arm                  randconfig-r2303-20260928    gcc-16.1.0 sparse
arm                         spear6xx_defconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260929    clang-24
arm64                 randconfig-1001-20260929    clang-24
arm64                 randconfig-1002-20260929    clang-24
arm64                 randconfig-1003-20260929    clang-22
arm64                 randconfig-1003-20260929    clang-24
arm64                randconfig-r2306-20260928    gcc-14.3.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260929    clang-24
csky                  randconfig-1000-20260929    gcc-16.1.0
csky                  randconfig-1001-20260929    clang-24
csky                  randconfig-1001-20260929    gcc-15.2.0
csky                 randconfig-r2107-20260928    gcc-12.5.0 cocci
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260929    gcc-8.5.0
hexagon               randconfig-1001-20260929    gcc-8.5.0
hexagon              randconfig-r2102-20260928    clang-22   cocci
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20260929    clang-22
i386        buildonly-randconfig-1001-20260929    clang-22
i386        buildonly-randconfig-1001-20260929    gcc-14
i386        buildonly-randconfig-1002-20260929    clang-22
i386        buildonly-randconfig-1002-20260929    gcc-14
i386        buildonly-randconfig-1003-20260929    clang-22
i386        buildonly-randconfig-1004-20260929    clang-22
i386        buildonly-randconfig-1005-20260929    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260929    clang-22
i386                  randconfig-1000-20260929    gcc-13
i386                  randconfig-1001-20260929    clang-22
i386                  randconfig-1001-20260929    gcc-13
i386                  randconfig-1002-20260929    gcc-13
i386                  randconfig-1003-20260929    gcc-13
i386                  randconfig-1003-20260929    gcc-14
i386                  randconfig-1004-20260929    gcc-13
i386                  randconfig-1004-20260929    gcc-14
i386                  randconfig-1005-20260929    clang-22
i386                  randconfig-1005-20260929    gcc-13
i386                  randconfig-1006-20260929    clang-22
i386                  randconfig-1006-20260929    gcc-13
i386                  randconfig-1007-20260929    gcc-14
i386                  randconfig-1008-20260929    gcc-14
i386                  randconfig-1009-20260929    gcc-14
i386                  randconfig-1010-20260929    gcc-14
i386                  randconfig-1011-20260929    gcc-14
i386                  randconfig-1012-20260929    gcc-14
i386                  randconfig-1013-20260929    gcc-14
i386                  randconfig-2100-20260928    clang-22   cocci
i386                  randconfig-2100-20260929    gcc-13     cocci
i386                  randconfig-2101-20260928    gcc-14     cocci
i386                  randconfig-2101-20260929    clang-22   cocci
i386                  randconfig-2102-20260928    gcc-12     cocci
i386                  randconfig-2102-20260929    clang-22   cocci
i386                  randconfig-2103-20260928    clang-22   cocci
i386                  randconfig-2103-20260929    clang-22   cocci
i386                  randconfig-2200-20260928    clang-22   smatch
i386                  randconfig-2200-20260929    gcc-14     smatch
i386                  randconfig-2300-20260928    gcc-14     sparse
i386                  randconfig-2301-20260928    gcc-12     sparse
i386                  randconfig-2302-20260928    clang-22   sparse
i386                 randconfig-r2100-20260929    gcc-14     cocci
i386                 randconfig-r2104-20260929    gcc-14     cocci
i386                 randconfig-r2202-20260928    gcc-14     smatch
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch                 loongson64_defconfig    clang-17
loongarch             randconfig-1000-20260929    gcc-8.5.0
loongarch             randconfig-1001-20260929    gcc-8.5.0
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.1.0
m68k                        bvme6000_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                           hp300_defconfig    clang-17
m68k                             q40_defconfig    clang-17
m68k                 randconfig-r2201-20260928    gcc-12.5.0 smatch
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2103-20260928    gcc-13.4.0 cocci
microblaze           randconfig-r2309-20260928    gcc-15.2.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip30_defconfig    gcc-16.1.0
mips                 randconfig-r2302-20260928    clang-24   sparse
mips                 randconfig-r2306-20260929    gcc-15.2.0 sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260929    gcc-8.5.0
nios2                 randconfig-1001-20260929    gcc-8.5.0
nios2                randconfig-r2304-20260928    gcc-8.5.0  sparse
openrisc                          alldefconfig    gcc-16.1.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2104-20260928    gcc-16.1.0 cocci
openrisc             randconfig-r2107-20260929    gcc-15.2.0 cocci
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260929    gcc-15.2.0
parisc                randconfig-1000-20260929    gcc-8.5.0
parisc                randconfig-1000-20260930    gcc-8.5.0
parisc                randconfig-1001-20260929    gcc-13.4.0
parisc                randconfig-1001-20260929    gcc-8.5.0
parisc                randconfig-1001-20260930    gcc-8.5.0
parisc               randconfig-r2200-20260928    gcc-8.5.0  smatch
parisc               randconfig-r2200-20260929    gcc-14.3.0 smatch
parisc               randconfig-r2300-20260928    gcc-16.1.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     gamecube_defconfig    gcc-16.1.0
powerpc                      ksi8560_defconfig    gcc-16.1.0
powerpc                    motionpro_defconfig    gcc-16.1.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260929    clang-17
powerpc               randconfig-1000-20260929    gcc-8.5.0
powerpc               randconfig-1000-20260930    gcc-8.5.0
powerpc               randconfig-1001-20260929    gcc-14.3.0
powerpc               randconfig-1001-20260929    gcc-8.5.0
powerpc               randconfig-1001-20260930    gcc-8.5.0
powerpc              randconfig-r2307-20260928    clang-24   sparse
powerpc              randconfig-r2308-20260929    clang-24   sparse
powerpc                      redwood_defconfig    clang-17
powerpc64             randconfig-1000-20260929    gcc-8.5.0
powerpc64             randconfig-1000-20260930    gcc-8.5.0
powerpc64             randconfig-1001-20260929    gcc-12.5.0
powerpc64             randconfig-1001-20260929    gcc-8.5.0
powerpc64             randconfig-1001-20260930    gcc-8.5.0
powerpc64            randconfig-r2101-20260929    gcc-10.5.0 cocci
powerpc64            randconfig-r2103-20260929    gcc-13.4.0 cocci
powerpc64            randconfig-r2105-20260928    clang-17   cocci
powerpc64            randconfig-r2305-20260928    gcc-8.5.0  sparse
powerpc64            randconfig-r2307-20260929    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260929    clang-24
riscv                 randconfig-1001-20260929    clang-24
riscv                 randconfig-2000-20260928    gcc-8.5.0
riscv                 randconfig-2000-20260929    gcc-11.5.0
riscv                 randconfig-2001-20260928    gcc-8.5.0
riscv                 randconfig-2001-20260929    gcc-9.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260929    clang-24
s390                  randconfig-1001-20260929    clang-24
s390                  randconfig-2000-20260928    clang-22
s390                  randconfig-2000-20260929    clang-24
s390                  randconfig-2001-20260928    gcc-16.1.0
s390                  randconfig-2001-20260929    gcc-8.5.0
s390                 randconfig-r2105-20260929    gcc-13.4.0 cocci
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                         dreamcast_defconfig    clang-17
sh                           kfr2r09_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260929    clang-24
sh                    randconfig-1001-20260929    clang-24
sh                    randconfig-2000-20260928    gcc-15.2.0
sh                    randconfig-2000-20260929    gcc-14.3.0
sh                    randconfig-2001-20260928    gcc-13.4.0
sh                    randconfig-2001-20260929    gcc-16.1.0
sh                   randconfig-r2202-20260929    gcc-16.1.0 smatch
sh                            se7721_defconfig    gcc-16.1.0
sh                            se7722_defconfig    gcc-16.1.0
sh                    secureedge5410_defconfig    gcc-16.1.0
sh                              shx3_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260929    gcc-14
sparc                 randconfig-1001-20260929    gcc-14
sparc                 randconfig-2000-20260928    gcc-15.2.0
sparc                 randconfig-2000-20260929    gcc-14.3.0
sparc                 randconfig-2001-20260928    gcc-13.4.0
sparc                 randconfig-2001-20260929    gcc-12.5.0
sparc                randconfig-r2100-20260928    gcc-11.5.0 cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260929    gcc-14
sparc64               randconfig-1001-20260929    gcc-14
sparc64               randconfig-2000-20260928    clang-20
sparc64               randconfig-2000-20260929    gcc-8.5.0
sparc64               randconfig-2001-20260928    clang-24
sparc64               randconfig-2001-20260929    clang-24
sparc64              randconfig-r2308-20260928    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260929    gcc-14
um                    randconfig-1001-20260929    gcc-14
um                    randconfig-2000-20260928    gcc-14
um                    randconfig-2000-20260929    clang-17
um                    randconfig-2001-20260928    gcc-14
um                    randconfig-2001-20260929    gcc-14
um                            x86_64_defconfig    clang-17
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20260929    clang-22
x86_64      buildonly-randconfig-1001-20260929    clang-22
x86_64      buildonly-randconfig-1002-20260929    clang-22
x86_64      buildonly-randconfig-1002-20260929    gcc-14
x86_64      buildonly-randconfig-1003-20260929    clang-22
x86_64      buildonly-randconfig-1003-20260929    gcc-14
x86_64      buildonly-randconfig-1004-20260929    clang-22
x86_64      buildonly-randconfig-1005-20260929    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260929    clang-22
x86_64                randconfig-1000-20260929    gcc-13
x86_64                randconfig-1001-20260929    clang-22
x86_64                randconfig-1002-20260929    clang-22
x86_64                randconfig-1002-20260929    gcc-14
x86_64                randconfig-1003-20260929    clang-22
x86_64                randconfig-1004-20260929    clang-22
x86_64                randconfig-1005-20260929    clang-22
x86_64                randconfig-1006-20260929    gcc-13
x86_64                randconfig-1007-20260929    gcc-13
x86_64                randconfig-1008-20260929    gcc-13
x86_64                randconfig-1009-20260929    gcc-13
x86_64                randconfig-1010-20260929    gcc-13
x86_64                randconfig-1011-20260929    gcc-13
x86_64                randconfig-1012-20260929    clang-22
x86_64                randconfig-1013-20260929    clang-22
x86_64                randconfig-1014-20260929    clang-22
x86_64                randconfig-1015-20260929    clang-22
x86_64                randconfig-1016-20260929    clang-22
x86_64                randconfig-1017-20260929    clang-22
x86_64                randconfig-2100-20260928    gcc-14     cocci
x86_64                randconfig-2100-20260929    clang-22   cocci
x86_64                randconfig-2101-20260928    clang-22   cocci
x86_64                randconfig-2101-20260929    gcc-14     cocci
x86_64                randconfig-2102-20260928    gcc-14     cocci
x86_64                randconfig-2102-20260929    gcc-14     cocci
x86_64                randconfig-2103-20260928    gcc-12     cocci
x86_64                randconfig-2103-20260929    clang-22   cocci
x86_64                randconfig-2200-20260928    gcc-14     smatch
x86_64                randconfig-2200-20260929    clang-22   smatch
x86_64                randconfig-2300-20260928    gcc-14     sparse
x86_64                randconfig-2301-20260928    gcc-14     sparse
x86_64                randconfig-2302-20260928    clang-22   sparse
x86_64               randconfig-r2102-20260929    clang-22   cocci
x86_64               randconfig-r2301-20260928    clang-22   sparse
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260929    gcc-14
xtensa                randconfig-1001-20260929    gcc-14
xtensa                randconfig-2000-20260928    gcc-13.4.0
xtensa                randconfig-2000-20260929    gcc-16.1.0
xtensa                randconfig-2001-20260928    gcc-11.5.0
xtensa                randconfig-2001-20260929    gcc-10.5.0
xtensa               randconfig-r2101-20260928    gcc-14.3.0 cocci

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

