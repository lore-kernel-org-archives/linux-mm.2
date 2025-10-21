Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4C1CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A0C8E000F; Tue, 21 Oct 2025 12:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B608E0002; Tue, 21 Oct 2025 12:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BCF8E000F; Tue, 21 Oct 2025 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE0B28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:20:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97CB513AFEF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:20:59 +0000 (UTC)
X-FDA: 84022635438.13.AB3A2B8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 565A910000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:20:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V1/fujYV";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761063657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=toeXzWRMxJXpT8YIt3uCmGKmzwNQIpdKKoB4sqV+WcI=;
	b=naY2ga4ktT/HTecpyUwh5AJ4APVtbXeApGzv2KFh8AmNna2r1s/4y2DdSqPUet1//cPqI/
	Y7Hky9az1cgLaPNOnLCPVXZQA2Ei7m4NYXXYI7tKsyouSJ6+d6pLreZiPbPOHC1SrJerBm
	adNt+DmF8bVfAvUG8z0KGI9eoP63V2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761063657; a=rsa-sha256;
	cv=none;
	b=uuLwKUCTrML/UEUApmyF6iT+YUjVj9gjhvGk8aPNaAxw0mH90VyAQbFdUxGoYirDkrcnQK
	MHqBeFt06MWcckUniVEulBkx7t+xqsgNJoPNofxmUlXdI9BKlr7GCwbmTqC5n0mhPF08SO
	MnFk0q3umd3xJCyOVOGoZq0Vvt+bD8Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V1/fujYV";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761063657; x=1792599657;
  h=date:from:to:cc:subject:message-id;
  bh=CM9SfYlcQ9JQgfzNea7pXccMR5MuEYukQeE7u5PG9Ag=;
  b=V1/fujYV2vWTtzrvmDU2+Df/VVexiEqAhIA/Ej+e2P7/dpaQhiWgZ+cs
   l09mUA+kuZqzUQIT8mvqZxbh10SBRrAxBz/ZB8EZihPFPXkGojIxQetKG
   iqNBchJMwc91/k7bWsZghR5j44BjtrPkCwNjTyJI8yStCtkEZNMRYzmYB
   LxMJZsTESfdM4C0j0p2qapfhdKtpQ3r0LUs5DztatwkgG9Vt4gGC4kZOQ
   CsNZl2KAYGc22yKb9c+TYqB675C9js6Rkx6qNRXu328OpcLqJaMYARTTo
   oJf+NsRLa0P1Bdaitq8B2CH0C+JAR9GqOEwghSMa4rmnT1ZxNL83opae4
   w==;
X-CSE-ConnectionGUID: jWskkB0wTJKGX6S/RQHpNw==
X-CSE-MsgGUID: W6Edk6jOQ5KWMDvvW2RRYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="85820168"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="85820168"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 09:20:56 -0700
X-CSE-ConnectionGUID: QzZQ8rEtSGGyYkQqyUgUtg==
X-CSE-MsgGUID: 489PaNjrRIyLmmRc2RJ4lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="214585300"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 21 Oct 2025 09:20:53 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBF6R-000B0f-0n;
	Tue, 21 Oct 2025 16:20:51 +0000
Date: Wed, 22 Oct 2025 00:20:51 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 fe45352cd106ae41b5ad3f0066c2e54dbb2dfd70
Message-ID: <202510220036.ahSSmVmL-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam01
X-Stat-Signature: iix46ine78d8cnw9m9yn3d95oide9j5t
X-Rspam-User: 
X-Rspamd-Queue-Id: 565A910000D
X-HE-Tag: 1761063656-394677
X-HE-Meta: U2FsdGVkX18DQh0aP35xyiX/aSO4SZU+gWa+DjQo1cYHgF5vko8E92QfWYMGYSaYtwDPFG4NzvI0ji/tbeeO1rax7QoyEvQ/+wwsw6x5Hy8eYFA04sGwJeWOBypVyucQ5O0FPPMUdhg6XlNQ/OA01Ic5lVh2gBgfMXoYOYWxoEjSZHjjmWuRoRrOfqfpcljUYKm35PLgBtCCP1dgvHqcFD7MXxYQvHnCdSM+hZMk52TaJggLA1glr5rvHBTqmRqkiCF93Iy6/tUZNtYUWd20GfI29GkPDv3Z8A1u1TXU3F3uKd9LEltm0cfV/f8cYJOe5fFgp1uwRvzOUmazlqFJNlBzgFW4kLGkz2UTLL48oprSfQyYeh52ooBnqd8LLy77tOFo4S91q4nOKlrNldxkuF0ol3JsTNS0xTLtPbjLpAc9ZZjHbAG9Fp9/kczaVCMMfoIDjTbn99NYmVzND72nZhR8tRSoyMJJVTkgeebnNUDfqQC1rvHI/h9l80S5sshAcdQTRF1yMdCZ9YvexVhpyA/CiLGdldivABMkQCYTJUChZXjjGNqj5c+phk5zu1ys6eMkNCqGKTUTxhEOuYhT6EaCcMJvaqBMZ0vPB16AgO8+9ZtDN/RLqlsTEV/x7wATqAq7QYuAsCxcpPol5WV2KNNk5lTWJoYw30T+bqlaFKkoh8ZhdiqZZkLChWNRkeZPgJ/FDDEePWC7oU2TaaG4Nm6R6Xg1qQ2RePSYUf1QYBerpwU3dzf+BfnaTbE1pTfRqOWSgp0u5otgoq5VfuIReEJCf5QqqVZOksPPV4ZPDHpd+nFth7kPk7VE1RcbbYV4rQZ22vexYN8I7tZ9IShbU0vwjKWzeEVh5LfzheK/QMdBHLQ6QqpaM+MTEPl4y1Aext3//DBCU1IekVlmoOejJhTnE4lAFOKgdSqFGPNw6IKp75VBLNDFAhsRB9PAZdDrOgTe6CiXGPOreCoT0rb
 hg9Y3jVt
 cGv9cib9cL2Lw4ZlaCt7ql8jRvz+irlw91dO/ugC3Z+XDsC2k1HfYYsfquFfDqeiLq351augl7xj8vYkrOCllIpoakoALl3xWxi28F/EC6ppGpAFkK9h0W6MUFbMDfagZ15mlMyu+sNMkyYYpRKHKtce66GcoDpiNHqkYJ6YXWksTlCbHzVNGEjfnhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fe45352cd106ae41b5ad3f0066c2e54dbb2dfd70  Add linux-next specific files for 20251021

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509231815.d1EjWp8Y-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509240828.ng1OXTUj-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509251326.SYA3QL9j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510110109.hIUbuESQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510211523.sSEVqPUQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510211905.RgfWkgss-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510212223.LQlabZyJ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510220010.Ly8icYfP-lkp@intel.com

    (.text.unlikely+0x80): undefined reference to `devm_clk_register'
    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    alpha-linux-ld: (.text.unlikely+0xb8): undefined reference to `devm_clk_register'
    arc-linux-ld: clk-acpm.c:(.text+0x3e): undefined reference to `devm_acpm_get_by_node'
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6dl-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt2.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-revc-lt6.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dtb: switch@0 (microchip,ksz8873): Unevaluated properties are not allowed ('interrupt', 'pinctrl-names' were unexpected)
    arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dtb: switch@0 (microchip,ksz8873): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-basic.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-hdmi.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-lt6.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revb-mi1010ait-1cp1.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-bd500.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-tian-g07017.dtb: switch@5f (microchip,ksz9893): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/freescale/imx8mp-skov-revc-tian-g07017.dtb: switch@5f (microchip,ksz9893): pinctrl-names: ['default'] is too short
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b10000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b12000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana-rev7.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/rockchip/rk3528-armsom-sige1.dtb: /soc/pcie@fe000000: failed to match any schema with compatible: ['rockchip,rk3528-pcie', 'rockchip,rk3568-pcie']
    arch/arm64/boot/dts/rockchip/rk3528-armsom-sige1.dtb: pcie@fe000000 (rockchip,rk3528-pcie): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/rockchip/rk3528-armsom-sige1.dtb: pcie@fe000000 (rockchip,rk3528-pcie): interrupt-names:5: 'dma0' was expected
    arch/arm64/boot/dts/rockchip/rk3528-nanopi-zero2.dtb: /soc/pcie@fe000000: failed to match any schema with compatible: ['rockchip,rk3528-pcie', 'rockchip,rk3568-pcie']
    arch/arm64/boot/dts/rockchip/rk3528-nanopi-zero2.dtb: pcie@fe000000 (rockchip,rk3528-pcie): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/rockchip/rk3528-nanopi-zero2.dtb: pcie@fe000000 (rockchip,rk3528-pcie): interrupt-names:5: 'dma0' was expected
    arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dtb: /soc/pcie@fe000000: failed to match any schema with compatible: ['rockchip,rk3528-pcie', 'rockchip,rk3568-pcie']
    arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dtb: pcie@fe000000 (rockchip,rk3528-pcie): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dtb: pcie@fe000000 (rockchip,rk3528-pcie): interrupt-names:5: 'dma0' was expected
    arch/arm64/boot/dts/rockchip/rk3528-rock-2a.dtb: /soc/pcie@fe000000: failed to match any schema with compatible: ['rockchip,rk3528-pcie', 'rockchip,rk3568-pcie']
    arch/arm64/boot/dts/rockchip/rk3528-rock-2a.dtb: pcie@fe000000 (rockchip,rk3528-pcie): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/rockchip/rk3528-rock-2a.dtb: pcie@fe000000 (rockchip,rk3528-pcie): interrupt-names:5: 'dma0' was expected
    arch/arm64/boot/dts/rockchip/rk3528-rock-2f.dtb: /soc/pcie@fe000000: failed to match any schema with compatible: ['rockchip,rk3528-pcie', 'rockchip,rk3568-pcie']
    arch/arm64/boot/dts/rockchip/rk3528-rock-2f.dtb: pcie@fe000000 (rockchip,rk3528-pcie): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/rockchip/rk3528-rock-2f.dtb: pcie@fe000000 (rockchip,rk3528-pcie): interrupt-names:5: 'dma0' was expected
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): Unevaluated properties are not allowed ('pinctrl-names' was unexpected)
    arch/arm64/boot/dts/rockchip/rk3588-jaguar-ethernet-switch.dtb: switch@5f (microchip,ksz9896): pinctrl-names: ['default'] is too short
    i2c-k1.c:(.text.unlikely+0xe3): undefined reference to `devm_clk_register'
    include/linux/kernel.h:334:46: error: called object 'strlen' is not a function or function pointer
    xe_pci.c:(.text+0x908): undefined reference to `xe_configfs_primary_gt_allowed'
    xe_pci.c:(.text+0x91c): undefined reference to `xe_configfs_media_gt_allowed'
    xtensa-linux-ld: xe_pci.c:(.text+0xdf8): undefined reference to `xe_configfs_check_device'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r051-20251021
|   |-- (.text.unlikely):undefined-reference-to-devm_clk_register
|   `-- alpha-linux-ld:(.text.unlikely):undefined-reference-to-devm_clk_register
|-- arc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- arc-randconfig-r132-20251021
|   `-- arc-linux-ld:clk-acpm.c:(.text):undefined-reference-to-devm_acpm_get_by_node
|-- arm-randconfig-051-20251021
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|-- arm-randconfig-052-20251021
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|-- arm-randconfig-053-20251021
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|-- arm-randconfig-054-20251021
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|-- arm-randconfig-055-20251021
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6dl-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt2.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-revc-lt6.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|   |-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):Unevaluated-properties-are-not-allowed-(-interrupt-pinctrl-names-were-unexpected)
|   `-- arch-arm-boot-dts-nxp-imx-imx6q-skov-reve-mi1010ait-1cp1.dtb:switch-(microchip-ksz8873):pinctrl-names:default-is-too-short
|-- arm64-randconfig-051-20251021
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3528-armsom-sige1.dtb:pcie-fe000000-(rockchip-rk3528-pcie):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-rockchip-rk3528-armsom-sige1.dtb:pcie-fe000000-(rockchip-rk3528-pcie):interrupt-names:dma0-was-expected
|   |-- arch-arm64-boot-dts-rockchip-rk3528-armsom-sige1.dtb:soc-pcie-fe000000:failed-to-match-any-schema-with-compatible:rockchip-rk3528-pcie-rockchip-rk3568-pcie
|   |-- arch-arm64-boot-dts-rockchip-rk3528-nanopi-zero2.dtb:pcie-fe000000-(rockchip-rk3528-pcie):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-rockchip-rk3528-nanopi-zero2.dtb:pcie-fe000000-(rockchip-rk3528-pcie):interrupt-names:dma0-was-expected
|   |-- arch-arm64-boot-dts-rockchip-rk3528-nanopi-zero2.dtb:soc-pcie-fe000000:failed-to-match-any-schema-with-compatible:rockchip-rk3528-pcie-rockchip-rk3568-pcie
|   |-- arch-arm64-boot-dts-rockchip-rk3528-radxa-e20c.dtb:pcie-fe000000-(rockchip-rk3528-pcie):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-rockchip-rk3528-radxa-e20c.dtb:pcie-fe000000-(rockchip-rk3528-pcie):interrupt-names:dma0-was-expected
|   |-- arch-arm64-boot-dts-rockchip-rk3528-radxa-e20c.dtb:soc-pcie-fe000000:failed-to-match-any-schema-with-compatible:rockchip-rk3528-pcie-rockchip-rk3568-pcie
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2a.dtb:pcie-fe000000-(rockchip-rk3528-pcie):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2a.dtb:pcie-fe000000-(rockchip-rk3528-pcie):interrupt-names:dma0-was-expected
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2a.dtb:soc-pcie-fe000000:failed-to-match-any-schema-with-compatible:rockchip-rk3528-pcie-rockchip-rk3568-pcie
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2f.dtb:pcie-fe000000-(rockchip-rk3528-pcie):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2f.dtb:pcie-fe000000-(rockchip-rk3528-pcie):interrupt-names:dma0-was-expected
|   |-- arch-arm64-boot-dts-rockchip-rk3528-rock-2f.dtb:soc-pcie-fe000000:failed-to-match-any-schema-with-compatible:rockchip-rk3528-pcie-rockchip-rk3568-pcie
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-052-20251021
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-053-20251021
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-054-20251021
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- arm64-randconfig-055-20251021
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-basic.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-hdmi.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-lt6.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revb-mi1010ait-1cp1.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-bd500.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   |-- arch-arm64-boot-dts-freescale-imx8mp-skov-revc-tian-g07017.dtb:switch-5f-(microchip-ksz9893):pinctrl-names:default-is-too-short
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):Unevaluated-properties-are-not-allowed-(-pinctrl-names-was-unexpected)
|   `-- arch-arm64-boot-dts-rockchip-rk3588-jaguar-ethernet-switch.dtb:switch-5f-(microchip-ksz9896):pinctrl-names:default-is-too-short
|-- i386-buildonly-randconfig-004-20251021
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- microblaze-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- microblaze-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- openrisc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- parisc-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sh-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- sparc-allmodconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
|-- um-randconfig-001-20251021
|   `-- i2c-k1.c:(.text.unlikely):undefined-reference-to-devm_clk_register
|-- xtensa-allyesconfig
|   `-- include-linux-kernel.h:error:called-object-strlen-is-not-a-function-or-function-pointer
`-- xtensa-randconfig-002-20251021
    |-- xe_pci.c:(.text):undefined-reference-to-xe_configfs_media_gt_allowed
    |-- xe_pci.c:(.text):undefined-reference-to-xe_configfs_primary_gt_allowed
    `-- xtensa-linux-ld:xe_pci.c:(.text):undefined-reference-to-xe_configfs_check_device

elapsed time: 734m

configs tested: 136
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251021    gcc-8.5.0
arc                   randconfig-002-20251021    gcc-9.5.0
arc                        vdk_hs38_defconfig    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                           imxrt_defconfig    clang-22
arm                   randconfig-001-20251021    clang-22
arm                   randconfig-002-20251021    clang-22
arm                   randconfig-003-20251021    clang-22
arm                   randconfig-004-20251021    clang-22
arm                           u8500_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251021    gcc-15.1.0
arm64                 randconfig-002-20251021    clang-22
arm64                 randconfig-003-20251021    gcc-12.5.0
arm64                 randconfig-004-20251021    clang-18
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251021    gcc-15.1.0
csky                  randconfig-002-20251021    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251021    clang-22
hexagon               randconfig-002-20251021    clang-17
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251021    clang-20
i386        buildonly-randconfig-002-20251021    clang-20
i386        buildonly-randconfig-003-20251021    clang-20
i386        buildonly-randconfig-004-20251021    gcc-14
i386        buildonly-randconfig-005-20251021    gcc-14
i386        buildonly-randconfig-006-20251021    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251021    clang-22
loongarch             randconfig-002-20251021    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                        bcm63xx_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251021    gcc-10.5.0
nios2                 randconfig-002-20251021    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251021    gcc-8.5.0
parisc                randconfig-002-20251021    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                        cell_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251021    clang-22
powerpc               randconfig-002-20251021    clang-19
powerpc               randconfig-003-20251021    clang-22
powerpc64             randconfig-001-20251021    clang-22
powerpc64             randconfig-002-20251021    gcc-12.5.0
powerpc64             randconfig-003-20251021    gcc-8.5.0
riscv                            alldefconfig    gcc-15.1.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251021    gcc-8.5.0
riscv                 randconfig-002-20251021    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                          debug_defconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251021    clang-22
s390                  randconfig-002-20251021    gcc-11.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251021    gcc-9.5.0
sh                    randconfig-002-20251021    gcc-10.5.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251021    gcc-8.5.0
sparc                 randconfig-002-20251021    gcc-14.3.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251021    gcc-8.5.0
sparc64               randconfig-002-20251021    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251021    gcc-14
um                    randconfig-002-20251021    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251021    gcc-13
x86_64      buildonly-randconfig-002-20251021    clang-20
x86_64      buildonly-randconfig-003-20251021    clang-20
x86_64      buildonly-randconfig-004-20251021    clang-20
x86_64      buildonly-randconfig-005-20251021    gcc-14
x86_64      buildonly-randconfig-006-20251021    clang-20
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                generic_kc705_defconfig    gcc-15.1.0
xtensa                randconfig-001-20251021    gcc-8.5.0
xtensa                randconfig-002-20251021    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

