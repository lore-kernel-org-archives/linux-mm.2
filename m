Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADFDF532EA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9ED36B0092; Tue, 24 Mar 2026 04:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FC56B0095; Tue, 24 Mar 2026 04:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917906B0096; Tue, 24 Mar 2026 04:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 797C56B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:02:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C3CD1417B5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:02:39 +0000 (UTC)
X-FDA: 84580214838.08.C210516
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id 230CC80013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:02:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NQ0XVDbs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339357; a=rsa-sha256;
	cv=none;
	b=uze6et2hBbrPTHbZLvfZxakn5giUSXt/5y/R10FMxUb2ZDtDAInWDAstZeuxnD4p3enE7y
	dloAoY/YiLBcXmkO6TkzOsGRtj9wF2en0XE9YEKBifmKojXPJ/1Yy8eBxTHCB5W37KjUbk
	4MPcCIFQvNg1iep7ySUosmCY4Zn6nb4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NQ0XVDbs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TyVjOYVAnaa4bCCEdcylb8SLtF09wHU7W2E2V96LQ3Y=;
	b=TEXTsm3KEvUzL7mMI0ZhrFyh8X2a1uAgnWdqghhjNhUeCN3PwmVY5hCfCDWER0PIgJXgPe
	TGUXAOELt5vy4TuWIjy0pI2prQsqajx5O/n7dXYKYPRnXT67b0xew1A5wP8WYGbS8J4ba5
	Xif1yra4HzrVeHcCOlQPXdFoNQGTHfg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774339357; x=1805875357;
  h=date:from:to:cc:subject:message-id;
  bh=ja+OtRF8abth7JNsJU5jy823hbYOmMJqYhimSX9PlPU=;
  b=NQ0XVDbsQIjSpPHTwx49zReluHk/FJ7OHZMVYBs85d41rrS0LLJU3ebk
   Os86CF6fty5GJqeI8gRORVGUW4rIGw9QyhyNIRjJF54Jbk27xisFuiMFf
   rSUFVFOZrez6u4PkeOojhlLUa+D340P5E9BO/AjBfaWeiMFQTl9Hcziq8
   7ELrpvy1ZpLPx+Xj+8zmp8dmEaBOdYr1uEnaV0+CIQGmfonveGZYGiyDO
   4dHjjI/OZ3/1Mm9/1ZmKGPZSbJlBTR0IuTIazMgkjpnAfdJJF7NJb/DYe
   BMJW8U/RIqFazSeR5Mo77CmmDV7XXWsiBpJBa2wD9SJG82t6K45FetmUm
   A==;
X-CSE-ConnectionGUID: 1xIol5ytSX6bizCj2RqWIQ==
X-CSE-MsgGUID: f3j3Y5jMQ1mmSv8AsUC0Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="62901768"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="62901768"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 01:02:36 -0700
X-CSE-ConnectionGUID: wDJFJ4AWQpymbFPQsjDwbA==
X-CSE-MsgGUID: M+NuQfLGSCya6qeaUM4Q0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="223359390"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 24 Mar 2026 01:02:34 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4wid-000000004CP-3Avt;
	Tue, 24 Mar 2026 08:02:31 +0000
Date: Tue, 24 Mar 2026 16:01:49 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 09c0f7f1bcdbc3c37a5a760cbec76bf18f278406
Message-ID: <202603241636.5Lg2SQRD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 230CC80013
X-Stat-Signature: 1sa1xpow4ipx5ezjg159i9gx1hojjguh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774339356-773284
X-HE-Meta: U2FsdGVkX19OJ5qMrz5DnFWdNkKq43pbJA+KWMmXuSpEG17kAgt6tKOR1va9LTO5ekCFUqi0nzzzDGDnnG40naGhfaaSPB3JrwYgfkNBxKJm/U8gz+yl6675iMEynEBPKPpDSD4NNCEyRBOB327g+1XK6knVYKGNhbtPY2sfGPCQ5arYqHEIqkqGqFF4tDDubRgpintm5ikgSCuyx7O8LrTNjpFHsu1cV9om5oZrjnW0wRpSQP2ugIj9zhmjVL+kQk+adr+g60UIcSXI/m19wuruAaYDJxZNSH/mIvXBFwzHsq9S1gqgD9h5MTrgFo2d7FY4lUy+hUfMrgMtwzeXy7h9LM0iq6fEPHSQNdgzSppA9ea8BgQwIIKLgdn8pg3JzoGaqd70oOVS2es/vzm5r6Cl9LNeO11y1qOX58nam/sjhBqmKnhLBgQ+3G/bHrUQ3dUjPwMhzcrwrx3navZrLVAaJiyYD1ooDX8pbE5nQST1DZydfuHVz/szINtGW2cXiw2w+Bl+pgK4QEAEwSslLtMzbdmtvTfCBfaCE9aRmfMbzqz1HMnUDYxbN9kV6SKVZ283TqCmvdthro+XgHuOC6nPHTmYAEQX4ysluhqkqw25zWKIfC1JSZBHrKyWrlISrfbmorXNuEIy7eX8N5DHAd0QnGtWl9FLSGxEUAEtjjRioM1A69xXJFnH1/nXzJReCsO3H3LDHgjJFboA+yeuCdzPUl1v/GQw/eq7xol2dT3ERrwhuAjpV40tu3hY/ZDUbO0+YZUVwgx3uzdhjC7ar6GVwqV+GYX0FeQboxKQHe1HD0hD8biXbGvFHb+ZMI/4VLR9Da0nh0OiYeGY2eWMr+0/wtgypDfswGg2VFK9IUgXQq6JWyIEHVYKaPrX4kyorPb1TRGhDbZ0WbyymO5MZe7GyAadsg1pPmrbkXad8+qGXlbnOE0pJD/SWF559ejkkPdUVNUIoOIlSe8Gweo
 8pmnfOuK
 mqX2YIh7azU4Ujonwc7XL28Bcr8roGXPLUEQLy+ae1sVsg9TJItL0xvtT7e3fkj8m9KtVNkCxYf3BZ0slOe6MKfi/j78INzNA6fGIdhxImF1Ia9dyR8CsXgeQ20visV9Jz0qXvE372+mH7ERqW40pfZ1Ei2FXb/Bah6jcsgkTTqcWzrt/a2f1YWr+Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 09c0f7f1bcdbc3c37a5a760cbec76bf18f278406  Add linux-next specific files for 20260323

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603240810.8hpFk4my-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603241527.WQ5SzKfW-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603240754.C7jumMeJ-lkp@intel.com

    drivers/gpu/drm/bridge/lontium-lt8713sx.c:141:(.text+0x1c6): undefined reference to `__udivdi3'
    include/linux/property.h:264: undefined reference to `wm_adsp2_remove'
    pcie-mediatek-gen3.c:(.text+0x1988): undefined reference to `pci_pwrctrl_power_on_devices'
    pcie-mediatek-gen3.c:(.text+0x1e38): undefined reference to `pci_pwrctrl_create_devices'
    pcie-mediatek-gen3.c:(.text+0xa2c): undefined reference to `pci_pwrctrl_power_off_devices'
    sound/soc/codecs/cs35l41.c:1042: undefined reference to `wm_halo_init'
    sound/soc/codecs/cs35l41.c:233: undefined reference to `wm_adsp_early_event'
    sound/soc/codecs/cs35l41.c:385: undefined reference to `wm_adsp2_remove'
    sound/soc/codecs/cs35l41.c:511: undefined reference to `wm_adsp_event'
    sound/soc/codecs/cs35l41.c:879: undefined reference to `wm_adsp2_component_remove'
    sound/soc/codecs/cs35l41.c:953: undefined reference to `wm_adsp2_component_probe'
    sparc-linux-ld: pcie-mediatek-gen3.c:(.text+0x130c): undefined reference to `pci_pwrctrl_power_off_devices'
    sparc-linux-ld: pcie-mediatek-gen3.c:(.text+0xa40): undefined reference to `pci_pwrctrl_destroy_devices'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.c:215: undefined reference to `wm_adsp_early_event'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.c:402: undefined reference to `wm_adsp2_remove'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.c:434: undefined reference to `wm_halo_init'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.c:525: undefined reference to `wm_adsp_event'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.c:681: undefined reference to `wm_adsp2_component_probe'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x2eb8): undefined reference to `wm_adsp2_preloader_get'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x2ebc): undefined reference to `wm_adsp2_preloader_put'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x2ee8): undefined reference to `wm_adsp_fw_get'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x2eec): undefined reference to `wm_adsp_fw_put'
    xtensa-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x2ef4): undefined reference to `wm_adsp_fw_enum'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.c:810: undefined reference to `wm_adsp_event'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.o:(.rodata+0x6bc): undefined reference to `wm_adsp2_preloader_get'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.o:(.rodata+0x6c0): undefined reference to `wm_adsp2_preloader_put'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.o:(.rodata+0x6ec): undefined reference to `wm_adsp_fw_get'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.o:(.rodata+0x6f0): undefined reference to `wm_adsp_fw_put'
    xtensa-linux-ld: sound/soc/codecs/cs35l45.o:(.rodata+0x6f8): undefined reference to `wm_adsp_fw_enum'
    xtensa-linux-ld: sound/soc/codecs/cs35l56-shared.c:568: undefined reference to `cs_dsp_coeff_read_ctrl'
    xtensa-linux-ld: sound/soc/codecs/cs35l56-shared.c:636: undefined reference to `cs_dsp_get_ctl'
    xtensa-linux-ld: sound/soc/codecs/cs35l56.c:1309: undefined reference to `wm_adsp_power_up'
    xtensa-linux-ld: sound/soc/codecs/cs35l56.c:1328: undefined reference to `wm_adsp_run'
    xtensa-linux-ld: sound/soc/codecs/cs35l56.c:1328: undefined reference to `wm_adsp_stop'
    xtensa-linux-ld: sound/soc/codecs/cs35l56.c:531: undefined reference to `wm_adsp_power_down'
    xtensa-linux-ld: sound/soc/codecs/cs35l56.c:536: undefined reference to `wm_adsp2_component_remove'

Unverified Error/Warning (likely false positive, kindly check if interested):

    fs/gfs2/log.c:1044 gfs2_remove_from_journal() error: dereferencing freed memory 'bh' (line 1038)
    fs/gfs2/log.c:1051 gfs2_remove_from_journal() warn: passing freed memory 'bh' (line 1038)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-r063-20260324
|   `-- drivers-gpu-drm-bridge-lontium-lt8713sx.c:(.text):undefined-reference-to-__udivdi3
|-- s390-randconfig-r072-20260324
|   |-- fs-gfs2-log.c-gfs2_remove_from_journal()-error:dereferencing-freed-memory-bh-(line-)
|   `-- fs-gfs2-log.c-gfs2_remove_from_journal()-warn:passing-freed-memory-bh-(line-)
|-- sparc-randconfig-002-20260324
|   |-- pcie-mediatek-gen3.c:(.text):undefined-reference-to-pci_pwrctrl_create_devices
|   |-- pcie-mediatek-gen3.c:(.text):undefined-reference-to-pci_pwrctrl_power_off_devices
|   |-- pcie-mediatek-gen3.c:(.text):undefined-reference-to-pci_pwrctrl_power_on_devices
|   |-- sparc-linux-ld:pcie-mediatek-gen3.c:(.text):undefined-reference-to-pci_pwrctrl_destroy_devices
|   `-- sparc-linux-ld:pcie-mediatek-gen3.c:(.text):undefined-reference-to-pci_pwrctrl_power_off_devices
`-- xtensa-randconfig-001-20260324
    |-- include-linux-property.h:undefined-reference-to-wm_adsp2_remove
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp2_component_probe
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp2_component_remove
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp2_remove
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp_early_event
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp_event
    |-- sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_halo_init
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp2_component_probe
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp2_remove
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp_early_event
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_adsp_event
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.c:undefined-reference-to-wm_halo_init
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.c:undefined-reference-to-wm_adsp_event
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l45.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56-shared.c:undefined-reference-to-cs_dsp_coeff_read_ctrl
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56-shared.c:undefined-reference-to-cs_dsp_get_ctl
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56.c:undefined-reference-to-wm_adsp2_component_remove
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56.c:undefined-reference-to-wm_adsp_power_down
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56.c:undefined-reference-to-wm_adsp_power_up
    |-- xtensa-linux-ld:sound-soc-codecs-cs35l56.c:undefined-reference-to-wm_adsp_run
    `-- xtensa-linux-ld:sound-soc-codecs-cs35l56.c:undefined-reference-to-wm_adsp_stop

elapsed time: 817m

configs tested: 234
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260324    gcc-11.5.0
arc                   randconfig-001-20260324    gcc-8.5.0
arc                   randconfig-002-20260324    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260324    gcc-8.5.0
arm                   randconfig-002-20260324    gcc-14.3.0
arm                   randconfig-002-20260324    gcc-8.5.0
arm                   randconfig-003-20260324    gcc-8.5.0
arm                   randconfig-004-20260324    clang-23
arm                   randconfig-004-20260324    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260324    gcc-13.4.0
arm64                 randconfig-002-20260324    gcc-13.4.0
arm64                 randconfig-002-20260324    gcc-8.5.0
arm64                 randconfig-003-20260324    clang-23
arm64                 randconfig-003-20260324    gcc-13.4.0
arm64                 randconfig-004-20260324    clang-23
arm64                 randconfig-004-20260324    gcc-13.4.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260324    gcc-13.4.0
csky                  randconfig-001-20260324    gcc-15.2.0
csky                  randconfig-002-20260324    gcc-13.4.0
csky                  randconfig-002-20260324    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260324    clang-23
hexagon               randconfig-002-20260324    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260324    gcc-12
i386        buildonly-randconfig-002-20260324    clang-20
i386        buildonly-randconfig-002-20260324    gcc-12
i386        buildonly-randconfig-003-20260324    clang-20
i386        buildonly-randconfig-003-20260324    gcc-12
i386        buildonly-randconfig-004-20260324    gcc-12
i386        buildonly-randconfig-004-20260324    gcc-14
i386        buildonly-randconfig-005-20260324    clang-20
i386        buildonly-randconfig-005-20260324    gcc-12
i386        buildonly-randconfig-006-20260324    gcc-12
i386        buildonly-randconfig-006-20260324    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260324    clang-20
i386                  randconfig-001-20260324    gcc-14
i386                  randconfig-002-20260324    clang-20
i386                  randconfig-003-20260324    clang-20
i386                  randconfig-004-20260324    clang-20
i386                  randconfig-005-20260324    clang-20
i386                  randconfig-006-20260324    clang-20
i386                  randconfig-006-20260324    gcc-14
i386                  randconfig-007-20260324    clang-20
i386                  randconfig-007-20260324    gcc-14
i386                  randconfig-011-20260324    clang-20
i386                  randconfig-011-20260324    gcc-13
i386                  randconfig-012-20260324    clang-20
i386                  randconfig-012-20260324    gcc-13
i386                  randconfig-013-20260324    gcc-13
i386                  randconfig-013-20260324    gcc-14
i386                  randconfig-014-20260324    gcc-13
i386                  randconfig-015-20260324    gcc-13
i386                  randconfig-015-20260324    gcc-14
i386                  randconfig-016-20260324    gcc-13
i386                  randconfig-017-20260324    clang-20
i386                  randconfig-017-20260324    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260324    gcc-14.3.0
loongarch             randconfig-002-20260324    clang-18
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           mtx1_defconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260324    gcc-11.5.0
nios2                 randconfig-002-20260324    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260324    gcc-12.5.0
parisc                randconfig-001-20260324    gcc-8.5.0
parisc                randconfig-002-20260324    gcc-10.5.0
parisc                randconfig-002-20260324    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260324    gcc-8.5.0
powerpc               randconfig-002-20260324    gcc-8.5.0
powerpc                  storcenter_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260324    gcc-14.3.0
powerpc64             randconfig-001-20260324    gcc-8.5.0
powerpc64             randconfig-002-20260324    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260324    clang-23
riscv                 randconfig-002-20260324    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260324    clang-23
s390                  randconfig-001-20260324    gcc-12.5.0
s390                  randconfig-002-20260324    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260324    clang-23
sh                    randconfig-001-20260324    gcc-15.2.0
sh                    randconfig-002-20260324    clang-23
sh                    randconfig-002-20260324    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260324    gcc-14
sparc                 randconfig-001-20260324    gcc-15.2.0
sparc                 randconfig-002-20260324    gcc-14
sparc                 randconfig-002-20260324    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260324    clang-23
sparc64               randconfig-001-20260324    gcc-14
sparc64               randconfig-002-20260324    clang-20
sparc64               randconfig-002-20260324    gcc-14
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260324    gcc-14
um                    randconfig-002-20260324    clang-17
um                    randconfig-002-20260324    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260324    gcc-14
x86_64      buildonly-randconfig-002-20260324    clang-20
x86_64      buildonly-randconfig-002-20260324    gcc-14
x86_64      buildonly-randconfig-003-20260324    clang-20
x86_64      buildonly-randconfig-003-20260324    gcc-14
x86_64      buildonly-randconfig-004-20260324    gcc-14
x86_64      buildonly-randconfig-005-20260324    gcc-12
x86_64      buildonly-randconfig-005-20260324    gcc-14
x86_64      buildonly-randconfig-006-20260324    clang-20
x86_64      buildonly-randconfig-006-20260324    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260324    gcc-14
x86_64                randconfig-002-20260324    clang-20
x86_64                randconfig-003-20260324    gcc-14
x86_64                randconfig-004-20260324    gcc-14
x86_64                randconfig-005-20260324    gcc-14
x86_64                randconfig-006-20260324    clang-20
x86_64                randconfig-011-20260324    clang-20
x86_64                randconfig-011-20260324    gcc-14
x86_64                randconfig-012-20260324    gcc-14
x86_64                randconfig-013-20260324    gcc-14
x86_64                randconfig-014-20260324    clang-20
x86_64                randconfig-014-20260324    gcc-14
x86_64                randconfig-015-20260324    gcc-14
x86_64                randconfig-016-20260324    clang-20
x86_64                randconfig-016-20260324    gcc-14
x86_64                randconfig-071-20260324    gcc-12
x86_64                randconfig-071-20260324    gcc-14
x86_64                randconfig-072-20260324    gcc-12
x86_64                randconfig-072-20260324    gcc-14
x86_64                randconfig-073-20260324    gcc-12
x86_64                randconfig-073-20260324    gcc-14
x86_64                randconfig-074-20260324    gcc-12
x86_64                randconfig-075-20260324    gcc-12
x86_64                randconfig-075-20260324    gcc-14
x86_64                randconfig-076-20260324    gcc-12
x86_64                randconfig-076-20260324    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                randconfig-001-20260324    gcc-14
xtensa                randconfig-001-20260324    gcc-8.5.0
xtensa                randconfig-002-20260324    gcc-14
xtensa                randconfig-002-20260324    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

