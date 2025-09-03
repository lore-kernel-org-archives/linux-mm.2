Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E56CA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AD18E0002; Wed,  3 Sep 2025 05:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951EA8E0001; Wed,  3 Sep 2025 05:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E568E0002; Wed,  3 Sep 2025 05:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799358E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:49:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 303EC1605BF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:49:47 +0000 (UTC)
X-FDA: 83847467214.15.421A107
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75B354000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:49:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SzCNvlWP;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756892985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YowusOh1NaQhVWWnc2mrVgxHxXmTDjL2XGUpyxgytsA=;
	b=2X4OW1Fz0LIBB6bLGtEVKZAhyAaYBtIdpszeeMI9TyyYkD6P7qsD2kwmOKfsSB+Hq+kOsA
	9yzngg408mffNWLcbk2khV6F+oznqg9bYcFBt8uD9QeCoS8KZf3DuMXl+2w93F2JuAsvHr
	LqVq0r6Ph0SlC6l0Ebd9wxkKmNV/EEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756892985; a=rsa-sha256;
	cv=none;
	b=79Av3KaDrumXyvrrwgbD7KQOishnkXh78swsXFRM93Fa4yxcGdaUYu2jxqg22dOvCt7Hjx
	YsUcyxSYJKGed8vpwjUp1qNUt/RUIztHJfc146yVlSmArZs6CzI5p/0FLqWnS0pWUj3SG0
	OVaw3YGukrWIvD2m/ty8zoogLodlgsw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SzCNvlWP;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756892984; x=1788428984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/GXQxrq4olsaQZF0tYUyMIdCmN1wPnFvKRAgcOdpAvM=;
  b=SzCNvlWP3ZzXkjkrCmg77g+n9vuXdMwlQ6PjViwmA4/9RfIyVNmg1wd5
   9cSHW1Hs6Pv2oTnTxMvWQoKemu/kSWQCiXKAL3oWnXpBq+/Jj+TL7YElu
   bLonDy9ZPPAQGdYpYob8u8rD9uULrfzTJsVNm+mgnfsd7ER95Dxjqs7iv
   tK5mLQeGaPNgLo2PYSAfl2BZEXP6zpv6AmhUV3uSrKN+pit1NWusXpr3x
   pHWTsfqpKslnSSTaI5A5bBSYgTkIePiaZdsRiP/7Xxic1ScbJVhqIWWl5
   Og+U6l/YzRtn49CgNjR26SlICaGY6/Jt++Cm5kUXwvvMP+5YD+Xc8ypQc
   A==;
X-CSE-ConnectionGUID: z4h+jp5gTHaxKEB8g0RAbQ==
X-CSE-MsgGUID: 5TTN0CUYS0ewRb3rFjjcfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="46774659"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="46774659"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:49:42 -0700
X-CSE-ConnectionGUID: pySSvOT5SSeshVvcZ+dbcw==
X-CSE-MsgGUID: ecH8QOpuQ46rlnkuzuD9Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="172006550"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 03 Sep 2025 02:49:35 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utk6m-0003il-0P;
	Wed, 03 Sep 2025 09:49:09 +0000
Date: Wed, 3 Sep 2025 17:47:35 +0800
From: kernel test robot <lkp@intel.com>
To: Yueyang Pan <pyyjason@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <202509031744.HcibSETe-lkp@intel.com>
References: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75B354000A
X-Stat-Signature: 4kfy6rxqttt3rkahgqrwn6u4fmfbi3xt
X-Rspam-User: 
X-HE-Tag: 1756892984-791940
X-HE-Meta: U2FsdGVkX1/MBhrJGeLfWe0B6uslLoGbcAcP+74XfMveDC+6kRAYLa0TOR+xsZ0Jw9jEZYNVpIIxqZZrOMFRKoIdfr/xzrD6iYFh7JKyYdTenDmfRcjvNvLhAd/8EbL86JsMXV+fS9qGjpTzvluMaFId/rsrTlbithWn/glOeA/VFd69WumiudsvR0ipuEm4UpZUiUEm5QidG/RIwzn2iwsDSr7tFGP8ugXLhQtcf96s5IpqkqpRlsnBSMvJ4XmIh+c3SQGwmPsumMrPz0gLfYD5EoFnfXNuRqtCzpQGbXsGz9wBDvPCZYkgrM1S19Un5nJZ7YZzMBtvwVSKehka/O9HkusSbDAlDTGUzqL0hXygi5lXceaHzkD2TVOOUc3lOLSBWe8eZs3kwDaxfo0XoPPQD7vc7FtGEnsPqDlGTG91n8rbrrwQ20rhFJufJds4N1xnenF2yYAtRNhplk0PpkedZD5M/kotOnA2kB7rghTXIcBzbiDcvJhQB8zoJBv+s5q6oCPbtlqQwIP3xHZEDD6qbo7ZdZlsjycpQYuTnB/KI5/anJ2ORF71+oy/G6X6buqINXtY3/DI/Ri1c+2x60O1C3r9ofZByiMpbe6KcadwaQCWeiJsDDjnxJVrUDVQiAsWXhx++bl1H0tGaKUnRXjYv5QxWox36O4Wd0ny+q9W9HUi4t3iaGrEcOiiOk36HaxADcqyKubNAHzkm1ptpFICGLKd421y+CZlM5NEG/p+HLG7RH6SPSPAagWD0Xm/AYRYs/552RZ672a0XonvB7LH9NMk3/amLtNEns2PM9MsnOPtOYFPLZeLNmIAFX9H9l3HjyfUZwjde59aBCwq2vWsByt6EAU9C7majrPGTmOgPVphDwHtHvrKWVbm23IEMbOD0uNXzuErp+EzPWir6CgM4DJxosaSBzYSyH+YvnxjtHFjacnpzUB9kTiu+/44sZsOgbtvvuqCtsXBwd7
 pbwgXLc9
 GW2VTBZsb34W5M4dbYTk8D/wd2NGNKIlAHVb6rJGEzlNpcBEDoNMi2nZhkzvUONpYyx8ddeKJQiT4otUllI241Tnl9JKQ+/mJwNl0FQLMgMkxoXI4plCXDWw6SVgFlDOzDM/yEqzjNqM1h89YQkIc37V9I6k9hm7pVNOqY7uFMUDdDga2U0mUcsuqYa5DZqOj73MKMoWbMGT41T3I1ZU5a2H/HtooiLfzVwEq5MuY6wNaAuSXZWq8fGT155i0w4Pp3209Oje2/UllJWmXF0MCPgKJwR3uhn2eeyYBHOH55MbwHxNPMXACZNeNhz8Jr7apaSeCciTISQUQ+Uwy93gMCjiZy6gjUBQ8NgTKyjx6AtXEG0k2veQzwt3u8kkXgOd1HQr6LmueKVwtFRI/rnZ3G6Yqkrmu/thsIv1y98w9sLgtfugQ+pcMIYqqBoPMVRFm2GsGsrlmcfo+uMAPgNVwIytguw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yueyang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yueyang-Pan/mm-show_mem-Dump-the-status-of-the-mem-alloc-profiling-before-printing/20250903-000616
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason%40gmail.com
patch subject: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509031744.HcibSETe-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/show_mem.c:18:
   mm/show_mem.c: In function 'show_free_areas':
   mm/show_mem.c:336:49: error: 'NR_ZSPAGES' undeclared (first use in this function); did you mean 'NR_STATS'?
     336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
         |                                                 ^~~~~~~~~~
   mm/internal.h:560:16: note: in definition of macro 'K'
     560 | #define K(x) ((x) << (PAGE_SHIFT-10))
         |                ^
   include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   mm/show_mem.c:298:17: note: in expansion of macro 'printk'
     298 |                 printk(KERN_CONT
         |                 ^~~~~~
   mm/show_mem.c:336:49: note: each undeclared identifier is reported only once for each function it appears in
     336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
         |                                                 ^~~~~~~~~~
   mm/internal.h:560:16: note: in definition of macro 'K'
     560 | #define K(x) ((x) << (PAGE_SHIFT-10))
         |                ^
   include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   mm/show_mem.c:298:17: note: in expansion of macro 'printk'
     298 |                 printk(KERN_CONT
         |                 ^~~~~~
   In file included from include/linux/spinlock.h:89,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/blkdev.h:9,
                    from mm/show_mem.c:8:
   mm/show_mem.c: In function '__show_mem':
>> mm/show_mem.c:399:32: warning: unused variable 'mem_alloc_profiling_spinlock' [-Wunused-variable]
     399 |         static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/spinlock_types.h:43:44: note: in definition of macro 'DEFINE_SPINLOCK'
      43 | #define DEFINE_SPINLOCK(x)      spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
         |                                            ^


vim +/mem_alloc_profiling_spinlock +399 mm/show_mem.c

   396	
   397	void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
   398	{
 > 399		static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

