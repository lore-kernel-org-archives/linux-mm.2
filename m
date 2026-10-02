Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7CFCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189C26B0088; Fri,  2 Oct 2026 08:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B5B6B008A; Fri,  2 Oct 2026 08:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FF26B008C; Fri,  2 Oct 2026 08:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB8B76B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:59:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B57791C30A4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:59:11 +0000 (UTC)
X-FDA: 85277691702.10.EBFE250
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1699F2000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:59:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fL8rO+Q3;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790945949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2VnpE6miVXQV08xxqCiZhJmsBpVftImVgbEbYSbKGME=;
	b=1YN4s8L3HvlWaoN05IW2ocu6Q/MeseYD6izK2LGJ34yzIdkDly+6tMprP4JuF2FuIavTNA
	xUnd444mhgnZjaOVHPYBIAy6ATkfDIY5JsYBpfeqqmvIX7923plWLw8ZMGzJV95nd5BkB/
	DshC7xtVXQaAn1LP85Qx5acBiA6fSOI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fL8rO+Q3;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790945949;
	b=r5/2Y0XkgfQMfoq4DgoJ/jor9LNr5jM81OZDyU+PFIWg/Tzb9uee+HFTRDSQGH3BtEnhMK
	xpw2Zsbufl55tfA4JltEmyvERh7Nc0G3UsizJ14TSrwN1s3QgJIlIzFn0hGNhJ3G4PGKpJ
	7suH3GQ+mNVacEkuQLBDyCknK/O/kkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790945949; x=1822481949;
  h=date:from:to:cc:subject:message-id;
  bh=MZHc4aqTc9oNW9La8MkG+LwCJt89CmGZqro4uQR753c=;
  b=fL8rO+Q3uyfIojFlyVLzfJC+px8lekO2bz4A+f80QIX4nApZQYYuY/+g
   tTvRRqzu8FDm6gWBH5Gvuzasol6wO5UYQj/aFfKgPeEH0n0sclH0dDRLx
   dnh/BHIUaBF7bm/UrvXknMu/U1LU0e0Ha0GjLAKhZR8hmXLiaoeYytnH0
   QL5Ub5097s7/LFbij7MJrxaXE2IEFw2XTepbu7engPoQCF3LLQTkWS4gB
   UUG7fxaN0YgQxSt4BFtCVJdkISDGrn2SBKcq6wthJXhoc7RKEgLHxjtDe
   09KZV5D52m00B1bx6HlvVaI0rGdG6RSjrvCDKFHEEsz+R6gqbKOgpiqEq
   A==;
X-CSE-ConnectionGUID: LU9JC/HDSlqQi5BR0/7fcA==
X-CSE-MsgGUID: erfAGo3tS9SPInWQoQ2izQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90766035"
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="90766035"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 05:59:08 -0700
X-CSE-ConnectionGUID: 7P3/OP6VTVWXK2hCIlF37w==
X-CSE-MsgGUID: i4pgRskiTuqBLvrlNyAX+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="272645237"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 02 Oct 2026 05:59:06 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xCcqt-00000000T3O-2IoY;
	Fri, 02 Oct 2026 12:59:03 +0000
Date: Fri, 02 Oct 2026 20:58:08 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 6c2cb8b8b843d216ab549b678a0d8831c43153e0
Message-ID: <202610022004.Z6gkcxAN-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1699F2000C
X-Stat-Signature: mts89cbfna6476375b78d9jxzerwec8d
X-Rspam-User: 
X-HE-Tag: 1790945948-184517
X-HE-Meta: U2FsdGVkX18OVHCF+lqIOmWVgeDvDqO2v2hrwdS+Hi/ciFDIC1rs6boqqx60G/qYImL6XLE2hgSR9F9ylHdCwHZvF/qvMb/5kw0Lci8Dww+XGzPtLxbM1wjUMUs6YFUw43xz1VHpZ4duFUjIYCGqGb1mjbRW2FqKlAHLjhqqy/XiSShWmx/I844Mx+2WIzrh/Cs1N90LQQU5Tb66O/K1JVxdRIZfxW5E9XbC65KpMDxGOcnQLWGmicxCEb3Kk7P6OMleLiITqGsUxN1b40l8g7tu6sc4pXw7AMQTXK3tSArNFheCoDiEZ8pGQNF1iEgNb0dW9UIocsXg/y+4A/zCGsEJdOLd34YVQL5sTnXl+pKFTBLzAiq1jjopknX2TDGeg6h39oY/L4pQ8dyfAduDyrXidaAcsFwmHvq3XeBXpVg3ibkJBsZpkZcGM3QnDKkgQ8rOWMra+CFzsSnZfeqXcspqLLr1FEKd4lb4jrM0OJVfn/WJK1s/HQNoXCjODRbBW1y2XzDCt69eFrX9GH3vpZVn7veEXSMRYXr3gdX82OW5xwEIMearKbd/jJzZxFA/F7OJLwrfBBtB2s88LG3fQD39Sku+v/7yhD4hCJ8NDUW3cgottM9j1XCLgBcZZoDTtEphzUKdR068sc3csYqyVEdu90vZOWREHubUIe+UusNcZzBLMREPYSs5sDQ67yk0/jWXC5IRlF6MGzfqPrXgnVyr9Ii+kXJFxU2ReAor7axTtJxh66QoT7umelzavGsYetuZ/Z/O91+1uaPtuR9VLWyf13tHnFwo5SU3xX0gVdkkzLMQVl7oqku2zHGNewAL4n1xpZhCK9tU3wNYf0O1T2TA51DhDx01vO5my2GCKaAuHFPT8vADxXrm9Ihozsd+AEJowfVsaVhc56zYH12LQ08ES1xUav1+37PiQ/NzGOtzxliE3bMH/LwGOI49m9x5QxMblz3xZ026zZHqFk9
 gTyaMmmc
 YOAsG19ocK2q+loQCniNoLBN+dCm8o3BoN5ZR6jwBgzYW3aK2uPhIY6/WkcXQePOoVBb5oBMn3oCVe/H2szDvVwtmK6XLhrZm3RpT5StBOqZRZF1FwfTp/0Y/pODxHRCs1H3DXRDW7P0jDkj3MzN9XTL6PToOE3xB6Ttpgt4ovnqoUBzuowzZMyg65zAHegEiZ65UsU/HYj5VeqbkCxTK/Xoa/t9RuQygTWu1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6c2cb8b8b843d216ab549b678a0d8831c43153e0  Add linux-next specific files for 20260930

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609301936.oogGZnPc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609302014.WoEXKnE8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609302313.Ux3U0CdC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609302316.aEF8QlMC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202610010151.2W0MrmxE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202610011244.Y6tJFpMR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202610011246.6j5CkJfx-lkp@intel.com

    arch/arm64/boot/dts/qcom/sdm670-google-bonito-tianma.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
    arch/arm64/boot/dts/qcom/sdm670-google-sargo.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
    arch/arm64/boot/dts/renesas/r9a07g044l2-hummingboard-iiot-emmc.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g044l2-hummingboard-iiot-microsd.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g044l2-hummingboard-iiot-rs485-a.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g044l2-hummingboard-iiot-rs485-b.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g044l2-hummingboard-iiot.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g054l2-hummingboard-iiot-emmc.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g054l2-hummingboard-iiot-microsd.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g054l2-hummingboard-iiot-rs485-a.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g054l2-hummingboard-iiot-rs485-b.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/arm64/boot/dts/renesas/r9a07g054l2-hummingboard-iiot.dtb: hub@1 (usb4b4,6502): 'peer-hub' is a required property
    arch/powerpc/kernel/irq.c:116: undefined reference to `.irq_proc_emit_counts'
    drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:9: warning: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    drivers/gpu/drm/verisilicon/vs_bridge.c:306:7: warning: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    include/linux/stddef.h:8:14: error: called object is not a function or function pointer

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609302225.Nn9X0tWf-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609302354.kv3fnDbV-lkp@intel.com

    drivers/hid/hid-steam.c:557 steam_send_report_id() warn: check sign expansion for '__UNIQUE_ID_x__513'
    drivers/iio/adc/ad7768.c:193 ad7768_precharge_buf2_mask() warn: subtract is higher precedence than shift
    drivers/iio/dac/mcp47feb02-core.c:833 mcp47feb02_init_ctrl_regs() warn: subtract is higher precedence than shift
    fs/f2fs/iostat.c:339:2: error: call to '__compiletime_assert_616' declared with 'error' attribute: BUILD_BUG_ON failed: NR_PAGE_ORDERS > F2FS_IOSTAT_RD_FOLIO_ORDERS
    kernel/rcu/hazptrtorture.c:443:1: internal compiler error: in final_scan_insn_1, at final.cc:2813

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-2404-20260923
|   |-- arch-arm-boot-dts-st-ste-href520-tvk.dtb:msp-(stericsson-ux500-msp-i2s):sound-dai-cells-is-a-required-property
|   |-- arch-arm-boot-dts-st-ste-hrefprev60-stuib.dtb:msp-(stericsson-ux500-msp-i2s):sound-dai-cells-is-a-required-property
|   |-- arch-arm-boot-dts-st-ste-hrefv60plus-stuib.dtb:msp-(stericsson-ux500-msp-i2s):sound-dai-cells-is-a-required-property
|   |-- arch-arm-boot-dts-st-ste-hrefv60plus-tvk.dtb:msp-(stericsson-ux500-msp-i2s):sound-dai-cells-is-a-required-property
|   `-- arch-arm-boot-dts-st-ste-snowball.dtb:msp-(stericsson-ux500-msp-i2s):sound-dai-cells-is-a-required-property
|-- arm64-randconfig-2402-20260929
|   |-- arch-arm64-boot-dts-renesas-r9a07g044l2-hummingboard-iiot-emmc.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g044l2-hummingboard-iiot-microsd.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g044l2-hummingboard-iiot-rs485-a.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g044l2-hummingboard-iiot-rs485-b.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g044l2-hummingboard-iiot.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g054l2-hummingboard-iiot-emmc.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g054l2-hummingboard-iiot-microsd.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g054l2-hummingboard-iiot-rs485-a.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   |-- arch-arm64-boot-dts-renesas-r9a07g054l2-hummingboard-iiot-rs485-b.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|   `-- arch-arm64-boot-dts-renesas-r9a07g054l2-hummingboard-iiot.dtb:hub-(usb4b2):peer-hub-is-a-required-property
|-- arm64-randconfig-2404-20260927
|   |-- arch-arm64-boot-dts-qcom-sdm670-google-bonito-tianma.dtb:clock-controller-(qcom-gcc-sdm670):power-domains-is-a-required-property
|   `-- arch-arm64-boot-dts-qcom-sdm670-google-sargo.dtb:clock-controller-(qcom-gcc-sdm670):power-domains-is-a-required-property
|-- csky-randconfig-1000-20261001
|   `-- kernel-rcu-hazptrtorture.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- m68k-randconfig-r2308-20260930
|   `-- include-linux-stddef.h:error:called-object-is-not-a-function-or-function-pointer
|-- parisc-randconfig-r2200-20260930
|   `-- drivers-gpu-drm-bridge-synopsys-dw-mipi-dsi.c:warning:assignment-to-struct-drm_bridge-from-int-makes-pointer-from-integer-without-a-cast
|-- powerpc64-randconfig-r2105-20260930
|   `-- arch-powerpc-kernel-irq.c:undefined-reference-to-irq_proc_emit_counts
|-- s390-randconfig-r2304-20260930
|   `-- drivers-reset-reset-dr1v90.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-noderef-__iomem-base-got-void-platform_data
|-- sparc64-randconfig-r2201-20260930
|   |-- drivers-iio-adc-ad7768.c-ad7768_precharge_buf2_mask()-warn:subtract-is-higher-precedence-than-shift
|   `-- drivers-iio-dac-mcp47feb02-core.c-mcp47feb02_init_ctrl_regs()-warn:subtract-is-higher-precedence-than-shift
|-- um-randconfig-r2302-20260929
|   `-- fs-f2fs-iostat.c:error:call-to-__compiletime_assert_NNN-declared-with-error-attribute:BUILD_BUG_ON-failed:NR_PAGE_ORDERS-F2FS_IOSTAT_RD_FOLIO_ORDERS
|-- x86_64-randconfig-2200-20261001
|   `-- drivers-hid-hid-steam.c-steam_send_report_id()-warn:check-sign-expansion-for-__UNIQUE_ID_x__513
`-- xtensa-randconfig-r2307-20260930
    `-- drivers-gpu-drm-verisilicon-vs_bridge.c:warning:assignment-to-struct-drm_bridge-from-int-makes-pointer-from-integer-without-a-cast

elapsed time: 1269m

configs tested: 269
configs skipped: 2

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261001    gcc-10.5.0 cocci
alpha                randconfig-r2301-20261001    gcc-16.1.0 sparse
alpha                randconfig-r2308-20260930    gcc-8.5.0  sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                  randconfig-r2102-20260930    gcc-13.4.0 cocci
arm                  randconfig-r2302-20261001    gcc-8.5.0  sparse
arm                  randconfig-r2306-20260930    gcc-8.5.0  sparse
arm                          s3c6400_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261002    gcc-12.5.0
arm64                 randconfig-1001-20261002    gcc-12.5.0
arm64                 randconfig-1002-20261002    gcc-12.5.0
arm64                 randconfig-1003-20261002    gcc-12.5.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261002    gcc-12.5.0
csky                  randconfig-1001-20261002    gcc-12.5.0
csky                 randconfig-r2100-20260930    gcc-16.1.0 cocci
csky                 randconfig-r2202-20261001    gcc-16.1.0 smatch
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261002    gcc-13.4.0
hexagon               randconfig-1001-20261002    gcc-13.4.0
hexagon              randconfig-r2104-20260930    clang-17   cocci
hexagon              randconfig-r2105-20260930    clang-17   cocci
hexagon              randconfig-r2107-20260930    clang-24   cocci
hexagon              randconfig-r2302-20261001    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261002    clang-22
i386        buildonly-randconfig-1001-20261002    clang-22
i386        buildonly-randconfig-1002-20261002    clang-22
i386        buildonly-randconfig-1003-20261002    clang-22
i386        buildonly-randconfig-1004-20261002    clang-22
i386        buildonly-randconfig-1005-20261002    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261002    gcc-14
i386                  randconfig-1001-20261002    gcc-14
i386                  randconfig-1002-20261002    gcc-14
i386                  randconfig-1003-20261002    gcc-14
i386                  randconfig-1004-20261002    gcc-14
i386                  randconfig-1005-20261002    gcc-14
i386                  randconfig-1006-20261002    gcc-14
i386                  randconfig-1007-20261002    clang-22
i386                  randconfig-1008-20261002    clang-22
i386                  randconfig-1009-20261002    clang-22
i386                  randconfig-1010-20261002    clang-22
i386                  randconfig-1011-20261002    clang-22
i386                  randconfig-1012-20261002    clang-22
i386                  randconfig-1013-20261002    clang-22
i386                  randconfig-2100-20260930    clang-22   cocci
i386                  randconfig-2100-20261001    gcc-14     cocci
i386                  randconfig-2101-20260930    clang-22   cocci
i386                  randconfig-2101-20261001    gcc-14     cocci
i386                  randconfig-2102-20260930    clang-22   cocci
i386                  randconfig-2102-20261001    clang-22   cocci
i386                  randconfig-2103-20260930    clang-22   cocci
i386                  randconfig-2103-20261001    gcc-13     cocci
i386                  randconfig-2200-20260930    gcc-14     smatch
i386                  randconfig-2200-20261001    clang-22   smatch
i386                  randconfig-2300-20260930    gcc-14     sparse
i386                  randconfig-2300-20261001    clang-22   sparse
i386                  randconfig-2301-20260930    clang-22   sparse
i386                  randconfig-2301-20261001    gcc-14     sparse
i386                  randconfig-2302-20260930    gcc-14     sparse
i386                  randconfig-2302-20261001    gcc-14     sparse
i386                 randconfig-r2200-20260930    gcc-14     smatch
i386                 randconfig-r2201-20261001    gcc-14     smatch
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261002    gcc-13.4.0
loongarch             randconfig-1001-20261002    gcc-13.4.0
loongarch            randconfig-r2104-20261001    clang-24   cocci
loongarch            randconfig-r2303-20261001    gcc-13.4.0 sparse
loongarch            randconfig-r2305-20261001    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                 randconfig-r2302-20260930    gcc-16.1.0 sparse
m68k                 randconfig-r2307-20261001    gcc-16.1.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2303-20261001    gcc-16.1.0 sparse
microblaze           randconfig-r2308-20261001    gcc-10.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ip27_defconfig    gcc-16.1.0
mips                         maltaup_defconfig    gcc-16.1.0
mips                            mtx1_defconfig    gcc-16.1.0
mips                 randconfig-r2102-20261001    gcc-11.5.0 cocci
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261002    gcc-13.4.0
nios2                 randconfig-1001-20261002    gcc-13.4.0
nios2                randconfig-r2100-20261001    gcc-9.5.0  cocci
nios2                randconfig-r2105-20261001    gcc-11.5.0 cocci
openrisc                          alldefconfig    gcc-16.1.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261002    gcc-14.3.0
parisc                randconfig-1001-20261002    gcc-14.3.0
parisc               randconfig-r2106-20261001    gcc-9.5.0  cocci
parisc               randconfig-r2304-20261001    gcc-15.2.0 sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                       arches_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261002    gcc-14.3.0
powerpc               randconfig-1001-20261002    gcc-14.3.0
powerpc              randconfig-r2101-20260930    gcc-15.2.0 cocci
powerpc              randconfig-r2103-20261001    clang-24   cocci
powerpc              randconfig-r2107-20261001    gcc-9.5.0  cocci
powerpc              randconfig-r2303-20260930    clang-24   sparse
powerpc64             randconfig-1000-20261002    gcc-14.3.0
powerpc64             randconfig-1001-20261002    gcc-14.3.0
powerpc64            randconfig-r2106-20260930    gcc-11.5.0 cocci
powerpc64            randconfig-r2301-20260930    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261002    clang-24
riscv                 randconfig-1001-20261002    clang-24
riscv                 randconfig-2000-20260930    gcc-15.2.0
riscv                 randconfig-2001-20260930    gcc-8.5.0
riscv                randconfig-r2309-20261001    clang-20   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261002    clang-24
s390                  randconfig-1001-20261002    clang-24
s390                  randconfig-2000-20260930    clang-24
s390                  randconfig-2001-20260930    gcc-8.5.0
s390                 randconfig-r2300-20260930    clang-17   sparse
s390                 randconfig-r2304-20261001    gcc-15.2.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          apsh4a3a_defconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261002    clang-24
sh                    randconfig-1001-20261002    clang-24
sh                    randconfig-2000-20260930    gcc-14.3.0
sh                    randconfig-2001-20260930    gcc-12.5.0
sh                   randconfig-r2309-20260930    gcc-10.5.0 sparse
sh                           sdk7780_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261002    clang-24
sparc                 randconfig-1001-20261002    clang-24
sparc                 randconfig-2000-20260930    gcc-14.3.0
sparc                 randconfig-2000-20261001    gcc-12.5.0
sparc                 randconfig-2001-20260930    gcc-8.5.0
sparc                 randconfig-2001-20261001    gcc-14.3.0
sparc                randconfig-r2200-20261001    gcc-8.5.0  smatch
sparc                randconfig-r2300-20261001    gcc-14.3.0 sparse
sparc                randconfig-r2304-20260930    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261002    clang-24
sparc64               randconfig-1001-20261002    clang-24
sparc64               randconfig-2000-20260930    gcc-8.5.0
sparc64               randconfig-2000-20261001    clang-24
sparc64               randconfig-2001-20260930    gcc-9.5.0
sparc64               randconfig-2001-20261001    gcc-8.5.0
sparc64              randconfig-r2103-20260930    clang-24   cocci
sparc64              randconfig-r2305-20260930    gcc-15.2.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261002    clang-24
um                    randconfig-1001-20261002    clang-24
um                    randconfig-2000-20260930    clang-24
um                    randconfig-2000-20261001    clang-17
um                    randconfig-2001-20260930    clang-24
um                    randconfig-2001-20261001    clang-24
um                   randconfig-r2201-20260930    clang-17   smatch
um                   randconfig-r2301-20261001    gcc-14     sparse
um                   randconfig-r2307-20260930    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261002    gcc-14
x86_64                randconfig-1001-20261002    gcc-14
x86_64                randconfig-1002-20261002    gcc-14
x86_64                randconfig-1003-20261002    gcc-14
x86_64                randconfig-1004-20261002    gcc-14
x86_64                randconfig-1005-20261002    gcc-14
x86_64                randconfig-1006-20261002    clang-22
x86_64                randconfig-1007-20261002    clang-22
x86_64                randconfig-1008-20261002    clang-22
x86_64                randconfig-1009-20261002    clang-22
x86_64                randconfig-1010-20261002    clang-22
x86_64                randconfig-1011-20261002    clang-22
x86_64                randconfig-1012-20261002    clang-22
x86_64                randconfig-1013-20261002    clang-22
x86_64                randconfig-1014-20261002    clang-22
x86_64                randconfig-1015-20261002    clang-22
x86_64                randconfig-1016-20261002    clang-22
x86_64                randconfig-1017-20261002    clang-22
x86_64                randconfig-2100-20260930    clang-22   cocci
x86_64                randconfig-2100-20261001    gcc-14     cocci
x86_64                randconfig-2101-20260930    clang-22   cocci
x86_64                randconfig-2101-20261001    gcc-13     cocci
x86_64                randconfig-2102-20260930    gcc-14     cocci
x86_64                randconfig-2102-20261001    clang-22   cocci
x86_64                randconfig-2103-20260930    clang-22   cocci
x86_64                randconfig-2103-20261001    clang-22   cocci
x86_64                randconfig-2200-20260930    gcc-14     smatch
x86_64                randconfig-2200-20261001    clang-22   smatch
x86_64                randconfig-2300-20260930    clang-22   sparse
x86_64                randconfig-2300-20261001    clang-22   sparse
x86_64                randconfig-2301-20260930    gcc-14     sparse
x86_64                randconfig-2301-20261001    clang-22   sparse
x86_64                randconfig-2302-20260930    gcc-13     sparse
x86_64                randconfig-2302-20261001    gcc-14     sparse
x86_64               randconfig-r2306-20261001    gcc-14     sparse
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
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261002    clang-24
xtensa                randconfig-1001-20261002    clang-24
xtensa                randconfig-2000-20260930    gcc-12.5.0
xtensa                randconfig-2000-20261001    gcc-10.5.0
xtensa                randconfig-2001-20260930    gcc-10.5.0
xtensa                randconfig-2001-20261001    gcc-8.5.0
xtensa               randconfig-r2202-20260930    gcc-16.1.0 smatch
xtensa               randconfig-r2305-20261001    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

