Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0D1D116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 07:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068066B000C; Sat, 29 Nov 2025 02:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018F36B000D; Sat, 29 Nov 2025 02:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70956B000E; Sat, 29 Nov 2025 02:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7EC56B000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:00:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 327F9BA6BA
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:00:58 +0000 (UTC)
X-FDA: 84162747396.19.7A80F48
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 83C3C1C0014
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:00:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=byw6nCh+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764399656; a=rsa-sha256;
	cv=none;
	b=cvo1TJbyFSx6wp47RkXiy7MxQOS6UmH4Oq9uJZDNhGiujKZT6J8sHIA4jGYcsTrNf/f8Yu
	3ah/HD3MsPP6KIQgPgVbEY4TsslKK3PHf7qUxWbsfRNImOKRe1wUQAWbGOyH6nDXWUsEBF
	vkR5pfkPjRNqRdqGBWLI6ThWZ9ehBwM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=byw6nCh+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764399656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=M6galFviRWdunR5IYFBmpvGwaXmADHhDwNiAGFdd1r4=;
	b=5i/fAkdyPbciZibC/R7XciHOHKmiTq+Ky/sodXI+/YKoxF61JYaSOqr0PnzMgCunkTh8gr
	tti39ZFHv4w0GBvBuXYN5mRy0rQvvNSKN0bjNpLbzAyu+9bvWN1NC5K23qe1NS46ijSgq1
	y8Me2+mfk51LNsbRx33GNFjFNsK1Sk8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764399656; x=1795935656;
  h=date:from:to:cc:subject:message-id;
  bh=eoT27Hqh3tozWvnJxb55nBANpp/pJzSTa3BR0P6dk3E=;
  b=byw6nCh+zFrKT9z4JVlnD+OE+OiryRthdLZqNHjTVellD4WowVrL5HmK
   q8u+I5AoEdu5H8ijuk9Mha0JWT49Qqa0V4Lwt0ACVT44iRsDUPKaECflv
   kbmznuCRVE4sDyRbqWK3bNzkFsXoYrcTYH74w1MDH1yHJsG49TdFI9ZuF
   BpvVyngHC6gVZWlMcA+iY/L8X076C4bqyXmmIZgs7f3rV1PeJrs3WgypO
   InthzqEcJRdzDpYqqjNOh2bu+mb6Z4MG2x1u+NVVZKz6K02y6rTH4LFlb
   DjN7rylOrpWlzJI4DVyad84NPzM/cU84upIenE68uZ/s2HkoLAmv/Kjf1
   Q==;
X-CSE-ConnectionGUID: BuW/uX0CTgq2tToADXtj2w==
X-CSE-MsgGUID: hIR78mDgSt+zsEYZBNDshQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11627"; a="66445506"
X-IronPort-AV: E=Sophos;i="6.20,235,1758610800"; 
   d="scan'208";a="66445506"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 23:00:54 -0800
X-CSE-ConnectionGUID: 18wobYsESjGi4WDgfRkWWQ==
X-CSE-MsgGUID: Pxb2COR+QfmXqHPxNTRYiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,235,1758610800"; 
   d="scan'208";a="198725108"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 28 Nov 2025 23:00:52 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vPEws-0000000071h-0AAK;
	Sat, 29 Nov 2025 07:00:50 +0000
Date: Sat, 29 Nov 2025 15:00:09 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 7d31f578f3230f3b7b33b0930b08f9afd8429817
Message-ID: <202511291501.P3J6cF8e-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83C3C1C0014
X-Stat-Signature: ss6ti3j3c1egfq8hgscoa5k58mizdem3
X-Rspam-User: 
X-HE-Tag: 1764399655-842779
X-HE-Meta: U2FsdGVkX18NYjY1KCfahY9+xduaEagxkao6WL7V3IdHJoUMnq8L9/w4zFLcfFJDxqaU6xOEZOOE4+Fa4etwlHGl8OyqwWcVzE9/vhaY+qJqDaRFL0zJtofOIZXRv4EXL4w5R/SibWz/09eV9DwxowawyC/XlwGxO7x9aoWWiVt4VD3IW8bL338vlbCy5Y+RIsu1CHmKT9tqmpawFQre5OLVXFl+jqKAECF207h2Pf3dM4STTsuIaWRVSwWdbINXPscKbf/+qq4cgq0N/i/7qFeRy46Zf2KruIWrZvdrrx2N3OLa2xDPxjl8KfHgd0Ix0m4t9UDpmZeRdkTmaNTe39Jil6JHB7O8PATMHpNpSL4Fg/UMTnFS8yIaSI/liQQFNbp4GWzyJS+jH8C24lWqo00EHEjrSbIUpCGrZ56wNjtXmp0GW5Eb+pK2D1YQwBoCq1OBOtGFTNuSh7MXhonUONQil4Uls9SDS3AgNhKrhI6xOAyxagdhyOYFGslQQyT5uoHIjjhQdyt0eJVhoMkP0BW37zmspY2ax90dFIqoJoq+0iAU2p2sqgfeCfE7MfaGjA4YoR3cKOG6Qc+taWn0HdA3Oasq6Zo/3Xa2QAzDZ+V/o7CMzTO3H260kIoW2SOK44823kbGtAoQ9cv6Smpiv7cyDwfnyjFSrMD04CxQyysJerHT4uPZIT2hFrFD5G/EQwSM+LtyhVymbWG/hZEEvmOF+os8TOJ/1qBOHNjAd7IcOFov0k/x8gneem+tS+D/wv0JJ6Yd7X/SZ4uHzCy0+hD8tmYYD91msmsKuLfvfhE9RTT4MNHN37NHF12r6fbawiLmQM4jhMGiSZjATL3gUTELsBxIpYDcLjJRBBJ9uXtgBgyJtIoV0A1sVjzcIRRgGmLuLAlgcptfqWa3N4INX/Pkh9Gdu21z1iZngFSgkio8rxnUybFWx69BgV9etw14Joey5EUWeHwMyKUge3h
 snI5NyYV
 z9Nu35aKc0QtCtqlaAQvmqkc6LygR0Vs0DTtvsq5dk0T16Y0woHXCYO5qJDMzfUC7FOcKCi/O0iJoxchy/jbX3BRQT0214Jiy1VSjiFe/kt8FtorIbXtuBEtyBMfU0nonY5Zk8jmuoN+GDK8ZnLYJpalTfLtX8K9kCBljcfpy6p9S7nlrgBqDlINmww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 7d31f578f3230f3b7b33b0930b08f9afd8429817  Add linux-next specific files for 20251128

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202511281900.DQmp9w3q-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511282325.uVQFRTkA-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511281720.i9qJCv8H-lkp@intel.com

    net/can/raw.c:933: undefined reference to `safe_candev_priv'
    net/can/raw.c:933:(.text+0x284): relocation truncated to fit: R_NIOS2_CALL26 against `safe_candev_priv'
    pinctrl-pic64gx-gpio2.c:(.rodata.cst4+0x4): undefined reference to `pinconf_generic_dt_node_to_map'
    sound/soc/sdca/sdca_class_function.c:349:(.text+0x41bb038): undefined reference to `__devm_regmap_init_sdw_mbq'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpib/common/gpib_os.c:816 ibioctl() warn: inconsistent returns '&board->big_gpib_mutex'.
    drivers/iommu/generic_pt/fmt/../iommu_pt.h:628 pt_iommu_amdv1_map_pages() warn: impossible condition '(paddr > 18446744073709551615) => (0-u64max > u64max)'
    mm/page_alloc.c:6159:1: internal compiler error: in arc_ccfsm_record_condition, at config/arc/arc.c:4800

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-002-20251129
|   `-- mm-page_alloc.c:internal-compiler-error:in-arc_ccfsm_record_condition-at-config-arc-arc.c
|-- i386-randconfig-141-20251125
|   `-- drivers-gpib-common-gpib_os.c-ibioctl()-warn:inconsistent-returns-board-big_gpib_mutex-.
|-- i386-randconfig-141-20251127
|   `-- drivers-iommu-generic_pt-fmt-..-iommu_pt.h-pt_iommu_amdv1_map_pages()-warn:impossible-condition-(paddr-)-(-u64max-u64max)
|-- nios2-randconfig-002-20251128
|   |-- net-can-raw.c:(.text):relocation-truncated-to-fit:R_NIOS2_CALL26-against-safe_candev_priv
|   `-- net-can-raw.c:undefined-reference-to-safe_candev_priv
|-- parisc-randconfig-002-20251129
|   `-- pinctrl-pic64gx-gpio2.c:(.rodata.cst4):undefined-reference-to-pinconf_generic_dt_node_to_map
`-- x86_64-randconfig-006-20251128
    `-- sound-soc-sdca-sdca_class_function.c:(.text):undefined-reference-to-__devm_regmap_init_sdw_mbq

elapsed time: 1450m

configs tested: 141
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251128    gcc-8.5.0
arc                   randconfig-002-20251128    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                                 defconfig    clang-22
arm                        mvebu_v5_defconfig    gcc-15.1.0
arm                   randconfig-001-20251128    gcc-14.3.0
arm                   randconfig-002-20251128    gcc-8.5.0
arm                   randconfig-003-20251128    clang-22
arm                   randconfig-004-20251128    clang-17
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251128    clang-22
arm64                 randconfig-002-20251128    clang-20
arm64                 randconfig-003-20251128    clang-22
arm64                 randconfig-004-20251128    gcc-10.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251128    gcc-15.1.0
csky                  randconfig-002-20251128    gcc-12.5.0
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251128    clang-22
hexagon               randconfig-002-20251128    clang-22
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20251128    gcc-14
i386        buildonly-randconfig-002-20251128    clang-20
i386        buildonly-randconfig-003-20251128    clang-20
i386        buildonly-randconfig-004-20251128    clang-20
i386        buildonly-randconfig-005-20251128    gcc-13
i386        buildonly-randconfig-006-20251128    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251128    clang-20
i386                  randconfig-002-20251128    clang-20
i386                  randconfig-003-20251128    clang-20
i386                  randconfig-004-20251128    gcc-14
i386                  randconfig-005-20251128    clang-20
i386                  randconfig-006-20251128    clang-20
i386                  randconfig-007-20251128    gcc-14
i386                  randconfig-011-20251128    gcc-12
i386                  randconfig-012-20251128    gcc-14
i386                  randconfig-013-20251128    clang-20
i386                  randconfig-014-20251128    clang-20
i386                  randconfig-015-20251128    gcc-14
i386                  randconfig-016-20251128    gcc-14
i386                  randconfig-017-20251128    gcc-14
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251128    gcc-15.1.0
loongarch             randconfig-002-20251128    clang-22
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                        bcm47xx_defconfig    clang-18
mips                        omega2p_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251128    gcc-8.5.0
nios2                 randconfig-002-20251128    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251128    gcc-14.3.0
parisc                randconfig-002-20251128    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                       ppc64_defconfig    clang-22
powerpc               randconfig-001-20251128    gcc-11.5.0
powerpc               randconfig-002-20251128    clang-22
powerpc                     tqm8540_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251128    clang-22
powerpc64             randconfig-002-20251128    gcc-8.5.0
riscv                             allnoconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251128    gcc-11.5.0
riscv                 randconfig-002-20251128    gcc-8.5.0
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20251128    clang-22
s390                  randconfig-002-20251128    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251128    gcc-13.4.0
sh                    randconfig-002-20251128    gcc-15.1.0
sh                          rsk7201_defconfig    gcc-15.1.0
sh                           se7724_defconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251128    gcc-8.5.0
sparc                 randconfig-002-20251128    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251128    gcc-12.5.0
sparc64               randconfig-002-20251128    gcc-12.5.0
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251128    clang-22
um                    randconfig-002-20251128    clang-22
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20251128    clang-20
x86_64      buildonly-randconfig-002-20251128    gcc-14
x86_64      buildonly-randconfig-003-20251128    gcc-14
x86_64      buildonly-randconfig-004-20251128    gcc-14
x86_64      buildonly-randconfig-005-20251128    clang-20
x86_64      buildonly-randconfig-006-20251128    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251128    gcc-14
x86_64                randconfig-002-20251128    gcc-14
x86_64                randconfig-003-20251128    gcc-14
x86_64                randconfig-004-20251128    clang-20
x86_64                randconfig-005-20251128    gcc-14
x86_64                randconfig-006-20251128    gcc-14
x86_64                randconfig-011-20251128    gcc-14
x86_64                randconfig-012-20251128    gcc-13
x86_64                randconfig-013-20251128    clang-20
x86_64                randconfig-014-20251128    clang-20
x86_64                randconfig-015-20251128    clang-20
x86_64                randconfig-016-20251128    clang-20
x86_64                randconfig-071-20251128    clang-20
x86_64                randconfig-072-20251128    gcc-14
x86_64                randconfig-073-20251128    clang-20
x86_64                randconfig-074-20251128    gcc-14
x86_64                randconfig-075-20251128    gcc-14
x86_64                randconfig-076-20251128    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251128    gcc-15.1.0
xtensa                randconfig-002-20251128    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

