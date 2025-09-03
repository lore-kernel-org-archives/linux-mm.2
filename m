Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 571E4CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 03:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8F66B0007; Tue,  2 Sep 2025 23:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A3A6B0008; Tue,  2 Sep 2025 23:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F306B000C; Tue,  2 Sep 2025 23:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73E876B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:53:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FE10B9A3A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:53:59 +0000 (UTC)
X-FDA: 83846570598.26.59E2C68
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7432140007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:53:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RsAyj5be;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756871637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mmqPh39juKQQC8YZwxo6erfgz5KPO9senq2OXA7PBrw=;
	b=AUNUOQCQPLScH7SV+8ei0VoBCOAD3/DguhfUj/UQoWiU5OsUkbGiod9v45qLjP9ZSb+o4F
	iGTOy4o5FJ5MJjueBUrMzn9qK9gPezCobW8sRzg2vLGHtRlcpjnJftWMyehh84nXvwKisb
	7XsOCt6wRB8a22z83JyihrMobZQA0GY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RsAyj5be;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756871637; a=rsa-sha256;
	cv=none;
	b=DwKsG4m/UlyCoXqPaM0zGtMNTo94Tu3fznZvNn7VO74xjMUU1EHb9o2Plim+m1LPJooDqm
	VWl+VeZAVoTk4NRwc3aufR99hiSWhQiAUBW34oqPIX1K3j+yzbD140/0eHCB7rV3wEkc0n
	vFxg2pyVpzmi/LZu2VMcQQbx+ahOj9g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756871636; x=1788407636;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hHJm4RhYvy1lWmzocwyI81r00Gwr1hI6d9XuDTkkn9g=;
  b=RsAyj5be6YAgAigbDpbaTX3+5OCiVPK9VfhTjZEM487Hmles+mtfvJgy
   XZLGjOC6kU/gXp2jTlvci+IiVXxlD+VBzOHjRoah8iXGJKT8ayepAB941
   eHvcWzi4+5PY7RT2usaUHcSd/fVBIPdiXBfY16hGB+O6/xPeU1TFoZOVm
   42Iaag8nBIXNr3mbkFsFpdblWYmcNBCoRAx8IfvJOhorZn51iD8K5KE+J
   xEKBABVZ+UGxt086j/CojxpnS6n9d5kWO5s4nuSzLt7j/kzTWvaPSUkxy
   BPf/BitExBTcxxSZwRRKdFrR8qDU+A9Ykjz1rdDLVtx4SUSi3N+r5H6iA
   g==;
X-CSE-ConnectionGUID: //EGfHUBT06n9miaGQyX6g==
X-CSE-MsgGUID: RqrP6XgcTZyo7jROXv7tdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="62817098"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="62817098"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 20:53:55 -0700
X-CSE-ConnectionGUID: L1S3t1vqTw+0JrPnK9xJww==
X-CSE-MsgGUID: VJrZtQI2Sj2vJbJVmSsckA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202363943"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 02 Sep 2025 20:53:53 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uteZC-0003Kj-2N;
	Wed, 03 Sep 2025 03:53:50 +0000
Date: Wed, 3 Sep 2025 11:53:25 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [linux-next:master 5272/5641] arch/um/include/asm/kasan.h:29:2:
 error: UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202509031153.WYCE6uYO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7432140007
X-Stat-Signature: r1k36k7e7yuoywoghtrssni7b44hybb3
X-Rspam-User: 
X-HE-Tag: 1756871636-962703
X-HE-Meta: U2FsdGVkX1/nLui7/wpJEl/iV16HrIz7a9HUid4KJbgFZr+yoMn34qrANADI69xqmzwcG+9BLwsyuFkPKLv2ZvZMSKgxFmA1/grNwcL+1YmzSx6F6l+uxss1yNdxf86MWmAegmoWX5C7uQCOcrf4vBRpuTBh51TdfuOuNIAIv2xLWUNJ9zkyF3rzCjHCLsoH0ixFUMSuS3Dy1X34qYjs1Uj9stWLWDT9XVhkx+WgW1QSmZ62m3cjuIcJWsYa0AB7VeHfEh86v/s5vSlsikXtNp5StNR4MsylpEf8AvqX3GB0eF35tap8YREVrDrjJf2BHdMCdjxu440sKgAqRQEk4AZmTBJmOlGIbOqJ1Wst2U2+rMyDx/62toC1/4/+zKNH5Rr9BBkk4zJkiF/vOYSGPwpfCl/EW+Xld4BCP3oN9Q+o0Ex63v2C+7OE3+ZNWrQ5XjojZKemo8v5dQYatq57E9+mTRloTIPghB/zv73RlreGmiN16bcONFIz/83KKnyz/yb2FoyZlGFVh0B29aktvVSVuvviNzDQBsZakCk3ZdNvQ1iT3gFaRGKASky6Srk18krqK0jiZEtAujnGqG7iWKe6oYTbX4lPSIulN6psg4UjoIWz0RgXim87z3NozMdZSFB8a4IDt6x1mBo3elhJ8Vi5TEgBoVIpfXG8TyD4IU4gc2yCKIF35CALXsiqAVMgQvfQ3uwewX/2mqS6p6VL+9bLDLfB1pfeUS0jYjgVvQI/pkGyATujf2zylzms1AFYjPBzlMnNY3lfGX7KZ0UCIHhIO5Ws4ope5GRfiHnbPTGfxVoqEQjFY02yJscsiOa3/TmZqB6mKPGfU+xy5/UlQl8dojZaIEuZx2oke3xzZe2Iq8vPaKxUx7tJA9hnZlazdc3j0rck6SojejzD8zYm+pLAOiQknrevKUZxPBjK5lOlMKS4l2jL1rTFGlWxsYL22GX8xeBaJasEZcP6EXH
 RDQGj7Fj
 ixmeMUah2EFjMrVAEVChvC8kAC00o9nVweOLr9vCR5Ma+X/HJQFjHAK4V+6WFw5rnEN0GUQPmshV60kHcbz4GcYmPE6j3RpO8i5b5EBF0EYw/VYuHaDw5AVPEbwc2fNtT+egdOhCB6zwAKI2a1plBiL98jFIKktiEsCxJLaQ3nrPMdLuFN/rSIbuXBlCic7ibgYYOPJTe1FjgrKK0Qe/izmHnAvbLKpf/db7jnSV/CoOahqXmji547doFXZ46+kH7I/FG2s1W9Eq8EI4WNVL9IneRW1+WEZCLt4lS3/5DBchIecMFxQ5aE/AJPDM0wNUNsJoQI5iiuK5T2KnEuN7ccAJnwMkkBo1LHR4coMnXRegwcQV9Wh/7hef1GLF6Whwxid8GzkCouGCg1B4Y0kpWynW2lGTbuQ+E5GNqa+c2LXKDxUAi4l74jVzrg0aNdQxTC7yp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   3db46a82d467bd23d9ebc473d872a865785299d8
commit: f5dd875907292162bd6de7c47e6b047461ea2b7b [5272/5641] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
config: um-randconfig-r132-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031153.WYCE6uYO-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031153.WYCE6uYO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509031153.WYCE6uYO-lkp@intel.com/

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

