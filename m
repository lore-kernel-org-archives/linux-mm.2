Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6297FD7F97
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D246B0005; Fri, 27 Feb 2026 06:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AE76B0088; Fri, 27 Feb 2026 06:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36F86B0089; Fri, 27 Feb 2026 06:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC4416B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:43:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6233E140609
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:43:46 +0000 (UTC)
X-FDA: 84490052052.09.38DEEDF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAADC80009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:43:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lQTfuQ8h;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772192624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQBLVqYR0crvP/cbM9aXrVg7Fqs+jR1gP6F3HYrmTHM=;
	b=vgbDzqppR/bjbGk+tfRnVdAsnNbkXYfOvjfqEtP74Q9iZ1OpgEdYgj0qvchnUl2mqltry+
	CNJ8lywW832Rt6vTWsJPZYmeMqhYcW2oNgpBH4z3DtfTFSjjBHmPCl3pGTom5vY6ztXEHF
	aMxqKLq4ifLBq08tPW83tExzL7vrJWY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lQTfuQ8h;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772192624; a=rsa-sha256;
	cv=none;
	b=Kqfx8S1gAGBTDGPjlkbFve4PbINe2kRwRnMZgPeQiHKtEurxv98Zg17qhpyOEc5Sj3rFqj
	xDRlvYgUpz7VhcxE0my6OPR1i/6BdgsFj8YmuuAxkDlk9mlzCC9eoG43H5KukDKet1NrUl
	lMOCNFpuS+00UDIDT4EoYHPiS2xz1ls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772192622; x=1803728622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k71+5wpnY+R4W/nYkxbAc1A91ldRLf5J5npGg7ll4SY=;
  b=lQTfuQ8hqA7sJkxvoc1BqlBe0Os9OMJN4LYUbg7ovBYYfKIh3/H9mBGh
   /Sj/H4Vu7PRWQ8X1Lv00WsPWlKsflRrlNTteXcNUYuePy7nz1bKvmpgTi
   UzXxdmwjOGwpjoGnz2uB5uxd6wRCdmliUPWeXa6OL3NQ34nuzkAFzQh3n
   HWzhuwyQuZ8g5d7J4+3Aro6qVWyTjxaYSUo9oWhjSXaiC8b2Q0eiLNmCq
   gnFwVA4WsCJBFKMu/lVjdo/l6QFdVLagw6stnW2/ZISbZw0/KDqlrmXM7
   jBy1bf1FrniN+Ilq35+999S+qeLy+23HDhQD0me8DdocZZ9yJKwcjGsEh
   w==;
X-CSE-ConnectionGUID: oMH8jQG8RcylRJHRlzvgkw==
X-CSE-MsgGUID: ithf2hDoRjuSfvlxMhRteg==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73144983"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="73144983"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 03:43:40 -0800
X-CSE-ConnectionGUID: DI7r2TWIREOtq5yOW4njRw==
X-CSE-MsgGUID: ZqsTWKdpQzSKdW0ZLZsWeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="216984966"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 27 Feb 2026 03:43:38 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvwFJ-00000000AX1-2Vfa;
	Fri, 27 Feb 2026 11:43:09 +0000
Date: Fri, 27 Feb 2026 19:42:33 +0800
From: kernel test robot <lkp@intel.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yu Zhao <yuzhao@google.com>, linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: bail out when the PMD has been set in bloom filter
Message-ID: <202602271916.OBNa34QU-lkp@intel.com>
References: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
X-Rspam-User: 
X-Stat-Signature: gah3jpmxi7f6985rpuakcwbum65ncnzi
X-Rspamd-Queue-Id: AAADC80009
X-Rspamd-Server: rspam10
X-HE-Tag: 1772192621-223851
X-HE-Meta: U2FsdGVkX19XJtGuYjfNctjXtMxoRYXApgEk3ZQLJIsirLOJfk8NbwIuzVZ36p4QShQytA8o+xZre90ECFvUASPCqHVwAIgP4vHJLp/WaZtT7xq85q1xt+wEhjhkyfRsUfLvOdXXh2YktLT8YInrG7DaivRB62xuRUxkXY26Hw1bblRnJzfTZDVVd1BjLBsi87vSA6zrVZhb6JmxBUpoHMKbrsOlb203Z1y+cRuTJXZCEfh+KFT+gsaG4uTBDNhekQBkqVIMFVjhKqTRaFmw/yd3YqNCIkgbdC+FlECsRRyKMlO+DB3Kk2uzJGcqTpYAISYo4Pyrq0wDX5ccFLjlj9qdat6yXaogz/gZQt86RoIs16I8+6YC0+3EqDZsn0vI3ubxCpaXtkf9nhyinjnrJNjj7k3BykxIwkL33U77gtOqRdNEtuXyiOEoQUUfnwUnQGUuML4LHbRF9ZTRjfBycD6F364Vivdjs65A1fVQuiMSNLZZDuzIrEHLWKCuDji3iaFY+aTQrU2nElEPdHl5a3YW+XPOqoFIlmoaL6Venu7LEMeXem0f5wwB5MnCqpFVuMr9DA2dB881EgAwFEKx+m60MfpWRpPK7ZzDT/hRZID7AUsp4KEDzGaEMb6MZrkvPo0xsQNicMccBgWXhjrBkI9nwjWwCjn/Exfr3jrHgMjvCLLfv84BlcAuvzbH3pffRVHESa2n1KMv+UKn6dcHKe8jZwc+WY1mumWaY5h4fkW1XwWrglJXBMTmnNZ/z8E2y8tPJ6PFrRjp8YK7rpIchiwhK5i0cTh6TKFmg9IrUjSKEzP7OY3an1QXtl76OrfR9iW+Z/gUjKgaqRATcoMKjbfBpqrUAdMX69DGWseg+wyA1WVR+wNa2yIJTZHX1kE49ZIO62JgHTOj0MyiT146y/ukLJlVR0nQjb6Sf/xYTPBImT1rvMeWOY2QA4UdsgGRH4jnz1JjzOlsbGzc9HQ
 tGnzzdsV
 OoXyqiwtaqCAud/uNTWm/SIqiLpSSEX4BDd5Dxcm3TrnBy62p1b5c8uftw4PwtWxbb19q6VqQgyjlaKdKIFqDQBMpwZVG7thtcPOa40PFKpd8oH2l7Tph+7gHtuPts2EVKLNogsZXHDTwfmj3StmY3AWeGOoC7jZlJXrQgV5aW2869s+5mBGkbHCQh2W92fzmHranWY8eLsjzxT2tgNz6vnseicEwb3AZqkeYq2XsMnclY9jdVLzwCQ9fIfE/e63eRAJaicKPOFMxKMNdK2R3Ce7LvATpoqevjsJVLdX/21HMbOWw6ATUJNfYpOYQQD44V6kUIZQWCXZy6wQi+2iDkDK5g+GirbMlEtjnNZJOl52skuo1lyMo8hh0NQW1MGXnXGxJZ9FUJk9QarO5MyQw4pj4hZxWM9tnGudE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi zhaoyang.huang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/zhaoyang-huang/mm-bail-out-when-the-PMD-has-been-set-in-bloom-filter/20260227-155729
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260227075250.1128175-1-zhaoyang.huang%40unisoc.com
patch subject: [PATCH] mm: bail out when the PMD has been set in bloom filter
config: sparc64-randconfig-002-20260227 (https://download.01.org/0day-ci/archive/20260227/202602271916.OBNa34QU-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9a109fbb6e184ec9bcce10615949f598f4c974a9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602271916.OBNa34QU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602271916.OBNa34QU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmscan.c:4206:24: warning: variable 'mm_state' is uninitialized when used here [-Wuninitialized]
    4206 |         if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
         |                               ^~~~~~~~
   mm/vmscan.c:4185:35: note: initialize the variable 'mm_state' to silence this warning
    4185 |         struct lru_gen_mm_state *mm_state;
         |                                          ^
         |                                           = NULL
>> mm/vmscan.c:4206:34: warning: variable 'max_seq' is uninitialized when used here [-Wuninitialized]
    4206 |         if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
         |                                         ^~~~~~~
   mm/vmscan.c:4186:23: note: initialize the variable 'max_seq' to silence this warning
    4186 |         unsigned long max_seq;
         |                              ^
         |                               = 0
   2 warnings generated.


vim +/mm_state +4206 mm/vmscan.c

  4157	
  4158	/******************************************************************************
  4159	 *                          rmap/PT walk feedback
  4160	 ******************************************************************************/
  4161	
  4162	/*
  4163	 * This function exploits spatial locality when shrink_folio_list() walks the
  4164	 * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
  4165	 * the scan was done cacheline efficiently, it adds the PMD entry pointing to
  4166	 * the PTE table to the Bloom filter. This forms a feedback loop between the
  4167	 * eviction and the aging.
  4168	 */
  4169	bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
  4170	{
  4171		int i;
  4172		bool dirty;
  4173		unsigned long start;
  4174		unsigned long end;
  4175		struct lru_gen_mm_walk *walk;
  4176		struct folio *last = NULL;
  4177		int young = 1;
  4178		pte_t *pte = pvmw->pte;
  4179		unsigned long addr = pvmw->address;
  4180		struct vm_area_struct *vma = pvmw->vma;
  4181		struct folio *folio = pfn_folio(pvmw->pfn);
  4182		struct mem_cgroup *memcg;
  4183		struct pglist_data *pgdat = folio_pgdat(folio);
  4184		struct lruvec *lruvec;
  4185		struct lru_gen_mm_state *mm_state;
  4186		unsigned long max_seq;
  4187		int gen;
  4188	
  4189		lockdep_assert_held(pvmw->ptl);
  4190		VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
  4191	
  4192		if (!ptep_clear_young_notify(vma, addr, pte))
  4193			return false;
  4194	
  4195		if (spin_is_contended(pvmw->ptl))
  4196			return true;
  4197	
  4198		/* exclude special VMAs containing anon pages from COW */
  4199		if (vma->vm_flags & VM_SPECIAL)
  4200			return true;
  4201	
  4202		/* avoid taking the LRU lock under the PTL when possible */
  4203		walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
  4204	
  4205		/* may the pmd has been set in bloom filter */
> 4206		if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
  4207			return true;
  4208	
  4209		start = max(addr & PMD_MASK, vma->vm_start);
  4210		end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
  4211	
  4212		if (end - start == PAGE_SIZE)
  4213			return true;
  4214	
  4215		if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
  4216			if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4217				end = start + MIN_LRU_BATCH * PAGE_SIZE;
  4218			else if (end - addr < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4219				start = end - MIN_LRU_BATCH * PAGE_SIZE;
  4220			else {
  4221				start = addr - MIN_LRU_BATCH * PAGE_SIZE / 2;
  4222				end = addr + MIN_LRU_BATCH * PAGE_SIZE / 2;
  4223			}
  4224		}
  4225	
  4226		memcg = get_mem_cgroup_from_folio(folio);
  4227		lruvec = mem_cgroup_lruvec(memcg, pgdat);
  4228		max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
  4229		gen = lru_gen_from_seq(max_seq);
  4230		mm_state = get_mm_state(lruvec);
  4231	
  4232		lazy_mmu_mode_enable();
  4233	
  4234		pte -= (addr - start) / PAGE_SIZE;
  4235	
  4236		for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
  4237			unsigned long pfn;
  4238			pte_t ptent = ptep_get(pte + i);
  4239	
  4240			pfn = get_pte_pfn(ptent, vma, addr, pgdat);
  4241			if (pfn == -1)
  4242				continue;
  4243	
  4244			folio = get_pfn_folio(pfn, memcg, pgdat);
  4245			if (!folio)
  4246				continue;
  4247	
  4248			if (!ptep_clear_young_notify(vma, addr, pte + i))
  4249				continue;
  4250	
  4251			if (last != folio) {
  4252				walk_update_folio(walk, last, gen, dirty);
  4253	
  4254				last = folio;
  4255				dirty = false;
  4256			}
  4257	
  4258			if (pte_dirty(ptent))
  4259				dirty = true;
  4260	
  4261			young++;
  4262		}
  4263	
  4264		walk_update_folio(walk, last, gen, dirty);
  4265	
  4266		lazy_mmu_mode_disable();
  4267	
  4268		/* feedback from rmap walkers to page table walkers */
  4269		if (mm_state && suitable_to_scan(i, young))
  4270			update_bloom_filter(mm_state, max_seq, pvmw->pmd);
  4271	
  4272		mem_cgroup_put(memcg);
  4273	
  4274		return true;
  4275	}
  4276	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

