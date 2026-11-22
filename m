Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31EA606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Sh9O9bWh
Received: by kanga.kvack.org (Postfix)
	id DDB6B6B05B1; Sun, 22 Nov 2026 13:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3E86B05B2; Sun, 22 Nov 2026 13:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9FF6B05B3; Sun, 22 Nov 2026 13:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0AE86B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:23:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F366120710
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:23:20 +0000 (UTC)
X-FDA: 85463577360.17.54239D3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 86A5E2000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:23:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Sh9O9bWh;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795371798;
	b=G2x+/BWKuvoG4PhJh20lvT41PjRXdcZXW+JdvMyo3Kn/iEMQvyjciMlg0+YvAhrxyyQQsN
	z+CYjsytWGzNlzBnEwMyDBki7rKJwQTWMbQTxpfcn15jFB5WLKg3DcwQV9mfJX6LRxY4Zg
	Xvp7oxzJffvK2CTIl3IZ/iGk4myQkMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795371798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jqUbshbUrD4dIXmC6wyFgtBQRt102VHSb6FwURfjPjc=;
	b=14DeUOsm9Kc4cC0cmVQDFj4TyNUVzxqvUjNzqMF3cL1LsH6gdVaT2lHAhW4ZCNZWSPEC1X
	IKmnOKDpM7vGqFG4Yx3+UXpC2MDhVBSvtaGhuNBhC/4EABxVwETKtSRkeJuZMxM5sKp1ut
	Ko33V/K5gabcjMRGwAubd1/mhpDerEs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Sh9O9bWh;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795371798; x=1826907798;
  h=date:from:to:cc:subject:message-id;
  bh=0B2MzZR/xPZvKP9aOuwWvcbzRHUyqMbJy96tkQQv2/U=;
  b=Sh9O9bWhM0RGOSz9gg7m7q614uyuDCU048gzTaKFrhmUqBcCu50tMhzk
   RUSYhKblhD+z8U6YbUA3tln80gE6q+57Zpg+7rQPHuIBlR5r1CEfsB6rd
   dgHaxY3nnuHMTgh2nSbgbk2zDZPil9afXtg2BlIv+ffF0VXFz4IKts0/A
   Gc57E4HoGKE0EYPaE8H7ePknpDW05Zc/nXO7VT8OetrRxo9nWfww1ZEkn
   d8IirvPXqnQ0d/XglyEGSGCPRJ39PC+TrXcJLYjrdcgJVn7AhlFtJdf6N
   HPG7eLBZ0hDIUE6to8DB99jN0rgYEJtYOraKl3UN+lWribGVf7EaEpcUt
   Q==;
X-CSE-ConnectionGUID: 9x0Kk/GlQ0aDALwsAA2O5Q==
X-CSE-MsgGUID: KYFau+xPSESiZUKcAQE5dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4095197"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4095197"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 10:23:16 -0800
X-CSE-ConnectionGUID: 1ksepyN7RWKqDJo6z3Ok4g==
X-CSE-MsgGUID: H5JCy2mYQYu4UUI9SnvyUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="11452200"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 22 Nov 2026 10:23:14 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVCDX-00000001LuE-2vSF;
	Sun, 22 Nov 2026 18:23:11 +0000
Date: Mon, 23 Nov 2026 02:22:55 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 909ef7a9a30fa139e69e555e3606680f5cca7726
Message-ID: <20261123022255.V0Idw89X-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Rspamd-Queue-Id: 86A5E2000B
X-Stat-Signature: r3jgaifdpxkwek3toca11hf4de17awif
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795371797-415853
X-HE-Meta: U2FsdGVkX1/0WPozTspfxltc5gTDqeYXyTvMkJI/j4f5E7E1MmqujvFcYUSBZXbHBlTOSDNq/pXdh130MkyX/cPKXbY3PchAbF9j2S0xPgRfz7KdYMu+/UXihE8htWHFPG0xNpc9zH/57utfkculyridNdHpidRth4rGY9rGqLDcV4Tt2wbAZlGKYJ+nX59uiL+MfNYbVSIPEWnO0tN+f91RmmqzX5QGMpb2hGFYFInIunbKjXowgyXmF0ITUcFnvjLFgWnG4Ft+xzk7ND4QLNwuq2xh9kk/BDxjzcF3P08OC1oCQAN5lFW+bEclhWffIVbFFKMjihGJPGDJg2Y9NN4Q2P85VGackGMIyBvFZzGO9/V+qqAKerayuS2SW2ArLQzE9/oONcvSW/fhGwSLRcIPIPqOIVQNPSpbiG8BU2R4+OCZ4XEdJXNa8c2vBuvLqE7QyZjblckDFd1JcKUi2zCfUZ4n+8xYOxB6YlTdYtsjUjyWBKUK7sR3+T4f9GOAhV8D6slyQJ9/ZYXSyG7uehKOvXx0+6q393l40ysAqSKf8HQ4KwYebMmfSiUbrbXOeY3hyqHUSjjIhJIGsxLR4m9XPbZW8YkbW3aDuZVj2oSXjmGKkX5FUicRN8KMvSdgdkGHirBmN5IZRtImNh9TDTERHTXu68OdlNkAksxJS18gNDCfX5QCrcoCn3eyXD3CztDWpJjVTe24N8gyU9gu9hUKi2ELS86p7xqlaPyKiSg2ZY/+277cj4sUmcQPbqPphIhcYkE/kGvej0b/0a2WF8E++ram3y1Mkf5Re3O3KdLguybBwxfZCv6Fjzj4lJQzkQPjUXxDRfE5uceVPeGuE6ck9jnF2+ayEr56VuAMvwPOX/JbgcSNP8psly1Tvo28ThdgDyI4QUPduWZRMgzddJ0eSxWpk58OUpDicibjitW0TZ1XCpkjqgOeXt2sf7LazGUAI+CTde2y7cjD4Bb
 ouFjNmOu
 OMEyQdIMfUTXtdCnhPjorhtwEz2hnvgfQlZrb1/vXWKrEaf4ZMw+l5Ybz96gHbzp4RhQO/NJhUeMSr0MRCXyQXpngWlY9bzdrXGI+Oi5p4dl7eTgqIuMx7p8Gu4hNHow+D2DsFr1aFzUxmImQYvPxYxyyWvCb/xEJhMJfTupdOQxo2fZ+nJuUiaQk2UkDyMFvELwbApDEXZ+g2gz4vyUwuSw7QrNWV9WiujVZQLUyZS1dq3OW3TQ6lo/oWNEE0+YBD0kezIqflgVc8F9U/Xib/pKqBsOrFMO+7sStGy621Iig8NrwIaZD9BIotyC0sY9lsaxnBpcIBJItc174q4MFmGkq4K/1zJ6/FhMh9gKGDuzF0n2G3B9wcs0UWvB04tJqehpqnL38Yzx6xJ8jdcaSzj/WDMXO7xUsskBUjKDdROkziF2Z+9h69sko6QaIUN/PNNCwgtnxJl1JJcV+0WtZw3tkqwOiA1zBvAodgLcaFgqE2vXYdrpdWl0XLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 909ef7a9a30fa139e69e555e3606680f5cca7726  Add linux-next specific files for 20261120

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/20261120205750.YcnKhuSh-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/20261121004452.TskH9STt-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/20261121125243.34yaORF7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/20261121140840.gMUkIHya-lkp@intel.com

    ERROR: modpost: __ex_table+0x2394 references non-executable section '_ftrace_annotated_branch'
    arc-linux-ld: cache.c:(.text+0x1c0): undefined reference to `__st_r13_to_r18'
    arc-linux-ld: cache.c:(.text+0x370): undefined reference to `__ld_r13_to_r16_ret'
    arc-linux-ld: cache.c:(.text+0x374): undefined reference to `__ld_r13_to_r18_ret'
    arc-linux-ld: cache.c:(.text+0x404): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: cache.c:(.text+0x47a): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: cache.c:(.text+0x4a4): undefined reference to `__st_r13_to_r16'
    arc-linux-ld: cache.c:(.text+0x506): undefined reference to `__ld_r13_to_r16'
    arc-linux-ld: cache.c:(.text+0x90): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: cache.c:(.text+0xfa): undefined reference to `__ld_r13_to_r15'
    arc-linux-ld: calibrate.c:(.text+0x6a): undefined reference to `__ld_r13_to_r15'
    arc-linux-ld: calibrate.c:(.text+0x90): undefined reference to `__ld_r13_to_r17'
    arc-linux-ld: calibrate.c:(.text+0xa): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: calibrate.c:(.text+0xc): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: capability.c:(.text+0x2f0): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: capability.c:(.text+0x326): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: capability.c:(.text+0x60): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: cpu.c:(.init.text+0x11a): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: cpu.c:(.init.text+0x192): undefined reference to `__ld_r13_to_r15'
    arc-linux-ld: cpu.c:(.init.text+0x26c): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: cpu.c:(.init.text+0x3d4): undefined reference to `__ld_r13_to_r17_ret'
    arc-linux-ld: cpu.c:(.init.text+0x4): undefined reference to `__st_r13_to_r16'
    arc-linux-ld: cpu.c:(.init.text+0x74): undefined reference to `__ld_r13_to_r16_ret'
    arc-linux-ld: cpu.c:(.init.text+0x90): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: cpu.c:(.text+0x12c): undefined reference to `__st_r13_to_r19'
    arc-linux-ld: cpu.c:(.text+0x17a0): undefined reference to `__st_r13_to_r16'
    arc-linux-ld: cpu.c:(.text+0x17e6): undefined reference to `__ld_r13_to_r16_ret'
    arc-linux-ld: cpu.c:(.text+0x19ec): undefined reference to `__ld_r13_to_r16'
    arc-linux-ld: cpu.c:(.text+0x1cc): undefined reference to `__ld_r13_to_r19_ret'
    arc-linux-ld: cpu.c:(.text+0x218a): undefined reference to `__ld_r13_to_r20'
    arc-linux-ld: cpu.c:(.text+0x24): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: cpu.c:(.text+0x274): undefined reference to `__ld_r13_to_r15'
    arc-linux-ld: cpu.c:(.text+0x27c): undefined reference to `__st_r13_to_r20'
    arc-linux-ld: cpu.c:(.text+0x2f4): undefined reference to `__ld_r13_to_r20_ret'
    arc-linux-ld: cpu.c:(.text+0x56): undefined reference to `__ld_r13_to_r17_ret'
    arc-linux-ld: cpu.c:(.text+0x64): undefined reference to `__st_r13_to_r18'
    arc-linux-ld: cpu.c:(.text+0x668): undefined reference to `__ld_r13_to_r17'
    arc-linux-ld: cpu.c:(.text+0x958): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: cpu.c:(.text+0x9a): undefined reference to `__ld_r13_to_r18_ret'
    arc-linux-ld: cpu.c:(.text+0x9ac): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: cpu.c:(.text+0x9b4): undefined reference to `__st_r13_to_r22'
    arc-linux-ld: cpu.c:(.text+0xbe0): undefined reference to `__ld_r13_to_r22'
    arc-linux-ld: cpu.c:(.text+0xbf0): undefined reference to `__ld_r13_to_r22_ret'
    arc-linux-ld: cpu.c:(.text+0xd10): undefined reference to `__st_r13_to_r21'
    arc-linux-ld: cpu.c:(.text+0xf38): undefined reference to `__ld_r13_to_r21'
    arc-linux-ld: cpu.c:(.text+0xf48): undefined reference to `__ld_r13_to_r21_ret'
    arc-linux-ld: devtree.c:(.init.text+0x34): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: devtree.c:(.init.text+0x82): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0x130): undefined reference to `__st_r13_to_r21'
    arc-linux-ld: do_mounts.c:(.init.text+0x1b8): undefined reference to `__ld_r13_to_r17_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0x28c): undefined reference to `__ld_r13_to_r21_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0x318): undefined reference to `__st_r13_to_r20'
    arc-linux-ld: do_mounts.c:(.init.text+0x3e8): undefined reference to `__st_r13_to_r22'
    arc-linux-ld: do_mounts.c:(.init.text+0x45a): undefined reference to `__ld_r13_to_r22_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0x4c4): undefined reference to `__ld_r13_to_r20_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0x4ca): undefined reference to `__ld_r13_to_r22'
    arc-linux-ld: do_mounts.c:(.init.text+0x5ce): undefined reference to `__ld_r13_to_r21'
    arc-linux-ld: do_mounts.c:(.init.text+0x7b0): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: do_mounts.c:(.init.text+0x8b2): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: do_mounts.c:(.init.text+0xee): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: exec_state.c:(.text+0x10c): undefined reference to `__ld_r13_to_r17_ret'
    arc-linux-ld: exec_state.c:(.text+0x124): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: exec_state.c:(.text+0x12a): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: exec_state.c:(.text+0x208): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: exec_state.c:(.text+0x7c): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: exit.c:(.text+0x16b6): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: exit.c:(.text+0x308): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: fork.c:(.init.text+0x14e): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: fork.c:(.init.text+0x1da): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: fork.c:(.init.text+0x58): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: fork.c:(.text+0x1a2): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: init.c:(.init.text+0xb6): undefined reference to `__st_r13_to_r17'
    arc-linux-ld: init.c:(.init.text+0xf4): undefined reference to `__ld_r13_to_r17'
    arc-linux-ld: irq.c:(.text+0x2): undefined reference to `__st_r13_to_r16'
    arc-linux-ld: irq.c:(.text+0x24): undefined reference to `__ld_r13_to_r16'
    arc-linux-ld: main.c:(.init.text+0x118): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: main.c:(.init.text+0x33e): undefined reference to `__st_r13_to_r20'
    arc-linux-ld: main.c:(.ref.text+0x140): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: main.c:(.text+0x2c): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: main.c:(.text.unlikely+0x11e): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: panic.c:(.init.text+0x11e): undefined reference to `__st_r13_to_r15'
    arc-linux-ld: panic.c:(.init.text+0x174): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: panic.c:(.init.text+0xb4): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: panic.c:(.text+0x10c): undefined reference to `__st_r13_to_r19'
    arc-linux-ld: panic.c:(.text+0x16e): undefined reference to `__ld_r13_to_r19_ret'
    arc-linux-ld: panic.c:(.text+0x290): undefined reference to `__ld_r13_to_r15_ret'
    arc-linux-ld: panic.c:(.text.unlikely+0x1e4): undefined reference to `__st_r13_to_r16'
    arc-linux-ld: panic.c:(.text.unlikely+0x23a): undefined reference to `__ld_r13_to_r16'
    arc-linux-ld: resource.c:(.init.text+0x106): undefined reference to `__st_r13_to_r19'
    arc-linux-ld: resource.c:(.init.text+0x1bc): undefined reference to `__ld_r13_to_r19_ret'
    arc-linux-ld: resource.c:(.init.text+0x1c6): undefined reference to `__st_r13_to_r22'
    arc-linux-ld: resource.c:(.init.text+0x2d2): undefined reference to `__ld_r13_to_r22_ret'
    arc-linux-ld: resource.c:(.init.text+0x88): undefined reference to `__ld_r13_to_r14_ret'
    arc-linux-ld: resource.c:(.text+0x750): undefined reference to `__ld_r13_to_r21_ret'
    arc-linux-ld: resource.c:(.text+0x796): undefined reference to `__st_r13_to_r19'
    arc-linux-ld: resource.c:(.text+0x7d6): undefined reference to `__ld_r13_to_r19_ret'
    arc-linux-ld: resource.c:(.text+0xa2a): undefined reference to `__st_r13_to_r24'
    arc-linux-ld: resource.c:(.text+0xaa8): undefined reference to `__ld_r13_to_r24_ret'
    arc-linux-ld: resource.c:(.text+0xed6): undefined reference to `__st_r13_to_r20'
    arc-linux-ld: resource.c:(.text+0xefc): undefined reference to `__ld_r13_to_r20_ret'
    arc-linux-ld: setup.c:(.init.text+0x128): undefined reference to `__ld_r13_to_r14_ret'
    arch/riscv/kvm/main.c:37 kvm_riscv_setup_vendor_features() warn: impossible condition '(riscv_cached_marchid(0) == 9223372036854775816) => (0-u32max == 9223372036854775816)'
    drivers/usb/storage/scsiglue.c:604 max_sectors_store() warn: inconsistent returns '&sdev->request_queue->limits_lock'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-2000-20261120
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r15
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r16
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r18_ret
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__st_r13_to_r16
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__st_r13_to_r18
|   |-- arc-linux-ld:calibrate.c:(.text):undefined-reference-to-__ld_r13_to_r17
|   |-- arc-linux-ld:calibrate.c:(.text):undefined-reference-to-__st_r13_to_r17
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__ld_r13_to_r15
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__ld_r13_to_r16_ret
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__ld_r13_to_r17_ret
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__st_r13_to_r16
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__st_r13_to_r17
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r16
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r16_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r17
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r17_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r18_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r19_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r20
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r20_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r21
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r21_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r22
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r22_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r16
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r17
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r18
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r19
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r20
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r21
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__st_r13_to_r22
|   |-- arc-linux-ld:devtree.c:(.init.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:devtree.c:(.init.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r20_ret
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r21
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r21_ret
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__st_r13_to_r20
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__st_r13_to_r21
|   |-- arc-linux-ld:exec_state.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:exec_state.c:(.text):undefined-reference-to-__ld_r13_to_r17_ret
|   |-- arc-linux-ld:exec_state.c:(.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:exec_state.c:(.text):undefined-reference-to-__st_r13_to_r17
|   `-- arc-linux-ld:exit.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|-- arc-randconfig-2005-20261121
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:cache.c:(.text):undefined-reference-to-__ld_r13_to_r16_ret
|   |-- arc-linux-ld:calibrate.c:(.text):undefined-reference-to-__ld_r13_to_r15
|   |-- arc-linux-ld:calibrate.c:(.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:capability.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:capability.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:capability.c:(.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:cpu.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:cpu.c:(.text):undefined-reference-to-__ld_r13_to_r15
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r17_ret
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r22
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__ld_r13_to_r22_ret
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__st_r13_to_r17
|   |-- arc-linux-ld:do_mounts.c:(.init.text):undefined-reference-to-__st_r13_to_r22
|   |-- arc-linux-ld:exec_state.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:exit.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:fork.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:fork.c:(.init.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:fork.c:(.init.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:fork.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:init.c:(.init.text):undefined-reference-to-__ld_r13_to_r17
|   |-- arc-linux-ld:init.c:(.init.text):undefined-reference-to-__st_r13_to_r17
|   |-- arc-linux-ld:irq.c:(.text):undefined-reference-to-__ld_r13_to_r16
|   |-- arc-linux-ld:irq.c:(.text):undefined-reference-to-__st_r13_to_r16
|   |-- arc-linux-ld:main.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:main.c:(.init.text):undefined-reference-to-__st_r13_to_r20
|   |-- arc-linux-ld:main.c:(.ref.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:main.c:(.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:main.c:(.text.unlikely):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:panic.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:panic.c:(.init.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:panic.c:(.init.text):undefined-reference-to-__st_r13_to_r15
|   |-- arc-linux-ld:panic.c:(.text):undefined-reference-to-__ld_r13_to_r15_ret
|   |-- arc-linux-ld:panic.c:(.text):undefined-reference-to-__ld_r13_to_r19_ret
|   |-- arc-linux-ld:panic.c:(.text):undefined-reference-to-__st_r13_to_r19
|   |-- arc-linux-ld:panic.c:(.text.unlikely):undefined-reference-to-__ld_r13_to_r16
|   |-- arc-linux-ld:panic.c:(.text.unlikely):undefined-reference-to-__st_r13_to_r16
|   |-- arc-linux-ld:resource.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|   |-- arc-linux-ld:resource.c:(.init.text):undefined-reference-to-__ld_r13_to_r19_ret
|   |-- arc-linux-ld:resource.c:(.init.text):undefined-reference-to-__ld_r13_to_r22_ret
|   |-- arc-linux-ld:resource.c:(.init.text):undefined-reference-to-__st_r13_to_r19
|   |-- arc-linux-ld:resource.c:(.init.text):undefined-reference-to-__st_r13_to_r22
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__ld_r13_to_r19_ret
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__ld_r13_to_r20_ret
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__ld_r13_to_r21_ret
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__ld_r13_to_r24_ret
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__st_r13_to_r19
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__st_r13_to_r20
|   |-- arc-linux-ld:resource.c:(.text):undefined-reference-to-__st_r13_to_r24
|   `-- arc-linux-ld:setup.c:(.init.text):undefined-reference-to-__ld_r13_to_r14_ret
|-- m68k-randconfig-2200-20261121
|   `-- security-landlock-cap.c-hook_mmap_addr()-warn:always-true-condition-(addr-)-(-u32max-)
|-- riscv-randconfig-2003-20261121
|   `-- ERROR:__ex_table-references-non-executable-section-_ftrace_annotated_branch
|-- riscv-randconfig-2200-20261118
|   `-- arch-riscv-kvm-main.c-kvm_riscv_setup_vendor_features()-warn:impossible-condition-(riscv_cached_marchid()-)-(-u32max-)
|-- sparc64-randconfig-2200-20261120
|   `-- drivers-usb-storage-scsiglue.c-max_sectors_store()-warn:inconsistent-returns-sdev-request_queue-limits_lock-.
`-- sparc64-randconfig-r2302-20261122
    |-- drivers-net-ethernet-sun-sunvnet_common.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__sum16-usertype-got-restricted-__wsum-addressable-usertype-csum
    `-- drivers-net-ethernet-sun-sunvnet_common.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__wsum-addressable-usertype-csum-got-restricted-__sum16

elapsed time: 1266m

configs tested: 416
configs skipped: 10

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261120    gcc-13.5.0
alpha                 randconfig-2000-20261120    gcc-15.3.0
alpha                 randconfig-2001-20261120    gcc-15.3.0
alpha                 randconfig-2200-20261120    gcc-15.3.0 smatch
alpha                 randconfig-2200-20261121    gcc-10.5.0 smatch
alpha                randconfig-r2107-20261120    gcc-11.5.0 cocci
alpha                randconfig-r2109-20261120    gcc-11.5.0 cocci
alpha                randconfig-r2306-20261120    gcc-11.5.0 sparse
alpha                randconfig-r2309-20261121    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-2000-20261120    gcc-11.5.0
arc                   randconfig-2000-20261120    gcc-9.5.0
arc                   randconfig-2001-20261120    gcc-11.5.0
arc                   randconfig-2002-20261120    gcc-11.5.0
arc                   randconfig-2002-20261120    gcc-8.5.0
arc                   randconfig-2003-20261120    gcc-11.5.0
arc                   randconfig-2003-20261120    gcc-8.5.0
arc                   randconfig-2004-20261120    gcc-11.5.0
arc                   randconfig-2004-20261120    gcc-9.5.0
arc                   randconfig-2005-20261120    gcc-11.5.0
arc                   randconfig-2200-20261120    gcc-15.3.0 smatch
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-2000-20261120    gcc-11.5.0
arm                   randconfig-2000-20261121    clang-24
arm                   randconfig-2001-20261120    gcc-8.5.0
arm                   randconfig-2001-20261121    clang-24
arm                   randconfig-2002-20261120    clang-24
arm                   randconfig-2002-20261121    clang-24
arm                   randconfig-2200-20261120    clang-17   smatch
arm                   randconfig-2200-20261121    clang-19   smatch
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261122    gcc-8.5.0
arm64                 randconfig-1001-20261122    gcc-8.5.0
arm64                 randconfig-1002-20261122    gcc-8.5.0
arm64                 randconfig-1003-20261122    gcc-8.5.0
arm64                 randconfig-2000-20261120    clang-24
arm64                 randconfig-2000-20261121    clang-24
arm64                 randconfig-2001-20261120    gcc-8.5.0
arm64                 randconfig-2001-20261121    clang-24
arm64                 randconfig-2002-20261120    gcc-14.4.0
arm64                 randconfig-2002-20261121    clang-24
arm64                 randconfig-2200-20261121    clang-22   smatch
arm64                randconfig-r2301-20261120    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261122    gcc-8.5.0
csky                  randconfig-1001-20261122    gcc-8.5.0
csky                  randconfig-2000-20261120    gcc-13.5.0
csky                  randconfig-2000-20261121    gcc-16.2.0
csky                  randconfig-2001-20261120    gcc-16.2.0
csky                  randconfig-2001-20261121    gcc-16.2.0
csky                  randconfig-2200-20261120    gcc-15.3.0 smatch
csky                  randconfig-2200-20261121    gcc-16.2.0 smatch
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-2000-20261120    clang-24
hexagon               randconfig-2000-20261121    clang-24
hexagon               randconfig-2000-20261121    gcc-16.2.0
hexagon               randconfig-2001-20261120    clang-24
hexagon               randconfig-2001-20261121    clang-24
hexagon               randconfig-2001-20261121    gcc-16.2.0
hexagon               randconfig-2200-20261120    clang-17   smatch
hexagon               randconfig-2200-20261121    clang-24   smatch
hexagon              randconfig-r2106-20261120    clang-17   cocci
hexagon              randconfig-r2310-20261120    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261122    gcc-14
i386        buildonly-randconfig-1001-20261122    gcc-14
i386        buildonly-randconfig-1002-20261122    gcc-14
i386        buildonly-randconfig-1003-20261122    gcc-14
i386        buildonly-randconfig-1004-20261122    gcc-14
i386        buildonly-randconfig-1005-20261122    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1007-20261122    gcc-14
i386                  randconfig-1008-20261122    gcc-14
i386                  randconfig-1009-20261122    gcc-14
i386                  randconfig-1010-20261122    gcc-14
i386                  randconfig-1011-20261122    gcc-14
i386                  randconfig-1012-20261122    gcc-14
i386                  randconfig-1013-20261122    gcc-14
i386                  randconfig-2000-20261120    clang-22
i386                  randconfig-2000-20261120    gcc-14
i386                  randconfig-2001-20261120    clang-22
i386                  randconfig-2001-20261120    gcc-14
i386                  randconfig-2002-20261120    clang-22
i386                  randconfig-2003-20261120    clang-22
i386                  randconfig-2004-20261120    clang-22
i386                  randconfig-2005-20261120    clang-22
i386                  randconfig-2100-20261120    clang-22   cocci
i386                  randconfig-2100-20261120    gcc-14     cocci
i386                  randconfig-2101-20261120    gcc-14     cocci
i386                  randconfig-2102-20261120    gcc-14     cocci
i386                  randconfig-2103-20261120    clang-22   cocci
i386                  randconfig-2103-20261120    gcc-14     cocci
i386                  randconfig-2104-20261120    gcc-14     cocci
i386                  randconfig-2105-20261120    gcc-12     cocci
i386                  randconfig-2105-20261120    gcc-14     cocci
i386                  randconfig-2200-20261120    clang-22   smatch
i386                  randconfig-2300-20261120    clang-22   sparse
i386                  randconfig-2300-20261120    gcc-14     sparse
i386                  randconfig-2301-20261120    clang-22   sparse
i386                  randconfig-2301-20261120    gcc-14     sparse
i386                  randconfig-2302-20261120    clang-22   sparse
i386                 randconfig-r2110-20261120    clang-17   cocci
i386                 randconfig-r2111-20261120    clang-17   cocci
i386                 randconfig-r2302-20261120    clang-22   sparse
i386                 randconfig-r2302-20261120    gcc-8.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-2000-20261120    clang-24
loongarch             randconfig-2001-20261120    clang-20
loongarch             randconfig-2001-20261120    clang-24
loongarch             randconfig-2200-20261120    clang-18   smatch
loongarch            randconfig-r2104-20261120    clang-24   cocci
loongarch            randconfig-r2109-20261120    clang-17   cocci
loongarch            randconfig-r2309-20261120    gcc-16.2.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261120    gcc-12.5.0
m68k                  randconfig-2000-20261120    gcc-15.3.0
m68k                  randconfig-2001-20261120    gcc-15.3.0
m68k                  randconfig-2001-20261120    gcc-8.5.0
m68k                  randconfig-2200-20261120    gcc-14.4.0 smatch
m68k                  randconfig-2200-20261121    gcc-8.5.0  smatch
m68k                 randconfig-r2101-20261120    clang-24   cocci
m68k                 randconfig-r2104-20261120    gcc-9.5.0  cocci
m68k                 randconfig-r2106-20261120    gcc-8.5.0  cocci
m68k                 randconfig-r2310-20261121    gcc-11.5.0 sparse
m68k                 randconfig-r2311-20261121    gcc-11.5.0 sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261120    gcc-15.3.0
microblaze            randconfig-2000-20261120    gcc-9.5.0
microblaze            randconfig-2001-20261120    gcc-15.3.0
microblaze            randconfig-2001-20261120    gcc-8.5.0
microblaze            randconfig-2200-20261120    gcc-11.5.0 smatch
microblaze           randconfig-r2300-20261120    gcc-8.5.0  sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                         bcm47xx_defconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                         qi_lb60_defconfig    gcc-16.2.0
mips                  randconfig-2000-20261120    gcc-15.3.0
mips                  randconfig-2000-20261121    gcc-16.2.0
mips                  randconfig-2001-20261120    clang-19
mips                  randconfig-2001-20261121    gcc-16.2.0
mips                  randconfig-2002-20261120    gcc-11.5.0
mips                  randconfig-2002-20261121    gcc-16.2.0
mips                  randconfig-2200-20261120    clang-24   smatch
mips                  randconfig-2200-20261121    clang-21   smatch
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-2000-20261120    clang-24
nios2                 randconfig-2000-20261120    gcc-8.5.0
nios2                 randconfig-2001-20261120    clang-24
nios2                 randconfig-2001-20261120    gcc-8.5.0
nios2                 randconfig-2200-20261120    gcc-11.5.0 smatch
nios2                 randconfig-2200-20261121    gcc-10.5.0 smatch
nios2                randconfig-r2103-20261120    clang-24   cocci
nios2                randconfig-r2303-20261120    gcc-11.5.0 sparse
nios2                randconfig-r2311-20261120    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-11.5.0
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261120    gcc-9.5.0
openrisc              randconfig-2000-20261121    gcc-16.2.0
openrisc              randconfig-2001-20261120    gcc-11.5.0
openrisc              randconfig-2001-20261121    gcc-16.2.0
openrisc              randconfig-2002-20261120    gcc-9.5.0
openrisc              randconfig-2002-20261121    gcc-16.2.0
openrisc              randconfig-2200-20261120    gcc-11.5.0 smatch
openrisc             randconfig-r2100-20261120    gcc-10.5.0 cocci
openrisc             randconfig-r2305-20261120    gcc-8.5.0  sparse
openrisc             randconfig-r2307-20261120    gcc-14.4.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261122    clang-24
parisc                randconfig-1001-20261122    clang-24
parisc                randconfig-2000-20261120    clang-24
parisc                randconfig-2000-20261120    gcc-8.5.0
parisc                randconfig-2001-20261120    clang-24
parisc                randconfig-2001-20261120    gcc-13.5.0
parisc                randconfig-2200-20261120    gcc-8.5.0  smatch
parisc               randconfig-r2110-20261120    gcc-11.5.0 cocci
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       cm5200_defconfig    gcc-16.2.0
powerpc                  mpc837x_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261122    clang-24
powerpc               randconfig-1001-20261122    clang-24
powerpc               randconfig-2000-20261120    clang-17
powerpc               randconfig-2000-20261121    clang-24
powerpc               randconfig-2001-20261120    clang-19
powerpc               randconfig-2001-20261121    clang-24
powerpc               randconfig-2002-20261120    clang-24
powerpc               randconfig-2002-20261121    clang-24
powerpc               randconfig-2200-20261120    clang-17   smatch
powerpc               randconfig-2200-20261121    gcc-11.5.0 smatch
powerpc              randconfig-r2100-20261120    clang-24   cocci
powerpc              randconfig-r2301-20261120    clang-20   sparse
powerpc                      tqm8540_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261122    clang-24
powerpc64             randconfig-1001-20261122    clang-24
powerpc64             randconfig-2000-20261120    clang-24
powerpc64             randconfig-2000-20261121    clang-24
powerpc64             randconfig-2001-20261120    clang-24
powerpc64             randconfig-2001-20261121    clang-24
powerpc64             randconfig-2002-20261120    clang-18
powerpc64             randconfig-2002-20261121    clang-24
powerpc64             randconfig-2200-20261120    gcc-16.2.0 smatch
powerpc64             randconfig-2200-20261121    gcc-10.5.0 smatch
powerpc64            randconfig-r2303-20261120    gcc-8.5.0  sparse
powerpc64            randconfig-r2307-20261121    gcc-11.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261122    gcc-9.5.0
riscv                 randconfig-1001-20261122    gcc-9.5.0
riscv                 randconfig-2000-20261120    clang-24
riscv                 randconfig-2000-20261121    gcc-9.5.0
riscv                 randconfig-2001-20261120    gcc-10.5.0
riscv                 randconfig-2001-20261121    gcc-9.5.0
riscv                 randconfig-2002-20261120    gcc-8.5.0
riscv                 randconfig-2002-20261121    gcc-9.5.0
riscv                 randconfig-2003-20261120    clang-24
riscv                 randconfig-2003-20261121    gcc-9.5.0
riscv                 randconfig-2004-20261120    clang-20
riscv                 randconfig-2004-20261121    gcc-9.5.0
riscv                 randconfig-2005-20261120    gcc-10.5.0
riscv                 randconfig-2005-20261121    gcc-9.5.0
riscv                 randconfig-2200-20261120    gcc-8.5.0  smatch
riscv                randconfig-r2102-20261120    clang-24   cocci
riscv                randconfig-r2108-20261120    clang-17   cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261122    gcc-9.5.0
s390                  randconfig-1001-20261122    gcc-9.5.0
s390                  randconfig-2000-20261120    clang-24
s390                  randconfig-2000-20261120    gcc-8.5.0
s390                  randconfig-2001-20261120    clang-24
s390                  randconfig-2002-20261120    clang-24
s390                  randconfig-2003-20261120    clang-24
s390                  randconfig-2004-20261120    clang-24
s390                  randconfig-2004-20261120    gcc-16.2.0
s390                  randconfig-2005-20261120    clang-24
s390                  randconfig-2200-20261120    clang-17   smatch
s390                 randconfig-r2102-20261120    gcc-8.5.0  cocci
s390                 randconfig-r2306-20261121    gcc-11.5.0 sparse
s390                 randconfig-r2308-20261120    clang-17   sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261122    gcc-9.5.0
sh                    randconfig-1001-20261122    gcc-9.5.0
sh                    randconfig-2000-20261120    gcc-16.2.0
sh                    randconfig-2000-20261121    gcc-16.2.0
sh                    randconfig-2001-20261120    gcc-16.2.0
sh                    randconfig-2001-20261121    gcc-16.2.0
sh                    randconfig-2002-20261120    gcc-16.2.0
sh                    randconfig-2002-20261121    gcc-16.2.0
sh                    randconfig-2003-20261120    gcc-11.5.0
sh                    randconfig-2003-20261121    gcc-16.2.0
sh                    randconfig-2004-20261120    gcc-16.2.0
sh                    randconfig-2004-20261121    gcc-16.2.0
sh                    randconfig-2005-20261120    gcc-15.3.0
sh                    randconfig-2005-20261121    gcc-16.2.0
sh                    randconfig-2200-20261120    gcc-11.5.0 smatch
sh                   randconfig-r2103-20261120    gcc-16.2.0 cocci
sh                   randconfig-r2108-20261120    gcc-13.5.0 cocci
sparc                             alldefconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261122    clang-24
sparc                 randconfig-1001-20261122    clang-24
sparc                 randconfig-2000-20261120    gcc-16.2.0
sparc                 randconfig-2000-20261121    gcc-8.5.0
sparc                 randconfig-2001-20261120    gcc-8.5.0
sparc                 randconfig-2001-20261121    gcc-8.5.0
sparc                 randconfig-2200-20261120    gcc-11.5.0 smatch
sparc                 randconfig-2200-20261121    gcc-8.5.0  smatch
sparc                randconfig-r2105-20261120    gcc-8.5.0  cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261122    clang-24
sparc64               randconfig-1001-20261122    clang-24
sparc64               randconfig-2000-20261120    gcc-8.5.0
sparc64               randconfig-2000-20261121    gcc-8.5.0
sparc64               randconfig-2001-20261120    gcc-8.5.0
sparc64               randconfig-2001-20261121    gcc-8.5.0
sparc64               randconfig-2200-20261120    gcc-14.4.0 smatch
sparc64              randconfig-r2101-20261120    clang-24   cocci
sparc64              randconfig-r2107-20261120    clang-17   cocci
sparc64              randconfig-r2304-20261120    clang-24   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261122    clang-24
um                    randconfig-1001-20261122    clang-24
um                    randconfig-2000-20261120    clang-24
um                    randconfig-2000-20261121    gcc-8.5.0
um                    randconfig-2001-20261120    gcc-14
um                    randconfig-2001-20261121    gcc-8.5.0
um                    randconfig-2200-20261120    clang-24   smatch
um                    randconfig-2200-20261121    gcc-14     smatch
um                   randconfig-r2105-20261120    clang-24   cocci
um                   randconfig-r2305-20261120    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261122    gcc-14
x86_64                randconfig-1001-20261122    gcc-14
x86_64                randconfig-1002-20261122    gcc-14
x86_64                randconfig-1003-20261122    gcc-14
x86_64                randconfig-1004-20261122    gcc-14
x86_64                randconfig-1005-20261122    gcc-14
x86_64                randconfig-1006-20261122    gcc-14
x86_64                randconfig-1007-20261122    gcc-14
x86_64                randconfig-1008-20261122    gcc-14
x86_64                randconfig-1009-20261122    gcc-14
x86_64                randconfig-1010-20261122    gcc-14
x86_64                randconfig-1011-20261122    gcc-14
x86_64                randconfig-1012-20261122    clang-22
x86_64                randconfig-1013-20261122    clang-22
x86_64                randconfig-1014-20261122    clang-22
x86_64                randconfig-1015-20261122    clang-22
x86_64                randconfig-1016-20261122    clang-22
x86_64                randconfig-1017-20261122    clang-22
x86_64                randconfig-2000-20261120    clang-22
x86_64                randconfig-2000-20261120    gcc-14
x86_64                randconfig-2001-20261120    clang-22
x86_64                randconfig-2001-20261120    gcc-14
x86_64                randconfig-2002-20261120    clang-22
x86_64                randconfig-2003-20261120    clang-22
x86_64                randconfig-2004-20261120    clang-22
x86_64                randconfig-2005-20261120    clang-22
x86_64                randconfig-2005-20261120    gcc-14
x86_64                randconfig-2100-20261120    gcc-14     cocci
x86_64                randconfig-2100-20261121    gcc-14     cocci
x86_64                randconfig-2101-20261120    gcc-14     cocci
x86_64                randconfig-2101-20261121    gcc-14     cocci
x86_64                randconfig-2102-20261120    gcc-14     cocci
x86_64                randconfig-2102-20261121    gcc-14     cocci
x86_64                randconfig-2103-20261120    clang-22   cocci
x86_64                randconfig-2103-20261121    gcc-14     cocci
x86_64                randconfig-2104-20261120    clang-22   cocci
x86_64                randconfig-2104-20261121    gcc-14     cocci
x86_64                randconfig-2105-20261120    clang-22   cocci
x86_64                randconfig-2105-20261121    gcc-14     cocci
x86_64                randconfig-2200-20261120    clang-22   smatch
x86_64                randconfig-2300-20261120    clang-22   sparse
x86_64                randconfig-2300-20261120    gcc-14     sparse
x86_64                randconfig-2301-20261120    clang-22   sparse
x86_64                randconfig-2302-20261120    clang-22   sparse
x86_64               randconfig-r2111-20261120    gcc-14     cocci
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261122    clang-24
xtensa                randconfig-1001-20261122    clang-24
xtensa                randconfig-2000-20261121    gcc-16.2.0
xtensa                randconfig-2000-20261121    gcc-8.5.0
xtensa                randconfig-2001-20261120    gcc-8.5.0
xtensa                randconfig-2001-20261121    gcc-12.5.0
xtensa                randconfig-2001-20261121    gcc-16.2.0
xtensa                randconfig-2200-20261120    gcc-9.5.0  smatch
xtensa               randconfig-r2300-20261120    gcc-12.5.0 sparse
xtensa               randconfig-r2304-20261120    gcc-8.5.0  sparse
xtensa               randconfig-r2308-20261121    gcc-11.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

