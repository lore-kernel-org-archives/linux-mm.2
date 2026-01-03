Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5CCFC6165
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 03:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F45B6B008A; Fri,  2 Jan 2026 22:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2366B008C; Fri,  2 Jan 2026 22:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876B86B0092; Fri,  2 Jan 2026 22:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72C9E6B008A
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 22:22:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E53878FE19
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:22:29 +0000 (UTC)
X-FDA: 84289204818.11.1891D00
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64DA5C0003
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:22:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ezgth/AR";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767410547; a=rsa-sha256;
	cv=none;
	b=FS81o550b9bSkilxBNAjKMn1C3E2R/ynTYD48jNvzjUNI9s7n9zL058+FX4vF9IGeghqDh
	8R03B1q1m55vfAOAMQhxaX+bvOpj04OPNAxUg53aRL+j2z+7kQQtjuAkz4oiOppGLUg4T7
	jwjgSPCRR+IuOo7MuNyIDqr07z0Uigo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ezgth/AR";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767410547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgpS+6/IreObuLCKzsh1Bik8rDmoVQZh7BPw6zp5St0=;
	b=2JmyfSBBAmT3fRUIcnCA3+iqZE3xmh/U5VnQ8/Z9khbuZtp0jV2ZR/1rUcunVNSXizw9dr
	Hs8dn5f3diUALZ3PLNs2yKlLb/4HBNo6WIbh4M9NDPpHY+78qxqmuOq0wh8PjaD2aqY4We
	IISoNpKDno8jAG5RIOiJZhEFGbjHNzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767410546; x=1798946546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/KS68S1wUbRid/TxE3cBE6LAtmAlf9OSK2uLviI4c3E=;
  b=Ezgth/AR7cvXeLlX1a1pHvMQVFhe7Vd5UTQc+sfj3nRjQBtZLHG7lIBZ
   WJ8SNYaZvk7zKYHja7shcNGh9uqWf2Obyoumn2T7eXfrgTINAVUeHn3uY
   ORpDsoHVh58V2i2h/+rWqOXzlEiOU1eSxSmgkgvWGolXPU6BY5IcdCbu9
   XSywuPH94ZtG7Go0o+vpcFOX1HGkOa/8pRIDkJzl3O6M0b46j+9Tfam23
   TrruPaSdJW1ssnDzSEIh+C/IJOAZ5kcpnPouaY1H4J2OQ5Q9dYK4VTk64
   3CNiWazRZNvNYSMQAZEA0pHzCHwZiL3rvrLtRU6MojX2AipQwnMOReQIy
   w==;
X-CSE-ConnectionGUID: CMBzs6UTSS2nL6PA2AG5/w==
X-CSE-MsgGUID: j1qi/ZcoROKKL3gtqzAWXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="79187726"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="79187726"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 19:22:24 -0800
X-CSE-ConnectionGUID: mTwaqU1ZRMuhiPcw+/oVTw==
X-CSE-MsgGUID: Kg9tDkPASDKxssLZ4IjbwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="206071317"
Received: from lkp-server01.sh.intel.com (HELO c9aa31daaa89) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 02 Jan 2026 19:22:18 -0800
Received: from kbuild by c9aa31daaa89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vbsDY-000000002Yb-2k3D;
	Sat, 03 Jan 2026 03:22:16 +0000
Date: Sat, 3 Jan 2026 11:22:13 +0800
From: kernel test robot <lkp@intel.com>
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, balbirs@nvidia.com,
	matthew.brost@intel.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
	mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca, Felix.Kuehling@amd.com
Subject: Re: [PATCH v1 3/8] mm: Add helpers to create migration entries from
 struct pages
Message-ID: <202601030958.73URABlJ-lkp@intel.com>
References: <20251231043154.42931-4-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231043154.42931-4-jniethe@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 64DA5C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 1oiz4cgcoggy8zkwza81od6tzg6noigp
X-HE-Tag: 1767410546-869453
X-HE-Meta: U2FsdGVkX1/+Fl+XIZUKYeu8DcdwOKaFMTFmKUxsfJfl6n/DXmvyTBJ4saiSKQHka6pnH98hk35ADTCuc0H4HD4FBC5M2PKH8wI5lnsc1fzofgqit2/uB9uWj9CZU/v2ORrfoAp2sYzh2nMMqcXPno8oo3mzG3UDMRdFk+yLODtabIN55YWH3p/DbEkHr6fS7mSBjCUW/uvEXQ8aDNr8piCen5RYyWJSmt2Ocs71c1fLSroDDcfAzHeeZuJxSKtDc+LN8qGSlhsuP3k46muzypkpflIbxfo62sSRX+59Zk5sv1Yrs+l4k6soWJV8gxyJ5y9G1xIa5RMjFFnA8QxVqy/QND0sJwyn1RCpxUaGOs0zLacsqdLtFFArZg2XdSK/83QqiEFE8fVPq5PjbEVqyLI42UV+C1jk4XJUtYaDAGcU3I1/i0HdKfFykYTjuKJ964ZcW2KR0QBxMhTmT6tBJWZHK1a+P/8krZRbCwBD5pihJQUQD2w8C2Ga4j+6ng/NrWcE+iLgjDV3wAxIKtJ2kgRgVx4wA5WykGpfSx6xNhmk3a/7F5I/QQdFdedFivsoYM9a7Aqx/ubQi14xRSaTEQyYhO6uIJ6XvnO9XUrA5SvpG2Maj0UFrMBR019iBPd4/yjDq5fP/0HbQE4/z3w/HZ3ZTHDOvySsYypAzHvfPzs87MS6fRbzkdxAYXw90CWkeGrCUITn9ipA//B5zUwkNLI0GW4zRUdbXR2TRTB3ZD8hTLj4LU1ya+mkD+vAA0NkySlZAx8g1a7V4zCwpQACQhcw0ryt5sH3WOdmoeA411lMWntp6pok7N/GNswTVGN04xJZLu8aCe7SVXdJ/VZ779s5XEvpSjlvyZ0s837wbkkqqBrTcmR5fE4YTflGlEllP7VU2e8r1leyDeDCqAg7TGS5Sj9MOpVgqJYxPgAjL0INmalR2IptGLuDOSVFCHIHNmjVmSalKmWMQ9rcrVz
 P2tQleLT
 Z2Zj93Gpb34WhZziH+okMelPYDKMb4RmarGWsz2wOrdxB/fwgJE8PInh0JMPgJynV/Vis11na10cJHEGsGJSgfwE9Jp06htq0ARp/hetbfuysQ4e18+U7OBa4TzUd5tEUMq6RPnOZ17sfloOZf1VPBozPXYdwe34QUa3ZW0LL5tai+yiuIw4Km57sLGO/PwA00hmuJ6uKeKsdTCBqTdfcf0KACIcv+me9dXtE7QwZwcw3nbBWsYEmPrHfRICYV35VLADvYo+lE1BYHH1st/+1ewgnr5F5LU9W+eNhv+XXjVi3f7V7nlU0M6M1cSlV2bzFv1TM47idI5Vh6oHWqqX/hORItJ4LOUYjWtGw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

kernel test robot noticed the following build errors:

[auto build test ERROR on f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da]

url:    https://github.com/intel-lab-lkp/linux/commits/Jordan-Niethe/mm-migrate_device-Add-migrate-PFN-flag-to-track-device-private-pages/20251231-123453
base:   f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
patch link:    https://lore.kernel.org/r/20251231043154.42931-4-jniethe%40nvidia.com
patch subject: [PATCH v1 3/8] mm: Add helpers to create migration entries from struct pages
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20260103/202601030958.73URABlJ-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260103/202601030958.73URABlJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601030958.73URABlJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/rmap.c: In function 'try_to_migrate_one':
>> mm/rmap.c:2542:41: error: implicit declaration of function 'make_writable_migration_entry_from_page'; did you mean 'make_readable_migration_entry_from_page'? [-Wimplicit-function-declaration]
    2542 |                                 entry = make_writable_migration_entry_from_page(
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                         make_readable_migration_entry_from_page
>> mm/rmap.c:2542:41: error: incompatible types when assigning to type 'swp_entry_t' from type 'int'


vim +2542 mm/rmap.c

  2275	
  2276	/*
  2277	 * @arg: enum ttu_flags will be passed to this argument.
  2278	 *
  2279	 * If TTU_SPLIT_HUGE_PMD is specified any PMD mappings will be split into PTEs
  2280	 * containing migration entries.
  2281	 */
  2282	static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
  2283			     unsigned long address, void *arg)
  2284	{
  2285		struct mm_struct *mm = vma->vm_mm;
  2286		DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
  2287		bool anon_exclusive, writable, ret = true;
  2288		pte_t pteval;
  2289		struct page *subpage;
  2290		struct mmu_notifier_range range;
  2291		enum ttu_flags flags = (enum ttu_flags)(long)arg;
  2292		unsigned long pfn;
  2293		unsigned long hsz = 0;
  2294	
  2295		/*
  2296		 * When racing against e.g. zap_pte_range() on another cpu,
  2297		 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
  2298		 * try_to_migrate() may return before page_mapped() has become false,
  2299		 * if page table locking is skipped: use TTU_SYNC to wait for that.
  2300		 */
  2301		if (flags & TTU_SYNC)
  2302			pvmw.flags = PVMW_SYNC;
  2303	
  2304		/*
  2305		 * For THP, we have to assume the worse case ie pmd for invalidation.
  2306		 * For hugetlb, it could be much worse if we need to do pud
  2307		 * invalidation in the case of pmd sharing.
  2308		 *
  2309		 * Note that the page can not be free in this function as call of
  2310		 * try_to_unmap() must hold a reference on the page.
  2311		 */
  2312		range.end = vma_address_end(&pvmw);
  2313		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
  2314					address, range.end);
  2315		if (folio_test_hugetlb(folio)) {
  2316			/*
  2317			 * If sharing is possible, start and end will be adjusted
  2318			 * accordingly.
  2319			 */
  2320			adjust_range_if_pmd_sharing_possible(vma, &range.start,
  2321							     &range.end);
  2322	
  2323			/* We need the huge page size for set_huge_pte_at() */
  2324			hsz = huge_page_size(hstate_vma(vma));
  2325		}
  2326		mmu_notifier_invalidate_range_start(&range);
  2327	
  2328		while (page_vma_mapped_walk(&pvmw)) {
  2329			/* PMD-mapped THP migration entry */
  2330			if (!pvmw.pte) {
  2331				__maybe_unused unsigned long pfn;
  2332				__maybe_unused pmd_t pmdval;
  2333	
  2334				if (flags & TTU_SPLIT_HUGE_PMD) {
  2335					split_huge_pmd_locked(vma, pvmw.address,
  2336							      pvmw.pmd, true);
  2337					ret = false;
  2338					page_vma_mapped_walk_done(&pvmw);
  2339					break;
  2340				}
  2341	#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
  2342				pmdval = pmdp_get(pvmw.pmd);
  2343				if (likely(pmd_present(pmdval)))
  2344					pfn = pmd_pfn(pmdval);
  2345				else
  2346					pfn = softleaf_to_pfn(softleaf_from_pmd(pmdval));
  2347	
  2348				subpage = folio_page(folio, pfn - folio_pfn(folio));
  2349	
  2350				VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
  2351						!folio_test_pmd_mappable(folio), folio);
  2352	
  2353				if (set_pmd_migration_entry(&pvmw, subpage)) {
  2354					ret = false;
  2355					page_vma_mapped_walk_done(&pvmw);
  2356					break;
  2357				}
  2358				continue;
  2359	#endif
  2360			}
  2361	
  2362			/* Unexpected PMD-mapped THP? */
  2363			VM_BUG_ON_FOLIO(!pvmw.pte, folio);
  2364	
  2365			/*
  2366			 * Handle PFN swap PTEs, such as device-exclusive ones, that
  2367			 * actually map pages.
  2368			 */
  2369			pteval = ptep_get(pvmw.pte);
  2370			if (likely(pte_present(pteval))) {
  2371				pfn = pte_pfn(pteval);
  2372			} else {
  2373				const softleaf_t entry = softleaf_from_pte(pteval);
  2374	
  2375				pfn = softleaf_to_pfn(entry);
  2376				VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
  2377			}
  2378	
  2379			subpage = folio_page(folio, pfn - folio_pfn(folio));
  2380			address = pvmw.address;
  2381			anon_exclusive = folio_test_anon(folio) &&
  2382					 PageAnonExclusive(subpage);
  2383	
  2384			if (folio_test_hugetlb(folio)) {
  2385				bool anon = folio_test_anon(folio);
  2386	
  2387				/*
  2388				 * huge_pmd_unshare may unmap an entire PMD page.
  2389				 * There is no way of knowing exactly which PMDs may
  2390				 * be cached for this mm, so we must flush them all.
  2391				 * start/end were already adjusted above to cover this
  2392				 * range.
  2393				 */
  2394				flush_cache_range(vma, range.start, range.end);
  2395	
  2396				/*
  2397				 * To call huge_pmd_unshare, i_mmap_rwsem must be
  2398				 * held in write mode.  Caller needs to explicitly
  2399				 * do this outside rmap routines.
  2400				 *
  2401				 * We also must hold hugetlb vma_lock in write mode.
  2402				 * Lock order dictates acquiring vma_lock BEFORE
  2403				 * i_mmap_rwsem.  We can only try lock here and
  2404				 * fail if unsuccessful.
  2405				 */
  2406				if (!anon) {
  2407					VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
  2408					if (!hugetlb_vma_trylock_write(vma)) {
  2409						page_vma_mapped_walk_done(&pvmw);
  2410						ret = false;
  2411						break;
  2412					}
  2413					if (huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
  2414						hugetlb_vma_unlock_write(vma);
  2415						flush_tlb_range(vma,
  2416							range.start, range.end);
  2417	
  2418						/*
  2419						 * The ref count of the PMD page was
  2420						 * dropped which is part of the way map
  2421						 * counting is done for shared PMDs.
  2422						 * Return 'true' here.  When there is
  2423						 * no other sharing, huge_pmd_unshare
  2424						 * returns false and we will unmap the
  2425						 * actual page and drop map count
  2426						 * to zero.
  2427						 */
  2428						page_vma_mapped_walk_done(&pvmw);
  2429						break;
  2430					}
  2431					hugetlb_vma_unlock_write(vma);
  2432				}
  2433				/* Nuke the hugetlb page table entry */
  2434				pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
  2435				if (pte_dirty(pteval))
  2436					folio_mark_dirty(folio);
  2437				writable = pte_write(pteval);
  2438			} else if (likely(pte_present(pteval))) {
  2439				flush_cache_page(vma, address, pfn);
  2440				/* Nuke the page table entry. */
  2441				if (should_defer_flush(mm, flags)) {
  2442					/*
  2443					 * We clear the PTE but do not flush so potentially
  2444					 * a remote CPU could still be writing to the folio.
  2445					 * If the entry was previously clean then the
  2446					 * architecture must guarantee that a clear->dirty
  2447					 * transition on a cached TLB entry is written through
  2448					 * and traps if the PTE is unmapped.
  2449					 */
  2450					pteval = ptep_get_and_clear(mm, address, pvmw.pte);
  2451	
  2452					set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
  2453				} else {
  2454					pteval = ptep_clear_flush(vma, address, pvmw.pte);
  2455				}
  2456				if (pte_dirty(pteval))
  2457					folio_mark_dirty(folio);
  2458				writable = pte_write(pteval);
  2459			} else {
  2460				const softleaf_t entry = softleaf_from_pte(pteval);
  2461	
  2462				pte_clear(mm, address, pvmw.pte);
  2463	
  2464				writable = softleaf_is_device_private_write(entry);
  2465			}
  2466	
  2467			VM_WARN_ON_FOLIO(writable && folio_test_anon(folio) &&
  2468					!anon_exclusive, folio);
  2469	
  2470			/* Update high watermark before we lower rss */
  2471			update_hiwater_rss(mm);
  2472	
  2473			if (PageHWPoison(subpage)) {
  2474				VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
  2475	
  2476				pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
  2477				if (folio_test_hugetlb(folio)) {
  2478					hugetlb_count_sub(folio_nr_pages(folio), mm);
  2479					set_huge_pte_at(mm, address, pvmw.pte, pteval,
  2480							hsz);
  2481				} else {
  2482					dec_mm_counter(mm, mm_counter(folio));
  2483					set_pte_at(mm, address, pvmw.pte, pteval);
  2484				}
  2485			} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
  2486				   !userfaultfd_armed(vma)) {
  2487				/*
  2488				 * The guest indicated that the page content is of no
  2489				 * interest anymore. Simply discard the pte, vmscan
  2490				 * will take care of the rest.
  2491				 * A future reference will then fault in a new zero
  2492				 * page. When userfaultfd is active, we must not drop
  2493				 * this page though, as its main user (postcopy
  2494				 * migration) will not expect userfaults on already
  2495				 * copied pages.
  2496				 */
  2497				dec_mm_counter(mm, mm_counter(folio));
  2498			} else {
  2499				swp_entry_t entry;
  2500				pte_t swp_pte;
  2501	
  2502				/*
  2503				 * arch_unmap_one() is expected to be a NOP on
  2504				 * architectures where we could have PFN swap PTEs,
  2505				 * so we'll not check/care.
  2506				 */
  2507				if (arch_unmap_one(mm, vma, address, pteval) < 0) {
  2508					if (folio_test_hugetlb(folio))
  2509						set_huge_pte_at(mm, address, pvmw.pte,
  2510								pteval, hsz);
  2511					else
  2512						set_pte_at(mm, address, pvmw.pte, pteval);
  2513					ret = false;
  2514					page_vma_mapped_walk_done(&pvmw);
  2515					break;
  2516				}
  2517	
  2518				/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
  2519				if (folio_test_hugetlb(folio)) {
  2520					if (anon_exclusive &&
  2521					    hugetlb_try_share_anon_rmap(folio)) {
  2522						set_huge_pte_at(mm, address, pvmw.pte,
  2523								pteval, hsz);
  2524						ret = false;
  2525						page_vma_mapped_walk_done(&pvmw);
  2526						break;
  2527					}
  2528				} else if (anon_exclusive &&
  2529					   folio_try_share_anon_rmap_pte(folio, subpage)) {
  2530					set_pte_at(mm, address, pvmw.pte, pteval);
  2531					ret = false;
  2532					page_vma_mapped_walk_done(&pvmw);
  2533					break;
  2534				}
  2535	
  2536				/*
  2537				 * Store the pfn of the page in a special migration
  2538				 * pte. do_swap_page() will wait until the migration
  2539				 * pte is removed and then restart fault handling.
  2540				 */
  2541				if (writable)
> 2542					entry = make_writable_migration_entry_from_page(
  2543								subpage);
  2544				else if (anon_exclusive)
  2545					entry = make_readable_exclusive_migration_entry_from_page(
  2546								subpage);
  2547				else
  2548					entry = make_readable_migration_entry_from_page(
  2549								subpage);
  2550				if (likely(pte_present(pteval))) {
  2551					if (pte_young(pteval))
  2552						entry = make_migration_entry_young(entry);
  2553					if (pte_dirty(pteval))
  2554						entry = make_migration_entry_dirty(entry);
  2555					swp_pte = swp_entry_to_pte(entry);
  2556					if (pte_soft_dirty(pteval))
  2557						swp_pte = pte_swp_mksoft_dirty(swp_pte);
  2558					if (pte_uffd_wp(pteval))
  2559						swp_pte = pte_swp_mkuffd_wp(swp_pte);
  2560				} else {
  2561					swp_pte = swp_entry_to_pte(entry);
  2562					if (pte_swp_soft_dirty(pteval))
  2563						swp_pte = pte_swp_mksoft_dirty(swp_pte);
  2564					if (pte_swp_uffd_wp(pteval))
  2565						swp_pte = pte_swp_mkuffd_wp(swp_pte);
  2566				}
  2567				if (folio_test_hugetlb(folio))
  2568					set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
  2569							hsz);
  2570				else
  2571					set_pte_at(mm, address, pvmw.pte, swp_pte);
  2572				trace_set_migration_pte(address, pte_val(swp_pte),
  2573							folio_order(folio));
  2574				/*
  2575				 * No need to invalidate here it will synchronize on
  2576				 * against the special swap migration pte.
  2577				 */
  2578			}
  2579	
  2580			if (unlikely(folio_test_hugetlb(folio)))
  2581				hugetlb_remove_rmap(folio);
  2582			else
  2583				folio_remove_rmap_pte(folio, subpage, vma);
  2584			if (vma->vm_flags & VM_LOCKED)
  2585				mlock_drain_local();
  2586			folio_put(folio);
  2587		}
  2588	
  2589		mmu_notifier_invalidate_range_end(&range);
  2590	
  2591		return ret;
  2592	}
  2593	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

