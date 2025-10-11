Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15122CCD185
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 00:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AFF8E002B; Fri, 10 Oct 2025 20:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554118E001F; Fri, 10 Oct 2025 20:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F548E002B; Fri, 10 Oct 2025 20:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 376938E001F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:50:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D31218789B
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:50:53 +0000 (UTC)
X-FDA: 83984003586.07.AF4AC43
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7904A1A000F
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:50:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X1NYdcbS;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760143851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCx0DwPLyiYTCyxjHZTHjELRamDb4oB9DsTmhXZlf+E=;
	b=mrPH+uDq9SqaA5cOdWIPB/37X02Z17EAY04ecJ7Gz3Y+Z7Qzh4UJ+sa+uXP+ku/rrd1cnj
	wp6Sh5FIg8/KmpSGCKQRDtc0133DPIgbdT6vAdFXANFDGPTIPIwOTW+xTPE3b3HmXRLeaZ
	NrHi/czdPblYed/qQh83JdYc/gXyD0E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X1NYdcbS;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760143851; a=rsa-sha256;
	cv=none;
	b=uSMDpsglumqFRW8xbFKHEeTMhtVkEm7CzdZ9ynMWxstzVw2snUyNjo9+OesaE0OtCbmZrR
	1QMpxrWqhtINwFIcP8hMC/djpW6LbZUGzFUAoiCzzATi4Sl+19s+rk7t2x8/kOgCZbopFB
	v7xUGaNAgLU/yenMMEIdE71Q7w9s66k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760143852; x=1791679852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9mgsASjVFIeADDVrI9fvFoRPP0l3FSfJJNlhNk/Q2lY=;
  b=X1NYdcbS+uPxmSmOGtE9Aq8ltCJfGCIi/0qQNAl34Q8XpZrjETwlz5/E
   ZVORv0Kd1jsUiOORl/SOnYWkXWOrJEZZNhc5y3zEQ6Pd1k4KWXbi/jlM9
   Lekd2KSKiwaA0dZD66P70NJNQnVm6hobFj6Y/aWgKRKfmBztFO7fQHfsh
   9bmCAOhDxlwiOPViRv3LchfEy0nWRoc+EIquq4anHOYiMYK2L/1V0S+w9
   /FBBTXJYzfj6OITMzzf9vlBB08+1cPmtUifIWtnn/t6z+WyxZJLOtdoAo
   OulrAJO5aL8Mc0KBBBFoHJqAZ/mw/QUro3/clzF9vQhKWEYYwTyJNmY6w
   g==;
X-CSE-ConnectionGUID: vw0lGEMTQ7io8Ui/WcPqzg==
X-CSE-MsgGUID: WMjiA4fwTCqTkF9+Y3JDKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66194855"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66194855"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 17:50:50 -0700
X-CSE-ConnectionGUID: XAAY603OTAq3vXDWwrrrVg==
X-CSE-MsgGUID: j9ZDNPDASAWyNKWZhItqmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="181529200"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 Oct 2025 17:50:46 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7Noq-0003LT-2A;
	Sat, 11 Oct 2025 00:50:44 +0000
Date: Sat, 11 Oct 2025 08:50:20 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>, acsjakub@amazon.de
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, chengming.zhou@linux.dev,
	david@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
	xu.xin16@zte.com.cn, rust-for-linux@vger.kernel.org,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <202510110850.4VXzbsF7-lkp@intel.com>
References: <20251007162136.1885546-1-aliceryhl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007162136.1885546-1-aliceryhl@google.com>
X-Stat-Signature: 7ez1cg7usjc7ryt31k6fi6z5o773k9c9
X-Rspamd-Queue-Id: 7904A1A000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760143851-37689
X-HE-Meta: U2FsdGVkX18+RC8TfKcB/Buie7Pk9AbGHcH/Hx5Udyga2z6VKobFUJHCfO2vhKIfR2T5RmFtt9ttudnHmI2XFzX6mhULYvSYrWZxvfh4uOHf0s05wogoaReZeflXLHU8Audz+BzsIKtDWR5a0liJKFsbpijD1GPmgxhKV0JbXjWMXalYkaaoILMfAVEs66DXLgFLIIDZJs0Kt+1Ez7Gly8i6vDHO+YnJTJkd4jkOlQAiAQH6WjeUpMFzECa/sMm6wSsoh15MzOzjB+Yp7fv9L13RfQEqNGQK23qHAJ719plyxxPivCjppT8TKeJoCW+tuy1HLm3AAxe5oKae0aMqBHD+waLedtJlOfq5qXgn32JzWKjpbRVOh4GctfxWrWdii+AWXDD4cgbXh8cOnB/hUyL4pPjhi9JxD+DSPiIf99vigydKQst1sNbd/HG94i4y6IDiC0QNPXXQkhukX9WuELq5yICRs8KBJeG3CKZlbY/af6W7eckbPssDkXIeIbRwRDFSbEl3bNGXAUopiYu7XBJqN5l/UGXl9YW0o+TYrBCYr7dbpUv9+hu6Ty5dFbGw+kKU2utLxxAW8euLuL3ToUlMtWCuGbhSrGvqhpgZcJ6wE3tLtpO1+MovFJJ7b+nZkciD7rx5GCyGCcgOhifjpy+THN0ASZMSR7sBGznB/XnzZF6qOoYLEHmIpzHfN37UL6XTlhesE/3PbXOp9e1CRLXQO+KzjGlXyLcE1aF//Us8LiV3xQl4bu8LcRBsnEbQQLWsrKsbiYnmK2IgEkg4nfr/k8KOgfdTNqQczavlexFwColmMOGCq2VKRW8v5mCGcArg+XvwmgD/5CRAQNa3Ys9BPCZAyBWtuiGwqxjUsQCWW8P60i+D+9TYNL910G0CYnakKwQkZdgR6bl8NGAiC01JHUFYpLbpQMyXASJgxuOTJh0on8TMA9ZaD85JuOcAiWcrN6uk+bQn+V2dc8R
 LP7Puiob
 TEeoN5UsUyQEwoBqsQuJvgivQLCGUFJogbbrLX2sv98H/qPQWXMdBZdFRauSZkLsH70fu6P49ljjDPsJigUuhOeaM2P6b+CEw36pVT3tlZVbIs50CDWTiCZVHltLuBcbzyecFxIAziMiNP5yh2265IHCaTjJl488vDcNrVfVX2MHjg/J/hMCGu+l7P4N6Y47kKlDtEulKQxEz2MpCb15kb4UJETGmuhjasQ7KHc5CMID8DEDe67vDeKM+llKPe6PY4kCUXNvekBtUt2W8mGALHXOArPwbAWKfS+wrzd8CEGfUE+4vKIqdRqlLGt19klU8uYZHnhXfSfRX3DlpLj0xuMcgVxyxrAxmEMKTRHQUoEp++/xLYzdubSZP5u2dbiiQ+Q82lLti9Fa2ZRuLh91Nfsz2aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Alice-Ryhl/mm-use-enum-for-vm_flags/20251010-095004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251007162136.1885546-1-aliceryhl%40google.com
patch subject: [PATCH] mm: use enum for vm_flags
config: powerpc64-randconfig-r111-20251011 (https://download.01.org/0day-ci/archive/20251011/202510110850.4VXzbsF7-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110850.4VXzbsF7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110850.4VXzbsF7-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/proc/task_mmu.c:1184:5: sparse: sparse: undefined preprocessor identifier 'VM_HIGH_ARCH_3'
>> fs/proc/task_mmu.c:1187:5: sparse: sparse: undefined preprocessor identifier 'VM_HIGH_ARCH_4'
   fs/proc/task_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:897:25: sparse: sparse: context imbalance in 'proc_get_vma' - unexpected unlock
   fs/proc/task_mmu.c:309:9: sparse: sparse: context imbalance in 'm_start' - different lock contexts for basic block
   include/linux/rcupdate.h:897:25: sparse: sparse: context imbalance in 'm_stop' - unexpected unlock

vim +/VM_HIGH_ARCH_3 +1184 fs/proc/task_mmu.c

e070ad49f31155 Mauricio Lin       2005-09-03  1120  
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1121  static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1122  {
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1123  	/*
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1124  	 * Don't forget to update Documentation/ on changes.
5778ace04e6f07 Brahmajit Das      2024-10-05  1125  	 *
5778ace04e6f07 Brahmajit Das      2024-10-05  1126  	 * The length of the second argument of mnemonics[]
5778ace04e6f07 Brahmajit Das      2024-10-05  1127  	 * needs to be 3 instead of previously set 2
5778ace04e6f07 Brahmajit Das      2024-10-05  1128  	 * (i.e. from [BITS_PER_LONG][2] to [BITS_PER_LONG][3])
5778ace04e6f07 Brahmajit Das      2024-10-05  1129  	 * to avoid spurious
5778ace04e6f07 Brahmajit Das      2024-10-05  1130  	 * -Werror=unterminated-string-initialization warning
5778ace04e6f07 Brahmajit Das      2024-10-05  1131  	 *  with GCC 15
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1132  	 */
5778ace04e6f07 Brahmajit Das      2024-10-05  1133  	static const char mnemonics[BITS_PER_LONG][3] = {
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1134  		/*
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1135  		 * In case if we meet a flag we don't know about.
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1136  		 */
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1137  		[0 ... (BITS_PER_LONG-1)] = "??",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1138  
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1139  		[ilog2(VM_READ)]	= "rd",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1140  		[ilog2(VM_WRITE)]	= "wr",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1141  		[ilog2(VM_EXEC)]	= "ex",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1142  		[ilog2(VM_SHARED)]	= "sh",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1143  		[ilog2(VM_MAYREAD)]	= "mr",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1144  		[ilog2(VM_MAYWRITE)]	= "mw",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1145  		[ilog2(VM_MAYEXEC)]	= "me",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1146  		[ilog2(VM_MAYSHARE)]	= "ms",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1147  		[ilog2(VM_GROWSDOWN)]	= "gd",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1148  		[ilog2(VM_PFNMAP)]	= "pf",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1149  		[ilog2(VM_LOCKED)]	= "lo",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1150  		[ilog2(VM_IO)]		= "io",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1151  		[ilog2(VM_SEQ_READ)]	= "sr",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1152  		[ilog2(VM_RAND_READ)]	= "rr",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1153  		[ilog2(VM_DONTCOPY)]	= "dc",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1154  		[ilog2(VM_DONTEXPAND)]	= "de",
8614d6c5eda005 Jason A. Donenfeld 2022-12-05  1155  		[ilog2(VM_LOCKONFAULT)]	= "lf",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1156  		[ilog2(VM_ACCOUNT)]	= "ac",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1157  		[ilog2(VM_NORESERVE)]	= "nr",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1158  		[ilog2(VM_HUGETLB)]	= "ht",
b6fb293f2497a9 Jan Kara           2017-11-01  1159  		[ilog2(VM_SYNC)]	= "sf",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1160  		[ilog2(VM_ARCH_1)]	= "ar",
d2cd9ede6e193d Rik van Riel       2017-09-06  1161  		[ilog2(VM_WIPEONFORK)]	= "wf",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1162  		[ilog2(VM_DONTDUMP)]	= "dd",
424037b77519d1 Daniel Kiss        2020-03-16  1163  #ifdef CONFIG_ARM64_BTI
424037b77519d1 Daniel Kiss        2020-03-16  1164  		[ilog2(VM_ARM64_BTI)]	= "bt",
424037b77519d1 Daniel Kiss        2020-03-16  1165  #endif
ec8e41aec13005 Naoya Horiguchi    2013-11-12  1166  #ifdef CONFIG_MEM_SOFT_DIRTY
ec8e41aec13005 Naoya Horiguchi    2013-11-12  1167  		[ilog2(VM_SOFTDIRTY)]	= "sd",
ec8e41aec13005 Naoya Horiguchi    2013-11-12  1168  #endif
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1169  		[ilog2(VM_MIXEDMAP)]	= "mm",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1170  		[ilog2(VM_HUGEPAGE)]	= "hg",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1171  		[ilog2(VM_NOHUGEPAGE)]	= "nh",
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1172  		[ilog2(VM_MERGEABLE)]	= "mg",
16ba6f811dfe44 Andrea Arcangeli   2015-09-04  1173  		[ilog2(VM_UFFD_MISSING)]= "um",
16ba6f811dfe44 Andrea Arcangeli   2015-09-04  1174  		[ilog2(VM_UFFD_WP)]	= "uw",
9f3419315f3cdc Catalin Marinas    2019-11-27  1175  #ifdef CONFIG_ARM64_MTE
9f3419315f3cdc Catalin Marinas    2019-11-27  1176  		[ilog2(VM_MTE)]		= "mt",
9f3419315f3cdc Catalin Marinas    2019-11-27  1177  		[ilog2(VM_MTE_ALLOWED)]	= "",
9f3419315f3cdc Catalin Marinas    2019-11-27  1178  #endif
5212213aa5a235 Ram Pai            2018-03-27  1179  #ifdef CONFIG_ARCH_HAS_PKEYS
c1192f84284146 Dave Hansen        2016-02-12  1180  		/* These come out via ProtectionKey: */
c1192f84284146 Dave Hansen        2016-02-12  1181  		[ilog2(VM_PKEY_BIT0)]	= "",
c1192f84284146 Dave Hansen        2016-02-12  1182  		[ilog2(VM_PKEY_BIT1)]	= "",
c1192f84284146 Dave Hansen        2016-02-12  1183  		[ilog2(VM_PKEY_BIT2)]	= "",
9f82f15ddfdd60 Joey Gouly         2024-08-22 @1184  #if VM_PKEY_BIT3
c1192f84284146 Dave Hansen        2016-02-12  1185  		[ilog2(VM_PKEY_BIT3)]	= "",
9f82f15ddfdd60 Joey Gouly         2024-08-22  1186  #endif
2c9e0a6fa2bb75 Ram Pai            2018-03-27 @1187  #if VM_PKEY_BIT4
2c9e0a6fa2bb75 Ram Pai            2018-03-27  1188  		[ilog2(VM_PKEY_BIT4)]	= "",
c1192f84284146 Dave Hansen        2016-02-12  1189  #endif
5212213aa5a235 Ram Pai            2018-03-27  1190  #endif /* CONFIG_ARCH_HAS_PKEYS */
7677f7fd8be766 Axel Rasmussen     2021-05-04  1191  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
7677f7fd8be766 Axel Rasmussen     2021-05-04  1192  		[ilog2(VM_UFFD_MINOR)]	= "ui",
7677f7fd8be766 Axel Rasmussen     2021-05-04  1193  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
bcc9d04e749a8c Mark Brown         2024-10-01  1194  #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
54007f818206dc Yu-cheng Yu        2023-06-12  1195  		[ilog2(VM_SHADOW_STACK)] = "ss",
399ab86ea55039 Jeff Xu            2024-06-14  1196  #endif
d175ee98fe545d Christophe Leroy   2024-09-02  1197  #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
9651fcedf7b92d Jason A. Donenfeld 2022-12-08  1198  		[ilog2(VM_DROPPABLE)] = "dp",
d175ee98fe545d Christophe Leroy   2024-09-02  1199  #endif
d175ee98fe545d Christophe Leroy   2024-09-02  1200  #ifdef CONFIG_64BIT
399ab86ea55039 Jeff Xu            2024-06-14  1201  		[ilog2(VM_SEALED)] = "sl",
54007f818206dc Yu-cheng Yu        2023-06-12  1202  #endif
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1203  	};
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1204  	size_t i;
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1205  
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1206  	seq_puts(m, "VmFlags: ");
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1207  	for (i = 0; i < BITS_PER_LONG; i++) {
c1192f84284146 Dave Hansen        2016-02-12  1208  		if (!mnemonics[i][0])
c1192f84284146 Dave Hansen        2016-02-12  1209  			continue;
5778ace04e6f07 Brahmajit Das      2024-10-05  1210  		if (vma->vm_flags & (1UL << i))
5778ace04e6f07 Brahmajit Das      2024-10-05  1211  			seq_printf(m, "%s ", mnemonics[i]);
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1212  	}
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1213  	seq_putc(m, '\n');
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1214  }
834f82e2aa9a8e Cyrill Gorcunov    2012-12-17  1215  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

