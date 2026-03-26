Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3CE106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318F26B0005; Thu, 26 Mar 2026 04:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A29A6B0088; Thu, 26 Mar 2026 04:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A316B0089; Thu, 26 Mar 2026 04:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 019C76B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:32:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 915F213BB7A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:15 +0000 (UTC)
X-FDA: 84587547030.22.894D995
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf19.hostedemail.com (Postfix) with ESMTP id 20D221A0012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:32:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vo+MyYxC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=xpnAwO6HvFxnxXufc3mJKXnt2Y6gtSoNcYEHYPB7qqY=;
	b=H9WTCfffTyN7lVctMiJqAxe/ygOdAMq24mpvQ1eEbvdjMAKn4as2IO6O2+ppuBtdaDh6HP
	bpAY4ZYlRUfpuVZ0QSVWCfBUIx4VrjdwFhh6PxIX3Tq0EvPKzVADmlR07s27nQYpRdtlGQ
	MeSC8/P92pkmqltGFW1z7e49xzD7hp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774513933; a=rsa-sha256;
	cv=none;
	b=LnCdD5KwP7G1xljAH2+JouJ5GHRLaEVxGSZh0uXPUuht29p7jJTwBxGfkCDbAuB4oApvyG
	OdVM607cRSCELRh0B9Kr/Wn2euPkvFDzUX3LagYb9UrcuQobAGHMKypBMRXy5suVRUEIgJ
	odBAfv17GReqeCaikj6hbw3BlPdZtto=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vo+MyYxC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774513933; x=1806049933;
  h=date:from:to:cc:subject:message-id;
  bh=Q3scC9iaXATvac+OEupqVlj0gt5E1a0UpnlRQz02+i4=;
  b=Vo+MyYxCH8RFX6QsrvCUvwv3BoQWeLyIubEtQlw94ZxQ1RryiQt1OJJy
   k2AQvvPQorV9a9wdgKQSNz0lGXGoeVBpVftkpxarrPmH+aTttX/0QmC2+
   xAsuqeLi1VhI0T3JvWLshlMRgZXUvUg3pWgFNphVLfO/Lmq1JMUrI0RqX
   ycg+QLAKz1/Zmwm+1m83Uj5sWbIaOXWk3px1lBwCtDhWvHE24NJQq1eWH
   uxi9eidHdYqMnhkMwx3IW3JW2R4McVPMbhUkWBFX5NFDBLegru+Jae0wK
   +czWT6dJBu2NtQ/U1FieUzD/IAWkCKNnp6JSZNnbAr1OypqAigT1/Vgl1
   w==;
X-CSE-ConnectionGUID: EKHG6gTbTW2xfTRFnCJCYA==
X-CSE-MsgGUID: PHwxWcB2S3uvY4uqZWizbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="86643255"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="86643255"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 01:32:12 -0700
X-CSE-ConnectionGUID: VUucEUeiRtCDHa87er4qMQ==
X-CSE-MsgGUID: zoCph+ZkR/6ZOW8IcBfkEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="229872714"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 26 Mar 2026 01:32:10 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5g8N-000000008gV-2pmQ;
	Thu, 26 Mar 2026 08:32:07 +0000
Date: Thu, 26 Mar 2026 16:31:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 66ba480978ce390e631e870b740a3406e3eb6b01
Message-ID: <202603261655.ZWdDAyOb-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 20D221A0012
X-Stat-Signature: pdw7w1n4ey5tmjbwrnjz16f666r8ybyd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774513932-491825
X-HE-Meta: U2FsdGVkX1+1eIBHP/pJ2CXYyx6Jhp1plvN6nLM0prbw1uaJZ0vjNNCskl+DaZupucgJNfYd10Yod6oqrn32v6Cu1H/kPs4oEiiDZ85x2UEZvwqp5t6Mhc9u8cZJxZLYzHs/Rjus2C64NlIftXv1wjlX77OPbc8ignPXUdHm61GYqRqzcfCh3XTQtpPIKgIdFZ7R/EmnUnEUssRQJ34+2f6Kfj4DAnVlLG6K8bwWOWWT4WxhOQPTCbAGidtYLED9Vmyman9KeiUmWOheCYk/OCOn4pArOy6mfrDWZBc8yM7UyRCyFa4ReqwmNzUc6GDupBTmRv3YsujPvYjmctfkXR6QnwdYHZm0ArNv6CDHc5eiu5gRZCrpv7kAqGVXa/P6JmKRdBZ6GtHUaPThv6zZsAQD+FsJ33+qiRwkIcoMI4FGoPd7Tm4QRfpmwuVDupZXcFPVbTvgERnyvlK+xVQ4PKCly5C7lylPirCo0AiIw7r5BdMS2H5j9Gr6Kk8KDogpif+iAqIgL/k3L3dLswj8w0M2Kk9o5KWBTeGmF6Bik4OR5k+MihZwPudpBMxvBx/2pzup4xlIrd5kVHFYgV4TrzNsn1kJ2ncyGAPF6MEp5a4QiKTyzaLKF5KO5HMW/OWfcRRKs2duzPUk4+2iSnW67ZJcW9gGefw/SWh+w46sSrzODRVhmyMfaq37kSTJSmAneKDTa/AjSrZx+n5yudiAxdo7o8zsuyD/4DH4lmwaSL3CQkQoo0pDOhVSjkwLbZWlTxczm8YD/gfLNdDEf9VfgdwYCrpRGlKwarJwB6yfmD5SxFs4sIMpm9tdgHsNXDUTa6rOAANUVDUtkA7N5z59u4R0xQNOfNbyFYxGvMGS5TO1rBdtHgtB/yG7G7GLA2e6QCObShFb/hg/RMFWl0V3tbNO145EOzl/NWQ1F2koJhju9SJB4yBBpvTuJj8rY+S98ttZYuCkCddhlvkKvE6
 G3LKyy+k
 oao1hr3Gw7N4Ru265XnVcBNn2NS00IzP+En5D0ds0GNNLkJ8dXrBRU6kamP8m0Xf40JQvfVlJ2YEa4g4qiIPXtbebMvWM529WVq3U91R69p/+gHf6flfLWWe1YX6rVPvVCzKVFRRDaNeO6ctd+Rc9TerQdYknXWcop83HuJWoGnpzk/zXQutS6HuqlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 66ba480978ce390e631e870b740a3406e3eb6b01  Add linux-next specific files for 20260325

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202603260524.9N9gzJgn-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202603260956.RGX4dhHh-lkp@intel.com

    bmap.c:(.text+0x13b0): undefined reference to `__udivdi3'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/extcon/extcon-ptn5150.c:355 ptn5150_i2c_probe() warn: 'info->role_sw' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- loongarch-randconfig-r123-20260325
|   `-- include-trace-events-dma_fence.h:sparse:sparse:dereference-of-noderef-expression
|-- powerpc64-randconfig-r072-20260326
|   `-- drivers-extcon-extcon-ptn5150.c-ptn5150_i2c_probe()-warn:info-role_sw-is-an-error-pointer-or-valid
|-- riscv-randconfig-r123-20260326
|   |-- drivers-gpu-drm-imagination-pvr_ccb.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|   `-- drivers-gpu-drm-imagination-pvr_queue.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- x86_64-randconfig-121-20260325
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_amdkfd_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
`-- xtensa-randconfig-r054-20260326
    `-- bmap.c:(.text):undefined-reference-to-__udivdi3

elapsed time: 785m

configs tested: 182
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260326    gcc-13.4.0
arc                   randconfig-002-20260326    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                       aspeed_g5_defconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260326    clang-23
arm                   randconfig-002-20260326    gcc-11.5.0
arm                   randconfig-003-20260326    gcc-10.5.0
arm                   randconfig-004-20260326    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260326    clang-19
arm64                 randconfig-002-20260326    clang-23
arm64                 randconfig-003-20260326    gcc-13.4.0
arm64                 randconfig-004-20260326    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260326    gcc-13.4.0
csky                  randconfig-002-20260326    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260326    gcc-14
i386        buildonly-randconfig-002-20260326    clang-20
i386        buildonly-randconfig-003-20260326    gcc-14
i386        buildonly-randconfig-004-20260326    clang-20
i386        buildonly-randconfig-005-20260326    gcc-14
i386        buildonly-randconfig-006-20260326    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260326    clang-20
i386                  randconfig-002-20260326    gcc-14
i386                  randconfig-003-20260326    clang-20
i386                  randconfig-004-20260326    gcc-14
i386                  randconfig-005-20260326    gcc-14
i386                  randconfig-006-20260326    clang-20
i386                  randconfig-007-20260326    clang-20
i386                  randconfig-011-20260326    gcc-14
i386                  randconfig-012-20260326    gcc-14
i386                  randconfig-013-20260326    gcc-14
i386                  randconfig-014-20260326    gcc-14
i386                  randconfig-015-20260326    clang-20
i386                  randconfig-016-20260326    clang-20
i386                  randconfig-017-20260326    clang-20
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
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
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260326    gcc-9.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260326    gcc-12.5.0
parisc                randconfig-002-20260326    gcc-11.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260326    gcc-10.5.0
powerpc               randconfig-002-20260326    clang-19
powerpc64             randconfig-001-20260326    gcc-8.5.0
powerpc64             randconfig-002-20260326    clang-19
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260326    gcc-10.5.0
riscv                 randconfig-002-20260326    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                  randconfig-001-20260326    gcc-13.4.0
s390                  randconfig-002-20260326    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260326    gcc-15.2.0
sh                    randconfig-002-20260326    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260326    gcc-8.5.0
sparc                 randconfig-002-20260326    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260326    clang-23
sparc64               randconfig-002-20260326    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260326    gcc-14
um                    randconfig-002-20260326    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260326    gcc-14
x86_64      buildonly-randconfig-002-20260326    gcc-14
x86_64      buildonly-randconfig-003-20260326    clang-20
x86_64      buildonly-randconfig-004-20260326    clang-20
x86_64      buildonly-randconfig-005-20260326    gcc-14
x86_64      buildonly-randconfig-006-20260326    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260326    gcc-14
x86_64                randconfig-002-20260326    gcc-14
x86_64                randconfig-003-20260326    gcc-14
x86_64                randconfig-004-20260326    gcc-14
x86_64                randconfig-005-20260326    clang-20
x86_64                randconfig-006-20260326    clang-20
x86_64                randconfig-011-20260326    gcc-14
x86_64                randconfig-012-20260326    gcc-14
x86_64                randconfig-013-20260326    gcc-14
x86_64                randconfig-014-20260326    gcc-12
x86_64                randconfig-015-20260326    gcc-14
x86_64                randconfig-016-20260326    gcc-12
x86_64                randconfig-071-20260326    clang-20
x86_64                randconfig-072-20260326    gcc-14
x86_64                randconfig-073-20260326    gcc-14
x86_64                randconfig-074-20260326    gcc-14
x86_64                randconfig-075-20260326    clang-20
x86_64                randconfig-076-20260326    gcc-14
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
xtensa                           allyesconfig    clang-23
xtensa                randconfig-001-20260326    gcc-11.5.0
xtensa                randconfig-002-20260326    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

