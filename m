Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8A5C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7EBD6B009B; Thu, 31 Jul 2025 12:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F556B009D; Thu, 31 Jul 2025 12:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E526B009F; Thu, 31 Jul 2025 12:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0D516B009B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:20:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AA705B93B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:16 +0000 (UTC)
X-FDA: 83725072032.02.E8ACEEC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id A76CC140014
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Wkgm/mup";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753978814; a=rsa-sha256;
	cv=none;
	b=IcTuvpL7PVY/HHymHQ2ZbTXF/VA3Rt7UBa8mPqPFIZ1KzYQLl4KDtCAPzHOJmHFsEkxrep
	uDOLj9NMKmpZ2bVxxu2KoSEbiKkOJRqaXP9jsKbq+aLQl7K+4AG4mU1NHeG/KC1M7fGfwx
	Hm4sN2zvbLq16KbL4F4uIn+7HGocoiU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Wkgm/mup";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753978814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQV9RMp9f4E/nbPJJC3DVHU8cyJTvIdvE2n56xqCssM=;
	b=Q7DvwUM3kWkByxAG5TqTP1BYe+F5acB0t3wtph9KeyaRrGtVptUnRZW28zRpYcGZdsv/Z7
	SMgHcu+RARr7lzLCP4ywRTmOwBL9SbB9J4HM9ALdQ0Mx+mhNpZ1rdOoyXj052SxGT0oSOA
	zLSHOG3ftOJMbbn0ipSP4RLRf9yBmsY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753978814; x=1785514814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Uzw4l/DadJpUNAI5j/MXwiKLFsLDzgdQXCiuDsi3QE=;
  b=Wkgm/mupYmtrojSSzRnu4CoJdk2of5Ib6AeL082S40Yw3Umkd4NQ2b7K
   GRzSrlORKSmIBf2Goo/+v7NPRAvtyWJ2xafc50IFohC5bw2898Rrld62F
   CUeersQBf77/jp1YSgt4AfR2X0hxMKB5nfNl976lyqMXrw8ncX4fDgfR+
   c88NpxkF8IuL139v3uWABgqPQdMGvbUjfe3XW26o3AoiIbqmjXoC7axag
   w4T+bcbXCrb8lpbJmpuN6tw21XbIhZud+fmO4UPsH7nHrqkwgWFr2I9Sl
   lqd+n0vzs24Z68HjHP3OjUbotPLGVZMeZPGKyDk/k8uIchJkQv9Uh76Ts
   A==;
X-CSE-ConnectionGUID: me6rgZ+CRvmXljH4r/FXOA==
X-CSE-MsgGUID: JKZFBeKMTA+4q1VbkHOd9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56455679"
X-IronPort-AV: E=Sophos;i="6.17,254,1747724400"; 
   d="scan'208";a="56455679"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 09:20:12 -0700
X-CSE-ConnectionGUID: 1TSHb2rpQySMYDBl24Qimg==
X-CSE-MsgGUID: gK+enTLiSlGTTNmrphHccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,254,1747724400"; 
   d="scan'208";a="167791054"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 31 Jul 2025 09:20:06 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhW0h-0003um-2m;
	Thu, 31 Jul 2025 16:20:03 +0000
Date: Fri, 1 Aug 2025 00:19:52 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 03/11] mm/migrate_device: THP migration of zone device pages
Message-ID: <202507312342.dmLxVgli-lkp@intel.com>
References: <20250730092139.3890844-4-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730092139.3890844-4-balbirs@nvidia.com>
X-Stat-Signature: dafh5mpni7ma5ugwxmz9sie1c9s5jegd
X-Rspam-User: 
X-Rspamd-Queue-Id: A76CC140014
X-Rspamd-Server: rspam02
X-HE-Tag: 1753978813-461550
X-HE-Meta: U2FsdGVkX19OWsaBOCA8JkeBKzSS833UIMvxVfNeZEm2uAZZcGkacCaYgDNTfhIX5YrvM8tZkjAXFRLcHnvtL/HDSjVWLwv19b2kP7KfjOL87OcEdz3Tr44SZxxP9F4rs+diROJbEmBpODSUp3RXZmSVtf6Us71r/oNhv2e0dr4uDB+cwXYwhFxdUoDpCQih3frMc7a7szaNShngb2euTaVChtlxFtVrMGGiZH3qzQnkWfefe2OX6hGhRtAjpzYcUT9+Tto841T1WNS3sHKBAlFULZMjrsW61RX81veumps7/2PP+RNo8jL8gMhTznqmTNWtLKgDGDQ4PAl8s+uEFshIABAUWaZGjvXR97Uqwn47EY+4KjaUfluvSvwP+FyWTYpMVM6InS3boFO5Yw5wj18ORe8Xg46WNcbCaxBYiCHO+k2QvqlsDbEmkmAdd8uc9OF032sHcU9Q8SalBZnaKDi2dT6YEjczbEoqcSAXlmtSXddmlkT014gE69w+ZbMlGMdLgvTmqwIvIOLAY028qIiG+7aRgEXhv1Lpi07KDBK/UvKhOH9BKnCoSNSlgFJDTMtBUWSkQUJA+1rqkDyOog7ehFopp5zg+Qn1n8YFX1Iv0i1TfukZ0eT5ui3WDbRusOc4wfyUsnoaGa18MDDB4aDvloMbdSUkUjumY4boxO78YIaGkTE4F6sLK7HDGqwEWQgneh/dBmOtFbc/IYosKRt7XEYJVt2Bcdw+pDH6dNzsMv9QQtWCvVjpwzcSPXRihkN9HVSJhgOuWtYN0qGrxU8zfJM0fpCZry3PEdXRFC+O5J1nur9eN1kQ23922h1fr2OMD1V6PGft56EyTlR1iWwOcloSpFKfUYB3XqRFGXw0seONdBUoUrAuzCiAacw+ZWwgvzoozOLNgjuA6zgb2vj6z2OJO+vBOV+uqZna3bZcv7TQqlhBuvHC3m+4zBEoVl8c/siF9y0W4KEleHf
 uKy1aX2/
 R8+XHfQFByPmjuIFg6gjRn5S8WN0rZwgE2ucwNWrihtqCzVHPNydKFVWLc95cOJcLnSv631rjPK3xJTrHNALZf/tEInvmLVdRkAz1OszWPszlWej9e+YROT6c7k2Du1tuYZ9xDeygSps98OUkPG65icG3iibWPYzf7SiOdhPS4eU3ZImUWZIwX05d6kaVzgnVIdRJTCO8uHo1wkqoNSGN4oDj9wCkRaU8Igy31CwblZcZ8JxHdetyelHeQNbdG8pggTWterZkY6LC+vdLd6/lC5iv7vz5zneSb+7x15KAysTnVSMXedKYMcHjlIaHIj/jyXGnDMDlHgfi4E0HZCSkFUqN5485NdxufoAZibIFYwL2gWZaRSA+pTAHCZEcTo5aGGKAoTYkRCD2bmNM3kma5ZP35IAieh9Y7fCxJdxzt5PgW9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20250731]
[cannot apply to akpm-mm/mm-nonmm-unstable shuah-kselftest/next shuah-kselftest/fixes linus/master v6.16]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-zone_device-support-large-zone-device-private-folios/20250730-172600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250730092139.3890844-4-balbirs%40nvidia.com
patch subject: [v2 03/11] mm/migrate_device: THP migration of zone device pages
config: x86_64-randconfig-122-20250731 (https://download.01.org/0day-ci/archive/20250731/202507312342.dmLxVgli-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507312342.dmLxVgli-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507312342.dmLxVgli-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/migrate_device.c:769:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted vm_fault_t @@
   mm/migrate_device.c:769:13: sparse:     expected int [assigned] ret
   mm/migrate_device.c:769:13: sparse:     got restricted vm_fault_t
   mm/migrate_device.c:130:25: sparse: sparse: context imbalance in 'migrate_vma_collect_huge_pmd' - unexpected unlock
   mm/migrate_device.c:815:16: sparse: sparse: context imbalance in 'migrate_vma_insert_huge_pmd_page' - different lock contexts for basic block

vim +769 mm/migrate_device.c

   689	
   690	#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
   691	/**
   692	 * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
   693	 * at @addr. folio is already allocated as a part of the migration process with
   694	 * large page.
   695	 *
   696	 * @folio needs to be initialized and setup after it's allocated. The code bits
   697	 * here follow closely the code in __do_huge_pmd_anonymous_page(). This API does
   698	 * not support THP zero pages.
   699	 *
   700	 * @migrate: migrate_vma arguments
   701	 * @addr: address where the folio will be inserted
   702	 * @folio: folio to be inserted at @addr
   703	 * @src: src pfn which is being migrated
   704	 * @pmdp: pointer to the pmd
   705	 */
   706	static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
   707						 unsigned long addr,
   708						 struct page *page,
   709						 unsigned long *src,
   710						 pmd_t *pmdp)
   711	{
   712		struct vm_area_struct *vma = migrate->vma;
   713		gfp_t gfp = vma_thp_gfp_mask(vma);
   714		struct folio *folio = page_folio(page);
   715		int ret;
   716		spinlock_t *ptl;
   717		pgtable_t pgtable;
   718		pmd_t entry;
   719		bool flush = false;
   720		unsigned long i;
   721	
   722		VM_WARN_ON_FOLIO(!folio, folio);
   723		VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
   724	
   725		if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
   726			return -EINVAL;
   727	
   728		ret = anon_vma_prepare(vma);
   729		if (ret)
   730			return ret;
   731	
   732		folio_set_order(folio, HPAGE_PMD_ORDER);
   733		folio_set_large_rmappable(folio);
   734	
   735		if (mem_cgroup_charge(folio, migrate->vma->vm_mm, gfp)) {
   736			count_vm_event(THP_FAULT_FALLBACK);
   737			count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
   738			ret = -ENOMEM;
   739			goto abort;
   740		}
   741	
   742		__folio_mark_uptodate(folio);
   743	
   744		pgtable = pte_alloc_one(vma->vm_mm);
   745		if (unlikely(!pgtable))
   746			goto abort;
   747	
   748		if (folio_is_device_private(folio)) {
   749			swp_entry_t swp_entry;
   750	
   751			if (vma->vm_flags & VM_WRITE)
   752				swp_entry = make_writable_device_private_entry(
   753							page_to_pfn(page));
   754			else
   755				swp_entry = make_readable_device_private_entry(
   756							page_to_pfn(page));
   757			entry = swp_entry_to_pmd(swp_entry);
   758		} else {
   759			if (folio_is_zone_device(folio) &&
   760			    !folio_is_device_coherent(folio)) {
   761				goto abort;
   762			}
   763			entry = folio_mk_pmd(folio, vma->vm_page_prot);
   764			if (vma->vm_flags & VM_WRITE)
   765				entry = pmd_mkwrite(pmd_mkdirty(entry), vma);
   766		}
   767	
   768		ptl = pmd_lock(vma->vm_mm, pmdp);
 > 769		ret = check_stable_address_space(vma->vm_mm);
   770		if (ret)
   771			goto abort;
   772	
   773		/*
   774		 * Check for userfaultfd but do not deliver the fault. Instead,
   775		 * just back off.
   776		 */
   777		if (userfaultfd_missing(vma))
   778			goto unlock_abort;
   779	
   780		if (!pmd_none(*pmdp)) {
   781			if (!is_huge_zero_pmd(*pmdp))
   782				goto unlock_abort;
   783			flush = true;
   784		} else if (!pmd_none(*pmdp))
   785			goto unlock_abort;
   786	
   787		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
   788		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
   789		if (!folio_is_zone_device(folio))
   790			folio_add_lru_vma(folio, vma);
   791		folio_get(folio);
   792	
   793		if (flush) {
   794			pte_free(vma->vm_mm, pgtable);
   795			flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
   796			pmdp_invalidate(vma, addr, pmdp);
   797		} else {
   798			pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
   799			mm_inc_nr_ptes(vma->vm_mm);
   800		}
   801		set_pmd_at(vma->vm_mm, addr, pmdp, entry);
   802		update_mmu_cache_pmd(vma, addr, pmdp);
   803	
   804		spin_unlock(ptl);
   805	
   806		count_vm_event(THP_FAULT_ALLOC);
   807		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
   808		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
   809	
   810		return 0;
   811	
   812	unlock_abort:
   813		spin_unlock(ptl);
   814	abort:
   815		for (i = 0; i < HPAGE_PMD_NR; i++)
   816			src[i] &= ~MIGRATE_PFN_MIGRATE;
   817		return 0;
   818	}
   819	#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
   820	static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
   821						 unsigned long addr,
   822						 struct page *page,
   823						 unsigned long *src,
   824						 pmd_t *pmdp)
   825	{
   826		return 0;
   827	}
   828	#endif
   829	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

