Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E558CCA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 19:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07E56B0006; Sat, 30 Aug 2025 15:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8E46B0008; Sat, 30 Aug 2025 15:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7AF6B000C; Sat, 30 Aug 2025 15:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76B0D6B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:10:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF24BC024E
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:10:53 +0000 (UTC)
X-FDA: 83834365986.21.AE021C9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1665714000A
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:10:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I1c3qkw7;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756581052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cxqyLkPY25fDgE4laNbglweu6ayzoOFZdX1zkijbmL4=;
	b=d8/Wxt9D/vQZzMTpNqzQlnRAv+eGdJ3diUB+JQUrTzg1dci7FPQsZQYEnNx509209LFh5N
	GxKxXzciD+Amsjcrl0v95vxLTdXHrk47uYZxJLzGW4N1/wXpm96haAbHRytPeLK4yOmzZd
	5nEpz+6gXF4xtYK7RjwJ92k0yJLxLvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756581052; a=rsa-sha256;
	cv=none;
	b=r5Osss208GlXhMQsu7d0wyFtF24co2/fB1cetPrsFa/ANVZitpEnvLMIcgJoHwe6mo8iPc
	DcIt8E/KGxMwlrt8hoifYgvTRFIdLzhLlDkVmx8x+Ds1rJ5jdLXc+JVNPpLhNJmkBH21V7
	n7A7qz/QDghSs/TxkKIsz4zikidZUSU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I1c3qkw7;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756581051; x=1788117051;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=HSxwq/sv5bGv5zvi1+pAo8mM20+0b8sh/zp9ljjKZgA=;
  b=I1c3qkw7gPjb0zZO6BpX3zKeSwFQb7xgbyq+Y/5753WCFsQ4717cXkSh
   gDZJdTKi2Z+Ysb+18+NsdkW382dXWQgK62P4+dQ0W1UzDat8VlaagG+6B
   6KLgPRNIL4t8w1N71U0aw2CUW3wr764dpMItn6mENdKl7ze3ooVa+xk+5
   C0lgZlnAAaDkHxDQBWaAWv+t94olb+37neaI/SPquLp9B4rVOPSQccXIp
   vQ3+9ILqC6hKKj+r8ot4ywJ4+Dm+IupqR63N0mFSE1mfjyGPfYHTs10f/
   M4pxMr/eEB0BYImef/CKzo6dQCTlWyyboiR7o4p0nBDA9hhR1aAx7eFEY
   w==;
X-CSE-ConnectionGUID: bbMC+fOKS2uOMeg4ks8JQg==
X-CSE-MsgGUID: 2owaprrgToyEBNxr3hD1qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="69938559"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="69938559"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 12:10:50 -0700
X-CSE-ConnectionGUID: gY+YP60GTgeA7lRfyz234A==
X-CSE-MsgGUID: OeY8ZE0BSHS9GzRB/M6wwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="207784669"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 30 Aug 2025 12:10:48 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usQyL-000VdZ-1Y;
	Sat, 30 Aug 2025 19:10:45 +0000
Date: Sun, 31 Aug 2025 03:09:58 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [akpm-mm:mm-unstable 140/221] arch/um/include/asm/kasan.h:29:2:
 error: UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202508310221.jSUso3QB-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1665714000A
X-Stat-Signature: 9tbm66wdmskk68p8drzoh4ix3fps614h
X-Rspam-User: 
X-HE-Tag: 1756581050-219991
X-HE-Meta: U2FsdGVkX18EQ5Wh9ZoR9TUyyhYCL6X0dVRm9OGYo4o0kj2rnJc55wXhJdNgeoWvVaRpIQ69TjPFlyFA7U7gMY/NQ3T+HrPoutoG2vdYVadYFYr/k20Z0LX6nlLrY36hZIswJqcNLZUaTwqI3ynJaUVoD3THFh5FJMB7SNRDVBWAQLS3R/Ad5Az4ILui4vZIcuzgtrk8aEH5W7gQeszPbvQTC4gMQPEyc+LyJrFtMQKMLYE0x8KKX1vxTv9exflY59t0Ao7hvxgjt2YywZ1sbIN3+2RbpJyA4zpQgKw1HqbJCT7dCdkfguxlRkQZMY0K1WSb0F/YxwOEdE0JEp+tZCrF1uXhY9a6OjkvOTuM692yGQ3R8mczLKYzgrKdjXYADWtnah2GzP6LqMFNg3yv6ym3o8EDQAlpDfsCHhma6O5C4AebTj9OdKiAGQjZzB417NQ9tuBXc/TXlejEwQljA+3Br5NCPYk4k88uhag/4rUeGvw2DYaGKTuF0JtZTqUaGCL7tcJqOCJE06DwCHICR/pY0r+cgf/K7E8kiGF1isEEbJ5D2bA2mjEiJNsnkbd4hbNKfJviOAx76ilHtxNeBYgFhImZWsMUnRfWIVeFx6/KkY7wOonAnMZv+zytZOcNJdVyWQ6MaHrEuRvuzNn2CUPC43wMAnd7pBrFhwRaYSIvazm9fCWSp0mIyAp/v+jd8zSzUSd5rNRxcAiUf6/kw5Nq5WxJTZS+xra2rT3ZKPywWL1nuV6uD1zPDizTM2VrHG6rY/Sco8HiN34bcBhe1dimYIqGcInhqAovHdnC/5pZeJqc2Fl81H/rK8k3P5Hg2Qea/GIQ3dquGKtWmQKpux7Fp+n8UI3d7OzZ/bpOs73orlWXjfAGa2+5FF6+/GskTpjEFojc0zg4I71gseLMLFFRDCKtemXFNqkvT+V+3qQH+PJyOHaxTi8t7aw5SaIjW2MzzVitX6XFGbfFGv8
 ViKD/05g
 ZDMi5hR42QJ1V8jmtwGhB9caDbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   6531c300923e1b222e7cac7b74975ddf686aba96
commit: cf803b1aeda8859efc50696db9bd11577571e5c1 [140/221] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
config: um-randconfig-001-20250831 (https://download.01.org/0day-ci/archive/20250831/202508310221.jSUso3QB-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250831/202508310221.jSUso3QB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508310221.jSUso3QB-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:5:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:260:
   In file included from include/linux/kasan.h:21:
>> arch/um/include/asm/kasan.h:29:2: error: UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
      29 | #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
         |  ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];


vim +29 arch/um/include/asm/kasan.h

    27	
    28	#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
  > 29	#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
    30	#endif
    31	#else
    32	static inline void kasan_init(void) { }
    33	#endif /* CONFIG_KASAN */
    34	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

