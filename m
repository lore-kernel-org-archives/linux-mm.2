Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84A0CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 02:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C366B02E8; Fri,  8 May 2026 22:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CBF6B02E9; Fri,  8 May 2026 22:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A9D6B02EA; Fri,  8 May 2026 22:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4DF66B02E8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:10:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 703A31C0390
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:10:49 +0000 (UTC)
X-FDA: 84746253018.05.1FAF47D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF0598000A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:10:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jBBtPe+O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778292647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sZzlyFy1Pwxjq6LWdUoyKdzG1UgXwLPhu7DYLofN4Xg=;
	b=YrAHQctIyBd8m12IvSBdprXrk3UoZOg1FhBvnlGY0Ec9Gn+JPuamflICt0D71C8UxOeyPq
	NjiEdLtoF3PjNb9XQ/KbwmNqE4yux+EkMiToXUidT0dovCx9ihQ4BvNELjhS2DXfWRNPke
	mA91jdWNWEQQAsX1hWvTVogy6nwlQdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778292647; a=rsa-sha256;
	cv=none;
	b=NKkXRCNNA/H2e7T32SWU6c4F5HlGSKgyd55V04AsI9X5RjABDLPwBFsle5Bs5xEAeHqfFm
	JPW9vDocvhkTGtkohuLecSBNAbv6Mvmowcgnoyv9/eyVVLoUZyVx/4FE2bx/DO2ISHJnoO
	h0jwz1adP9YijO4JLBt77tbiEf0aDYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jBBtPe+O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778292647; x=1809828647;
  h=date:from:to:cc:subject:message-id;
  bh=wbYbuwrn9witqYITwu6kRF15cmujvz+p9DQMEjVtaO8=;
  b=jBBtPe+O4odtff4COWjLfD50689LkG5+1CyhbbPT5SK9QimV9kHYX6uu
   AT5gtlCJb+pWmEg1Xnfea4ZCqDJztjSiTtgnjNS1j2yei0i0q0lgUSAio
   pQhIn4l5dQ/+z2NksgFQ9cp3oQy2khyyi1lLJAibj1TN/ENz73/1smD0v
   owqS0NHm+VsAXmHhjbjMoh9oJypf5M7gZ10bUYGRzKCqU0Sm0Is+v/mAw
   v9bfQ3f3jS2qv1tBcfTkk1U0m3K3Z3AYsxpQYVADwlklWA1r3NU3N7IkB
   JurIivp+/wnNzIjm8weuqN+5myOt2robHVLkXBW1/ci8Ke00CuCDyufmu
   g==;
X-CSE-ConnectionGUID: ngTE1YCqSu+3mMETEvQdvw==
X-CSE-MsgGUID: 5R55LpETRE2c4zA9loWRkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79308817"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="79308817"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 19:10:43 -0700
X-CSE-ConnectionGUID: cOUbxKZqTTStteJTQ8KkQg==
X-CSE-MsgGUID: P1mnSAKDQPezqyesRpaWXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="230526642"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 08 May 2026 19:10:42 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLX9L-000000000aj-36Cg;
	Sat, 09 May 2026 02:10:39 +0000
Date: Sat, 09 May 2026 10:09:54 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Thierry Reding <treding@nvidia.com>
Subject: [linux-next:master] BUILD REGRESSION
 e98d21c170b01ddef366f023bbfcf6b31509fa83
Message-ID: <202605091044.Eis9oRvR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: DF0598000A
X-Rspamd-Server: rspam04
X-Stat-Signature: eqe33dbrk7zr3uefeh4jhzyxx1nhxa1w
X-HE-Tag: 1778292646-67456
X-HE-Meta: U2FsdGVkX18spgq/2HR8hKW0ZkGjiseuc0m9MiDlrlFdQPCWBsacQ9RZ/sCmYojKk9SKOZ7EmRLkfPbrmzD4OZKSiRNv8AgatJIKsddMWiAkrjzVydIeubUkBe9yDTsFrIKC8hFpdFl4tPVw3GMmynOnPZ6f1lFI0/Pn/XtSFC60DXn+hZlNUixRlSNul6UqeWf7cpz2SHuW85VKxpXbFchORttxbzWIebNGTjSfn38ki1Mvbb3TUBwcP7Cf/m5AW6t8va0vSIKWBWZc//8cUHn8M/ZiarsAD7OytHVjs+60gOT7/rp1c6YFb8WqHzq2FRE9nob4vLU4mWQhPktAYGC9Fc3nKPdMeIcZHK88K54sogmZpznuvmtSzZZ+jJAEcR0O+fbCwHu7QhrqrKwILv7wLGBXLLHRlFOAYzmhjjQRQvLkL/yclTsER7cUh/h1TxN7lzcskzcBWwGFmDUWU0Z/Rv818j6WQVJRYnly9c+srw7rgI2ZS09ui8yaHBYmtVYEsqaol95bdhhwSt9ZnD1CHit4fT3qx7QrGf0xJt89yfZA5+1Sl2d/sxkPcsVf29MfMhXFk2pbaB1WVLUdWEsIsf+neviPM9DYhsyD904fwkksdkpnpXvIF4yeeJYefm3DS6Eoam2MI8sicyM97m4Qymtz1Vft/JfzyyqzgKpb1aSb2jqtkVgJPvoK50EWSkg9B5m0s/WKQ4YAn2rPopRYxHKMjQgkqTJ7+XL8X7ujzr1duvKWOeBNMu9ADIfY7pG4vX8qqpV2bTpYV3naVT992y7ggdjUSe/Sv+GfkF4dKJYjrJB+q0jNk0c0lC6np52ck6wR+OV5OpX2dcwjIoHio9K/Xw9Q6L37jQ9+ChAwMG1gagS7PUQrZ8iUpsOpDVycENynhXuYFVPQGFjcdv8+r2MxryW4nw2CJZh7wJRWte5OBg425vhugYEpTVeFady9xPd2FIzTT3lPmaF
 1YiIv/Y5
 5mO7/0UGJpvC7XcZoSAAD5+iZrMPdFLzGgVS4jYkDDBhZ+KUTnpUXiP/kZ+UrIbjhd4GzGLKH9duuvtvMupBDmeVcuc7bdZFUs+vheUVypHbsXL/3C80hxC4hZrTVD8OpuJYTXFtplHYKLhxAJS2HqhAvjaffjzM4Pmz9Es72Q/CCrmY+QQXdYocCvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e98d21c170b01ddef366f023bbfcf6b31509fa83  Add linux-next specific files for 20260508

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605090449.Iz3ZmNRQ-lkp@intel.com

    /usr/lib/gcc/i686-linux-gnu/14/../../../../i686-linux-gnu/bin/ld: se_ctrl.c:(.text+0x444): undefined reference to `mbox_free_channel'
    ele_common.c:(.text+0x12b): undefined reference to `mbox_send_message'
    ele_common.c:(.text+0x51c): undefined reference to `mbox_send_message'
    se_ctrl.c:(.text+0x2c0): undefined reference to `mbox_free_channel'
    se_ctrl.c:(.text+0x3d8): undefined reference to `mbox_request_channel_byname'
    se_ctrl.c:(.text+0x681): undefined reference to `mbox_free_channel'
    se_ctrl.c:(.text+0xb00): undefined reference to `mbox_request_channel_byname'

Unverified Error/Warning (likely false positive, kindly check if interested):

    ERROR: modpost: "__sync_fetch_and_add_8" [kernel/trace/preemptirq_delay_test.ko] undefined!
    ERROR: modpost: "__sync_fetch_and_add_8" [kernel/trace/synth_event_gen_test.ko] undefined!
    tegra210_mixer.c:(.text.tegra210_mixer_configure_gain+0x364): undefined reference to `__aeabi_uldivmod'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-allyesconfig
|   `-- tegra210_mixer.c:(.text.tegra210_mixer_configure_gain):undefined-reference-to-__aeabi_uldivmod
|-- parisc-randconfig-002-20260509
|   |-- ERROR:__sync_fetch_and_add_8-kernel-trace-preemptirq_delay_test.ko-undefined
|   `-- ERROR:__sync_fetch_and_add_8-kernel-trace-synth_event_gen_test.ko-undefined
|-- um-randconfig-r051-20260508
|   |-- ele_common.c:(.text):undefined-reference-to-mbox_send_message
|   |-- se_ctrl.c:(.text):undefined-reference-to-mbox_free_channel
|   |-- se_ctrl.c:(.text):undefined-reference-to-mbox_request_channel_byname
|   `-- usr-lib-gcc-i686-linux-gnu-..-..-..-..-i686-linux-gnu-bin-ld:se_ctrl.c:(.text):undefined-reference-to-mbox_free_channel
`-- xtensa-randconfig-001-20260509
    |-- ele_common.c:(.text):undefined-reference-to-mbox_send_message
    |-- se_ctrl.c:(.text):undefined-reference-to-mbox_free_channel
    `-- se_ctrl.c:(.text):undefined-reference-to-mbox_request_channel_byname

elapsed time: 724m

configs tested: 182
configs skipped: 11

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260509    gcc-9.5.0
arc                   randconfig-002-20260509    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260509    gcc-9.5.0
arm                   randconfig-002-20260509    gcc-9.5.0
arm                   randconfig-003-20260509    gcc-9.5.0
arm                   randconfig-004-20260509    gcc-9.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260509    clang-16
arm64                 randconfig-002-20260509    clang-16
arm64                 randconfig-003-20260509    gcc-15.2.0
arm64                 randconfig-004-20260509    clang-17
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260509    gcc-12.5.0
csky                  randconfig-002-20260509    gcc-10.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260509    clang-23
hexagon               randconfig-002-20260509    clang-17
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260509    gcc-14
i386        buildonly-randconfig-002-20260509    gcc-14
i386        buildonly-randconfig-003-20260509    gcc-14
i386        buildonly-randconfig-004-20260509    gcc-14
i386        buildonly-randconfig-005-20260509    gcc-14
i386        buildonly-randconfig-006-20260509    gcc-14
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260509    clang-20
i386                  randconfig-002-20260509    clang-20
i386                  randconfig-003-20260509    clang-20
i386                  randconfig-004-20260509    clang-20
i386                  randconfig-005-20260509    clang-20
i386                  randconfig-006-20260509    clang-20
i386                  randconfig-007-20260509    clang-20
i386                  randconfig-011-20260509    gcc-14
i386                  randconfig-012-20260509    gcc-14
i386                  randconfig-013-20260509    gcc-14
i386                  randconfig-014-20260509    gcc-14
i386                  randconfig-015-20260509    gcc-14
i386                  randconfig-016-20260509    gcc-14
i386                  randconfig-017-20260509    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260509    gcc-15.2.0
loongarch             randconfig-002-20260509    clang-18
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
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260509    gcc-11.5.0
nios2                 randconfig-002-20260509    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260509    gcc-11.5.0
parisc                randconfig-002-20260509    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260509    gcc-12.5.0
powerpc               randconfig-002-20260509    clang-23
powerpc64             randconfig-001-20260509    gcc-8.5.0
powerpc64             randconfig-002-20260509    clang-23
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260509    clang-23
riscv                 randconfig-002-20260509    clang-18
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260509    gcc-8.5.0
s390                  randconfig-002-20260509    gcc-11.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                        apsh4ad0a_defconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260509    gcc-12.5.0
sh                    randconfig-002-20260509    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260509    clang-23
sparc                 randconfig-002-20260509    clang-23
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260509    clang-23
sparc64               randconfig-002-20260509    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260509    clang-23
um                    randconfig-002-20260509    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    gcc-12
x86_64      buildonly-randconfig-001-20260508    gcc-14
x86_64      buildonly-randconfig-001-20260509    clang-20
x86_64               buildonly-randconfig-002    clang-20
x86_64      buildonly-randconfig-002-20260508    clang-20
x86_64      buildonly-randconfig-002-20260509    clang-20
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260508    gcc-14
x86_64      buildonly-randconfig-003-20260509    clang-20
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260508    clang-20
x86_64      buildonly-randconfig-004-20260509    clang-20
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260508    gcc-14
x86_64      buildonly-randconfig-005-20260509    clang-20
x86_64               buildonly-randconfig-006    clang-20
x86_64      buildonly-randconfig-006-20260508    clang-20
x86_64      buildonly-randconfig-006-20260509    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-011-20260508    gcc-14
x86_64                randconfig-012-20260508    clang-20
x86_64                randconfig-013-20260508    gcc-14
x86_64                randconfig-014-20260508    gcc-14
x86_64                randconfig-015-20260508    gcc-14
x86_64                randconfig-016-20260508    gcc-14
x86_64                randconfig-071-20260509    gcc-14
x86_64                randconfig-072-20260509    gcc-14
x86_64                randconfig-073-20260509    clang-20
x86_64                randconfig-074-20260509    clang-20
x86_64                randconfig-075-20260509    clang-20
x86_64                randconfig-076-20260509    clang-20
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260509    clang-23
xtensa                randconfig-002-20260509    clang-23

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

