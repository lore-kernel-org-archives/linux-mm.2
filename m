Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1411093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 04:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937016B0088; Sat, 21 Mar 2026 00:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7E26B0089; Sat, 21 Mar 2026 00:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE2F6B008A; Sat, 21 Mar 2026 00:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC7F6B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:31:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5AFA58E1F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:31:49 +0000 (UTC)
X-FDA: 84568797138.09.CE914E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 87B8A180004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:31:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZiAsdN6f;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774067508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AbyIAFdB2gRFiTn8Ewo/Rk9juZk86cWe6HbHa8XFDcE=;
	b=Gf8coyRn3t3XQVOEIL2E17u1Tw/k5ps1Cfs+KXSNNEOEEB3hxH2EAhxETKukzCfzdeejdi
	nFfB1JLsWOPjaQTZBHh4xwHxsj1oKZBH68WLitqNSFKylp6U7otXPgoyYu8biq7laEOUfP
	wYe4RGzOWh/qFlZpQGVknHpFnIAfOPM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZiAsdN6f;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774067508; a=rsa-sha256;
	cv=none;
	b=4ecwFsJMBVmfkNWfBnOXlUx42GJlJ+lUR9aNEoKor0jPbrB39hJjfeJu/bHm+3mBMQuDT3
	Yq4uBR2tjMxWzyHwxqAc0zxNAFlh824jNWw4Wp654Xl520vEMErMqHaMIWVZecGtiBE4or
	TpQ03H2FeiaL8vSKLwVoRC/lnD7eoOA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774067507; x=1805603507;
  h=date:from:to:cc:subject:message-id;
  bh=4GR6hVt8gyZ2v0ahx16gfOxVY7IGMNezL6tMIE8DfB0=;
  b=ZiAsdN6fMM3MHAZXIfEwt+h7d/XlbfQb3H7yCOII94aWkl+TKtc/n5V8
   +aBdMgB7mh54F002DI9tz3FEm297ZOZOhQoD6xLIppZ4Yzsbjq5rX93aT
   ctKg3+aymodaDuuknKL3dNrg3qKYAFDdLceV2R0OgaTivRCTBoB/zg9XV
   RiuVRAYJZYNyEipgp4b3DBsjUh/ZTiH+biu+Og0WZUc+tgNjIl1DcVoGd
   gJ/CRi2C4LsIp66fAfeNps/dyJJuX1TnQ2x9nEYZIhY2K1fwRjlYy6G9u
   Qo2nDhn8k72UOuGg/Wf/eCoG0l9+oNZNbqwWWFhn2vTTVJ0oII6pJrK/3
   w==;
X-CSE-ConnectionGUID: h3tO42TZTHehng7O8yPQvQ==
X-CSE-MsgGUID: kOCNoLJ2T7yro+bJAgSa5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75224421"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="75224421"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 21:31:45 -0700
X-CSE-ConnectionGUID: AUU2SPYiTv+SZkUXoJKdFw==
X-CSE-MsgGUID: bqSlTESQSbSk7C+KzbdXLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="222720969"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 20 Mar 2026 21:31:44 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3nzR-000000000If-0wcQ;
	Sat, 21 Mar 2026 04:31:19 +0000
Date: Sat, 21 Mar 2026 12:29:59 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
Message-ID: <202603211247.Y5JRJjpR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87B8A180004
X-Stat-Signature: fnm8pnbmwqyfkf7tw6y8a3xc9p3p6xrc
X-Rspam-User: 
X-HE-Tag: 1774067507-844162
X-HE-Meta: U2FsdGVkX1/3B58pvttqE8CS4GqDOqXnRG5kkzz/tglRVQkO+G7BObL+joPSdntp2bx2B4061k/wCY5nwqdxSiicZ02s0M8zZXVXtEjWWV8n78cDyndiBV//PGodvaYd0LKAruqt9W95q74/udnljkPtyWvXTFk1Ot+4Lbxgah8qnXuRxHSyKnXmHGRVbvE3V3k9NjitJsqOr830pFAFmifMwZY70VPHzmS5S300nqhcIlh2ZmYLp9JUiRc+iUGX/qyaITT6V9ZPHpfSWy/fcnIa0pYl01H6aYQGMM5xunW1PB0lXps4/zFo1QJoTPKF8VJxq7Yb1GSfRnNc2v9XPl//L2gc2OPdC7fodxffGG4jfbXioyZn8JVsnv18lc10St06bLG7WCUdQDnvRFFeT6sCw5zfRcrSzsSNM9g/LJr7ILScNpoXYZl0eGXnMfNdRIffxljild/DM5dFaU+Brxe/MN4SDRZPrVkB9+8W0qk8dFUmpyEnAnLKK56wb7kQM9Si3NI9Z0fJBFM9r6M3n5Cb0p3ibc9B1ZudQutPcMP/gR2KPxXRTB/bWb89Q48+kST9+jV7ohD2VUXPcGHQTXZFcwzkaI17cG8/1Dl2n6eN/kNDL3lvw3XUJ85xl64uQQ4W76XVnZPTBTD85WBKd+4aPH/KhRudGtjHlgQ811ASjOa4jPdxBhL5eeCJ8+jC7992dz1OAyHRLC/mLpucrfeEir7e7RtlzAYn1df0k/l7fEI0SLl6VjiyOb//fqEsr/RmOJR5jLJnKiQUIsKYXQq87en3wrHRJq7GBK9UgGZf71ziTPRQ/fD7qtjiFkxFHuPRjYaNgzsfMlzyDM5SqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e  Add linux-next specific files for 20260320

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603202333.o9PN1JUT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603210208.5TW7E8WX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603210903.IrKhPd6k-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603211040.LUJzjyRs-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603211220.dWi6MHR5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603210529.IutAxKNP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603211016.C56jHFl9-lkp@intel.com

    .tmp_gl_lontium-lt8713sx.o:(.text+0x268): undefined reference to `__udivdi3'
    cs47l24.c:(.text+0x1dc): undefined reference to `wm_adsp2_component_remove'
    cs47l24.c:(.text+0x2e0): undefined reference to `wm_adsp2_component_probe'
    cs47l24.c:(.text+0x38c): undefined reference to `wm_adsp2_set_dspclk'
    cs47l24.c:(.text+0x470): undefined reference to `wm_adsp_compr_handle_irq'
    cs47l24.c:(.text+0x694): undefined reference to `wm_adsp2_init'
    cs47l24.c:(.text+0x70): undefined reference to `wm_adsp2_remove'
    cs47l24.c:(.text+0x7e8): undefined reference to `wm_adsp_compr_open'
    cs47l85.c:(.text+0x180): undefined reference to `wm_adsp2_component_remove'
    cs47l85.c:(.text+0x2c4): undefined reference to `wm_adsp2_component_probe'
    cs47l85.c:(.text+0x3b4): undefined reference to `wm_adsp_early_event'
    cs47l85.c:(.text+0x5d0): undefined reference to `wm_adsp_compr_handle_irq'
    cs47l85.c:(.text+0x6a4): undefined reference to `wm_adsp_compr_open'
    cs47l85.c:(.text+0x768): undefined reference to `wm_adsp2_remove'
    cs47l85.c:(.text+0xa24): undefined reference to `wm_adsp2_init'
    cs47l92.c:(.text+0x1e8): undefined reference to `wm_adsp2_component_probe'
    cs47l92.c:(.text+0x2ac): undefined reference to `wm_adsp_early_event'
    cs47l92.c:(.text+0x40c): undefined reference to `wm_adsp_compr_handle_irq'
    cs47l92.c:(.text+0x6fc): undefined reference to `wm_adsp_compr_open'
    cs47l92.c:(.text+0x7dc): undefined reference to `wm_adsp2_remove'
    cs47l92.c:(.text+0x9b8): undefined reference to `wm_adsp2_init'
    cs47l92.c:(.text+0xf0): undefined reference to `wm_adsp2_component_remove'
    drivers/hsi/controllers/omap_ssi_port.c:1121:12: warning: address of array 'ssi->port' will always evaluate to 'true' [-Wpointer-bool-conversion]
    error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
    include/linux/compiler_types.h:706:38: error: call to '__compiletime_assert_398' declared with attribute error: min(outarg.size, ((loff_t)(~0UL) << 12) - pos) signedness error
    include/linux/instrumented.h:67:(.text+0x105c): undefined reference to `wm_adsp2_remove'
    kernel/sched/ext.c:6517:2: error: call to undeclared function 'cgroup_put'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    kernel/sched/ext.c:6606:2: error: call to undeclared function 'cgroup_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    sh4-linux-ld: cs47l24.c:(.text+0x2e4): undefined reference to `wm_adsp2_component_remove'
    sh4-linux-ld: cs47l24.c:(.text+0x390): undefined reference to `wm_adsp_early_event'
    sh4-linux-ld: cs47l85.c:(.text+0xa58): undefined reference to `wm_adsp2_remove'
    sh4-linux-ld: cs47l92.c:(.text+0x9c8): undefined reference to `wm_adsp2_bus_error'
    sh4-linux-ld: cs47l92.c:(.text+0x9cc): undefined reference to `wm_adsp2_remove'
    sh4-linux-ld: sound/soc/codecs/cs35l41.c:1105:(.text+0x738): undefined reference to `wm_adsp2_remove'
    sh4-linux-ld: sound/soc/codecs/cs35l41.c:211:(.text+0x560): undefined reference to `wm_adsp_early_event'
    sh4-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x3214): undefined reference to `wm_adsp2_preloader_get'
    sh4-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x3218): undefined reference to `wm_adsp2_preloader_put'
    sh4-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x3244): undefined reference to `wm_adsp_fw_get'
    sh4-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x3248): undefined reference to `wm_adsp_fw_put'
    sh4-linux-ld: sound/soc/codecs/cs35l41.o:(.rodata+0x3250): undefined reference to `wm_adsp_fw_enum'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1ac): undefined reference to `wm_adsp_compr_free'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1b0): undefined reference to `wm_adsp_compr_set_params'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1c0): undefined reference to `wm_adsp_compr_trigger'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1c4): undefined reference to `wm_adsp_compr_pointer'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1c8): undefined reference to `wm_adsp_compr_copy'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0x1d4): undefined reference to `wm_adsp_compr_get_caps'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xb1708): undefined reference to `wm_adsp_event'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xc3c84): undefined reference to `wm_adsp2_preloader_get'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xc3c88): undefined reference to `wm_adsp2_preloader_put'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xc51e4): undefined reference to `wm_adsp_fw_get'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xc51e8): undefined reference to `wm_adsp_fw_put'
    sh4-linux-ld: sound/soc/codecs/cs47l24.o:(.rodata+0xc51f0): undefined reference to `wm_adsp_fw_enum'
    sh4-linux-ld: sound/soc/codecs/cs47l85.o:(.rodata+0x1ac): undefined reference to `wm_adsp_compr_free'
    sh4-linux-ld: sound/soc/codecs/cs47l85.o:(.rodata+0x1c8): undefined reference to `wm_adsp_compr_copy'
    sh4-linux-ld: sound/soc/codecs/cs47l85.o:(.rodata+0x27cd4c): undefined reference to `wm_adsp2_preloader_get'
    sh4-linux-ld: sound/soc/codecs/cs47l85.o:(.rodata+0x27cd50): undefined reference to `wm_adsp2_preloader_put'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/block/drbd/drbd_debugfs.c:336 drbd_get_peer_request_state() warn: bitwise AND condition is false here
    drivers/iommu/generic_pt/fmt/../iommu_pt.h:908 riscv_64_map_range() warn: impossible condition '(paddr > 18446744073709551615) => (0-u32max > u64max)'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-002-20260320
|   `-- drivers-hsi-controllers-omap_ssi_port.c:warning:address-of-array-ssi-port-will-always-evaluate-to-true
|-- arm64-randconfig-r112-20260321
|   |-- kernel-sched-ext.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-scx_sched-sch-got-struct-scx_sched-noderef-__rcu-scx_sched
|   `-- kernel-sched-ext.c:sparse:sparse:incorrect-type-in-initializer-(different-address-spaces)-expected-struct-scx_sched-parent-got-struct-scx_sched-noderef-__rcu-scx_sched
|-- i386-randconfig-141-20260321
|   `-- drivers-iommu-generic_pt-fmt-..-iommu_pt.h-riscv_64_map_range()-warn:impossible-condition-(paddr-)-(-u32max-u64max)
|-- microblaze-allyesconfig
|   `-- tmp_gl_lontium-lt8713sx.o:(.text):undefined-reference-to-__udivdi3
|-- nios2-randconfig-r073-20260321
|   `-- drivers-block-drbd-drbd_debugfs.c-drbd_get_peer_request_state()-warn:bitwise-AND-condition-is-false-here
|-- sh-randconfig-r123-20260321
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp2_component_probe
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp2_component_remove
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp2_init
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp2_set_dspclk
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp_compr_handle_irq
|   |-- cs47l24.c:(.text):undefined-reference-to-wm_adsp_compr_open
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp2_component_probe
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp2_component_remove
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp2_init
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp_compr_handle_irq
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp_compr_open
|   |-- cs47l85.c:(.text):undefined-reference-to-wm_adsp_early_event
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp2_component_probe
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp2_component_remove
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp2_init
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp_compr_handle_irq
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp_compr_open
|   |-- cs47l92.c:(.text):undefined-reference-to-wm_adsp_early_event
|   |-- include-linux-instrumented.h:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- sh4-linux-ld:cs47l24.c:(.text):undefined-reference-to-wm_adsp2_component_remove
|   |-- sh4-linux-ld:cs47l24.c:(.text):undefined-reference-to-wm_adsp_early_event
|   |-- sh4-linux-ld:cs47l85.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- sh4-linux-ld:cs47l92.c:(.text):undefined-reference-to-wm_adsp2_bus_error
|   |-- sh4-linux-ld:cs47l92.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_adsp2_remove
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_adsp_early_event
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs35l41.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_copy
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_free
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_get_caps
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_pointer
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_set_params
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_compr_trigger
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_event
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l24.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_copy
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_free
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_get_caps
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_pointer
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_set_params
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_compr_trigger
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_event
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l85.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp2_preloader_put
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_copy
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_free
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_get_caps
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_pointer
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_set_params
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_compr_trigger
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_event
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
|   |-- sh4-linux-ld:sound-soc-codecs-cs47l92.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
|   |-- sh4-linux-ld:sound-soc-codecs-wm2200.o:(.rodata):undefined-reference-to-wm_adsp1_event
|   |-- sh4-linux-ld:sound-soc-codecs-wm2200.o:(.rodata):undefined-reference-to-wm_adsp_fw_enum
|   |-- sh4-linux-ld:sound-soc-codecs-wm2200.o:(.rodata):undefined-reference-to-wm_adsp_fw_get
|   |-- sh4-linux-ld:sound-soc-codecs-wm2200.o:(.rodata):undefined-reference-to-wm_adsp_fw_put
|   |-- sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_adsp2_component_probe
|   |-- sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_adsp2_component_remove
|   |-- sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_adsp_event
|   |-- sound-soc-codecs-cs35l41.c:(.text):undefined-reference-to-wm_halo_init
|   `-- wm2200.c:(.text):undefined-reference-to-wm_adsp1_init
|-- sparc64-randconfig-r072-20260320
|   `-- clang:error:optimization-flag-fno-inline-functions-called-once-is-not-supported-Werror-Wignored-optimization-argument
|-- x86_64-buildonly-randconfig-003-20260321
|   `-- error-E0277:const-kernel::bindings::vm_uffd_ops-cannot-be-shared-between-threads-safely
|-- x86_64-buildonly-randconfig-004-20260321
|   |-- kernel-sched-ext.c:error:call-to-undeclared-function-cgroup_get-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- kernel-sched-ext.c:error:call-to-undeclared-function-cgroup_put-ISO-C99-and-later-do-not-support-implicit-function-declarations
`-- xtensa-randconfig-r053-20260321
    `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(outarg.size-((loff_t)(-0UL)-)-pos)-signedness-error

elapsed time: 769m

configs tested: 213
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260320    gcc-13.4.0
arc                   randconfig-002-20260320    gcc-13.4.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                           h3600_defconfig    gcc-15.2.0
arm                   randconfig-001-20260320    gcc-10.5.0
arm                   randconfig-002-20260320    clang-18
arm                   randconfig-003-20260320    gcc-13.4.0
arm                   randconfig-004-20260320    clang-23
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260320    clang-17
arm64                 randconfig-002-20260320    gcc-8.5.0
arm64                 randconfig-003-20260320    clang-23
arm64                 randconfig-004-20260320    gcc-14.3.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260320    gcc-15.2.0
csky                  randconfig-002-20260320    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260320    clang-23
hexagon               randconfig-002-20260320    clang-19
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260320    gcc-14
i386        buildonly-randconfig-001-20260321    clang-20
i386        buildonly-randconfig-002-20260320    gcc-14
i386        buildonly-randconfig-002-20260321    clang-20
i386        buildonly-randconfig-002-20260321    gcc-14
i386        buildonly-randconfig-003-20260320    clang-20
i386        buildonly-randconfig-003-20260321    clang-20
i386        buildonly-randconfig-003-20260321    gcc-14
i386        buildonly-randconfig-004-20260320    gcc-14
i386        buildonly-randconfig-004-20260321    clang-20
i386        buildonly-randconfig-005-20260320    clang-20
i386        buildonly-randconfig-005-20260321    clang-20
i386        buildonly-randconfig-006-20260320    clang-20
i386        buildonly-randconfig-006-20260321    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260321    gcc-14
i386                  randconfig-002-20260321    gcc-14
i386                  randconfig-003-20260321    clang-20
i386                  randconfig-004-20260321    gcc-13
i386                  randconfig-005-20260321    clang-20
i386                  randconfig-006-20260321    gcc-14
i386                  randconfig-007-20260321    gcc-14
i386                  randconfig-011-20260320    clang-20
i386                  randconfig-012-20260320    gcc-14
i386                  randconfig-013-20260320    clang-20
i386                  randconfig-014-20260320    clang-20
i386                  randconfig-015-20260320    clang-20
i386                  randconfig-016-20260320    clang-20
i386                  randconfig-017-20260320    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260320    clang-23
loongarch             randconfig-002-20260320    clang-18
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260320    gcc-11.5.0
nios2                 randconfig-002-20260320    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260320    gcc-14.3.0
parisc                randconfig-002-20260320    gcc-9.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 mpc832x_rdb_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260320    clang-23
powerpc               randconfig-002-20260320    gcc-10.5.0
powerpc64             randconfig-001-20260320    gcc-10.5.0
powerpc64             randconfig-002-20260320    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260321    gcc-15.2.0
riscv                 randconfig-002-20260321    clang-18
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260321    gcc-15.2.0
s390                  randconfig-002-20260321    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260321    gcc-15.2.0
sh                    randconfig-002-20260321    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260320    gcc-8.5.0
sparc                 randconfig-002-20260320    gcc-12.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260320    gcc-14.3.0
sparc64               randconfig-002-20260320    gcc-12.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260320    gcc-14
um                    randconfig-002-20260320    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260320    gcc-14
x86_64      buildonly-randconfig-001-20260321    clang-20
x86_64      buildonly-randconfig-002-20260320    gcc-14
x86_64      buildonly-randconfig-002-20260321    clang-20
x86_64      buildonly-randconfig-002-20260321    gcc-13
x86_64      buildonly-randconfig-003-20260320    clang-20
x86_64      buildonly-randconfig-003-20260321    clang-20
x86_64      buildonly-randconfig-004-20260320    clang-20
x86_64      buildonly-randconfig-004-20260321    clang-20
x86_64      buildonly-randconfig-005-20260320    clang-20
x86_64      buildonly-randconfig-005-20260321    clang-20
x86_64      buildonly-randconfig-006-20260320    gcc-14
x86_64      buildonly-randconfig-006-20260321    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260321    clang-20
x86_64                randconfig-002-20260321    gcc-14
x86_64                randconfig-003-20260321    clang-20
x86_64                randconfig-004-20260321    gcc-14
x86_64                randconfig-005-20260321    gcc-14
x86_64                randconfig-006-20260321    clang-20
x86_64                randconfig-011-20260320    gcc-14
x86_64                randconfig-012-20260320    gcc-14
x86_64                randconfig-013-20260320    gcc-14
x86_64                randconfig-014-20260320    gcc-14
x86_64                randconfig-015-20260320    gcc-14
x86_64                randconfig-016-20260320    gcc-12
x86_64                randconfig-071-20260321    gcc-14
x86_64                randconfig-072-20260321    clang-20
x86_64                randconfig-073-20260321    gcc-13
x86_64                randconfig-074-20260321    gcc-14
x86_64                randconfig-075-20260321    clang-20
x86_64                randconfig-076-20260321    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260320    gcc-8.5.0
xtensa                randconfig-002-20260320    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

