Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2DEC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 19:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBE46B009F; Sat,  9 Aug 2025 15:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CAE6B00A0; Sat,  9 Aug 2025 15:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4FF6B00A1; Sat,  9 Aug 2025 15:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC7B96B009F
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 15:41:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DD42140273
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 19:41:59 +0000 (UTC)
X-FDA: 83758239558.21.753F319
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id 864BE40005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 19:41:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G/Yh/RPh";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754768517; a=rsa-sha256;
	cv=none;
	b=WtT97rdSQrPYlZaehME+4MXZO14AH/+NIqWpPl+iBI6gC+mH6NeohLc8P9wZ2eJ0hrsOsQ
	gTVfzW2lwQ2FbbYvVFykPnpsptV9mPZnB1ACnK2ew4zN+hls69o10l93p6PtooxswBesXa
	Zt/khF/toWWvLIp+yI45Wq2s+8d7yLY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G/Yh/RPh";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754768517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kMq9Vt6UlIlgE9lxn7ARGSRVmWoeBCfQoYID6oE7Xis=;
	b=vAPpL9nbE7nRLIYgQIwCiZxLtQWiQBvzAvr2+845twL5/AEXtvMVZZb/wFJwznvjB90saR
	j7cjc6ZLm4TGDju2Ypc5yScp2/eUzP33FWYSYMdGoGorDaNPLC3wchCz7hVhdU3nXqxEQz
	TlSUZvrHCly+UxpJk4n/KZ1e3FxyziE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754768517; x=1786304517;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=06Kjz4k4lavK7HKHl+Pl1kS3zK+LVKSZHsr67K/P29g=;
  b=G/Yh/RPhm2RY04mIcBqT0qP0f7w8MgYeSQhT/+BlxzTbbRqtKcMhbW/b
   PXA+iv2edXOwYtAss1utEwpJHHua9b+tfrq6gi8bIHB+Sf6UKMn37j5kg
   8U27/kd8E89p7/DXLzelefWuCnWsN75woU9nGRBbUkDgVrejxo+gRP6wn
   AKVYHqdCxdCnCLrp+2U020QfSBX/tmRQPUeUZQlHtYc6jK6UBeg7A2kUc
   cgP7gO1njs5/GLOYbgi8DmAriO6kHAXXlFy83Lj6CQJnUTv5ynxsEGqOg
   yAxKDMXBb0XnMnsDiZO6jaDFuKU7S3jPt7DbdXUsAgCU+x27cs7jLaAmN
   A==;
X-CSE-ConnectionGUID: QipaxE/wTymyAmNc1C2fyQ==
X-CSE-MsgGUID: Dn1egBZwTDaizIY19RV7NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11516"; a="57003104"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57003104"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 12:41:55 -0700
X-CSE-ConnectionGUID: iO5wYnCDQYu33ub9GsimoQ==
X-CSE-MsgGUID: /OKTt80pTkKEbSvIQti18w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="202765763"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 09 Aug 2025 12:41:53 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ukpQu-00051g-0M;
	Sat, 09 Aug 2025 19:41:01 +0000
Date: Sun, 10 Aug 2025 03:40:23 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 72/77] arch/um/include/asm/kasan.h:29:2: error: UML
 does not work in KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202508100304.92cGHfSj-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: btru9fodt5dyr7aw3muh94161pksdt4k
X-Rspam-User: 
X-Rspamd-Queue-Id: 864BE40005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754768516-651979
X-HE-Meta: U2FsdGVkX18I++HowPTNOD+joUcTll+WMNNRKbbJ1QGPAOXJC/rYWtSaqyrX7GBftlQJWpX69LWopRG+oNcrcy2hT5K5V5pPQTpGq+yd83qFVyX5cTKha7iohJS+NgiIGDUApjN4Iu3F5WRINIpF8jEPfeWR9cM1b47pcWPbX4NnANo1jXF1CDOcJ5pq51pFflm8gcBVsXewrr3jW8UOJv+mhOAqOxPc0O9CnUi+vCzyhyp+cVf4KXPQovq1Ac6PGDr3lD3os9GqUv6XUMa7pOLBcNczkRV9pqzrdhRst7Cmlt70gYobnG1HjTkagM9nWPuLLkvSZSfFcdUoYhwbNeN+J1WDnWD6WNoRXK8xMm5U1hhKsbSVY80l/7Xe2iC6U7h4ZDOzLBW/h+xDlJfnRfaIsmRpCWUb819zal45GewfsuPNww5/wcMjF3nGxKLaZ489WAVdFEpFVSgn875ufDh/NGdjm3nZ5dAoWFYwIoFCXBM13djrcuQNCVBM19278xLgD3gIQNqS8e82xGKiyPxjpqa2RgS0WjlLCVikCJjyQEw5+4hGRARW7pK9/bIuNbT9Vkl/2lNYHgE6TCu3+dwC08wjPz3atE3VUqkqkMXPGQ68YM2gbPw7OYsS6gkczGtC9I9xDmhLyQdZygCqtbUTtxAE5+wQDkTGHXsmC1k3L1B2oX3av3oZ5PlH5vsOUpMAS1NXAk2Xdl6g4OKlVKKJf6/oxafIBtPX77Aq+1E2Qgy71514AJx5HnAcoGGnVBplrdoudAo1k+79lV71dlnFLSX+HbahqRktC9Sn5pY9pSJcDicSq6yia4Qms0rQs6DByV4T/JzilvoKQMaxXu69N67wgYUUn+ZHf8s7nOf/frOITvy2kBoW2fkoi0G3S8IS9SR2f+iuERsxy6+irQSk0nhkn9c9ASxYKN7aSThQ0hQreY8hnObnIi4jRyVIWYbzksYUwMW7EBnGpQY
 agmJ+A3z
 ttP5rV2KbW/6aWpRsrCf3w5cWsTg8l1IeseQuZ2NgPnG7d8hLe1wbQTt8u/cGZl9yYXmVbO/kNf01J+StGpoN22k02yM/BUOCYuUuYGxIi6HPu6I8qW6lYN3UlP6yjm6u9Ur6IfQbMul2Amicli0gjihy/ooVcTIby5AOsd2kqNXKAzQShav6L2Y639mr7/ixFXghTX/NtxanJbDKMo/QBQRINKJ5WiiFYKJS3667LIsB/GsCpYoTIXlBdHUrAUj2319o003x78bTgIyVzUeDfllGGV6YXA+dUBXytbkCOIhTxYjG+YF+Ax+RT4SIad89D5L0sR8tMp+FbWHoAwN5FxA5YrS+H3P95l8ho2Vz+m96VrbI5zvfRblcNcgP/Epiy/BavrYynQ6Y2SMcdBRLlh+vNpJ3jc2FKbwIyJBNGgeu2cWFSmzrdIAGXKzX5rk9RMbn0IcqaXhG6kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   53c448023185717d0ed56b5546dc2be405da92ff
commit: 5594d8bbb347972a06d703063bb65cccc8820c84 [72/77] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
config: um-randconfig-002-20250810 (https://download.01.org/0day-ci/archive/20250810/202508100304.92cGHfSj-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 3769ce013be2879bf0b329c14a16f5cb766f26ce)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250810/202508100304.92cGHfSj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508100304.92cGHfSj-lkp@intel.com/

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

