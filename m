Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5E1CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF856B008A; Thu, 14 May 2026 06:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96CC6B008C; Thu, 14 May 2026 06:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3A46B0092; Thu, 14 May 2026 06:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC7516B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:27:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58681160581
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:27:15 +0000 (UTC)
X-FDA: 84765648030.04.700163F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5BF18000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:27:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n5lQukOx;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778754433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=u4vzdRzK0y7SIQCWfB+v9o+WP2p1QSrYO5+RUPq3qUo=;
	b=P+iNzPdqBeAndte594o1VGXVig2wVD+4iXGJbToU/th5/iobvjKEIHbfEMCeS/bCfMd/n7
	jXliEi7evMgaAR86XFbzBa4EXe4pMLH4nBuy4ortFei8GalEb9nnFtrysug6PqyCZdZn7L
	h0WPPbxiofTvsLOphcEgp+LQKk8rx98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778754433; a=rsa-sha256;
	cv=none;
	b=asvpi37xvJQAef+jQaDEHtADX4/lkASvhqBI1R+LLJbGPcLNSGrODGH40IRrrS0SbqZzx4
	jqp8A2PK9zjxpQGP+RIKaZqcTUfiyWeNYBnXkiBgFQLJhZa4/nYNb8ywHkJppS4h9Z2Vbf
	1hFu/uGqZDpWuw+vXETpCOU6k6iVlgA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n5lQukOx;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778754433; x=1810290433;
  h=date:from:to:cc:subject:message-id;
  bh=3HhlC1VUktv/C3dGPnW7KDEUOWMR3qKkiexr7vbL0e8=;
  b=n5lQukOxsc4pxxEWXpozSqVMM/iu8Zq9KIbi9MLOWUDH8XAnwXbxiEo2
   Hraop7xcliSFr2venMiirCdiQLq144ASVynxv1uRJKGIJslnz9/z3gDYU
   hr+Ko0jsQGtS/xd1MLu9NKY67MwsMCqnwowS88SV9g2cNz16ckYs+wDvD
   fF5jTAnSzaIS3PGxqleTq6useclnwkBOoHTce0xW/rOZmNlvTYeJRaYOz
   neueAIz20oLkUldg72dTOGKJsEfaavI9IABlBUH+8zYQgfAWcgbOukaSj
   YnMK9wtRBgjrqVUBk5Q08RD1lo2i+fp4OBV6f+JIEY8Z/gQ+pXZ5o4i43
   Q==;
X-CSE-ConnectionGUID: 6OkzfMcrTUSConWnAx9suA==
X-CSE-MsgGUID: 4uTp+rMaQmGwcinc0oVcFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="90387542"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="90387542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 03:27:12 -0700
X-CSE-ConnectionGUID: fkWXV+1hTsulGXbmFp5Yeg==
X-CSE-MsgGUID: 0LkLLypoQeysFUCEN0oKng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="240185684"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 14 May 2026 03:27:09 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNTHW-000000006M3-3fY3;
	Thu, 14 May 2026 10:27:06 +0000
Date: Thu, 14 May 2026 18:26:11 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:17: error:
 implicit declaration of function '__huge_pmd_unshare'; did you mean
 'huge_pmd_unshare'?
Message-ID: <202605141855.iUPf0H4F-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5BF18000A
X-Stat-Signature: ncn5d1kes8c8ig7us9kgj8op1qtgdip8
X-Rspam-User: 
X-HE-Tag: 1778754432-653860
X-HE-Meta: U2FsdGVkX19x78rh6i82vCPIaGWPWy8iwJOSNJY+TDfZNabOmH0dSnjLvgRNjkNx15X5bqQvEe9RGix2LXwYtwDTbQ/mIlHKHPtp4RYgjocnH/mn/ovcg5AIfbx9/trIZOwpazdMbfmbQqBcsfrnQL2ZLY6SkpGGEZByrGgNpUFqzFuoq4bFjTOYXzwNRZF+5QQVtLCsHODzZ1QAQ1xpF4rcY++tbBPLMk3L0d15HBkwBN3MAed8OoHZZIFeAFmz9aLcy12vwtKkSF226qZdTtikSqJUqrleg6f9LsUSO4hCqM98cIEiSiJgHrqMYR6vy3nZ3puIlcEO3QhLFjd8skniyQ1x43WVusgPCFpkGH8VEbeUGgxJb5ED3pKxGrlTNtUBWo0OLMUjzIQPKGaCv+6m30dgS4ROk1cYrHtXVKkx60wGNVmspS9b5mfDQ4PGxZCQTIiDtHxgQ5ftdfvcuIoeDZMdN0FA6bfCi6uiEhnPCNRmwmTLdBpqn9OpcDE8Rw03IKepq23z1a57WrhgtaPJ31HfogO3pXOHK/CY5XeCDmQvWG5MF5wBBkEB5l4K+b2HZ3R7IG38pOsIY6eBHdDFPDHGiagbYva+S2tkGmVQ4HqUBTPBsfCLXNEQvvd/1tSZLsAAsC19VzI0WHok6xaNhbsfYgqD3mxPapi40okfkxxmWgvlmhVC1g4rDyK9OH/qvdK5/3OITGEX3Ije5r/olGCi0vPMtBSAnF81KT1sKdFUTp3ycd5IixtxMwa40VRt6Zao4qcVWY3gHq6YbrpWzAgSGiiJqFS8oJ5Fs/oL893BFwbzw7M19+NASJ6BtDDo2q2JvlBI1GE+uQDhQVFe3iEVoHWYpWo+mDHxCn/1hhCvulMYgzdnDPZbvjSduAHmAnpOscnl1fTPWVviQ/3EcoWRjSqnyQD0A6yOGQ4v6uOOybyJKTvCxOVQi9PGJUeUs8ydrsZc6QV2TMM
 z6PMnskE
 p1GQEtO11frOwz8plhEIEnp9GNc6AcAFi1XejAFkuuiOD6SDBtVDssGRgq4iGxIOzO/gv0oa1aIkYVrfKwIvFrSLDIIe6crE/HEQrzfao55zeZO+mR1z34C79MPqokOXtGt+eGqBXReWPERwzT0EsOOlhmdQNJNKqPQneDiO1BvXYGLBEpmhwhAKJ/mcARupqMr4lZn3QAO98micNBuNfynhNFnIGfB5cO51w6nRHq4v77t1+IIXIgn0HfFBssLKnAFjx8tH8bnUMBtaU9tNYfacHt+agO0cBqmLruMVQUDGbtTuBEGLc4/8qe46MnhqHWVyb68Pq9AEG1f0JBgiVZGS5/NZe9hqvuxlQWpLfvXRHDh16+Zj9SJqxaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   444fc9435e57157fcf30fc99aee44997f3458641
commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260514/202605141855.iUPf0H4F-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605141855.iUPf0H4F-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605141855.iUPf0H4F-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hugetlb.c: In function 'hugetlb_unshare_pmds':
>> mm/hugetlb.c:7281:17: error: implicit declaration of function '__huge_pmd_unshare'; did you mean 'huge_pmd_unshare'? [-Wimplicit-function-declaration]
    7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
         |                 ^~~~~~~~~~~~~~~~~~
         |                 huge_pmd_unshare


vim +7281 mm/hugetlb.c

  7233	
  7234	/*
  7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
  7236	 * access can happen (except for gup_fast() and hardware page walks).
  7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
  7238	 * concurrent page fault handling) and the file rmap lock.
  7239	 */
  7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
  7241					   unsigned long start,
  7242					   unsigned long end,
  7243					   bool take_locks)
  7244	{
  7245		struct hstate *h = hstate_vma(vma);
  7246		unsigned long sz = huge_page_size(h);
  7247		struct mm_struct *mm = vma->vm_mm;
  7248		struct mmu_notifier_range range;
  7249		struct mmu_gather tlb;
  7250		unsigned long address;
  7251		spinlock_t *ptl;
  7252		pte_t *ptep;
  7253	
  7254		if (!(vma->vm_flags & VM_MAYSHARE))
  7255			return;
  7256	
  7257		if (start >= end)
  7258			return;
  7259	
  7260		flush_cache_range(vma, start, end);
  7261		tlb_gather_mmu_vma(&tlb, vma);
  7262	
  7263		/*
  7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
  7265		 * we have already done the PUD_SIZE alignment.
  7266		 */
  7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
  7268					start, end);
  7269		mmu_notifier_invalidate_range_start(&range);
  7270		if (take_locks) {
  7271			hugetlb_vma_lock_write(vma);
  7272			i_mmap_lock_write(vma->vm_file->f_mapping);
  7273		} else {
  7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
  7275		}
  7276		for (address = start; address < end; address += PUD_SIZE) {
  7277			ptep = hugetlb_walk(vma, address, sz);
  7278			if (!ptep)
  7279				continue;
  7280			ptl = huge_pte_lock(h, mm, ptep);
> 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
  7282			spin_unlock(ptl);
  7283		}
  7284		huge_pmd_unshare_flush(&tlb, vma);
  7285		if (take_locks) {
  7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
  7287			hugetlb_vma_unlock_write(vma);
  7288		}
  7289		/*
  7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
  7291		 * Documentation/mm/mmu_notifier.rst.
  7292		 */
  7293		mmu_notifier_invalidate_range_end(&range);
  7294		tlb_finish_mmu(&tlb);
  7295	}
  7296	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

