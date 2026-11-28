Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FB5606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 05:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GbCbZ9HV
Received: by kanga.kvack.org (Postfix)
	id 46AEC6B05B0; Sat, 28 Nov 2026 00:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C946B05B1; Sat, 28 Nov 2026 00:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3330B6B05B2; Sat, 28 Nov 2026 00:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013A16B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:12:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEB571205C7
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:12:19 +0000 (UTC)
X-FDA: 85483356798.04.2FF2BE4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6405280005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 05:12:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GbCbZ9HV;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795842738;
	b=Sg6d5opGgqpIFjJhkzMIicGyHtORd+eCofXohgAviTkGtfPcV4N1QlLpdK2lkpYkJqgZAg
	RxXDYADYHNFzazYo58SThgAsslhYAji9/uYh9oWC4foYO0cW4X8xm/5CyiTNz+dKLKjjxp
	L8V4s1hqZQND2rs+lUq2D31V9q7CNNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795842738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mQhZ0Rpe582oGSmJzrc5wrx+1NfOeiMeUFY1k2TTu3A=;
	b=DqY0qKmy9q5QpIfMzq42uv/h4SqYWH1tHkMxa8mYdDJzH+DPmZ3R0wLBB6g8SioO+6LoG0
	Ua+9HKHhN35JhBpF2GAA3p4rVmk3VSFVpKZ43rQe13bd7hvBt8AX1+E+u548I4dry/YDDM
	EXDmcqGLdRxZ0k3t5NeV6Z/OqY9uSEA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GbCbZ9HV;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795842737; x=1827378737;
  h=date:from:to:cc:subject:message-id;
  bh=gaeNwrCQmmeZLD+UpBMSQ5wrQen0hGARmnXlogyI7zQ=;
  b=GbCbZ9HVeW1vF8TQJ1NZAG5I2r3cOfg+oux04qsRZyyB5Ufi9mZNV8f/
   b5k4P5sO3dv1dKhPfvrw2ft8PLaQDtKDp8Sga89SqWKn9jkLk5BhXr5eO
   8MHUbl3C8rtSxFgHG4rnLfx8MVudeHNexyirW2NlvwYwT37lnW5uQfB2J
   Dd7NIl0ZsVOJASZv7GcRHmtXWByCdH78Fbbn1C7goo8cUYqVOxU/Rx2js
   Ts3OSKgrMI7qyMN385oPRIxd1atWdOyV/r3ouoM2JraSAb4gnLimJwCIB
   xpj/D0gjn6InICOa2pG73rbgCih109h6YUq09pielBi6fjjO6+EQB/eMI
   Q==;
X-CSE-ConnectionGUID: db66MSALSPStvt8WFPaEmQ==
X-CSE-MsgGUID: kyzKmHFHTzSKXEyl5sD2Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11979"; a="4649423"
X-IronPort-AV: E=Sophos;i="6.27,238,1787036400"; 
   d="scan'208";a="4649423"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 21:12:16 -0800
X-CSE-ConnectionGUID: amhjKOqXTbasDejXf8oNIA==
X-CSE-MsgGUID: 84lOGwEKSGmWGnsT2fvvqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,238,1787036400"; 
   d="scan'208";a="12546650"
Received: from igk-lkp-server01.igk.intel.com (HELO 146cf1e082f1) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 27 Nov 2026 21:12:14 -0800
Received: from kbuild by 146cf1e082f1 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xXAjL-000000000WA-2hQS;
	Sat, 28 Nov 2026 05:12:11 +0000
Date: Sat, 28 Nov 2026 06:11:18 +0100
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 303/428] mm/huge_memory.c:2546:67:
 error: too few arguments to function call, expected 4, have 3
Message-ID: <20261128060622.OMTGOfau-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6405280005
X-Stat-Signature: 87yn6ai6pp8y8whp31xdc1jf8oj8tr74
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795842737-529984
X-HE-Meta: U2FsdGVkX1/WvT3Z4LqBXJ7Z2xpciQ7oUAQq5o+UQZUQR2wSGfbXzvwnUNrYwltepxNrzsshLscwsy3E+qTs7lI7JXrpKO3qJlD4ciPWxR9uTqhQwrjF/JQBKgetGGUw8MEbkoioYpOv7uR7sSlk3HwWrIz7J6dhtJWEBgJ4CYZtSb0wQoxvEVE3VXAz36IxHeWYuZm0NsIXqGDwTkLPCzGHSsf1Yw0Q++o7ENksmNaWvzbV9Fif2DMarb3dhgstvSZkrMlSHCMO8aRpC99ed3DjW/pwVuYHMMdOP4Rd121w0WrswKwvldOUvXp8xVRcqVeBnHtHLambg7hmjtf1/TL/NOYppiH+I7VggYbT4+cMDBntdzhmsidATlSdDVkvdAjELZzXbsY0tSzaid/8lm9Y5F8u7P8I0/mzFgloxrdgi/csMmAxrDWYe0TRrOrDciaCMZxJv2ly4TmT2xXQQjrKARw8PnB41aD4SkJswUVKw6KDUF/Y5bm7ewgPELc9HeR3xJ/vE53qhaSIevB4iav3hUgUdP3laXnUoRym20cTWt+XSkS+9gKaWJbsRXoIv5vsql3wvmvugKLDYZf/ytOeAU9LulryqG9jpUbtfHPFudSrsEM+CbpI6qEKPLgI/HXQt9zItEn1M09fPOXbEUadrD9/ha/kDvaXUlGeJokbtYoPSBFwhZRkkS1H5N6A3SkLCi1Mtr6gobcfkJnHiVn3RG2rVRCR8ND1PxHavNRRZmGBNPH/7I5+PpxLxEd9zU7LuU15Je1nsMf3iwarMjcBq1waSyhWi0BF6ACkGK7BLzcr5EXhzEwJhZKWw3ROIy/rjpAIlFmp0CTZPl9nPjvms7VFJszUQznL/AS7EreaQ2SBETMV1ei/3pZ9lNuP4ww2/Q8cOHXH+fdn3E7QmKyijLdvmz8XbffovsS1iifAXj0IJIEvR/5cYQt5loIMj40zMQHd7Kp2besIdTx
 qIa+v9mG
 AkidNL6OkV627tF5Lsfz5U29zVW2JB09NPTEmMNr30evFbE3ZNcjwzScWkcXKo/X445JiOX7yHkmqgNCeyav8LGorJXkSSVQzWoYo0Ukv3gTwQvUN3en8SPxWUxnXSdrtX3V7ibM6GYcVT90xvo5w78QpehXWchxUqRQ4U/r7z0YGWSK0gVilvKHEgKxzdjrzg6ku4or7FtihXiFyZQygkZAyMIyVYGoq+HZZLSMV6b3BhgNxv47Y+jsXwqIUldrwKOhM6FnTAlWsTIClCWAl0k8XUAfUbnvOIy3iuStsmvJ0yy4RhtUIK0ZN5f1diN3sI46gQA0iSN8ivE74S7xQRMQapwCZEfZMoj20FRo1X3MjIhjbnJchkCs/ebrh9wfawY0CvpYdfddfo+ytYYk23YR/9Wp1mXmesRUxpn7eFYITCj6kBHJ97Aqh4nnvdY2iwmbpghUNwGHbyYGV7Lr1ApqaeA709O7sLAY8qrKD/2WamTm0JMvfUqq6YAq/JTituOaNzvQAWQyHZ88RuMN47/515QsWlHxTEom378b85krpJuKlr46H0C3WXhcGbCHNcuiB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   ac6a52aad42728ef45e6972c403072fba5c524f4
commit: 5a7c0c5e349b6b13c1689fedd1a82073b4679418 [303/428] mm/hugetlb: delay anon folio rmap removal until after the TLB flush
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261128/20261128060622.OMTGOfau-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261128060622.OMTGOfau-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/huge_memory.c:2546:67: error: too few arguments to function call, expected 4, have 3
    2546 |         else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
         |                  ~~~~~~~~~~~~~~~~~~~~~~                                  ^
   include/asm-generic/tlb.h:248:6: note: '__tlb_remove_page_size' declared here
     248 | bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
         |      ^                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     249 |                 int page_size, bool delay_rmap);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +2546 mm/huge_memory.c

953c66c2b22a304 Aneesh Kumar K.V         2016-12-12  2503  
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2504) static void zap_huge_pmd_folio(struct mmu_gather *tlb, struct vm_area_struct *vma,
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2505) 		pmd_t pmdval, struct folio *folio, bool is_present, bool *force_flush)
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2506) {
63a940541358d09 Chris Mason              2026-10-31  2507  	const bool is_device_private = pmd_is_device_private_entry(pmdval);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2508) 	struct mm_struct *mm = tlb->mm;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2509) 	bool delay_rmap = false;
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2510) 
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2511) 	if (folio_test_anon(folio)) {
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2512) 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2513) 	} else {
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2514) 		add_mm_counter(mm, mm_counter_file(folio),
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2515) 			       -HPAGE_PMD_NR);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2516) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2517) 		if (is_present && pmd_dirty(pmdval)) {
fe6cf984939d8e1 Usama Arif               2026-08-19  2518  			folio_mark_dirty(folio);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2519) 			/*
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2520) 			 * Remove rmap after the TLB flush if stale TLB entries
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2521) 			 * could still be used to write to a mapping that
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2522) 			 * supports writeback.
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2523) 			 */
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2524) 			if (!tlb->fullmm && vma->vm_file &&
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2525) 			    mapping_can_writeback(vma->vm_file->f_mapping))
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2526) 				delay_rmap = tlb_can_delay_rmap();
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2527) 		}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2528) 		if (is_present && pmd_young(pmdval) &&
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2529) 		    likely(vma_has_recency(vma)))
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2530) 			folio_mark_accessed(folio);
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2531) 	}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2532) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2533) 	if (!is_present && !is_device_private)
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2534) 		return;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2535) 
e6a07d29b0a60f3 Chris Mason              2026-10-31  2536  	/*
e6a07d29b0a60f3 Chris Mason              2026-10-31  2537  	 * Present and device private folios are rmappable. Remove the
e6a07d29b0a60f3 Chris Mason              2026-10-31  2538  	 * rmap after transferring young+dirty to the folio.
e6a07d29b0a60f3 Chris Mason              2026-10-31  2539  	 */
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2540) 	if (!delay_rmap)
e6a07d29b0a60f3 Chris Mason              2026-10-31  2541  		folio_remove_rmap_pmd(folio, &folio->page, vma);
e6a07d29b0a60f3 Chris Mason              2026-10-31  2542  
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2543) 	/* Device private folios are pinned and don't need a TLB flush. */
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2544) 	if (is_device_private)
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2545) 		folio_put(folio);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16 @2546) 	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2547) 		*force_flush = true;
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2548) 
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2549) 	if (delay_rmap) {
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2550) 		tlb_flush_mmu_tlbonly(tlb);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2551) 		folio_remove_rmap_pmd(folio, &folio->page, vma);
c818150bf00b0b4 David Hildenbrand (Arm   2026-11-16  2552) 	}
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2553) }
f87854c90910142 Lorenzo Stoakes (Oracle  2026-03-20  2554) 

:::::: The code at line 2546 was first introduced by commit
:::::: c818150bf00b0b42ff02bffc6a2c36d4f0ff7a52 mm/huge_memory: flush dirty file PMDs before removing rmap

:::::: TO: David Hildenbrand (Arm) <david@kernel.org>
:::::: CC: David Hildenbrand (Arm) <david@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

