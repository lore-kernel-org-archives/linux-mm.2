Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A94E8782A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790E56B00A5; Tue,  3 Feb 2026 08:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765FA6B00A6; Tue,  3 Feb 2026 08:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6682F6B00A7; Tue,  3 Feb 2026 08:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8F16B00A5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:05:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0410A1B1D5B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:05:19 +0000 (UTC)
X-FDA: 84403166400.20.08845B7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id B67C1140013
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:05:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WdTywgbw;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770123918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSh2Nqzzh10/u2IJA+YX2OL4R4kNfmoLKZfwXuXuglU=;
	b=In940n4cx0lVh+ESZDE13quXW4OQ+X3CnXRbV/z8XTTnmkqFz7CWK5nGYOiaMqZSVUew10
	ns2GXSiWzJcmH5NInIQWZD6gkNulOuEQ3m+eqAzhFBc8dtsm+2o+DdQ+NbxofvRmmrdl2A
	8cMiGXYeM3uYmFzyoYf/VMiJGzWfxnY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WdTywgbw;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770123918; a=rsa-sha256;
	cv=none;
	b=Di1KXIgAhKt9ki4/a+Q7r+CrCuvE3GLUTjl/3y54NKem9S2vQkfupXW5I9nGFV/YrNEM0O
	d6ytPVIkQ+a4uCcBAGv3+Tfk02I1n9HCc4np1Bph0Q4vtPYnW1D0TKfe8xG3XtDU2BvPd/
	rEZmDwmc34L7T+8/ukjTIhZ/23frnQg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770123918; x=1801659918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eAOTahntRImrik38mnsnViDi0PjENZgxrqEs53AMudI=;
  b=WdTywgbwq9GCIH0QdfndB+w4Nk3a5OkbHliZG5pYy9q0HByLs4UQKIXs
   w81QsY2XTmzc2KSlytMIL0ScSRLxTZoX0McYlVVBI2WoYsVgYWHbbNEK3
   QP/MoUdfWZuO7NlpNwo1pPqRXTEG795xuF4Gntn25GwU1W4LUYa9m3m7K
   2uYJI/zIOqf7+689pkf0DrBzjRABDKf5EqNzGKCE3oaqGfeyhQSqqrScs
   /Afp3uG9bl2Dxe3Y0oMvo8SUtOVcaj6dJYYumhmRQ0S1VFIanWo4XdRrB
   cCyOCu8/jG90TEKhh/Rhg0G7WyDQGT4ujmfohDXvW5P38toPN+qoJHos7
   g==;
X-CSE-ConnectionGUID: aykZy9VrRXq06yw3URy1Uw==
X-CSE-MsgGUID: cPkghKvdR5acDBzjRIpoqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="93945554"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="93945554"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 05:05:14 -0800
X-CSE-ConnectionGUID: NUmFSuM4RTG8P55q95+ARw==
X-CSE-MsgGUID: nLLd4nr8TfSH1xmlM01hPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="240516124"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 03 Feb 2026 05:05:10 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnG5b-00000000gfe-1dla;
	Tue, 03 Feb 2026 13:05:07 +0000
Date: Tue, 3 Feb 2026 21:04:47 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <202602032123.zvKd7G8W-lkp@intel.com>
References: <20260203104532.98534-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203104532.98534-1-thomas.hellstrom@linux.intel.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B67C1140013
X-Stat-Signature: gju73hnwoainn3co1pg6gps3nnij445r
X-Rspam-User: 
X-HE-Tag: 1770123917-617102
X-HE-Meta: U2FsdGVkX1/Ypa+/pR8tCZTL0avscWwN6omilhgYucUzwkPodz5ZgBy7MXqmEPfMnPXQ/0UoV+egBmby/3ZS2v+SvnSlKK9TIdyredCHyil2E2bdag/eTBC3exhV/tn6jIxSFmwE0EsMUA/HZNC+naGheK/h3gVC0feFmuKZz0yElqKwE5iWxDKAgF3hK32xyiu4ZIxawen3nPyH+f7xxgspBEVNnbnmsK0sT0WNEH6ruuDZY07P1ioQZDgg7k1+xU+CU0SPjwJgdzUeGKb7EfUeMfspt4Nk0CR6p/ZCcKGOv4jleA9xGpeLkZFbJ8ycZEWac27LiG7m34HAcXGu3AxAtrqNrex8Sp05liTcVf7FyAKRDvpTxdyaa+P1Cp5QZbfatymfeAgXyIe5+JpOPvcXiQyLSWoIk58x5l9W8pFrunOeInh85zCjs88CsCjCUwsohQk3ce66Z4XkPlotjbqZr3t9ZQmVI/z+/MHeO6nGBS8xhjBsE+vnNeeZ0zHC2cnXiqJGpCytlZOkEtFub+ZSZyQzW6eSVPgtPHQk4pSGsWXFAiJu8l9MUaxHh0lP3aKitwUWNdnw6zqAKkhwJ70ePWpwAJn3mfrI9SAyQtKH+JVlukH+PFpZD4SJk9GPD7riWIsDam9Mk2Fl0PQEDoyoVkpWCRIcTLTiF39ZPwVPYm+KDlVGH9gNMR/p5ke5l8y6Hv2iWtuYx5jRkBfjGp++nGluKchGnfYLQSi0iHsqLs3c6rN4cdX4P/N2ktAJDwSLZHBItN50vF9o/QZ0irHAXu0LKOfpCXnYbIbIxLU64p6++0g9jFcCQ3O9Sje9vZAM5WeKuxUkQHuyP7MWsB0DXlDE12Sn3wCFN+aKc/MEsDE2Zn0ukmXOQwr34bbXuWkR+U0XPiSminJnELgerisOrvrtLOKgXEBZQThZZZjioaxzw6t/EhV85XNJJrJEMbUjkmWLMtUDNArV7E+
 J8Wd3zZx
 anH07/jkWT3lhqlivqkq9z0ODatsQjotQxFOX/LKPZQuygPq9Y2ooZRbgYMUoUgCVIfH1200u5HkrTVseA9I6YCtLrfM9PX8C4bq5BDoOfALyVQx0fYqqz759USMIB/81ei5ioiOxDHWgnkheMN4lmjY0TwMGm8rJ5/bcG55ghvv33SdUBCVZx597YN7lzjUn7Vp9iU5KQK7q/DDowkKcK49rOUByL0t30nbRYYtvpOW6+VEyEop96MtGWpckdX7VEGr770SROoImIa1JuditdQHRbLVA1A0Oj8DaZpg3GweWz6h8986H4yMid/2g3pPFXVm5eHnol7FZisXBq8IIGB84/jHTn07U+erwZfrIPS0oQMl3GBfvB2UHuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Thomas-Hellstr-m/mm-Fix-a-hmm_range_fault-livelock-starvation-problem/20260203-184803
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260203104532.98534-1-thomas.hellstrom%40linux.intel.com
patch subject: [PATCH v2] mm: Fix a hmm_range_fault() livelock / starvation problem
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260203/202602032123.zvKd7G8W-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602032123.zvKd7G8W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602032123.zvKd7G8W-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory.c:4769:5: error: call to undeclared function 'migration_entry_wait_on_locked'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    4769 |                                 migration_entry_wait_on_locked(entry, vmf->ptl);
         |                                 ^
   mm/memory.c:4769:5: note: did you mean 'migration_entry_wait_huge'?
   include/linux/swapops.h:237:20: note: 'migration_entry_wait_huge' declared here
     237 | static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
         |                    ^
   1 error generated.


vim +/migration_entry_wait_on_locked +4769 mm/memory.c

  4699	
  4700	/*
  4701	 * We enter with non-exclusive mmap_lock (to exclude vma changes,
  4702	 * but allow concurrent faults), and pte mapped but not yet locked.
  4703	 * We return with pte unmapped and unlocked.
  4704	 *
  4705	 * We return with the mmap_lock locked or unlocked in the same cases
  4706	 * as does filemap_fault().
  4707	 */
  4708	vm_fault_t do_swap_page(struct vm_fault *vmf)
  4709	{
  4710		struct vm_area_struct *vma = vmf->vma;
  4711		struct folio *swapcache = NULL, *folio;
  4712		struct page *page;
  4713		struct swap_info_struct *si = NULL;
  4714		rmap_t rmap_flags = RMAP_NONE;
  4715		bool exclusive = false;
  4716		softleaf_t entry;
  4717		pte_t pte;
  4718		vm_fault_t ret = 0;
  4719		int nr_pages;
  4720		unsigned long page_idx;
  4721		unsigned long address;
  4722		pte_t *ptep;
  4723	
  4724		if (!pte_unmap_same(vmf))
  4725			goto out;
  4726	
  4727		entry = softleaf_from_pte(vmf->orig_pte);
  4728		if (unlikely(!softleaf_is_swap(entry))) {
  4729			if (softleaf_is_migration(entry)) {
  4730				migration_entry_wait(vma->vm_mm, vmf->pmd,
  4731						     vmf->address);
  4732			} else if (softleaf_is_device_exclusive(entry)) {
  4733				vmf->page = softleaf_to_page(entry);
  4734				ret = remove_device_exclusive_entry(vmf);
  4735			} else if (softleaf_is_device_private(entry)) {
  4736				if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
  4737					/*
  4738					 * migrate_to_ram is not yet ready to operate
  4739					 * under VMA lock.
  4740					 */
  4741					vma_end_read(vma);
  4742					ret = VM_FAULT_RETRY;
  4743					goto out;
  4744				}
  4745	
  4746				vmf->page = softleaf_to_page(entry);
  4747				vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
  4748						vmf->address, &vmf->ptl);
  4749				if (unlikely(!vmf->pte ||
  4750					     !pte_same(ptep_get(vmf->pte),
  4751								vmf->orig_pte)))
  4752					goto unlock;
  4753	
  4754				/*
  4755				 * Get a page reference while we know the page can't be
  4756				 * freed.
  4757				 */
  4758				if (trylock_page(vmf->page)) {
  4759					struct dev_pagemap *pgmap;
  4760	
  4761					get_page(vmf->page);
  4762					pte_unmap_unlock(vmf->pte, vmf->ptl);
  4763					pgmap = page_pgmap(vmf->page);
  4764					ret = pgmap->ops->migrate_to_ram(vmf);
  4765					unlock_page(vmf->page);
  4766					put_page(vmf->page);
  4767				} else {
  4768					pte_unmap(vmf->pte);
> 4769					migration_entry_wait_on_locked(entry, vmf->ptl);
  4770				}
  4771			} else if (softleaf_is_hwpoison(entry)) {
  4772				ret = VM_FAULT_HWPOISON;
  4773			} else if (softleaf_is_marker(entry)) {
  4774				ret = handle_pte_marker(vmf);
  4775			} else {
  4776				print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
  4777				ret = VM_FAULT_SIGBUS;
  4778			}
  4779			goto out;
  4780		}
  4781	
  4782		/* Prevent swapoff from happening to us. */
  4783		si = get_swap_device(entry);
  4784		if (unlikely(!si))
  4785			goto out;
  4786	
  4787		folio = swap_cache_get_folio(entry);
  4788		if (folio)
  4789			swap_update_readahead(folio, vma, vmf->address);
  4790		if (!folio) {
  4791			if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
  4792				folio = alloc_swap_folio(vmf);
  4793				if (folio) {
  4794					/*
  4795					 * folio is charged, so swapin can only fail due
  4796					 * to raced swapin and return NULL.
  4797					 */
  4798					swapcache = swapin_folio(entry, folio);
  4799					if (swapcache != folio)
  4800						folio_put(folio);
  4801					folio = swapcache;
  4802				}
  4803			} else {
  4804				folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
  4805			}
  4806	
  4807			if (!folio) {
  4808				/*
  4809				 * Back out if somebody else faulted in this pte
  4810				 * while we released the pte lock.
  4811				 */
  4812				vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
  4813						vmf->address, &vmf->ptl);
  4814				if (likely(vmf->pte &&
  4815					   pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
  4816					ret = VM_FAULT_OOM;
  4817				goto unlock;
  4818			}
  4819	
  4820			/* Had to read the page from swap area: Major fault */
  4821			ret = VM_FAULT_MAJOR;
  4822			count_vm_event(PGMAJFAULT);
  4823			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
  4824		}
  4825	
  4826		swapcache = folio;
  4827		ret |= folio_lock_or_retry(folio, vmf);
  4828		if (ret & VM_FAULT_RETRY)
  4829			goto out_release;
  4830	
  4831		page = folio_file_page(folio, swp_offset(entry));
  4832		/*
  4833		 * Make sure folio_free_swap() or swapoff did not release the
  4834		 * swapcache from under us.  The page pin, and pte_same test
  4835		 * below, are not enough to exclude that.  Even if it is still
  4836		 * swapcache, we need to check that the page's swap has not
  4837		 * changed.
  4838		 */
  4839		if (unlikely(!folio_matches_swap_entry(folio, entry)))
  4840			goto out_page;
  4841	
  4842		if (unlikely(PageHWPoison(page))) {
  4843			/*
  4844			 * hwpoisoned dirty swapcache pages are kept for killing
  4845			 * owner processes (which may be unknown at hwpoison time)
  4846			 */
  4847			ret = VM_FAULT_HWPOISON;
  4848			goto out_page;
  4849		}
  4850	
  4851		/*
  4852		 * KSM sometimes has to copy on read faults, for example, if
  4853		 * folio->index of non-ksm folios would be nonlinear inside the
  4854		 * anon VMA -- the ksm flag is lost on actual swapout.
  4855		 */
  4856		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
  4857		if (unlikely(!folio)) {
  4858			ret = VM_FAULT_OOM;
  4859			folio = swapcache;
  4860			goto out_page;
  4861		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
  4862			ret = VM_FAULT_HWPOISON;
  4863			folio = swapcache;
  4864			goto out_page;
  4865		} else if (folio != swapcache)
  4866			page = folio_page(folio, 0);
  4867	
  4868		/*
  4869		 * If we want to map a page that's in the swapcache writable, we
  4870		 * have to detect via the refcount if we're really the exclusive
  4871		 * owner. Try removing the extra reference from the local LRU
  4872		 * caches if required.
  4873		 */
  4874		if ((vmf->flags & FAULT_FLAG_WRITE) &&
  4875		    !folio_test_ksm(folio) && !folio_test_lru(folio))
  4876			lru_add_drain();
  4877	
  4878		folio_throttle_swaprate(folio, GFP_KERNEL);
  4879	
  4880		/*
  4881		 * Back out if somebody else already faulted in this pte.
  4882		 */
  4883		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
  4884				&vmf->ptl);
  4885		if (unlikely(!vmf->pte || !pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
  4886			goto out_nomap;
  4887	
  4888		if (unlikely(!folio_test_uptodate(folio))) {
  4889			ret = VM_FAULT_SIGBUS;
  4890			goto out_nomap;
  4891		}
  4892	
  4893		nr_pages = 1;
  4894		page_idx = 0;
  4895		address = vmf->address;
  4896		ptep = vmf->pte;
  4897		if (folio_test_large(folio) && folio_test_swapcache(folio)) {
  4898			int nr = folio_nr_pages(folio);
  4899			unsigned long idx = folio_page_idx(folio, page);
  4900			unsigned long folio_start = address - idx * PAGE_SIZE;
  4901			unsigned long folio_end = folio_start + nr * PAGE_SIZE;
  4902			pte_t *folio_ptep;
  4903			pte_t folio_pte;
  4904	
  4905			if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
  4906				goto check_folio;
  4907			if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
  4908				goto check_folio;
  4909	
  4910			folio_ptep = vmf->pte - idx;
  4911			folio_pte = ptep_get(folio_ptep);
  4912			if (!pte_same(folio_pte, pte_move_swp_offset(vmf->orig_pte, -idx)) ||
  4913			    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
  4914				goto check_folio;
  4915	
  4916			page_idx = idx;
  4917			address = folio_start;
  4918			ptep = folio_ptep;
  4919			nr_pages = nr;
  4920			entry = folio->swap;
  4921			page = &folio->page;
  4922		}
  4923	
  4924	check_folio:
  4925		/*
  4926		 * PG_anon_exclusive reuses PG_mappedtodisk for anon pages. A swap pte
  4927		 * must never point at an anonymous page in the swapcache that is
  4928		 * PG_anon_exclusive. Sanity check that this holds and especially, that
  4929		 * no filesystem set PG_mappedtodisk on a page in the swapcache. Sanity
  4930		 * check after taking the PT lock and making sure that nobody
  4931		 * concurrently faulted in this page and set PG_anon_exclusive.
  4932		 */
  4933		BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
  4934		BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
  4935	
  4936		/*
  4937		 * If a large folio already belongs to anon mapping, then we
  4938		 * can just go on and map it partially.
  4939		 * If not, with the large swapin check above failing, the page table
  4940		 * have changed, so sub pages might got charged to the wrong cgroup,
  4941		 * or even should be shmem. So we have to free it and fallback.
  4942		 * Nothing should have touched it, both anon and shmem checks if a
  4943		 * large folio is fully appliable before use.
  4944		 *
  4945		 * This will be removed once we unify folio allocation in the swap cache
  4946		 * layer, where allocation of a folio stabilizes the swap entries.
  4947		 */
  4948		if (!folio_test_anon(folio) && folio_test_large(folio) &&
  4949		    nr_pages != folio_nr_pages(folio)) {
  4950			if (!WARN_ON_ONCE(folio_test_dirty(folio)))
  4951				swap_cache_del_folio(folio);
  4952			goto out_nomap;
  4953		}
  4954	
  4955		/*
  4956		 * Check under PT lock (to protect against concurrent fork() sharing
  4957		 * the swap entry concurrently) for certainly exclusive pages.
  4958		 */
  4959		if (!folio_test_ksm(folio)) {
  4960			/*
  4961			 * The can_swapin_thp check above ensures all PTE have
  4962			 * same exclusiveness. Checking just one PTE is fine.
  4963			 */
  4964			exclusive = pte_swp_exclusive(vmf->orig_pte);
  4965			if (exclusive)
  4966				check_swap_exclusive(folio, entry, nr_pages);
  4967			if (folio != swapcache) {
  4968				/*
  4969				 * We have a fresh page that is not exposed to the
  4970				 * swapcache -> certainly exclusive.
  4971				 */
  4972				exclusive = true;
  4973			} else if (exclusive && folio_test_writeback(folio) &&
  4974				  data_race(si->flags & SWP_STABLE_WRITES)) {
  4975				/*
  4976				 * This is tricky: not all swap backends support
  4977				 * concurrent page modifications while under writeback.
  4978				 *
  4979				 * So if we stumble over such a page in the swapcache
  4980				 * we must not set the page exclusive, otherwise we can
  4981				 * map it writable without further checks and modify it
  4982				 * while still under writeback.
  4983				 *
  4984				 * For these problematic swap backends, simply drop the
  4985				 * exclusive marker: this is perfectly fine as we start
  4986				 * writeback only if we fully unmapped the page and
  4987				 * there are no unexpected references on the page after
  4988				 * unmapping succeeded. After fully unmapped, no
  4989				 * further GUP references (FOLL_GET and FOLL_PIN) can
  4990				 * appear, so dropping the exclusive marker and mapping
  4991				 * it only R/O is fine.
  4992				 */
  4993				exclusive = false;
  4994			}
  4995		}
  4996	
  4997		/*
  4998		 * Some architectures may have to restore extra metadata to the page
  4999		 * when reading from swap. This metadata may be indexed by swap entry
  5000		 * so this must be called before folio_put_swap().
  5001		 */
  5002		arch_swap_restore(folio_swap(entry, folio), folio);
  5003	
  5004		add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
  5005		add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
  5006		pte = mk_pte(page, vma->vm_page_prot);
  5007		if (pte_swp_soft_dirty(vmf->orig_pte))
  5008			pte = pte_mksoft_dirty(pte);
  5009		if (pte_swp_uffd_wp(vmf->orig_pte))
  5010			pte = pte_mkuffd_wp(pte);
  5011	
  5012		/*
  5013		 * Same logic as in do_wp_page(); however, optimize for pages that are
  5014		 * certainly not shared either because we just allocated them without
  5015		 * exposing them to the swapcache or because the swap entry indicates
  5016		 * exclusivity.
  5017		 */
  5018		if (!folio_test_ksm(folio) &&
  5019		    (exclusive || folio_ref_count(folio) == 1)) {
  5020			if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
  5021			    !pte_needs_soft_dirty_wp(vma, pte)) {
  5022				pte = pte_mkwrite(pte, vma);
  5023				if (vmf->flags & FAULT_FLAG_WRITE) {
  5024					pte = pte_mkdirty(pte);
  5025					vmf->flags &= ~FAULT_FLAG_WRITE;
  5026				}
  5027			}
  5028			rmap_flags |= RMAP_EXCLUSIVE;
  5029		}
  5030		folio_ref_add(folio, nr_pages - 1);
  5031		flush_icache_pages(vma, page, nr_pages);
  5032		vmf->orig_pte = pte_advance_pfn(pte, page_idx);
  5033	
  5034		/* ksm created a completely new copy */
  5035		if (unlikely(folio != swapcache)) {
  5036			folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
  5037			folio_add_lru_vma(folio, vma);
  5038			folio_put_swap(swapcache, NULL);
  5039		} else if (!folio_test_anon(folio)) {
  5040			/*
  5041			 * We currently only expect !anon folios that are fully
  5042			 * mappable. See the comment after can_swapin_thp above.
  5043			 */
  5044			VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
  5045			VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
  5046			folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
  5047			folio_put_swap(folio, NULL);
  5048		} else {
  5049			VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
  5050			folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
  5051						 rmap_flags);
  5052			folio_put_swap(folio, nr_pages == 1 ? page : NULL);
  5053		}
  5054	
  5055		VM_BUG_ON(!folio_test_anon(folio) ||
  5056				(pte_write(pte) && !PageAnonExclusive(page)));
  5057		set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
  5058		arch_do_swap_page_nr(vma->vm_mm, vma, address,
  5059				pte, pte, nr_pages);
  5060	
  5061		/*
  5062		 * Remove the swap entry and conditionally try to free up the swapcache.
  5063		 * Do it after mapping, so raced page faults will likely see the folio
  5064		 * in swap cache and wait on the folio lock.
  5065		 */
  5066		if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
  5067			folio_free_swap(folio);
  5068	
  5069		folio_unlock(folio);
  5070		if (unlikely(folio != swapcache)) {
  5071			/*
  5072			 * Hold the lock to avoid the swap entry to be reused
  5073			 * until we take the PT lock for the pte_same() check
  5074			 * (to avoid false positives from pte_same). For
  5075			 * further safety release the lock after the folio_put_swap
  5076			 * so that the swap count won't change under a
  5077			 * parallel locked swapcache.
  5078			 */
  5079			folio_unlock(swapcache);
  5080			folio_put(swapcache);
  5081		}
  5082	
  5083		if (vmf->flags & FAULT_FLAG_WRITE) {
  5084			ret |= do_wp_page(vmf);
  5085			if (ret & VM_FAULT_ERROR)
  5086				ret &= VM_FAULT_ERROR;
  5087			goto out;
  5088		}
  5089	
  5090		/* No need to invalidate - it was non-present before */
  5091		update_mmu_cache_range(vmf, vma, address, ptep, nr_pages);
  5092	unlock:
  5093		if (vmf->pte)
  5094			pte_unmap_unlock(vmf->pte, vmf->ptl);
  5095	out:
  5096		if (si)
  5097			put_swap_device(si);
  5098		return ret;
  5099	out_nomap:
  5100		if (vmf->pte)
  5101			pte_unmap_unlock(vmf->pte, vmf->ptl);
  5102	out_page:
  5103		if (folio_test_swapcache(folio))
  5104			folio_free_swap(folio);
  5105		folio_unlock(folio);
  5106	out_release:
  5107		folio_put(folio);
  5108		if (folio != swapcache) {
  5109			folio_unlock(swapcache);
  5110			folio_put(swapcache);
  5111		}
  5112		if (si)
  5113			put_swap_device(si);
  5114		return ret;
  5115	}
  5116	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

