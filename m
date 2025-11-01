Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692CCCCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 02:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9678E00AD; Fri, 31 Oct 2025 22:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A278E0068; Fri, 31 Oct 2025 22:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378EF8E00AD; Fri, 31 Oct 2025 22:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9278E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 22:36:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1D85140692
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 02:36:01 +0000 (UTC)
X-FDA: 84060473322.12.0A03870
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0957A100009
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 02:35:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eusadvVj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761964560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=FvSS1/7yZOrPQm9LhCxSsbFTObl2zO51hYQ+MrZpGlI=;
	b=GUajZQ79klxSPT54U37UDHSS8dF+DIPrSHbmGZ7gF7hKMRDdub17VmQBtDdG7zGHUxe/sR
	xj2bxRk+sDYVfzE5yBGi4NAC9rUOOwJcbrWt+mkoOTE0utaWvVgLfPMHmW2IwY6c+khxWM
	Oriz82Pcjx0E35oJN/ceY8eni0u6cc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761964560; a=rsa-sha256;
	cv=none;
	b=qSTy4VJJb3g9TKHFIWuzDqIaBZShjaKTY6ldgwFUNHwfMIIa4uFFOBDzQXzsOKPgtYDPai
	/rZeZQ9l7CFEWBZr/MVlO9JAwMw/vANYrfmeC6x4ncr1uqYaHRTraojWhEOxpG2STi/z/k
	SOgrc/yCTRG8wXEr8r7XCS7yz198eec=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eusadvVj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761964559; x=1793500559;
  h=date:from:to:cc:subject:message-id;
  bh=QhdL8RJwE1U2ocSN3pKQe9xEfrfuuI+BzTEPnAiyXaA=;
  b=eusadvVjb759ILRVdt3MG4HgrscSkU/FZIcYYgWdUJNhh3/8WiYv0ArF
   u/z9Ua4Dv7PikGBsxLzySBoDtf7QqDtQSP2Wr5tJYE33om4d+We8mXyCr
   2g+gyffn/L1F4nmzty+lvWCCwQFYydPT9eSWmTvjVSPitqCOace3NICHU
   h78D1txW48wenSzDhEgsHYlf5cNk2wgLPOIB75EimsICumoh6V3DnxUbV
   uyJzNsB80QBEi0i5LqCUu2p72GZxATChC8wawsc/QQuUiJo2I5jNp4LFw
   ZlzFbKhYhWqhqs8eXzy/w1yuUShQDCmqqwUd2IbRRKn3UvKOlezyj3pEo
   w==;
X-CSE-ConnectionGUID: 5ZsBtbFlTHWsS3+PW+wlXg==
X-CSE-MsgGUID: c9ZOcQUMRMGFO3a/thiGQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="67785290"
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="67785290"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 19:35:57 -0700
X-CSE-ConnectionGUID: VUOtf8ZPRF+41rkxuAozRw==
X-CSE-MsgGUID: VaRSXhFxQxCm7DsRQI+wmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="209937320"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 31 Oct 2025 19:35:56 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vF1T7-000NsK-2l;
	Sat, 01 Nov 2025 02:35:53 +0000
Date: Sat, 01 Nov 2025 10:35:51 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 98bd8b16ae57e8f25c95d496fcde3dfdd8223d41
Message-ID: <202511011025.f3WQJ7dy-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam01
X-Stat-Signature: kqsnfxkie3kddkkkancay6r5wkncjqdq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0957A100009
X-HE-Tag: 1761964558-650855
X-HE-Meta: U2FsdGVkX18wnw/VIOG91b7apHgE2g9Xbpme1fE9gSZ5M3n4EdEhnF+olgS776+ELACY9Y5gtXjhTfgxqPy3hzYh1DlUWw3lmPX2N/Z6vcmvMMW85cwgRn0fB22E4Wo3ElXuOY2kKmcnp8um8xgI1z1ZljEKaI6Q9U8aQqOsSYiHzemhyJs4ZOk/BVcnC9lIVlU5LdTLECxRNsDR2FT5Nge/J/sqGq5ftmq42UhkEBr+i1qPZ2/ftT2fMCdsb4pUctJsPLdBSxXBXsrUksktGC2SjncvMWwvxQEGhpBWvE20dHNJr5ncrxSGlyWgQOms99tmjALsc1/dCeHRZLtmL6eRyhqCyfLtZHKjqtfSIGFkTlvrYofeaWDD+715bVE2ImQsPcNBukvmYxNkGZr9iyI80MlSd+WM4dy82I4qUIGW6x0ZBkEpTI13VRtrS8MbF5tbsc+V0EWoA0D+d2VGxOj6Izy42uCGcRQWF8E/zZC85qwt5wuZA/sS1FtL3Vn3c1V9fhfEuBa+XFiXUmaii80l8N74SliJeIV3jloP2OrGASRvhZkXf/YE75lSutbY6RXPCFCPl+OdibZ9LRoAqNvTOU57YTYLV8txJJIhV52VNuAakGxWuo+DltzmFhSBIXtywcXQSK6LBj/9bkLlJvDSk97WsSoLwgr8er1r+uXDHOSRu2ER3HkglNSamGtlxRShdKsjoSuZnHh4nOG5ttim+AsvPxPnNBVndsNRjNxDx0wZzj4y8s2iz/Ii32jY6JnPljDcTrBjC+j7RrqxBBpUq9OCN09tUHX1oRyRlgPQO3qSUc/r7gzhUKsxY8hsWswDSSTBPXduDenA6w7kkuueusVn464zwMp2UbV4iNLnM4Vlec/nw+ARzF2ZibSLf7jujrqwPHTCY/7h0uZ6dLLbjlb0P01J/FCiH3DjdRE1S2wtWvWmdvnZlnXzJuAMQr1r0cK+PxWnxGaLMId
 ui5349KE
 tr4Fz3HuBnMUjbGsNhVg/Ucj6YLOT3Mw0VolucM+aE5sPZiBAJMg9L58jQVy2su1hWdOAjbGSvUVE6p9dpjXwtiICvLZQOqICyLMxlLLT9wcwsCseQRyySanvpdXQHSDGuYSwSyfIvtnBczUYthJp9X1ukSeWslGBY9qzs7uSVryrWpRCBWq/CnXd0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 98bd8b16ae57e8f25c95d496fcde3dfdd8223d41  Add linux-next specific files for 20251031

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510250422.YmoOlBv8-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510282030.nzq0BTFH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291500.a2Lg0OSH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292307.DmOaSI39-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510302348.Knwt7vQ1-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511010200.BobYItig-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    amdgpu_ras_mgr.c:(.text+0x134): undefined reference to `__udivdi3'
    arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
    arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
    drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_stream_encoder.c:1571:69: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
    drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/amdgpu_ras_mgr.c:132:(.text+0x136): undefined reference to `__udivdi3'
    drivers/gpu/drm/panel/panel-visionox-rm69299.c:343:(.text+0x408): undefined reference to `devm_backlight_device_register'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
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
|-- i386-buildonly-randconfig-001-20251031
|   `-- amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|-- i386-randconfig-001-20251031
|   `-- drivers-gpu-drm-panel-panel-visionox-rm69299.c:(.text):undefined-reference-to-devm_backlight_device_register
|-- i386-randconfig-002-20251031
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- i386-randconfig-011-20251031
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-012-20251031
|   `-- drivers-gpu-drm-amd-amdgpu-..-ras-ras_mgr-amdgpu_ras_mgr.c:(.text):undefined-reference-to-__udivdi3
|-- i386-randconfig-013-20251031
|   `-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|-- i386-randconfig-015-20251031
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
|-- parisc-randconfig-002-20251031
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-randconfig-r111-20251031
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
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
|-- powerpc64-randconfig-r133-20251031
|   `-- drivers-pmdomain-mediatek-mtk-mfg-pmdomain.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le64-assigned-usertype-base-got-unsigned-long-long-usertype-shared_
|-- riscv-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- riscv-allyesconfig
|   `-- arch-riscv-include-asm-vdso-processor.h:error:expected-instruction-format
|-- riscv-randconfig-001-20251031
|   `-- arch-riscv-include-asm-vdso-processor.h:Error:unrecognized-opcode
|-- riscv-randconfig-002-20251031
|   `-- arch-riscv-include-asm-vdso-processor.h:error:expected-instruction-format
|-- s390-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- s390-randconfig-002-20251031
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
|-- sparc64-randconfig-002-20251031
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc64-randconfig-r113-20251031
|   |-- kernel-sched-ext.c:sparse:sparse:incorrect-type-in-initializer-(different-address-spaces)-expected-struct-scx_kick_syncs-ksyncs-got-struct-scx_kick_syncs-noderef-__rcu
|   `-- kernel-sched-ext.c:sparse:sparse:symbol-scx_bpf_reenqueue_local___v2-was-not-declared.-Should-it-be-static
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
|-- x86_64-randconfig-001-20251031
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
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

elapsed time: 1004m

configs tested: 179
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251031    gcc-8.5.0
arc                   randconfig-002-20251031    gcc-8.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                       aspeed_g4_defconfig    clang-22
arm                       imx_v4_v5_defconfig    clang-22
arm                         lpc32xx_defconfig    clang-17
arm                   randconfig-001-20251031    gcc-14.3.0
arm                   randconfig-002-20251031    clang-22
arm                   randconfig-003-20251031    gcc-11.5.0
arm                   randconfig-004-20251031    clang-22
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                 randconfig-001-20251031    gcc-8.5.0
arm64                 randconfig-002-20251031    clang-22
arm64                 randconfig-003-20251031    gcc-10.5.0
arm64                 randconfig-004-20251031    gcc-14.3.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                  randconfig-001-20251031    gcc-9.5.0
csky                  randconfig-002-20251031    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon               randconfig-001-20251031    clang-22
hexagon               randconfig-002-20251031    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251031    gcc-14
i386        buildonly-randconfig-002-20251031    gcc-14
i386        buildonly-randconfig-003-20251031    clang-20
i386        buildonly-randconfig-004-20251031    gcc-14
i386        buildonly-randconfig-005-20251031    clang-20
i386        buildonly-randconfig-006-20251031    gcc-14
i386                  randconfig-001-20251031    gcc-14
i386                  randconfig-002-20251031    gcc-14
i386                  randconfig-003-20251031    gcc-14
i386                  randconfig-004-20251031    gcc-14
i386                  randconfig-005-20251031    gcc-14
i386                  randconfig-006-20251031    gcc-12
i386                  randconfig-007-20251031    clang-20
i386                  randconfig-011-20251031    clang-20
i386                  randconfig-012-20251031    gcc-13
i386                  randconfig-013-20251031    gcc-13
i386                  randconfig-014-20251031    gcc-14
i386                  randconfig-015-20251031    clang-20
i386                  randconfig-016-20251031    clang-20
i386                  randconfig-017-20251031    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251031    gcc-15.1.0
loongarch             randconfig-002-20251031    gcc-14.3.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5208evb_defconfig    gcc-15.1.0
m68k                           virt_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251031    gcc-9.5.0
nios2                 randconfig-002-20251031    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251031    gcc-14.3.0
parisc                randconfig-002-20251031    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20251031    clang-22
powerpc               randconfig-002-20251031    gcc-12.5.0
powerpc64             randconfig-001-20251031    clang-22
powerpc64             randconfig-002-20251031    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251031    gcc-8.5.0
riscv                 randconfig-002-20251031    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251031    clang-16
s390                  randconfig-002-20251031    gcc-12.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251031    gcc-14.3.0
sh                    randconfig-002-20251031    gcc-14.3.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251031    gcc-8.5.0
sparc                 randconfig-002-20251031    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251031    gcc-8.5.0
sparc64               randconfig-002-20251031    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251031    gcc-14
um                    randconfig-002-20251031    clang-22
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251031    clang-20
x86_64      buildonly-randconfig-002-20251031    gcc-14
x86_64      buildonly-randconfig-003-20251031    clang-20
x86_64      buildonly-randconfig-004-20251031    gcc-14
x86_64      buildonly-randconfig-005-20251031    gcc-14
x86_64      buildonly-randconfig-006-20251031    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251031    gcc-14
x86_64                randconfig-002-20251031    clang-20
x86_64                randconfig-003-20251031    clang-20
x86_64                randconfig-004-20251031    gcc-14
x86_64                randconfig-005-20251031    gcc-14
x86_64                randconfig-006-20251031    gcc-14
x86_64                randconfig-011-20251031    gcc-14
x86_64                randconfig-012-20251031    clang-20
x86_64                randconfig-013-20251031    gcc-14
x86_64                randconfig-014-20251031    gcc-14
x86_64                randconfig-015-20251031    gcc-14
x86_64                randconfig-016-20251031    clang-20
x86_64                randconfig-071-20251031    gcc-14
x86_64                randconfig-072-20251031    clang-20
x86_64                randconfig-073-20251031    gcc-14
x86_64                randconfig-074-20251031    clang-20
x86_64                randconfig-075-20251031    gcc-14
x86_64                randconfig-076-20251031    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251031    gcc-13.4.0
xtensa                randconfig-002-20251031    gcc-8.5.0
xtensa                         virt_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

