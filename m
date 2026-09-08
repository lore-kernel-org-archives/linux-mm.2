Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A24ECC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684086B0095; Tue,  8 Sep 2026 14:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E746B0096; Tue,  8 Sep 2026 14:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5876B0098; Tue,  8 Sep 2026 14:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255446B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:02:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B295116070F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:02:35 +0000 (UTC)
X-FDA: 85191365070.20.9E32757
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A4FF12000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:02:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KDm/YmSu";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788890553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hHxuOiNmQKd9ZsoPdxNUKUKvlKHktmFbTTcPeh74dzY=;
	b=Ux3bMq/VT5ERzWLvWB1+Yi+1x5F4QE+nxL9coNvtlUvl/R89fbwGDIG9D8bGp/pHih4VdT
	c3jiAonH8XsE4lUiT/68QZOqFcr3npdz/eVOE0WcO90qu5f4qyi9fXx7ejqgQPonWSCmWV
	6uB+sIGzvaxDelfCbcg8opQ4jo8q+Aw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KDm/YmSu";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788890553;
	b=nSlMUhiojdirU4EjjXXvcPWVj0cyLhhpwZg8ArTRpMpZIE0k5yUBvGRrOEEZ91DGBSYFXh
	IE2CngbXDlFvW4msxglaQyrkECtcwleBjPF4s/92x8LdHJFJG7NUBM1tNsObrqXjk5ccA+
	/VvSEDcIX2TwK57NvHovmKJbSSJrgXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788890554; x=1820426554;
  h=date:from:to:cc:subject:message-id;
  bh=+T3DZDcwtpWqlSK+JVn+FFtqxNTCioyLargi+2xd4aM=;
  b=KDm/YmSuQInC82nMuMENuMluzAZrgEd9RLvoJAqwQW6yWS/z3+zxGVrY
   65cd0B/lTyXOgHn8fjtoz/ikiA9+2fRGmHwIkH03b3y5F1AYTNYNaNHVk
   qz1XWS/QMjANU3imOcbPHVH006NIr1bPEVDUy76ntVf00hCxXB6mKHvFa
   5lqIgNWS0GRaDsHxNVkPwC3gRE8W3O/elBA4fn1siFI9YVwM9PbUFBkIK
   hRACbiU/bKnx0phF++CdttmaICW+18h9nC2igsBW/6JbGE02DXYM2h8jz
   tD1b//60e5pe8o8v96W+GoHqPyTcXWT6MtVQo2DKzr5wDWHxzY4nnoDsm
   g==;
X-CSE-ConnectionGUID: qiv/9CXATF2EnQw0l+/xrg==
X-CSE-MsgGUID: FlyY9GbvRUqoC7HAZmTMJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100461148"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="100461148"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 11:02:33 -0700
X-CSE-ConnectionGUID: K9Ldxc81Q++FbYyJL8bppw==
X-CSE-MsgGUID: aVtdl8bxSCiAcOUBJh2GMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="269732182"
Received: from lkp-server01.sh.intel.com (HELO dc5b8f51e05b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 08 Sep 2026 11:02:31 -0700
Received: from kbuild by dc5b8f51e05b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x409M-000000000c3-2jwF;
	Tue, 08 Sep 2026 18:02:28 +0000
Date: Wed, 09 Sep 2026 02:02:18 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 944a035ecca915ae947905dcfb03f2b9dc6d032c
Message-ID: <202609090213.FTy2twLY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: ytr1bsmope8bpmgwpmh1r6czn5jhhw14
X-Rspamd-Queue-Id: 4A4FF12000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1788890553-528073
X-HE-Meta: U2FsdGVkX18LmHgqnuo/5tU5w0/NqXhu+EmB8WwvOOiXrSH0vI4nCiLpacZ6GHJ8mp/dAggH3ARv7CNsJW0wMel5AdYP5AsWY11C5Sen4mfbUaRnLolQwiSqtWPpHmpkZ8lastfahuASyG0porBlN2NFRbzXGczhzVlip21Bwg8fbnMz/AxCPXulTqo9pSo5LTKdaYyKPVoN5pDBxw0gOLLlgRdQcz8eZgZfvgUGZa0sI2fP27V+dDh+6YhQyYUnH9klNNrR9lsbTqlKGovSefFR+fHbBIz3jidVPfS85KiET1Zg4KSPt08yg9QKKWoKljYsxQOvj4KjKC99uYhCEuyto6UyozsMAc9v3cq7oSJKjjAGmFG8ERPcqWwwG29m4OBL+XB7fA/lcqD+AJ9pr558sMB7ykbshyNe1aAqELh1vtSThj1CpfO2+aUI8+P0axX0CUyf7+MaR16BJkuVVRkA6R0N1H1df+9Ipvut/9Femm3ZKK1o07Xr03n2jxsJRjl6t7iemzAtHZW0iS1tSQ98j0efVMSqII7fbALHWxBLcgdMJYSxqoQh1Rbc41UJKXfKUV73PtWFG44V7DDOIi9463au4b9DfhwJqWES+T6ygfX6ZblJL/9CXx8R0Fz7eZwslDAs+Lba2nfNiIHHZAD8OmxRmZ1Z+tV/ObXnqpZ8pAz6DURzoXJoMoXQ3kgd6VRjaMOupnXChPyYIRqPaqlT+LsiWNKsdicqL+BAr2QXOJRDa4iqOguMa8TFddZRbKbC3KC+wCqQFRM9B9e9DiCycAPiYKkK67ZeymuvsW2AIWo4iRzrjBzXmyWfGypJ0igjEV3nPulMC4CpV6pqlgbPYdszL2o3G/7J/YRlT8I+iSRV8IRU57lU+f89L03RkqXa/4q/2enICkoU629PDbcEyqR2xTmk0I9LceFcoza6Z378wRZ8/+noh+nhIKfKoL1WolKHWeCkmWW3j7C
 q/+PIzSe
 Lfx0LGI8QNPn7DNWLR6hjr3DUL+3maOR/XzaeFtGgeKnOANnQjH6gUNR+h2d7d+bAL0aynR/x6jqJ4qTfT/izl8OhhsANW3zWBe5YL/Eo3YZ1L0Z7RnMuAs0sJR6z1k72/5fUsci9UYiQ9rTdLYmlE+UsPfgS6KkX+PLMntKKtJqUWHe2pufltzhgr54vsXL/Bzalb3flquLRsRM73P01zHTUA9V8m9cPMXbf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 944a035ecca915ae947905dcfb03f2b9dc6d032c  Add linux-next specific files for 20260907

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609080812.PANyfUFq-lkp@intel.com

    drivers/bluetooth/btintel_pcie.c:776:13: warning: variable 'i' set but not used [-Wunused-but-set-variable]
    samples/rpmsg/rpmsg_client_sample.c:68:39: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'ssize_t' {aka 'int'} [-Wformat=]
    samples/rpmsg/rpmsg_client_sample.c:68:59: warning: format specifies type 'long' but the argument has type 'ssize_t' (aka 'int') [-Wformat]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609081528.N9VrC0I3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609081618.41PJOZvZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609081933.K4tVJnyh-lkp@intel.com

    (.head.text+0x0): relocation truncated to fit: R_MIPS_26 against `kernel_entry'
    (.ref.text+0xd8): relocation truncated to fit: R_MIPS_26 against `start_secondary'
    drivers/net/dsa/motorcomm/chip.c:1792 yt921x_acl_rule_ext_parse_flow_entries() warn: missing unwind goto?
    mm/hugetlb.c:3086 alloc_hugetlb_folio() warn: mixing irq and irqsave
    sound/soc/codecs/nau8360-dsp.c:214 nau8360_message_to_dsp() warn: missing error code? 'ret'
    sound/soc/codecs/nau8360.c:2203 nau8360_alloc_defaults() warn: potentially one past the end of array 'dyn_defaults[idx]'
    super.c:(.text.exfat_set_vol_flags.isra.0+0x104): undefined reference to `__udivdi3'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- arc-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- arm-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- arm-randconfig-r071-20260908
|   |-- drivers-net-dsa-motorcomm-chip.c-yt921x_acl_rule_ext_parse_flow_entries()-warn:missing-unwind-goto
|   |-- sound-soc-codecs-nau8360-dsp.c-nau8360_message_to_dsp()-warn:missing-error-code-ret
|   `-- sound-soc-codecs-nau8360.c-nau8360_alloc_defaults()-warn:potentially-one-past-the-end-of-array-dyn_defaults-idx
|-- arm64-allmodconfig
|   `-- drivers-bluetooth-btintel_pcie.c:warning:variable-i-set-but-not-used
|-- csky-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- hexagon-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-specifies-type-long-but-the-argument-has-type-ssize_t-(aka-int-)
|-- i386-randconfig-063-20260907
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-specifies-type-long-but-the-argument-has-type-ssize_t-(aka-int-)
|-- loongarch-allmodconfig
|   `-- drivers-bluetooth-btintel_pcie.c:warning:variable-i-set-but-not-used
|-- m68k-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- m68k-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- microblaze-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- mips-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   |-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|   `-- super.c:(.text.exfat_set_vol_flags):undefined-reference-to-__udivdi3
|-- nios2-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- openrisc-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- parisc-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- parisc-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- riscv-allmodconfig
|   `-- drivers-bluetooth-btintel_pcie.c:warning:variable-i-set-but-not-used
|-- riscv-allyesconfig
|   `-- drivers-bluetooth-btintel_pcie.c:warning:variable-i-set-but-not-used
|-- sh-allmodconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- sh-allyesconfig
|   `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int
|-- x86_64-randconfig-121-20260907
|   `-- drivers-bluetooth-btintel_pcie.c:warning:variable-i-set-but-not-used
|-- x86_64-randconfig-161-20260908
|   `-- mm-hugetlb.c-alloc_hugetlb_folio()-warn:mixing-irq-and-irqsave
`-- xtensa-allyesconfig
    `-- samples-rpmsg-rpmsg_client_sample.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-ssize_t-aka-int

elapsed time: 1607m

configs tested: 84
configs skipped: 2

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

