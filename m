Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3ECC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 18:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2888E0003; Fri,  8 Aug 2025 14:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA0E8E0001; Fri,  8 Aug 2025 14:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0368E0003; Fri,  8 Aug 2025 14:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0A68E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:02:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4703D1A03EE
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:02:27 +0000 (UTC)
X-FDA: 83754359934.25.85F87FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id C401912000D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:02:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btAJ1Lri;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754676145; a=rsa-sha256;
	cv=none;
	b=V3wTIoMekV8br+4rXZhOisbcBe4rWenqW8HR5IkR113q5Y/0kuETxS+C+XDyvOltYH25s3
	f7k6ch6slypVUGL7VyYZYiMJe4Dk++WBknzDAlnqoDNy4UvLNBxapvb4+3YQcoDghsh184
	telIfocXIGL703/x5AAYacB3APYSseU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btAJ1Lri;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754676145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=15GumnhYZKmEL95mXKPZfb2RwTCShZqOK287H+dVjbc=;
	b=vmhfVS1rHEJiJ/OnFxPYEQE674DpDCDeBYyvpdDb6Ia6NtHp/YsSqmY8NSqHzFA6OJlp0o
	UnB0BpJouhJje9HXegw7Nf9UoPUy5nZtJNERXH5biYChFy34u3oHlVMAc27etiz42OYQWi
	FD0ifxCccP7r2tlyjNoqHL96QNUPqDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754676145; x=1786212145;
  h=date:from:to:cc:subject:message-id;
  bh=i2i1V29pbBOsKXFdRFNdm44uCBAyhqij7LEJHEE9ziY=;
  b=btAJ1LriFPHLedE4fVMALewz98Lb0V+3Wzfx1LtmRoXOk64lBktQc4Hd
   D20YDX+PmyLRm8ikW7yUS2plgIJsTjnqdQnkTDV+q1/iVr+1mCqbZ/X4Z
   PwFNGCL1j5oA50tylvBc6f5pnPxOucNUmpk7r0EntnHqiVZXYMl0A05pe
   a6zpTD6k5SH2Qk8LD+3lHzBRSRPuHBsjMiAXonZ0whKENXn402hYCb+q9
   HPcXiM/m3mioXfamyCw1pd+BexWLFDO27GdxnvLsoc6WDoV95BwGoByOC
   6i2JTPip0TMSJIXKRcl6OkjRCqZUtJS7B6I9iIQrhcE/B9cncrFbKc8fu
   Q==;
X-CSE-ConnectionGUID: mH40a8I7QW6PmxydMcv/FQ==
X-CSE-MsgGUID: ns/oemUTQ2WljqhApQcN+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="56232631"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="56232631"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 11:02:23 -0700
X-CSE-ConnectionGUID: vCGeTJM+TYqi4CeBzLsRBQ==
X-CSE-MsgGUID: 9ZYCIADgRpOmRbgYzB7Zbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="164891423"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 08 Aug 2025 11:02:22 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ukRPy-0004Bc-0J;
	Fri, 08 Aug 2025 18:02:15 +0000
Date: Sat, 09 Aug 2025 02:02:02 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 b1549501188cc9eba732c25b033df7a53ccc341f
Message-ID: <202508090249.aL1V3rye-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C401912000D
X-Stat-Signature: mnn4sj3aesro5hj68np387yj7rj4asis
X-HE-Tag: 1754676144-100283
X-HE-Meta: U2FsdGVkX1/mNb237h+N4Fmf4EowF+knUJS4vN/HWmlFdVOnuhe5nuyiJ5ACnRziGLo9k1e7DvLl7ZTiRoAmrksCGnh3k9kCEr7iEUQvlUQDXwlb/8znRWVl3AG3wE44fPkUYAc1NsKVEb2ei4UIWuMvG6oG/KhAb/27hQ+87Hs5vaKz6D1OYxDTosV+OM84HqGrgjv44XNR5NltkIv8Y0z7JnIGPJs7j4jAMXJ8ivCsxpW4k0nk713obZ5BBhUvg4lm0muh4O3VNwjj8H7Swgjcu2w5oqxJhW3gcNLBtakZBt4B2Q6enGYoxZA3qDKZ+yGI6c9Bgt45pUGQZszincBVkvIuApgYJYhxqE1pzUDIc1/aiVkZ8dL/99HPEefXYs1nSbC14JJZTCrgMcwrOk/nz/XVORTEL5V9Zw4VFIhOG0KlazYci/zts+TwmkZx0tCGHGNOhsY2KWyXUO5XYc5KNoet8wWuM/ae1IZX0m9K9hADNLbJbATf/VC5LEbCtzrmpzoi761zWTtP5zRADt7nEHrnXDJWpAgRqLz17/sNDaubqkeSe6mFVLOpnWI4W/3DJ/WO96jqjfADQdW6WBQobKRau1HrTmkw0nd9xPpOJoFC1h0mFTrVfF8ygrC04N20OmVuGTKONlWjT7bucFUXDcCvWKSSSCaV0Eb/K64fjhdv3MeNYFuTInFmPyRFwu7eX0AFBw74PEsqHy3kvVs2oLrTglab+yXX/bQTOAmEHHiojHRQrwsAaLd0RJs2yh5Bbgq8NYRQUC4I44CZbnDlKSVuGL+Sl6XGM0aBShNw+fACcufrlgM6qygL5ZJ0Bm2ZeSM3aZNvaKX5c4Kro2bVHZ2sDxHAqxtkSTZMID7dMiJnjqAVOmV6HEEDGww/VE7SxMode91Edp7fCt8KZtLNV+3Ye/sSZj0TmxDK49YFhsZxbZkCWA3NqtiEjULWJU5MYwywbShYEqtJpT9
 h9hAf/Jk
 181//B0n/+7orIjBtz8vSd2EDSA7cEb8dI1qkkctkszenO1TmftUKW1H78+IU3VPG7dJDi8uuH87aJIp88gYPayFUgpk5nVUytEKKTaJS5ARhYNg8yKcX/yH6sOP2WC0DLD2g4t3lkENl99pyOJ1X4OigXHpfoGp9aCfoRqFiPkG8Ic2JSx8eWo96lQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: b1549501188cc9eba732c25b033df7a53ccc341f  Add linux-next specific files for 20250808

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202507142044.IrnmDHo3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507180503.nfyD9uRv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507212020.72nw9OIi-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220802.0Iz9U37j-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202507220927.C6zNUJt7-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508010846.fwKbJz68-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202508061925.bEevCphN-lkp@intel.com

    drivers/i3c/master/../internals.h:54:9: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_GPUCC_615
    kismet: WARNING: unmet direct dependencies detected for QCS_GCC_615 when selected by QCS_VIDEOCC_615
    kismet: WARNING: unmet direct dependencies detected for SM_GCC_6350 when selected by SM_VIDEOCC_6350

Unverified Error/Warning (likely false positive, kindly check if interested):

    clang: error: clang frontend command failed with exit code 139 (use -v to see invocation)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r113-20250808
|   `-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|-- arc-randconfig-r133-20250808
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- arm-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_GPUCC_615
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-QCS_GCC_615-when-selected-by-QCS_VIDEOCC_615
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-SM_GCC_6350-when-selected-by-SM_VIDEOCC_6350
|-- arm64-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- csky-randconfig-r131-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-061-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-062-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- i386-randconfig-063-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- loongarch-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   `-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|-- openrisc-randconfig-r111-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- powerpc-randconfig-r112-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- sparc64-randconfig-001-20250808
|   `-- drivers-i3c-master-..-internals.h:error:passing-const-void-to-parameter-of-type-void-discards-qualifiers-Werror-Wincompatible-pointer-types-discards-qualifiers
|-- um-allmodconfig
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- x86_64-randconfig-121-20250808
|   |-- drivers-gpu-drm-sitronix-st7571-i2c.c:sparse:sparse:symbol-st7567_config-was-not-declared.-Should-it-be-static
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
|-- x86_64-randconfig-122-20250808
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
|   |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
|   `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu
`-- x86_64-randconfig-123-20250808
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-char-const-str-got-char-const-noderef-__rcu
    |-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-driver_ptr_-got-char-const-noderef-__rcu
    `-- include-trace-events-dma_fence.h:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-const-timeline_ptr_-got-char-const-noderef-__rcu

elapsed time: 725m

configs tested: 135
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250808    gcc-14.3.0
arc                   randconfig-002-20250808    gcc-12.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   randconfig-001-20250808    gcc-14.3.0
arm                   randconfig-002-20250808    gcc-10.5.0
arm                   randconfig-003-20250808    clang-22
arm                   randconfig-004-20250808    clang-22
arm                         socfpga_defconfig    gcc-15.1.0
arm                        spear3xx_defconfig    clang-17
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250808    clang-20
arm64                 randconfig-002-20250808    gcc-10.5.0
arm64                 randconfig-003-20250808    clang-22
arm64                 randconfig-004-20250808    gcc-8.5.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250808    gcc-15.1.0
csky                  randconfig-002-20250808    gcc-12.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250808    clang-20
hexagon               randconfig-002-20250808    clang-22
i386                             allmodconfig    gcc-12
i386                              allnoconfig    gcc-12
i386                             allyesconfig    gcc-12
i386        buildonly-randconfig-001-20250808    clang-20
i386        buildonly-randconfig-002-20250808    clang-20
i386        buildonly-randconfig-003-20250808    gcc-12
i386        buildonly-randconfig-004-20250808    clang-20
i386        buildonly-randconfig-005-20250808    gcc-12
i386        buildonly-randconfig-006-20250808    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250808    clang-22
loongarch             randconfig-002-20250808    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5249evb_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                         rt305x_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250808    gcc-9.5.0
nios2                 randconfig-002-20250808    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250808    gcc-8.5.0
parisc                randconfig-002-20250808    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                     mpc512x_defconfig    clang-22
powerpc               randconfig-001-20250808    clang-22
powerpc               randconfig-002-20250808    clang-18
powerpc               randconfig-003-20250808    clang-22
powerpc64             randconfig-001-20250808    clang-18
powerpc64             randconfig-002-20250808    clang-22
powerpc64             randconfig-003-20250808    clang-16
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250808    clang-22
riscv                 randconfig-002-20250808    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250808    gcc-10.5.0
s390                  randconfig-002-20250808    gcc-10.5.0
sh                               alldefconfig    gcc-15.1.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250808    gcc-13.4.0
sh                    randconfig-002-20250808    gcc-10.5.0
sh                             sh03_defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250808    gcc-12.5.0
sparc                 randconfig-002-20250808    gcc-8.5.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250808    clang-22
sparc64               randconfig-002-20250808    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-12
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-12
um                    randconfig-001-20250808    gcc-12
um                    randconfig-002-20250808    gcc-12
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250808    clang-20
x86_64      buildonly-randconfig-002-20250808    gcc-12
x86_64      buildonly-randconfig-003-20250808    clang-20
x86_64      buildonly-randconfig-004-20250808    clang-20
x86_64      buildonly-randconfig-005-20250808    gcc-12
x86_64      buildonly-randconfig-006-20250808    clang-20
x86_64                              defconfig    gcc-11
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250808    gcc-9.5.0
xtensa                randconfig-002-20250808    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

