Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C6AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8026B00B4; Tue, 21 Jul 2026 04:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FEE6B00B6; Tue, 21 Jul 2026 04:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71E16B00B7; Tue, 21 Jul 2026 04:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 831C16B00B4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:35:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 007DDC03E3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:35:21 +0000 (UTC)
X-FDA: 85012124484.07.3DB5A35
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B87820004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:35:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFCR2Py6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NDvVHc97SxCTMlSq308UdziivYBuYgTcm16PGR32mC4=;
	b=2gLJC9bFsG1voPpQOK9pD39UJ8iM6StqS2/cbaX+pUJNFWLM078chHQG4yenlVVYfkHALV
	Zbzz47t9NNgvSmg6/e4wAo7DopNgJY3RLfL5EDKIKnLCA0H1wwilRiXs/oruMC9mDbL+79
	9WnweBcNUkXReJZZZ83xDJ8Qa6Aym6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622920;
	b=rupbESgnTMAsoDHlMvBVfMuT9+yo0Hb7RN6IjkFHOCpdnn0KIXACbJCtFYcGWDTyewIe4R
	YtEQhRhVOZLgdHVqLhpVVrqMbroXanLw7DC9D6rq7EHOFHJ8LxSvzSpeRFZsCkVfBmvC/n
	MCVZ9ADioP7V9n1NCdHipwrKqqsJpik=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFCR2Py6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784622920; x=1816158920;
  h=date:from:to:cc:subject:message-id;
  bh=TqBuk+y222S/0JZKUqdHbjn0+vuZEHvbtEuhuz+DG3Q=;
  b=CFCR2Py63rxYEJbz0Bk606FFcoWxiB0TKNTeoK4QwcjWYakmxxGYgDvt
   cs6tQAWCtggOHKq86XAIZb067omVrQvFijgS1fEaN9Bpbkk5Mo6qISUvy
   nXzyA1/imaLxhb2df9BxZyVcpcil61rW/hZe+WfwUN8MoJMt2glKPBGXp
   US7htcr8BSa3J8NljSls9oYkV83wqkDKrbJu14oJ2mv31WN4JnxP+l6cE
   Jetmt4hHFo7Zkzkfk0TWDzo/C0A7heSgu9R0DdoshlsHmpOOlhrtRo3gl
   FCwpG7L8azBP/z/UXxzLJ+Th1Opv+LX9/5foLsXTeahYgXOFV8yQ2a2Ji
   w==;
X-CSE-ConnectionGUID: hcQn5rocQ56cuq/cl0Hgdw==
X-CSE-MsgGUID: l4fAZlvCQoOZCr7WFcftlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="85415878"
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="85415878"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 01:35:19 -0700
X-CSE-ConnectionGUID: d5RZ3SEmRri6LcdJvCLOeA==
X-CSE-MsgGUID: CnKPypL6RuCxoLTVF9u7jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="295907026"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 21 Jul 2026 01:35:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wm5wP-00000000XQ3-11uQ;
	Tue, 21 Jul 2026 08:35:05 +0000
Date: Tue, 21 Jul 2026 16:34:57 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 6918/7793] mm/page_owner.c:818:22: error:
 passing 'memdesc_flags_t *' to parameter of incompatible type
 'memdesc_flags_t'; remove &
Message-ID: <202607211642.g3Xlz5F8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: zmou5kcgt1ccjzp341wy59cdef3bdcqx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B87820004
X-HE-Tag: 1784622919-300529
X-HE-Meta: U2FsdGVkX1/vhvHzYtGbWSKUPpKhxSWt7motfFfeN1F8win5bn+QaDa/IGDZw9mUp+t3xl+uigPavyyViWI1Tgckdw7AZr5rtmxPZAyP9jrfYqjXtzFJunspPYfYY4J8M2lwm6evQYIpQEl6h7JtN0Hvch9L+R8sujlMm+GPSDcwOp9WLk8DoYGbUkNRr0LIA1SfpsU/9rO+XxTbazZXjQBAcIECn3GQT8M4dJvaN0hSRExzTSXv9G0kdQZORUfxNsBF9kkdhRXYHvrAiMXvrRBhjcnH9d1hbEybnFLBZYpxIUrcVEh6lkuQBIu4kNMTnaPm+Ux2AutY73cz+77x5l02QdNo4r+U1YCJTpQo98HNpK0y2siWgBmpnjgbkxxOEVhWoOzKThSIRk0yVhP1uMpytVx5kCwzXNevmTW2xAbT/xQirBB7GV+4g8rP3mAV9vSHA+iRiMj1PtzLOQcm+Wm/flhjmQf8YDiOBOZjxgmSV/qAS2DSU9NMiAP1MCfYvIyrvQkChv51/hf9CTsWPk2wkKZmoLgsLSpPjN8u0krhA5ZCrxdkzNhZFCU0aY8fKxelJf/KhRykhuz5JMFfnCk+O0bagc8nKOXHwuakutbom6EzmNAqUKWHftxFaOsUzP7szxDb1hfEWBVr6y3mxg3FhUWsK5J2u73EwSMJYFRh/EzbRxq1P89En9UHr3CIxFbQvkFw0LRSPz9IxALwF1rTErXg423dOnvUnz0YaemF3Z2+FGBZMkEZWdqMsaExEbMeaMjJ94u83MJ93+wOKGG3w8/Qos4Uzzo7JHKQnQ5k9P9joN+j9zjUDpRjwen//9udpe9iiHPz94ArXA1myZUysWKG7xd3C1mk1KGXYnZZwbsHIIRwdi7iIrRWJBohe5HYv3unZWt5zovyUIrvEOtPciq0vS19LLJHdWGu0K0UJ17I5F+KqnETNRJ7bKY/oX3H45GrfY5Myyc/ngU
 QIP7JEYd
 klY3rC1mc8BK7GvCOa/jYCVSzyrG0qb4JzG6htL/WR+OmXcoLcu6wu8kyW5hxxhVJlmsjr39D+TXE68cIWaUWHRXoQ+IldX+ljvCsaWx7ipcWdLbacfmXBhMqscvsdkpWhnaxotpWB+l4F+6ZT/upYolcMv48GFKWe8uUPoJPvNcsV/y6N+uEUVyAuq+2y51/5wNavhY9aRzlqSEuMnyXoNN3RYDdpLy2H2ZL9uLyMdFGKUhZoYYTGZ0zh28vEyn6gXGbsw4RbNT2YC9jOIL049VijhgGuHmE8FEbCo+zJPrTJH/fSbdrQE/yJoWqjBTWuUIZACfobhFHDJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   3fe08b9796f36ef437ab9328e7dd1e5ff2d66603
commit: 2e3c4a69b0c52d1f75d13c3ac380625143888e18 [6918/7793] mm-page_owner-add-numa-node-filter-fix
config: i386-randconfig-r134-20260721 (https://download.01.org/0day-ci/archive/20260721/202607211642.g3Xlz5F8-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260721/202607211642.g3Xlz5F8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607211642.g3Xlz5F8-lkp@intel.com/

Note: the linux-next/master HEAD 3fe08b9796f36ef437ab9328e7dd1e5ff2d66603 builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

>> mm/page_owner.c:818:22: error: passing 'memdesc_flags_t *' to parameter of incompatible type 'memdesc_flags_t'; remove &
     818 |                         nid = memdesc_nid(&page_flags);
         |                                           ^~~~~~~~~~~
   include/linux/mm.h:2291:47: note: passing argument to parameter 'mdf' here
    2291 | static inline int memdesc_nid(memdesc_flags_t mdf)
         |                                               ^
   1 error generated.


vim +818 mm/page_owner.c

   727	
   728	static ssize_t
   729	read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
   730	{
   731		unsigned long pfn;
   732		struct page *page;
   733		struct page_ext *page_ext;
   734		struct page_owner *page_owner;
   735		depot_stack_handle_t handle;
   736		struct page_owner_filter_state *state = file->private_data;
   737	
   738		if (!static_branch_unlikely(&page_owner_inited))
   739			return -EINVAL;
   740	
   741		page = NULL;
   742		if (*ppos == 0)
   743			pfn = min_low_pfn;
   744		else
   745			pfn = *ppos;
   746		/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
   747		while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
   748			pfn++;
   749	
   750		/* Find an allocated page */
   751		for (; pfn < max_pfn; pfn++) {
   752			/*
   753			 * This temporary page_owner is required so
   754			 * that we can avoid the context switches while holding
   755			 * the rcu lock and copying the page owner information to
   756			 * user through copy_to_user() or GFP_KERNEL allocations.
   757			 */
   758			struct page_owner page_owner_tmp;
   759	
   760			/*
   761			 * If the new page is in a new MAX_ORDER_NR_PAGES area,
   762			 * validate the area as existing, skip it if not
   763			 */
   764			if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0 && !pfn_valid(pfn)) {
   765				pfn += MAX_ORDER_NR_PAGES - 1;
   766				continue;
   767			}
   768	
   769			page = pfn_to_page(pfn);
   770			if (skip_buddy_pages(&pfn, page))
   771				continue;
   772	
   773			page_ext = page_ext_get(page);
   774			if (unlikely(!page_ext))
   775				continue;
   776	
   777			/*
   778			 * Some pages could be missed by concurrent allocation or free,
   779			 * because we don't hold the zone lock.
   780			 */
   781			if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
   782				goto ext_put_continue;
   783	
   784			/*
   785			 * Although we do have the info about past allocation of free
   786			 * pages, it's not relevant for current memory usage.
   787			 */
   788			if (!test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags))
   789				goto ext_put_continue;
   790	
   791			page_owner = get_page_owner(page_ext);
   792	
   793			/*
   794			 * Don't print "tail" pages of high-order allocations as that
   795			 * would inflate the stats.
   796			 */
   797			if (!IS_ALIGNED(pfn, 1 << page_owner->order))
   798				goto ext_put_continue;
   799	
   800			/*
   801			 * Access to page_ext->handle isn't synchronous so we should
   802			 * be careful to access it.
   803			 */
   804			handle = READ_ONCE(page_owner->handle);
   805			if (!handle)
   806				goto ext_put_continue;
   807	
   808			if (state->nid_filter_enabled) {
   809				int nid;
   810				memdesc_flags_t page_flags = READ_ONCE(page->flags);
   811	
   812				/*
   813				 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
   814				 * VM_BUG_ON when accessing poisoned pages.
   815				 */
   816				if (page_flags.f == PAGE_POISON_PATTERN)
   817					goto ext_put_continue;
 > 818				nid = memdesc_nid(&page_flags);
   819				if (!node_isset(nid, state->nid_filter))
   820					goto ext_put_continue;
   821			}
   822	
   823			/* Record the next PFN to read in the file offset */
   824			*ppos = pfn + 1;
   825	
   826			page_owner_tmp = *page_owner;
   827			page_ext_put(page_ext);
   828			return print_page_owner(buf, count, pfn, page,
   829					&page_owner_tmp, handle, state);
   830	ext_put_continue:
   831			page_ext_put(page_ext);
   832			cond_resched();
   833		}
   834	
   835		return 0;
   836	}
   837	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

