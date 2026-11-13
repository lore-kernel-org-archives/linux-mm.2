Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D6A606A883
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b3Q3ouUO
Received: by kanga.kvack.org (Postfix)
	id 464E76B05B4; Fri, 13 Nov 2026 13:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E106B05BA; Fri, 13 Nov 2026 13:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE436B05BF; Fri, 13 Nov 2026 13:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED3426B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:48:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38426A7843
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:48:12 +0000 (UTC)
X-FDA: 85430980824.08.5C82B7C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D78540007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:48:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b3Q3ouUO;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTTXoLzmI08d/jkNxxwJkcGQTYkKfMEm/po0ghn6PCY=;
	b=GiN0LIMpA0HBJniQfJebZuP7SYcZ9PT8PEF7B9rKcL0jyM7EX225v9p7UHxJ792UH7D4zf
	IDH1wLGB5/O+g25dFruugH+2JmJk8ZphMnZBpN++6yLoxcHrMpILTJq/3OpbaTy374ch0X
	LglFlvHXayJ8CJAUoUi+aQqqm3Mwj7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b3Q3ouUO;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595690;
	b=TgVRWr8Nev6+dfmwcwl3yhfZVvvMdj9qFOxtyVTB6HVUic4SoBp+YgI9i/QSc+JrkX89wa
	kZpl34MaHZuFPYkSWkcd/KT654ITDCs6277zIUPlCrCttfKTU5zPJYnCRgZtDgcZ7V6KgX
	U+hEnSbxm1eLy4iEHQJmwCr54AHBmyc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794595690; x=1826131690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0jeRtz+9v5QZzJ0um3TzrYm5IN5Zt91xgFDxIX0GY3g=;
  b=b3Q3ouUOk/43aFPnd8o121ldPmp2/0/RJXMCovrBBVHF7W2VEBNQ8V5h
   d4g6X+WAcoCVyzpP+zaCAvBty0taVhe096n25MuTo2oG9Bt6WqS8BG2Ly
   OMKUz52XXML2NvmFMwsGk6EGfJnfeGbBLyG/xJ51SvxE3Jd7wr+p1Jg/N
   jR21CA1P8vFJpPY51Oc8obaydx9OKrtOyBcUQJGKYGrSgG2vGXFE8GFqJ
   JjeUauZH9H/b6ybhBC7P4L6SNuHzAaIi3cNrdlQJ+UhnJLdp0Z2OUpeip
   6YOoI+qPSGASWXBdeyq307ht8Zj8f9iNCLPEiDe6tXA78jGQWDE3TNTO3
   Q==;
X-CSE-ConnectionGUID: IZBgmbY9QSGaNc9tf8Cv4w==
X-CSE-MsgGUID: iKsXSUWSRqelVjlIGtXEyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3268944"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3268944"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 10:48:08 -0800
X-CSE-ConnectionGUID: Rh20D4FlSN+XtD+EJsNIVQ==
X-CSE-MsgGUID: VsDH7IbkSdi8NAaR+ArEEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9523504"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 13 Nov 2026 10:48:04 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRwJd-000000013hD-0x1c;
	Fri, 13 Nov 2026 18:48:01 +0000
Date: Sat, 14 Nov 2026 02:47:17 +0800
From: kernel test robot <lkp@intel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baoquan.he@linux.dev, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	mhocko@kernel.org, baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
Message-ID: <202611140210.uZmu9pV3-lkp@intel.com>
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: w1ac1exfcajbai75j5wus7q8b699wnqj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D78540007
X-HE-Tag: 1794595689-372729
X-HE-Meta: U2FsdGVkX1/NRPbOY22BTdbQHRV7Z/RljOnGV9bbqSsgcHJ/wZ5Fqa+uuI2c4kUZ52QyW8qYzEc8v+Mstwd0lKZSZFcKZCMjGLmbPtEGQroSZFz7ztMAKsvkuquCK0oCabP1HMzNUGC4s4jZBJ/TDlGOXLJBUcswcABK/2uJsEhHAXnJQazuOQWBOaiye8JQ9hJPtYGQwL+DhTr3sH/FalN2Wb4nOA5XuGPWjlSfMnZxzzQb3Ekq9muR9soiavl/V2rTSOY141Gg/5EE0pxsQzBedAXqSbGd0YCU/JzlSiwMPIG4nQmrElIt9PzmnZ53rS1mw1JFbLtFX1U/tVaXR6OmFphpTYzbRdyIG4qKZERISlinoz2ygnkGjw+oGJCBgSFhgB0uS12jB9zbKJn8y44P6ZyX/Oju7jSYhDKJswG8VO5jjGY5dUEBa+kkDIQwLW5WMaK0zeVC1ie+r6tqj8qNmPEjmLdsTCwmTdktioJ7Sqkh4F1RDiWBMoqvCtf3SHPEu+qgv524o7vBWrcjtsncIhWuM/VfVmhEk0zGY+bW4oqNkeO2DEaN6/N8V6TKAiqieDJZlDXIjW5FUsFTjQTQ5hZLWolTvZQaXWij/gHTrKgxTzxsVpbJ6GS+OhfkSvtNP5dwLKO9PieJjl6h8s8w+11lDsTIeq1vZOp+Le9lty/WLsmoLkfBwKbuNARO+8lBgJXI5MkNrR+5csIjOvswNqrg/FKqx34HUXTlxqXI670FXt6C0RvUvaF5K2UF2SO1JmOl0heB4ZPKKkjinDkzIEZZZrMz5rQwRCib6mijPF+gvzn5oVMgyHApL4uhG0COvO2bk1H4NeNOAYKLmBVRZxASvVxWYyEAh82V2t7zLFXNMCu9T55q+o09IRY2MSesYFEEzXNmeRZQQM4k+EDhJIWSsRBWhWuyikNlUl5TavV1FvHypB/Z4fpV5f4auv7hDVri6s839jUCRaq
 r2tHKQAf
 +39/6lX10YKx1gY0+ot2XNyhVOcf4rX51gK5/OoDBJo8wQEyQ1izmNEfIys68Wxqu5Rqg9aYThbp+q97kC1nY2aDeZv+RoXjw5ddJfCK5AHOsgK+m0cbpRMr1zoc9j+V6Rfwxai7XM1qW8WFkartaxzyWFTiM7c2L+n5JcKy5/O/AjqB/WCV9xmJcpX11vjrEifP1rXcFYrF3Zc7MOgZj5vyI/LLb021R0hs2i1rGTSET4BID7xaaJTJAuVUKOM+i0zvCKupbqM1fGc5xBgvFq0Y/jgFLdv040pWHWeauLV2x20p+V5apOF407zoRNguxQY/XZ0x2AVi2b4kypAIs4AjhZ9Pvy5CmOoKzlJV7jXs5QzfMOzKAXNPIWQwp/CxvKW8LbdZI11hquwc/OOaLxWu2xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Baolin,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Baolin-Wang/mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end/20261112-191239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang%40linux.alibaba.com
patch subject: [PATCH] mm: mglru: use pte_table_clamped_end() helper to calculate the end
config: x86_64-randconfig-1008-20261113 (https://download.01.org/0day-ci/archive/20261114/202611140210.uZmu9pV3-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261114/202611140210.uZmu9pV3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611140210.uZmu9pV3-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vmscan.c:4343:8: error: call to undeclared function 'pte_table_clamped_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    4343 |         end = pte_table_clamped_end(addr, vma->vm_end);
         |               ^
   1 error generated.


vim +/pte_table_clamped_end +4343 mm/vmscan.c

  4296	
  4297	/******************************************************************************
  4298	 *                          rmap/PT walk feedback
  4299	 ******************************************************************************/
  4300	
  4301	/*
  4302	 * This function exploits spatial locality when shrink_folio_list() walks the
  4303	 * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
  4304	 * the scan was done cacheline efficiently, it adds the PMD entry pointing to
  4305	 * the PTE table to the Bloom filter. This forms a feedback loop between the
  4306	 * eviction and the aging.
  4307	 */
  4308	bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
  4309	{
  4310		int i;
  4311		bool dirty;
  4312		unsigned long start;
  4313		unsigned long end;
  4314		struct lru_gen_mm_walk *walk;
  4315		struct folio *last = NULL;
  4316		int young = nr;
  4317		pte_t *pte = pvmw->pte;
  4318		unsigned long addr = pvmw->address;
  4319		struct vm_area_struct *vma = pvmw->vma;
  4320		struct folio *folio = pfn_folio(pvmw->pfn);
  4321		struct mem_cgroup *memcg;
  4322		struct pglist_data *pgdat = folio_pgdat(folio);
  4323		struct lruvec *lruvec;
  4324		struct lru_gen_mm_state *mm_state;
  4325	
  4326		lockdep_assert_held(pvmw->ptl);
  4327		VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
  4328	
  4329		if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
  4330			return false;
  4331	
  4332		if (spin_is_contended(pvmw->ptl))
  4333			return true;
  4334	
  4335		/* exclude non-mm-backed VMAs containing anon pages from COW */
  4336		if (!vma_is_mm_backed(vma))
  4337			return true;
  4338	
  4339		/* avoid taking the LRU lock under the PTL when possible */
  4340		walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
  4341	
  4342		start = max(addr & PMD_MASK, vma->vm_start);
> 4343		end = pte_table_clamped_end(addr, vma->vm_end);
  4344	
  4345		if (end - start == PAGE_SIZE)
  4346			return true;
  4347	
  4348		if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
  4349			if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4350				end = start + MIN_LRU_BATCH * PAGE_SIZE;
  4351			else if (end - addr < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4352				start = end - MIN_LRU_BATCH * PAGE_SIZE;
  4353			else {
  4354				start = addr - MIN_LRU_BATCH * PAGE_SIZE / 2;
  4355				end = addr + MIN_LRU_BATCH * PAGE_SIZE / 2;
  4356			}
  4357		}
  4358	
  4359		memcg = get_mem_cgroup_from_folio(folio);
  4360		lruvec = mem_cgroup_lruvec(memcg, pgdat);
  4361		mm_state = get_mm_state(lruvec);
  4362	
  4363		lazy_mmu_mode_enable();
  4364	
  4365		pte -= (addr - start) / PAGE_SIZE;
  4366	
  4367		for (i = 0, addr = start; addr != end;
  4368		     i += nr, pte += nr, addr += nr * PAGE_SIZE) {
  4369			unsigned long pfn;
  4370			pte_t ptent = ptep_get(pte);
  4371	
  4372			nr = 1;
  4373			pfn = get_pte_pfn(ptent, vma, addr, pgdat);
  4374			if (pfn == -1)
  4375				continue;
  4376	
  4377			folio = get_pfn_folio(pfn, memcg, pgdat);
  4378			if (!folio)
  4379				continue;
  4380	
  4381			if (folio_test_large(folio)) {
  4382				const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
  4383	
  4384				nr = folio_pte_batch_flags(folio, NULL, pte, &ptent,
  4385							   max_nr, FPB_MERGE_YOUNG_DIRTY);
  4386			}
  4387	
  4388			if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
  4389				continue;
  4390	
  4391			if (last != folio) {
  4392				walk_update_folio(walk, vma, lruvec, last, dirty);
  4393	
  4394				last = folio;
  4395				dirty = false;
  4396			}
  4397	
  4398			if (pte_dirty(ptent))
  4399				dirty = true;
  4400	
  4401			young += nr;
  4402		}
  4403	
  4404		walk_update_folio(walk, vma, lruvec, last, dirty);
  4405	
  4406		lazy_mmu_mode_disable();
  4407	
  4408		/* feedback from rmap walkers to page table walkers */
  4409		if (mm_state && suitable_to_scan(i, young))
  4410			update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
  4411					    pvmw->pmd);
  4412	
  4413		mem_cgroup_put(memcg);
  4414	
  4415		return true;
  4416	}
  4417	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

