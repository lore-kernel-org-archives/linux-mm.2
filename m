Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0A7CF8545
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1966B0010; Thu, 20 Nov 2025 01:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2956B0022; Thu, 20 Nov 2025 01:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9186B002B; Thu, 20 Nov 2025 01:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9B8A6B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:25:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C1045ABB7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:25:35 +0000 (UTC)
X-FDA: 84129999030.11.A6A1CFA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29FB3140009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:25:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IMVWb6gS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763619933; a=rsa-sha256;
	cv=none;
	b=EwaQlsjZTadvJQCc6sZwPDecgig71bgY8D6+bezROzRG+g9Bdxg/48wFC+keWx0JTmMlzt
	RHGtTLPMq8GTegUdlsHLIFGZYiiVVrFT7rsSK9G0lxVeaSzTnhl9Jr59UxJonWUEKXNhnY
	xI3JXlG+eieO2AVEruXVNLh4yF3/ajo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IMVWb6gS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763619933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Kh6HG+h1UZIKlTIBEgWQLteCZ6EtPKbL19QUe58KQ2E=;
	b=0RaL/EQBi1OtAiIhU8xL+0UP4MNfmZYqdxruN1vEQRkoGL2DHM0jOe/MjdEq7Djx9hlhq+
	63I2BM1PPqw1+3IzSuVq7CGkeqXSTcBanmtxRz5uEWT/ZL9V1f1NW4gDVswXuqWqqcXnug
	3hm+X7rhgAZn7PwL8FgSd/2PFpCkttc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619934; x=1795155934;
  h=date:from:to:cc:subject:message-id;
  bh=kBC0b1wkl1B65JvfVkInWMT1p3WdXERkqw/MoPDTkks=;
  b=IMVWb6gS9uif/kHONJ8dJAGi+O33X6coxms6AwZfr/AuIVqR+eR3LIrM
   4luwEncOoYO3DXALN6Xt/p3c9vM7QxDZ4c1gX6MmGITu4U4eo2Ce52XhR
   lDKVT3SCsfVsd9MPfJ6ppWrC7rvzdFsgsEZvZedPtLCa/dC3illcH2Fcl
   4BCOQTcXE9fLsM/C5BtPcJLhzw3E4Tedi89HLpLdA3FxY+Gyb3jOe7xpP
   fDb9SClANq3aY3h66uetvpsyvC0kqxQIap6EUWvgqfEIpJwpPeflMgW4t
   F+/sbKjptsBFX1jOjRdvcxl2E49VkzCv9v4n/soFVOYeEAx9CbUEDAsqY
   Q==;
X-CSE-ConnectionGUID: w27EVn7jTUiRNiSXZ1P2SQ==
X-CSE-MsgGUID: OxXq07h7Q+20s9wvOBkrhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65615245"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65615245"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:25:32 -0800
X-CSE-ConnectionGUID: hdQBCswgSy2UVcAvUUNMSA==
X-CSE-MsgGUID: BVao69LYTGGE2/vVZjZHQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191702076"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Nov 2025 22:25:30 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLy6i-0003fj-1W;
	Thu, 20 Nov 2025 06:25:28 +0000
Date: Thu, 20 Nov 2025 14:24:43 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 fe4d0dea039f2befb93f27569593ec209843b0f5
Message-ID: <202511201433.FGHwio64-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29FB3140009
X-Stat-Signature: eztyiqfox6t61xqectsgexb8d4j8iopo
X-HE-Tag: 1763619932-901191
X-HE-Meta: U2FsdGVkX19sIas41ii2y3HoFmBTlqt8j6JBENEYUWexNUI8u5Uf4JTy0IJFri9yUUBtgP2MbQNhYDcO6mescJbO98AayJsJm3EhggqJG5qv7o5Q9c/7E+A+L6xxl5IDnAvkH6Sv56MbsvfYogGGpKP7JoWjQB6QNkjQaznbyM6J2Rwuoh1SE0oYT7GfdY8SN1v13S8HuVcngcBeqnGN3a80EOpC0qGGV+ayKWyS6cCZ5oPMLWkmexC6wDclSu5jHT8FhfK2ddKh5BwChiBRzVrpp4KYBj0O9pj7GW9uVv1hSc0Ektrg8Q6uHErdBZ5nK5eRuSgSWLHuWwTrYGNsYUxMKzuwlrsm/T027rIn1EAG56/aLe7fVhC/D9pf3LfHm3KYHgHUeDVfj5sWEkTL5Tk2Oi4E2qK4FPzll6xjh78LRauIcUGHo6mzzJZQ1PcJxAZj0/Vh7EwiLXkUymRnO9j/SI+tWzmL36X1PMA4yD9TzJWRyyRuBEqdZYbYL9I4C2L/ppJtpjlm+XIWezBZYPa2KpSEab7qbOulojSFR1pmZN8aPvLZUOOszigV0dXxO6Flxpv6K64U4lrMBSY9cz8/EMWTPXHc92KZu94npNbeXfweaG17///Tg5o5MmGKcpRueOeK1AfZalVv6US2JWRgPmiqq1KVXBU9sPg7APU8XHn50FE+4o3fntGu7qUPbSjHTkWZlvpI8Sdm8QtdrhojbrlErcFPL8e/LKfajuRXs1kioxPXRAjQzVU4x5wGOH41Xduvoc8grbNKTYXkCUnwoKcJRR2aocfWqLOO3MZJQC8kfUsERWsssNLyz8usPgeNN/hUXOx+vAwSuZkmQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fe4d0dea039f2befb93f27569593ec209843b0f5  Add linux-next specific files for 20251119

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202511062036.Ry8Z2APc-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202511200419.SbU6YvjE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511192005.lYSPlgGs-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511192128.aqouWvbT-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511200403.G1aJi4TR-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511200423.3XVoDcKs-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511201428.C3G6i0vq-lkp@intel.com

    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 expecting prototype for ras_core_eeprom_append(). Prototype was for ras_eeprom_append() instead
    Warning: drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_eeprom.c:845 function parameter 'ras_core' not described in 'ras_eeprom_append'
    arm-linux-gnueabi-ld: selftests.c:(.text+0xcb0): undefined reference to `udp4_hwcsum'
    microblaze-linux-ld: net/core/selftests.c:148:(.text+0xb60): undefined reference to `udp4_hwcsum'
    sdca_interrupts.c:(.text+0x1cc): undefined reference to `sdca_fdl_process'
    sdca_interrupts.c:(.text+0xb38): undefined reference to `sdca_fdl_alloc_state'
    selftests.c:(.text+0xa4c): undefined reference to `ip_send_check'

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/um/kernel/um_arch.c:330 linux_main() warn: impossible condition '(task_size > 1024 * (1 << 22)) => (0-4294950912 > 4294967296)'
    drivers/net/ethernet/qlogic/qede/qede_fp.c:964 qede_tpa_cont() error: testing array offset 'i' after use.
    drivers/net/ethernet/qlogic/qede/qede_fp.c:989 qede_tpa_end() error: testing array offset 'i' after use.
    fs/btrfs/raid56.c:1154 get_rbio_vertical_errors() error: we previously assumed 'faila' could be null (see line 1148)
    fs/ext4/move_extent.o: warning: objtool: mext_folio_mkuptodate+0x6c: unreachable instruction
    fs/smb/client/fs_context.c:1839 smb3_fs_context_parse_param() warn: variable dereferenced before check 'fc' (see line 1123)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001-20251120
|   |-- arm-linux-gnueabi-ld:selftests.c:(.text):undefined-reference-to-udp4_hwcsum
|   `-- selftests.c:(.text):undefined-reference-to-ip_send_check
|-- i386-randconfig-141-20251119
|   `-- fs-smb-client-fs_context.c-smb3_fs_context_parse_param()-warn:variable-dereferenced-before-check-fc-(see-line-)
|-- loongarch-randconfig-r071-20251118
|   `-- fs-ext4-move_extent.o:warning:objtool:mext_folio_mkuptodate:unreachable-instruction
|-- loongarch-randconfig-r131-20251119
|   |-- sdca_interrupts.c:(.text):undefined-reference-to-sdca_fdl_alloc_state
|   `-- sdca_interrupts.c:(.text):undefined-reference-to-sdca_fdl_process
|-- m68k-randconfig-r073-20251119
|   `-- fs-btrfs-raid56.c-get_rbio_vertical_errors()-error:we-previously-assumed-faila-could-be-null-(see-line-)
|-- microblaze-randconfig-r111-20251118
|   `-- microblaze-linux-ld:net-core-selftests.c:(.text):undefined-reference-to-udp4_hwcsum
|-- um-randconfig-r073-20251120
|   `-- arch-um-kernel-um_arch.c-linux_main()-warn:impossible-condition-(task_size-(-))-(-)
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-expecting-prototype-for-ras_core_eeprom_append().-Prototype-was-for-ras_eeprom_append()-instead
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-ras-rascore-ras_eeprom.c-function-parameter-ras_core-not-described-in-ras_eeprom_append
`-- xtensa-randconfig-r073-20251119
    |-- drivers-net-ethernet-qlogic-qede-qede_fp.c-qede_tpa_cont()-error:testing-array-offset-i-after-use.
    `-- drivers-net-ethernet-qlogic-qede-qede_fp.c-qede_tpa_end()-error:testing-array-offset-i-after-use.

elapsed time: 1579m

configs tested: 117
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251119    gcc-10.5.0
arc                   randconfig-002-20251119    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                         lpc32xx_defconfig    clang-17
arm                          moxart_defconfig    gcc-15.1.0
arm                   randconfig-001-20251119    gcc-8.5.0
arm                   randconfig-002-20251119    clang-16
arm                   randconfig-003-20251119    clang-22
arm                   randconfig-004-20251119    gcc-13.4.0
arm64                             allnoconfig    gcc-15.1.0
arm64                 randconfig-001-20251119    clang-22
arm64                 randconfig-002-20251119    gcc-8.5.0
arm64                 randconfig-003-20251119    clang-22
arm64                 randconfig-004-20251119    clang-22
csky                              allnoconfig    gcc-15.1.0
csky                  randconfig-001-20251119    gcc-15.1.0
csky                  randconfig-002-20251119    gcc-10.5.0
hexagon                           allnoconfig    clang-22
hexagon               randconfig-001-20251119    clang-22
hexagon               randconfig-002-20251119    clang-22
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20251119    gcc-14
i386        buildonly-randconfig-002-20251119    clang-20
i386        buildonly-randconfig-003-20251119    clang-20
i386        buildonly-randconfig-004-20251119    clang-20
i386        buildonly-randconfig-005-20251119    gcc-14
i386        buildonly-randconfig-006-20251119    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251119    clang-20
i386                  randconfig-002-20251119    clang-20
i386                  randconfig-003-20251119    clang-20
i386                  randconfig-004-20251119    clang-20
i386                  randconfig-005-20251119    clang-20
i386                  randconfig-006-20251119    gcc-14
i386                  randconfig-007-20251119    gcc-14
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251119    clang-22
loongarch             randconfig-002-20251119    gcc-14.3.0
m68k                              allnoconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251119    gcc-11.5.0
nios2                 randconfig-002-20251119    gcc-10.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251119    gcc-8.5.0
parisc                randconfig-002-20251119    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                        fsp2_defconfig    gcc-15.1.0
powerpc                      ppc6xx_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251119    clang-16
powerpc               randconfig-002-20251119    clang-22
powerpc                     redwood_defconfig    clang-22
powerpc                      tqm8xx_defconfig    clang-19
powerpc64             randconfig-001-20251119    clang-19
powerpc64             randconfig-002-20251119    gcc-8.5.0
riscv                             allnoconfig    gcc-15.1.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251119    gcc-15.1.0
riscv                 randconfig-002-20251119    gcc-10.5.0
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20251119    gcc-8.5.0
s390                  randconfig-002-20251119    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251119    gcc-11.5.0
sh                    randconfig-002-20251119    gcc-9.5.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251119    gcc-15.1.0
sparc                 randconfig-002-20251119    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251119    gcc-15.1.0
sparc64               randconfig-002-20251119    clang-22
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251119    clang-16
um                    randconfig-002-20251119    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20251119    gcc-14
x86_64      buildonly-randconfig-002-20251119    gcc-14
x86_64      buildonly-randconfig-003-20251119    clang-20
x86_64      buildonly-randconfig-004-20251119    clang-20
x86_64      buildonly-randconfig-005-20251119    gcc-14
x86_64      buildonly-randconfig-006-20251119    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251119    clang-20
x86_64                randconfig-002-20251119    clang-20
x86_64                randconfig-003-20251119    gcc-14
x86_64                randconfig-004-20251119    gcc-14
x86_64                randconfig-005-20251119    gcc-14
x86_64                randconfig-014-20251119    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20251119    gcc-8.5.0
xtensa                randconfig-002-20251119    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

