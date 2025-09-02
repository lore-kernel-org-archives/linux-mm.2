Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAEECA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054958E0002; Tue,  2 Sep 2025 16:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004C28E0001; Tue,  2 Sep 2025 16:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35A58E0002; Tue,  2 Sep 2025 16:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83FA8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:33:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FD761403B6
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:33:11 +0000 (UTC)
X-FDA: 83845459782.17.05828FB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DABD100012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:33:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k7MXFOoG;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756845189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rR582s4KMYq71kmMjrFvHN9MuGNWDhru0y7bSnNyZs=;
	b=Fr0UYjihRFBB3OUjqfWQDO1p8xI3Bs8nW90AvtRKuZN9pJTzBfrx5sVkVI12xjtEDXy05k
	ph9M4KveSHpd3Vxfu8ITkf2/Dday0q1OSMVXbra+xEZ9otyk0gWgN+nAiz/+00qbC57WTO
	+Ufsj8una2f8nzTM+nCWfKTN4gfoWhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756845189; a=rsa-sha256;
	cv=none;
	b=8ISm8ujkr3DWm0rlATnwdqiaNhVQk/Na+ylr7jRtCxPfOYju4eeItD+2B96ow4vTo85U0M
	x9bmqAdPVQbWwOvCBR/yvBodftoMvxAcLMvyrZwIdwiy0PqgeX1MTkuFg+4Hs6SjLSImne
	JIE63HKHgXTLvyBCjuQHMIb9ABjLzY8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k7MXFOoG;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756845188; x=1788381188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GoShCcC4zkp4YyNiPnlHqVA9/MAGDmqqoiUbCVRHKDo=;
  b=k7MXFOoGqoBS/BiccjCoh2vWpsspqOr+HUcL4/baehVEmyOHKu1sl9ii
   ylAcnWMbNrtr0jOuiMHZ0ng1ZMG68ncgM9azWKudjb+z16fDvW74TU6sS
   mLgHvf3PWlTfPYG5JV/n/B14XZatl4lID+vm4sCPJHSd7sl4IoUDiP9g5
   giD8FiBUorBfiTueqY0YPxB2BlT2xJ+sosT3HkK7bAcepZwUbOXj+qDAl
   cyo+qaVLnzB877m5695pahEwpLpv/d/9jC5F0le8JB7Vrq+P08qbpYcpu
   ev6EzIjpQYUlRpOvNwPLy9NQAgGvVy89640ma/II5V8h7mzd3CI1C4/c7
   g==;
X-CSE-ConnectionGUID: SqjlkUN9Sv+zVzW3spLQQg==
X-CSE-MsgGUID: FzvkhOj7QX2SHbsiw5z/cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62970451"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62970451"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 13:33:06 -0700
X-CSE-ConnectionGUID: VxwCyw4fSY2VxTS1CCg/7w==
X-CSE-MsgGUID: xy5zL5IoT3Wdp7/aK4bZFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="170937857"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 02 Sep 2025 13:33:04 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utXgJ-00030F-0W;
	Tue, 02 Sep 2025 20:32:48 +0000
Date: Wed, 3 Sep 2025 04:31:36 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, david@redhat.com, osalvador@suse.de,
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 2/2] mm/memremap: Remove unused get_dev_pagemap()
 parameter
Message-ID: <202509030434.fEPVFkG4-lkp@intel.com>
References: <20250902051421.162498-2-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902051421.162498-2-apopple@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DABD100012
X-Stat-Signature: 8wm5arbso9st871n9wkh4mk14z6s1omg
X-Rspam-User: 
X-HE-Tag: 1756845188-889805
X-HE-Meta: U2FsdGVkX18m7xzkFztSffbZITogv1NIO73t0jiDmP/y51KOMJV+opopekrco+x/dsBTHsJyIDgfGbX1LVCfqJoiHJVOoi5tjQzwPdFhApou3kvPEsOFsPyFi+12dgzZQJNF1ed3UbvlCDH3ciQwHSYyqItPC9YhvMhyE+Sf3ZrPrucZ4v1F7z6HdR/YAt8zFe9xvuyNdqHRJ7dCocElgWhb95p89WfQF8cFgu8vhTgkqQDCpsi8h4JS5+650UwkmqEdgEWphvVI/G0Tg/brU/sBVkQF3eFJHNtBGSdvo4jAxRbmR4ziGbaVji8Vn4o/1L7QF6QYpX2UaCfVMAmogWtRjj3fXeECFqluLrGEXZnhCVqtLaiBD+j1DlrAJaElRfyWHzUrYddhA11ZrR0KBlkA+k/gTF6xygLeYFoEQC044XsqaQQweXxldgfmcT+b5N8zzq98vosJnbw4Pc3jvAQNhxVURwZVL3JmbxY8YnnECF3dnJkrVVV+K0lXDOqZLsIVjUHMpgjMv8Cd0U/o2Xlrxo7O81Jus+hBCdbyUJESf+W/QL/isU7vlBs9kJ7kyWbhhGh1nDXBJY5RrFUXBixhooxcpw4LuUqB9vO57J8/K3VsdD3v17r6yqoAqPn06mfryxkxDBFdqd2AMqV75u8KUR+KNucyYyyuoMs2Z/h7Be4l9Ssphmzpz+5zXZmesL9zBVkiGAocrJ0aHXsKrKxABT7TZ/9D38n4f+VsRB15otCZxqtXhJFeFh57+IVsBFKRFPL9pkiNtPq1k/JHX6W3u5KBm+kS/ChwtxuY+6GGoYZiQugctnzveG5rv4NBdoBZ2+/wokRsRFD0Pl46eUOpaYP8r1DVPO/Dkgo4eAbTW4oR5QPQucnEMXk2KUVBHSDXWSbfI8mDzo/PcQPdinIbSuxphSFMLYOQThpWZ6kl8wVUlrwMLpcGY3Yzl4iqY6IHka6l8lxhT3CpaJT
 R0i0KxPm
 X/8B/WLHL0JN3Ifi7cmJAxV8DYljz2DE0OADqMRAytJG2GXYClraBxZ/DIce9/2Ze0auxLgIWDYlJwpjd3Sc+Y1RZ7tguaXPA1rE0mJZdOExXME8eLD+S5ue2JXk/rJ1Fmcthqu9blloWEGqHphDy+AmaeuwCkhVWuDbL5QdE+CTDn18CcbYamjSR2XLKcSrN9EfsfNLmxvgUFpFy9fsIzMnJrutWsQMHD2nkwUhHdna1VDsI66Tu5D4lkl+gTsnd5iH7CSsS6W9s/pwdxFJMbipqaKCsucRGZ1lnVMSAjzw0FqJnfCRbQDvHLCZ2NSGkaZZvRh/YBdAyHQa4wEQO6OrCgYJYWn8LNtLKFyI3Veuw2r8JKoyTn3blTSc6Q4jRv9PDoGfZevUwakw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alistair,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Alistair-Popple/mm-memremap-Remove-unused-get_dev_pagemap-parameter/20250902-131811
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250902051421.162498-2-apopple%40nvidia.com
patch subject: [PATCH 2/2] mm/memremap: Remove unused get_dev_pagemap() parameter
config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509030434.fEPVFkG4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509030434.fEPVFkG4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509030434.fEPVFkG4-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory-failure.c: In function 'memory_failure':
>> mm/memory-failure.c:2269:33: error: too many arguments to function 'get_dev_pagemap'
    2269 |                         pgmap = get_dev_pagemap(pfn, NULL);
         |                                 ^~~~~~~~~~~~~~~
   In file included from include/linux/mm.h:33,
                    from mm/memory-failure.c:40:
   include/linux/memremap.h:236:35: note: declared here
     236 | static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
         |                                   ^~~~~~~~~~~~~~~


vim +/get_dev_pagemap +2269 mm/memory-failure.c

1a3798dececa8c Jane Chu                2024-05-24  2218  
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2219  /**
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2220   * memory_failure - Handle memory failure of a page.
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2221   * @pfn: Page Number of the corrupted page
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2222   * @flags: fine tune action taken
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2223   *
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2224   * This function is called by the low level machine check code
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2225   * of an architecture when it detects hardware memory corruption
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2226   * of a page. It tries its best to recover, which includes
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2227   * dropping pages, killing processes etc.
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2228   *
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2229   * The function is primarily of use for corruptions that
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2230   * happen outside the current execution context (e.g. when
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2231   * detected by a background scrubber)
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2232   *
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2233   * Must run in process context (e.g. a work queue) with interrupts
5885c6a62533cb Miaohe Lin              2023-07-11  2234   * enabled and no spinlocks held.
d1fe111fb62a1c luofei                  2022-03-22  2235   *
d2734f044f8483 Shuai Xue               2025-03-12  2236   * Return:
d2734f044f8483 Shuai Xue               2025-03-12  2237   *   0             - success,
d2734f044f8483 Shuai Xue               2025-03-12  2238   *   -ENXIO        - memory not managed by the kernel
d2734f044f8483 Shuai Xue               2025-03-12  2239   *   -EOPNOTSUPP   - hwpoison_filter() filtered the error event,
d2734f044f8483 Shuai Xue               2025-03-12  2240   *   -EHWPOISON    - the page was already poisoned, potentially
d2734f044f8483 Shuai Xue               2025-03-12  2241   *                   kill process,
d2734f044f8483 Shuai Xue               2025-03-12  2242   *   other negative values - failure.
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2243   */
83b57531c58f41 Eric W. Biederman       2017-07-09  2244  int memory_failure(unsigned long pfn, int flags)
6a46079cf57a7f Andi Kleen              2009-09-16  2245  {
6a46079cf57a7f Andi Kleen              2009-09-16  2246  	struct page *p;
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2247) 	struct folio *folio;
6100e34b2526e1 Dan Williams            2018-07-13  2248  	struct dev_pagemap *pgmap;
171936ddaf97e6 Tony Luck               2021-06-24  2249  	int res = 0;
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2250  	unsigned long page_flags;
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2251  	bool retry = true;
405ce051236cc6 Naoya Horiguchi         2022-04-21  2252  	int hugetlb = 0;
6a46079cf57a7f Andi Kleen              2009-09-16  2253  
6a46079cf57a7f Andi Kleen              2009-09-16  2254  	if (!sysctl_memory_failure_recovery)
83b57531c58f41 Eric W. Biederman       2017-07-09  2255  		panic("Memory failure on page %lx", pfn);
6a46079cf57a7f Andi Kleen              2009-09-16  2256  
03b122da74b22f Tony Luck               2021-10-26  2257  	mutex_lock(&mf_mutex);
03b122da74b22f Tony Luck               2021-10-26  2258  
67f22ba7750f94 zhenwei pi              2022-06-15  2259  	if (!(flags & MF_SW_SIMULATED))
67f22ba7750f94 zhenwei pi              2022-06-15  2260  		hw_memory_failure = true;
67f22ba7750f94 zhenwei pi              2022-06-15  2261  
96c804a6ae8c59 David Hildenbrand       2019-10-18  2262  	p = pfn_to_online_page(pfn);
96c804a6ae8c59 David Hildenbrand       2019-10-18  2263  	if (!p) {
03b122da74b22f Tony Luck               2021-10-26  2264  		res = arch_memory_failure(pfn, flags);
03b122da74b22f Tony Luck               2021-10-26  2265  		if (res == 0)
03b122da74b22f Tony Luck               2021-10-26  2266  			goto unlock_mutex;
03b122da74b22f Tony Luck               2021-10-26  2267  
96c804a6ae8c59 David Hildenbrand       2019-10-18  2268  		if (pfn_valid(pfn)) {
96c804a6ae8c59 David Hildenbrand       2019-10-18 @2269  			pgmap = get_dev_pagemap(pfn, NULL);
d51b68469bc780 Miaohe Lin              2023-07-01  2270  			put_ref_page(pfn, flags);
03b122da74b22f Tony Luck               2021-10-26  2271  			if (pgmap) {
03b122da74b22f Tony Luck               2021-10-26  2272  				res = memory_failure_dev_pagemap(pfn, flags,
96c804a6ae8c59 David Hildenbrand       2019-10-18  2273  								 pgmap);
03b122da74b22f Tony Luck               2021-10-26  2274  				goto unlock_mutex;
03b122da74b22f Tony Luck               2021-10-26  2275  			}
96c804a6ae8c59 David Hildenbrand       2019-10-18  2276  		}
96f96763de26d6 Kefeng Wang             2022-07-26  2277  		pr_err("%#lx: memory outside kernel control\n", pfn);
03b122da74b22f Tony Luck               2021-10-26  2278  		res = -ENXIO;
03b122da74b22f Tony Luck               2021-10-26  2279  		goto unlock_mutex;
6a46079cf57a7f Andi Kleen              2009-09-16  2280  	}
6a46079cf57a7f Andi Kleen              2009-09-16  2281  
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2282  try_again:
405ce051236cc6 Naoya Horiguchi         2022-04-21  2283  	res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
405ce051236cc6 Naoya Horiguchi         2022-04-21  2284  	if (hugetlb)
171936ddaf97e6 Tony Luck               2021-06-24  2285  		goto unlock_mutex;
171936ddaf97e6 Tony Luck               2021-06-24  2286  
6a46079cf57a7f Andi Kleen              2009-09-16  2287  	if (TestSetPageHWPoison(p)) {
47af12bae17f99 Aili Yao                2021-06-24  2288  		res = -EHWPOISON;
a3f5d80ea401ac Naoya Horiguchi         2021-06-28  2289  		if (flags & MF_ACTION_REQUIRED)
a3f5d80ea401ac Naoya Horiguchi         2021-06-28  2290  			res = kill_accessing_process(current, pfn, flags);
f361e2462e8ccc Naoya Horiguchi         2022-04-28  2291  		if (flags & MF_COUNT_INCREASED)
f361e2462e8ccc Naoya Horiguchi         2022-04-28  2292  			put_page(p);
b8b9488d50b715 Jane Chu                2024-05-24  2293  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
171936ddaf97e6 Tony Luck               2021-06-24  2294  		goto unlock_mutex;
6a46079cf57a7f Andi Kleen              2009-09-16  2295  	}
6a46079cf57a7f Andi Kleen              2009-09-16  2296  
6a46079cf57a7f Andi Kleen              2009-09-16  2297  	/*
6a46079cf57a7f Andi Kleen              2009-09-16  2298  	 * We need/can do nothing about count=0 pages.
6a46079cf57a7f Andi Kleen              2009-09-16  2299  	 * 1) it's a free page, and therefore in safe hand:
9cf2819159d5a3 Miaohe Lin              2022-08-30  2300  	 *    check_new_page() will be the gate keeper.
761ad8d7c7b548 Naoya Horiguchi         2017-07-10  2301  	 * 2) it's part of a non-compound high order page.
6a46079cf57a7f Andi Kleen              2009-09-16  2302  	 *    Implies some kernel user: cannot stop them from
6a46079cf57a7f Andi Kleen              2009-09-16  2303  	 *    R/W the page; let's pray that the page has been
6a46079cf57a7f Andi Kleen              2009-09-16  2304  	 *    used and will be freed some time later.
6a46079cf57a7f Andi Kleen              2009-09-16  2305  	 * In fact it's dangerous to directly bump up page count from 0,
1c4c3b99c03d3e Jiang Biao              2018-08-21  2306  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
6a46079cf57a7f Andi Kleen              2009-09-16  2307  	 */
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2308  	if (!(flags & MF_COUNT_INCREASED)) {
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2309  		res = get_hwpoison_page(p, flags);
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2310  		if (!res) {
8d22ba1b74aa94 Wu Fengguang            2009-12-16  2311  			if (is_free_buddy_page(p)) {
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2312  				if (take_page_off_buddy(p)) {
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2313  					page_ref_inc(p);
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2314  					res = MF_RECOVERED;
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2315  				} else {
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2316  					/* We lost the race, try again */
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2317  					if (retry) {
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2318  						ClearPageHWPoison(p);
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2319  						retry = false;
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2320  						goto try_again;
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2321  					}
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2322  					res = MF_FAILED;
a8b2c2ce89d4e0 Oscar Salvador          2020-12-14  2323  				}
b66d00dfebe79e Kefeng Wang             2022-10-21  2324  				res = action_result(pfn, MF_MSG_BUDDY, res);
8d22ba1b74aa94 Wu Fengguang            2009-12-16  2325  			} else {
b66d00dfebe79e Kefeng Wang             2022-10-21  2326  				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
8d22ba1b74aa94 Wu Fengguang            2009-12-16  2327  			}
171936ddaf97e6 Tony Luck               2021-06-24  2328  			goto unlock_mutex;
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2329  		} else if (res < 0) {
b8b9488d50b715 Jane Chu                2024-05-24  2330  			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2331  			goto unlock_mutex;
0ed950d1f28142 Naoya Horiguchi         2021-06-28  2332  		}
6a46079cf57a7f Andi Kleen              2009-09-16  2333  	}
6a46079cf57a7f Andi Kleen              2009-09-16  2334  
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2335) 	folio = page_folio(p);
9b0ab153d76972 Jane Chu                2024-05-24  2336  
9b0ab153d76972 Jane Chu                2024-05-24  2337  	/* filter pages that are protected from hwpoison test by users */
9b0ab153d76972 Jane Chu                2024-05-24  2338  	folio_lock(folio);
9b0ab153d76972 Jane Chu                2024-05-24  2339  	if (hwpoison_filter(p)) {
9b0ab153d76972 Jane Chu                2024-05-24  2340  		ClearPageHWPoison(p);
9b0ab153d76972 Jane Chu                2024-05-24  2341  		folio_unlock(folio);
9b0ab153d76972 Jane Chu                2024-05-24  2342  		folio_put(folio);
9b0ab153d76972 Jane Chu                2024-05-24  2343  		res = -EOPNOTSUPP;
9b0ab153d76972 Jane Chu                2024-05-24  2344  		goto unlock_mutex;
9b0ab153d76972 Jane Chu                2024-05-24  2345  	}
9b0ab153d76972 Jane Chu                2024-05-24  2346  	folio_unlock(folio);
9b0ab153d76972 Jane Chu                2024-05-24  2347  
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2348) 	if (folio_test_large(folio)) {
eac96c3efdb593 Yang Shi                2021-10-28  2349  		/*
eac96c3efdb593 Yang Shi                2021-10-28  2350  		 * The flag must be set after the refcount is bumped
eac96c3efdb593 Yang Shi                2021-10-28  2351  		 * otherwise it may race with THP split.
eac96c3efdb593 Yang Shi                2021-10-28  2352  		 * And the flag can't be set in get_hwpoison_page() since
eac96c3efdb593 Yang Shi                2021-10-28  2353  		 * it is called by soft offline too and it is just called
5885c6a62533cb Miaohe Lin              2023-07-11  2354  		 * for !MF_COUNT_INCREASED.  So here seems to be the best
eac96c3efdb593 Yang Shi                2021-10-28  2355  		 * place.
eac96c3efdb593 Yang Shi                2021-10-28  2356  		 *
eac96c3efdb593 Yang Shi                2021-10-28  2357  		 * Don't need care about the above error handling paths for
eac96c3efdb593 Yang Shi                2021-10-28  2358  		 * get_hwpoison_page() since they handle either free page
eac96c3efdb593 Yang Shi                2021-10-28  2359  		 * or unhandlable page.  The refcount is bumped iff the
eac96c3efdb593 Yang Shi                2021-10-28  2360  		 * page is a valid handlable page.
eac96c3efdb593 Yang Shi                2021-10-28  2361  		 */
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2362) 		folio_set_has_hwpoisoned(folio);
1a3798dececa8c Jane Chu                2024-05-24  2363  		if (try_to_split_thp_page(p, false) < 0) {
1a3798dececa8c Jane Chu                2024-05-24  2364  			res = -EHWPOISON;
1a3798dececa8c Jane Chu                2024-05-24  2365  			kill_procs_now(p, pfn, flags, folio);
1a3798dececa8c Jane Chu                2024-05-24  2366  			put_page(p);
1a3798dececa8c Jane Chu                2024-05-24  2367  			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
171936ddaf97e6 Tony Luck               2021-06-24  2368  			goto unlock_mutex;
5d1fd5dc877bc1 Naoya Horiguchi         2020-10-15  2369  		}
415c64c1453aa2 Naoya Horiguchi         2015-06-24  2370  		VM_BUG_ON_PAGE(!page_count(p), p);
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2371) 		folio = page_folio(p);
415c64c1453aa2 Naoya Horiguchi         2015-06-24  2372  	}
415c64c1453aa2 Naoya Horiguchi         2015-06-24  2373  
e43c3afb367112 Wu Fengguang            2009-09-29  2374  	/*
e43c3afb367112 Wu Fengguang            2009-09-29  2375  	 * We ignore non-LRU pages for good reasons.
e43c3afb367112 Wu Fengguang            2009-09-29  2376  	 * - PG_locked is only well defined for LRU pages and a few others
48c935ad88f5be Kirill A. Shutemov      2016-01-15  2377  	 * - to avoid races with __SetPageLocked()
e43c3afb367112 Wu Fengguang            2009-09-29  2378  	 * - to avoid races with __SetPageSlab*() (and more non-atomic ops)
e43c3afb367112 Wu Fengguang            2009-09-29  2379  	 * The check (unnecessarily) ignores LRU pages being isolated and
e43c3afb367112 Wu Fengguang            2009-09-29  2380  	 * walked by the page reclaim code, however that's not a big loss.
e43c3afb367112 Wu Fengguang            2009-09-29  2381  	 */
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2382) 	shake_folio(folio);
e43c3afb367112 Wu Fengguang            2009-09-29  2383  
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2384) 	folio_lock(folio);
847ce401df392b Wu Fengguang            2009-12-16  2385  
f37d4298aa7f8b Andi Kleen              2014-08-06  2386  	/*
75ee64b3c9a969 Miaohe Lin              2022-03-22  2387  	 * We're only intended to deal with the non-Compound page here.
8a78882dac1c8c Miaohe Lin              2024-07-08  2388  	 * The page cannot become compound pages again as folio has been
8a78882dac1c8c Miaohe Lin              2024-07-08  2389  	 * splited and extra refcnt is held.
f37d4298aa7f8b Andi Kleen              2014-08-06  2390  	 */
8a78882dac1c8c Miaohe Lin              2024-07-08  2391  	WARN_ON(folio_test_large(folio));
f37d4298aa7f8b Andi Kleen              2014-08-06  2392  
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2393  	/*
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2394  	 * We use page flags to determine what action should be taken, but
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2395  	 * the flags can be modified by the error containment action.  One
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2396  	 * example is an mlocked page, where PG_mlocked is cleared by
4d8f7418e8ba36 David Hildenbrand       2023-12-20  2397  	 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
4d8f7418e8ba36 David Hildenbrand       2023-12-20  2398  	 * status correctly, we save a copy of the page flags at this time.
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2399  	 */
378d05afc7b1bd Matthew Wilcox (Oracle  2025-08-05  2400) 	page_flags = folio->flags.f;
524fca1e7356f8 Naoya Horiguchi         2013-02-22  2401  
e8675d291ac007 yangerkun               2021-06-15  2402  	/*
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2403) 	 * __munlock_folio() may clear a writeback folio's LRU flag without
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2404) 	 * the folio lock. We need to wait for writeback completion for this
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2405) 	 * folio or it may trigger a vfs BUG while evicting inode.
e8675d291ac007 yangerkun               2021-06-15  2406  	 */
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2407) 	if (!folio_test_lru(folio) && !folio_test_writeback(folio))
0bc1f8b0682caa Chen Yucong             2014-07-02  2408  		goto identify_page_state;
0bc1f8b0682caa Chen Yucong             2014-07-02  2409  
6edd6cc66201e0 Naoya Horiguchi         2014-06-04  2410  	/*
6edd6cc66201e0 Naoya Horiguchi         2014-06-04  2411  	 * It's very difficult to mess with pages currently under IO
6edd6cc66201e0 Naoya Horiguchi         2014-06-04  2412  	 * and in many cases impossible, so we just avoid it here.
6edd6cc66201e0 Naoya Horiguchi         2014-06-04  2413  	 */
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2414) 	folio_wait_writeback(folio);
6a46079cf57a7f Andi Kleen              2009-09-16  2415  
6a46079cf57a7f Andi Kleen              2009-09-16  2416  	/*
6a46079cf57a7f Andi Kleen              2009-09-16  2417  	 * Now take care of user space mappings.
6ffcd825e7d041 Matthew Wilcox (Oracle  2022-06-28  2418) 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
6a46079cf57a7f Andi Kleen              2009-09-16  2419  	 */
03468a0f52893b Matthew Wilcox (Oracle  2024-04-12  2420) 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
b8b9488d50b715 Jane Chu                2024-05-24  2421  		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
171936ddaf97e6 Tony Luck               2021-06-24  2422  		goto unlock_page;
1668bfd5be9d8a Wu Fengguang            2009-12-16  2423  	}
6a46079cf57a7f Andi Kleen              2009-09-16  2424  
6a46079cf57a7f Andi Kleen              2009-09-16  2425  	/*
6a46079cf57a7f Andi Kleen              2009-09-16  2426  	 * Torn down by someone else?
6a46079cf57a7f Andi Kleen              2009-09-16  2427  	 */
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2428) 	if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2429) 	    folio->mapping == NULL) {
b66d00dfebe79e Kefeng Wang             2022-10-21  2430  		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
171936ddaf97e6 Tony Luck               2021-06-24  2431  		goto unlock_page;
6a46079cf57a7f Andi Kleen              2009-09-16  2432  	}
6a46079cf57a7f Andi Kleen              2009-09-16  2433  
0bc1f8b0682caa Chen Yucong             2014-07-02  2434  identify_page_state:
0348d2ebec9b00 Naoya Horiguchi         2017-07-10  2435  	res = identify_page_state(pfn, p, page_flags);
ea6d0630100b28 Naoya Horiguchi         2021-06-24  2436  	mutex_unlock(&mf_mutex);
ea6d0630100b28 Naoya Horiguchi         2021-06-24  2437  	return res;
171936ddaf97e6 Tony Luck               2021-06-24  2438  unlock_page:
5dba5c356ab3bb Matthew Wilcox (Oracle  2024-04-12  2439) 	folio_unlock(folio);
171936ddaf97e6 Tony Luck               2021-06-24  2440  unlock_mutex:
171936ddaf97e6 Tony Luck               2021-06-24  2441  	mutex_unlock(&mf_mutex);
6a46079cf57a7f Andi Kleen              2009-09-16  2442  	return res;
6a46079cf57a7f Andi Kleen              2009-09-16  2443  }
cd42f4a3b2b1c4 Tony Luck               2011-12-15  2444  EXPORT_SYMBOL_GPL(memory_failure);
847ce401df392b Wu Fengguang            2009-12-16  2445  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

