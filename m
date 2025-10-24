Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB39CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F33F8E00DE; Fri, 24 Oct 2025 13:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAFF8E00C9; Fri, 24 Oct 2025 13:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1998E00DE; Fri, 24 Oct 2025 13:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6846A8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:08:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08F90160F1C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:08:08 +0000 (UTC)
X-FDA: 84033640656.21.6432B96
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id 724B340007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:08:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QELDE/ZC";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VZAcH2AXEtG2U5Iheqq/WmefzweQEIuzetpMHbgaY3w=;
	b=VD53jh/zcks9xV7hrJM4psSBpK1o3Kvu418FMxPxPzEgbJKoKN77uYFQ8o00L2ROgotAh5
	rmYovQe622jbZqjy0nJ3IfJpTt+9eTPOBUQ7xc4eZE8b6Iw7KrDsa7Zm5M98uHPO/5SWz6
	B1ksKRNAJ6Rc2R9r3eo77uVD77fY4iQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QELDE/ZC";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325686; a=rsa-sha256;
	cv=none;
	b=5l1f5D3/shJOp7dRott7bglc5acbzjvFMBiyVXzmtX4Bj7Z9qQPGOfEDBGLY4lv41KALhi
	iGiRd3qIxVBCTMMztvxRZa7ahqDZp99Zokl9w44QCD8P7oe3MMq6/RR3Rs2gMtwMhEJFoz
	zM9i+lfIZzxHlWGCpAFHhMGmYFcI3mA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761325686; x=1792861686;
  h=date:from:to:cc:subject:message-id;
  bh=SRlDA6FsKqeOjfaYL7Nv9b4OFKWFnxSCZBUnUN+vREU=;
  b=QELDE/ZCmBjRuk8VE/DkELOjNHShnXUTGK01wZO8OxXlEuGZeATOBrML
   HzcRqsqWH7CncxM5dB+FBTqLUQhWivczSKJAy8t0XPD3qR8Iwk68VPamD
   dnxbx1YkahNVQ/ZvO1yr13Rwt9hDl/Nczxk5dG6bGhh2Uu+rBI/66oHT5
   7qPZdkWwDws7OcCGkifYhxHDwtFz6qC1ZznMd6VHeTkts9kuGf/qKbOcW
   BqmGdSlsjU0M3uSWpfqr5O95jS/KqVX6ykFbt1jUppJEq1Dzg2658Lkvn
   713GZ2KG5Cw7BEUfWL2doSOIPkW8b0kVDkvOLv6wm89CbKzTjIN+FyDqY
   A==;
X-CSE-ConnectionGUID: r/5CHDUDTMqCt+2NWB39YA==
X-CSE-MsgGUID: eWxlJvQVRqmF5EVm4oB1ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81137563"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="81137563"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 10:08:04 -0700
X-CSE-ConnectionGUID: nPuMrKkVRbiC9KDLeaRMEQ==
X-CSE-MsgGUID: WXDFa2zwTvKJ+UvpUkigAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="208121461"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 24 Oct 2025 10:08:02 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vCLGi-000Ei9-1m;
	Fri, 24 Oct 2025 17:08:00 +0000
Date: Sat, 25 Oct 2025 01:07:16 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 72fb0170ef1f45addf726319c52a0562b6913707
Message-ID: <202510250105.SStKq3dO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 724B340007
X-Stat-Signature: kdidyfpaket9tgwsb43pz6coxxbpnhb7
X-Rspam-User: 
X-HE-Tag: 1761325685-672466
X-HE-Meta: U2FsdGVkX1/qnb1cSTD15TblKMvm2R2BGN7KkzkZ1NQheaiHiGT+98gAYWmlbmGZT2D4uWEXqfpT7hZcO2ogv7bMmxCRcCVJ2k8W5BzB+5A5hGLuswZnVsr2LqmadQqliWuF66w00wg5TyGGvrSrH9LJ8XIpySgORtwnGfdyslDnZWJ1DsMn5YWb7hi7tLCy+f+ALqxQ3ANfb9peCWxheUjLJ3mjx9Vz8+2RApETvaoCfR+UwW9O8uVetxfBSExpgd4i4W1C4IzG/cEc/v9W1DCJWYO2tWEs3SZ8wSQH4TkWDA9YmABPqtVOZrXGC0NBSgnUu0Lvdi1g/wGb3zuTRejUR6eywXCBuSiMtXYcajIdTQjwlFgGMy8WAyDlreC6svuEoCM0GSIwja/X8U0cU2CWl775DOSKXNE/tEFinBRKJkyG8Wbnhjo1fCzTGeqTXqkGg3LCtl3lmnk73chdXZYeNxxt/wV6J3wox1RPJKUs7GRVb5xzluMQ2sJ8GuLEqjvV6WSQsVTPs7W6NhmW0kSUlNbsv9qH/BaqA+C+842Aic6qqtfxHCdJt+xz104vt03kCJIfeLvHOkZaMFXy1haCRA0bmMW3QhV5V7V/jX1gzuNgZGt5pnDLTXuGnxc5bOa8xdqSQrxFCcWx0cOhUjENiNb7h7FJTel/7FFLa96KmgUQeYMbt2iRPKR/7sD3Nm0+c0DLrpqgwgmvHpA4BAqSIElQhNhNxIplhB+Dy4cvk5ING/9g1YvOBTnGtbMNQNOCfWKt0sRCCIreorj/Rm+KqA+0OGChE5bNQWibHygDTv7Nggv/MYXlvHE5OARW7/VloKB7V06AZsB7mWTcYIcj7d6qKl3jAQvvVK9g91Dr4x077RJm8gAkwW6/ASIrn7zpuSc2KL8q24DL2soDIVHVX9KRQvlvppX8Tjg5Dda1W3J/f5BxofRXIZZWhPCt5SMlwb2VNJCcO4ib2rn
 ARC3P7Ha
 IOZpmuHCaFhXrgh4McleNuqqPP4vDs91LmJ0FlRNSwE0OKjyyh9Dmx//Uvp+xjTXdzO80gRKG1L5MRw9Bb0k5w3XL3Cd47LsUV0hwDOnBo8D6bTVVAHxZIeeXupVvTGjBsOWDudIlDMf3UxTNr0+KS/1BqVeBUJz5MwqyJra4R4s0lXHSD8C1vei9gQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 72fb0170ef1f45addf726319c52a0562b6913707  Add linux-next specific files for 20251024

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202509260906.O3Ra2nGg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510110109.hIUbuESQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510220954.lcvy1Yp7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510230222.gjGA0A40-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510242255.O4cs8TXL-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510242309.6p5FyVLQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510222308.6LSfjKDk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510241912.s8uQLYlp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242155.afchO66g-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242250.ZzaqW0pV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242322.aWclvr7e-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b10000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dtb: i2c@8b12000 (hisilicon,hix5hd2-i2c): Unevaluated properties are not allowed ('label' was unexpected)
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana-rev7.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/mediatek/mt8173-elm.dtb: pinctrl@1000b000 (mediatek,mt8173-pinctrl): 'aud_i2s2', 'i2c0', 'i2c1', 'i2c2', 'i2c3', 'i2c4', 'i2c6', 'mmc0', 'mmc0default', 'mmc1', 'mmc1default', 'mmc3', 'mmc3default', 'nor', 'rt5650_irq', 'spi1', 'trackpad_irq', 'usb', 'xxx' do not match any of the regexes: '^pinctrl-[0-9]+$', 'pins$'
    arch/arm64/boot/dts/renesas/r8a77960-salvator-x-panel-aa104xd12.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-salvator-x-panel-aa104xd12.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/renesas/r8a77960-salvator-x.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-salvator-x.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/renesas/r8a77960-salvator-xs-panel-aa104xd12.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-salvator-xs-panel-aa104xd12.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/renesas/r8a77960-salvator-xs.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-salvator-xs.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/renesas/r8a77960-ulcb-kf.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-ulcb-kf.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:
    arch/arm64/boot/dts/renesas/r8a77960-ulcb.dtb: /soc/gpu@fd000000: failed to match any schema with compatible: ['renesas,r8a7796-gpu', 'img,img-gx6250', 'img,img-rogue']
    arch/arm64/boot/dts/renesas/r8a77960-ulcb.dtb: gpu@fd000000 (renesas,r8a7796-gpu): compatible: 'oneOf' conditional failed, one must be fixed:

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:512 ras_core_get_utc_second_timestamp() error: we previously assumed 'ras_core' could be null (see line 508)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:531 ras_core_ras_interrupt_detected() error: we previously assumed 'ras_core' could be null (see line 527)
    drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_umc.c:210 ras_umc_log_pending_bad_bank() warn: variable dereferenced before check 'ecc_node' (see line 208)
    drivers/gpu/drm/vkms/vkms_configfs.c:102 make_plane_group() error: dereferencing freed memory 'plane' (line 101)
    drivers/gpu/drm/vkms/vkms_configfs.c:121 make_crtc_group() error: dereferencing freed memory 'crtc' (line 120)
    drivers/gpu/drm/vkms/vkms_configfs.c:125 make_device_group() error: dereferencing freed memory 'dev' (line 124)
    drivers/gpu/drm/vkms/vkms_configfs.c:411 make_encoder_group() error: dereferencing freed memory 'encoder' (line 410)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-051-20251024
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   `-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|-- arm64-randconfig-052-20251024
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-x-panel-aa104xd12.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-x-panel-aa104xd12.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-x.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-x.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-xs-panel-aa104xd12.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-xs-panel-aa104xd12.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-xs.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-renesas-r8a77960-salvator-xs.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|   |-- arch-arm64-boot-dts-renesas-r8a77960-ulcb-kf.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   |-- arch-arm64-boot-dts-renesas-r8a77960-ulcb-kf.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|   |-- arch-arm64-boot-dts-renesas-r8a77960-ulcb.dtb:gpu-fd000000-(renesas-r8a7796-gpu):compatible:oneOf-conditional-failed-one-must-be-fixed:
|   `-- arch-arm64-boot-dts-renesas-r8a77960-ulcb.dtb:soc-gpu-fd000000:failed-to-match-any-schema-with-compatible:renesas-r8a7796-gpu-img-img-gx6250-img-img-rogue
|-- arm64-randconfig-053-20251024
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   `-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|-- arm64-randconfig-054-20251024
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   `-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|-- arm64-randconfig-055-20251024
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b10000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-hisilicon-hi3798cv200-poplar.dtb:i2c-8b12000-(hisilicon-hix5hd2-i2c):Unevaluated-properties-are-not-allowed-(-label-was-unexpected)
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana-rev7.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_ir
|   |-- arch-arm64-boot-dts-mediatek-mt8173-elm-hana.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi
|   `-- arch-arm64-boot-dts-mediatek-mt8173-elm.dtb:pinctrl-1000b000-(mediatek-mt8173-pinctrl):aud_i2s2-i2c0-i2c1-i2c2-i2c3-i2c4-i2c6-mmc0-mmc0default-mmc1-mmc1default-mmc3-mmc3default-nor-rt5650_irq-spi1-tra
|-- csky-randconfig-001-20251024
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- csky-randconfig-r051-20251024
|   `-- drivers-gpu-drm-solomon-ssd13.c:Unneeded-variable:ret-Return-on-line
|-- i386-randconfig-063-20251024
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn401-dcn401_hwseq.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- i386-randconfig-141-20251024
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
|   `-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)
|-- microblaze-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- parisc-allmodconfig
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- x86_64-randconfig-123-20251024
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn401-dcn401_hwseq.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
`-- x86_64-randconfig-161-20251024
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_get_utc_second_timestamp()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_core.c-ras_core_ras_interrupt_detected()-error:we-previously-assumed-ras_core-could-be-null-(see-line-)
    |-- drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_umc.c-ras_umc_log_pending_bad_bank()-warn:variable-dereferenced-before-check-ecc_node-(see-line-)
    `-- drivers-gpu-drm-amd-amdgpu-amdgpu_virt.c-amdgpu_virt_init_critical_region()-warn:unsigned-init_hdr_offset-is-never-less-than-zero.

elapsed time: 732m

configs tested: 143
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251024    gcc-8.5.0
arc                   randconfig-002-20251024    gcc-14.3.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                        clps711x_defconfig    clang-22
arm                                 defconfig    clang-22
arm                          pxa168_defconfig    clang-19
arm                   randconfig-001-20251024    clang-20
arm                   randconfig-002-20251024    gcc-15.1.0
arm                   randconfig-003-20251024    clang-22
arm                   randconfig-004-20251024    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251024    gcc-8.5.0
arm64                 randconfig-002-20251024    clang-16
arm64                 randconfig-003-20251024    gcc-13.4.0
arm64                 randconfig-004-20251024    clang-17
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251024    gcc-14.3.0
csky                  randconfig-002-20251024    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251024    clang-22
hexagon               randconfig-002-20251024    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251024    clang-20
i386        buildonly-randconfig-002-20251024    gcc-14
i386        buildonly-randconfig-003-20251024    clang-20
i386        buildonly-randconfig-004-20251024    gcc-14
i386        buildonly-randconfig-005-20251024    gcc-14
i386        buildonly-randconfig-006-20251024    gcc-14
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251024    gcc-15.1.0
loongarch             randconfig-002-20251024    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5208evb_defconfig    gcc-15.1.0
m68k                            mac_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                          rb532_defconfig    clang-18
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251024    gcc-11.5.0
nios2                 randconfig-002-20251024    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251024    gcc-9.5.0
parisc                randconfig-002-20251024    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                   bluestone_defconfig    clang-22
powerpc               mpc834x_itxgp_defconfig    clang-22
powerpc               randconfig-001-20251024    gcc-8.5.0
powerpc               randconfig-002-20251024    clang-17
powerpc               randconfig-003-20251024    clang-16
powerpc64             randconfig-001-20251024    gcc-12.5.0
powerpc64             randconfig-002-20251024    gcc-14.3.0
powerpc64             randconfig-003-20251024    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251024    clang-22
riscv                 randconfig-002-20251024    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251024    gcc-13.4.0
s390                  randconfig-002-20251024    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                          r7785rp_defconfig    gcc-15.1.0
sh                    randconfig-001-20251024    gcc-12.5.0
sh                    randconfig-002-20251024    gcc-14.3.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251024    gcc-12.5.0
sparc                 randconfig-002-20251024    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251024    clang-20
sparc64               randconfig-002-20251024    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251024    gcc-14
um                    randconfig-002-20251024    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251024    clang-20
x86_64      buildonly-randconfig-002-20251024    clang-20
x86_64      buildonly-randconfig-003-20251024    clang-20
x86_64      buildonly-randconfig-004-20251024    gcc-14
x86_64      buildonly-randconfig-005-20251024    gcc-14
x86_64      buildonly-randconfig-006-20251024    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251024    gcc-11.5.0
xtensa                randconfig-002-20251024    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

