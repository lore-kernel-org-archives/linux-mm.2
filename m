Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027CAC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8C86B00AB; Tue,  5 Aug 2025 13:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9956B00AC; Tue,  5 Aug 2025 13:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797E66B00AD; Tue,  5 Aug 2025 13:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65C256B00AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:23:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E98C71A014F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:22:59 +0000 (UTC)
X-FDA: 83743374078.02.0C5DA19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id 114F114000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:22:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AvqpAaX/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754414578; a=rsa-sha256;
	cv=none;
	b=k0uPFpAm1QV0MR/U+WA7AI/+ymp9IR4hXLhRA3ftMgNvZp2XAAZSSmIiNDTJWSJq0MWDIo
	J5LaiI0TDQGLXZFzfz1gtf7CqkGHzwzF6qCAPCXZ1qh4DVIo1rstVII8f8cHZIkp+MrkWy
	IrDYZ2XoVVyZpgUyHKBjL2swlXq+afs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AvqpAaX/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754414578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=uXx0jlH30dean7bS9AmJfi/QaqRpfuWdugcYHMG7xNw=;
	b=na4vECuSXrSIzvu8CmecBZd/yAo6zCgoEoV+QQ+VdQWYNNbeUauKp9Id1cQbb0I18tQ/L0
	Fzrwl36b+qtaX9KsYRrK8yArmcTor4y9LULP4Mj63jA8jvKl+b7c/MhWb/XpWvpkvt8r7W
	4gB1nQITcJ2Rz6LbRUfS5gR2BRHUT1c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754414577; x=1785950577;
  h=date:from:to:cc:subject:message-id;
  bh=2wxSb+W6W2H3IYq549Xa6/EYnVVYXVwx42/FVuF2q5s=;
  b=AvqpAaX/jy7OfnLdjhR63oq1E1id359WBzY4XxRfaiXwAVWCJ+IVsPEE
   xWK/VqTfOsDtIocSWPVy4NbXiV6WLBIrIjlFoocVHT/5vxF+Pc0TGsdHD
   mWMEScokcpuGD1qz0A6sFUpTwBq24nmB6mQAdCV1c9p9dw51zjeZhtD82
   FoiK4gcbumVKsEI03k2wNyYVM0cP7dlwQ1s9nyfistjubAHgJBew13o7V
   12HLAKlLuGfhOKHsXgIUmywItH9EQdSNiA1j+broyZxZsoyjrhTW3uqeL
   Oi0fCXR1RYzvtNHWeY8STfzg8mBsF6ocrQrTkaAVJIZBHA5Hr5lmLjU1b
   Q==;
X-CSE-ConnectionGUID: 5rx+2WGqTuWlBy5YOfUGaA==
X-CSE-MsgGUID: rGF4ajXERcWmA7M0P7hk9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56611363"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56611363"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 10:22:54 -0700
X-CSE-ConnectionGUID: SbYenHW/QuaAi8dQCh/q5w==
X-CSE-MsgGUID: zHGAn9uKQtGgVcEtGPaEVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="201732081"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 05 Aug 2025 10:22:53 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujLN8-0000iQ-0e;
	Tue, 05 Aug 2025 17:22:47 +0000
Date: Wed, 06 Aug 2025 01:22:37 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 afec768a6a8fe7fb02a08ffce5f2f556f51d4b52
Message-ID: <202508060118.lBLAlJwh-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 114F114000E
X-Stat-Signature: txsbzkmt96iourjutgia3zxuitzs57z6
X-HE-Tag: 1754414576-856001
X-HE-Meta: U2FsdGVkX18dSEqhxlGuVzybcrYVYoQyDq+AiWR7m1atCSTrogY5x7ryVXFKHVvwijNeW2WYMDeB4h12Qb9f7xgXD0QBeBMrEq3c7R4GiZF5X95TdExkEmgff56oPdsbQKvc61ymkK+Sb6kZf6ZrdQ+y4j/8w36IHyuqezWHY8lHETStyouZ511bY1ExMdHPZLYSrmD5MOKQQRA72pSG8T1UlNzc+MIOF2B5nil5VRP1k/h6pUAEoc4mBgsP/UNdbg5p5iOkaQos8ZMO27CYS30alZRv9zBmX5g58K4ArI7GplhnsEQfhGuktJdleXeNCWSz7+AVUHo64ZfbLIxOOzptysHocT0fViDqVnZokFGYQdm3YsRjDP2/5LWxEAZaHcssnViv8oX6I3G2CIcyD1uIQ8Aoitc7ge22tKWOLqJ1bwPDJhWJHTs2TxKqUhFmbewyGN+pRNWXF4sh1scv5GFW6Cu1/XaqMPLlA592H5a3l6+3nnT4HjC+vTXnkvDYCrmZdzY6qFA2cFEnavratvMOuBYZQKYlk2iETspmtNhggaGOguctL9Wul/iWNvGeqlaxCEwa16R4kggDXGDebcmYz1MtywPlGbyLeYG3i7M0N/yAqGBz6mubyOYg2nMNQMTra8fBMgGA7sfrQtFjR/sw4MZs7f+Ta6yIPmsTL8YibFFu4YkrpABXG3mDP0gX8qwbdsUmZ4OFUKLrrvYPiuOZK+WokxKsUZ7wfIVCyxbp2uKOt0Riy0OG4WG+S7OQgKc3wvLTliGAxyrEFGM0qJZyGHizoBNg6d+tsGAQ4bfTsbMxbysPYyex1KGYkahsfufIeG+J1qK92bUm4VSxAt/YGeQtd/6XVRcm9zrtgl1exNxDTkU0pQFsGzXlCWRNYFypVG9D0LoF+nlFgW3rcU9ILRmeFtt79gKZww1/2qahmT9r4moqQ7z41Bg7Y/LxiXgugLwuR3igOMGhZ04
 HWiJDfP3
 s672f5a9HZ+1cEmSDac3RoDD3/O24dGEQmMhqLqNAJJ5IFZhskLVsK55G73TgYlpYAH1LVJvPlh1PGWV9IQ3IMCOM7USMW1vfZ53gkHEmpTYgD4l2Z5GRC7iXj745G+Q5FqU/nC6EJ9xFqD0uVh4CIk6Bm6SPC8k7Q2TTtdy6IcvDTbVkDYB59kQYUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: afec768a6a8fe7fb02a08ffce5f2f556f51d4b52  Add linux-next specific files for 20250805

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508010846.fwKbJz68-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507290021.SSOS7V6E-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202507301209.hFc4VENm-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508020200.mf738OTo-lkp@intel.com

    drivers/i3c/master/../internals.h:54:9: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
    vmlinux.o: warning: objtool: populate_audio_dp_link_info+0x1fc: sibling call from callable instruction with modified stack frame
    vmlinux.o: warning: objtool: translate_to_dto_source+0x40: sibling call from callable instruction with modified stack frame

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_pt.c:2487 xe_pt_update_ops_run() error: uninitialized symbol 'ifence'.
    drivers/gpu/drm/xe/xe_pt.c:2492 xe_pt_update_ops_run() error: uninitialized symbol 'mfence'.
    drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c:3425 iwl_trans_pcie_dump_monitor() error: we previously assumed 'trans->dbg.dest_tlv' could be null (see line 3410)
    fs/bcachefs/fsck.c:187 lookup_lostfound() error: uninitialized symbol 'subvolid'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r122-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-061-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-062-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-063-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-141-20250805
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-ifence-.
|   |-- drivers-gpu-drm-xe-xe_pt.c-xe_pt_update_ops_run()-error:uninitialized-symbol-mfence-.
|   |-- drivers-net-wireless-intel-iwlwifi-pcie-gen1_2-trans.c-iwl_trans_pcie_dump_monitor()-error:we-previously-assumed-trans-dbg.dest_tlv-could-be-null-(see-line-)
|   `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.
|-- i386-randconfig-r123-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-r133-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- loongarch-randconfig-002-20250730
|   |-- vmlinux.o:warning:objtool:populate_audio_dp_link_info:sibling-call-from-callable-instruction-with-modified-stack-frame
|   `-- vmlinux.o:warning:objtool:translate_to_dto_source:sibling-call-from-callable-instruction-with-modified-stack-frame
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|-- mips-randconfig-r132-20250805
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- s390-randconfig-r121-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- sh-randconfig-002-20250805
|   |-- air_en8811h.c:(.text):undefined-reference-to-clk_restore_context
|   `-- air_en8811h.c:(.text):undefined-reference-to-clk_save_context
|-- sparc64-randconfig-002-20250805
|   `-- drivers-i3c-master-..-internals.h:error:passing-const-void-to-parameter-of-type-void-discards-qualifiers-Werror-Wincompatible-pointer-types-discards-qualifiers
|-- um-randconfig-r113-20250805
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-121-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-122-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-123-20250805
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
`-- x86_64-randconfig-161-20250805
    `-- fs-bcachefs-fsck.c-lookup_lostfound()-error:uninitialized-symbol-subvolid-.

elapsed time: 750m

configs tested: 208
configs skipped: 4

tested configs:
alpha                             allnoconfig    clang-22
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    clang-22
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250805    gcc-12.5.0
arc                   randconfig-001-20250805    gcc-8.5.0
arc                   randconfig-002-20250805    gcc-10.5.0
arc                   randconfig-002-20250805    gcc-12.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                       aspeed_g4_defconfig    clang-22
arm                         at91_dt_defconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20250805    gcc-11.5.0
arm                   randconfig-001-20250805    gcc-12.5.0
arm                   randconfig-002-20250805    clang-22
arm                   randconfig-002-20250805    gcc-12.5.0
arm                   randconfig-003-20250805    gcc-12.5.0
arm                   randconfig-004-20250805    clang-18
arm                   randconfig-004-20250805    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250805    gcc-12.5.0
arm64                 randconfig-002-20250805    clang-20
arm64                 randconfig-002-20250805    gcc-12.5.0
arm64                 randconfig-003-20250805    gcc-11.5.0
arm64                 randconfig-003-20250805    gcc-12.5.0
arm64                 randconfig-004-20250805    gcc-12.5.0
arm64                 randconfig-004-20250805    gcc-13.4.0
csky                              allnoconfig    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250805    gcc-10.5.0
csky                  randconfig-001-20250805    gcc-12.5.0
csky                  randconfig-002-20250805    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250805    clang-20
hexagon               randconfig-001-20250805    gcc-10.5.0
hexagon               randconfig-002-20250805    clang-22
hexagon               randconfig-002-20250805    gcc-10.5.0
i386                             alldefconfig    gcc-15.1.0
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250805    clang-20
i386        buildonly-randconfig-002-20250805    gcc-12
i386        buildonly-randconfig-003-20250805    gcc-12
i386        buildonly-randconfig-004-20250805    gcc-12
i386        buildonly-randconfig-005-20250805    gcc-12
i386        buildonly-randconfig-006-20250805    gcc-12
i386                                defconfig    clang-20
i386                  randconfig-001-20250805    clang-20
i386                  randconfig-002-20250805    clang-20
i386                  randconfig-003-20250805    clang-20
i386                  randconfig-004-20250805    clang-20
i386                  randconfig-005-20250805    clang-20
i386                  randconfig-006-20250805    clang-20
i386                  randconfig-007-20250805    clang-20
i386                  randconfig-011-20250805    clang-20
i386                  randconfig-012-20250805    clang-20
i386                  randconfig-013-20250805    clang-20
i386                  randconfig-014-20250805    clang-20
i386                  randconfig-015-20250805    clang-20
i386                  randconfig-016-20250805    clang-20
i386                  randconfig-017-20250805    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250805    gcc-10.5.0
loongarch             randconfig-001-20250805    gcc-15.1.0
loongarch             randconfig-002-20250805    gcc-10.5.0
loongarch             randconfig-002-20250805    gcc-12.5.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                          atari_defconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                  cavium_octeon_defconfig    gcc-15.1.0
mips                           ci20_defconfig    clang-22
mips                        omega2p_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-15.1.0
nios2                               defconfig    gcc-11.5.0
nios2                               defconfig    gcc-15.1.0
nios2                 randconfig-001-20250805    gcc-10.5.0
nios2                 randconfig-001-20250805    gcc-11.5.0
nios2                 randconfig-002-20250805    gcc-10.5.0
nios2                 randconfig-002-20250805    gcc-8.5.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-12
openrisc                            defconfig    gcc-15.1.0
parisc                           alldefconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250805    gcc-10.5.0
parisc                randconfig-002-20250805    gcc-10.5.0
parisc                randconfig-002-20250805    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                    adder875_defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     ep8248e_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250805    clang-22
powerpc               randconfig-001-20250805    gcc-10.5.0
powerpc               randconfig-002-20250805    clang-22
powerpc               randconfig-002-20250805    gcc-10.5.0
powerpc               randconfig-003-20250805    gcc-10.5.0
powerpc               randconfig-003-20250805    gcc-9.5.0
powerpc64             randconfig-001-20250805    clang-22
powerpc64             randconfig-001-20250805    gcc-10.5.0
powerpc64             randconfig-002-20250805    clang-19
powerpc64             randconfig-002-20250805    gcc-10.5.0
powerpc64             randconfig-003-20250805    clang-22
powerpc64             randconfig-003-20250805    gcc-10.5.0
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-12
riscv                 randconfig-001-20250805    clang-18
riscv                 randconfig-002-20250805    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-12
s390                  randconfig-001-20250805    clang-22
s390                  randconfig-002-20250805    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-12
sh                                  defconfig    gcc-15.1.0
sh                            hp6xx_defconfig    gcc-15.1.0
sh                    randconfig-001-20250805    gcc-9.5.0
sh                    randconfig-002-20250805    gcc-14.3.0
sh                          rsk7201_defconfig    gcc-15.1.0
sh                          rsk7203_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250805    gcc-8.5.0
sparc                 randconfig-002-20250805    gcc-15.1.0
sparc                       sparc32_defconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-12
sparc64               randconfig-001-20250805    gcc-9.5.0
sparc64               randconfig-002-20250805    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                                  defconfig    gcc-12
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250805    gcc-12
um                    randconfig-002-20250805    gcc-12
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-12
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250805    clang-20
x86_64      buildonly-randconfig-001-20250805    gcc-12
x86_64      buildonly-randconfig-002-20250805    clang-20
x86_64      buildonly-randconfig-002-20250805    gcc-12
x86_64      buildonly-randconfig-003-20250805    clang-20
x86_64      buildonly-randconfig-004-20250805    clang-20
x86_64      buildonly-randconfig-004-20250805    gcc-12
x86_64      buildonly-randconfig-005-20250805    clang-20
x86_64      buildonly-randconfig-006-20250805    clang-20
x86_64      buildonly-randconfig-006-20250805    gcc-12
x86_64                              defconfig    gcc-11
x86_64                randconfig-071-20250805    clang-20
x86_64                randconfig-072-20250805    clang-20
x86_64                randconfig-073-20250805    clang-20
x86_64                randconfig-074-20250805    clang-20
x86_64                randconfig-075-20250805    clang-20
x86_64                randconfig-076-20250805    clang-20
x86_64                randconfig-077-20250805    clang-20
x86_64                randconfig-078-20250805    clang-20
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250805    gcc-14.3.0
xtensa                randconfig-002-20250805    gcc-15.1.0
xtensa                         virt_defconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

