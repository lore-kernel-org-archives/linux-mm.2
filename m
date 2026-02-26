Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF06FD9E21
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714FC6B025D; Thu, 26 Feb 2026 18:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE826B0269; Thu, 26 Feb 2026 18:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC2D6B0278; Thu, 26 Feb 2026 18:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4586F6B025D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:15:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1C8F13AA77
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:34 +0000 (UTC)
X-FDA: 84488166588.05.E3CA209
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0610C000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZCAFbS5Z;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772147733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=He2gO7FeCtzL/4vV2XSVVirU0Z1WzkdCShcV5vmV814=;
	b=QJqZujo3wDc6B/jZVHP+cR/KmOK/tOsKVu0/+jYlEWk+mM5SXdZfuy65egsakAenT7o/ya
	TVMUJAUvIc6W0XcC802/wHwHOKQJjcJjcXuDhvrc2x2Uzpn5LceJqpEO9kymRZj382+0In
	2qXK5bzXFWTXvQIX95/Pirkljt+kIL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZCAFbS5Z;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772147733; a=rsa-sha256;
	cv=none;
	b=BQwh563ToX8+WUfuoyturL+KDsSrrLlupbs+zWaItjZEXDXlM4yhVw4sXiboF11hwQT33T
	5phJDO8O9furF0ZlY5xNCQNST0kyP7xBtxh1vw7GTCLR7hAa7kWh8834IrAyMS6YcmhDQF
	wumEaZnd3uZ4ZQQqQQOfB0Zo1Bm+Rjg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772147733; x=1803683733;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6ND260s9WILQRHkwfeaLvd30FFZogrwqcdbhvPGrCLU=;
  b=ZCAFbS5ZjTxZi3GRT3szwNn349ZkBMJ2cvLE8hfVsJJtVovXzmin9Tm/
   K/YyGQN83RvT5OeTApLP6zXe4dPxBZfJC03dM/ZMl+PHPP3yT7YFeuJp1
   V9dEUTee0XUkaLr5NQw2WTIQUfxUK7XhAVyMnNPe6u+G2EIlLI0wMcgBD
   rXrBUpPJeph6qR65SZ9/o1VDECnv3kBUIzK5SD4gJDJoBowmNO7WQ1Q61
   vbK0b0I7TGrXltK7FJxk5mnhMXaBM3vhm6Bh6y/PSywLk9/uWtFP5utOg
   rmIUHtDsuu/y9+4isQNBwKh1EvL7Eo/REFBXAFO5ZslaG5RcpF7oJLwPU
   A==;
X-CSE-ConnectionGUID: aYMIhTnqRKmPRfObcWtNMg==
X-CSE-MsgGUID: 6Tj/FrlvRCKnixKh+H6Z4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73331465"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="73331465"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:15:31 -0800
X-CSE-ConnectionGUID: 2nd7JkiIRv+7XVyRSDhPeA==
X-CSE-MsgGUID: +DW9LNsSQ6mZAAtCLcDJCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="220856206"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 26 Feb 2026 15:15:25 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvkZJ-000000009zN-0205;
	Thu, 26 Feb 2026 23:15:07 +0000
Date: Fri, 27 Feb 2026 07:13:01 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <202602270740.0RL1uwsV-lkp@intel.com>
References: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
X-Stat-Signature: tkw6fbyyuw3wfi3gcaqr9ggy9qf4fm7m
X-Rspamd-Queue-Id: C0610C000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772147732-545673
X-HE-Meta: U2FsdGVkX19/mlV4mIIdSkeQhy4CorRQ/JDkkQCcCh6IQWPgdf6OkXUX1+InfOuNJWrPuakmRqqLDa5QnJkyQOW5RCV7kCfD8KnshrvxnUZQZJq7utVkv2nuEWCQujY2FSjmwFh1ud8yVh24cOYfycH7wXluht183aAxgaOPdx9yqGEAvuQCLLDZqaz7bvI3TjXyMvAlZPdLqGsBc+Tn2EdQ/jo7f6J9kitnLneGevMIR1lZVdKmWDGpPc6IcFYzHgiRlsYaXTZ3/OeBzMcKdd60py1PwC0UUvA5jH+Rsw+HF7LcAsicjNQJU0PEr3Xwb9cfmSX5WXV7U5JRODW2g+IpRs9Pp2blHsFdzKqCAcqxY8/o3ITWqDV8k+6cstr3pOSN/AZd5HdINW/QfpPhpID0v3Sipg1WDDN55bACZXjGlrAsMxC/1D0M0M1R0nBd/4WnNgUl+TDXOmFhCQnbIzvMmRGUu1JM1in46A6fWtpbvgZcxd5HM27VoACFyQtdcTftTAOGk5A4IT2Bx07NuoGOs+xMn+2fxDFos2U1MUsnDjt2W1n2+Y85Nx3Vx2VpDh6WQikWocOIW25nEaG9BuiID8YQ1G9kbW+ypBcKScwC1iCJXhOWqdc1KE9xoSsGGFbOjkx+saG3lH/kYWA9oQLMVBU1Czr9EQYUbnjeEq8IRDA5kLeTVt9EgPSBTXx44k5YbnyBCmRGn/mRrBe5BbKtYQmeucJJtF52kTjTaoH6ZwrcgqodEMTwHOGaEdlhVIEqxqycHjz0Jro2qeun1N580bQS+/dEqcQEyCOP0dirrrh+Fls5FlsGwuiaE8woQpTfnyJTI2CQog0+6P2UZ61S0oQhGpQt5zO+hUDiFDj+XoJZOYyq/Rk6klL4nGKzENRqL4bUO1RMl1dZ9V1u0wSxArmyFNnIo7Fmgqr8grzISP8c3KhgL4CWod95y2V/KrJ512R/y+kXvcR7oJk
 5V1DZHtC
 2DYO0I9X6AohAoa6+6+kpFv//hDksFH9rRzi9BfLL7E9WBjV/znUxrZr/ztzQYJnxQ1UNod+17GYIr5CTMVDBZQQtkPlDDWN2YyRepTvWFqIcAoSYR0PcseWoEbGyJTTH9tNqzMq7R9zfYma8fScsrS+2iTMHpwA+7+9eb5fc8b2o3xrOJ+DECWpmFFwBckIGQ3QHIA22dQrSgPdZB1akl9e0YJyHm5pXJlBAyZgqdTlOhOcEEQ74IVE3Ii7kxUPitkFxlPj3qiRNBCjfbUrLx2P02OaT0kJzp/MmT2zg2UATL8C8WVcVmwwl7faccJk53CD5Qb4rJ23ON0vB8IhL5lqODNqQkkt/UE1R7fs51zB7T9HvaqCPQWRmTSls/y0dO6xgrUrvbhVfA2YjxhOO36wxCSn1eUWVMsFx0TueEpf2GjH2omJD5rTIPxAHW3m6Mai9rGlxBu0T0fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dmitry,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc1 next-20260226]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Ilvokhin/mm-introduce-zone-lock-wrappers/20260227-022914
base:   linus/master
patch link:    https://lore.kernel.org/r/1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d%40ilvokhin.com
patch subject: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20260227/202602270740.0RL1uwsV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270740.0RL1uwsV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602270740.0RL1uwsV-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/sched.h:37,
                    from include/linux/percpu.h:12,
                    from arch/x86/include/asm/msr.h:16,
                    from arch/x86/include/asm/tsc.h:11,
                    from arch/x86/include/asm/timex.h:6,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from kernel/power/snapshot.c:14:
   kernel/power/snapshot.c: In function 'mark_free_pages':
>> kernel/power/snapshot.c:1254:34: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
    1254 |         spin_lock_irqsave(&zone->lock, flags);
         |                                  ^~~~
   include/linux/spinlock.h:244:48: note: in definition of macro 'raw_spin_lock_irqsave'
     244 |                 flags = _raw_spin_lock_irqsave(lock);   \
         |                                                ^~~~
   kernel/power/snapshot.c:1254:9: note: in expansion of macro 'spin_lock_irqsave'
    1254 |         spin_lock_irqsave(&zone->lock, flags);
         |         ^~~~~~~~~~~~~~~~~
   kernel/power/snapshot.c:1287:39: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
    1287 |         spin_unlock_irqrestore(&zone->lock, flags);
         |                                       ^~~~
         |                                       _lock


vim +1254 kernel/power/snapshot.c

31a1b9d7fe768d Kefeng Wang     2023-05-16  1243  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1244  static void mark_free_pages(struct zone *zone)
31a1b9d7fe768d Kefeng Wang     2023-05-16  1245  {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1246  	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1247  	unsigned long flags;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1248  	unsigned int order, t;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1249  	struct page *page;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1250  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1251  	if (zone_is_empty(zone))
31a1b9d7fe768d Kefeng Wang     2023-05-16  1252  		return;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1253  
31a1b9d7fe768d Kefeng Wang     2023-05-16 @1254  	spin_lock_irqsave(&zone->lock, flags);
31a1b9d7fe768d Kefeng Wang     2023-05-16  1255  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1256  	max_zone_pfn = zone_end_pfn(zone);
312eca8a14c5f5 David Woodhouse 2025-04-23  1257  	for_each_valid_pfn(pfn, zone->zone_start_pfn, max_zone_pfn) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1258  		page = pfn_to_page(pfn);
31a1b9d7fe768d Kefeng Wang     2023-05-16  1259  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1260  		if (!--page_count) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1261  			touch_nmi_watchdog();
31a1b9d7fe768d Kefeng Wang     2023-05-16  1262  			page_count = WD_PAGE_COUNT;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1263  		}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1264  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1265  		if (page_zone(page) != zone)
31a1b9d7fe768d Kefeng Wang     2023-05-16  1266  			continue;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1267  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1268  		if (!swsusp_page_is_forbidden(page))
31a1b9d7fe768d Kefeng Wang     2023-05-16  1269  			swsusp_unset_page_free(page);
31a1b9d7fe768d Kefeng Wang     2023-05-16  1270  	}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1271  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1272  	for_each_migratetype_order(order, t) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1273  		list_for_each_entry(page,
31a1b9d7fe768d Kefeng Wang     2023-05-16  1274  				&zone->free_area[order].free_list[t], buddy_list) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1275  			unsigned long i;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1276  
31a1b9d7fe768d Kefeng Wang     2023-05-16  1277  			pfn = page_to_pfn(page);
31a1b9d7fe768d Kefeng Wang     2023-05-16  1278  			for (i = 0; i < (1UL << order); i++) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1279  				if (!--page_count) {
31a1b9d7fe768d Kefeng Wang     2023-05-16  1280  					touch_nmi_watchdog();
31a1b9d7fe768d Kefeng Wang     2023-05-16  1281  					page_count = WD_PAGE_COUNT;
31a1b9d7fe768d Kefeng Wang     2023-05-16  1282  				}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1283  				swsusp_set_page_free(pfn_to_page(pfn + i));
31a1b9d7fe768d Kefeng Wang     2023-05-16  1284  			}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1285  		}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1286  	}
31a1b9d7fe768d Kefeng Wang     2023-05-16  1287  	spin_unlock_irqrestore(&zone->lock, flags);
31a1b9d7fe768d Kefeng Wang     2023-05-16  1288  }
31a1b9d7fe768d Kefeng Wang     2023-05-16  1289  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

