Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E84CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28876B0093; Thu, 28 May 2026 04:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9206B0096; Thu, 28 May 2026 04:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8576B0098; Thu, 28 May 2026 04:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD43B6B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:16:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 778C4161E30
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:16:11 +0000 (UTC)
X-FDA: 84816120942.27.6520D40
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5132618000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:16:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XCFjK/ce";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=D4c3/5RQxXTp1KQvpSUjHm1N97EGHk0UKwWcGeKWLdA=;
	b=kf5Hok3t08RN0HncudI27tEQS7OoU+woOj7gVqY2klFYuup+eaDCTUTUEWh2LRi4G13nvK
	wwc5XM58iXrazpcjug5EAfwE2JE8PaYUAlZ2SxtiQvZAfiU632k4ETPKP/E1aWkSFEr9no
	fDkrPVTKR9bt5NyR3HaZFMAIQDsh5K8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XCFjK/ce";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956169; a=rsa-sha256;
	cv=none;
	b=2gXQteuhAsYldP11UJtG2n1HpfyMMqjzSUzlVUnd+byNeUWM0w7+wDTzzf1SqAD73baGHn
	whmlWZ6upRj9OK1xw6ELMNbxgLwVIfge1TG2qlIER+3sQJfkUftg57Zze9NXD4pdbOisdF
	hE/ViIXQxzPL24g58mLjhxXv953EtEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779956168; x=1811492168;
  h=date:from:to:cc:subject:message-id;
  bh=XRG8W9NAHc+HbEyj0+UtCgt+HhS+ZeeZXcAuoLpSGFE=;
  b=XCFjK/cexRykblr7DP4kPPQ+1nquhkzJcmlQX91BiBG9TG+ocUh7wtX7
   3Oh3kqww1/lI/3hA/oyYnoApi28izygI7PwOEqR/Gk6HR/YyKxybaaknO
   OQVXecv+BFuF+3ZyxXeI1sJdGr51OD2bM5Re9AQsgFWRJ4A5WnRJ5LkA5
   LnkrTqh/fnQZ1bGhzckj2byKfziDlUKrbAOzMThDNMoC/zgMn38xXylCr
   hhI4zp1coW1tVi/bS9UCvjV2h16Qo6FOQJvtRv2zMJwxcDkJcLmrX0YLe
   MNkTQaNTqZCTCBBpHGUqAekAhEYjOgad6OG4abI+CNLrbyadYNc6m1hvb
   Q==;
X-CSE-ConnectionGUID: d3ABU7D+R9izLdnzFuMzMg==
X-CSE-MsgGUID: e6i3yfPyTVK+HtRtfH2IPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80520121"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80520121"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 01:16:07 -0700
X-CSE-ConnectionGUID: 91NmiBW4RE2ttYlQlBmu7g==
X-CSE-MsgGUID: 7247Q2d1SaOkJYI760tmCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="266088107"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 28 May 2026 01:16:04 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSVuL-000000005j0-3mpc;
	Thu, 28 May 2026 08:16:01 +0000
Date: Thu, 28 May 2026 16:15:31 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call
 to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202605281620.lc3rtkBm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: nsrua6qou6d94du8z5x9cueg74feqz1n
X-Rspamd-Queue-Id: 5132618000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779956168-543093
X-HE-Meta: U2FsdGVkX1+xbSbw5BnYcydlnwR3ss1btEsMcpxpNWAK18aE7ALUhB8u1se72aexGejwNBK2z2vEXcpHkkEgHWrQduz0uzeOwKx2oZW59//wa+9TOn2EbhRhdft7u7g65Xo6zrl5KSz6bhky6Tws4vTpTGzmf49OEur5A30z/WzOaUbmSX4kyRTSOqLoaHTkclZhbSgI4fwRXVPtDFfNUNsLJdgsup24+hS1NRSmO/uVhaoUOlcVK/gWDOeVWCziBCCWyznd8wZwj7YOCYb+iK1gavrfBYT1X97wE2TaoSdpZY/51BsnOZWtC5Zi7Gzfwxdqho9jYnBo+ECqQ/kjpzBDgoNnJpl0kaQryV31S3M5mmi2uCNs8+ZraBL6FCPLoHNGO7/C9wSolTqTbcKLn5QqipSW0fVE8kFfEaxtIyFTTEarWyx6apSta+ICmsKlxCt1YESGu/zpCsuSskJNVQbruTbdraJ96wears8lL1JM2aVo15v9XUpgqGoP3JpfQUWXEbAaI7tcEu/JE5VFNUvw/7vwri3kFDkAU+VXrBJuZVIGftWZKaZKDA+aZHGDAfQ7kzp2GAiUFBao4PV0jLz02JrUSlA4UCyXeTeD9Yw5m2ocgNvkT2yvLmmo/3A5ymQ504SpHesOfVgQXt2tYXo5/XS80DyxjmsOVfUXuQf4SJPHCic89ig7CvoXHR9jau3/OCf0khRIjIf4lFa1dPu2gUQqOxpCMJ1TUeVd/JFkCJbE2sFm6P8l4Vqcv+oYR7yF1y1s/ms+RtHFUFiCwB6immKMRgQtxd8hFvdqf2eSQYUlK/d86BJv8ZsAkVDMXIo3JXxFGTWIFZAFnQx/bP/H3kKBL8RII2fO0iJzrS2wD8viEPuvEdxdpwly4bErLDuirtJkajCuOojFhHQMDTb1Tdj9whFM6ewiJvlM3OheRKQgW15pctXa4R7Eo/AA4/xBJKultmS6G3Ks1+Z
 C96Py/NV
 ao4gPlXj0hNeFYHeU9wSeRpFeeKz3s98hfOMQU6moMsL7bdarHDVygtYVebPa/cuMZ/tQXBl4kLRAtKcu0CRjz4solybCDfXsrHYnhVE8O2Dqq33sutnlsayo02yIYnYGiuOCBf2XLacYctCaFciA0ucQAR1NUnvDk8OQZGuWJDRd59E0s1WD/407Oi1/OdnaZk4oFfQPPs6WQ+z2khqY0g0doDHmnraVjXsmhTjNp7RRgeXpFWf1qglekYjJy8yfGh1wrRdK6zAgl7vSbc56wBluqhJ0X1A5HKXULTUiCxsa6inh2VunvjaGZ9dIplRXy+xe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
         |                          ^
   1 error generated.


vim +/folio_memcg_alloc_deferred +468 mm/swap_state.c

   390	
   391	/*
   392	 * Try to allocate a folio of given order in the swap cache.
   393	 *
   394	 * This helper resolves the potential races of swap allocation
   395	 * and prepares a folio to be used for swap IO. May return following
   396	 * value:
   397	 *
   398	 * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
   399	 *                   caller should shrink the order and retry
   400	 * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
   401	 *                    should abort or try to use the cached folio instead
   402	 */
   403	static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
   404						swp_entry_t targ_entry, gfp_t gfp,
   405						unsigned int order, struct vm_fault *vmf,
   406						struct mempolicy *mpol, pgoff_t ilx)
   407	{
   408		int err;
   409		swp_entry_t entry;
   410		struct folio *folio;
   411		void *shadow = NULL;
   412		unsigned short memcg_id;
   413		unsigned long address, nr_pages = 1UL << order;
   414		struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
   415	
   416		VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
   417		entry.val = round_down(targ_entry.val, nr_pages);
   418	
   419		/* Check if the slot and range are available, skip allocation if not */
   420		spin_lock(&ci->lock);
   421		err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
   422		spin_unlock(&ci->lock);
   423		if (unlikely(err))
   424			return ERR_PTR(err);
   425	
   426		/*
   427		 * Limit THP gfp. The limitation is a no-op for typical
   428		 * GFP_HIGHUSER_MOVABLE but matters for shmem.
   429		 */
   430		if (order)
   431			gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
   432	
   433		if (mpol || !vmf) {
   434			folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
   435		} else {
   436			address = round_down(vmf->address, PAGE_SIZE << order);
   437			folio = vma_alloc_folio(gfp, order, vmf->vma, address);
   438		}
   439		if (unlikely(!folio))
   440			return ERR_PTR(-ENOMEM);
   441	
   442		/* Double check the range is still not in conflict */
   443		spin_lock(&ci->lock);
   444		err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
   445		if (unlikely(err)) {
   446			spin_unlock(&ci->lock);
   447			folio_put(folio);
   448			return ERR_PTR(err);
   449		}
   450	
   451		__folio_set_locked(folio);
   452		__folio_set_swapbacked(folio);
   453		__swap_cache_do_add_folio(ci, folio, entry);
   454		spin_unlock(&ci->lock);
   455	
   456		if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
   457						   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
   458			spin_lock(&ci->lock);
   459			__swap_cache_do_del_folio(ci, folio, entry, shadow);
   460			spin_unlock(&ci->lock);
   461			folio_unlock(folio);
   462			/* nr_pages refs from swap cache, 1 from allocation */
   463			folio_put_refs(folio, nr_pages + 1);
   464			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
   465			return ERR_PTR(-ENOMEM);
   466		}
   467	
 > 468		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
   469			spin_lock(&ci->lock);
   470			__swap_cache_do_del_folio(ci, folio, entry, shadow);
   471			spin_unlock(&ci->lock);
   472			folio_unlock(folio);
   473			/* nr_pages refs from swap cache, 1 from allocation */
   474			folio_put_refs(folio, nr_pages + 1);
   475			return ERR_PTR(-ENOMEM);
   476		}
   477	
   478		/* memsw uncharges swap when folio is added to swap cache */
   479		memcg1_swapin(folio);
   480		if (shadow)
   481			workingset_refault(folio, shadow);
   482	
   483		node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
   484		lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
   485	
   486		/* Caller will initiate read into locked new_folio */
   487		folio_add_lru(folio);
   488		return folio;
   489	}
   490	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

