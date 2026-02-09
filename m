Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744C3EF0702
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 02:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68B96B0005; Sun,  8 Feb 2026 21:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16AC6B0088; Sun,  8 Feb 2026 21:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15676B0089; Sun,  8 Feb 2026 21:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0FA6B0005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:22:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40378C237F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:22:44 +0000 (UTC)
X-FDA: 84423319848.01.01CEC10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76F86100005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:22:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TvbO0IvA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770603762; a=rsa-sha256;
	cv=none;
	b=y8sg8Vn5aixKJiRprunZX+7pNrtwwY5Lzl57062OmbziFSkA3ls/IqO9X1XQJw2nybo42M
	/uCR6+XNUssLbMeJiy9NUKjNsG1TKHosi09sAl8NcsV2IPOfnVO+q5BUkH9g+4A2ABpAdx
	ioNnK7kdvjAqWSWSDDz2DSS+gnF3M80=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TvbO0IvA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770603762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hho5ZHqwJ0L55u8OmQdhmKMZ90IOrlRmAxbrTbbSy7Q=;
	b=QEZmPalgw+gXSxCefo4wXggSfn994jZC2oIm6cZnLirev+5r0N3DDFJ/90Qzyw0s5ZxZya
	w2LKP9OrWOmRrzdWlwgpHbP7423NMA08g/vugrTA7U9uRNaw6obUom+kDFOFSnVvnG9b/w
	p/JUD18VoCJZB/iy199QwQ/HYTeJbbo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770603762; x=1802139762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lN29YV+zBAydXqnE2rZS6mvynhrdF/TkVSR0zGXivNw=;
  b=TvbO0IvA0qUnAdzmDjqbEzn0bQt6suU/vH/TrHeCmm7IERkc3LS9NG2R
   I06kmY1UKS25i+ofS6j/4E6f2nGgT5lraJtbPHvbWZAJksteICCd9ZL2v
   Ash5q8F5rw97Mbt6Yn3robTbnAqTtVc8W+b62QkYV4ko/4b4WhbwN7kbQ
   xnX9qkfwJ3mzblloNdOHjgkVXWRxk8MUj4/HVV9LZ9rzpTSxX/6mHFMOG
   iQVdhdn5FZ0aAW23K8QoHJBvIKtCGn+uDLRQWzkL4hC8pqQjm/TIAFg/M
   muOgh1WWRYL41EkxCJg2Z9HZcMvqMdHQBx3Ui77My/NTC5s+/V2xhOYVf
   A==;
X-CSE-ConnectionGUID: H6HSgeEWTj2p9QG5+OHQKQ==
X-CSE-MsgGUID: D44jDXb2T9ummXTPQ96PsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="97170089"
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="97170089"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2026 18:22:40 -0800
X-CSE-ConnectionGUID: CJ2DLclWQsCDNhy6DDl/HQ==
X-CSE-MsgGUID: WlgPUJxwRzOOIAmFmBzJ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="241664631"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 08 Feb 2026 18:22:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpGv1-00000000mVw-0scF;
	Mon, 09 Feb 2026 02:22:31 +0000
Date: Mon, 9 Feb 2026 10:22:28 +0800
From: kernel test robot <lkp@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com,
	yosry.ahmed@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 01/20] mm/swap: decouple swap cache from physical swap
 infrastructure
Message-ID: <202602091044.soVrWeDA-lkp@intel.com>
References: <20260208215839.87595-2-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-2-nphamcs@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76F86100005
X-Stat-Signature: b8at5p3opn4kckwqeakup587ck7kp8tj
X-HE-Tag: 1770603761-562648
X-HE-Meta: U2FsdGVkX1/zsLaXy4fr8pHyq4KMfq3ozsUMwR6xQdDbZ8CKmJcrINsVW/TQFjBhPiiDQE3Ftg2LaXI4BV4lVYr5J8nFtmQufQ49qVtuGD+afIEUDVfYboC+odzVSSewl1eNdo3imql/dgF8r10Tf/NapGcg9uiK8XV5azGpg368XlIMC9zcZqTrrZp21nIhKt4UmZRA+kUyjQA1YweLd32rp0G3hnX7ugRLohVHMy/NAGkxA4x+27GUKXhaaNg34sJcEF16LzH+l1ParcDzN5FYDtSEsZbyngeGfoLu8+7ClpUq4BOagMEN5F8tI5YsfTp3+LTlrG2sR2hF0DLUx+BE8xDaKRhLE6MZk8BtrlMnQh+LDaQEnwG/hLcUNNdBTeXylzQo0bmwoo+bFSiF2X5Kf62wsnxegHeKXlr86+7jwbJrgWNgi0GVggkIQESsk5DDPqtf7sRhIw7vEy/2qZw8e9p79TQaa/zloC25aisajZFIn94qj0BQgyO4glLT/cztnOF5s5m9SNzhj988AWilpeAT5A2bg4/NATNGkNkBjeAGMHCLRAMD/h9fyQPCnRGjTSwhY9oEDZRuUI7jon+6YUXxL1cy20dq6f/NPhbcOuOy2KxsizFJ/B7o+qO/ccyqjya+e2zvvbxFq3UsHWBtWPsl+feiWAvheE31bq5aLv+lG7esc9R6V/fY/aQNQvu3lptZ7k3IRtWpFe5IADFpH53/kJflzk7eLAdqyfT+y2lBZfrlbfQvAx1U6QG8UPYHGxGqxzfMBb2zjXMWjjFCxP44XHEeO03Fnw6+s/bdOxuWZwXVjqd7htgaJWppMmrTY23lmoN/yCrnq7dv7lbVPZ9SvwOD4xevNK7Es45hoTIxwK526Idt6ZaRFr08XIM+E5oYTJpyqBJZAZT0AtKe8qai7j5DWDCOEK7umBonJUlyTpZatB6w9hKeXUuUrwM/Jdv1YwhRBcdY5XW
 LHp1zdqy
 ga80AQQ0167FpnMtzrMRr21hQE/CgZHNgPDnVjgEbHBGA9wfHAQn3QUEul/VFB1r7gDSekawYzy6o/XIkHDA1sxB4RFY3HMm8Izynix7pB1BvMpytO257G9Ni3ooikih9Bo/JkYEfQGzumdKYmUWalC1wXlgw4kAtNFwl/lA+1yC03CzqipyWGgVYB6r1jllvW/euYI+vqAqVJO2Rt5d501nJDNPKKq7holcyStawc1d6AgMaBVwZAmJgAfOETgXQsbk8b/XbbGdM9yhCjIWKop3HUbcK+TLD2unaBXLVEcWI2QEcDoX11eF9oSiC3yIrPsM5PuuDa/MjyLch7T2PS/GvgpVsxqH2E5kFJv6Q+s07D4NtEzCqRDMaPOFyp2IHeaX0rHnKgxbYzf59BAJlLzSOMl1XBPI1IavT/XG6kZyJpSyyT0JmeOcMYxNV40eejXvI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next tip/smp/core next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/swap-rearrange-the-swap-header-file/20260209-065842
base:   linus/master
patch link:    https://lore.kernel.org/r/20260208215839.87595-2-nphamcs%40gmail.com
patch subject: [PATCH v3 01/20] mm/swap: decouple swap cache from physical swap infrastructure
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260209/202602091044.soVrWeDA-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260209/202602091044.soVrWeDA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602091044.soVrWeDA-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vmscan.c:715:3: error: call to undeclared function 'swap_cache_lock_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     715 |                 swap_cache_lock_irq();
         |                 ^
>> mm/vmscan.c:762:3: error: call to undeclared function 'swap_cache_unlock_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     762 |                 swap_cache_unlock_irq();
         |                 ^
   mm/vmscan.c:762:3: note: did you mean 'swap_cluster_unlock_irq'?
   mm/swap.h:350:20: note: 'swap_cluster_unlock_irq' declared here
     350 | static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
         |                    ^
   mm/vmscan.c:801:3: error: call to undeclared function 'swap_cache_unlock_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     801 |                 swap_cache_unlock_irq();
         |                 ^
   3 errors generated.
--
>> mm/shmem.c:2168:2: error: call to undeclared function 'swap_cache_lock_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2168 |         swap_cache_lock_irq();
         |         ^
>> mm/shmem.c:2173:2: error: call to undeclared function 'swap_cache_unlock_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2173 |         swap_cache_unlock_irq();
         |         ^
   2 errors generated.


vim +/swap_cache_lock_irq +715 mm/vmscan.c

   700	
   701	/*
   702	 * Same as remove_mapping, but if the folio is removed from the mapping, it
   703	 * gets returned with a refcount of 0.
   704	 */
   705	static int __remove_mapping(struct address_space *mapping, struct folio *folio,
   706				    bool reclaimed, struct mem_cgroup *target_memcg)
   707	{
   708		int refcount;
   709		void *shadow = NULL;
   710	
   711		BUG_ON(!folio_test_locked(folio));
   712		BUG_ON(mapping != folio_mapping(folio));
   713	
   714		if (folio_test_swapcache(folio)) {
 > 715			swap_cache_lock_irq();
   716		} else {
   717			spin_lock(&mapping->host->i_lock);
   718			xa_lock_irq(&mapping->i_pages);
   719		}
   720	
   721		/*
   722		 * The non racy check for a busy folio.
   723		 *
   724		 * Must be careful with the order of the tests. When someone has
   725		 * a ref to the folio, it may be possible that they dirty it then
   726		 * drop the reference. So if the dirty flag is tested before the
   727		 * refcount here, then the following race may occur:
   728		 *
   729		 * get_user_pages(&page);
   730		 * [user mapping goes away]
   731		 * write_to(page);
   732		 *				!folio_test_dirty(folio)    [good]
   733		 * folio_set_dirty(folio);
   734		 * folio_put(folio);
   735		 *				!refcount(folio)   [good, discard it]
   736		 *
   737		 * [oops, our write_to data is lost]
   738		 *
   739		 * Reversing the order of the tests ensures such a situation cannot
   740		 * escape unnoticed. The smp_rmb is needed to ensure the folio->flags
   741		 * load is not satisfied before that of folio->_refcount.
   742		 *
   743		 * Note that if the dirty flag is always set via folio_mark_dirty,
   744		 * and thus under the i_pages lock, then this ordering is not required.
   745		 */
   746		refcount = 1 + folio_nr_pages(folio);
   747		if (!folio_ref_freeze(folio, refcount))
   748			goto cannot_free;
   749		/* note: atomic_cmpxchg in folio_ref_freeze provides the smp_rmb */
   750		if (unlikely(folio_test_dirty(folio))) {
   751			folio_ref_unfreeze(folio, refcount);
   752			goto cannot_free;
   753		}
   754	
   755		if (folio_test_swapcache(folio)) {
   756			swp_entry_t swap = folio->swap;
   757	
   758			if (reclaimed && !mapping_exiting(mapping))
   759				shadow = workingset_eviction(folio, target_memcg);
   760			__swap_cache_del_folio(folio, swap, shadow);
   761			memcg1_swapout(folio, swap);
 > 762			swap_cache_unlock_irq();
   763			put_swap_folio(folio, swap);
   764		} else {
   765			void (*free_folio)(struct folio *);
   766	
   767			free_folio = mapping->a_ops->free_folio;
   768			/*
   769			 * Remember a shadow entry for reclaimed file cache in
   770			 * order to detect refaults, thus thrashing, later on.
   771			 *
   772			 * But don't store shadows in an address space that is
   773			 * already exiting.  This is not just an optimization,
   774			 * inode reclaim needs to empty out the radix tree or
   775			 * the nodes are lost.  Don't plant shadows behind its
   776			 * back.
   777			 *
   778			 * We also don't store shadows for DAX mappings because the
   779			 * only page cache folios found in these are zero pages
   780			 * covering holes, and because we don't want to mix DAX
   781			 * exceptional entries and shadow exceptional entries in the
   782			 * same address_space.
   783			 */
   784			if (reclaimed && folio_is_file_lru(folio) &&
   785			    !mapping_exiting(mapping) && !dax_mapping(mapping))
   786				shadow = workingset_eviction(folio, target_memcg);
   787			__filemap_remove_folio(folio, shadow);
   788			xa_unlock_irq(&mapping->i_pages);
   789			if (mapping_shrinkable(mapping))
   790				inode_lru_list_add(mapping->host);
   791			spin_unlock(&mapping->host->i_lock);
   792	
   793			if (free_folio)
   794				free_folio(folio);
   795		}
   796	
   797		return 1;
   798	
   799	cannot_free:
   800		if (folio_test_swapcache(folio)) {
   801			swap_cache_unlock_irq();
   802		} else {
   803			xa_unlock_irq(&mapping->i_pages);
   804			spin_unlock(&mapping->host->i_lock);
   805		}
   806		return 0;
   807	}
   808	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

