Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF7FCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 14:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84708E0079; Thu,  9 Oct 2025 10:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33AF8E003F; Thu,  9 Oct 2025 10:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923688E0079; Thu,  9 Oct 2025 10:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77E538E003F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:10:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BFB414099B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:10:43 +0000 (UTC)
X-FDA: 83978761566.14.6B648A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id B70A4C0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:10:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kRjK9isp;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760019041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K9jpTtRboBqCSxMC7PORbuV1IkxkjvEu0jCXkW0MYsY=;
	b=PNWHxE4ZHiIlW+w81DWQnpTMU5mjLsOt0SluT4cXTANzRaP55CtS0tNPakjrzEIQlhYuV2
	PBX2miwWlBosPbIdCsXQlQ8EbawthOl+JVSwvZZdJ/vercwS5CKmU5iNBIT6iwM9RclfaM
	6x8YABZ5Wg9Np3cHxSVGD0pYf9rTjMI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kRjK9isp;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760019041; a=rsa-sha256;
	cv=none;
	b=B4KcNb152P70sENT1AZothAm2RWYiamBQIQ7bJ4tL3cQVYIDhvoVpi4+aVegf+yTvGOPjS
	S+xLN5DyW6uAzSusHaxq9XNEKqBUxOFk46Su/JwgAvReF3Gsa5ksrCaxos7vj8hkkh+zDB
	ZuJIcHWCDUzYGCWybedGsSHMoOaqJY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760019039; x=1791555039;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=xiD9JdCG6GYY8bizkz8QTcTAeMChxyCADvZQGZwSY1I=;
  b=kRjK9ispCTNfbJJ9TVUuvJqJtKv+0WDuutuY/ibXw/DziEXs7tVNsh4d
   BKcJXZq1q5Mkfr4G03XJeKxIOxsfGLYrc7gI/ZQBTxJ52e4vI4n4eMEbQ
   Yj8lOxHVmaK4u/mtjSveb6xJMLW+3wmed+DpuVOklGafdShlPXBVNK6DA
   qPdKBJNPEfMcVT9NtpjF7GbdXDS/jy38H6Bk6o05OXggxisPMaPw/CgWt
   u1Hq7hT1QktV5mJw+8W+ugq/GnMQB4bp2BmA7rWAyE84ITe9pGJ008p1K
   eP0ZAiusPaqVq0Fv1C716WB3164XVuzA/tMGYrVxll6LFsUV0vpKgs6s/
   w==;
X-CSE-ConnectionGUID: bf9JhPAKSoWDM0rNb5wG4w==
X-CSE-MsgGUID: gNV31mkvS6aYtpWaPrA9Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="64850411"
X-IronPort-AV: E=Sophos;i="6.19,216,1754982000"; 
   d="scan'208";a="64850411"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 07:10:38 -0700
X-CSE-ConnectionGUID: CRw5i0YFTTiR6Y/03rB+Xg==
X-CSE-MsgGUID: B7Ve1GZNRhKaux7a4gDRbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,216,1754982000"; 
   d="scan'208";a="181128409"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 09 Oct 2025 07:10:36 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v6rLm-0000nF-15;
	Thu, 09 Oct 2025 14:10:34 +0000
Date: Thu, 9 Oct 2025 22:09:53 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/mprotect.c:450:23: sparse: sparse: cast to non-scalar
Message-ID: <202510092232.AaOMsQQa-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B70A4C0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hq48w8k7ia5gtkawk3f36f8yge44m8ps
X-HE-Tag: 1760019039-965378
X-HE-Meta: U2FsdGVkX18DkGWRoqxmIDZ61Wenu5Hw2LCM+3zaw/ai9Yd82qC+W/DHg9i1aw0fOHGGslFwX5mRjfmGwmPf1sOpnz4QcD0qFo1/o5xWObXVqRi3ATZb6snhTCgki3JEHo73HE15zaW3h6FzjX5YttwsA3/omoePVuFEKQWcxsiJohpvJIlJcAnoFCl1qCERr44S1Xw188+KeOk5tyFQNfGdA07EZIWAgdPyPIkCEcic8TQiv8s8UK8q82AlCpDyIsJCh0jJDC1uxX09iq1yCOJX1CmP1rOAb4A29KWNsi+lO0C96NQJcjC+SoVaXawGlcO/KKGzfavyMeucJ3mALMU6SM2mYFBHewYcMpwNdF0UE4shUslIhS7c4Q0H/nzW83dT+2vF1KCs7anveI4Pij8fjZCVkSf1RC1EiBBlt8mdTYAxp0/Q+NIpOuuDmtaXd4HH3a/OYZJLJyiYGnVp3PQrseJl6AEc4L9RIwGz0XEDqbNeqhMXO02K12Lz5OsS0DWXEykGbemEMEd/BXAD+XvHxQHbnk2gGCfITxLBtJoapqo7BgBiNQRvDyGhdjLNffPzzZIiWZAGOsB2QuUBMEdiFiMA/AlqSW+Fdzozm6eVZHkJG7/WwPn1qVtV+M/ehVnr7aVmxhmHKAIBLIDEJf0VGBLdZ+syCy7i+iIiRdETKYtblyCSgwZaqMSIimUbwBJHg6bJgnQWqXbkx6SFJvYZ4YXsVPVMpP5zj8oTWDIwjqKAtKABX8Nay+ZmngWLk43EBhjmnYKXTdf+km1pe0lgZWblnuuOd+u3i4a7kDDnwXM79NY9IqFNfHFmxXyc0KUdREzo4ce+oJzM+jfpcI0Y15f50uL8mjuURbFYGDFbiJJF1loFboEsFJOLQ0QTzNLMNibGE276OImXTwsvQsJIp20/gFSHQvFCtZ9dVrtZ28678G/fEJ/rlj29tSAsywLBvk37BtQhXjpwlux
 ypRqDLhe
 8UsvG1+54vYkLCRsRcZtRb4Qff6xC7V2gNXenKutzYBsgNHqTbqLseCUbDK18B1iF8LEkS2OXjfgja7kIi8JgoVh5i/hLBM4ge/JwjO5vl5VouRGHcR3oEbnFeFRXv2x9+YqQ8YPAQ0ZSgyClL+ebtYzEJnIS0eIAW14goZBlygJEHUwyfX+NBOMH5HOvOIHTqX+hnAd6T/bznDl3L6ID9oQUMwI3FUgkKN7wFImx60Fh9Ib8FF3/X2fsXAL5HuYkY9HnytFkRw+MSFGJiBmbrK4opKh3Hv4k5f+PhRC6QZjBe8U7WLurx2DeJvkiQsoHgG1LEisAlb5lbrM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   ec714e371f22f716a04e6ecb2a24988c92b26911
commit: cb0f01beb16669e91510fcdb2cea213931aee017 mm/mprotect: fix dax pud handlings
date:   1 year, 1 month ago
config: alpha-randconfig-r121-20251009 (https://download.01.org/0day-ci/archive/20251009/202510092232.AaOMsQQa-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251009/202510092232.AaOMsQQa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510092232.AaOMsQQa-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
   include/linux/pgtable.h:317:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast from non-scalar
   mm/mprotect.c:291:9: sparse: sparse: context imbalance in 'change_pte_range' - unexpected unlock
>> mm/mprotect.c:450:23: sparse: sparse: cast to non-scalar
>> mm/mprotect.c:450:23: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:324:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:324:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:317:16: sparse: sparse: cast from non-scalar

vim +450 mm/mprotect.c

    85	
    86	static long change_pte_range(struct mmu_gather *tlb,
    87			struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
    88			unsigned long end, pgprot_t newprot, unsigned long cp_flags)
    89	{
    90		pte_t *pte, oldpte;
    91		spinlock_t *ptl;
    92		long pages = 0;
    93		int target_node = NUMA_NO_NODE;
    94		bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
    95		bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
    96		bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
    97	
    98		tlb_change_page_size(tlb, PAGE_SIZE);
    99		pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
   100		if (!pte)
   101			return -EAGAIN;
   102	
   103		/* Get target node for single threaded private VMAs */
   104		if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
   105		    atomic_read(&vma->vm_mm->mm_users) == 1)
   106			target_node = numa_node_id();
   107	
   108		flush_tlb_batched_pending(vma->vm_mm);
   109		arch_enter_lazy_mmu_mode();
   110		do {
   111			oldpte = ptep_get(pte);
   112			if (pte_present(oldpte)) {
   113				pte_t ptent;
   114	
   115				/*
   116				 * Avoid trapping faults against the zero or KSM
   117				 * pages. See similar comment in change_huge_pmd.
   118				 */
   119				if (prot_numa) {
   120					struct folio *folio;
   121					int nid;
   122					bool toptier;
   123	
   124					/* Avoid TLB flush if possible */
   125					if (pte_protnone(oldpte))
   126						continue;
   127	
   128					folio = vm_normal_folio(vma, addr, oldpte);
   129					if (!folio || folio_is_zone_device(folio) ||
   130					    folio_test_ksm(folio))
   131						continue;
   132	
   133					/* Also skip shared copy-on-write pages */
   134					if (is_cow_mapping(vma->vm_flags) &&
   135					    (folio_maybe_dma_pinned(folio) ||
   136					     folio_likely_mapped_shared(folio)))
   137						continue;
   138	
   139					/*
   140					 * While migration can move some dirty pages,
   141					 * it cannot move them all from MIGRATE_ASYNC
   142					 * context.
   143					 */
   144					if (folio_is_file_lru(folio) &&
   145					    folio_test_dirty(folio))
   146						continue;
   147	
   148					/*
   149					 * Don't mess with PTEs if page is already on the node
   150					 * a single-threaded process is running on.
   151					 */
   152					nid = folio_nid(folio);
   153					if (target_node == nid)
   154						continue;
   155					toptier = node_is_toptier(nid);
   156	
   157					/*
   158					 * Skip scanning top tier node if normal numa
   159					 * balancing is disabled
   160					 */
   161					if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
   162					    toptier)
   163						continue;
   164					if (folio_use_access_time(folio))
   165						folio_xchg_access_time(folio,
   166							jiffies_to_msecs(jiffies));
   167				}
   168	
   169				oldpte = ptep_modify_prot_start(vma, addr, pte);
   170				ptent = pte_modify(oldpte, newprot);
   171	
   172				if (uffd_wp)
   173					ptent = pte_mkuffd_wp(ptent);
   174				else if (uffd_wp_resolve)
   175					ptent = pte_clear_uffd_wp(ptent);
   176	
   177				/*
   178				 * In some writable, shared mappings, we might want
   179				 * to catch actual write access -- see
   180				 * vma_wants_writenotify().
   181				 *
   182				 * In all writable, private mappings, we have to
   183				 * properly handle COW.
   184				 *
   185				 * In both cases, we can sometimes still change PTEs
   186				 * writable and avoid the write-fault handler, for
   187				 * example, if a PTE is already dirty and no other
   188				 * COW or special handling is required.
   189				 */
   190				if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
   191				    !pte_write(ptent) &&
   192				    can_change_pte_writable(vma, addr, ptent))
   193					ptent = pte_mkwrite(ptent, vma);
   194	
   195				ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
   196				if (pte_needs_flush(oldpte, ptent))
   197					tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
   198				pages++;
   199			} else if (is_swap_pte(oldpte)) {
   200				swp_entry_t entry = pte_to_swp_entry(oldpte);
   201				pte_t newpte;
   202	
   203				if (is_writable_migration_entry(entry)) {
   204					struct folio *folio = pfn_swap_entry_folio(entry);
   205	
   206					/*
   207					 * A protection check is difficult so
   208					 * just be safe and disable write
   209					 */
   210					if (folio_test_anon(folio))
   211						entry = make_readable_exclusive_migration_entry(
   212								     swp_offset(entry));
   213					else
   214						entry = make_readable_migration_entry(swp_offset(entry));
   215					newpte = swp_entry_to_pte(entry);
   216					if (pte_swp_soft_dirty(oldpte))
   217						newpte = pte_swp_mksoft_dirty(newpte);
   218				} else if (is_writable_device_private_entry(entry)) {
   219					/*
   220					 * We do not preserve soft-dirtiness. See
   221					 * copy_nonpresent_pte() for explanation.
   222					 */
   223					entry = make_readable_device_private_entry(
   224								swp_offset(entry));
   225					newpte = swp_entry_to_pte(entry);
   226					if (pte_swp_uffd_wp(oldpte))
   227						newpte = pte_swp_mkuffd_wp(newpte);
   228				} else if (is_writable_device_exclusive_entry(entry)) {
   229					entry = make_readable_device_exclusive_entry(
   230								swp_offset(entry));
   231					newpte = swp_entry_to_pte(entry);
   232					if (pte_swp_soft_dirty(oldpte))
   233						newpte = pte_swp_mksoft_dirty(newpte);
   234					if (pte_swp_uffd_wp(oldpte))
   235						newpte = pte_swp_mkuffd_wp(newpte);
   236				} else if (is_pte_marker_entry(entry)) {
   237					/*
   238					 * Ignore error swap entries unconditionally,
   239					 * because any access should sigbus anyway.
   240					 */
   241					if (is_poisoned_swp_entry(entry))
   242						continue;
   243					/*
   244					 * If this is uffd-wp pte marker and we'd like
   245					 * to unprotect it, drop it; the next page
   246					 * fault will trigger without uffd trapping.
   247					 */
   248					if (uffd_wp_resolve) {
   249						pte_clear(vma->vm_mm, addr, pte);
   250						pages++;
   251					}
   252					continue;
   253				} else {
   254					newpte = oldpte;
   255				}
   256	
   257				if (uffd_wp)
   258					newpte = pte_swp_mkuffd_wp(newpte);
   259				else if (uffd_wp_resolve)
   260					newpte = pte_swp_clear_uffd_wp(newpte);
   261	
   262				if (!pte_same(oldpte, newpte)) {
   263					set_pte_at(vma->vm_mm, addr, pte, newpte);
   264					pages++;
   265				}
   266			} else {
   267				/* It must be an none page, or what else?.. */
   268				WARN_ON_ONCE(!pte_none(oldpte));
   269	
   270				/*
   271				 * Nobody plays with any none ptes besides
   272				 * userfaultfd when applying the protections.
   273				 */
   274				if (likely(!uffd_wp))
   275					continue;
   276	
   277				if (userfaultfd_wp_use_markers(vma)) {
   278					/*
   279					 * For file-backed mem, we need to be able to
   280					 * wr-protect a none pte, because even if the
   281					 * pte is none, the page/swap cache could
   282					 * exist.  Doing that by install a marker.
   283					 */
   284					set_pte_at(vma->vm_mm, addr, pte,
   285						   make_pte_marker(PTE_MARKER_UFFD_WP));
   286					pages++;
   287				}
   288			}
   289		} while (pte++, addr += PAGE_SIZE, addr != end);
   290		arch_leave_lazy_mmu_mode();
 > 291		pte_unmap_unlock(pte - 1, ptl);
   292	
   293		return pages;
   294	}
   295	
   296	/*
   297	 * Return true if we want to split THPs into PTE mappings in change
   298	 * protection procedure, false otherwise.
   299	 */
   300	static inline bool
   301	pgtable_split_needed(struct vm_area_struct *vma, unsigned long cp_flags)
   302	{
   303		/*
   304		 * pte markers only resides in pte level, if we need pte markers,
   305		 * we need to split.  For example, we cannot wr-protect a file thp
   306		 * (e.g. 2M shmem) because file thp is handled differently when
   307		 * split by erasing the pmd so far.
   308		 */
   309		return (cp_flags & MM_CP_UFFD_WP) && !vma_is_anonymous(vma);
   310	}
   311	
   312	/*
   313	 * Return true if we want to populate pgtables in change protection
   314	 * procedure, false otherwise
   315	 */
   316	static inline bool
   317	pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
   318	{
   319		/* If not within ioctl(UFFDIO_WRITEPROTECT), then don't bother */
   320		if (!(cp_flags & MM_CP_UFFD_WP))
   321			return false;
   322	
   323		/* Populate if the userfaultfd mode requires pte markers */
   324		return userfaultfd_wp_use_markers(vma);
   325	}
   326	
   327	/*
   328	 * Populate the pgtable underneath for whatever reason if requested.
   329	 * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
   330	 * allocation failures during page faults by kicking OOM and returning
   331	 * error.
   332	 */
   333	#define  change_pmd_prepare(vma, pmd, cp_flags)				\
   334		({								\
   335			long err = 0;						\
   336			if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
   337				if (pte_alloc(vma->vm_mm, pmd))			\
   338					err = -ENOMEM;				\
   339			}							\
   340			err;							\
   341		})
   342	
   343	/*
   344	 * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
   345	 * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
   346	 * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
   347	 */
   348	#define  change_prepare(vma, high, low, addr, cp_flags)			\
   349		  ({								\
   350			long err = 0;						\
   351			if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
   352				low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
   353				if (p == NULL)					\
   354					err = -ENOMEM;				\
   355			}							\
   356			err;							\
   357		})
   358	
   359	static inline long change_pmd_range(struct mmu_gather *tlb,
   360			struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
   361			unsigned long end, pgprot_t newprot, unsigned long cp_flags)
   362	{
   363		pmd_t *pmd;
   364		unsigned long next;
   365		long pages = 0;
   366		unsigned long nr_huge_updates = 0;
   367	
   368		pmd = pmd_offset(pud, addr);
   369		do {
   370			long ret;
   371			pmd_t _pmd;
   372	again:
   373			next = pmd_addr_end(addr, end);
   374	
   375			ret = change_pmd_prepare(vma, pmd, cp_flags);
   376			if (ret) {
   377				pages = ret;
   378				break;
   379			}
   380	
   381			if (pmd_none(*pmd))
   382				goto next;
   383	
   384			_pmd = pmdp_get_lockless(pmd);
   385			if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
   386				if ((next - addr != HPAGE_PMD_SIZE) ||
   387				    pgtable_split_needed(vma, cp_flags)) {
   388					__split_huge_pmd(vma, pmd, addr, false, NULL);
   389					/*
   390					 * For file-backed, the pmd could have been
   391					 * cleared; make sure pmd populated if
   392					 * necessary, then fall-through to pte level.
   393					 */
   394					ret = change_pmd_prepare(vma, pmd, cp_flags);
   395					if (ret) {
   396						pages = ret;
   397						break;
   398					}
   399				} else {
   400					ret = change_huge_pmd(tlb, vma, pmd,
   401							addr, newprot, cp_flags);
   402					if (ret) {
   403						if (ret == HPAGE_PMD_NR) {
   404							pages += HPAGE_PMD_NR;
   405							nr_huge_updates++;
   406						}
   407	
   408						/* huge pmd was handled */
   409						goto next;
   410					}
   411				}
   412				/* fall through, the trans huge pmd just split */
   413			}
   414	
   415			ret = change_pte_range(tlb, vma, pmd, addr, next, newprot,
   416					       cp_flags);
   417			if (ret < 0)
   418				goto again;
   419			pages += ret;
   420	next:
   421			cond_resched();
   422		} while (pmd++, addr = next, addr != end);
   423	
   424		if (nr_huge_updates)
   425			count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
   426		return pages;
   427	}
   428	
   429	static inline long change_pud_range(struct mmu_gather *tlb,
   430			struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
   431			unsigned long end, pgprot_t newprot, unsigned long cp_flags)
   432	{
   433		struct mmu_notifier_range range;
   434		pud_t *pudp, pud;
   435		unsigned long next;
   436		long pages = 0, ret;
   437	
   438		range.start = 0;
   439	
   440		pudp = pud_offset(p4d, addr);
   441		do {
   442	again:
   443			next = pud_addr_end(addr, end);
   444			ret = change_prepare(vma, pudp, pmd, addr, cp_flags);
   445			if (ret) {
   446				pages = ret;
   447				break;
   448			}
   449	
 > 450			pud = READ_ONCE(*pudp);
   451			if (pud_none(pud))
   452				continue;
   453	
   454			if (!range.start) {
   455				mmu_notifier_range_init(&range,
   456							MMU_NOTIFY_PROTECTION_VMA, 0,
   457							vma->vm_mm, addr, end);
   458				mmu_notifier_invalidate_range_start(&range);
   459			}
   460	
   461			if (pud_leaf(pud)) {
   462				if ((next - addr != PUD_SIZE) ||
   463				    pgtable_split_needed(vma, cp_flags)) {
   464					__split_huge_pud(vma, pudp, addr);
   465					goto again;
   466				} else {
   467					ret = change_huge_pud(tlb, vma, pudp,
   468							      addr, newprot, cp_flags);
   469					if (ret == 0)
   470						goto again;
   471					/* huge pud was handled */
   472					if (ret == HPAGE_PUD_NR)
   473						pages += HPAGE_PUD_NR;
   474					continue;
   475				}
   476			}
   477	
   478			pages += change_pmd_range(tlb, vma, pudp, addr, next, newprot,
   479						  cp_flags);
   480		} while (pudp++, addr = next, addr != end);
   481	
   482		if (range.start)
   483			mmu_notifier_invalidate_range_end(&range);
   484	
   485		return pages;
   486	}
   487	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

