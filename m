Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F45CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 22:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AD38E01E6; Thu, 30 Oct 2025 18:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB118E009F; Thu, 30 Oct 2025 18:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9A28E01E6; Thu, 30 Oct 2025 18:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE478E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:09:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3BE716029E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:09:30 +0000 (UTC)
X-FDA: 84056172942.02.B7E7011
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52E1F80016
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:09:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLDz5Pq8;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761862169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=tqg73KSPv5cfBM5WgyTNWeTkhuEWU7mFfaz21dv9SgE=;
	b=1DGPqGS/UtX7HvCHWE3eWle8N7qw/Tp6MIwqQ7ldAXFDqtn0ZDkB4R+t6NJBmHzwzYvXR7
	pZRyrZ7lnd9QTn9rfvs0XN+NXetJAoC2jmgNsIwRdpchs07GJR9R9TXT2ZV/cDwfd/YWt4
	Ls+QR6XSXKX9denOcMncax81g52gFrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761862169; a=rsa-sha256;
	cv=none;
	b=M1BedTepKqTHTmY+bUdfv5qCxn/a75/3R3sEDzOqMLPrA73muBjQaHMEv6jtJG/IW7VrY9
	aSSvAW7+Bj2JvSxfq43fCh72Zgv0Nf3MlrkiloXSuVbv1xKKGg2VCW+SbBDMQusGUf83Vd
	BpZUB6/heTmsp6D58aXFBA9s1WzUbtc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PLDz5Pq8;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761862168; x=1793398168;
  h=date:from:to:cc:subject:message-id;
  bh=HUNqY13A1kXQqPH5Y488mB9YhSQqhvLEJZ0K72pzhzQ=;
  b=PLDz5Pq8k0QwXWiLojetkJBYyL6uOEGyHMSbsrh5kcTu0TwkGWDHOze5
   wZCHO3jfOhkU7dw7IBkjESNfv4qunbB35e27LQG13h1c0iCFPPRQYALPV
   weEr+8QQx/BUxH7pndLHnBppqUCFGRCD7zio5ueNjrIEx82BxoSTLn4U9
   ok/MWrP8OV9ZCAaUDkLD19AmOl+Ow61vBtrvv9CyW+WyfJHlho6Lnjdw4
   OLTYA6SdZhUUomYG/DQDC3D7zh/cCCJJ3gEn+PYeRv40lIpchE0wosKPa
   np4YYRWlwbngyXM8gLraKvfjHKztAVNvAoMadQozLZ3PONIOMGVIA2tfE
   g==;
X-CSE-ConnectionGUID: sTNn9gX+Tfa3OZdZ4jy39g==
X-CSE-MsgGUID: 7owMuqTKQG2z5SoQNUe80A==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64050626"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64050626"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 15:09:26 -0700
X-CSE-ConnectionGUID: UJEmjE+gSriBNXF4V5hLhw==
X-CSE-MsgGUID: +cjUaQyySPqcJ3NDTofHAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185758895"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 30 Oct 2025 15:09:25 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEape-000MZL-2M;
	Thu, 30 Oct 2025 22:09:22 +0000
Date: Fri, 31 Oct 2025 06:09:08 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 131f3d9446a6075192cdd91f197989d98302faa6
Message-ID: <202510310641.OO5XPtt4-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Stat-Signature: oz6eat7cmte6pjzdziw8f19qbbeboxci
X-Rspam-User: 
X-Rspamd-Queue-Id: 52E1F80016
X-HE-Tag: 1761862168-590037
X-HE-Meta: U2FsdGVkX18cMjMrUklLrRbJSYapItMTo1Zz58/73EZu704hvTdixabJrwo5dx08Bp97oe64Yc36tzaPyvCXrSkeXW4cS40R/9BuTVBmbP1E/SiN91IW2WxVkdPx1BWI4eoIuSIbhbGDuaXxbksUqVKQBd2XWozbzyj36SKONBQlMU0iEAJlt9AQ4va4gPiLPpvwqrPjz+CGdA2FLNjnawhsCsNT4L9QHmd02dQaf9Gr9Eq6lFajcTl5but5QdlMpDlq1B/BuZ8cI4xlVs5fF4V/+WeZKD3Fm91gSr06jQTg3JTybfSrRnSzUyX4e9f4Nz9H/Q7BdwWrI0PGRteisKpuhpP0bBrDE8nBhdqfZ4YuG6Bw3Cpco8zfmlSmw8W2wIjJZmkYONdbDcMJdUGQyZnFwwUmrnZUA1rfJmUAXdi1hvTIY2swzLOITMhN6RDCcpMK58mmziAVFQxJEYPj9UYnpxg0V2HGMA5WdkO3huKrWdD0d1u6xpbMmf2QHbtH8Yf7OoYsbo6bizxkzoLUozw6LS18oxM/ekV4oj7O4ecy+vBtlxHEMXA3S1WLXhhArgXsY0oSd1YQ8ZU2j+zOn4kF0OoqdaCz8djsCyLn1MzXeCXc6yWiAaRJ1GnYiVWU5sDPywSD+ir++8ScrYiH7acrm7hTVXz+wu1vO1YtU1O5INhBaH7+LSVYARUez6Qwqqz7OPHRJT5X6KwzaS90go5N4EwA6rokCrpIXIsg2sS7GnBEG4tYFGa9N8RyBQWHmcnyp8+g9jKEc5DjJmdRDEqZnja5FtrA4/YAkbzIBbq6JyA3PG3SeF9zEAaVL8xSWamQdNAL78f5QnZ1UWeu7afD+5MVzhq3IDVisyqZcDoiuTulDKatgitIo+xb73LBZL7Qraz28t/bqzODu/umbEp3PUlv/+CkSxMJ0GE+JriBAPJF0ihzizLkB/8L3BgjD5RmV+iqFUlpI3TnKL/
 kQwwLu1M
 KgVpVFRji6Gob4dm7IPjurmtTL88BTCAZwtJmK9ujI7Gn/BZpKuZK+Kg6fXWRWGIQCg+rk21bbMo3p2NVjk/O3FwG1oxECHXEpbgQE7K3IN9mDJ7sLRtByYFIpfi3d5LerPyHVwvXF/6VY0w0lcAu9MmA1MKJjgQCNZXHfDfeuzFhEHD9tk+iL1rsQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 131f3d9446a6075192cdd91f197989d98302faa6  Add linux-next specific files for 20251030

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510220954.lcvy1Yp7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510271906.1346pSIO-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510272037.nf7xzQxk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510282030.nzq0BTFH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291500.a2Lg0OSH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291626.PW7a9uD7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292307.DmOaSI39-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510301311.TcOCnZ1s-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510302348.Knwt7vQ1-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510241912.s8uQLYlp-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242155.afchO66g-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242250.ZzaqW0pV-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510242322.aWclvr7e-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202510250132.FdNONf4v-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    arch/riscv/include/asm/cmpxchg.h:419: Error: unrecognized opcode `0x00d00073'
    arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
    arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
    arch/x86/hyperv/hv_crash.c:631:2: error: must use 'struct' tag to refer to type 'smp_ops'
    arch/x86/hyperv/hv_crash.c:631:9: error: expected identifier or '('
    drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_stream_encoder.c:1571:69: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
    drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/amdgpu_ras_mgr.c:132:(.text+0x134): undefined reference to `__udivdi3'
    drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/amdgpu_ras_mgr.c:132:(.text+0x138): undefined reference to `__udivdi3'
    drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/amdgpu_ras_mgr.c:132:(.text+0x161): undefined reference to `__udivdi3'
    hda.c:(.text.unlikely+0xb4): undefined reference to `codec_info_list'
    include/linux/device/devres.h:59:(.text+0x781): undefined reference to `codec_info_list'
    include/linux/device/devres.h:59:(.text.unlikely+0x98): undefined reference to `codec_info_list'
    ld.lld: error: undefined symbol: devm_backlight_device_register
    ld.lld: error: undefined symbol: mbox_free_channel
    ld.lld: error: undefined symbol: mbox_request_channel_byname
    ld: sound/soc/sof/intel/hda.c:1172:(.text+0x736): undefined reference to `asoc_sdw_get_codec_info_list_count'
    ld: sound/soc/sof/intel/hda.c:1172:(.text.unlikely+0xc5): undefined reference to `asoc_sdw_get_codec_info_list_count'
    ld: sound/soc/sof/intel/hda.c:1176:(.text.unlikely+0xbb): undefined reference to `codec_info_list'
    ld: sound/soc/sof/intel/hda.c:1179:(.text+0x778): undefined reference to `codec_info_list'
    loongarch64-linux-ld: hda.c:(.text.unlikely+0xc0): undefined reference to `codec_info_list'
    loongarch64-linux-ld: hda.c:(.text.unlikely+0xc4): undefined reference to `asoc_sdw_get_codec_info_list_count'
    sound/soc/sof/intel/hda.c:1172:(.text+0x731): undefined reference to `codec_info_list'
    sound/soc/sof/intel/hda.c:1179:(.text.unlikely+0x9e): undefined reference to `codec_info_list'
    sound/soc/sof/intel/hda.c:1221:(.text+0x89d): undefined reference to `asoc_sdw_get_codec_info_list_count'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/vkms/vkms_configfs.c:223 make_crtc_group() error: dereferencing freed memory 'crtc' (line 222)
    drivers/gpu/drm/vkms/vkms_configfs.c:377 make_plane_group() error: dereferencing freed memory 'plane' (line 376)
    drivers/gpu/drm/vkms/vkms_configfs.c:491 make_encoder_group() error: dereferencing freed memory 'encoder' (line 490)
    drivers/gpu/drm/vkms/vkms_configfs.c:656 make_connector_group() error: dereferencing freed memory 'connector' (line 655)
    drivers/gpu/drm/vkms/vkms_configfs.c:770 make_device_group() error: dereferencing freed memory 'dev' (line 769)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- alpha-randconfig-r134-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-randconfig-003-20251030
|   |-- ld.lld:error:undefined-symbol:mbox_free_channel
|   `-- ld.lld:error:undefined-symbol:mbox_request_channel_byname
|-- arm64-randconfig-004-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-randconfig-r121-20251030
|   `-- drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le64-assigned-usertype-base-got-unsigned-long-long-usertype-shared_
|-- csky-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- csky-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- hexagon-randconfig-002-20251030
|   `-- ld.lld:error:undefined-symbol:devm_backlight_device_register
|-- i386-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- i386-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- i386-randconfig-006-20251030
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-013-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- i386-randconfig-014-20251030
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-017-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- drivers-gpu-drm-amd-amdgpu-..-ras-ras_mgr-amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|-- i386-randconfig-052-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- include-linux-device-devres.h:(.text):undefined-reference-to-codec_info_list
|   |-- ld:sound-soc-sof-intel-hda.c:(.text):undefined-reference-to-asoc_sdw_get_codec_info_list_count
|   |-- ld:sound-soc-sof-intel-hda.c:(.text):undefined-reference-to-codec_info_list
|   |-- sound-soc-sof-intel-hda.c:(.text):undefined-reference-to-asoc_sdw_get_codec_info_list_count
|   `-- sound-soc-sof-intel-hda.c:(.text):undefined-reference-to-codec_info_list
|-- i386-randconfig-054-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- drivers-gpu-drm-amd-amdgpu-..-ras-ras_mgr-amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|   |-- include-linux-device-devres.h:(.text.unlikely):undefined-reference-to-codec_info_list
|   |-- ld:sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-asoc_sdw_get_codec_info_list_count
|   |-- ld:sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|   `-- sound-soc-sof-intel-hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|-- i386-randconfig-061-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-hwss-dcn401-dcn401_hwseq.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|   `-- drivers-gpu-drm-amd-amdgpu-..-ras-ras_mgr-amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|-- i386-randconfig-063-20251030
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- loongarch-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- loongarch-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- loongarch-defconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- loongarch-randconfig-r073-20251031
|   |-- hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|   |-- loongarch64-linux-ld:hda.c:(.text.unlikely):undefined-reference-to-asoc_sdw_get_codec_info_list_count
|   `-- loongarch64-linux-ld:hda.c:(.text.unlikely):undefined-reference-to-codec_info_list
|-- microblaze-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- microblaze-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- mips-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- mips-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- openrisc-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- openrisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- powerpc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- powerpc64-randconfig-001-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- riscv-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- riscv-allyesconfig
|   `-- arch-riscv-include-asm-vdso-processor.h:error:expected-instruction-format
|-- riscv-randconfig-r071-20251030
|   `-- drivers-pmdomain-mediatek-mtk-pm-domains.c-scpsys_add_one_domain()-error:we-previously-assumed-pd-data-could-be-null-(see-line-)
|-- riscv-randconfig-r073-20251030
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_connector_group()-error:dereferencing-freed-memory-connector-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_crtc_group()-error:dereferencing-freed-memory-crtc-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_device_group()-error:dereferencing-freed-memory-dev-(line-)
|   |-- drivers-gpu-drm-vkms-vkms_configfs.c-make_encoder_group()-error:dereferencing-freed-memory-encoder-(line-)
|   `-- drivers-gpu-drm-vkms-vkms_configfs.c-make_plane_group()-error:dereferencing-freed-memory-plane-(line-)
|-- riscv-randconfig-r132-20251030
|   |-- arch-riscv-include-asm-cmpxchg.h:Error:unrecognized-opcode
|   `-- arch-riscv-include-asm-vdso-processor.h:Error:unrecognized-opcode
|-- s390-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- um-randconfig-002-20251030
|   `-- clang:error:linker-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- x86_64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-randconfig-003-20251030
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-randconfig-076-20251030
|   |-- arch-x86-hyperv-hv_crash.c:error:expected-identifier-or-(
|   `-- arch-x86-hyperv-hv_crash.c:error:must-use-struct-tag-to-refer-to-type-smp_ops
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
`-- x86_64-rhel-9.4-rust
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
    `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog

elapsed time: 893m

configs tested: 186
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                          axs103_defconfig    gcc-15.1.0
arc                      axs103_smp_defconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251030    gcc-11.5.0
arc                   randconfig-002-20251030    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                         lpc18xx_defconfig    clang-22
arm                   randconfig-001-20251030    gcc-10.5.0
arm                   randconfig-002-20251030    clang-19
arm                   randconfig-003-20251030    clang-22
arm                   randconfig-004-20251030    clang-22
arm                           sama7_defconfig    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251030    gcc-12.5.0
arm64                 randconfig-002-20251030    gcc-8.5.0
arm64                 randconfig-003-20251030    clang-17
arm64                 randconfig-004-20251030    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251030    gcc-13.4.0
csky                  randconfig-002-20251030    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251030    clang-22
hexagon               randconfig-002-20251030    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251030    clang-20
i386        buildonly-randconfig-002-20251030    gcc-14
i386        buildonly-randconfig-003-20251030    clang-20
i386        buildonly-randconfig-004-20251030    clang-20
i386        buildonly-randconfig-005-20251030    gcc-14
i386        buildonly-randconfig-006-20251030    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251030    gcc-14
i386                  randconfig-002-20251030    gcc-14
i386                  randconfig-003-20251030    clang-20
i386                  randconfig-004-20251030    clang-20
i386                  randconfig-005-20251030    clang-20
i386                  randconfig-006-20251030    clang-20
i386                  randconfig-007-20251030    clang-20
i386                  randconfig-011-20251030    gcc-14
i386                  randconfig-012-20251030    gcc-14
i386                  randconfig-013-20251030    gcc-14
i386                  randconfig-014-20251030    clang-20
i386                  randconfig-015-20251030    gcc-14
i386                  randconfig-016-20251030    gcc-14
i386                  randconfig-017-20251030    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251030    clang-22
loongarch             randconfig-002-20251030    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                      maltaaprp_defconfig    clang-22
mips                        vocore2_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251030    gcc-8.5.0
nios2                 randconfig-002-20251030    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251030    gcc-8.5.0
parisc                randconfig-002-20251030    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                    gamecube_defconfig    clang-22
powerpc               randconfig-001-20251030    clang-22
powerpc               randconfig-002-20251030    clang-22
powerpc64             randconfig-001-20251030    gcc-8.5.0
powerpc64             randconfig-002-20251030    gcc-8.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251030    gcc-13.4.0
riscv                 randconfig-002-20251030    gcc-15.1.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251030    clang-17
s390                  randconfig-002-20251030    gcc-8.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251030    gcc-15.1.0
sh                    randconfig-002-20251030    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251030    gcc-8.5.0
sparc                 randconfig-002-20251030    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251030    gcc-11.5.0
sparc64               randconfig-002-20251030    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251030    gcc-14
um                    randconfig-002-20251030    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251030    clang-20
x86_64      buildonly-randconfig-002-20251030    gcc-14
x86_64      buildonly-randconfig-003-20251030    gcc-13
x86_64      buildonly-randconfig-004-20251030    gcc-14
x86_64      buildonly-randconfig-005-20251030    clang-20
x86_64      buildonly-randconfig-006-20251030    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251030    clang-20
x86_64                randconfig-002-20251030    gcc-14
x86_64                randconfig-003-20251030    clang-20
x86_64                randconfig-004-20251030    gcc-12
x86_64                randconfig-005-20251030    clang-20
x86_64                randconfig-006-20251030    gcc-14
x86_64                randconfig-011-20251030    clang-20
x86_64                randconfig-012-20251030    clang-20
x86_64                randconfig-013-20251030    gcc-13
x86_64                randconfig-014-20251030    gcc-14
x86_64                randconfig-015-20251030    clang-20
x86_64                randconfig-016-20251030    clang-20
x86_64                randconfig-071-20251030    gcc-14
x86_64                randconfig-072-20251030    gcc-14
x86_64                randconfig-073-20251030    clang-20
x86_64                randconfig-074-20251030    clang-20
x86_64                randconfig-075-20251030    gcc-13
x86_64                randconfig-076-20251030    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251030    gcc-10.5.0
xtensa                randconfig-002-20251030    gcc-13.4.0
xtensa                    smp_lx200_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

