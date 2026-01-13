Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA753D2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BF8D6B0005; Tue, 13 Jan 2026 13:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242B66B0089; Tue, 13 Jan 2026 13:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117516B008A; Tue, 13 Jan 2026 13:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED9EC6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:42:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A5DEB6FAD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:42:43 +0000 (UTC)
X-FDA: 84327811806.01.C69821B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BFDA40016
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:42:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G1L3sJ7V;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768329761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Ic7NOksOwkwzwNdzR+Wx0flh5qOxJC1coTlnwd/zzLk=;
	b=pCZC+jPQxZIY/69SNoaobF/xc1euEGyxlFhvTtrGDL7tvIRatf+GUA23Nt5bQY7Cojevbu
	dJPbeuwAGaKuxQ9GvA+EqsnJ2QP1XZz85uNjgrZ8bUvnBn0Ye1dtW2M4H9QTtgHfDZYj5U
	r3+BEojcsvTOlYZi4mjsnFEUFgbssMc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G1L3sJ7V;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768329761; a=rsa-sha256;
	cv=none;
	b=uXhe5fdFsJakBF8ILriYTerwHvOEeoNt3mV/cbQ4XA9+YF67M0oeoheY9RCOPngoXH6ZdM
	bxAPB8Ryuw3kS2BjTKqmdW4CrbfvdAWX5aZxzKFuvGq98AIa2XpUa3hUohm2S9+4W9NEjy
	WoMGgqv0hZ7XuZT+YhSyCx7/ZNb9iKg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768329761; x=1799865761;
  h=date:from:to:cc:subject:message-id;
  bh=Ik4g6mLqrHkdwQaEMqp7TcPt1uoS3L+6/ZTow13x/XI=;
  b=G1L3sJ7VKZLKoNG2HrRb4mhi9VGEd1GPPXe/6JFg/wVONb1gd5rEVJs4
   xm/tZaLT+MFp82A4nSrbSJvdaTKl7vRn4bcbQbCC8cIjBjUT/axHyjaaH
   eu2sKXEVsj5t5r9qX/Iq0aHc+Kz5/CBrVc1kYG/t0jVDz6Zty21H0+9mS
   AJwCUyBMHsY5buiuPXbAGSKZ4raEPEcDFogPI5eBvh5Edkke1tIUkYi0i
   z0xvmLzrPunDkTb9Q0ryG1JdzgCkToOk+RrDjIiqSonXlXuEeLnG1WMyl
   Cr6We8UgFV93jCBUAJnNy/C4c4FQnnUjX7UuIFzokfQH+Hi9RB3JfdAFZ
   Q==;
X-CSE-ConnectionGUID: PzZL7/wqQi2HtL+uGCgKoQ==
X-CSE-MsgGUID: ehCqJNZLTeGhna72GOotQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73466304"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="73466304"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 10:42:40 -0800
X-CSE-ConnectionGUID: tHzGxifzStaVa5ZgEQM8bw==
X-CSE-MsgGUID: x1GuZZMCQ4ytUc4Tu8H4Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="203596451"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 13 Jan 2026 10:42:37 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfjLe-00000000FEu-3vnx;
	Tue, 13 Jan 2026 18:42:34 +0000
Date: Wed, 14 Jan 2026 02:41:53 +0800
From: kernel test robot <lkp@intel.com>
To: "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 294/303] arch/arm64/kernel/traps.c:1074:9:
 error: implicit declaration of function 'kasan_die_unless_recover'
Message-ID: <202601140248.D9Oj5lCh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 0BFDA40016
X-Stat-Signature: ca38pnf4367ojainswimf9gndjopkd9s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768329760-350502
X-HE-Meta: U2FsdGVkX1+EmsFhED3JSGRCMP6jPDivcQes+qnPb5dDuKZ039YecDmvody1NfmYqOqN1z/tzV4oTCY0fnx0ZTSRmmaak9o9yQH8I/geXfaW5EBiMG0IrEfuin+l6WbZ8PyVqcar95OSWe17GSXoRfljkK0FpsqidRhmeUp8gV+DAW2Wga1AasxPQmL15mqkaS+jpu3RC23Mt5Wx+UvD677q/5x+Obhfl3X3XSBKFaBPe35r9BAge1ixZeZU5zW2LPuafAWjaZqyrAg7Dd/h6ztG3QEqxh5E7hxRM4fdnHRMs0tzgkEnNOrMWTWCQVMth81LxI//6SjmMCFsLgriFKfivEBRKIq9UKN2u8ay7hDLsLlRfvrzYvCWfOCIcOUPeIRas9g3d9VtxClzeT8kW0r5m1DoNORKXAlw3O/qg6hx8lEEZWnEbVYfMVS+Czxy3Oqsm+xwpjkjZTLcu2UDUXeyXFG7UI7K9LQPWx81dDXlz+Tt6LOtoa/9/3q+KtPjFTTaoPokRVrP5inhaWBmKhxyzL/b5i0RGN2XmHxfyPV6D9ESgy7okszoIUTCsUceFo3HsqVezirDyUZDR8uyJtklwIJzx4jASo1NqHa1bFyJ/qj61z2dXEEmcHUihVE5dn0ctj5mYe21OYI+80T3a7F9rc6obHt9RxZuF880GCsAkvOnaSgrroL325jrWT4Ow1DfKpf9Men7/KRkqaOGDdxqPiBvMXzVRRUCkaDRBABKrv1AUa6DAVEtp8eogGpX/IcmW7l86F7wNxZybepnSiZLJGqC+QXtqLkzL1583slc/kI4BA3Buqj9LQLDXuvM/b1D2de7lnC1g3iHEhkV85ogiS3hz9D1NypEjSxBjDxsvhJv0QWv6CPppTixncf4OigVMobzg7ikk3njLHQsvIc1PhAFOSjEDBnAZCRkTfWltyK29kFf0zJJ/6P3BAaqvlzrvBBUJ6IhksFp7+r
 ZpSqS6Yh
 8lAeLNE+wVDY04LqoZ/yY6/GBiqkqRS0dAb+p3fciP4eNabDMt5h+60SXinXjzO814PV3hi2ZVWa3P0/LUs7VAjT1VR3cWU/8EoHt6TbgOaP2OlurQ5MBXL63xwfznpvihip+YxPM335coJRqGMjdwJi7o8wrjLxHxr99V/An6RV1hvL19coGvIO/W2ChGIkyiFZwFkq+mwMnYEi9JlhIP9ulYYdFu84BsyBoOyUGQzi+XLeHs2YQAvNt/X5si9as1gf/MDfnXYOKA3cz6iS6U5xES75pTsu5yyxT
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
config: arm64-randconfig-r064-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140248.D9Oj5lCh-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140248.D9Oj5lCh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601140248.D9Oj5lCh-lkp@intel.com/

All errors (new ones prefixed by >>):

     853 |         [ESR_ELx_EC_SVE]                = "SVE",
         |                                           ^~~~~
   arch/arm64/kernel/traps.c:853:43: note: (near initialization for 'esr_class_str[25]')
   arch/arm64/kernel/traps.c:854:43: warning: initialized field overwritten [-Woverride-init]
     854 |         [ESR_ELx_EC_ERET]               = "ERET/ERETAA/ERETAB",
         |                                           ^~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:854:43: note: (near initialization for 'esr_class_str[26]')
   arch/arm64/kernel/traps.c:855:43: warning: initialized field overwritten [-Woverride-init]
     855 |         [ESR_ELx_EC_FPAC]               = "FPAC",
         |                                           ^~~~~~
   arch/arm64/kernel/traps.c:855:43: note: (near initialization for 'esr_class_str[28]')
   arch/arm64/kernel/traps.c:856:43: warning: initialized field overwritten [-Woverride-init]
     856 |         [ESR_ELx_EC_SME]                = "SME",
         |                                           ^~~~~
   arch/arm64/kernel/traps.c:856:43: note: (near initialization for 'esr_class_str[29]')
   arch/arm64/kernel/traps.c:857:43: warning: initialized field overwritten [-Woverride-init]
     857 |         [ESR_ELx_EC_IMP_DEF]            = "EL3 IMP DEF",
         |                                           ^~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:857:43: note: (near initialization for 'esr_class_str[31]')
   arch/arm64/kernel/traps.c:858:43: warning: initialized field overwritten [-Woverride-init]
     858 |         [ESR_ELx_EC_IABT_LOW]           = "IABT (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:858:43: note: (near initialization for 'esr_class_str[32]')
   arch/arm64/kernel/traps.c:859:43: warning: initialized field overwritten [-Woverride-init]
     859 |         [ESR_ELx_EC_IABT_CUR]           = "IABT (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:859:43: note: (near initialization for 'esr_class_str[33]')
   arch/arm64/kernel/traps.c:860:43: warning: initialized field overwritten [-Woverride-init]
     860 |         [ESR_ELx_EC_PC_ALIGN]           = "PC Alignment",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:860:43: note: (near initialization for 'esr_class_str[34]')
   arch/arm64/kernel/traps.c:861:43: warning: initialized field overwritten [-Woverride-init]
     861 |         [ESR_ELx_EC_DABT_LOW]           = "DABT (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:861:43: note: (near initialization for 'esr_class_str[36]')
   arch/arm64/kernel/traps.c:862:43: warning: initialized field overwritten [-Woverride-init]
     862 |         [ESR_ELx_EC_DABT_CUR]           = "DABT (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:862:43: note: (near initialization for 'esr_class_str[37]')
   arch/arm64/kernel/traps.c:863:43: warning: initialized field overwritten [-Woverride-init]
     863 |         [ESR_ELx_EC_SP_ALIGN]           = "SP Alignment",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:863:43: note: (near initialization for 'esr_class_str[38]')
   arch/arm64/kernel/traps.c:864:43: warning: initialized field overwritten [-Woverride-init]
     864 |         [ESR_ELx_EC_MOPS]               = "MOPS",
         |                                           ^~~~~~
   arch/arm64/kernel/traps.c:864:43: note: (near initialization for 'esr_class_str[39]')
   arch/arm64/kernel/traps.c:865:43: warning: initialized field overwritten [-Woverride-init]
     865 |         [ESR_ELx_EC_FP_EXC32]           = "FP (AArch32)",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:865:43: note: (near initialization for 'esr_class_str[40]')
   arch/arm64/kernel/traps.c:866:43: warning: initialized field overwritten [-Woverride-init]
     866 |         [ESR_ELx_EC_FP_EXC64]           = "FP (AArch64)",
         |                                           ^~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:866:43: note: (near initialization for 'esr_class_str[44]')
   arch/arm64/kernel/traps.c:867:43: warning: initialized field overwritten [-Woverride-init]
     867 |         [ESR_ELx_EC_GCS]                = "Guarded Control Stack",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:867:43: note: (near initialization for 'esr_class_str[45]')
   arch/arm64/kernel/traps.c:868:43: warning: initialized field overwritten [-Woverride-init]
     868 |         [ESR_ELx_EC_SERROR]             = "SError",
         |                                           ^~~~~~~~
   arch/arm64/kernel/traps.c:868:43: note: (near initialization for 'esr_class_str[47]')
   arch/arm64/kernel/traps.c:869:43: warning: initialized field overwritten [-Woverride-init]
     869 |         [ESR_ELx_EC_BREAKPT_LOW]        = "Breakpoint (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:869:43: note: (near initialization for 'esr_class_str[48]')
   arch/arm64/kernel/traps.c:870:43: warning: initialized field overwritten [-Woverride-init]
     870 |         [ESR_ELx_EC_BREAKPT_CUR]        = "Breakpoint (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:870:43: note: (near initialization for 'esr_class_str[49]')
   arch/arm64/kernel/traps.c:871:43: warning: initialized field overwritten [-Woverride-init]
     871 |         [ESR_ELx_EC_SOFTSTP_LOW]        = "Software Step (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:871:43: note: (near initialization for 'esr_class_str[50]')
   arch/arm64/kernel/traps.c:872:43: warning: initialized field overwritten [-Woverride-init]
     872 |         [ESR_ELx_EC_SOFTSTP_CUR]        = "Software Step (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:872:43: note: (near initialization for 'esr_class_str[51]')
   arch/arm64/kernel/traps.c:873:43: warning: initialized field overwritten [-Woverride-init]
     873 |         [ESR_ELx_EC_WATCHPT_LOW]        = "Watchpoint (lower EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:873:43: note: (near initialization for 'esr_class_str[52]')
   arch/arm64/kernel/traps.c:874:43: warning: initialized field overwritten [-Woverride-init]
     874 |         [ESR_ELx_EC_WATCHPT_CUR]        = "Watchpoint (current EL)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:874:43: note: (near initialization for 'esr_class_str[53]')
   arch/arm64/kernel/traps.c:875:43: warning: initialized field overwritten [-Woverride-init]
     875 |         [ESR_ELx_EC_BKPT32]             = "BKPT (AArch32)",
         |                                           ^~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:875:43: note: (near initialization for 'esr_class_str[56]')
   arch/arm64/kernel/traps.c:876:43: warning: initialized field overwritten [-Woverride-init]
     876 |         [ESR_ELx_EC_VECTOR32]           = "Vector catch (AArch32)",
         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:876:43: note: (near initialization for 'esr_class_str[58]')
   arch/arm64/kernel/traps.c:877:43: warning: initialized field overwritten [-Woverride-init]
     877 |         [ESR_ELx_EC_BRK64]              = "BRK (AArch64)",
         |                                           ^~~~~~~~~~~~~~~
   arch/arm64/kernel/traps.c:877:43: note: (near initialization for 'esr_class_str[60]')
   arch/arm64/kernel/traps.c: In function 'kasan_brk_handler':
>> arch/arm64/kernel/traps.c:1074:9: error: implicit declaration of function 'kasan_die_unless_recover' [-Werror=implicit-function-declaration]
    1074 |         kasan_die_unless_recover(recover, "Oops - KASAN", regs, esr, die);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/kasan_die_unless_recover +1074 arch/arm64/kernel/traps.c

   831	
   832	static const char *esr_class_str[] = {
   833		[0 ... ESR_ELx_EC_MAX]		= "UNRECOGNIZED EC",
   834		[ESR_ELx_EC_UNKNOWN]		= "Unknown/Uncategorized",
   835		[ESR_ELx_EC_WFx]		= "WFI/WFE",
   836		[ESR_ELx_EC_CP15_32]		= "CP15 MCR/MRC",
   837		[ESR_ELx_EC_CP15_64]		= "CP15 MCRR/MRRC",
   838		[ESR_ELx_EC_CP14_MR]		= "CP14 MCR/MRC",
   839		[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
   840		[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
   841		[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
   842		[ESR_ELx_EC_PAC]		= "PAC",
   843		[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
   844		[ESR_ELx_EC_BTI]		= "BTI",
   845		[ESR_ELx_EC_ILL]		= "PSTATE.IL",
   846		[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",
   847		[ESR_ELx_EC_HVC32]		= "HVC (AArch32)",
   848		[ESR_ELx_EC_SMC32]		= "SMC (AArch32)",
   849		[ESR_ELx_EC_SVC64]		= "SVC (AArch64)",
   850		[ESR_ELx_EC_HVC64]		= "HVC (AArch64)",
   851		[ESR_ELx_EC_SMC64]		= "SMC (AArch64)",
   852		[ESR_ELx_EC_SYS64]		= "MSR/MRS (AArch64)",
   853		[ESR_ELx_EC_SVE]		= "SVE",
   854		[ESR_ELx_EC_ERET]		= "ERET/ERETAA/ERETAB",
   855		[ESR_ELx_EC_FPAC]		= "FPAC",
   856		[ESR_ELx_EC_SME]		= "SME",
   857		[ESR_ELx_EC_IMP_DEF]		= "EL3 IMP DEF",
   858		[ESR_ELx_EC_IABT_LOW]		= "IABT (lower EL)",
   859		[ESR_ELx_EC_IABT_CUR]		= "IABT (current EL)",
   860		[ESR_ELx_EC_PC_ALIGN]		= "PC Alignment",
   861		[ESR_ELx_EC_DABT_LOW]		= "DABT (lower EL)",
   862		[ESR_ELx_EC_DABT_CUR]		= "DABT (current EL)",
   863		[ESR_ELx_EC_SP_ALIGN]		= "SP Alignment",
   864		[ESR_ELx_EC_MOPS]		= "MOPS",
   865		[ESR_ELx_EC_FP_EXC32]		= "FP (AArch32)",
   866		[ESR_ELx_EC_FP_EXC64]		= "FP (AArch64)",
   867		[ESR_ELx_EC_GCS]		= "Guarded Control Stack",
   868		[ESR_ELx_EC_SERROR]		= "SError",
   869		[ESR_ELx_EC_BREAKPT_LOW]	= "Breakpoint (lower EL)",
   870		[ESR_ELx_EC_BREAKPT_CUR]	= "Breakpoint (current EL)",
   871		[ESR_ELx_EC_SOFTSTP_LOW]	= "Software Step (lower EL)",
   872		[ESR_ELx_EC_SOFTSTP_CUR]	= "Software Step (current EL)",
   873		[ESR_ELx_EC_WATCHPT_LOW]	= "Watchpoint (lower EL)",
   874		[ESR_ELx_EC_WATCHPT_CUR]	= "Watchpoint (current EL)",
   875		[ESR_ELx_EC_BKPT32]		= "BKPT (AArch32)",
 > 876		[ESR_ELx_EC_VECTOR32]		= "Vector catch (AArch32)",
   877		[ESR_ELx_EC_BRK64]		= "BRK (AArch64)",
   878	};
   879	
   880	const char *esr_get_class_string(unsigned long esr)
   881	{
   882		return esr_class_str[ESR_ELx_EC(esr)];
   883	}
   884	
   885	/*
   886	 * bad_el0_sync handles unexpected, but potentially recoverable synchronous
   887	 * exceptions taken from EL0.
   888	 */
   889	void bad_el0_sync(struct pt_regs *regs, int reason, unsigned long esr)
   890	{
   891		unsigned long pc = instruction_pointer(regs);
   892	
   893		current->thread.fault_address = 0;
   894		current->thread.fault_code = esr;
   895	
   896		arm64_force_sig_fault(SIGILL, ILL_ILLOPC, pc,
   897				      "Bad EL0 synchronous exception");
   898	}
   899	
   900	DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
   901		__aligned(16);
   902	
   903	void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far)
   904	{
   905		unsigned long tsk_stk = (unsigned long)current->stack;
   906		unsigned long irq_stk = (unsigned long)this_cpu_read(irq_stack_ptr);
   907		unsigned long ovf_stk = (unsigned long)this_cpu_ptr(overflow_stack);
   908	
   909		console_verbose();
   910		pr_emerg("Insufficient stack space to handle exception!");
   911	
   912		pr_emerg("ESR: 0x%016lx -- %s\n", esr, esr_get_class_string(esr));
   913		pr_emerg("FAR: 0x%016lx\n", far);
   914	
   915		pr_emerg("Task stack:     [0x%016lx..0x%016lx]\n",
   916			 tsk_stk, tsk_stk + THREAD_SIZE);
   917		pr_emerg("IRQ stack:      [0x%016lx..0x%016lx]\n",
   918			 irq_stk, irq_stk + IRQ_STACK_SIZE);
   919		pr_emerg("Overflow stack: [0x%016lx..0x%016lx]\n",
   920			 ovf_stk, ovf_stk + OVERFLOW_STACK_SIZE);
   921	
   922		__show_regs(regs);
   923	
   924		/*
   925		 * We use nmi_panic to limit the potential for recursive overflows, and
   926		 * to get a better stack trace.
   927		 */
   928		nmi_panic(NULL, "kernel stack overflow");
   929		cpu_park_loop();
   930	}
   931	
   932	void __noreturn arm64_serror_panic(struct pt_regs *regs, unsigned long esr)
   933	{
   934		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
   935		console_verbose();
   936	
   937		pr_crit("SError Interrupt on CPU%d, code 0x%016lx -- %s\n",
   938			smp_processor_id(), esr, esr_get_class_string(esr));
   939		if (regs)
   940			__show_regs(regs);
   941	
   942		nmi_panic(regs, "Asynchronous SError Interrupt");
   943	
   944		cpu_park_loop();
   945	}
   946	
   947	bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned long esr)
   948	{
   949		unsigned long aet = arm64_ras_serror_get_severity(esr);
   950	
   951		switch (aet) {
   952		case ESR_ELx_AET_CE:	/* corrected error */
   953		case ESR_ELx_AET_UEO:	/* restartable, not yet consumed */
   954			/*
   955			 * The CPU can make progress. We may take UEO again as
   956			 * a more severe error.
   957			 */
   958			return false;
   959	
   960		case ESR_ELx_AET_UEU:	/* Uncorrected Unrecoverable */
   961		case ESR_ELx_AET_UER:	/* Uncorrected Recoverable */
   962			/*
   963			 * The CPU can't make progress. The exception may have
   964			 * been imprecise.
   965			 *
   966			 * Neoverse-N1 #1349291 means a non-KVM SError reported as
   967			 * Unrecoverable should be treated as Uncontainable. We
   968			 * call arm64_serror_panic() in both cases.
   969			 */
   970			return true;
   971	
   972		case ESR_ELx_AET_UC:	/* Uncontainable or Uncategorized error */
   973		default:
   974			/* Error has been silently propagated */
   975			arm64_serror_panic(regs, esr);
   976		}
   977	}
   978	
   979	void do_serror(struct pt_regs *regs, unsigned long esr)
   980	{
   981		/* non-RAS errors are not containable */
   982		if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(regs, esr))
   983			arm64_serror_panic(regs, esr);
   984	}
   985	
   986	/* GENERIC_BUG traps */
   987	#ifdef CONFIG_GENERIC_BUG
   988	int is_valid_bugaddr(unsigned long addr)
   989	{
   990		/*
   991		 * bug_brk_handler() only called for BRK #BUG_BRK_IMM.
   992		 * So the answer is trivial -- any spurious instances with no
   993		 * bug table entry will be rejected by report_bug() and passed
   994		 * back to the debug-monitors code and handled as a fatal
   995		 * unexpected debug exception.
   996		 */
   997		return 1;
   998	}
   999	#endif
  1000	
  1001	int bug_brk_handler(struct pt_regs *regs, unsigned long esr)
  1002	{
  1003		switch (report_bug(regs->pc, regs)) {
  1004		case BUG_TRAP_TYPE_BUG:
  1005			die("Oops - BUG", regs, esr);
  1006			break;
  1007	
  1008		case BUG_TRAP_TYPE_WARN:
  1009			break;
  1010	
  1011		default:
  1012			/* unknown/unrecognised bug trap type */
  1013			return DBG_HOOK_ERROR;
  1014		}
  1015	
  1016		/* If thread survives, skip over the BUG instruction and continue: */
  1017		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
  1018		return DBG_HOOK_HANDLED;
  1019	}
  1020	
  1021	#ifdef CONFIG_CFI
  1022	int cfi_brk_handler(struct pt_regs *regs, unsigned long esr)
  1023	{
  1024		unsigned long target;
  1025		u32 type;
  1026	
  1027		target = pt_regs_read_reg(regs, FIELD_GET(CFI_BRK_IMM_TARGET, esr));
  1028		type = (u32)pt_regs_read_reg(regs, FIELD_GET(CFI_BRK_IMM_TYPE, esr));
  1029	
  1030		switch (report_cfi_failure(regs, regs->pc, &target, type)) {
  1031		case BUG_TRAP_TYPE_BUG:
  1032			die("Oops - CFI", regs, esr);
  1033			break;
  1034	
  1035		case BUG_TRAP_TYPE_WARN:
  1036			break;
  1037	
  1038		default:
  1039			return DBG_HOOK_ERROR;
  1040		}
  1041	
  1042		arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
  1043		return DBG_HOOK_HANDLED;
  1044	}
  1045	#endif /* CONFIG_CFI */
  1046	
  1047	int reserved_fault_brk_handler(struct pt_regs *regs, unsigned long esr)
  1048	{
  1049		pr_err("%s generated an invalid instruction at %pS!\n",
  1050			"Kernel text patching",
  1051			(void *)instruction_pointer(regs));
  1052	
  1053		/* We cannot handle this */
  1054		return DBG_HOOK_ERROR;
  1055	}
  1056	
  1057	#ifdef CONFIG_KASAN_SW_TAGS
  1058	
  1059	#define KASAN_ESR_RECOVER	0x20
  1060	#define KASAN_ESR_WRITE	0x10
  1061	#define KASAN_ESR_SIZE_MASK	0x0f
  1062	#define KASAN_ESR_SIZE(esr)	(1 << ((esr) & KASAN_ESR_SIZE_MASK))
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

