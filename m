Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BE6D29DE6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673F76B0005; Tue, 13 Jan 2026 02:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621A36B0089; Tue, 13 Jan 2026 02:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520996B008A; Tue, 13 Jan 2026 02:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3696B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:47:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFE411401DA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:47:40 +0000 (UTC)
X-FDA: 84326161080.20.395929B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE9DAC0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:47:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oFZInn4I;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768290458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=E+v+VkdDXEX4NU3TK3yzBWPCTEfDcLBD3APVijyaCvk=;
	b=I6PAEGPpUdXDOhcVUmqlU2RnQI0wdWSlzly+XM6wVrfol56IDb1vDjZZlc5s263/jHVYxQ
	A4FJm7frIT5vKWvorVl72FPg1V8+5qKfBD8UEsZyY8DWgb+rFuenjYaTekuf3AGMFC6Foz
	Q2OmxetzqwVWemVaGJXIqZafP+PlFvg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oFZInn4I;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768290458; a=rsa-sha256;
	cv=none;
	b=zFpWvKuQmrjQNZ9WCF9EfDUGb06yaMVCyCnFnUZnnVNqDf9rQl6IOtpeaMhAeY0NHqf5XC
	xKh8bEDRdMWh0tEAxKRyGa+Xrmv+apc6W/rcu7iNUVQv5MqhLfr99clWC1UR58LYsGGvzz
	u26YhBI5eQyay5wnDEKZPZyxcL4NqfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768290458; x=1799826458;
  h=date:from:to:cc:subject:message-id;
  bh=J4PcDyKeentBfEoiQRb2xDPqhx/fOMHrdpLfCypZrKk=;
  b=oFZInn4In1iD9Zjhv3+g4YVeiaLQqF3R7U36Dp6m1kEHJVaJDQwk0d8K
   h9nsSJ/GwK9ujJoOK8JcjJADmxDtXbcaJfhnbW1nP4l00/Rfd6AMeKiRA
   iMtfAFx4epM9u9Bp+ugVvtaqrfjl3t3GrUUYyuZSoXo2OhzRfaeyj8Jtm
   lE+vpT2NgbL2y+o+OW9MWhuvHWPiY+pzTin6V6Qfss2VLURYx7mIwo8Yd
   4TTeeTlSj23HEubuVm+YhVuragv1UQQbiWNvnrZmNLrTHNciLv+ZNVo7X
   11GEP31u/SaHXwmLTyNXXbqRN29SmaXCPbDSG7hVSCsr6DFRM+ak+hNBK
   Q==;
X-CSE-ConnectionGUID: REfMNoiwQ5yuj6miiwLT1Q==
X-CSE-MsgGUID: ZQUtnQfOQoi+sZtqnHSvEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80678673"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80678673"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 23:47:37 -0800
X-CSE-ConnectionGUID: 6XKv94g8SH2vONWghmC/Zw==
X-CSE-MsgGUID: MU/oy78cQguVxJT5ilisXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="235024330"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 12 Jan 2026 23:47:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfZ7j-00000000EOC-0IDk;
	Tue, 13 Jan 2026 07:47:31 +0000
Date: Tue, 13 Jan 2026 15:47:15 +0800
From: kernel test robot <lkp@intel.com>
To: "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 294/303] arch/arm64/kernel/traps.c:1074:2:
 error: call to undeclared function 'kasan_die_unless_recover'; ISO C99 and
 later do not support implicit function declarations
Message-ID: <202601131502.L9EGfMiI-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: AE9DAC0006
X-Stat-Signature: xnyjjhx9o6pkdji9k5kem36kucqeqocr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768290457-213929
X-HE-Meta: U2FsdGVkX1+CUKq4ckjFJIHqr61YMkSW3kbD36W6X6xJAWbG5HwBkEMUkEegzBHNenOIFhHr6GGceaFse7IaqUISwyJ9fgAawfib2SXwxHH+u+deoVGDKbRP6iw73JXUu/Uw/B9C8TO6CLbm6Y17h95jMmS5msU46x6cjg8756UJc9+zXWCGIO4n4sObrhUEQXrAwNPrmL9vjMaThQRqOty/8b1cSrUqfmuOcVWC/n8itE0szJO+VxQyqPKl4n+CQ74vtOKBz5mLIzXdtuIor31LfUAFZhimnmHlgGCHa9+8Zb+V6I74oBAChZLvqUjNRfbBVNVEgWKzczYpHKzzbYSxYeEVjo0k8fsaw0WIgRfjIfS2L1j1fg+EIBdSDED35LoMNB8VSJzT7faHxG4LM0n+bpDcMGfBeScnh5S8/DwmsjQ0UqBsUPhv7UlHYe3PkMFv1l3OMgflTc1UOmBC4qeuaFcD4qV9eiKuzPi4SfTFA9/k6rOZ7cBC8ujE0qZvCF4JHx8Mn8ePZFCy+jhijQjExHRKt9GDupkdWOktY2J1G0MPgQTkOm7JMNL7e40T6px/86MYtERcwjNG/sfP1jhvN0wRIlBAvTvtoTqC25GIvx5E2HEYCx9hjSiuR6GU8mWFDiyFcykdGLYrCQwNBFbyDuzHkukr2Kraha9hWnQX8uwaRjaj2NQcZqj2u1+/oZs8d/r56hTsQyDJc5fQ1FQV7MvdzgYQYBnETteivgFlkS41oXwTt8o8o2yfx3v1hlILlRFQVEZ0i8qkFQKmVaztP0K54GJ9ujMQFI627r6A2Z/g1j/DP+hNgnjBzx1Tl6VvL21rVXpAZ+7Me1RdNDlU9IglFjovl3qPRoqesB7BSo4hZRhMWd1kbopGmjkf/riTyWjNj5SZp0llr98XWNiJ95Ew9Cl61T6EMYv2XWdKJcfRVKwx/dYcTpGZqMxA8yt0BxGD37434GR8BIC
 nt4taaoB
 nXSO1dZ+aFRBFdriREnlq+ra8vU4EU+Mo24MJVS+NYJTcdO4e3EsSJc0S7kYpfXo22A/1GEV75/eB9If5D3xs1FiIktD5Z4fpQgB2ERnKYKO7d525+O4dCSCoVoEG/pFv+rt5cWdct9k7wgheXSjYChELgJqutIcH2Q5lAMYnI8CMdbYEOr3D14K9hT8jJZjBWcX6py5yfxxy0DuJh9RldafAx/sw0rnCGoRjkTHhhNIrlp+XGnaZ+N2uq4vMBDDmZFRyk+D3EzfrcYQw6MGldMBbPLD2WABu6T6lx6XUUOLGasoTtYIPS+Bue60++jX0YGGS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   abb8eb84b7bb668d982e556b2b19f0e3ac42c591
commit: c22668ddeabded18adfebc428e99d20d59bc6d9d [294/303] arm64: unify software tag-based KASAN inline recovery path
config: arm64-randconfig-001-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131502.L9EGfMiI-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601131502.L9EGfMiI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601131502.L9EGfMiI-lkp@intel.com/

All errors (new ones prefixed by >>):

         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:862:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     862 |         [ESR_ELx_EC_DABT_CUR]           = "DABT (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:863:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     863 |         [ESR_ELx_EC_SP_ALIGN]           = "SP Alignment",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:864:23: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     864 |         [ESR_ELx_EC_MOPS]               = "MOPS",
         |                                           ^~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:865:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     865 |         [ESR_ELx_EC_FP_EXC32]           = "FP (AArch32)",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:866:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     866 |         [ESR_ELx_EC_FP_EXC64]           = "FP (AArch64)",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:867:22: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     867 |         [ESR_ELx_EC_GCS]                = "Guarded Control Stack",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:868:25: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     868 |         [ESR_ELx_EC_SERROR]             = "SError",
         |                                           ^~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:869:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     869 |         [ESR_ELx_EC_BREAKPT_LOW]        = "Breakpoint (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:870:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     870 |         [ESR_ELx_EC_BREAKPT_CUR]        = "Breakpoint (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:871:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     871 |         [ESR_ELx_EC_SOFTSTP_LOW]        = "Software Step (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:872:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     872 |         [ESR_ELx_EC_SOFTSTP_CUR]        = "Software Step (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:873:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     873 |         [ESR_ELx_EC_WATCHPT_LOW]        = "Watchpoint (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:874:29: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     874 |         [ESR_ELx_EC_WATCHPT_CUR]        = "Watchpoint (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:875:25: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     875 |         [ESR_ELx_EC_BKPT32]             = "BKPT (AArch32)",
         |                                           ^~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:876:27: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     876 |         [ESR_ELx_EC_VECTOR32]           = "Vector catch (AArch32)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:877:24: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     877 |         [ESR_ELx_EC_BRK64]              = "BRK (AArch64)",
         |                                           ^~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:833:28: note: previous initialization is here
     833 |         [0 ... ESR_ELx_EC_MAX]          = "UNRECOGNIZED EC",
         |                                           ^~~~~~~~~~~~~~~~~
>> arch/arm64/kernel/traps.c:1074:2: error: call to undeclared function 'kasan_die_unless_recover'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1074 |         kasan_die_unless_recover(recover, "Oops - KASAN", regs, esr, die);
         |         ^
   44 warnings and 1 error generated.


vim +/kasan_die_unless_recover +1074 arch/arm64/kernel/traps.c

  1063	
  1064	int kasan_brk_handler(struct pt_regs *regs, unsigned long esr)
  1065	{
  1066		bool recover = esr & KASAN_ESR_RECOVER;
  1067		bool write = esr & KASAN_ESR_WRITE;
  1068		size_t size = KASAN_ESR_SIZE(esr);
  1069		void *addr = (void *)regs->regs[0];
  1070		u64 pc = regs->pc;
  1071	
  1072		kasan_report(addr, size, write, pc);
  1073	
> 1074		kasan_die_unless_recover(recover, "Oops - KASAN", regs, esr, die);
  1075	
  1076		/* If thread survives, skip over the brk instruction and continue: */
  1077		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
  1078		return DBG_HOOK_HANDLED;
  1079	}
  1080	#endif
  1081	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

