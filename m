Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86393CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DCD8E002E; Fri, 12 Sep 2025 06:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15FA8E0011; Fri, 12 Sep 2025 06:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05F48E002E; Fri, 12 Sep 2025 06:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B88838E0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:25:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59E5A86304
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:25:59 +0000 (UTC)
X-FDA: 83880217638.12.0225E61
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C07DA0017
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:25:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VqYGD+ix;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AUE4Xc3vMbnN0s7VwvODrNNZe4CHbB6V6EMkNVa455w=;
	b=MMaU1/ukIjfgFy0VZBuaCq7AJcK4hcGBxdCLm9SI4QEvxaIknyilQxp4hjY0VuTa7t4YIm
	+ZWoiNv29k4RJrY6gwH07aVe/qjBXKTlI4joU0NwD1cIFPEaLfTYO/uElcIxb1BJYlvSoO
	r9qICMsYcPi6lkujYOEasWuAFkH+buI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672757; a=rsa-sha256;
	cv=none;
	b=dDdB/XWOY0xKt6jmtRfuGlAWuY1UQSvHdWwD6LUPTeW50DQgF1mjk9p3tJ28iy9kZAmb3+
	GkfUraGGmpMhLq/2e+mzGj6IAMFD7Z36Jy1y3a4pVVVk9XWXFJGUcVVrHuTw27tDnrpWSD
	zk2HYeFEbeiFAiiITSOOct6oriwA0ik=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VqYGD+ix;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757672757; x=1789208757;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8QI+t/emV3KKiCi2m0R6qI07rQ+E75YRrrNmVz+GEn4=;
  b=VqYGD+ix1WCUWCXQZcocw2NZvgUWweTWfURZ+prBqovVyTv/eJk6j7Bh
   0LLfMqEzD9elnev/mgXCRHxW5sTARec27zfEPci4Db0LdpXx9FfmVN0VM
   WsjGL5kNvnmUNSGs5j9H9pFKwmeV8zDyXCIwMQY81+9rC9dXlujWdNq2N
   huKG+kQlIWDuEvwaCsqAbX1473SugAeFTrmqqNN+tHu63wNCOPsenSfWr
   Wn2A4+75q2cVlGRgZs2nIz+heUKaN6RLt+bbOizklk+3wDyBruz/6mEMf
   WhWiU/5CcSa2JxAJHFag2EEm2xKIivh50gZeNciASqujplTvzJupM75O3
   g==;
X-CSE-ConnectionGUID: f1fauGMZT2KEgpdRkZVW+Q==
X-CSE-MsgGUID: YLhmI02GQNackER/L7GwpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59876798"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="59876798"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 03:25:55 -0700
X-CSE-ConnectionGUID: D54g7u5bQNi3fF3uOjVgPg==
X-CSE-MsgGUID: XsLUvO5nSq6b0T8soicwvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="197621271"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 12 Sep 2025 03:25:53 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ux0yV-0000xY-01;
	Fri, 12 Sep 2025 10:25:51 +0000
Date: Fri, 12 Sep 2025 18:25:35 +0800
From: kernel test robot <lkp@intel.com>
To: Alexei Starovoitov <ast@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [vbabka-slab:slab/for-6.18/kmalloc_nolock 14/14] mm/slub.c:3866:2:
 warning: variable 'flags' is used uninitialized whenever '&&' condition is
 false
Message-ID: <202509121822.aOV6H1ts-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5C07DA0017
X-Stat-Signature: cmjhrg5umba3633iouf4xkmytaiuwmhu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757672756-960858
X-HE-Meta: U2FsdGVkX1/gOEir4trin8cIU6WNnGDEgM+RzjJ7wg9B5vO4CYFWX2XR5LpFI4Zcg/zkst/lO+4K1hcFlbKNZC7nn8pWdaYrvWoxU1UIbd6+cuhkxV/kyig7KE1GZ0JQllpmdKwPrNUJW3HbzA2Ky1qP2LpyDWRLRrK/FzCgzzg3uV5wQ3I54dofDzun2IhIhDQPvMbTEExp22I224lUylhDjib3snATXTCVeKgYXnb/I/D8b+f4fonL3tnbCMf0QQoiJqlJUhk8cCdO2Qs3QlhwGsig06Fq8ZptxfGpAyLvxKKyoHV8GkiJWJbj8Z4QIA5U5/WS87o/U32h3z6eOwvSFY6Ad5vMXNTcIPTFIAAakiZwupAcIjY3AAgxTMhfcUoyZBmVxc2gzlXcJShOTytYjuCrh6ipi8Ptud6QkCFouQ/7fpBXiR8hw9+HEKB6S6TgN12C0rXr6dynMrQojm3GNlXVUUK7WxTou6y8Q1r24R77n1m5008hL8zhzVvXJbc2j1uRoZcYx29XTjNj2FOkN/s2jlCJE2ccfNpplN4zhCYK6Z9pTmtG/WVwnW2j2Oafg0vZPkRyYy5Oi73WWuLF+vQBS0yNPqSRXTitU/bSCCqdZu0yjQveXBzaseLlDIN9/RjSk7fPG7H4xESwN22tkmIclNtMwqhmMNIyl3RTtfRxHHScklwlwQkOPZCiI+BquyGU3t6FmFCxU5GMl51yNxs9ukF/VvivU4unBbPhPg8McHDUfh3Di2z0xvQq5493GgncDOysDhOC36067kWgRh0NANhIK5bMh1iy1bq+V2vejlr+O58TPtW7dUWzAo9s12sTRh3Ltex7NJ5WB+l8gQ2xycQSLuv38MCP4U20qR5CHX+B0ePuUEvt4ztZYk7MYldt+sJgD1ikMFuTpGgENdo7n26RLBUwgE0M3Fy4+ubIBqE1vrM/XaX5uyyo9s5AgnRMeg0aOLrCMuf
 wWBSOOAR
 hR++ZGe53BPLbtCohpXjT9cggEOxOuEhsioC00kHSpcH8LM8Fc4dZF0EV2RI7bCrfra/+skTmpCkSVLDotLeysgBKS+uNeRpVBOJ30zZFhuyk6ToqcigT5HeAUTgGbgiaqwKkIQDBC2k1AFWDRqGzeYvUnE0fSFsSrqOylFeCrGNvMfJu+Jt/+z8ckcanYRHSqV8tmPttFd4KqH/ntyIBEPbVGd4gbVRaQSbx7NFxeeAMlcWHCTNXicV/3e7832pABZ4JZeqcmQ1k9b1V7P0rbpX1ne3dDq85X36ULXyVjs8GMCXuqKHc74oJw9ekRwZ/gCV58VKe96RnhUJkxjHTJe1dWYxkP6zlvUYt+1bDwXlW+wixV83JzpDbRf3dGFdClu/mWMO6l1aWNN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git slab/for-6.18/kmalloc_nolock
head:   8014922e0e72dde7684abebeab3404720401679f
commit: 8014922e0e72dde7684abebeab3404720401679f [14/14] slab: Introduce kmalloc_nolock() and kfree_nolock().
config: x86_64-buildonly-randconfig-004-20250912 (https://download.01.org/0day-ci/archive/20250912/202509121822.aOV6H1ts-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509121822.aOV6H1ts-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509121822.aOV6H1ts-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/slub.c:3866:2: warning: variable 'flags' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
    3866 |         local_lock_cpu_slab(s, flags);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/slub.c:3776:2: note: expanded from macro 'local_lock_cpu_slab'
    3776 |         lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab->lock, flags))
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/lockdep.h:279:15: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |                      ^~~~~~~~~~~
   include/asm-generic/bug.h:171:25: note: expanded from macro 'WARN_ON'
     171 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   mm/slub.c:3891:27: note: uninitialized use occurs here
    3891 |         local_unlock_cpu_slab(s, flags);
         |                                  ^~~~~
   mm/slub.c:3780:48: note: expanded from macro 'local_unlock_cpu_slab'
    3780 |         local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
         |                                                       ^~~~~
   include/linux/local_lock.h:52:48: note: expanded from macro 'local_unlock_irqrestore'
      52 |         __local_unlock_irqrestore(this_cpu_ptr(lock), flags)
         |                                                       ^~~~~
   include/linux/local_lock_internal.h:202:21: note: expanded from macro '__local_unlock_irqrestore'
     202 |                 local_irq_restore(flags);                       \
         |                                   ^~~~~
   include/linux/irqflags.h:240:61: note: expanded from macro 'local_irq_restore'
     240 | #define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
         |                                                             ^~~~~
   include/linux/irqflags.h:179:26: note: expanded from macro 'raw_local_irq_restore'
     179 |                 arch_local_irq_restore(flags);          \
         |                                        ^~~~~
   mm/slub.c:3866:2: note: remove the '&&' if its condition is always true
    3866 |         local_lock_cpu_slab(s, flags);
         |         ^
   mm/slub.c:3776:2: note: expanded from macro 'local_lock_cpu_slab'
    3776 |         lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab->lock, flags))
         |         ^
   include/linux/lockdep.h:279:15: note: expanded from macro 'lockdep_assert'
     279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
         |                      ^
   mm/slub.c:3863:21: note: initialize the variable 'flags' to silence this warning
    3863 |         unsigned long flags;
         |                            ^
         |                             = 0
   1 warning generated.


vim +3866 mm/slub.c

  3852	
  3853	/*
  3854	 * Put a slab into a partial slab slot if available.
  3855	 *
  3856	 * If we did not find a slot then simply move all the partials to the
  3857	 * per node partial list.
  3858	 */
  3859	static void put_cpu_partial(struct kmem_cache *s, struct slab *slab, int drain)
  3860	{
  3861		struct slab *oldslab;
  3862		struct slab *slab_to_put = NULL;
  3863		unsigned long flags;
  3864		int slabs = 0;
  3865	
> 3866		local_lock_cpu_slab(s, flags);
  3867	
  3868		oldslab = this_cpu_read(s->cpu_slab->partial);
  3869	
  3870		if (oldslab) {
  3871			if (drain && oldslab->slabs >= s->cpu_partial_slabs) {
  3872				/*
  3873				 * Partial array is full. Move the existing set to the
  3874				 * per node partial list. Postpone the actual unfreezing
  3875				 * outside of the critical section.
  3876				 */
  3877				slab_to_put = oldslab;
  3878				oldslab = NULL;
  3879			} else {
  3880				slabs = oldslab->slabs;
  3881			}
  3882		}
  3883	
  3884		slabs++;
  3885	
  3886		slab->slabs = slabs;
  3887		slab->next = oldslab;
  3888	
  3889		this_cpu_write(s->cpu_slab->partial, slab);
  3890	
  3891		local_unlock_cpu_slab(s, flags);
  3892	
  3893		if (slab_to_put) {
  3894			__put_partials(s, slab_to_put);
  3895			stat(s, CPU_PARTIAL_DRAIN);
  3896		}
  3897	}
  3898	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

