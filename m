Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F1DD3567B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 06:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5776B0088; Wed, 28 Jan 2026 01:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A930C6B0089; Wed, 28 Jan 2026 01:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F496B008A; Wed, 28 Jan 2026 01:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 805BD6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:08:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4A591B0861
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:08:24 +0000 (UTC)
X-FDA: 84380342928.22.814766A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id A21A7C0003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:08:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kL20DfIo;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769580502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=RF13WLcdL+aIa/dQbshUzDQr/ZuH3QEgMinnDId4SwE=;
	b=0IpfRbtgziiN5nQihH4zKylN8OM6/olDGQagxxiu+tMPVajDLiA+xQeC60bfRtaPAivX5d
	UHcIXPrY4rMiOpFSmeg2ovRArnedpcyBwB7elT4gezzDwbO1lVq5pPHRr5MJgoEKVx62zu
	+JkWYEnJK6zlzV0qCQulkzOudsG0aUs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kL20DfIo;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769580502; a=rsa-sha256;
	cv=none;
	b=oYywSIUb93ixrcpqJqNnSzhINHkGODGqQxyZrNj8DEaJ+y+utwtpUlyJmj7Cs6jcuhkUNs
	NxyJ2bMv9apoQDHcHXj5Kba74FHnnJ6Igyhfc1HaCenuec3U7RTdRzNmVQKLWkCoTcxUS7
	LPSIdSqzqSRw+QihVd6UzdcISmv9yFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769580502; x=1801116502;
  h=date:from:to:cc:subject:message-id;
  bh=Q5TBIyxj0l3uLuc/PhuON6fKLuuFucT+2K83SU8bRTs=;
  b=kL20DfIojG8dKmIQA8iGtkt2f0ui8KwzQYdCE19yFgSZTpAHh71Jju+L
   n6i0wGaoQF1fKUpsO1AXVXQbHdJh8gF/nM/3Byja+7bpsrMp785rJ/gKl
   FodV1DY4xahIRbBSJge0R4eU8T/vW6J1/tzSy8/yYXnb4unYdfOQ7kqVl
   edZXhq3/fK7wdhcuqFIX0JRZ1KCI9cnf2qYIngLHpVAyyZNbP6hFw6XtD
   oOWaFXZPFhNvgU5va/X3FvEHQH8DHSQsB4y6p+RcZCm3ASFNQlkUWmsEX
   CqEpbWGj1vqbTwFESfQhQNs/z/pWePai+3jJdq47AqNh0v5ytaJ4fjCzQ
   g==;
X-CSE-ConnectionGUID: fViGep4aQDC5Voh1kh8KWg==
X-CSE-MsgGUID: PTgKkWj2SOSPMdnLxK7LaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="88205656"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="88205656"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:08:20 -0800
X-CSE-ConnectionGUID: ZbPBUbyZTFiU3WmT3BQGaQ==
X-CSE-MsgGUID: VFvoi7l4QFCLdupup7CJKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="207315811"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 27 Jan 2026 22:08:18 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkyit-00000000ZMG-44bf;
	Wed, 28 Jan 2026 06:08:15 +0000
Date: Wed, 28 Jan 2026 14:07:57 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 4f938c7d3b25d87b356af4106c2682caf8c835a2
Message-ID: <202601281448.YLU9aTIM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Stat-Signature: tbchikbrhm4rgdkrrnoxn3bo35swpapy
X-Rspam-User: 
X-Rspamd-Queue-Id: A21A7C0003
X-HE-Tag: 1769580501-92341
X-HE-Meta: U2FsdGVkX18ineXzJjd1Hq+2XIGZpzvOECEILFHgsbc4uVcV1rzBNgUwfuyb9pbG3NJ0Xsbz/UnSBH8fnYr7SbpYSVyLWkEnEOcI4chktEvVvwKDNhDTIxLZWy+0UZK9+EyzTe0bEqOqiYNnW+V87eeFwFxtGmXV3YM7z3YYy2i/UHi/LksJR3KX5fanlZz509qv0zPfalxNnvU2SvN5Ed6D6S1mji5qeq2+gQZxj2mffxBUQz/reHYQqefxQHmkKfekwoCqWPhu1GmdJrhMyUKPYHV/FsOzIUwPGBgFVfHhNG3SGsGS6pHEzWWAkd20Dwz8ClhB0grQt9aNf1fbY+8nOTxXn38O+bcY6Fn2tlz9h5/41rcBViOGBFzAUWBZVPOLwbBHCFajTWZp2zh48aoCurn+7An+Uh6s2VEXc5MYcap+SO+4MhQml3q/UaXz/o51PdVS/hGRABP6h+sw+6wx6TU0pWTYyaNx4f2xwMV9783IqYpc4THokNiMvLVJvZCmHTGYqpDsQqlFXoRU9vbuYLRVDw8LvPTskhG0EM346013k75w77VKLLZCeSeY4MSnkjFREASn17ejgs+RbbUa5JoV+pMBK+M9Cs3oGT1ZorBrxLbNErmHarg9BdAfBLvL1MXURTPN5fKOyblWRKNoWyhv5uZWLBfCAKcw+BsxpfFuA32OBTnCRw6c1OP30amj/SrxiUrwz0c+OOPBwBwIp/am4z0TLzI63QdXUc/G9xgAiI3kZpSQN4115PTKtzHlqnkje3Ar3ypAGX42NCShBARxI3GeU3YUi1Sj0z/6H1jqLVQruIicOnG/X/Xd/c15olDXuDkLdRn1Y/hverrMDOj0y8irF/fI9DzBDYoYfzkp6pLhfsUD9zTSzESCr+n8vwijiGgk95G3aLdAE6Wrr4f6wRgFEQUTl4LF3dfvRkeD8QaxuyYU3Hfo4zOKlaee6Gp6KfKAD2Wzax3
 Q7hKm0Wl
 vb0iqt1eHc7zzL36pf7nJaUkbPl27i/XcD3QsX9ZpxySSzIyJDR3ciDHtQdW78dUjO7Kde1qr8wqo8zySFHmykh4ofSdFDLWEuJra27gJXgF9tJ/lIffTJf0eUPbmNTjCwWTEsdtLWVDLkYFU8FzFkvdPq06S73NiN6fXUzLzUzJZ/TyoRA1g/wyJ2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 4f938c7d3b25d87b356af4106c2682caf8c835a2  Add linux-next specific files for 20260127

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild/202601280352.HxU02ziv-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601280742.mvDCU5qE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601281037.5Eik5saE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202601281347.J8rVE0kj-lkp@intel.com

    include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_409' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
    ld: drivers/gpu/drm/bridge/lontium-lt9611uxc.c:448:(.text+0x1cf8eed): undefined reference to `drm_connector_hdmi_audio_plugged_notify'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/iio/adc/ad4062.c:817:1: sparse: sparse: bad integer constant expression
    drivers/iio/adc/nxp-sar-adc.c:1014:1: sparse: sparse: bad integer constant expression
    drivers/pinctrl/microchip/pinctrl-mpfs-iomux0.c:276:1: sparse: sparse: bad integer constant expression
    drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c:735:1: sparse: sparse: bad integer constant expression
    drivers/pinctrl/microchip/pinctrl-pic64gx-gpio2.c:354:1: sparse: sparse: bad integer constant expression
    drivers/platform/wmi/tests/marshalling_kunit.c:449:1: sparse: sparse: bad integer constant expression
    powerpc-linux-ld: drivers/gpu/drm/bridge/lontium-lt9611uxc.c:448:(.text+0xb40): undefined reference to `drm_connector_hdmi_audio_plugged_notify'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-r051-20260128
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(((pos-len-)-)-(pos-)-max_pages)-signedness-error
|-- i386-randconfig-062-20260128
|   `-- drivers-platform-wmi-tests-marshalling_kunit.c:sparse:sparse:bad-integer-constant-expression
|-- openrisc-randconfig-r133-20260128
|   |-- drivers-pinctrl-microchip-pinctrl-mpfs-iomux0.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-pinctrl-microchip-pinctrl-mpfs-mssio.c:sparse:sparse:bad-integer-constant-expression
|   `-- drivers-pinctrl-microchip-pinctrl-pic64gx-gpio2.c:sparse:sparse:bad-integer-constant-expression
|-- parisc-randconfig-r132-20260128
|   `-- drivers-iio-adc-nxp-sar-adc.c:sparse:sparse:bad-integer-constant-expression
|-- powerpc-randconfig-r123-20260127
|   `-- powerpc-linux-ld:drivers-gpu-drm-bridge-lontium-lt9611uxc.c:(.text):undefined-reference-to-drm_connector_hdmi_audio_plugged_notify
|-- powerpc64-randconfig-r132-20260127
|   `-- drivers-iio-adc-ad4062.c:sparse:sparse:bad-integer-constant-expression
`-- x86_64-randconfig-015-20260127
    `-- ld:drivers-gpu-drm-bridge-lontium-lt9611uxc.c:(.text):undefined-reference-to-drm_connector_hdmi_audio_plugged_notify

elapsed time: 727m

configs tested: 225
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     haps_hs_smp_defconfig    clang-22
arc                            hsdk_defconfig    clang-22
arc                   randconfig-001-20260128    gcc-9.5.0
arc                   randconfig-002-20260128    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g4_defconfig    clang-22
arm                         at91_dt_defconfig    clang-22
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260128    gcc-15.2.0
arm                   randconfig-002-20260128    gcc-15.2.0
arm                   randconfig-003-20260128    gcc-8.5.0
arm                   randconfig-004-20260128    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260128    clang-22
arm64                 randconfig-002-20260128    gcc-12.5.0
arm64                 randconfig-003-20260128    gcc-14.3.0
arm64                 randconfig-004-20260128    gcc-13.4.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260128    gcc-15.2.0
csky                  randconfig-002-20260128    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260128    clang-20
hexagon               randconfig-002-20260128    clang-20
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260128    clang-20
i386        buildonly-randconfig-001-20260128    gcc-14
i386        buildonly-randconfig-002-20260128    clang-20
i386        buildonly-randconfig-003-20260128    clang-20
i386        buildonly-randconfig-003-20260128    gcc-14
i386        buildonly-randconfig-004-20260128    clang-20
i386        buildonly-randconfig-005-20260128    clang-20
i386        buildonly-randconfig-005-20260128    gcc-14
i386        buildonly-randconfig-006-20260128    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260128    gcc-14
i386                  randconfig-002-20260128    gcc-14
i386                  randconfig-003-20260128    gcc-14
i386                  randconfig-004-20260128    gcc-14
i386                  randconfig-005-20260128    gcc-14
i386                  randconfig-006-20260128    gcc-14
i386                  randconfig-007-20260128    gcc-14
i386                  randconfig-011-20260128    clang-20
i386                  randconfig-012-20260128    clang-20
i386                  randconfig-012-20260128    gcc-14
i386                  randconfig-013-20260128    clang-20
i386                  randconfig-013-20260128    gcc-14
i386                  randconfig-014-20260128    clang-20
i386                  randconfig-015-20260128    clang-20
i386                  randconfig-016-20260128    clang-20
i386                  randconfig-016-20260128    gcc-14
i386                  randconfig-017-20260128    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260128    clang-22
loongarch             randconfig-002-20260128    clang-20
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                       m5275evb_defconfig    clang-22
m68k                        mvme147_defconfig    gcc-15.2.0
m68k                           virt_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                           xway_defconfig    clang-22
nios2                            allmodconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260128    gcc-8.5.0
nios2                 randconfig-002-20260128    gcc-11.5.0
openrisc                         allmodconfig    clang-22
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
openrisc                  or1klitex_defconfig    clang-22
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260128    gcc-11.5.0
parisc                randconfig-002-20260128    gcc-12.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.2.0
powerpc                      chrp32_defconfig    clang-19
powerpc                     ep8248e_defconfig    gcc-15.2.0
powerpc                 linkstation_defconfig    clang-22
powerpc               randconfig-001-20260128    clang-22
powerpc               randconfig-002-20260128    gcc-8.5.0
powerpc                     tqm8555_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260128    clang-22
powerpc64             randconfig-002-20260128    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260128    gcc-13.4.0
riscv                 randconfig-002-20260128    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260128    gcc-13.4.0
s390                  randconfig-002-20260128    gcc-8.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                        apsh4ad0a_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                               j2_defconfig    gcc-15.2.0
sh                    randconfig-001-20260128    gcc-15.2.0
sh                    randconfig-002-20260128    gcc-15.2.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260128    gcc-8.5.0
sparc                 randconfig-002-20260128    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260128    gcc-12.5.0
sparc64               randconfig-002-20260128    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260128    gcc-12
um                    randconfig-002-20260128    clang-22
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260128    gcc-14
x86_64      buildonly-randconfig-002-20260128    gcc-14
x86_64      buildonly-randconfig-003-20260128    gcc-14
x86_64      buildonly-randconfig-004-20260128    gcc-12
x86_64      buildonly-randconfig-005-20260128    clang-20
x86_64      buildonly-randconfig-006-20260128    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260128    clang-20
x86_64                randconfig-002-20260128    clang-20
x86_64                randconfig-003-20260128    clang-20
x86_64                randconfig-004-20260128    gcc-14
x86_64                randconfig-005-20260128    gcc-13
x86_64                randconfig-006-20260128    gcc-14
x86_64                randconfig-011-20260128    clang-20
x86_64                randconfig-012-20260128    gcc-14
x86_64                randconfig-013-20260128    clang-20
x86_64                randconfig-014-20260128    clang-20
x86_64                randconfig-015-20260128    gcc-14
x86_64                randconfig-016-20260128    clang-20
x86_64                randconfig-071-20260128    clang-20
x86_64                randconfig-072-20260128    clang-20
x86_64                randconfig-073-20260128    gcc-12
x86_64                randconfig-074-20260128    gcc-14
x86_64                randconfig-075-20260128    gcc-14
x86_64                randconfig-076-20260128    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-22
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260128    gcc-8.5.0
xtensa                randconfig-002-20260128    gcc-11.5.0
xtensa                    xip_kc705_defconfig    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

