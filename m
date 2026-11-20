Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1EE606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OPkGKK+H
Received: by kanga.kvack.org (Postfix)
	id 85B4F6B05B1; Fri, 20 Nov 2026 10:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AFF6B05B2; Fri, 20 Nov 2026 10:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC116B05B3; Fri, 20 Nov 2026 10:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 442716B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:51:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A24561C48D4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:51:09 +0000 (UTC)
X-FDA: 85455936258.13.A896BB8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id DE0D112000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:51:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OPkGKK+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795189868;
	b=LvVO7bzHwhTb075tULdYrSGYXM/YESvf+DqYjgYz1a/M6otcS/h4novlFUSD5tuuf9fBXx
	FWRIQN4zQLc+m02dX2tU2fGe2jjMxoNfQFlcJ/ptsKcKDRkpEVOEwrsnb6BeOCIvWDcGu9
	UnIjwvDO8ALIdS27DXFXSWuiljnkphc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795189868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=a2Pf7EQ+umI9s+sUXWxaeQPYte0MkI8tsywE2nKX8tc=;
	b=2Kor8vBTwSgptSm9wC+Q1KR9FbKSpEQZdaLrDSQ/THoDOD0mIJrwThRqmIgB/W5523nrmy
	j/7fNBdC5CyUgjT2xWy9GqFL3Uqma5xdSpfWZcdJvmNBFrfIiTPBOZsw4MkeMLmGBU8Wii
	en3eCH5t8GsEw1qwKmR85oBoYvgnxoo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OPkGKK+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795189867; x=1826725867;
  h=date:from:to:cc:subject:message-id;
  bh=plq9uI4RiWYKfYfSnFCZHTnU5qksaz3XF1VWmOUUdZg=;
  b=OPkGKK+HZKxwSQX4pkcIp+grRgGGySbAepNLSezf4DU9nHzMyop3lA8Q
   f0yzU/rdyLc4FG2fno8Z+OmaaBjUZTqkRHA35MXVwn7whj7p0Jl7/3gFe
   rXUFxam1VtWTqy6yY3xqw2QZbgdqItRQMzSUTqbrLKnRCKUzoFX0NiFL1
   Y7cpyCZnlhhHyIJNaD6MG6WRWzjOzSgyQohi30Mcocsv4JC5k2+5NdRll
   nxUP71fHDfYERez1DvRtw3e9L+mzK6EE4ouBHEExXeKBJwlAhrwujNljw
   ruwwpnMKxlY4RyQBh9CgzA+MSWgODSCu74gH0C53+k4mIZZrQb1FbbKw0
   A==;
X-CSE-ConnectionGUID: JfP0KHQnSdqaTH8TFN4/IQ==
X-CSE-MsgGUID: s/TXggRgQteyn+nghb5x4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4074337"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="4074337"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 07:51:06 -0800
X-CSE-ConnectionGUID: iRQb59ThTvqu+8GfkAo0Aw==
X-CSE-MsgGUID: aLvKJIArRASN5Oo1juV1sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="10848361"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 20 Nov 2026 07:51:03 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUQtA-0000000044b-3HKI;
	Fri, 20 Nov 2026 15:51:00 +0000
Date: Fri, 20 Nov 2026 16:50:16 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [mm:for-test 9/9] mm/hugetlb.c:5544:38: error: implicit
 declaration of function 'tlb_delay_rmap'; did you mean 'tlb_can_delay_rmap'?
Message-ID: <20261120163957.EF7GtH5c-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE0D112000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xpxrixfb5ca85b438xuqxjuewbneh95t
X-Rspam-User:
X-HE-Tag: 1795189866-265221
X-HE-Meta: U2FsdGVkX1/n5Uc7vz6pf/ELG/MwkDCGnxcQQEFMcFQK6oEXTc0QMK/VT/W+P+uJw4vBfpTr7Q2Z6jYjzN9rgfpoqSt8dyvVUyrPwKlOVVtFWVURVNFktNUq8xhgL0QvE36mGAtp614vgIiqQr1aRvCz1CMJstCsG7p5Kryl2rCN3kgmmDp8hDC79M9pRbvdsOChLk86IIUcKLzlhVzdF/eaF9dfp42MJFkR6rZgXE0oz4b/7tvBTu9Pea2a16NTtVhYM31r1WbH7kO/HRJbw1dMtPqXK5p3udBKa+DzfHyGWnOBcUysT2yzJC8IAVJrikbCKH0rPBg3EANC7mf73EheO7+2ExsaKMJ9oqSXU//A0SOZnZCwEsYc0hpbsWO5mHbQSaQ1TpnCGAsUTEFWnQdbUxyl5uuJYKXPCVcdMdfR0RZ/hDB5Za0ujKcDz+LXRq2KMkRcD5/GZ8pUovQ4bjTcfhNkL7c24X0bX79N+hmo7Ubj+q4w3CHWI9ZpPNGcJGt5QA2zkQaXwVHF0Sll/5cAsA/2ekSCQ1+hUcG8AT7xaUzFhf/AIQHox4flFQN+Bd4iVa4JuI0prFWcbY6QXh1QgV3rYTMJxl4+StNE9wmAyVlBPpjWHpL+pYrGmT48ChoElp53VgKfkS6NcsLVjGZoIAbxS0JvRaaxIiumGJv4/nHns6NP7FNA5cRwvrUBDGJjq5GF74BF2fvHcFZpS2zKGn62Hd/XBlyW8fV5ejpRS8wyJ7Zrm3JwrTyUNyHf98tIuEu+1XzZKB02b9xj+NOde4pfKeeaZtcbnVi4yMTmY5DLWCWhW/9jwUSLzvaV/kGaStWZFQoyznznupOtJDQR39WMDZ32T75z4SxvkRNLGEUs/Kc/NojbuK9J/t27UGT+am5DUGw8vSuOIvKEFQlNO/mKnE3chpbSR7R1ISzUwljlVfOvdOoWYr+xMZ8brQtXalRzhpKJiFH0QJ6
 1xMR6oLU
 0htPtgoQB/ekMwhXY9TxwnKu33f0JyviJvorPal878Tvor8tyV5kBHhZfHhgLtnbso2Ud3NQup/R8lba8TzvoltDOmUFUzwcx3fYMDZoPgRbtAE99dO2PF3h2sp7P2Olk2FBINz/TbVFCfoY5WlYBZXNgdiV0H7LMJRZNpZ9gQhX98tgF+1EWuUAENoJ7b9hSThm27Bs4FcByO3XVTwh9DxYJEYrzaKi4DSFjvSRuTFktNDRCFnx4Dxpx0+oqyFE04MECK4V6SP5/M6q1SB6UeqrR3Zzqc7swSju4C1ymH2kNAAOC2LKX43/WluaZ/nMBknfQVqYxkLoFsn6NQjpcwLdD+auSYV1ZIYaKubatFFe0fMybF2SRI8Onk2AdrsFIFIets7pOTHXAymrZsaKySZ4dtlKjz+WiygLXafxTFdM6DT5F79YQ1mKtJ84R99UWyM7bAwLoZGHBFRsI5bzjaOEUwSfFoK5Ie3oc9mMFCZIS2Q/D8ejzLGwv+Nq+y7ZyLXYVE9OvnznTko4EN1tr0fbZcOxzXnjtgzvrlAiUbPHOgb0hKbszyOPx1Jxrl+DN2OSzoBvrQAXgOMMP//g9UOYYpfutPM2lgbmWFABbAk4h3jpQ5RsGezuWLVWYygkklDTDTt4zlkfKq1/m4NKPG5wJJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git for-test
head:   57851d09ac9eab196459f71a938f26f71f4b82ce
commit: 57851d09ac9eab196459f71a938f26f71f4b82ce [9/9] Merge https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new into for-test
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261120/20261120163957.EF7GtH5c-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/20261120163957.EF7GtH5c-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261120163957.EF7GtH5c-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hugetlb.c: In function 'hugetlb_unmap_range':
>> mm/hugetlb.c:5544:38: error: implicit declaration of function 'tlb_delay_rmap'; did you mean 'tlb_can_delay_rmap'? [-Wimplicit-function-declaration]
    5544 |                         delay_rmap = tlb_delay_rmap(tlb);
         |                                      ^~~~~~~~~~~~~~
         |                                      tlb_can_delay_rmap
--
   mm/huge_memory.c: In function 'zap_huge_pmd_folio':
>> mm/huge_memory.c:2552:18: error: too few arguments to function '__tlb_remove_page_size'
    2552 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
         |                  ^~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/x86/include/asm/tlb.h:8,
                    from mm/huge_memory.c:46:
   include/asm-generic/tlb.h:248:6: note: declared here
     248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
         |      ^~~~~~~~~~~~~~~~~~~~~~


vim +5544 mm/hugetlb.c

0fedfe11a346b2 David Hildenbrand (Arm      2026-11-16  5440) 
92daa8652f88c8 Li Zhe                      2026-10-22  5441  static void hugetlb_unmap_range(struct mmu_gather *tlb,
92daa8652f88c8 Li Zhe                      2026-10-22  5442  				struct vm_area_struct *vma, unsigned long start,
92daa8652f88c8 Li Zhe                      2026-10-22  5443  				unsigned long end, struct folio *folio,
92daa8652f88c8 Li Zhe                      2026-10-22  5444  				zap_flags_t zap_flags)
63551ae0feaaa2 David Gibson                2005-06-21  5445  {
63551ae0feaaa2 David Gibson                2005-06-21  5446  	struct mm_struct *mm = vma->vm_mm;
05275594a311cd Fan Ni                      2025-05-05  5447  	const bool folio_provided = !!folio;
63551ae0feaaa2 David Gibson                2005-06-21  5448  	unsigned long address;
c7546f8f03f5a4 David Gibson                2005-08-05  5449  	pte_t *ptep;
63551ae0feaaa2 David Gibson                2005-06-21  5450  	pte_t pte;
cb900f41215447 Kiryl Shutsemau             2013-11-14  5451  	spinlock_t *ptl;
a5516438959d90 Andi Kleen                  2008-07-23  5452  	struct hstate *h = hstate_vma(vma);
a5516438959d90 Andi Kleen                  2008-07-23  5453  	unsigned long sz = huge_page_size(h);
e95a9851787bbb Mike Kravetz                2022-06-21  5454  	unsigned long last_addr_mask;
a5516438959d90 Andi Kleen                  2008-07-23  5455  
5120b1e048d485 Guillaume Morin             2026-07-28  5456  	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
c911e7ebebf58c Lorenzo Stoakes (ARM        2026-10-13  5457) 	WARN_ON(!vma_is_hugetlb(vma));
a5516438959d90 Andi Kleen                  2008-07-23  5458  	BUG_ON(start & ~huge_page_mask(h));
a5516438959d90 Andi Kleen                  2008-07-23  5459  	BUG_ON(end & ~huge_page_mask(h));
63551ae0feaaa2 David Gibson                2005-06-21  5460  
e95a9851787bbb Mike Kravetz                2022-06-21  5461  	last_addr_mask = hugetlb_mask_last_page(h);
569f48b85813f0 Hillf Danton                2014-12-10  5462  	address = start;
569f48b85813f0 Hillf Danton                2014-12-10  5463  	for (; address < end; address += sz) {
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5464) 		bool delay_rmap = false;
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5465) 
9c67a20704e763 Peter Xu                    2022-12-16  5466  		ptep = hugetlb_walk(vma, address, sz);
e95a9851787bbb Mike Kravetz                2022-06-21  5467  		if (!ptep) {
e95a9851787bbb Mike Kravetz                2022-06-21  5468  			address |= last_addr_mask;
c7546f8f03f5a4 David Gibson                2005-08-05  5469  			continue;
e95a9851787bbb Mike Kravetz                2022-06-21  5470  		}
c7546f8f03f5a4 David Gibson                2005-08-05  5471  
cb900f41215447 Kiryl Shutsemau             2013-11-14  5472  		ptl = huge_pte_lock(h, mm, ptep);
8ce720d5bd91e9 David Hildenbrand (Red Hat  2025-12-23  5473) 		if (huge_pmd_unshare(tlb, vma, address, ptep)) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5474  			spin_unlock(ptl);
4ddb4d91b82f4b Mike Kravetz                2022-06-21  5475  			address |= last_addr_mask;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5476  			continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5477  		}
39dde65c9940c9 Kenneth W Chen              2006-12-06  5478  
e6c0c03245b14d Christophe Leroy            2024-07-02  5479  		pte = huge_ptep_get(mm, address, ptep);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5480  		if (huge_pte_none(pte)) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5481  			spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5482  			continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5483  		}
6629326b89b6e6 Hillf Danton                2012-03-23  5484  
6629326b89b6e6 Hillf Danton                2012-03-23  5485  		/*
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5486  		 * Migrating hugepage or HWPoisoned hugepage is already
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5487  		 * unmapped and its refcount is dropped, so just clear pte here.
6629326b89b6e6 Hillf Danton                2012-03-23  5488  		 */
9fbc1f635fd0bd Naoya Horiguchi             2015-02-11  5489  		if (unlikely(!pte_present(pte))) {
05e90bd05eea33 Peter Xu                    2022-05-12  5490  			/*
05e90bd05eea33 Peter Xu                    2022-05-12  5491  			 * If the pte was wr-protected by uffd-wp in any of the
05e90bd05eea33 Peter Xu                    2022-05-12  5492  			 * swap forms, meanwhile the caller does not want to
05e90bd05eea33 Peter Xu                    2022-05-12  5493  			 * drop the uffd-wp bit in this zap, then replace the
05e90bd05eea33 Peter Xu                    2022-05-12  5494  			 * pte with a marker.
05e90bd05eea33 Peter Xu                    2022-05-12  5495  			 */
f6605fc6b14bd5 Josef Bacik                 2026-10-15  5496  			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
05e90bd05eea33 Peter Xu                    2022-05-12  5497  			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
05e90bd05eea33 Peter Xu                    2022-05-12  5498  				set_huge_pte_at(mm, address, ptep,
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5499  						make_pte_marker(PTE_MARKER_UFFD_WP),
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5500  						sz);
05e90bd05eea33 Peter Xu                    2022-05-12  5501  			else
9386fac34c7cbe Punit Agrawal               2017-07-06  5502  				huge_pte_clear(mm, address, ptep, sz);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5503  			spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5504  			continue;
8c4894c6bc790d Naoya Horiguchi             2012-12-12  5505  		}
6629326b89b6e6 Hillf Danton                2012-03-23  5506  
04f2cbe35699d2 Mel Gorman                  2008-07-23  5507  		/*
7f4b6065d9a842 Fan Ni                      2025-05-05  5508  		 * If a folio is supplied, it is because a specific
7f4b6065d9a842 Fan Ni                      2025-05-05  5509  		 * folio is being unmapped, not a range. Ensure the folio we
7f4b6065d9a842 Fan Ni                      2025-05-05  5510  		 * are about to unmap is the actual folio of interest.
04f2cbe35699d2 Mel Gorman                  2008-07-23  5511  		 */
05275594a311cd Fan Ni                      2025-05-05  5512  		if (folio_provided) {
05275594a311cd Fan Ni                      2025-05-05  5513  			if (folio != page_folio(pte_page(pte))) {
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5514  				spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5515  				continue;
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5516  			}
04f2cbe35699d2 Mel Gorman                  2008-07-23  5517  			/*
04f2cbe35699d2 Mel Gorman                  2008-07-23  5518  			 * Mark the VMA as having unmapped its page so that
04f2cbe35699d2 Mel Gorman                  2008-07-23  5519  			 * future faults in this VMA will fail rather than
04f2cbe35699d2 Mel Gorman                  2008-07-23  5520  			 * looking like data was lost
04f2cbe35699d2 Mel Gorman                  2008-07-23  5521  			 */
04f2cbe35699d2 Mel Gorman                  2008-07-23  5522  			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
05275594a311cd Fan Ni                      2025-05-05  5523  		} else {
05275594a311cd Fan Ni                      2025-05-05  5524  			folio = page_folio(pte_page(pte));
04f2cbe35699d2 Mel Gorman                  2008-07-23  5525  		}
04f2cbe35699d2 Mel Gorman                  2008-07-23  5526  
02410ac72ac370 Ryan Roberts                2025-02-26  5527  		pte = huge_ptep_get_and_clear(mm, address, ptep, sz);
b528e4b6405b9f Aneesh Kumar K.V            2016-12-12  5528  		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
106c992a5ebef2 Gerald Schaefer             2013-04-29  5529  		if (huge_pte_dirty(pte))
05275594a311cd Fan Ni                      2025-05-05  5530  			folio_mark_dirty(folio);
05e90bd05eea33 Peter Xu                    2022-05-12  5531  		/* Leave a uffd-wp pte marker if needed */
f6605fc6b14bd5 Josef Bacik                 2026-10-15  5532  		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
05e90bd05eea33 Peter Xu                    2022-05-12  5533  		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
05e90bd05eea33 Peter Xu                    2022-05-12  5534  			set_huge_pte_at(mm, address, ptep,
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5535  					make_pte_marker(PTE_MARKER_UFFD_WP),
935d4f0c6dc8b3 Ryan Roberts                2023-09-22  5536  					sz);
5d317b2b653659 Naoya Horiguchi             2015-11-05  5537  		hugetlb_count_sub(pages_per_huge_page(h), mm);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5538) 		/*
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5539) 		 * hugetlb_wp() uses mapcount to decide whether an anonymous
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5540) 		 * folio can be reused. Delay rmap removal until stale TLB
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5541) 		 * entries are gone, unless the mm has no users left.
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5542) 		 */
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5543) 		if (folio_test_anon(folio) && !tlb->fullmm) {
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16 @5544) 			delay_rmap = tlb_delay_rmap(tlb);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5545) 			/*
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5546) 			 * Without delay-rmap support, just flush before
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5547) 			 * dropping the PTL. Except with MMU_GATHER_NO_GATHER
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5548) 			 * where clearing already flushed the TLB.
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5549) 			 */
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5550) 			if (!delay_rmap && !IS_ENABLED(CONFIG_MMU_GATHER_NO_GATHER))
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5551) 				flush_hugetlb_tlb_range(vma, address, address + sz);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5552) 		}
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5553) 		if (!delay_rmap)
05275594a311cd Fan Ni                      2025-05-05  5554  			hugetlb_remove_rmap(folio);
21cc2b5c5062a2 Jeongjun Park               2025-08-24  5555  		spin_unlock(ptl);
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5556  
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5557) 		if (!delay_rmap)
0fedfe11a346b2 David Hildenbrand (Arm      2026-11-16  5558) 			hugetlb_folio_restore_rsv_on_unmap(vma, folio);
df7a6d1f64056a Breno Leitao                2024-02-05  5559  
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5560) 		if (__tlb_remove_page_size(tlb, folio_page(folio, 0), sz,
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5561) 					   delay_rmap)) {
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5562) 			tlb_flush_mmu_tlbonly(tlb);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5563) 			tlb_flush_rmaps(tlb, vma);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5564) 			tlb_flush_mmu(tlb);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5565) 		}
24669e58477e27 Aneesh Kumar K.V            2012-07-31  5566  		/*
7f4b6065d9a842 Fan Ni                      2025-05-05  5567  		 * If we were instructed to unmap a specific folio, we're done.
24669e58477e27 Aneesh Kumar K.V            2012-07-31  5568  		 */
05275594a311cd Fan Ni                      2025-05-05  5569  		if (folio_provided)
31d49da5ad0172 Aneesh Kumar K.V            2016-07-26  5570  			break;
fe1668ae5bf014 Kenneth W Chen              2006-10-04  5571  	}
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5572) 
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5573) 	if (tlb->delayed_rmap) {
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5574) 		tlb_flush_mmu_tlbonly(tlb);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5575) 		tlb_flush_rmaps(tlb, vma);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5576) 		tlb_flush_mmu(tlb);
a8ce63a2d6e62a David Hildenbrand (Arm      2026-11-16  5577) 	}
92daa8652f88c8 Li Zhe                      2026-10-22  5578  }
92daa8652f88c8 Li Zhe                      2026-10-22  5579  

:::::: The code at line 5544 was first introduced by commit
:::::: a8ce63a2d6e62a97bb426cf65f3a1d4f91db31ce mm/hugetlb: delay anon folio rmap removal until after the TLB flush

:::::: TO: David Hildenbrand (Arm) <david@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

