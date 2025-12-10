Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1FBD3C525
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1319F6B0006; Tue,  9 Dec 2025 22:32:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2D06B0007; Tue,  9 Dec 2025 22:32:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E876B0008; Tue,  9 Dec 2025 22:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2D9A6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:32:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAAFA134693
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:32:46 +0000 (UTC)
X-FDA: 84202139532.06.A027372
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0961EC000B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:32:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=knNjhAtl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765337564; a=rsa-sha256;
	cv=none;
	b=YkMxQcslq6+YzZRkEg+qPpJiwGLnw0bbGZbgEkVKVXANuiaU3VsSA3/fnXdWzJ8X7NcStV
	r1X/yxDb569R69C4OQ5kRUyorvnMusmbaVTaXz6gip8t8RoJLGsb8aYPKwKJckA11rzul3
	i9OlE1rTLYzBRRJwwSvHeJVa40mTznA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=knNjhAtl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765337564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=5eiZSwdwrg1IlNpdgzjVmFnMw5Xbf6saJdhA368+lqU=;
	b=WSyuCKzjCqY9h5aeXbq2snBgwRf/4inQrv8BC+k2KyJskpjIsSa8kzNbIScw4iSNwHuyu7
	SHbs4pfZ8dHv1jolTaft3HS7+z+nJPtlD+7qz7GH3AztdAKgEtkWRNzrYIOBs28wTPCgM9
	Y0JG8oRsCKpCDa7dtS88fR6Idy9D+40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765337564; x=1796873564;
  h=date:from:to:cc:subject:message-id;
  bh=vaLDk8Z3ibjndOZxYt/TNI28KSw7/lXQ8tH95lb41Tg=;
  b=knNjhAtl1+vS+cvDRIq+/3mn0dJXYd4vWbLzpgblsAfnGVAwGlPVL5pC
   XXr/qCIfuySVFfRpRSwdSVBnM6SOskAS1v/fEY9fRmz+pdM/+T+Q27As4
   ncg9Mk6wVYGaMi4V2Z6p9+tSrOF5RKZSjimUFJUrOuvtzvKLXHkT0s6ob
   BndMeQ3tMRVdvvVR80uqe/EDiwJj1IWnWduFhuU6HZGrJ/Zeiuq5r3W7O
   lAHwharCKuAY3RN2/oSjUp+nuWI7HS2BbuuLXsQmALcnX84YwKHIfv6L8
   7pfB0uL+FYHOo6/7jh0DNtPt2OZygasrwQn6zxHpRFvUTeI7MW2pqIRYF
   Q==;
X-CSE-ConnectionGUID: 9XDmAF7OQOuHURhgghhWCw==
X-CSE-MsgGUID: x4h57oELTfuI88gF3WQqxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="78665881"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="78665881"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 19:32:42 -0800
X-CSE-ConnectionGUID: KesuhJQ2QjKQ7kCqiqmUhg==
X-CSE-MsgGUID: g2/oifJxQL+XKzgfJ1or8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="197176953"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 09 Dec 2025 19:32:41 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTAwR-000000002ci-1f1T;
	Wed, 10 Dec 2025 03:32:39 +0000
Date: Wed, 10 Dec 2025 11:32:00 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 c75caf76ed86bbc15a72808f48f8df1608a0886c
Message-ID: <202512101149.gQr4Ydcc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: bsqm46e81f4xg5ekpxcuu86jf7nw6xqz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0961EC000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1765337563-453136
X-HE-Meta: U2FsdGVkX18ymKQx6KLj+axl8hGb4XILzI/t6q/fZnuV4qR+Yug9Tm0uoEC70c+83aMJTzs2BM0OPeq57bLu2U+/owMJvMktISHcADkbj45v6bWDlb2DYlDyIFD5RoEYU8RugLj1kPkfHlEfD58POnqjXUZ51Ipt1HvegvAtfJJ0MkgdZ0gyWnftJMl4aim0LXQwfviCRT12lxGxT9jGCpFXO6K7s1zkBkf2VsIvJEqvo5qPZ/Wu8gE10DHZB/aQkv9+fNmXd5FC3aOlXtqxzrNx5bRCpzciinuW/D9Kyqbv5k9LGs7K6t+6FQ51yDALOEwF4JkQwuqGNEURbse2WNJz+6kQDClRFdZb50+zoy209rdXnamfJf+e+VKvStx57osUpH+Gi5ZOx6LHE9th9ogUhCjiJmnxxO3kUE9HyPCIrdA1SMh8wlObi01GQnvTbvKMExTNEX+1oI0z7Ky8GjVMluWLnqn1u1NvHxCLEC1iiMb2PkgNTmYybpowdAtSG+2u5j4IiRo7ewSnbfln5fL0DDKU2oaDjf4mslF4i/om9TNO8b1EDo1d2aCac2Uhd63wvsQJHEjTyDbBg86PZjDoatwVt3fQN+9rw/aRGMylzQQmIROOy0lqaH1fLPjJsqUZCMafqVFCSIKcBziSNixlgolzreJP0+p0+7TxgXQDO5e6qUvPO53PlM+VMF7ygj/ZihBYEqKPNaUETwYFdvB1ntmnnK5fF/gEDsBGrR3wRYMgRBIYGnc2jSJr57rlLH8docBBrOYpoUumbDpWAVx9KPpbRs+xunGgE4MB2vJEa+ZQbWRJn9Vhi2K/btdjtQ+IFyFKDHaSs4hM5XvCadfdVskMnmBlJdYMQDudUdAqcGyjBZchYcYRX5CLX7lC3ijshFHpG7qJrpFMDMdpAkLXksJPeO1tVT5ooij9aIrM7ccruXoNxYfbPByjB84TShb4j23WD0Cu/48ta/W
 1N/JTyhC
 DW+ZwN7Kj7+KeXPzPjtLBACVWS5mpcrzyQGeblqbnTRJC8nEfGKQq4ap8O9o7RpyaBkKIMUvDlq8Hu7C/gfCjj3BpMl4hSaxDq5GKXzAijSxVgjsvy1ZWBBsGliQAAVvto48lLv2OQAO9sKjsXY4Yoe9v+as40vJ/7vUeJkIkpIKOwfwCVENn9bjXZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: c75caf76ed86bbc15a72808f48f8df1608a0886c  Add linux-next specific files for 20251209

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild/202512091802.WtXCOnXL-lkp@intel.com

    (.exception.text+0x247): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: make_task_dead

Unverified Error/Warning (likely false positive, kindly check if interested):

    (.text+0x490): undefined reference to `devm_backlight_device_register'
    drivers/clk/qcom/nsscc-ipq5424.c:1339:1: sparse: sparse: bad integer constant expression
    drivers/clk/qcom/nsscc-ipq5424.c:1339:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/clk/qcom/nsscc-ipq5424.c:1340:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/clk/qcom/videocc-sm8750.c:462:1: sparse: sparse: bad integer constant expression
    drivers/clk/qcom/videocc-sm8750.c:462:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/clk/qcom/videocc-sm8750.c:463:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/clk/qcom/videocc-sm8750.c:463:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/gpib/gpio/gpib_bitbang.c:71:1: sparse: sparse: bad integer constant expression
    drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-dev.c:249:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r113-20251209
|   `-- drivers-media-platform-renesas-rzv2h-ivc-rzv2h-ivc-dev.c:sparse:sparse:bad-integer-constant-expression
|-- m68k-randconfig-r131-20251209
|   `-- drivers-pinctrl-qcom-pinctrl-kaanapali.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|-- microblaze-randconfig-r123-20251209
|   `-- drivers-media-platform-arm-mali-c55-mali-c55-core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|-- parisc-randconfig-r113-20251208
|   |-- (.text):undefined-reference-to-devm_backlight_device_register
|   |-- drivers-clk-qcom-nsscc-ipq5424.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-clk-qcom-nsscc-ipq5424.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   `-- drivers-clk-qcom-nsscc-ipq5424.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|-- riscv-randconfig-r123-20251209
|   `-- drivers-net-dsa-lantiq-mxl-gsw1xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|-- um-randconfig-r134-20251209
|   |-- drivers-clk-qcom-videocc-sm8750.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-clk-qcom-videocc-sm8750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-clk-qcom-videocc-sm8750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   `-- drivers-clk-qcom-videocc-sm8750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|-- x86_64-randconfig-122-20251209
|   `-- sound-soc-sof-intel-pci-nvl.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
`-- xtensa-randconfig-r121-20251205
    |-- (.exception.text):dangerous-relocation:windowed-longcall-crosses-1GB-boundary-return-may-fail:make_task_dead
    |-- drivers-gpib-gpio-gpib_bitbang.c:sparse:sparse:bad-integer-constant-expression
    `-- drivers-watchdog-renesas_wwdt.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte

elapsed time: 1476m

configs tested: 281
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-22
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                     nsimosci_hs_defconfig    gcc-15.1.0
arc                   randconfig-001-20251209    gcc-13.4.0
arc                   randconfig-001-20251210    gcc-11.5.0
arc                   randconfig-002-20251209    gcc-9.5.0
arc                   randconfig-002-20251210    gcc-11.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.1.0
arm                   randconfig-001-20251209    clang-19
arm                   randconfig-001-20251210    gcc-11.5.0
arm                   randconfig-002-20251209    clang-20
arm                   randconfig-002-20251210    gcc-11.5.0
arm                   randconfig-003-20251209    clang-22
arm                   randconfig-003-20251210    gcc-11.5.0
arm                   randconfig-004-20251209    clang-22
arm                   randconfig-004-20251210    gcc-11.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-22
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251209    gcc-8.5.0
arm64                 randconfig-001-20251210    clang-17
arm64                 randconfig-002-20251209    gcc-9.5.0
arm64                 randconfig-002-20251210    clang-17
arm64                 randconfig-003-20251209    clang-22
arm64                 randconfig-003-20251210    clang-17
arm64                 randconfig-004-20251209    gcc-11.5.0
arm64                 randconfig-004-20251210    clang-17
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251209    gcc-15.1.0
csky                  randconfig-001-20251210    clang-17
csky                  randconfig-002-20251209    gcc-15.1.0
csky                  randconfig-002-20251210    clang-17
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.1.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251209    clang-22
hexagon               randconfig-001-20251210    gcc-10.5.0
hexagon               randconfig-002-20251209    clang-22
hexagon               randconfig-002-20251210    gcc-10.5.0
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251209    clang-20
i386        buildonly-randconfig-001-20251210    clang-20
i386        buildonly-randconfig-002-20251209    clang-20
i386        buildonly-randconfig-002-20251210    clang-20
i386        buildonly-randconfig-003-20251209    gcc-14
i386        buildonly-randconfig-003-20251210    clang-20
i386        buildonly-randconfig-004-20251209    gcc-14
i386        buildonly-randconfig-004-20251210    clang-20
i386        buildonly-randconfig-005-20251209    gcc-14
i386        buildonly-randconfig-005-20251210    clang-20
i386        buildonly-randconfig-006-20251209    gcc-14
i386        buildonly-randconfig-006-20251210    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251209    gcc-14
i386                  randconfig-002-20251209    clang-20
i386                  randconfig-003-20251209    clang-20
i386                  randconfig-004-20251209    gcc-14
i386                  randconfig-005-20251209    gcc-14
i386                  randconfig-006-20251209    clang-20
i386                  randconfig-007-20251209    gcc-14
i386                  randconfig-011-20251209    clang-20
i386                  randconfig-011-20251210    gcc-14
i386                  randconfig-012-20251209    clang-20
i386                  randconfig-012-20251210    gcc-14
i386                  randconfig-013-20251209    clang-20
i386                  randconfig-013-20251210    gcc-14
i386                  randconfig-014-20251209    clang-20
i386                  randconfig-014-20251210    gcc-14
i386                  randconfig-015-20251209    clang-20
i386                  randconfig-015-20251210    gcc-14
i386                  randconfig-016-20251209    clang-20
i386                  randconfig-016-20251210    gcc-14
i386                  randconfig-017-20251209    gcc-14
i386                  randconfig-017-20251210    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-22
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251209    clang-22
loongarch             randconfig-001-20251210    gcc-10.5.0
loongarch             randconfig-002-20251209    clang-22
loongarch             randconfig-002-20251210    gcc-10.5.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                            gpr_defconfig    clang-18
mips                           ip22_defconfig    gcc-15.1.0
mips                           ip28_defconfig    gcc-15.1.0
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251209    gcc-8.5.0
nios2                 randconfig-001-20251210    gcc-10.5.0
nios2                 randconfig-002-20251209    gcc-11.5.0
nios2                 randconfig-002-20251210    gcc-10.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251209    gcc-8.5.0
parisc                randconfig-001-20251210    clang-19
parisc                randconfig-002-20251209    gcc-13.4.0
parisc                randconfig-002-20251210    clang-19
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                   currituck_defconfig    clang-22
powerpc               randconfig-001-20251209    gcc-14.3.0
powerpc               randconfig-001-20251210    clang-19
powerpc               randconfig-002-20251209    clang-22
powerpc               randconfig-002-20251210    clang-19
powerpc                     tqm5200_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251209    gcc-14.3.0
powerpc64             randconfig-001-20251210    clang-19
powerpc64             randconfig-002-20251209    gcc-15.1.0
powerpc64             randconfig-002-20251210    clang-19
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251209    clang-22
riscv                 randconfig-001-20251210    clang-22
riscv                 randconfig-002-20251209    clang-18
riscv                 randconfig-002-20251210    clang-22
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251209    gcc-12.5.0
s390                  randconfig-001-20251210    clang-22
s390                  randconfig-002-20251209    gcc-12.5.0
s390                  randconfig-002-20251210    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251209    gcc-14.3.0
sh                    randconfig-001-20251210    clang-22
sh                    randconfig-002-20251209    gcc-13.4.0
sh                    randconfig-002-20251210    clang-22
sh                          sdk7780_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251209    gcc-11.5.0
sparc                 randconfig-001-20251210    gcc-15.1.0
sparc                 randconfig-002-20251209    gcc-15.1.0
sparc                 randconfig-002-20251210    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251209    clang-22
sparc64               randconfig-001-20251210    gcc-15.1.0
sparc64               randconfig-002-20251209    clang-20
sparc64               randconfig-002-20251210    gcc-15.1.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.1.0
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251209    gcc-14
um                    randconfig-001-20251210    gcc-15.1.0
um                    randconfig-002-20251209    gcc-14
um                    randconfig-002-20251210    gcc-15.1.0
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251209    clang-20
x86_64      buildonly-randconfig-001-20251210    clang-20
x86_64      buildonly-randconfig-002-20251209    gcc-14
x86_64      buildonly-randconfig-002-20251210    clang-20
x86_64      buildonly-randconfig-003-20251209    gcc-14
x86_64      buildonly-randconfig-003-20251210    clang-20
x86_64      buildonly-randconfig-004-20251209    clang-20
x86_64      buildonly-randconfig-004-20251210    clang-20
x86_64      buildonly-randconfig-005-20251209    clang-20
x86_64      buildonly-randconfig-005-20251210    clang-20
x86_64      buildonly-randconfig-006-20251209    clang-20
x86_64      buildonly-randconfig-006-20251210    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251209    clang-20
x86_64                randconfig-001-20251210    gcc-14
x86_64                randconfig-002-20251209    clang-20
x86_64                randconfig-002-20251210    gcc-14
x86_64                randconfig-003-20251209    clang-20
x86_64                randconfig-003-20251210    gcc-14
x86_64                randconfig-004-20251209    gcc-14
x86_64                randconfig-004-20251210    gcc-14
x86_64                randconfig-005-20251209    gcc-14
x86_64                randconfig-005-20251210    gcc-14
x86_64                randconfig-006-20251209    gcc-14
x86_64                randconfig-006-20251210    gcc-14
x86_64                randconfig-011-20251209    gcc-14
x86_64                randconfig-012-20251209    clang-20
x86_64                randconfig-013-20251209    gcc-14
x86_64                randconfig-014-20251209    clang-20
x86_64                randconfig-015-20251209    clang-20
x86_64                randconfig-016-20251209    clang-20
x86_64                randconfig-071-20251209    clang-20
x86_64                randconfig-071-20251210    clang-20
x86_64                randconfig-072-20251209    gcc-14
x86_64                randconfig-072-20251210    clang-20
x86_64                randconfig-073-20251209    gcc-14
x86_64                randconfig-073-20251210    clang-20
x86_64                randconfig-074-20251209    gcc-14
x86_64                randconfig-074-20251210    clang-20
x86_64                randconfig-075-20251209    gcc-14
x86_64                randconfig-075-20251210    clang-20
x86_64                randconfig-076-20251209    clang-20
x86_64                randconfig-076-20251210    clang-20
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
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    clang-22
xtensa                randconfig-001-20251209    gcc-13.4.0
xtensa                randconfig-001-20251210    gcc-15.1.0
xtensa                randconfig-002-20251209    gcc-10.5.0
xtensa                randconfig-002-20251210    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

