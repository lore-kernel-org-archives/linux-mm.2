Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C4E606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GQtcgNaA
Received: by kanga.kvack.org (Postfix)
	id 1ACCE6B05B5; Fri, 13 Nov 2026 12:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F4F6B05B6; Fri, 13 Nov 2026 12:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E866B05B7; Fri, 13 Nov 2026 12:11:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD4FC6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:11:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CD1CA01F3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:11:28 +0000 (UTC)
X-FDA: 85430737056.17.0EED19F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84D7018000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:11:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GQtcgNaA;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794589886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eeySqJ6NUrXSgAYigTDXkgs9x3xogv1758TcVbxxaWs=;
	b=H2LQK+0swm5/dxPNRfJ4jHEL6r+0ljFe4ZaAh1l79xDbl+e227dYkaf66rOqfVD1DJJK9q
	/FTIfh0p+/tTFAgaLrveY2GhneOOSZIXKpUzG1/3NfPI9fks4tzVGRFdeUri47FFz6ELE7
	XU4YkFESPNwkdb8heIl+LWi6KyBYZ/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794589886;
	b=54HQ0s9wdQZ79aYmW6q6jYOTGG3XJlV51v6JwU33s/VrkeCIrzngdymg8XSiZpA4bLUOUI
	ZWTtfbPqFFKZv5qo8jBCBotO37uoGtU94gxCvEiYCMfuSE1MBsRkqPt3lqEx2+OLjyiqYX
	Sx5yh6tJImlKg7qDKQe6P68KnXIpoEc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GQtcgNaA;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794589885; x=1826125885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CgpZyVAyt+Qd7pZ3YLkFhQMR5yXckSnAKIR8/gt9wgA=;
  b=GQtcgNaAkGlxYmC1oUPy2KwbeLrusFgo0LcqNcE++78pZeiUaUMxiX9I
   XFR9XuAOGuZ2xz9j3Uvt/6aUJGJkqjpke3+vhnVWAyEBk6Cm8HpsRAy9l
   wKeUejbNPNKrpbvIkibCCcEyW+rI+0UddTathoq/yiYDwrlzz8c32CJZN
   TP1fznAp6FUeFz+eimpJyX3u8a+HBGfX7Gej8e5qaRZA3P49O7cn4njdc
   0A6RZKwtym+fV9BwRs060xY5KJgubytuWu+sPU8rsx152kpabKnTkDg9y
   ReUhHuT6PjIWWj/LA00wZSzrW7eUFtsIpARZXvsgnVWD2IFQ8xMvsa+Q/
   w==;
X-CSE-ConnectionGUID: pAFEhqnaQ3W+WEIJcFZTvg==
X-CSE-MsgGUID: wasHE3VAQp+DK0EQE64JjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3500246"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3500246"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 09:11:23 -0800
X-CSE-ConnectionGUID: R/Etu5amTUaDe9kfeyWTEw==
X-CSE-MsgGUID: lFSp4hyoQT2vw8iR/tj7TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="8782953"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 13 Nov 2026 09:11:20 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRuo1-000000013PL-1kla;
	Fri, 13 Nov 2026 17:11:17 +0000
Date: Sat, 14 Nov 2026 01:10:22 +0800
From: kernel test robot <lkp@intel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com
Cc: oe-kbuild-all@lists.linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baoquan.he@linux.dev, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	mhocko@kernel.org, baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
Message-ID: <202611140137.58xBD8xH-lkp@intel.com>
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 6cbn1m4w7iqjc4uxx5cpny8ppig3gyq4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 84D7018000A
X-Rspam-User: 
X-HE-Tag: 1794589885-30261
X-HE-Meta: U2FsdGVkX18XkLiG1ZDaUhVzE7USVS0z6HDfwfBQCYX8KUEhKiAjaNB1H93nsj/5NyvLHC2EBFzQUbHwoT6iIb0alqcXbeobJKD+a73SR0Rfl59TcAK5Br5cDSHlC6+6B/z8LhIBwW7xctJgCslzsPFSI2blxMf+RFvrowHiqAfNmegpZd+Nc/AfdrkLYD2S61mlwbP6sxminJz59VCtm6lkmnZmeUJL5uttYrvGCK7ChEQ/MFkohBZakz+GJESrkYXXuwn+qztSjKz+6CU/xxmrikc2wunio0Tnb8Ug+f/lIf07+SaHarro8U0jPjrIm+S9cbaE/MXF/rPRkjnJZbJSBT/goAjWiU9mDMX/UIPfvQbKxKY9hfX+8Tcxtx+4W3UPT0eQJ9nlbYUiJ20pZLHHq6rBeRZMOXAbj+y/NuNy+EIDufE558u5pCzzfB1xAucCV2AlQArQOlZ0hnnR/ccBEazr9AaKtU3Nc3eE/O0buPNYHw5zw43aOaSwV/RdAoYE5AHaMiVVtxJlh3Iy0u2XAP90h/bf9Nqust+OIBhVYFTb9eFoql3sRuK3lRNQ3NrXWC5resndYLXpRyZJpkM5FAaE+E+kGL9Farmm0R5lz2xF5CKuUu3ksOYROPfjX6AEyOPs4zRy/ErGCtR4H3zkUqE1X2RbHo6Y18xSn3ZdQCGsczz2XlaoZGr01J+o14yNy9lMlRdFttwAxoUE8Zj5fS+tWolgJ/1jrA43YPpco35KG3oYLL6sRfUQpMFp01ibuo6+BOFkr0ly+by/ASkWC80dEwnOercKMUPlYY8F61Fcma4OrZci3jioUxfPQz0Yz20uQxCih43S0xoDSLbD78UiFlfMg3CiL2Al8XMVsbNF6atMi45H7AC4M1GyZPJlt7TSZIeSUefYXgHCOKci7KUhdfGZ+zOSziwx2KhDHY2zc2vV/txH/rPyw09S3A3U6PpzLYJKC7r4B2T
 cRSEbGeW
 G7j4cdJRci+2rTTiGU4zkZTo8UwcMUrq8gvmMYn/0/zGf3B1msUOIXfGd5dCXV47imFioeobQAjV+EJhEVJsN9tJlmIKVX9i0Jcvp+yP9ZpV0FrFqFF+PYH26KMOAoIlZV4oTQnt7gf7ryWGFVzbUmMQpVBmUfmyR25ACVQL+My4ICF0bzloSheyWLXvpTEezlYedZqzgS3TT8Qwe6RlYIrkSEEXD1MLqGPMl+9nxrRjscYgJFXh1ZNTwAxi8TI/cqImCSyTK60ELzfH6e+v7mHhzy0RtO0NK4+yisz+7geP062ylJaeQlVHJ5Xpi4O9xTnukxICmu+zBCtvF+rDIlCdyRKxlFIwE9J5JHh6mVoR73myOXHdCPgyWjxxf2hGw9T6H2sqdb4IXF865cnZyv5hzOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Baolin,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Baolin-Wang/mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end/20261112-191239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang%40linux.alibaba.com
patch subject: [PATCH] mm: mglru: use pte_table_clamped_end() helper to calculate the end
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20261114/202611140137.58xBD8xH-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261114/202611140137.58xBD8xH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611140137.58xBD8xH-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/vmscan.c: In function 'lru_gen_look_around':
>> mm/vmscan.c:4343:15: error: implicit declaration of function 'pte_table_clamped_end' [-Wimplicit-function-declaration]
    4343 |         end = pte_table_clamped_end(addr, vma->vm_end);
         |               ^~~~~~~~~~~~~~~~~~~~~


vim +/pte_table_clamped_end +4343 mm/vmscan.c

  4296	
  4297	/******************************************************************************
  4298	 *                          rmap/PT walk feedback
  4299	 ******************************************************************************/
  4300	
  4301	/*
  4302	 * This function exploits spatial locality when shrink_folio_list() walks the
  4303	 * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
  4304	 * the scan was done cacheline efficiently, it adds the PMD entry pointing to
  4305	 * the PTE table to the Bloom filter. This forms a feedback loop between the
  4306	 * eviction and the aging.
  4307	 */
  4308	bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
  4309	{
  4310		int i;
  4311		bool dirty;
  4312		unsigned long start;
  4313		unsigned long end;
  4314		struct lru_gen_mm_walk *walk;
  4315		struct folio *last = NULL;
  4316		int young = nr;
  4317		pte_t *pte = pvmw->pte;
  4318		unsigned long addr = pvmw->address;
  4319		struct vm_area_struct *vma = pvmw->vma;
  4320		struct folio *folio = pfn_folio(pvmw->pfn);
  4321		struct mem_cgroup *memcg;
  4322		struct pglist_data *pgdat = folio_pgdat(folio);
  4323		struct lruvec *lruvec;
  4324		struct lru_gen_mm_state *mm_state;
  4325	
  4326		lockdep_assert_held(pvmw->ptl);
  4327		VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
  4328	
  4329		if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
  4330			return false;
  4331	
  4332		if (spin_is_contended(pvmw->ptl))
  4333			return true;
  4334	
  4335		/* exclude non-mm-backed VMAs containing anon pages from COW */
  4336		if (!vma_is_mm_backed(vma))
  4337			return true;
  4338	
  4339		/* avoid taking the LRU lock under the PTL when possible */
  4340		walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
  4341	
  4342		start = max(addr & PMD_MASK, vma->vm_start);
> 4343		end = pte_table_clamped_end(addr, vma->vm_end);
  4344	
  4345		if (end - start == PAGE_SIZE)
  4346			return true;
  4347	
  4348		if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
  4349			if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4350				end = start + MIN_LRU_BATCH * PAGE_SIZE;
  4351			else if (end - addr < MIN_LRU_BATCH * PAGE_SIZE / 2)
  4352				start = end - MIN_LRU_BATCH * PAGE_SIZE;
  4353			else {
  4354				start = addr - MIN_LRU_BATCH * PAGE_SIZE / 2;
  4355				end = addr + MIN_LRU_BATCH * PAGE_SIZE / 2;
  4356			}
  4357		}
  4358	
  4359		memcg = get_mem_cgroup_from_folio(folio);
  4360		lruvec = mem_cgroup_lruvec(memcg, pgdat);
  4361		mm_state = get_mm_state(lruvec);
  4362	
  4363		lazy_mmu_mode_enable();
  4364	
  4365		pte -= (addr - start) / PAGE_SIZE;
  4366	
  4367		for (i = 0, addr = start; addr != end;
  4368		     i += nr, pte += nr, addr += nr * PAGE_SIZE) {
  4369			unsigned long pfn;
  4370			pte_t ptent = ptep_get(pte);
  4371	
  4372			nr = 1;
  4373			pfn = get_pte_pfn(ptent, vma, addr, pgdat);
  4374			if (pfn == -1)
  4375				continue;
  4376	
  4377			folio = get_pfn_folio(pfn, memcg, pgdat);
  4378			if (!folio)
  4379				continue;
  4380	
  4381			if (folio_test_large(folio)) {
  4382				const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
  4383	
  4384				nr = folio_pte_batch_flags(folio, NULL, pte, &ptent,
  4385							   max_nr, FPB_MERGE_YOUNG_DIRTY);
  4386			}
  4387	
  4388			if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
  4389				continue;
  4390	
  4391			if (last != folio) {
  4392				walk_update_folio(walk, vma, lruvec, last, dirty);
  4393	
  4394				last = folio;
  4395				dirty = false;
  4396			}
  4397	
  4398			if (pte_dirty(ptent))
  4399				dirty = true;
  4400	
  4401			young += nr;
  4402		}
  4403	
  4404		walk_update_folio(walk, vma, lruvec, last, dirty);
  4405	
  4406		lazy_mmu_mode_disable();
  4407	
  4408		/* feedback from rmap walkers to page table walkers */
  4409		if (mm_state && suitable_to_scan(i, young))
  4410			update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
  4411					    pvmw->pmd);
  4412	
  4413		mem_cgroup_put(memcg);
  4414	
  4415		return true;
  4416	}
  4417	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

