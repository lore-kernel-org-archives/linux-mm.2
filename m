Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E601CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A3E8E000D; Wed,  5 Nov 2025 20:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A128E0002; Wed,  5 Nov 2025 20:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34578E000D; Wed,  5 Nov 2025 20:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD32E8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:01:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C42F1601C3
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:01:47 +0000 (UTC)
X-FDA: 84078379854.04.C0C5953
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F2FE14000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:01:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="h5glcAH/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762390905; a=rsa-sha256;
	cv=none;
	b=v13EIu32sO9sMjgIPRsYVK4MLFxSxBLnS/h3Lo/vVfDLvSMM0Xrk2nU2h6+9VPqAJ3lA0X
	h2TVx49BuE5BX2ocj1exhRUNIXg6dq1vlp5ItMAjyjTbQEjRx6diRrN99C9BYUDiJobxF+
	VKU/Xz6dAjMC6izVvTUMpwPquBAvDNs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="h5glcAH/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762390905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pJ+wbmT51KguhPBx9OiDe2lxxuDV1z2Dk9eKyi0VJKA=;
	b=3e8YfHeabjTIqANyISfQL0JycG5ZyNKJLoM+wq+npu5zZdgK4xCD54Yde23ijy0WnyJAx3
	9QMwnqSdKsjC5/t0b+M1h2mQZTxYNgYSVafmOusFP0VoINY5SjmFWObB65ji8CNVNiao/3
	mY6rlrNUo8z1ErvuW1hrMM+hwhAvcik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762390903; x=1793926903;
  h=date:from:to:cc:subject:message-id;
  bh=+Sfv3cTidfFoDL+hchK76QnUTbUZK++LJqTWHgoBiJg=;
  b=h5glcAH/ugYlrvEcWB7yHZY37nhUbIkYu9aJOsEV5G1A5HFQ2L7iHSEu
   piioWS5rqHmQMEIqGOv1gqcuHCX62FdYtoc7bKIIht4Mbgf8hRAHfntX9
   903iRI8RZHPbTiiw8+tI69TI6vaCLolRvt5RiN4a2HYmHMjJf82GU9a+0
   M8pWLmhgXNHiZiuH+Qg/PT5a0LVWyMuQQTlsV+Mpn54cKQrmk1if+Vlm2
   E9Yi6R5oa7Jp2+niT9e/AhW16C8q4qREyD2Dd9r4PdeG+M7GyVFwL8gyi
   tIqf2wRzItMbdNC65vqiz1CqrOmcFLaTKGpZe6ODPqMwMymFvIE71tolg
   w==;
X-CSE-ConnectionGUID: p0guUvZhSAq8qrvfhXgBDg==
X-CSE-MsgGUID: aYjgXChyQXiBNQEIhiuUxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="63724905"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="63724905"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 17:01:41 -0800
X-CSE-ConnectionGUID: duYMP7ZYTESaDWlXTg5s0Q==
X-CSE-MsgGUID: qwW0jYdNTIeMU/WkXybXWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="187455791"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 05 Nov 2025 17:01:41 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGoNf-000TJ6-0x;
	Thu, 06 Nov 2025 01:01:39 +0000
Date: Thu, 06 Nov 2025 09:01:03 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 84d39fb9d529f27d2f3d295430d1be0abdae7a6d
Message-ID: <202511060949.ZKT1cbkc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4F2FE14000B
X-Stat-Signature: 5c8edfm1ot6oz311dsj8f7twcg36cfb3
X-Rspam-User: 
X-HE-Tag: 1762390904-218567
X-HE-Meta: U2FsdGVkX19xYWjyNS6CR9WsDVrmEIjcmGNyXo7K9quahEcPnpWeWYsfrPvkCFuwvUV0M4huB1nSI1Z/0mYOmweslOD59LMMedq7PjmuQLSpxq9jWoGdakYo7CSomTUiuHDEZx48L1FaeSEmQhQWe8rLS0nKrFW1k5j4KbrMwjiAuxIXP+q4+pCOrl5W0/2YAwyg6SCJl9XvPgAd1uqhNzAxEOFC5KTLHgIyMJBUIVLOBb5NnMOWE6nv9stmSIdJguc32i9jg3j/aa9fEGHP0gXuXsJqIgCuXn/Huu379CfvYrJbA29+HdBqMZftGyVr4VuItZ/wdQxSt0aNkodNv4cEQnUN4JGUvHXU3iG73Er9RE6S5bUcvsKzY1Vhac8aSfomPJ4fAW/IcPl5DOaGYiDzdmFAFWtvXVmiWTEyVXnHeIn1FrWfMLt4b5LpN2tUDmfG5HfBX8z8HuDwmGxW3cxp1dsPG78F8mPcohk3n4zSAp0RGE4t8bdTkze6HEHsvQYevjF5WiZ9uR3TlyRQtK3wJLxtZdoxTw4KmSQJr0E8bzePnftGOArQeRG9e4Ckz5I2y5KSmn42MWofoEYxbIfEZP7Zm/y8VQm0qCceydKg3gDEtNvTAgMRjJhdZNxr/XrhFZPyLS3ppLZyFeBCiD79EUkdKq++LG+HYDc9tM1HiR7K9ij5GvpxkU1HHhHx84MBCC6avVKm4sOperiSX4LyLfAi99Bjw4Ji4Aq/LSVCpVwKU8U5zBmIo2Kp88EWsaI/tKm+86ek0ofQBNxs34qfo/GXeN83BaelA/YDEIbvFzg1w40nv4+QaIN8B5H4sb8gGGeJzRQHVa/TPxFo7bLKjJqCPSmyeK0AE3X9EzSLcjwLFlxwoVwAYwDrXeFKgB7tNMNmN3yn8HLgjlhM9tyIHJczBhvyb4W8WZailQErjAvpcY6iAB+COMvuscnuw6VX7rypsfczwifHjgr
 q/WsQ2BY
 JeiIuNHOZVxJUPOCwKt/mJBcm27tiLyz6hWgFrhnGzIJ0wdW4IsQgt8c1TsMlnw775Zg9oGZfa9bwOHK2vqPTwajHNeCpxssve6wS5xf829IQuN9GzHi5jatQRESumnSC6Th/PZtoShgCqSvZ+Wz8r1oxnA9w59LxhJeYzoIjU5/wLwRknlnQX9YUPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 84d39fb9d529f27d2f3d295430d1be0abdae7a6d  Add linux-next specific files for 20251105

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511052112.OWG4sAep-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511060242.1PnkE9qI-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511060511.obhCl9rH-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511051942.WvTQThiM-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511052053.zZZ5GjNx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511052057.dU1s9Y6h-lkp@intel.com

    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1355 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1355 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    drivers/gpu/drm/xe/xe_vm.c:1461:11: error: variable 'number_tiles' set but not used [-Werror,-Wunused-but-set-variable]
    drivers/pinctrl/pinctrl-mpfs-iomux0.c:216:(.text+0x98): undefined reference to `pinconf_generic_dt_node_to_map'
    ide.c:(.text+0x898): undefined reference to `tsm_ide_stream_unregister'
    tsm.c:(.text+0x88c): undefined reference to `find_tsm_dev'
    xtensa-linux-ld: drivers/pinctrl/pinctrl-mpfs-iomux0.c:218:(.text+0xaf): undefined reference to `pinconf_generic_dt_node_to_map'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/xen/grant-dma-ops.c:174 xen_grant_dma_map_phys() warn: mask and shift to zero: expr='offset >> 12'
    fs/btrfs/bio.c:740 btrfs_submit_chunk() warn: variable dereferenced before check 'inode' (see line 665)
    fs/erofs/fileio.c:65 erofs_fileio_rq_submit() error: uninitialized symbol 'ret'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
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
|-- arm64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- i386-randconfig-061-20251105
|   `-- drivers-gpu-drm-xe-xe_vm.c:error:variable-number_tiles-set-but-not-used-Werror-Wunused-but-set-variable
|-- loongarch-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- microblaze-allmodconfig
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
|-- openrisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-allmodconfig
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
|-- parisc-randconfig-r071-20251105
|   `-- fs-erofs-fileio.c-erofs_fileio_rq_submit()-error:uninitialized-symbol-ret-.
|-- powerpc-allmodconfig
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
|-- sparc-randconfig-r113-20251105
|   |-- ide.c:(.text):undefined-reference-to-tsm_ide_stream_unregister
|   `-- tsm.c:(.text):undefined-reference-to-find_tsm_dev
|-- um-randconfig-r073-20251105
|   `-- fs-btrfs-bio.c-btrfs_submit_chunk()-warn:variable-dereferenced-before-check-inode-(see-line-)
|-- x86_64-randconfig-161-20251104
|   `-- drivers-xen-grant-dma-ops.c-xen_grant_dma_map_phys()-warn:mask-and-shift-to-zero:expr-offset
|-- x86_64-rhel-9.4-bpf
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
`-- xtensa-randconfig-r112-20251105
    |-- drivers-pinctrl-pinctrl-mpfs-iomux0.c:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
    `-- xtensa-linux-ld:drivers-pinctrl-pinctrl-mpfs-iomux0.c:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map

elapsed time: 1065m

configs tested: 173
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                        nsim_700_defconfig    gcc-15.1.0
arc                   randconfig-001-20251105    gcc-8.5.0
arc                   randconfig-002-20251105    gcc-13.4.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20251105    clang-22
arm                   randconfig-002-20251105    clang-22
arm                   randconfig-003-20251105    clang-22
arm                   randconfig-004-20251105    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251105    clang-17
arm64                 randconfig-002-20251105    gcc-13.4.0
arm64                 randconfig-003-20251105    gcc-8.5.0
arm64                 randconfig-004-20251105    clang-17
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251105    gcc-15.1.0
csky                  randconfig-002-20251105    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251105    clang-22
hexagon               randconfig-002-20251105    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251105    gcc-14
i386        buildonly-randconfig-002-20251105    gcc-14
i386        buildonly-randconfig-003-20251105    clang-20
i386        buildonly-randconfig-004-20251105    gcc-14
i386        buildonly-randconfig-005-20251105    gcc-14
i386        buildonly-randconfig-006-20251105    clang-20
i386                                defconfig    clang-20
i386                  randconfig-011-20251105    clang-20
i386                  randconfig-012-20251105    clang-20
i386                  randconfig-013-20251105    clang-20
i386                  randconfig-014-20251105    clang-20
i386                  randconfig-015-20251105    clang-20
i386                  randconfig-016-20251105    clang-20
i386                  randconfig-017-20251105    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251105    clang-18
loongarch             randconfig-002-20251105    clang-20
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
mips                           ip32_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251105    gcc-9.5.0
nios2                 randconfig-002-20251105    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251105    gcc-12.5.0
parisc                randconfig-002-20251105    gcc-10.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc               randconfig-001-20251105    gcc-14.3.0
powerpc               randconfig-002-20251105    gcc-12.5.0
powerpc                  storcenter_defconfig    gcc-15.1.0
powerpc                 xes_mpc85xx_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251105    clang-22
powerpc64             randconfig-002-20251105    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251105    gcc-8.5.0
riscv                 randconfig-002-20251105    clang-18
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251105    gcc-8.5.0
s390                  randconfig-002-20251105    gcc-14.3.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                               j2_defconfig    gcc-15.1.0
sh                    randconfig-001-20251105    gcc-10.5.0
sh                    randconfig-002-20251105    gcc-11.5.0
sh                           se7619_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251105    gcc-12.5.0
sparc                 randconfig-002-20251105    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251105    clang-22
sparc64               randconfig-002-20251105    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251105    clang-22
um                    randconfig-002-20251105    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251105    clang-20
x86_64      buildonly-randconfig-002-20251105    gcc-13
x86_64      buildonly-randconfig-003-20251105    gcc-14
x86_64      buildonly-randconfig-004-20251105    gcc-13
x86_64      buildonly-randconfig-005-20251105    gcc-14
x86_64      buildonly-randconfig-006-20251105    gcc-13
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20251105    clang-20
x86_64                randconfig-002-20251105    gcc-14
x86_64                randconfig-003-20251105    gcc-12
x86_64                randconfig-004-20251105    gcc-14
x86_64                randconfig-005-20251105    gcc-14
x86_64                randconfig-006-20251105    clang-20
x86_64                randconfig-011-20251105    clang-20
x86_64                randconfig-012-20251105    clang-20
x86_64                randconfig-013-20251105    clang-20
x86_64                randconfig-014-20251105    gcc-14
x86_64                randconfig-015-20251105    clang-20
x86_64                randconfig-016-20251105    gcc-14
x86_64                randconfig-071-20251105    gcc-14
x86_64                randconfig-072-20251105    clang-20
x86_64                randconfig-073-20251105    clang-20
x86_64                randconfig-074-20251105    clang-20
x86_64                randconfig-075-20251105    gcc-14
x86_64                randconfig-076-20251105    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251105    gcc-11.5.0
xtensa                randconfig-002-20251105    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

