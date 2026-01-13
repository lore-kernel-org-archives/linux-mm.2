Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB9CD29DE2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B876B008C; Tue, 13 Jan 2026 03:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9186B0092; Tue, 13 Jan 2026 03:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1C36B0093; Tue, 13 Jan 2026 03:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE2EB6B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:21:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D8AD1AE32
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:21:51 +0000 (UTC)
X-FDA: 84326247222.20.EB06D45
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id BBB2740005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:21:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWpZlhof;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768292509; a=rsa-sha256;
	cv=none;
	b=GZVcnc9oydhM0XlxCDfXR8OtuE8sXrkYlkzPl62XEC98PFFqUWnfgAxnXojoqTijcmxQ+9
	YHvTkSWqJkqmiwBxZuOUnC+8CFj5oGJlLu5sK4qjosNNiJDjodXRwElXBRySJAqqhS509v
	oV6uAjk1lJBkVNcc9S+RMG5KdidcpXQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWpZlhof;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768292509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=kC5vzngpwT0i2aZQgsomu/N4qXTjUfLiH8XqGpnrgac=;
	b=bobYbNBdhk2QAvxFOl3DNDQNIrqqW4QUl/NXai2Cyr/O/fb76JhjwTgXEctIpcyZV1oj8E
	u9M2MvEaGq+QUh6eGdMyOzuAUUF6A0VZFMDcz62DySd3N0ahVNb18HEUv+hcdCUvz0gaUw
	7vFgk6ED61Qxy2cxMYj4LQSOH1ohEOI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768292509; x=1799828509;
  h=date:from:to:cc:subject:message-id;
  bh=4uvy1XaSKV2E+hgAr7Sto8Rn9KBoDfne1dT2yxOQgTM=;
  b=NWpZlhofBcZXpLSbYI6GfeO8xTulWgSTopu++4s/x3w2pOopScK914Po
   EdPQ15PWgyah+rlka3HzewKNbJovZ5o/29OYoA3Nlof+bmvfqv/uJXH+r
   h4Gc7ao/YD266dYGsIJjVLQk/Q0V1vP7BOEP+AMSGkGtxOZcMPteWF63g
   T/QbPEIsXklhok8IMVKS4nLqy/Nj53Is2bMVDonGLRQbnZ+8O8ja07vxl
   LneznTBpUV6WstDUxHwkPMiRLYbJqPnVZbeYqGU8fLWd+J55CIzYAdtzr
   +wwZjvpjS/HWiMiB5+w4QSJiGBDhSFQ4gVaQBVyPvrm7q6iM/4L5O6Xc7
   w==;
X-CSE-ConnectionGUID: mPIcys94RGawbmiYCv3Wtg==
X-CSE-MsgGUID: zyL2lKV1QTWXlHzAMLlWxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69625413"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69625413"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:21:47 -0800
X-CSE-ConnectionGUID: 8cDUmGH/RMW5lM3iU3m11A==
X-CSE-MsgGUID: 9yY0o8T7QSiFwubTI8QS1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="209153904"
Received: from igk-lkp-server01.igk.intel.com (HELO 8581b2e2a62c) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 13 Jan 2026 00:21:45 -0800
Received: from kbuild by 8581b2e2a62c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfZeo-00000000173-2i3Y;
	Tue, 13 Jan 2026 08:21:42 +0000
Date: Tue, 13 Jan 2026 09:21:22 +0100
From: kernel test robot <lkp@intel.com>
To: "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 294/303] arch/arm64/kernel/traps.c:1074:2:
 error: call to undeclared function 'kasan_die_unless_recover'; ISO C99 and
 later do not support implicit function declarations
Message-ID: <202601130951.tiOySRqt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 147poxcztsnnyfsmxznqw7ec6frejbqn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBB2740005
X-HE-Tag: 1768292508-141885
X-HE-Meta: U2FsdGVkX1/jDc9Y4Opvw/grOnqwYH+pe+cCOHmfG1n0YGXQWeHKV/uUIPxMGSaFqWVGKlMml2/4Mv//33itq/Y2Fgq6BhCCXvqiROD7vkYWnE6Z4aS46k5WtinGJsOgcdvg3uU8I+yBolcwQUOT8T5IiePNV4m84G8y0FLxBoRHBk6vd9YPWhJhOOxF+cfjGoNFIj/3j9KkSHVFaGUYR+ZO+fOGeywcKPjJbPd8UJFhAdEFAJ4nGIMHwa72qryR8omjTTes+EyMytvzbL5AQORl/AINOZHu8RFOjYolFt4uObaCW98P2mqhQxARn6xGFOaMCGudgPZRkxyPt1aCzCbiPd0xipXaVGZAMknLnN3sztaQFc7Gof79dGCjJ9tWJrvS+Ju/EUH83jmUQQts2lj0t/uJNSefK4/dk64bmtfebf5ITcdAFm8dc7pmPceUsbwVsj/+vPMnI/qxcgrPL5W2mGcOlRKX3/mwqHhdmxrX0CPcHRCgJrVSBzwGZltE+UGjQL/VGJGOO8TckIH7QMiuuMth8X7nNNQTdzh24m85RvTd2b8iX05MLtZzkYYf46B2Zw/8gimLhxB3Fq9AIejuTBSL5RtxrIxZuPdnMXZoA1xqkIIn4xiu7NYQhD6LgdSDmfbX98WeJsbMSTMX1cW41cqJZShfqcJrjgyNfbgEQCRx819vf6bMX6DKxiKQgGTNsFxqFYn9653qnRbIDimsPc6+MDYKmn/qBkf/7OcVs6kgt08SegFUXJLWBKuQmYsCgKxItw5oiRi1CT//LXTKbuNc538bauvCH1H3VbN/0h2HgXniLjeRYXilTgJOTdeIFQSNGDWQBbTmRNXk3XgXBrLXgmTkySyTEX4dwMagpR+BpYtPCOkwz2dz9W8JM4yUK9liw9zehR1ZsBcNs2ublkRvIp/G5j5BqdxONnUZBrfJSEih6rJ2svw/QNyN/iAgGpLCufvPdF3WeeD
 pxmBbwoj
 vWVHM8SAYtW39kTBRM04WOaB+6ERSW+JuVzd3yCUE9eExbq8w0TZcYhtNhY9/4HLFmdSGpqpQpHtzY0enyK4fB3hS7NuRnasUOFIcN8zs8vLCRA4vxp4NGB8csvA9my3jRnDbSAgImHXTRNrncT3vhsKR6xr647jO2UXOBcQvnR8hoFFclRSqUfyCpRcy3yt1sdHclQ791PtufdyjzXPkvYupkke5XaRXJa2dABNsVVgW5WhKoo0SUVw3tJvmZODQkP42SmSIpaNu4KS6mdOHiRCIykPqqMmhLoCVBJoox3GGkeCWYQApOQ1+H8Vgts3Pn/x5
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
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260113/202601130951.tiOySRqt-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601130951.tiOySRqt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601130951.tiOySRqt-lkp@intel.com/

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

