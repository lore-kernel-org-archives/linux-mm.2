Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A112FD4A5EA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFDE6B0005; Thu, 15 Jan 2026 21:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D506B0088; Thu, 15 Jan 2026 21:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C256B0089; Thu, 15 Jan 2026 21:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D98A6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:37:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E77541AE5D5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:37:37 +0000 (UTC)
X-FDA: 84336266154.20.07F9D26
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C761C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:37:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CSM80DaH;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768531056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4XlJxh8gjfCd7NAnXMmeo5xknBvLLdtF3eJ/OO20jlc=;
	b=r8mQXoO43m2t8yG7MdbE0ytscrT82PLQvAJSTtUYYCnU1a+tuJ8Qv839qquuSdQUvsQ9Hi
	7eXxqU7T7CPSEEcIsih+lxrN13KgLPTeDf/CnN66K/KzZQEy+zu1YzqJXHl0qprc7oc3Go
	uQzoZ1K9mJIhv0pIHs18hW9qqz1uvzc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CSM80DaH;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768531056; a=rsa-sha256;
	cv=none;
	b=blXTIdLRWvWfz9HmT7spR3xzxavonts3AkS/EDZc/D36wstYYBMe0M7JZI3pJ3PHnPE3OD
	trqOeuOWKFFl2iqeLpMTACW2IEx/M6fKqAxAMRkkHV+Kh1uJq4ApgurrcjLUTTrOzBZEj0
	M+JDIrC+3ZAtfnKmjFGkTbOMlb3vSAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768531055; x=1800067055;
  h=date:from:to:cc:subject:message-id;
  bh=FTUpp+PmEu79Ift1jLBH+S8go4n+Lhbg1VqNMKPNNeA=;
  b=CSM80DaHMlcbnf0tffmZ2lDFLyJdu8JMCCASVyE0I99rrW9WfKyAxlxf
   msK+gPVohxEq07xo6wXsWKGtEcIkfnnV/KGq42MtRUos2oopvdqL+cUOd
   ZinkMjHruULhZqqzUc5wRFzTTk1rNaqF0n9P+a9AOWt7DHd89olVeMB3g
   UsmpPkwnqdiOQVcWNwLe+s5OctYhhzWbP+k5EeSxlXOnwo1t1pb5hr27/
   jaXcPXB3AmG8LROkMmEXrBkDBZZFFgdWmx/zrGjJSV+s1hzIFxgPU7YWi
   aBWwLlQbsrWEKMcVBIzyfPB8atEY0odL153jRnoA8u/WxbcUrqB0VTWnH
   A==;
X-CSE-ConnectionGUID: n15Uf59bSnSb7nGsi0LYoQ==
X-CSE-MsgGUID: u4z7mxpzQkGPAA6O/N/7qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80564247"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80564247"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:37:33 -0800
X-CSE-ConnectionGUID: KCkwQl8eRCqNOWmQgz36fQ==
X-CSE-MsgGUID: y2K4Ab0vTBSHSMqTXAxL1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209264643"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Jan 2026 18:37:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgZiL-00000000KGq-0OeC;
	Fri, 16 Jan 2026 02:37:29 +0000
Date: Fri, 16 Jan 2026 10:36:56 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
Message-ID: <202601161037.4qa8TJAf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: uawou65964emtyzhuyjfexzop7pq4s59
X-Rspamd-Queue-Id: 2C761C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768531055-676873
X-HE-Meta: U2FsdGVkX1+UosuTjZZ38h8jhVZl64vVYmrcwRh17IcHhQBIGTrovmfdIN48us0ciYcYGP1sjaWXoSf+xzvVmaZHj2RT3YADP4b2D0E0wv45g2S6PJVT7mmbGs6ba1isUJwCaCKAe4Id5TLxFuKJ8QT9FG7DmHBn7wHdCQD/1VX75h6u2nvv/G4ctY33cqg6SQRJVrNBQYkPBw1oekYuVd08j07Nsu7PMswU5lbauw6VqnPmAGj0Tkuq547vWReilGfNzC2tlV6BzbAOmxJhK8XOoO9g9JcE7UlyNIi1ss5dqJGf6PW6ZHNu+JfDCvQnX/9K889pqnSLKfUxFkPZFrl3msRheHDCBeGv4WvjYAobvDFNR1zyjM/CbDXNuEWjj26HbfJDfT4RxM64DlJ8Zy/3fQjdsgQkU3vJZBS7CuJWNEepJsklOKHrugG3xkoJ88bAjHaODaZ8p/FpB7W0Jdjb8ZUFCPq5+iCnf4s6cFXqnVNVhr/6ezArgPMAwAio9XpLPUGfVv00Vy6pnK/sEa8oBZz2HY9ey63AqooEyN58SSy175e79BII+87K3M87IBF3r8zLN20esfHxayo6QzsPI9TSN/VOF1mVLnkpCBLG5ElzdI+a6m2ygmoW5uZpp+hsWyiQe/LVZS50QzRdiKOT32ZYnqLk8ohGWHwmXndveT6nUAoIyblBYTGz6Jb0ZKXEHMN5V+UIu89L+b3J1yuh49FuB0AHdjlsH0RAqDx2xXDZA7lefEaEE3G6QbpMDhOh9m7oYvsOyBy8Tj2D58T66rqxWzgnCrdp08YRboep2TgjWzdkUAXQYfTe7W5TTjC0GNyeEoYOb/ALNkgW/H5dObsoZnhtDniwANfFETcV1k6xanZ0VbG7IVMlrxh0EV8oVNFIM8tOuFo8dtTpHHM/XgfwjwYTguCXYc/u4Jr4ZjvBMvFr9I/G2BwNoac4/ZrcMOcNOD8YzSc+12p
 508LTNV2
 BL+LiL5/wi+xThhVSoqFuCwwtK34bq3wzbAiztEfzVYG9c+EHs8qRtqvpZQceNFILvgD5o03s4QVdSwPnguw9OlFmARoS9vYA+IQM9Ub1nHOHjAgiuBE8LoikXIk7eScsf5ft00NJ0yeWfncnaBnlbbL6/KebcU/AppibSODlL/rxOAywdLY6d+kZag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00  Add linux-next specific files for 20260115

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202601151728.S6JnRtXc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601151803.XY7KryHC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202601152258.8RPQcl59-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601152139.lvd04I0E-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601152219.wp7TKZXT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601160022.HqOucuTP-lkp@intel.com

    ./usr/include/linux/vbox_vmmdev_types.h:254:6: error: field u within 'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)' is less aligned than 'union (unnamed union at ./usr/include/linux/vbox_vmmdev_types.h:251:4)' and is usually due to 'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
    Warning: drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu_cmn.c:415 expecting prototype for smu_msg_proto_v1_send_msg(). Prototype was for smu_msg_v1_send_msg() instead
    Warning: drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c:1924 expecting prototype for amdgpu_ttm_mmio_remap_bo_init(). Prototype was for amdgpu_ttm_alloc_mmio_remap_bo() instead
    sound/soc/sdca/sdca_interrupts.c:212:34: error: no member named 'completion' in 'struct dev_pm_info'
    usr/include/linux/vbox_vmmdev_types.h:254:6: error: field u within 'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at usr/include/linux/vbox_vmmdev_types.h:249:3)' is less aligned than 'union (unnamed union at usr/include/linux/vbox_vmmdev_types.h:251:4)' and is usually due to 'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at usr/include/linux/vbox_vmmdev_types.h:249:3)' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/interconnect/icc-kunit.c:322:1: sparse: sparse: bad integer constant expression
    drivers/net/ethernet/stmicro/stmmac/dwmac-motorcomm.c:382:1: sparse: sparse: bad integer constant expression
    drivers/phy/phy-common-props-test.c:420:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arc-randconfig-002-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm-randconfig-004-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm-randconfig-r064-20260115
|   |-- usr-include-linux-vbox_vmmdev_types.h:error:field-u-within-struct-vmmdev_hgcm_function_parameter64::(anonymous-union)::(unnamed-at-.-usr-include-linux-vbox_vmmdev_types.h)-is-less-aligned-than-union-(
|   `-- usr-include-linux-vbox_vmmdev_types.h:error:field-u-within-struct-vmmdev_hgcm_function_parameter64::(anonymous-union)::(unnamed-at-usr-include-linux-vbox_vmmdev_types.h)-is-less-aligned-than-union-(un
|-- arm64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm64-randconfig-001-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm64-randconfig-003-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm64-randconfig-003-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm64-randconfig-004-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- arm64-randconfig-r113-20260115
|   |-- drivers-interconnect-icc-kunit.c:sparse:sparse:bad-integer-constant-expression
|   `-- drivers-phy-phy-common-props-test.c:sparse:sparse:bad-integer-constant-expression
|-- csky-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- csky-randconfig-r063-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- csky-randconfig-r064-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-buildonly-randconfig-005-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-buildonly-randconfig-005-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-buildonly-randconfig-006-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-002-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-002-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-004-20260115
|   `-- sound-soc-sdca-sdca_interrupts.c:error:no-member-named-completion-in-struct-dev_pm_info
|-- i386-randconfig-006-20260116
|   `-- sound-soc-sdca-sdca_interrupts.c:error:no-member-named-completion-in-struct-dev_pm_info
|-- i386-randconfig-011-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-015-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-054-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-141-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- i386-randconfig-141-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-defconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-randconfig-001-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-randconfig-002-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-randconfig-r061-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- loongarch-randconfig-r062-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- microblaze-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- microblaze-randconfig-r073-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- microblaze-randconfig-r132-20260115
|   `-- drivers-interconnect-icc-kunit.c:sparse:sparse:bad-integer-constant-expression
|-- mips-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- mips-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- openrisc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- parisc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- parisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- parisc-randconfig-r111-20260115
|   `-- drivers-phy-phy-common-props-test.c:sparse:sparse:bad-integer-constant-expression
|-- powerpc-randconfig-r064-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- riscv-randconfig-r121-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- s390-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- s390-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- sparc-randconfig-r131-20260115
|   `-- drivers-net-ethernet-stmicro-stmmac-dwmac-motorcomm.c:sparse:sparse:bad-integer-constant-expression
|-- sparc64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- sparc64-randconfig-r133-20260115
|   `-- drivers-phy-phy-common-props-test.c:sparse:sparse:bad-integer-constant-expression
|-- x86_64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-buildonly-randconfig-002-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-002-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-003-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-004-20260115
|   `-- sound-soc-sdca-sdca_interrupts.c:error:no-member-named-completion-in-struct-dev_pm_info
|-- x86_64-randconfig-013-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-014-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-016-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-073-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-074-20260116
|   `-- sound-soc-sdca-sdca_interrupts.c:error:no-member-named-completion-in-struct-dev_pm_info
|-- x86_64-randconfig-075-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-075-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-076-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-161-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-randconfig-r054-20260116
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- x86_64-rhel-9.4-rust
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- xtensa-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
|-- xtensa-randconfig-002-20260115
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead
`-- xtensa-randconfig-002-20260116
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu_cmn.c-expecting-prototype-for-smu_msg_proto_v1_send_msg().-Prototype-was-for-smu_msg_v1_send_msg()-instead
    `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-expecting-prototype-for-amdgpu_ttm_mmio_remap_bo_init().-Prototype-was-for-amdgpu_ttm_alloc_mmio_remap_bo()-instead

elapsed time: 1273m

configs tested: 313
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-22
arc                                 defconfig    gcc-15.2.0
arc                 nsimosci_hs_smp_defconfig    gcc-15.2.0
arc                   randconfig-001-20260115    gcc-13.4.0
arc                   randconfig-001-20260116    gcc-8.5.0
arc                   randconfig-002-20260115    gcc-13.4.0
arc                   randconfig-002-20260116    gcc-8.5.0
arc                    vdk_hs38_smp_defconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                                 defconfig    clang-22
arm                        neponset_defconfig    gcc-15.2.0
arm                            qcom_defconfig    clang-22
arm                   randconfig-001-20260115    gcc-8.5.0
arm                   randconfig-001-20260116    gcc-8.5.0
arm                   randconfig-002-20260115    clang-22
arm                   randconfig-002-20260116    gcc-8.5.0
arm                   randconfig-003-20260115    clang-17
arm                   randconfig-003-20260116    gcc-8.5.0
arm                   randconfig-004-20260115    clang-22
arm                   randconfig-004-20260116    gcc-8.5.0
arm                        shmobile_defconfig    gcc-15.2.0
arm                          sp7021_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260115    clang-22
arm64                 randconfig-001-20260116    clang-22
arm64                 randconfig-002-20260115    clang-22
arm64                 randconfig-002-20260116    clang-22
arm64                 randconfig-003-20260115    clang-22
arm64                 randconfig-003-20260116    clang-22
arm64                 randconfig-004-20260115    clang-22
arm64                 randconfig-004-20260115    gcc-9.5.0
arm64                 randconfig-004-20260116    clang-22
csky                             alldefconfig    gcc-15.2.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260115    clang-22
csky                  randconfig-001-20260115    gcc-15.2.0
csky                  randconfig-001-20260116    clang-22
csky                  randconfig-002-20260115    clang-22
csky                  randconfig-002-20260115    gcc-15.2.0
csky                  randconfig-002-20260116    clang-22
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260115    clang-22
hexagon               randconfig-001-20260116    clang-20
hexagon               randconfig-002-20260115    clang-16
hexagon               randconfig-002-20260116    clang-20
i386                             allmodconfig    clang-20
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386        buildonly-randconfig-001-20260115    gcc-14
i386        buildonly-randconfig-001-20260116    gcc-12
i386        buildonly-randconfig-002-20260115    gcc-14
i386        buildonly-randconfig-002-20260116    gcc-12
i386        buildonly-randconfig-003-20260115    gcc-14
i386        buildonly-randconfig-003-20260116    gcc-12
i386        buildonly-randconfig-004-20260115    clang-20
i386        buildonly-randconfig-004-20260115    gcc-14
i386        buildonly-randconfig-004-20260116    gcc-12
i386        buildonly-randconfig-005-20260115    clang-20
i386        buildonly-randconfig-005-20260115    gcc-14
i386        buildonly-randconfig-005-20260116    gcc-12
i386        buildonly-randconfig-006-20260115    clang-20
i386        buildonly-randconfig-006-20260115    gcc-14
i386        buildonly-randconfig-006-20260116    gcc-12
i386                                defconfig    clang-20
i386                  randconfig-001-20260115    clang-20
i386                  randconfig-001-20260116    clang-20
i386                  randconfig-002-20260115    clang-20
i386                  randconfig-002-20260116    clang-20
i386                  randconfig-003-20260115    clang-20
i386                  randconfig-003-20260116    clang-20
i386                  randconfig-004-20260115    clang-20
i386                  randconfig-004-20260116    clang-20
i386                  randconfig-005-20260115    clang-20
i386                  randconfig-005-20260116    clang-20
i386                  randconfig-006-20260115    clang-20
i386                  randconfig-006-20260115    gcc-14
i386                  randconfig-006-20260116    clang-20
i386                  randconfig-007-20260115    clang-20
i386                  randconfig-007-20260115    gcc-14
i386                  randconfig-007-20260116    clang-20
i386                  randconfig-011-20260115    clang-20
i386                  randconfig-011-20260115    gcc-14
i386                  randconfig-011-20260116    clang-20
i386                  randconfig-012-20260115    gcc-14
i386                  randconfig-012-20260116    clang-20
i386                  randconfig-013-20260115    gcc-14
i386                  randconfig-013-20260116    clang-20
i386                  randconfig-014-20260115    gcc-14
i386                  randconfig-014-20260116    clang-20
i386                  randconfig-015-20260115    clang-20
i386                  randconfig-015-20260115    gcc-14
i386                  randconfig-015-20260116    clang-20
i386                  randconfig-016-20260115    clang-20
i386                  randconfig-016-20260115    gcc-14
i386                  randconfig-016-20260116    clang-20
i386                  randconfig-017-20260115    clang-20
i386                  randconfig-017-20260115    gcc-14
i386                  randconfig-017-20260116    clang-20
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260115    clang-22
loongarch             randconfig-001-20260116    clang-20
loongarch             randconfig-002-20260115    clang-22
loongarch             randconfig-002-20260116    clang-20
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          hp300_defconfig    gcc-15.2.0
m68k                       m5208evb_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                     cu1830-neo_defconfig    clang-22
mips                          rm200_defconfig    gcc-15.2.0
nios2                         10m50_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-22
nios2                             allnoconfig    clang-22
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260115    gcc-10.5.0
nios2                 randconfig-001-20260116    clang-20
nios2                 randconfig-002-20260115    gcc-11.5.0
nios2                 randconfig-002-20260116    clang-20
openrisc                         allmodconfig    clang-22
openrisc                          allnoconfig    clang-22
openrisc                            defconfig    gcc-15.2.0
openrisc                 simple_smp_defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                           allyesconfig    clang-19
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260115    clang-22
parisc                randconfig-001-20260115    gcc-8.5.0
parisc                randconfig-001-20260116    clang-22
parisc                randconfig-002-20260115    clang-22
parisc                randconfig-002-20260115    gcc-12.5.0
parisc                randconfig-002-20260116    clang-22
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                   bluestone_defconfig    clang-22
powerpc                      cm5200_defconfig    clang-22
powerpc                        fsp2_defconfig    clang-22
powerpc                   motionpro_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260115    clang-22
powerpc               randconfig-001-20260115    gcc-8.5.0
powerpc               randconfig-001-20260116    clang-22
powerpc               randconfig-002-20260115    clang-22
powerpc               randconfig-002-20260116    clang-22
powerpc64             randconfig-001-20260115    clang-22
powerpc64             randconfig-001-20260116    clang-22
powerpc64             randconfig-002-20260115    clang-22
powerpc64             randconfig-002-20260116    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260115    clang-18
riscv                 randconfig-001-20260115    gcc-10.5.0
riscv                 randconfig-001-20260116    gcc-15.2.0
riscv                 randconfig-002-20260115    gcc-10.5.0
riscv                 randconfig-002-20260115    gcc-12.5.0
riscv                 randconfig-002-20260116    gcc-15.2.0
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                          debug_defconfig    clang-22
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260115    gcc-10.5.0
s390                  randconfig-001-20260116    gcc-15.2.0
s390                  randconfig-002-20260115    clang-22
s390                  randconfig-002-20260115    gcc-10.5.0
s390                  randconfig-002-20260116    gcc-15.2.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                               allyesconfig    clang-19
sh                         apsh4a3a_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260115    gcc-10.5.0
sh                    randconfig-001-20260116    gcc-15.2.0
sh                    randconfig-002-20260115    gcc-10.5.0
sh                    randconfig-002-20260115    gcc-14.3.0
sh                    randconfig-002-20260116    gcc-15.2.0
sh                          rsk7203_defconfig    gcc-15.2.0
sh                           se7619_defconfig    gcc-15.2.0
sh                        sh7763rdp_defconfig    clang-22
sparc                             allnoconfig    clang-22
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260115    clang-22
sparc                 randconfig-001-20260115    gcc-15.2.0
sparc                 randconfig-001-20260116    gcc-10.5.0
sparc                 randconfig-002-20260115    clang-22
sparc                 randconfig-002-20260115    gcc-12.5.0
sparc                 randconfig-002-20260116    gcc-10.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260115    clang-22
sparc64               randconfig-001-20260116    gcc-10.5.0
sparc64               randconfig-002-20260115    clang-22
sparc64               randconfig-002-20260115    gcc-8.5.0
sparc64               randconfig-002-20260116    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260115    clang-22
um                    randconfig-001-20260116    gcc-10.5.0
um                    randconfig-002-20260115    clang-22
um                    randconfig-002-20260115    gcc-14
um                    randconfig-002-20260116    gcc-10.5.0
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           alldefconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260115    clang-20
x86_64      buildonly-randconfig-002-20260115    clang-20
x86_64      buildonly-randconfig-002-20260115    gcc-13
x86_64      buildonly-randconfig-003-20260115    clang-20
x86_64      buildonly-randconfig-003-20260115    gcc-14
x86_64      buildonly-randconfig-004-20260115    clang-20
x86_64      buildonly-randconfig-005-20260115    clang-20
x86_64      buildonly-randconfig-006-20260115    clang-20
x86_64      buildonly-randconfig-006-20260115    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260115    clang-20
x86_64                randconfig-001-20260116    clang-20
x86_64                randconfig-002-20260115    clang-20
x86_64                randconfig-002-20260115    gcc-14
x86_64                randconfig-002-20260116    clang-20
x86_64                randconfig-003-20260115    clang-20
x86_64                randconfig-003-20260116    clang-20
x86_64                randconfig-004-20260115    clang-20
x86_64                randconfig-004-20260116    clang-20
x86_64                randconfig-005-20260115    clang-20
x86_64                randconfig-005-20260115    gcc-14
x86_64                randconfig-005-20260116    clang-20
x86_64                randconfig-006-20260115    clang-20
x86_64                randconfig-006-20260115    gcc-12
x86_64                randconfig-006-20260116    clang-20
x86_64                randconfig-011-20260115    clang-20
x86_64                randconfig-011-20260116    clang-20
x86_64                randconfig-012-20260115    clang-20
x86_64                randconfig-012-20260115    gcc-14
x86_64                randconfig-012-20260116    clang-20
x86_64                randconfig-013-20260115    clang-20
x86_64                randconfig-013-20260115    gcc-14
x86_64                randconfig-013-20260116    clang-20
x86_64                randconfig-014-20260115    clang-20
x86_64                randconfig-014-20260116    clang-20
x86_64                randconfig-015-20260115    clang-20
x86_64                randconfig-015-20260116    clang-20
x86_64                randconfig-016-20260115    clang-20
x86_64                randconfig-016-20260116    clang-20
x86_64                randconfig-071-20260115    gcc-14
x86_64                randconfig-071-20260116    clang-20
x86_64                randconfig-072-20260115    clang-20
x86_64                randconfig-072-20260115    gcc-14
x86_64                randconfig-072-20260116    clang-20
x86_64                randconfig-073-20260115    gcc-14
x86_64                randconfig-073-20260116    clang-20
x86_64                randconfig-074-20260115    gcc-14
x86_64                randconfig-074-20260116    clang-20
x86_64                randconfig-075-20260115    clang-20
x86_64                randconfig-075-20260115    gcc-14
x86_64                randconfig-075-20260116    clang-20
x86_64                randconfig-076-20260115    clang-20
x86_64                randconfig-076-20260115    gcc-14
x86_64                randconfig-076-20260116    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                           allyesconfig    clang-22
xtensa                randconfig-001-20260115    clang-22
xtensa                randconfig-001-20260115    gcc-8.5.0
xtensa                randconfig-001-20260116    gcc-10.5.0
xtensa                randconfig-002-20260115    clang-22
xtensa                randconfig-002-20260115    gcc-8.5.0
xtensa                randconfig-002-20260116    gcc-10.5.0
xtensa                    smp_lx200_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

