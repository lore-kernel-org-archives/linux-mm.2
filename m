Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A32BFCD0C2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 06:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898766B00F4; Wed, 18 Mar 2026 02:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8497D6B00F5; Wed, 18 Mar 2026 02:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F866B00F6; Wed, 18 Mar 2026 02:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB956B00F4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:34:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F17AF1A05A0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:34:39 +0000 (UTC)
X-FDA: 84558220278.12.D42685B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 115874000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:34:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+cFwGci;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773815678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=dB+I3Qtvds5t92HSdlIOk9Pnuns3b18hHWZlLg+t3W4=;
	b=X/ORRvl5+IepBK7FuPhEtP/o4o0snrDiM6xtca6uV7zT7vqr5thlBz7HwG+NT6gpsHTSXX
	opR6rcmog6EAnFYQeX7lpgLXQd74baO4/Dbpy2kYhZRmDFp2/jKxEe9n0B5A5hNRFLAR+0
	VN24DhU9uI0VyEaAwsPTcXYkdzFq/sE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g+cFwGci;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773815678; a=rsa-sha256;
	cv=none;
	b=H0EtMO0GdUt0gaPiMaDhHGpRh1HkE3iQhiydxdgpK9GTd/FZbNO70/MdwSOcTlH5T6v8C+
	Mtf1G8LyhFYWuWMJOxnK6eiEVrmc042idOTC/Iw2RUEX91Gdv3XjO/Ivsbw5c2msD8wk9b
	/PqTa4fvokyDNxU6VrHc+el9HBIiQR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773815678; x=1805351678;
  h=date:from:to:cc:subject:message-id;
  bh=L7SmfpU6RoEZUNT6Z1kvOKAfefUAOBGR0U1ZAMvarLA=;
  b=g+cFwGcioQj00C5BbfPU8FDqFwRmygltp+xm8yYJ5VCHVF7WfG7w+XfY
   kVIi+GQ8odErcM0MMGJjCRmxT4Mo4fIqINLamJAYAY0q9P/yAJOQKjjnf
   GZM13l3+oEOFTVldUlMyZQz5ag0LGBlh+8u3q7D/WYqcQvX+oKETywKmX
   7F6iSp5/F5oFOnpN28BYHyECkPpchaB76i+3MpeRJv7ksMcoLdN+Q0lWN
   ZQ1qQRcSBxKPf2zaHaEpdks2EOCxg5lqLDVw+SGWXFkoJl2hFRWMQvc2b
   pFClbJtGEokny7De5sF2fRYFxkjyhFMo4Vumvyl0qXNDOX+hcOIg3gGsW
   g==;
X-CSE-ConnectionGUID: y/yMHTtxQFWC3t4ZnOU12w==
X-CSE-MsgGUID: mNwrKeAFTmGAilMbuML+ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="74749246"
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="74749246"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 23:34:36 -0700
X-CSE-ConnectionGUID: wUHz4dcpSpi5PLJTBbSz0A==
X-CSE-MsgGUID: o8+eZiu4SWSxzInuPNl0XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="226652784"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 17 Mar 2026 23:34:34 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2kUB-000000002cz-1J3o;
	Wed, 18 Mar 2026 06:34:31 +0000
Date: Wed, 18 Mar 2026 14:34:17 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 8e5a478b6d6a5bb0a3d52147862b15e4d826af19
Message-ID: <202603181406.cfQIlUQX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 115874000A
X-Stat-Signature: rg9qapfdtsfgigxi7pu7fpqyu7b1p5en
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773815676-932539
X-HE-Meta: U2FsdGVkX1+lDBXCYg8NlTytnnB2uGhoRjk7eysS1JVsOxQUiaH964KDGdfFlCZkL+VT2yDHeJvdApNXMUlD3l060bhE1mAWB84k3V1zE0Ycu1irgiIwpe+XCHrPpqIkYegHt2u4RyYdD2Slauxp9Wm3W8OQkkPeKeZMrwkyTit3pp/Cn9PXM3hpo9sVJW34E276bY1nU6sjgzNvgDTJohm85e2IMHgi3vvyqb1iUK2xVvJ1dluZLT8/FKFXcdIjUfvMydB1giXa0gAlQ4tUMbrvm64WMO5NKRQarD3dRsHj7pp64ZX9G3Nt/b7wywvhh7snTBnLWTGtcUr7/P384SLOD1VjPaygr/+z4LyezJgfLWgZwS9CLY7zG3gxPDCT64xchY/uKSZGO/f4aRSVhh2IaPYCfT6PtaKC1fEuTGQvKHA92y3MmqSXajESxGUjjk8Wkrvs2WuQlXIalHvwEVaNpFFg/VeWN0CfLjmIdMcaNUtwWIIhHNzlo4Dxd2nqg5LHcc948GnC96QYxWu4KQMuP8UnriJ3Tk8ZrTUTMMm2POk5beIXiSIZ62iyXIyIRJu0+tTyo5kqYlxPOXAKqL3gM91MbZGcut8O1gGEdWJ/LrTLxw4itJpW+LnGUDwxPROolxXk0Wwi4G4+5Qc5Yx0NAejLExaPqw0R7m50HdIcP9MocR/mZEiywS10cFpLxeluBKEWq0OQWf6l2U+hCd8Hlsk+J7v0y24W9XLKKGxJKRRINW/2+WrgLJX6i9fVzM5GHWfjafNlPVBrdGW3wiOXJLyybZlX3VAYT3Ei6EhZn79jmuHk68WuSosI7TgURoco2VCy13qjxD+j4M9uxifSGQOd7SmQFEf+WFd4ZnXaRfsKKk0DXf4Xp2xZmPGo2n/axfe39jHLZ1GODqgxqyMIuJeALfH/omeDpFk1OUH0Z1ZxBVwAcJCKJYlAtoEXT2UoXgW3aQmx/YuHly4
 BuKy+6vQ
 51iP4YMhdrWT+pttwRa5iOBXusMk5n1PysUPMoKgNnlTFspgVJFPIjUfzLJr8aZ1gS4gwCr2r2ETteTpDACnP5+HXNqbq4yMQ8fXViEfbS21z2UF1JhpgP44gbNJyqkWh+/2acQBoL0QfZyhS5r9fut/UxMhncFvfqJazAbA4Blad3xFAMEqu3aANNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 8e5a478b6d6a5bb0a3d52147862b15e4d826af19  Add linux-next specific files for 20260317

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603180202.myb6Tv5N-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603180616.TM6qYvIY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603180630.HWujluGX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603180642.1rALz4hC-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603181152.94qXoLq4-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202603181233.gIWvTNla-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603180601.Zk8OGTBr-lkp@intel.com

    ERROR: modpost: "__udivdi3" [fs/nilfs2/nilfs2.ko] undefined!
    ERROR: modpost: "rdma_accept" [drivers/block/drbd/drbd_transport_rdma.ko] undefined!
    ERROR: modpost: "rdma_resolve_route" [drivers/block/drbd/drbd_transport_rdma.ko] undefined!
    Warning: arch/x86/virt/vmx/tdx/tdx.c:141 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    drivers/gpu/drm/bridge/lontium-lt8713sx.c:141:(.text.lt8713sx_firmware_store+0x138): undefined reference to `__udivdi3'
    drivers/gpu/drm/xe/xe_lrc.c:1921:40: error: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'int' [-Werror=format=]
    drivers/gpu/drm/xe/xe_lrc.c:1922:7: warning: format specifies type 'unsigned long' but the argument has type '__ptrdiff_t' (aka 'int') [-Wformat]
    fs/erofs/ishare.c:157:15: error: implicit declaration of function 'security_mmap_backing_file' [-Wimplicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3945 stmmac_request_irq_multi_msi() warn: 'msi->sfty_ce_irq' from request_irq() not released on lines: 3945.
    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3945 stmmac_request_irq_multi_msi() warn: 'msi->sfty_ue_irq' from request_irq() not released on lines: 3945.
    drivers/usb/typec/tcpm/fusb302.c:1789 fusb302_probe() warn: 'chip->gpio_int_n_irq' from request_irq() not released on lines: 1778.
    fs/ntfs3/attrib.c:1625:24: warning: 'off[1]' may be used uninitialized in this function [-Wmaybe-uninitialized]
    fs/ntfs3/attrib.c:1631:9: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r113-20260318
|   `-- drivers-gpu-drm-xe-xe_lrc.c:warning:format-specifies-type-unsigned-long-but-the-argument-has-type-__ptrdiff_t-(aka-int-)
|-- arm64-randconfig-r072-20260317
|   |-- drivers-net-ethernet-stmicro-stmmac-stmmac_main.c-stmmac_request_irq_multi_msi()-warn:msi-sfty_ce_irq-from-request_irq()-not-released-on-lines:.
|   `-- drivers-net-ethernet-stmicro-stmmac-stmmac_main.c-stmmac_request_irq_multi_msi()-warn:msi-sfty_ue_irq-from-request_irq()-not-released-on-lines:.
|-- arm64-randconfig-r072-20260318
|   `-- drivers-usb-typec-tcpm-fusb302.c-fusb302_probe()-warn:chip-gpio_int_n_irq-from-request_irq()-not-released-on-lines:.
|-- i386-randconfig-003-20260317
|   `-- fs-erofs-ishare.c:error:implicit-declaration-of-function-security_mmap_backing_file
|-- i386-randconfig-004-20260318
|   `-- drivers-gpu-drm-xe-xe_lrc.c:error:format-lx-expects-argument-of-type-long-unsigned-int-but-argument-has-type-int
|-- i386-randconfig-005-20260318
|   |-- ERROR:rdma_accept-drivers-block-drbd-drbd_transport_rdma.ko-undefined
|   `-- ERROR:rdma_resolve_route-drivers-block-drbd-drbd_transport_rdma.ko-undefined
|-- m68k-randconfig-r073-20260318
|   `-- drivers-gpu-drm-bridge-lontium-lt8713sx.c:(.text.lt8713sx_firmware_store):undefined-reference-to-__udivdi3
|-- nios2-randconfig-r131-20260318
|   `-- drivers-gpu-drm-verisilicon-vs_dc.c:sparse:sparse:symbol-vs_dc_platform_driver-was-not-declared.-Should-it-be-static
|-- powerpc-randconfig-001-20260317
|   `-- ERROR:__udivdi3-fs-nilfs2-nilfs2.ko-undefined
|-- sparc64-randconfig-r122-20260318
|   `-- drivers-pci-controller-dwc-pcie-eswin.c:sparse:sparse:symbol-eswin_pcie_pm-was-not-declared.-Should-it-be-static
|-- x86_64-randconfig-011-20260317
|   `-- Warning:arch-x86-virt-vmx-tdx-tdx.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
`-- xtensa-randconfig-001-20260318
    |-- fs-ntfs3-attrib.c:warning:err-may-be-used-uninitialized-in-this-function
    `-- fs-ntfs3-attrib.c:warning:off-may-be-used-uninitialized-in-this-function

elapsed time: 784m

configs tested: 171
configs skipped: 7

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260318    gcc-14.3.0
arc                   randconfig-002-20260318    gcc-14.3.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                   randconfig-001-20260318    clang-23
arm                   randconfig-002-20260318    clang-23
arm                   randconfig-003-20260318    clang-23
arm                   randconfig-004-20260318    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260318    gcc-8.5.0
arm64                 randconfig-002-20260318    gcc-15.2.0
arm64                 randconfig-003-20260318    clang-23
arm64                 randconfig-004-20260318    gcc-12.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260318    gcc-13.4.0
csky                  randconfig-002-20260318    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260318    clang-23
hexagon               randconfig-002-20260318    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260318    clang-20
i386        buildonly-randconfig-002-20260318    gcc-14
i386        buildonly-randconfig-003-20260318    clang-20
i386        buildonly-randconfig-004-20260318    gcc-14
i386        buildonly-randconfig-005-20260318    gcc-14
i386        buildonly-randconfig-006-20260318    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20260318    gcc-14
i386                  randconfig-002-20260318    gcc-14
i386                  randconfig-003-20260318    clang-20
i386                  randconfig-004-20260318    gcc-14
i386                  randconfig-005-20260318    clang-20
i386                  randconfig-006-20260318    gcc-14
i386                  randconfig-007-20260318    gcc-14
i386                  randconfig-011-20260318    gcc-14
i386                  randconfig-012-20260318    gcc-13
i386                  randconfig-013-20260318    clang-20
i386                  randconfig-014-20260318    clang-20
i386                  randconfig-015-20260318    clang-20
i386                  randconfig-016-20260318    clang-20
i386                  randconfig-017-20260318    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260318    clang-23
loongarch             randconfig-002-20260318    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                         apollo_defconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260318    gcc-8.5.0
nios2                 randconfig-002-20260318    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260318    gcc-15.2.0
parisc                randconfig-002-20260318    gcc-8.5.0
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260318    clang-23
powerpc               randconfig-002-20260318    gcc-12.5.0
powerpc64             randconfig-001-20260318    gcc-11.5.0
powerpc64             randconfig-002-20260318    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260318    gcc-13.4.0
riscv                 randconfig-002-20260318    gcc-12.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260318    gcc-11.5.0
s390                  randconfig-002-20260318    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260318    gcc-9.5.0
sh                    randconfig-002-20260318    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260318    gcc-8.5.0
sparc                 randconfig-002-20260318    gcc-13.4.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260318    gcc-8.5.0
sparc64               randconfig-002-20260318    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260318    gcc-14
um                    randconfig-002-20260318    clang-23
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260318    gcc-14
x86_64      buildonly-randconfig-002-20260318    gcc-14
x86_64      buildonly-randconfig-003-20260318    gcc-14
x86_64      buildonly-randconfig-004-20260318    clang-20
x86_64      buildonly-randconfig-005-20260318    clang-20
x86_64      buildonly-randconfig-006-20260318    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260318    clang-20
x86_64                randconfig-002-20260318    gcc-14
x86_64                randconfig-003-20260318    gcc-14
x86_64                randconfig-004-20260318    gcc-14
x86_64                randconfig-005-20260318    gcc-14
x86_64                randconfig-006-20260318    clang-20
x86_64                randconfig-011-20260318    gcc-14
x86_64                randconfig-012-20260318    gcc-14
x86_64                randconfig-013-20260318    gcc-14
x86_64                randconfig-014-20260318    clang-20
x86_64                randconfig-015-20260318    gcc-14
x86_64                randconfig-016-20260318    clang-20
x86_64                randconfig-071-20260318    gcc-14
x86_64                randconfig-072-20260318    gcc-14
x86_64                randconfig-073-20260318    clang-20
x86_64                randconfig-074-20260318    gcc-14
x86_64                randconfig-075-20260318    gcc-14
x86_64                randconfig-076-20260318    gcc-14
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
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260318    gcc-8.5.0
xtensa                randconfig-002-20260318    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

