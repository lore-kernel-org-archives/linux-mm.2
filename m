Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7558606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EvJO3zIw
Received: by kanga.kvack.org (Postfix)
	id C58466B00EF; Wed, 18 Nov 2026 15:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30AE6B05B0; Wed, 18 Nov 2026 15:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46476B05B1; Wed, 18 Nov 2026 15:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82F986B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:13:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1396F4084E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:13:42 +0000 (UTC)
X-FDA: 85449340284.11.8B327FE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id A735A40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:13:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EvJO3zIw;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795032820;
	b=MmGFYsxSqa0bFjOO19f/3yJ4Xf+NBY55+0gvv7IUdvws9YEUgkq+vxdM/1q4yoiKIZ4ibO
	ttBD9MDu1HcIL42UDPCVu5dJJtxVewsEpSBBKYdmDrOxOzGvjzrY0ocUAna1F+w4SiebLi
	Hp09K5af3a8oM/DACx5lzdl4qPdv6uw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EvJO3zIw;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795032820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=A4UANdgbRQv/Nud1dbXYRxTDlZU8SXCll4rX6/tnHa8=;
	b=fy4eMfyOGsFeSFJJSRezTEF6M7bgvX2ltKAinv9Myk7B2AfCQuhE7Nl0H7c8mdHokGrQCP
	NgiwCRxkqiOOB3Cd+Snw30OmZyUI5nYvfyuhJNsMh925XnRGHFpoPK+GXYbxMwTMQYFj19
	xVmzEx7b7QZGwNnZuu+YVfMO4F9PW14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795032819; x=1826568819;
  h=date:from:to:cc:subject:message-id;
  bh=dBYKY4db5uu/mLqk1U4EiEAES636+EV4smJ40ZykoQc=;
  b=EvJO3zIwI+SoexUkF1pv6uT/jTmtxuZwev1hKGJDjL7lrIlnLzuvpyVg
   xFRBC22ptkUZj0eJV021koWHlON5af1BmC0pfXH3Sp2hK2lvumirxA5hS
   bXLPoAluuxRmtBAXbt0Q2De62q82Tf3HyaIi1x4RyUkV2SZIUEfI+OWBH
   k7VPze3Q3gzUuotk19ExGmQEX4VZRhavvwrQVa2ui0orS55gScSbRVyXX
   z+0lpDk5LN44SFq5bneK5zx7HiBPx7UWiAp2FoOQJDazrRbhFAE+qFmIq
   LAVZQOgfRrKj1rimZziH+Pm8nUCYW/sDSAd208xP4cqdGLJCJMTi7eOne
   w==;
X-CSE-ConnectionGUID: vNwigW7OQt2Y4mcy0PhSFA==
X-CSE-MsgGUID: 67ty4Y5rQwy1q/803H8sxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3752523"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3752523"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 12:13:36 -0800
X-CSE-ConnectionGUID: ldPafGgKTiSKyuz4RjBaoA==
X-CSE-MsgGUID: GEBEVX3zRby7tJlFG2ZTng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10236714"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 18 Nov 2026 12:13:33 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTm26-000000003Sf-1yx9;
	Wed, 18 Nov 2026 20:13:30 +0000
Date: Wed, 18 Nov 2026 21:12:55 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [mm:for-test 9/9] mm/hugetlb.c:5543:38: error: implicit
 declaration of function 'tlb_delay_rmap'; did you mean 'tlb_can_delay_rmap'?
Message-ID: <20261118211118.1eyeqdYF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: A735A40009
X-Stat-Signature: 1khkwda7sqysttea3nfyekxbza5a4s36
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795032818-738224
X-HE-Meta: U2FsdGVkX18UsEUkCu9l9ZOdPBIye2jR+TQnp9jjRmQgqbrui+8n4dDFm5AAkvhHI3fal4utirHm4Fjqf64LtfoxypsC8GzAc76M7xREU1kJlTphqyNClI7+cXBdJy7hl4wsDlb7noCPsYX9z+Ay2orDS61Fws6RpTleOxJS7JHs/Yt7S4l16OTRkjfg6PLYM2Mrun1ZJSzdcA0keqYi0qlYqf4v9iR1R4aWv9UqOLi5aZ4SibEmOyC9FhbG3P48OPp5tisviqPB4//YA5n0qhLtkj4prg6G4Vxi0e8gxwAt3+LsVZi6JLMBkmK7Ey++NTGxQDgAYH1YDjfFpbnA1crrPuJfrTDbAcmydbrPH0elKMH0jG/uXdyfFH1lGl05Lp3kZha38sjzBby4LYlGxXsYyLGb4XTj3b+9buc+dY4T75OMPUpqun346WtBK7LdSW2b0pYBXZ3St33nCHsHCkwrhLty+6l0zxVTE5eRolUtXadyArVLwNxfv7O+h3OdA+R52oQALXw/WrDG5A5cAe6BdIndqBLuY74VS+TJ+biU1fnYRMqe18ZDs+9hwXSapukKYCNnKdssfLVY9O1gzDGa+si3VIHM6IBbzYgCnj6pBTgd5itqz4R8m2LijFT9SyJr4IAJxMg5QRYpHyuq1gZaXPiVXIs4aqzysBZe0WCOVggbgFSUDdIsMdxFXhqYTyybd4SXTmmhsLvpT5d0q4I/qLZ2hkdq55jBEdEpNrO6yFQ92HcfqfPbNdui4Mgd/MqFdkhZIMckb1LKOfS6sBWiXsOK5HRWMCemozAoMrpjq2ChbhClUFnNhWuSWwFXp7mfN2JhkGfOdUFPU5nk82mz+D/sRvtqMSnNbh7JXetH5oj1hVhigPQIHqtn1TPbkMN1zK+aI7bHsPN8fvLidxMN2xYgjRSCYD14b/KqyMPB0ewWujX75WyadZ2I1LVkPfw/PbxVMNZbQMuetvL
 vxqkSaup
 VlUFmqfoThIHy4f07dHs0PPLD68e24XdEpOHOQyoTozNeVHXyds+uUy4cFBAaTBspk/QNye6MpLHzdxtTY32vZLffAo/FiangEOct0CjBxLLfn8UKEDXpgyrbJlpz2uhqkjH9SQj40AvYdDG+FRq09CrpSs/zz3X4/n318q8q0Tu8YOQB8SIzEH68Anr6rHgKwrNymC+BwEq+uzN2O7xkVDG9++rid/c98iQo9UpgI977Oyj9v5Nk1EbmOZlRdp+BJHa59rnPq+sOrrRZWclxFObfozJHfCZEwg/DUFhLHif5TX11IZ8Ft6nkPnXcQlWPboKQYoWixJ5pXcqBvh70RfVmrVRJnxgDW6RbLmAAB0zttNYXEJtBtR6t5lg1hWsC/SPQkSOUi8t+GwuUxgc5eeWumAGst8A6yMAAxobLA66rCplLwzrcwzlEhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git for-test
head:   6cbe7dfca3ecd261d1579cb588b53d38cc6ce8c7
commit: 6cbe7dfca3ecd261d1579cb588b53d38cc6ce8c7 [9/9] Merge https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new into for-test
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261118/20261118211118.1eyeqdYF-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261118/20261118211118.1eyeqdYF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261118211118.1eyeqdYF-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hugetlb.c: In function 'hugetlb_unmap_range':
>> mm/hugetlb.c:5543:38: error: implicit declaration of function 'tlb_delay_rmap'; did you mean 'tlb_can_delay_rmap'? [-Wimplicit-function-declaration]
    5543 |                         delay_rmap = tlb_delay_rmap(tlb);
         |                                      ^~~~~~~~~~~~~~
         |                                      tlb_can_delay_rmap
--
   mm/huge_memory.c: In function 'zap_huge_pmd_folio':
>> mm/huge_memory.c:2559:18: error: too few arguments to function '__tlb_remove_page_size'
    2559 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
         |                  ^~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/tlb.h:8,
                    from mm/huge_memory.c:46:
   include/asm-generic/tlb.h:248:6: note: declared here
     248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
         |      ^~~~~~~~~~~~~~~~~~~~~~


vim +5543 mm/hugetlb.c

09c48feb742108 David Hildenbrand (Arm      2026-11-16  5439) 
92daa8652f88c8 Li Zhe                      2026-10-22  5440  static void hugetlb_unmap_range(struct mmu_gather *tlb,
92daa8652f88c8 Li Zhe                      2026-10-22  5441  				struct vm_area_struct *vma, unsigned long start,
92daa8652f88c8 Li Zhe                      2026-10-22  5442  				unsigned long end, struct folio *folio,
92daa8652f88c8 Li Zhe                      2026-10-22  5443  				zap_flags_t zap_flags)
63551ae0feaaa2 David Gibson                2005-06-21  5444  {
63551ae0feaaa2 David Gibson                2005-06-21  5445  	struct mm_struct *mm = vma->vm_mm;
05275594a311cd Fan Ni                      2025-05-05  5446  	const bool folio_provided = !!folio;
63551ae0feaaa2 David Gibson                2005-06-21  5447  	unsigned long address;
c7546f8f03f5a4 David Gibson                2005-08-05  5448  	pte_t *ptep;
63551ae0feaaa2 David Gibson                2005-06-21  5449  	pte_t pte;
cb900f41215447 Kiryl Shutsemau             2013-11-14  5450  	spinlock_t *ptl;
a5516438959d90 Andi Kleen                  2008-07-23  5451  	struct hstate *h = hstate_vma(vma);
a5516438959d90 Andi Kleen                  2008-07-23  5452  	unsigned long sz = huge_page_size(h);
e95a9851787bbb Mike Kravetz                2022-06-21  5453  	unsigned long last_addr_mask;
a5516438959d90 Andi Kleen                  2008-07-23  5454  
5120b1e048d485 Guillaume Morin             2026-07-28  5455  	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
c911e7ebebf58c Lorenzo Stoakes (ARM        2026-10-13  5456) 	WARN_ON(!vma_is_hugetlb(vma));
a5516438959d90 Andi Kleen                  2008-07-23  5457  	BUG_ON(start & ~huge_page_mask(h));
a5516438959d90 Andi Kleen                  2008-07-23  5458  	BUG_ON(end & ~huge_page_mask(h));
63551ae0feaaa2 David Gibson                2005-06-21  5459  
e95a9851787bbb Mike Kravetz                2022-06-21  5460  	last_addr_mask = hugetlb_mask_last_page(h);
569f48b85813f0 Hillf Danton                2014-12-10  5461  	address = start;
569f48b85813f0 Hillf Danton                2014-12-10  5462  	for (; address < end; address += sz) {
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5463) 		bool delay_rmap = false;
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5464) 
9c67a20704e763 Peter Xu                    2022-12-16  5465  		ptep = hugetlb_walk(vma, address, sz);
e95a9851787bbb Mike Kravetz                2022-06-21  5466  		if (!ptep) {
e95a9851787bbb Mike Kravetz                2022-06-21  5467  			address |= last_addr_mask;
c7546f8f03f5a4 David Gibson                2005-08-05  5468  			continue;
e95a9851787bbb Mike Kravetz                2022-06-21  5469  		}
c7546f8f03f5a4 David Gibson                2005-08-05  5470  
cb900f41215447 Kiryl Shutsemau             2013-11-14  5471  		ptl = huge_pte_lock(h, mm, ptep);
8ce720d5bd91e9 David Hildenbrand (Red Hat  2025-12-23  5472) 		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5473  			spin_unlock(ptl);
4ddb4d91b82f4b Mike Kravetz                2022-06-21  5474  			address |= last_addr_mask;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5475  			continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5476  		}
39dde65c9940c9 Kenneth W Chen              2006-12-06  5477  
e6c0c03245b14d Christophe Leroy            2024-07-02  5478  		pte = huge_ptep_get(mm, address, ptep);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5479  		if (huge_pte_none(pte)) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5480  			spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5481  			continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5482  		}
6629326b89b6e6 Hillf Danton                2012-03-23  5483  
6629326b89b6e6 Hillf Danton                2012-03-23  5484  		/*
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5485  		 * Migrating hugepage or HWPoisoned hugepage is already
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5486  		 * unmapped and its refcount is dropped, so just clear pte here.
6629326b89b6e6 Hillf Danton                2012-03-23  5487  		 */
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5488  		if (unlikely(!pte_present(pte))) {
05e90bd05eea33 Peter Xu                    2022-05-12  5489  			/*
05e90bd05eea33 Peter Xu                    2022-05-12  5490  			 * If the pte was wr-protected by uffd-wp in any of the
05e90bd05eea33 Peter Xu                    2022-05-12  5491  			 * swap forms, meanwhile the caller does not want to
05e90bd05eea33 Peter Xu                    2022-05-12  5492  			 * drop the uffd-wp bit in this zap, then replace the
05e90bd05eea33 Peter Xu                    2022-05-12  5493  			 * pte with a marker.
05e90bd05eea33 Peter Xu                    2022-05-12  5494  			 */
f6605fc6b14bd5 Josef Bacik                 2026-10-15  5495  			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
05e90bd05eea33 Peter Xu                    2022-05-12  5496  			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
05e90bd05eea33 Peter Xu                    2022-05-12  5497  				set_huge_pte_at(mm, address, ptep,
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5498  						make_pte_marker(PTE_MARKER_UFFD_WP),
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5499  						sz);
05e90bd05eea33 Peter Xu                    2022-05-12  5500  			else
9386fac34c7cbe Punit Agrawal               2017-07-06  5501  				huge_pte_clear(mm, address, ptep, sz);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5502  			spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5503  			continue;
8c4894c6bc790d Naoya Horiguchi             2012-12-12  5504  		}
6629326b89b6e6 Hillf Danton                2012-03-23  5505  
04f2cbe35699d2 Mel Gorman                  2008-07-23  5506  		/*
7f4b6065d9a842 Fan Ni                      2025-05-05  5507  		 * If a folio is supplied, it is because a specific
7f4b6065d9a842 Fan Ni                      2025-05-05  5508  		 * folio is being unmapped, not a range. Ensure the folio we
7f4b6065d9a842 Fan Ni                      2025-05-05  5509  		 * are about to unmap is the actual folio of interest.
04f2cbe35699d2 Mel Gorman                  2008-07-23  5510  		 */
05275594a311cd Fan Ni                      2025-05-05  5511  		if (folio_provided) {
05275594a311cd Fan Ni                      2025-05-05  5512  			if (folio != page_folio(pte_page(pte))) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5513  				spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5514  				continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5515  			}
04f2cbe35699d2 Mel Gorman                  2008-07-23  5516  			/*
04f2cbe35699d2 Mel Gorman                  2008-07-23  5517  			 * Mark the VMA as having unmapped its page so that
04f2cbe35699d2 Mel Gorman                  2008-07-23  5518  			 * future faults in this VMA will fail rather than
04f2cbe35699d2 Mel Gorman                  2008-07-23  5519  			 * looking like data was lost
04f2cbe35699d2 Mel Gorman                  2008-07-23  5520  			 */
04f2cbe35699d2 Mel Gorman                  2008-07-23  5521  			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
05275594a311cd Fan Ni                      2025-05-05  5522  		} else {
05275594a311cd Fan Ni                      2025-05-05  5523  			folio = page_folio(pte_page(pte));
04f2cbe35699d2 Mel Gorman                  2008-07-23  5524  		}
04f2cbe35699d2 Mel Gorman                  2008-07-23  5525  
02410ac72ac370 Ryan Roberts                2025-02-26  5526  		pte = huge_ptep_get_and_clear(mm, address, ptep, sz);
b528e4b6405b9f Aneesh Kumar K.V            2016-12-12  5527  		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
106c992a5ebef2 Gerald Schaefer             2013-04-29  5528  		if (huge_pte_dirty(pte))
05275594a311cd Fan Ni                      2025-05-05  5529  			folio_mark_dirty(folio);
05e90bd05eea33 Peter Xu                    2022-05-12  5530  		/* Leave a uffd-wp pte marker if needed */
f6605fc6b14bd5 Josef Bacik                 2026-10-15  5531  		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
05e90bd05eea33 Peter Xu                    2022-05-12  5532  		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
05e90bd05eea33 Peter Xu                    2022-05-12  5533  			set_huge_pte_at(mm, address, ptep,
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5534  					make_pte_marker(PTE_MARKER_UFFD_WP),
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5535  					sz);
5d317b2b653659 Naoya Horiguchi             2015-11-05  5536  		hugetlb_count_sub(pages_per_huge_page(h), mm);
df7a6d1f64056a Breno Leitao                2024-02-05  5537  		/*
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5538) 		 * hugetlb_wp() uses mapcount to decide whether an anonymous
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5539) 		 * folio can be reused. Delay rmap removal until stale TLB
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5540) 		 * entries are gone, unless the mm has no users left.
df7a6d1f64056a Breno Leitao                2024-02-05  5541  		 */
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5542) 		if (folio_test_anon(folio) && !tlb->fullmm) {
93487434a683c0 David Hildenbrand (Arm      2026-11-16 @5543) 			delay_rmap = tlb_delay_rmap(tlb);
df7a6d1f64056a Breno Leitao                2024-02-05  5544  			/*
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5545) 			 * Without delay-rmap support, just flush before
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5546) 			 * dropping the PTL. Except with MMU_GATHER_NO_GATHER
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5547) 			 * where clearing already flushed the TLB.
df7a6d1f64056a Breno Leitao                2024-02-05  5548  			 */
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5549) 			if (!delay_rmap && !IS_ENABLED(CONFIG_MMU_GATHER_NO_GATHER))
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5550) 				flush_hugetlb_tlb_range(vma, address, address + sz);
8daf9c702ee7f8 Oscar Salvador              2024-05-28  5551  		}
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5552) 		if (!delay_rmap)
05275594a311cd Fan Ni                      2025-05-05  5553  			hugetlb_remove_rmap(folio);
21cc2b5c5062a2 Jeongjun Park               2025-08-24  5554  		spin_unlock(ptl);
df7a6d1f64056a Breno Leitao                2024-02-05  5555  
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5556) 		if (!delay_rmap)
09c48feb742108 David Hildenbrand (Arm      2026-11-16  5557) 			hugetlb_folio_restore_rsv_on_unmap(vma, folio);
df7a6d1f64056a Breno Leitao                2024-02-05  5558  
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5559) 		if (__tlb_remove_page_size(tlb, folio_page(folio, 0), sz,
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5560) 					   delay_rmap)) {
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5561) 			tlb_flush_mmu_tlbonly(tlb);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5562) 			tlb_flush_rmaps(tlb, vma);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5563) 			tlb_flush_mmu(tlb);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5564) 		}
24669e58477e27 Aneesh Kumar K.V            2012-07-31  5565  		/*
7f4b6065d9a842 Fan Ni                      2025-05-05  5566  		 * If we were instructed to unmap a specific folio, we're done.
24669e58477e27 Aneesh Kumar K.V            2012-07-31  5567  		 */
05275594a311cd Fan Ni                      2025-05-05  5568  		if (folio_provided)
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5569  			break;
fe1668ae5bf014 Kenneth W Chen              2006-10-04  5570  	}
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5571) 
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5572) 	if (tlb->delayed_rmap) {
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5573) 		tlb_flush_mmu_tlbonly(tlb);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5574) 		tlb_flush_rmaps(tlb, vma);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5575) 		tlb_flush_mmu(tlb);
93487434a683c0 David Hildenbrand (Arm      2026-11-16  5576) 	}
92daa8652f88c8 Li Zhe                      2026-10-22  5577  }
92daa8652f88c8 Li Zhe                      2026-10-22  5578  

:::::: The code at line 5543 was first introduced by commit
:::::: 93487434a683c0385b51501f686a7979d8bcbc2f mm/hugetlb: delay anon folio rmap removal until after the TLB flush

:::::: TO: David Hildenbrand (Arm) <david@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

