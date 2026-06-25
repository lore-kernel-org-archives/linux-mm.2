Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FC5CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F856B0098; Thu, 25 Jun 2026 01:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467E46B0099; Thu, 25 Jun 2026 01:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358D36B009B; Thu, 25 Jun 2026 01:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F00006B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:46:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B2E1405DC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:46:16 +0000 (UTC)
X-FDA: 84917349552.15.0156C01
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B75E180003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:46:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CuCD6uxV;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366374;
	b=AS6afEcm5QsteSwEgV7Q6yla7m/JYALpGM+aC0+dZyFTfrPEjutUQTGt/GEWpadnuofiWo
	yvXZVqW8UpR9elZd5vpT6/nLgIb2LkwhHifrtkphpBNIZl5snRIxRNsZGAiLgmoITroJWg
	PA3mrYuEMdmOz1gFbAHhthixktlXYQY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4nACneApVdsGq5YmoklBOc7dc9gZem01m9S3K0KPkU=;
	b=e5cON/dWlD3xENL8lR6GAqFAfycKy/9WgjyBLQQTy/UBNN+lrL8/HkQWHUoxKwYhrQXWWB
	OHXvq5wDU7jIjJ8mP435P3/oM2UQgLAaQSeCsXdeCfKL0Il9m7U5pXjHq0icpuay8SrWgt
	fnUNevSutzpFOD0BbkCl0fMRy3St+Fc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CuCD6uxV;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782366373; x=1813902373;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CF0Qpif2lRz1peTAm1ADsyGmWCzDr80ARjv0mpc3Kk8=;
  b=CuCD6uxVQb0mhkOt6RtK597qH8G/+cMcKddDqsKEEhz/c6Kbyw+MQKI9
   DxlyOXtX3T6UasDMeOYIpjQ9NC1sOUdx61FR7cJjYSIB+TRc/Z2Akh0Tl
   fyW8gL0NZH6VgzoS/vHAF4eePzWAlqi8hlTn7/J6DgqQpoW24ECp6OOWY
   VxUWOd5pF4gX7OC6LlRYy0bWLii0pRTl+nhmsg5G2iM2MnbgCTM2Z/dXm
   CF0z7yBBbvVMLZsmJ+TIT5WN2wIvZK9pm0owgRkhncqqJl12VLWsODter
   5WH/JGXLyYstuCKSkSzOvEAAhXQU4H/L2l75Oj/NuZESjTxkJfXfffA3O
   g==;
X-CSE-ConnectionGUID: PAxwsnmmQUaqc78Laeb8+w==
X-CSE-MsgGUID: FgxworcHQNS2OE8/rgKy5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="82121856"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="82121856"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 22:46:11 -0700
X-CSE-ConnectionGUID: TgBe4sbNSImv6HMaVV55Ew==
X-CSE-MsgGUID: 5iiTdnI/RfaHkbwKTp6RZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="280543917"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 24 Jun 2026 22:46:06 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wccua-000000003w9-1qFv;
	Thu, 25 Jun 2026 05:46:04 +0000
Date: Thu, 25 Jun 2026 13:45:57 +0800
From: kernel test robot <lkp@intel.com>
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Dev Jain <dev.jain@arm.com>,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, kas@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Message-ID: <202606251311.CCKYInqf-lkp@intel.com>
References: <20260625042853.2752898-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625042853.2752898-1-dev.jain@arm.com>
X-Stat-Signature: 1wcspbe19w163zk78be5ag1rp8b14oa5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B75E180003
X-HE-Tag: 1782366373-6959
X-HE-Meta: U2FsdGVkX18zDqjVs24w0PmzFk2ZcuqvvGDyS/k57O+6851ADtwottR5kcp07maxX11m/k2KyOOdPLgflM5kFbll7FEUn7hBu6zccb4VQTfKtPLdYU9obkSzISZhifQlCsgICkpkZ8ssW9HoNBioIl7R6zT/8RyWmju+M7PwXmmEdT0jbb0MFCpgo9RhmKFy8vsk1cSgDMIU/h43Sly5tBMcscEqzRt8VFJFUfXnnXT/aB6zznHHIZHWZMyq+RPX5u0YFiHIbzx+aWfbSM5hVgfwLQw385/aJY76fyXQIpotitd1+zUntOoqjHIb/jCOkOTMvQmopVUy82cG3o6aqN7vV+7ZTsp6k5/ram9M1gg77MozDiHbrHJNqqqHj/j+E2OGkvOphGyH9p8hVZtepE+pP5K2kzDqM3wbEViIInu3n8W2VpvU9rcp1+l1uoRj7/IOVyWphVZpFQ9CKFkVnG3hAX1kTI3rxTf3EMsFQdOg+pSXGMbS9Aumna/dXw5/JHTzaL6dUv4dUAIeO9VJZ5n994uue9lEO9MMvDnr2EZAO71is4eEPAUZ7Qy3P1pSRXlYURfBJQYs4583n91apam299c2/i3Wi95gI39/Ro4UtQvwGYXH1rlCLrJMlzNBarkqRMu0bpZeOCO8vyGaSUpRS3YN7xE61ADuw6KLUimhBXd7VAWcwp7ffcK2oQMnSOij/FlPDKgytfTAekQrFzdL3GlEcWUsbRXn1zVs4xfafcIg/ewpwta468DpIQeZxELxu3vgbOr0abSZQcCVI1OxR+rqjfqJvdUuEeerjKASWzbtPJ+K6//CLmZ5e0eEjGNxqYyAFR6eJj2StdhqX/r24O9/pzRLEpbiILmM4ufsx7pwznrSAc08uhWGNwpMC82R7UQtvaeTevrcZqi9HhSwp0wrNcG0bPn26Y4D+F4Es81DJx8BRDBvXRxe9TFtwrj01PhKw4aqQqilbIY
 /wGScS9s
 F4gOAFix42NAOQVOBd8kbgDe8Ut6XkqeP+N4WoVPB90NuF2TxHrz/Th9VK8/eI/LX3Y+w+G463o4EsblNBCo6dGTD2iI7EU0kqmwexLfUZakBJ9ZZwBmlfjqSAre4kVnOQ49KKwnQsAROmOiksZek6+P+AS2XYY+eOP/InS6XnoSoJyVTEkss0nVaLsdQpT8yC/HvYzDJLECjXtYeLZGZ3fQLg+dava9ZzfuS3l0U6Ey09b+LVvt06l7Yx41C5Ngmb05JktOgBcxsyxH25Q+mNzaY4aafQO/Rl4kt6yXryWESBdkLSW17E7WaZBDjdB5bJxXNjDbT4LkM8XcRJHp/NH1AOEjLueOxGaAfAlgSBuvB3ABL94Jrd3o2kWMHZktOx4GWbws/E+sVI+9fuHixk+fXFBBgbSdGbUSziQDFQnoacyNsrmZjYOw0ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Dev-Jain/mm-rmap-use-huge_ptep_get-in-try_to_unmap_one/20260625-123050
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260625042853.2752898-1-dev.jain%40arm.com
patch subject: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260625/202606251311.CCKYInqf-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260625/202606251311.CCKYInqf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606251311.CCKYInqf-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/rmap.c: In function 'try_to_unmap_one':
>> mm/rmap.c:2100:34: error: implicit declaration of function 'huge_ptep_get' [-Werror=implicit-function-declaration]
    2100 |                         pteval = huge_ptep_get(mm, address, pvmw.pte);
         |                                  ^~~~~~~~~~~~~
>> mm/rmap.c:2100:34: error: incompatible types when assigning to type 'pte_t' from type 'int'
   cc1: some warnings being treated as errors


vim +/huge_ptep_get +2100 mm/rmap.c

  1980	
  1981	/*
  1982	 * @arg: enum ttu_flags will be passed to this argument
  1983	 */
  1984	static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
  1985			     unsigned long address, void *arg)
  1986	{
  1987		struct mm_struct *mm = vma->vm_mm;
  1988		DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
  1989		bool anon_exclusive, ret = true;
  1990		pte_t pteval;
  1991		struct page *subpage;
  1992		struct mmu_notifier_range range;
  1993		enum ttu_flags flags = (enum ttu_flags)(long)arg;
  1994		unsigned long nr_pages = 1, end_addr;
  1995		unsigned long pfn;
  1996		unsigned long hsz = 0;
  1997		int ptes = 0;
  1998	
  1999		/*
  2000		 * When racing against e.g. zap_pte_range() on another cpu,
  2001		 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
  2002		 * try_to_unmap() may return before folio_mapped() has become false,
  2003		 * if page table locking is skipped: use TTU_SYNC to wait for that.
  2004		 */
  2005		if (flags & TTU_SYNC)
  2006			pvmw.flags = PVMW_SYNC;
  2007	
  2008		/*
  2009		 * For THP, we have to assume the worse case ie pmd for invalidation.
  2010		 * For hugetlb, it could be much worse if we need to do pud
  2011		 * invalidation in the case of pmd sharing.
  2012		 *
  2013		 * Note that the folio can not be freed in this function as call of
  2014		 * try_to_unmap() must hold a reference on the folio.
  2015		 */
  2016		range.end = vma_address_end(&pvmw);
  2017		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
  2018					address, range.end);
  2019		if (folio_test_hugetlb(folio)) {
  2020			/*
  2021			 * If sharing is possible, start and end will be adjusted
  2022			 * accordingly.
  2023			 */
  2024			adjust_range_if_pmd_sharing_possible(vma, &range.start,
  2025							     &range.end);
  2026	
  2027			/* We need the huge page size for set_huge_pte_at() */
  2028			hsz = huge_page_size(hstate_vma(vma));
  2029		}
  2030		mmu_notifier_invalidate_range_start(&range);
  2031	
  2032		while (page_vma_mapped_walk(&pvmw)) {
  2033			nr_pages = 1;
  2034	
  2035			/*
  2036			 * If the folio is in an mlock()d vma, we must not swap it out.
  2037			 */
  2038			if (!(flags & TTU_IGNORE_MLOCK) &&
  2039			    (vma->vm_flags & VM_LOCKED)) {
  2040				ptes++;
  2041	
  2042				/*
  2043				 * Set 'ret' to indicate the page cannot be unmapped.
  2044				 *
  2045				 * Do not jump to walk_abort immediately as additional
  2046				 * iteration might be required to detect fully mapped
  2047				 * folio an mlock it.
  2048				 */
  2049				ret = false;
  2050	
  2051				/* Only mlock fully mapped pages */
  2052				if (pvmw.pte && ptes != pvmw.nr_pages)
  2053					continue;
  2054	
  2055				/*
  2056				 * All PTEs must be protected by page table lock in
  2057				 * order to mlock the page.
  2058				 *
  2059				 * If page table boundary has been cross, current ptl
  2060				 * only protect part of ptes.
  2061				 */
  2062				if (pvmw.flags & PVMW_PGTABLE_CROSSED)
  2063					goto walk_done;
  2064	
  2065				/* Restore the mlock which got missed */
  2066				mlock_vma_folio(folio, vma);
  2067				goto walk_done;
  2068			}
  2069	
  2070			if (!pvmw.pte) {
  2071				if (folio_test_lazyfree(folio)) {
  2072					if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
  2073						goto walk_done;
  2074					/*
  2075					 * unmap_huge_pmd_locked has either already marked
  2076					 * the folio as swap-backed or decided to retain it
  2077					 * due to GUP or speculative references.
  2078					 */
  2079					goto walk_abort;
  2080				}
  2081	
  2082				if (flags & TTU_SPLIT_HUGE_PMD) {
  2083					/*
  2084					 * We temporarily have to drop the PTL and
  2085					 * restart so we can process the PTE-mapped THP.
  2086					 */
  2087					split_huge_pmd_locked(vma, pvmw.address,
  2088							      pvmw.pmd, false);
  2089					flags &= ~TTU_SPLIT_HUGE_PMD;
  2090					page_vma_mapped_walk_restart(&pvmw);
  2091					continue;
  2092				}
  2093			}
  2094	
  2095			/* Unexpected PMD-mapped THP? */
  2096			VM_BUG_ON_FOLIO(!pvmw.pte, folio);
  2097	
  2098			address = pvmw.address;
  2099			if (folio_test_hugetlb(folio)) {
> 2100				pteval = huge_ptep_get(mm, address, pvmw.pte);
  2101			} else {
  2102				/*
  2103				 * Handle PFN swap PTEs, such as device-exclusive ones,
  2104				 * that actually map pages.
  2105				 */
  2106				pteval = ptep_get(pvmw.pte);
  2107			}
  2108			if (likely(pte_present(pteval))) {
  2109				pfn = pte_pfn(pteval);
  2110			} else {
  2111				const softleaf_t entry = softleaf_from_pte(pteval);
  2112	
  2113				pfn = softleaf_to_pfn(entry);
  2114				VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
  2115			}
  2116	
  2117			subpage = folio_page(folio, pfn - folio_pfn(folio));
  2118			anon_exclusive = folio_test_anon(folio) &&
  2119					 PageAnonExclusive(subpage);
  2120	
  2121			if (folio_test_hugetlb(folio)) {
  2122				bool anon = folio_test_anon(folio);
  2123	
  2124				/*
  2125				 * The try_to_unmap() is only passed a hugetlb page
  2126				 * in the case where the hugetlb page is poisoned.
  2127				 */
  2128				VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
  2129				/*
  2130				 * huge_pmd_unshare may unmap an entire PMD page.
  2131				 * There is no way of knowing exactly which PMDs may
  2132				 * be cached for this mm, so we must flush them all.
  2133				 * start/end were already adjusted above to cover this
  2134				 * range.
  2135				 */
  2136				flush_cache_range(vma, range.start, range.end);
  2137	
  2138				/*
  2139				 * To call huge_pmd_unshare, i_mmap_rwsem must be
  2140				 * held in write mode.  Caller needs to explicitly
  2141				 * do this outside rmap routines.
  2142				 *
  2143				 * We also must hold hugetlb vma_lock in write mode.
  2144				 * Lock order dictates acquiring vma_lock BEFORE
  2145				 * i_mmap_rwsem.  We can only try lock here and fail
  2146				 * if unsuccessful.
  2147				 */
  2148				if (!anon) {
  2149					struct mmu_gather tlb;
  2150	
  2151					VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
  2152					if (!hugetlb_vma_trylock_write(vma))
  2153						goto walk_abort;
  2154	
  2155					tlb_gather_mmu_vma(&tlb, vma);
  2156					if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
  2157						hugetlb_vma_unlock_write(vma);
  2158						huge_pmd_unshare_flush(&tlb, vma);
  2159						tlb_finish_mmu(&tlb);
  2160						/*
  2161						 * The PMD table was unmapped,
  2162						 * consequently unmapping the folio.
  2163						 */
  2164						goto walk_done;
  2165					}
  2166					hugetlb_vma_unlock_write(vma);
  2167					tlb_finish_mmu(&tlb);
  2168				}
  2169				pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
  2170				if (pte_dirty(pteval))
  2171					folio_mark_dirty(folio);
  2172			} else if (likely(pte_present(pteval))) {
  2173				nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
  2174				end_addr = address + nr_pages * PAGE_SIZE;
  2175				flush_cache_range(vma, address, end_addr);
  2176	
  2177				/* Nuke the page table entry. */
  2178				pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
  2179				/*
  2180				 * We clear the PTE but do not flush so potentially
  2181				 * a remote CPU could still be writing to the folio.
  2182				 * If the entry was previously clean then the
  2183				 * architecture must guarantee that a clear->dirty
  2184				 * transition on a cached TLB entry is written through
  2185				 * and traps if the PTE is unmapped.
  2186				 */
  2187				if (should_defer_flush(mm, flags))
  2188					set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
  2189				else
  2190					flush_tlb_range(vma, address, end_addr);
  2191				if (pte_dirty(pteval))
  2192					folio_mark_dirty(folio);
  2193			} else {
  2194				pte_clear(mm, address, pvmw.pte);
  2195			}
  2196	
  2197			/*
  2198			 * Now the pte is cleared. If this pte was uffd-wp armed,
  2199			 * we may want to replace a none pte with a marker pte if
  2200			 * it's file-backed, so we don't lose the tracking info.
  2201			 */
  2202			pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
  2203	
  2204			/* Update high watermark before we lower rss */
  2205			update_hiwater_rss(mm);
  2206	
  2207			if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
  2208				pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
  2209				if (folio_test_hugetlb(folio)) {
  2210					hugetlb_count_sub(folio_nr_pages(folio), mm);
  2211					set_huge_pte_at(mm, address, pvmw.pte, pteval,
  2212							hsz);
  2213				} else {
  2214					dec_mm_counter(mm, mm_counter(folio));
  2215					set_pte_at(mm, address, pvmw.pte, pteval);
  2216				}
  2217			} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
  2218				   !userfaultfd_armed(vma)) {
  2219				/*
  2220				 * The guest indicated that the page content is of no
  2221				 * interest anymore. Simply discard the pte, vmscan
  2222				 * will take care of the rest.
  2223				 * A future reference will then fault in a new zero
  2224				 * page. When userfaultfd is active, we must not drop
  2225				 * this page though, as its main user (postcopy
  2226				 * migration) will not expect userfaults on already
  2227				 * copied pages.
  2228				 */
  2229				dec_mm_counter(mm, mm_counter(folio));
  2230			} else if (folio_test_anon(folio)) {
  2231				swp_entry_t entry = page_swap_entry(subpage);
  2232				pte_t swp_pte;
  2233				/*
  2234				 * Store the swap location in the pte.
  2235				 * See handle_pte_fault() ...
  2236				 */
  2237				if (unlikely(folio_test_swapbacked(folio) !=
  2238						folio_test_swapcache(folio))) {
  2239					WARN_ON_ONCE(1);
  2240					goto walk_abort;
  2241				}
  2242	
  2243				/* MADV_FREE page check */
  2244				if (!folio_test_swapbacked(folio)) {
  2245					int ref_count, map_count;
  2246	
  2247					/*
  2248					 * Synchronize with gup_pte_range():
  2249					 * - clear PTE; barrier; read refcount
  2250					 * - inc refcount; barrier; read PTE
  2251					 */
  2252					smp_mb();
  2253	
  2254					ref_count = folio_ref_count(folio);
  2255					map_count = folio_mapcount(folio);
  2256	
  2257					/*
  2258					 * Order reads for page refcount and dirty flag
  2259					 * (see comments in __remove_mapping()).
  2260					 */
  2261					smp_rmb();
  2262	
  2263					if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
  2264						/*
  2265						 * redirtied either using the page table or a previously
  2266						 * obtained GUP reference.
  2267						 */
  2268						set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
  2269						folio_set_swapbacked(folio);
  2270						goto walk_abort;
  2271					} else if (ref_count != 1 + map_count) {
  2272						/*
  2273						 * Additional reference. Could be a GUP reference or any
  2274						 * speculative reference. GUP users must mark the folio
  2275						 * dirty if there was a modification. This folio cannot be
  2276						 * reclaimed right now either way, so act just like nothing
  2277						 * happened.
  2278						 * We'll come back here later and detect if the folio was
  2279						 * dirtied when the additional reference is gone.
  2280						 */
  2281						set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
  2282						goto walk_abort;
  2283					}
  2284					add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
  2285					goto discard;
  2286				}
  2287	
  2288				if (folio_dup_swap(folio, subpage) < 0) {
  2289					set_pte_at(mm, address, pvmw.pte, pteval);
  2290					goto walk_abort;
  2291				}
  2292	
  2293				/*
  2294				 * arch_unmap_one() is expected to be a NOP on
  2295				 * architectures where we could have PFN swap PTEs,
  2296				 * so we'll not check/care.
  2297				 */
  2298				if (arch_unmap_one(mm, vma, address, pteval) < 0) {
  2299					folio_put_swap(folio, subpage);
  2300					set_pte_at(mm, address, pvmw.pte, pteval);
  2301					goto walk_abort;
  2302				}
  2303	
  2304				/* See folio_try_share_anon_rmap(): clear PTE first. */
  2305				if (anon_exclusive &&
  2306				    folio_try_share_anon_rmap_pte(folio, subpage)) {
  2307					folio_put_swap(folio, subpage);
  2308					set_pte_at(mm, address, pvmw.pte, pteval);
  2309					goto walk_abort;
  2310				}
  2311				if (list_empty(&mm->mmlist)) {
  2312					spin_lock(&mmlist_lock);
  2313					if (list_empty(&mm->mmlist))
  2314						list_add(&mm->mmlist, &init_mm.mmlist);
  2315					spin_unlock(&mmlist_lock);
  2316				}
  2317				dec_mm_counter(mm, MM_ANONPAGES);
  2318				inc_mm_counter(mm, MM_SWAPENTS);
  2319				swp_pte = swp_entry_to_pte(entry);
  2320				if (anon_exclusive)
  2321					swp_pte = pte_swp_mkexclusive(swp_pte);
  2322				if (likely(pte_present(pteval))) {
  2323					if (pte_soft_dirty(pteval))
  2324						swp_pte = pte_swp_mksoft_dirty(swp_pte);
  2325					if (pte_uffd_wp(pteval))
  2326						swp_pte = pte_swp_mkuffd_wp(swp_pte);
  2327				} else {
  2328					if (pte_swp_soft_dirty(pteval))
  2329						swp_pte = pte_swp_mksoft_dirty(swp_pte);
  2330					if (pte_swp_uffd_wp(pteval))
  2331						swp_pte = pte_swp_mkuffd_wp(swp_pte);
  2332				}
  2333				set_pte_at(mm, address, pvmw.pte, swp_pte);
  2334			} else {
  2335				/*
  2336				 * This is a locked file-backed folio,
  2337				 * so it cannot be removed from the page
  2338				 * cache and replaced by a new folio before
  2339				 * mmu_notifier_invalidate_range_end, so no
  2340				 * concurrent thread might update its page table
  2341				 * to point at a new folio while a device is
  2342				 * still using this folio.
  2343				 *
  2344				 * See Documentation/mm/mmu_notifier.rst
  2345				 */
  2346				add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
  2347			}
  2348	discard:
  2349			if (unlikely(folio_test_hugetlb(folio))) {
  2350				hugetlb_remove_rmap(folio);
  2351			} else {
  2352				folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
  2353			}
  2354			if (vma->vm_flags & VM_LOCKED)
  2355				mlock_drain_local();
  2356			folio_put_refs(folio, nr_pages);
  2357	
  2358			/*
  2359			 * If we are sure that we batched the entire folio and cleared
  2360			 * all PTEs, we can just optimize and stop right here.
  2361			 */
  2362			if (nr_pages == folio_nr_pages(folio))
  2363				goto walk_done;
  2364			continue;
  2365	walk_abort:
  2366			ret = false;
  2367	walk_done:
  2368			page_vma_mapped_walk_done(&pvmw);
  2369			break;
  2370		}
  2371	
  2372		mmu_notifier_invalidate_range_end(&range);
  2373	
  2374		return ret;
  2375	}
  2376	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

