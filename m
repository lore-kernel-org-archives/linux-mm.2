Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA93CE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929858E0023; Fri, 14 Nov 2025 21:15:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1638E0005; Fri, 14 Nov 2025 21:15:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752548E0023; Fri, 14 Nov 2025 21:15:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3C88E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:15:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D2F214061A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:15:18 +0000 (UTC)
X-FDA: 84111224316.17.5BDA9A0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C30A40011
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:15:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NofrH2tt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763172916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6dNB6WwGbKoSscMWTgrpPCf+7SCb9brxRUxxpFeqMU=;
	b=AroCBTT9gFZl09fYthsDDgNC8HLLRTKMFmCO2UpdQyoGh/MnqCOaUWqt/eOlpDqWKdCma7
	WkmheDKjfML5RoWZx+7miw0KfYUMYCI6XEmm8YsLOS7F2gY+aQqj2q6CtqRkJBzvC68U2/
	lWvpbCysmuq+liygHLelHAf8LST07UM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763172916; a=rsa-sha256;
	cv=none;
	b=d/mL+tPg7nS17AWN0pXJaw4GvVEx30/F8iqpH/83FEniLlQQORt7Qhk95HY7y3UhlZKSXi
	WGWsIDqiSsWN3OkpzqrIzKsBVyHQUh/0TNXR2aGW4LcdtHSuBmsvW7e2PORCGOmdYcCm/l
	a0TVJjUc0r9HIUNM0INigJAKpLDfqPc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NofrH2tt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763172916; x=1794708916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fGFz8KquUr9jWQ4PCrcIGmqO/oRWoxlOLT9O5ngcD/A=;
  b=NofrH2ttvM9q7f3oCuFH7ASDX5gXDFoZ4HhAlXyu0LM2gRsNBz8hR4k0
   gSrXVgylKdKQWJU6/0WUkkJUy7iSJWdEG+ltglePcEEJQw3Nj/YY8FDge
   Y/ACIFkK2eHenEe02tzl3fl55+quhJ/xGwtxwhQsZHmaHvY23UiHS2uLs
   lt71c2Me/LsTht0l6z9gJYK+8ThI5eGWFZU7/Y/IR/qm91VVTNMi9o3GD
   dtzT4kNlrhOwZM5nmTx4DUFNBeG9JtgNzgZHkYvJr886UAb3Q9TZVetwq
   57eTzBXw+D2Y6D7VmBkDuOJoQNynePmlIZ7+4pkBZmWUCun25gOUETMqr
   g==;
X-CSE-ConnectionGUID: WFuPrs6HSn6hP179xr+DIg==
X-CSE-MsgGUID: EAsdZzXcTT+G9U4feyM+aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65301100"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="65301100"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 18:15:14 -0800
X-CSE-ConnectionGUID: rFi/DoFJRDmKn3VYj9QzCg==
X-CSE-MsgGUID: jDK/OEUFRFy+dZH4vzUDtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="189574133"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 14 Nov 2025 18:15:07 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vK5oe-0007eJ-2j;
	Sat, 15 Nov 2025 02:15:04 +0000
Date: Sat, 15 Nov 2025 10:15:02 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Message-ID: <202511151007.F1gixfc8-lkp@intel.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114012228.2634882-1-balbirs@nvidia.com>
X-Stat-Signature: 9dnjbekaczp8ud7kb5migmsrnnjqd5bu
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C30A40011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763172915-732525
X-HE-Meta: U2FsdGVkX1/x+tp4z/mF2cNpv1TFpTd4FVgmR5xySX6LVoD0DOoRfwMY/8c6pmZr6svagug8p6lRVURXjH3ZYlfP94W3wiMgwdtsBm1dRxq4rFmsqgRjXdZSZrZbhcFW6Z1XaDph4hpcCrNEwNeU+RPCEvpPHQ2QiZ/Bj3TWl4yfd7iyyEy7cflA/IIQx0umN7gRrVmaKUTjbUDi0ehBCNwQisTGjHrLHoYlTBrZoGLccz7QuWZJBRNDPmAY1h+x0lY2J0Joz6wYwJCCTUVaiWqkAsoOPBw3UoOHoeX4tj6ilgP/PMHsv60bh3zNeuf2CGunYbGAEYtu1LOXfsgyp1ulXnq4zQdYdXkXRpYu6OMiv6pT4T+qYjRMUe+VN5hekHVczupwWZsnbeoBOLShBEjG6v1phDmzM/ml53SLU3fxDxa5wnn9B/gY3YdTdumR1nxj4XGvm1BXZ1w4LQhC2L9Y0nccRhh1oLOsOtm8pde2KlkFGIwoun2MDqSoPM29nYhTeg49EyTBa4N9XfUA0GZl/XBLDSbZxwqscTqbnsVRdxvd7gZ1O1v+KbXtH05/jcKyh3en/dX7y0QbQH/aazyQukBgB3O2CrpjQKUVlDCMjQaVvNp7zQH7C8ynAV62JemNF0NHrwk1hmamBUbfun3kVa/9YYE2Ruo0T2JfXvfgO7g7HtpIjEJS+HHHLblY5J5TLDvU82vE8MSyeqQNquckMKEKahx+zwBVuP2UMTbNsoA8UWin+iQYPWgGPPpFGm1+yVAZ42Z65XdAZa9pZwzX+uZlK+qzeXvneaM6pVhI2A6vCi0VAolA2DUxARgNKWtj5VZ4TN8Ta0wyACJMGriJyWwp9S/5HLs/895adQPPqjEUc4UeTJ0wNfHA9mfflCBJXKg9yG37qvjBzhLxEYo7zGvYjOdcGBRO/OX+nHi8b2OqtGrw4r3n0Z+91bTSA+yKkAmN5qoWm1RJzFj
 kc717SmR
 QW9+zRpMrKq3wNKPqFVwm10VPxTGXDSOE+voPjwAHOpNcunOGHIT5lH8i2sMK9gZR1/n5Lj3URAakCZrdr7c7GzsXkpp2snEdFntGthcnjWsObaVEDaE61PToOLQwryKugs1xO7XXGxJJcNcnPl5oJGekwPjZNSv3cUjcaz/RrOBkBtP6Q5Btl00hCe928oy0fo+2u5KgMyEN7nwrhZZcp3WwpJdBEX9RpxP/2e4qk1MVfVAFsqMxIrZ/+AlAvOCLnw+df/MKtCy3JlO54gyx/KSe8KNCegV/vcXBKPkZvdmjMPf1SiI/N1/VUA2zvXubNPMot2UQ6f5DLIKYDoQsXCQ3ar0E5B2WnonjP48rfe+NSYpUD9wTE7Q8ARBvJf5oFo8qG9qSC2q8KYmI0BQLVE37SGTrZ+jS1fhPlx048UdxFs4+tSiXrtaYLK3yYxQohTMb1gZ2ELqf+90LXRYzLMrUTw==
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

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-huge_memory-c-introduce-folio_split_unmapped/20251114-093541
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251114012228.2634882-1-balbirs%40nvidia.com
patch subject: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
config: arm64-randconfig-002-20251115 (https://download.01.org/0day-ci/archive/20251115/202511151007.F1gixfc8-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511151007.F1gixfc8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511151007.F1gixfc8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/huge_memory.c:3751:6: warning: variable 'nr_shmem_dropped' set but not used [-Wunused-but-set-variable]
    3751 |         int nr_shmem_dropped = 0;
         |             ^
   1 warning generated.


vim +/nr_shmem_dropped +3751 mm/huge_memory.c

  3741	
  3742	static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
  3743						     struct page *split_at, struct xa_state *xas,
  3744						     struct address_space *mapping, bool do_lru,
  3745						     struct list_head *list, enum split_type split_type,
  3746						     pgoff_t end, int extra_pins)
  3747	{
  3748		struct folio *end_folio = folio_next(folio);
  3749		struct folio *new_folio, *next;
  3750		int old_order = folio_order(folio);
> 3751		int nr_shmem_dropped = 0;
  3752		int ret = 0;
  3753		struct deferred_split *ds_queue;
  3754	
  3755		/* Prevent deferred_split_scan() touching ->_refcount */
  3756		ds_queue = folio_split_queue_lock(folio);
  3757		if (folio_ref_freeze(folio, 1 + extra_pins)) {
  3758			struct swap_cluster_info *ci = NULL;
  3759			struct lruvec *lruvec;
  3760			int expected_refs;
  3761	
  3762			if (old_order > 1) {
  3763				if (!list_empty(&folio->_deferred_list)) {
  3764					ds_queue->split_queue_len--;
  3765					/*
  3766					 * Reinitialize page_deferred_list after removing the
  3767					 * page from the split_queue, otherwise a subsequent
  3768					 * split will see list corruption when checking the
  3769					 * page_deferred_list.
  3770					 */
  3771					list_del_init(&folio->_deferred_list);
  3772				}
  3773				if (folio_test_partially_mapped(folio)) {
  3774					folio_clear_partially_mapped(folio);
  3775					mod_mthp_stat(old_order,
  3776						MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
  3777				}
  3778			}
  3779			split_queue_unlock(ds_queue);
  3780			if (mapping) {
  3781				int nr = folio_nr_pages(folio);
  3782	
  3783				if (folio_test_pmd_mappable(folio) &&
  3784				    new_order < HPAGE_PMD_ORDER) {
  3785					if (folio_test_swapbacked(folio)) {
  3786						__lruvec_stat_mod_folio(folio,
  3787								NR_SHMEM_THPS, -nr);
  3788					} else {
  3789						__lruvec_stat_mod_folio(folio,
  3790								NR_FILE_THPS, -nr);
  3791						filemap_nr_thps_dec(mapping);
  3792					}
  3793				}
  3794			}
  3795	
  3796			if (folio_test_swapcache(folio)) {
  3797				if (mapping) {
  3798					VM_WARN_ON_ONCE_FOLIO(mapping, folio);
  3799					return -EINVAL;
  3800				}
  3801	
  3802				ci = swap_cluster_get_and_lock(folio);
  3803			}
  3804	
  3805			/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
  3806			if (do_lru)
  3807				lruvec = folio_lruvec_lock(folio);
  3808	
  3809			ret = __split_unmapped_folio(folio, new_order, split_at, xas,
  3810						     mapping, split_type);
  3811	
  3812			/*
  3813			 * Unfreeze after-split folios and put them back to the right
  3814			 * list. @folio should be kept frozon until page cache
  3815			 * entries are updated with all the other after-split folios
  3816			 * to prevent others seeing stale page cache entries.
  3817			 * As a result, new_folio starts from the next folio of
  3818			 * @folio.
  3819			 */
  3820			for (new_folio = folio_next(folio); new_folio != end_folio;
  3821			     new_folio = next) {
  3822				unsigned long nr_pages = folio_nr_pages(new_folio);
  3823	
  3824				next = folio_next(new_folio);
  3825	
  3826				zone_device_private_split_cb(folio, new_folio);
  3827	
  3828				expected_refs = folio_expected_ref_count(new_folio) + 1;
  3829				folio_ref_unfreeze(new_folio, expected_refs);
  3830	
  3831				if (do_lru)
  3832					lru_add_split_folio(folio, new_folio, lruvec, list);
  3833	
  3834				/*
  3835				 * Anonymous folio with swap cache.
  3836				 * NOTE: shmem in swap cache is not supported yet.
  3837				 */
  3838				if (ci) {
  3839					__swap_cache_replace_folio(ci, folio, new_folio);
  3840					continue;
  3841				}
  3842	
  3843				/* Anonymous folio without swap cache */
  3844				if (!mapping)
  3845					continue;
  3846	
  3847				/* Add the new folio to the page cache. */
  3848				if (new_folio->index < end) {
  3849					__xa_store(&mapping->i_pages, new_folio->index,
  3850						   new_folio, 0);
  3851					continue;
  3852				}
  3853	
  3854				/* Drop folio beyond EOF: ->index >= end */
  3855				if (shmem_mapping(mapping))
  3856					nr_shmem_dropped += nr_pages;
  3857				else if (folio_test_clear_dirty(new_folio))
  3858					folio_account_cleaned(
  3859						new_folio, inode_to_wb(mapping->host));
  3860				__filemap_remove_folio(new_folio, NULL);
  3861				folio_put_refs(new_folio, nr_pages);
  3862			}
  3863	
  3864			zone_device_private_split_cb(folio, NULL);
  3865			/*
  3866			 * Unfreeze @folio only after all page cache entries, which
  3867			 * used to point to it, have been updated with new folios.
  3868			 * Otherwise, a parallel folio_try_get() can grab @folio
  3869			 * and its caller can see stale page cache entries.
  3870			 */
  3871			expected_refs = folio_expected_ref_count(folio) + 1;
  3872			folio_ref_unfreeze(folio, expected_refs);
  3873	
  3874			if (do_lru)
  3875				unlock_page_lruvec(lruvec);
  3876	
  3877			if (ci)
  3878				swap_cluster_unlock(ci);
  3879		} else {
  3880			split_queue_unlock(ds_queue);
  3881			return -EAGAIN;
  3882		}
  3883	
  3884		return ret;
  3885	}
  3886	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

