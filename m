Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF24D38FED
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93806B0089; Wed, 14 Jan 2026 11:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F746B009E; Wed, 14 Jan 2026 11:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F2C6B009F; Wed, 14 Jan 2026 11:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38026B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:47:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F5D0BA149
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:47:09 +0000 (UTC)
X-FDA: 84331149378.16.3AB62F4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94CE3A0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:47:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BnWXNoFA;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I39HASnXsqxc9xQWRogWEaHpTvzjVn/oJBE3vNlPdms=;
	b=T9JTK5Zyh1DQZc328cSsERhFddDGQrB3JRUi9VrjfP4/0a2+jzGzk7GqAJ1PN064OT/F3w
	vvfGAiKCT2n94d0xJ9HLdQCvdy4RtO5B66x8kaa1L26TJEKJTSDC4h0OCSi/sM8hE+24lu
	YSl/xBhGJRh+8nPIz+jVA+yqbhgf3ro=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BnWXNoFA;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409227; a=rsa-sha256;
	cv=none;
	b=gdDRJAK198kdLp9YvE3Ds5lfMdf+8F8kctPBGcZo+ggcvoSKBPcJy92a/4NrAbh1T+x6l8
	VuoetooDGg7rFMteElk1Ok2X3lwIZvaVNnDcTq2uBXius6cYoBYiWwZn5JjE+kjlWviFmX
	2zHyXpUZeeVLLEkCqo8oaYftcS6u+64=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768409227; x=1799945227;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LsduvWdE521sHVk8zAXpbZYRmWsiFUTl1UjUbzQRAxE=;
  b=BnWXNoFA0xo7jrwRAL/i/zYT9AGf1n9zWxsBPsL1gO2r6TZYsV7vpUea
   cnhbAFXdm0w/hSGGgWdeaRqYmb4Om0kEfBM0LeE+AvIxo/IhwPp0wxKgR
   8ABLII1sz6QFlVMwRHUeYIC/zFtNh/KVms9Gd11b+2vaM6r3MHUKLgJRo
   f9RRBWdv0qH50XWNNuMkJ3KgrRhDdDFLWxjvhqF+AKxie+3/3HmgXLMyp
   JYW7pKf0n9m0PmDLaITEWYnPgHzxWAjCEHDBVCUDt6KPgUmUZM79+ZGVf
   rIOZQFbEAvtWG/I5byiWzq2j/pJDUSSTYmA4rCNo03yM+dJ4RVnbWZsEG
   Q==;
X-CSE-ConnectionGUID: KeZcSCBQRxu81e/p3RlKZQ==
X-CSE-MsgGUID: z66phPRSTiqrYnX5vY9tLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="80433676"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="80433676"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 08:47:05 -0800
X-CSE-ConnectionGUID: hoja1WWcSDCX1doRuk9J1A==
X-CSE-MsgGUID: ZU2sdGa3T7Sqs/x+nSwX/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="209772062"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 14 Jan 2026 08:47:02 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vg41L-00000000GfQ-0f0V;
	Wed, 14 Jan 2026 16:46:59 +0000
Date: Thu, 15 Jan 2026 00:46:31 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601150035.taEgRkxK-lkp@intel.com>
References: <20260114091923.3950465-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114091923.3950465-2-mpenttil@redhat.com>
X-Stat-Signature: irg4sk8p5ai5rz41u5ipsm7su86o54yy
X-Rspamd-Queue-Id: 94CE3A0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768409226-310443
X-HE-Meta: U2FsdGVkX1/o7pyAQmR/jgW4GafhR35heES4SaFwIrJQW1EvhAgHNywuIj61qt7eGEgyYt1H/dexgevtdzrIx7bMe8zavweVe9XNh9kgxvOyDx0LcYwvpMx1WTnmqYbNRZDugsVRR/W919eRBbBofmUuQl98yAPqlMsxmHJd590ZSoG1ozhrdLFa/T3I09+2TntNuQ/uBBBR3dF6RCU0lVisChdFl2RBVFfDETAd7Lmjpow5YcP7onk08RPWT5IP7aHWKYL+jJ1aSpOlWtmfAHd8e+J5sVY+96rtHm32McXiolQM3Aj1TYA8Y1dhCMkckZG4Ma1IHmGLaStFJ1PSITJHhJZq7dSPXPCEtMQHzE5OPJen4MYVLyTvUXQ9LF1eKdWQHH1uMRgReaAvnR/ThgQe5Xy5zilmZ4vxSXyMnUAEF9xN3lhtF11anN5Eik0Y5ayTKUuR7QAvM+HjUPr0TVL97sf7uMkJyBQE0CpV+IyMu6xfUxAXxNp9VZ4zzm5H3cAuNCSFH9T/7vLw5zTh5n26OJOMoSOeETwMI/YAET3wTPZdqXK0tn8JbdMWXUvUWVN+HPXTISgCt/KAD4mphgGcdfkgzSXHt6ZXfMcRW6OnLUWB2tiob6yhCFw9vFg4/mRpPfdGzBB/nHfklLjZvKG1k68ptI73ncg+sHOjUBJ7Q9LEqsXtd/N3ZXGdRpLv85fBhGqcOIf1oG/7Mi4d0GAQWJHr1ClDKnTEMjsoIXa2v0TCSUr7idXrx8PWULO+Q3fXtPisP9uTKP/1CKcbSRHQfNLJAon85waXhCX8FVGGI4/XCZirSPew02F+n6l1EogZAyYKOqGcItHBgGf2B3VyFLYJKkxn/9w6Yjn43oGkuBJpUECcS1QqrH0XluZy+2vJgTmg+T8VBrEPX05aeamL2DPa3neWYz78MoCRQVuYmL0laQUwkZv+ghJnnB9lYlyZZOhTrSrXmpdJpo4
 roe1uqNq
 W74N/X1d4wha19Lm4DQ4uhGRIpciHrbxHJDeitUylMNtft3RUWUmZ3b/xFX7ykcWgOtzHEKk6IOWQmtgzNgffMCCNFvwsVRe8d34CJA3XbcgsmpQAzA/QpcwNh3ClJUD2Rh3WwSSH7pFR7elCoplqWNTV5foZ1AKH0/u4kPwH7cIp1ZcF4cLPrUZjTK93jwzjVUfzAA0VOpfa6noHANsbAaMKe62wnXJCqD5Hh+QpMOOEZ7+9JklZLS4iqri4Zezo8zUmiIbjUhYnvG+2mLlOtDn8qXNV2XpTM0YwjdlRqACUDGATOlPABYJKkPiz/UcQxT/bc2id/Rq8MFViW3r137HvWGCYwNPye+KV2x3KzFWc37ecqc0m/zArZEwxgGboh1oH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on linus/master v6.19-rc5 next-20260114]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260114-172232
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260114091923.3950465-2-mpenttil%40redhat.com
patch subject: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20260115/202601150035.taEgRkxK-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260115/202601150035.taEgRkxK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601150035.taEgRkxK-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hmm.c:423:20: warning: unused variable 'range' [-Wunused-variable]
     423 |         struct hmm_range *range = hmm_vma_walk->range;
         |                           ^~~~~
>> mm/hmm.c:781:4: error: call to undeclared function 'flush_tlb_range'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     781 |                         flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
         |                         ^
   mm/hmm.c:781:4: note: did you mean 'flush_cache_range'?
   include/asm-generic/cacheflush.h:35:20: note: 'flush_cache_range' declared here
      35 | static inline void flush_cache_range(struct vm_area_struct *vma,
         |                    ^
   1 warning and 1 error generated.


vim +/flush_tlb_range +781 mm/hmm.c

   587	
   588	/*
   589	 * Install migration entries if migration requested, either from fault
   590	 * or migrate paths.
   591	 *
   592	 */
   593	static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
   594						  pmd_t *pmdp,
   595						  unsigned long addr,
   596						  unsigned long *hmm_pfn)
   597	{
   598		struct hmm_vma_walk *hmm_vma_walk = walk->private;
   599		struct hmm_range *range = hmm_vma_walk->range;
   600		struct migrate_vma *migrate = range->migrate;
   601		struct mm_struct *mm = walk->vma->vm_mm;
   602		struct folio *fault_folio = NULL;
   603		enum migrate_vma_info minfo;
   604		struct dev_pagemap *pgmap;
   605		bool anon_exclusive;
   606		struct folio *folio;
   607		unsigned long pfn;
   608		struct page *page;
   609		softleaf_t entry;
   610		pte_t pte, swp_pte;
   611		spinlock_t *ptl;
   612		bool writable = false;
   613		pte_t *ptep;
   614	
   615		// Do we want to migrate at all?
   616		minfo = hmm_select_migrate(range);
   617		if (!minfo)
   618			return 0;
   619	
   620		fault_folio = (migrate && migrate->fault_page) ?
   621			page_folio(migrate->fault_page) : NULL;
   622	
   623	again:
   624		ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
   625		if (!ptep)
   626			return 0;
   627	
   628		pte = ptep_get(ptep);
   629	
   630		if (pte_none(pte)) {
   631			// migrate without faulting case
   632			if (vma_is_anonymous(walk->vma)) {
   633				*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
   634				*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
   635				goto out;
   636			}
   637		}
   638	
   639		if (!pte_present(pte)) {
   640			/*
   641			 * Only care about unaddressable device page special
   642			 * page table entry. Other special swap entries are not
   643			 * migratable, and we ignore regular swapped page.
   644			 */
   645			entry = softleaf_from_pte(pte);
   646			if (!softleaf_is_device_private(entry))
   647				goto out;
   648	
   649			if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
   650				goto out;
   651	
   652			page = softleaf_to_page(entry);
   653			folio = page_folio(page);
   654			if (folio->pgmap->owner != migrate->pgmap_owner)
   655				goto out;
   656	
   657			if (folio_test_large(folio)) {
   658				int ret;
   659	
   660				pte_unmap_unlock(ptep, ptl);
   661				ret = migrate_vma_split_folio(folio,
   662							      migrate->fault_page);
   663				if (ret)
   664					goto out_unlocked;
   665				goto again;
   666			}
   667	
   668			pfn = page_to_pfn(page);
   669			if (softleaf_is_device_private_write(entry))
   670				writable = true;
   671		} else {
   672			pfn = pte_pfn(pte);
   673			if (is_zero_pfn(pfn) &&
   674			    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
   675				*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
   676				goto out;
   677			}
   678			page = vm_normal_page(walk->vma, addr, pte);
   679			if (page && !is_zone_device_page(page) &&
   680			    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
   681				goto out;
   682			} else if (page && is_device_coherent_page(page)) {
   683				pgmap = page_pgmap(page);
   684	
   685				if (!(minfo &
   686				      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
   687				    pgmap->owner != migrate->pgmap_owner)
   688					goto out;
   689			}
   690	
   691			folio = page_folio(page);
   692			if (folio_test_large(folio)) {
   693				int ret;
   694	
   695				pte_unmap_unlock(ptep, ptl);
   696				ret = migrate_vma_split_folio(folio,
   697							      migrate->fault_page);
   698				if (ret)
   699					goto out_unlocked;
   700	
   701				goto again;
   702			}
   703	
   704			writable = pte_write(pte);
   705		}
   706	
   707		if (!page || !page->mapping)
   708			goto out;
   709	
   710		/*
   711		 * By getting a reference on the folio we pin it and that blocks
   712		 * any kind of migration. Side effect is that it "freezes" the
   713		 * pte.
   714		 *
   715		 * We drop this reference after isolating the folio from the lru
   716		 * for non device folio (device folio are not on the lru and thus
   717		 * can't be dropped from it).
   718		 */
   719		folio = page_folio(page);
   720		folio_get(folio);
   721	
   722		/*
   723		 * We rely on folio_trylock() to avoid deadlock between
   724		 * concurrent migrations where each is waiting on the others
   725		 * folio lock. If we can't immediately lock the folio we fail this
   726		 * migration as it is only best effort anyway.
   727		 *
   728		 * If we can lock the folio it's safe to set up a migration entry
   729		 * now. In the common case where the folio is mapped once in a
   730		 * single process setting up the migration entry now is an
   731		 * optimisation to avoid walking the rmap later with
   732		 * try_to_migrate().
   733		 */
   734	
   735		if (fault_folio == folio || folio_trylock(folio)) {
   736			anon_exclusive = folio_test_anon(folio) &&
   737				PageAnonExclusive(page);
   738	
   739			flush_cache_page(walk->vma, addr, pfn);
   740	
   741			if (anon_exclusive) {
   742				pte = ptep_clear_flush(walk->vma, addr, ptep);
   743	
   744				if (folio_try_share_anon_rmap_pte(folio, page)) {
   745					set_pte_at(mm, addr, ptep, pte);
   746					folio_unlock(folio);
   747					folio_put(folio);
   748					goto out;
   749				}
   750			} else {
   751				pte = ptep_get_and_clear(mm, addr, ptep);
   752			}
   753	
   754			/* Setup special migration page table entry */
   755			if (writable)
   756				entry = make_writable_migration_entry(pfn);
   757			else if (anon_exclusive)
   758				entry = make_readable_exclusive_migration_entry(pfn);
   759			else
   760				entry = make_readable_migration_entry(pfn);
   761	
   762			swp_pte = swp_entry_to_pte(entry);
   763			if (pte_present(pte)) {
   764				if (pte_soft_dirty(pte))
   765					swp_pte = pte_swp_mksoft_dirty(swp_pte);
   766				if (pte_uffd_wp(pte))
   767					swp_pte = pte_swp_mkuffd_wp(swp_pte);
   768			} else {
   769				if (pte_swp_soft_dirty(pte))
   770					swp_pte = pte_swp_mksoft_dirty(swp_pte);
   771				if (pte_swp_uffd_wp(pte))
   772					swp_pte = pte_swp_mkuffd_wp(swp_pte);
   773			}
   774	
   775			set_pte_at(mm, addr, ptep, swp_pte);
   776			folio_remove_rmap_pte(folio, page, walk->vma);
   777			folio_put(folio);
   778			*hmm_pfn |= HMM_PFN_MIGRATE;
   779	
   780			if (pte_present(pte))
 > 781				flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
   782		} else
   783			folio_put(folio);
   784	out:
   785		pte_unmap_unlock(ptep, ptl);
   786		return 0;
   787	out_unlocked:
   788		return -1;
   789	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

