Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D517D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 20:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939336B0008; Fri, 28 Nov 2025 15:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9108C6B00A4; Fri, 28 Nov 2025 15:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DEA6B00A6; Fri, 28 Nov 2025 15:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 753E86B0008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:20:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15ED514070F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:20:40 +0000 (UTC)
X-FDA: 84161133840.14.172DF50
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6546D14000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:20:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TUMIuXIZ;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764361238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iPnRNj++vcRWa52YY3DuBiJxF01RJGsbnLdE1dYQytI=;
	b=58ogAUw/uHTouXZSzmxcOkQz61n87CDUaF1/YGR7V0aLNk/WjZS6ILWPu2PIDWiKEN5+tT
	qf9xuZskaBY1ZSAffV2PbJbmA+TU61CGiJkxY5Qzk++CbaTp8sjCN5qAOvZkLsdFMFanOF
	O+PJzcz3BuN2p/YncTi+0qdP23PPJRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764361238; a=rsa-sha256;
	cv=none;
	b=KH2nY+vCDwCADAhyvIv6+f7tc3W/DNq2J0ZPOT+NRAq1sM3MVFyWxiVHzLl1vHtMY5VBn7
	RC1zgXhdw2ENo86hpWxrCfLwXO9+56PxacJD2pcV9vMOKSx79WuVj84YSZbz5yyEjLCthc
	lXv+NyWbRremLITWlgVhWp0luVVEY98=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TUMIuXIZ;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764361238; x=1795897238;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vlNkjDYPkjDG2/TX24KjNq54SaEAHnvr5q+zY+jFnSk=;
  b=TUMIuXIZzsI6h+LP1fClYPKWIGp32Yvy0cxUdnILYoBLVGiZkSn5kYlh
   WK+wP3RE4vYcL6prZnp2AGQhdbjFPvb5Sc3L6JrPTV9C0JbGFyRzcxTMR
   /n12TofgBFd0z2g5GH8XhlC1o9uZ73MDwigMwufjWh2ZXEAyddeimm7e0
   vZQ+8olGUTjhe8mC/WZAt9ApnxFnVCN480v3S416UfR2xZDNPNS/3zksV
   1X/vNG8PajPEgpS/pfVam11xg+Jw9jZBRF3bhM1FDhuX/v9Khsc6YaCNG
   TRVVBzXf28edjMeeyx67L9Fzpycs1HeKSglH21W7krOvk/YjDaXjEAhEI
   w==;
X-CSE-ConnectionGUID: gIY7odb7QPqbeynojmOF7Q==
X-CSE-MsgGUID: HdWkIty8S4arvcDS7EL9sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11627"; a="77496304"
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="77496304"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 12:20:36 -0800
X-CSE-ConnectionGUID: ikrDBOkOQtaO7PRi6aTyPQ==
X-CSE-MsgGUID: B93q81DKTa2TG3mdScXODg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="198637136"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 28 Nov 2025 12:20:33 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vP4xD-000000006iz-3NTo;
	Fri, 28 Nov 2025 20:20:31 +0000
Date: Sat, 29 Nov 2025 04:20:01 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: arch/um/include/asm/kasan.h:29:2: error: UML does not work in
 KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202511290451.x9GZVJ1l-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 6546D14000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: kukqg4tytso9a3nfpuzisbtqih916scg
X-HE-Tag: 1764361237-69749
X-HE-Meta: U2FsdGVkX1+sLIY/qkVHEqtFgFka0RiuRIn/h0tp7cpPNot8/sGCmzMd/f+PZBjaXaJ1Of7Rc9GQ0rezmZAXk8dxIzYxuAEJBYrREoea4gj40b7CGpNE9geIR6L//i0BDYFlIzlW29oBbTwnunvufLbqHVM7xDw1ztBWGQfnYHl4FtJHwPI+PWpkPmO1+OfZ/CjsuSaaIK7l1Qw+DpVp7ibX4W9csUXmZiUnD27YLfJvgwqdp7XkW8yxO2vvNO/SAXiXIhQT/GmXpYywv6UoCn/Et1oalaUe3Sc3LEHoEXSobh3iNvUADaTwmlzGrNzSHC/hnxriddpS1QrYCJ0So4dK3wBJrkNxovi7/kkzzzGCR0j5WgEz2s5ppam4YsncP9Yh68VKNbKGIb+4vXXg5d+o/iLgWiR4Ec4Eqm+8BZLxwaX/5wAcKyolzQk27Y6bd+H8xJpy0zhngwjcN3y4qlRWGxdd1h0YBcfN/fQv7Yr4N2LBekzY3aTm+LPfpN4ndJojx+dtKxc22NFUiCfd6Vk9UF5vjqYQrbgqxTXVfanU1ylleu16kK0XwdtdJCb3lVNljFokmckRv31Q45rYtvnz5vOwAqohnz6mIi0+ItrhgXXcyP72ku37gfwSOFqbbkLps+vqF4n3XW4aaiFt9cjErdXSGA3kITD8udfaROEQJxx88IICUk+M678Kw/a4sbIZjyXDr7FTaWBseOLODyt8e7HJ6WK6qreafvIvMA1rYwHamhZEW8P4Kr72TqAGr+xhHQ5n372GMiR6/Rn8w+w8RRIxOUXN9qXa/vJ7V0Fo5CrsGb23EzFfwxGAmOoluZRwx3QLCUJ9TINwHcDy1SipmwAWK+BYk1Xx+ijS1VvJrElfJod5HHEa9C+TiCwmOyo9VYwWEhro7uGTIdqVgXgTV3RfB6YNzZLbOnryoWlDekoDIn0YrZnjr8McvNbpu5MsNJii7hOQRmjFmvP
 gVxUNNky
 YxdTOjHlEwZSP6qxCrPKQKwRPjqzaVefjZyHqBmzdgoL1W53zx23GrIESXklcDYp/5U8C1AlUyC0857u+b8ZGLvqb1/28QjDXKDhHfas+SfHtJX+WHlkDU/uroRA/EvsXFmRC5bFTbyRlNmeJILkUBLVJsMSPxo4O/pNs3jFTHGqzEGfF77BrgxhuX9W8cmH6QE6RYqadDBeM92le9fwtkTo+VtuMMr2Gx4SUaWqCGA54DuzDbTw45H+WYhGQb8ouseIB/v+SeXFYAGiE5ws/zB7ixFhYplBKAamJOl0jgH7CN9hFry4D4bHXKavDK3DMRIvcN0huWK/eKWGYat6MTxOepG5PKpC6HymPvvXzgDPPKUzjyLb7VFFPQ5OgVYimSpONSaMi1I/b4majRWHA9e01rnfhEJ++JCX9MupaIWaRCb0WJ2kCSZDIkRiejLQj+rthCexzBEpmIpnl01oTxXXASNyB5sorevXts8N89OPAyvY0NeExADW1uMa2ouN/X0f4J3KU78dpOjw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sabyrzhan,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   6cf62f0174de64e4161e301bb0ed52e198ce25dc
commit: 1e338f4d99e6814ede16bad1db1cc463aad8032c kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
date:   10 weeks ago
config: um-randconfig-r063-20251129 (https://download.01.org/0day-ci/archive/20251129/202511290451.x9GZVJ1l-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project b3428bb966f1de8aa48375ffee0eba04ede133b7)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251129/202511290451.x9GZVJ1l-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511290451.x9GZVJ1l-lkp@intel.com/

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

