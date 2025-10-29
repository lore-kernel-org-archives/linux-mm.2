Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AF8CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366C18E00E1; Wed, 29 Oct 2025 15:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9718E00B2; Wed, 29 Oct 2025 15:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0087F8E00E1; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB5958E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:26:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CD7414082D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:41 +0000 (UTC)
X-FDA: 84052133802.13.A2A524E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2797D16000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:26:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mPeb3YrF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761765999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdgL8CQx13gH4ay2+Y9r3NBlCHXTq8kUyY587BAXvYI=;
	b=bSj2vl10Xc9lr2fbq9ciXdsOfkaAvUv40BkNICbQgo5f5IAknbvvsBLz/WAXA0sFdOI6xc
	bJeqofKewX/AzNtkdHoNy78ZQ3r9R/CVnhjdw6H3Rgos2GS/jdfL3VPLyhqxe931Up6+Mc
	J6LF6CZkcwXoDIHiqDPGvaMIpmX2Mto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761765999; a=rsa-sha256;
	cv=none;
	b=SPZKwD1B1xS9titFOHiKBWWEDKeIWNDpQZ/QuKfWNfVb9Mt5s5xa/FKncgBcbQ6Z8hp0wb
	mXOAGJrEklHVJxq/7s8eIBvy2sTwjI83jxQrDwje9vJwqFKPuH+1wK14YllCtDY7C1RqBg
	k+IG9tKo7oFwwSIiFs8QdTXz0tqgAXk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mPeb3YrF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761765999; x=1793301999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=beMPeGN4MaJT9fWx9tZ7EqmiURgdCSilOmHGU7r1DaQ=;
  b=mPeb3YrFJiUbeQvFH2WQrm7D7Hg8byA3UbBk+z0myBEv9GSlSHIhaI7P
   rqdtDbdVpW1z0Bozlts+yXQcP4WaU9LwzpWQJrXv9dXSh9nUTvARjViMh
   uY54WqhgbLdAZKSQDDLJILj5n0sxtrkH/nkj2vZDwkMi6Kmp+Quxaj2cH
   alyxX/dda3PvQQu2+j0TSaGhCJCIGe4UxOOAPz6kU84R7rxk402lclzfx
   zTez7hn7zwjujqV5yKAE98rl74Pz3PvRBPNwradSpeohOh0aYzYxLixYz
   AoCYuhhWx4gpn54Qq+dzHmB6uLu6oyZX5aNrB1FSdx+R4Vs2/RyeaKRMA
   A==;
X-CSE-ConnectionGUID: aleu77dLTBKPVezKuFEiBQ==
X-CSE-MsgGUID: gFppeU0XRpKXQtRu6Q91Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74575063"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74575063"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 12:26:38 -0700
X-CSE-ConnectionGUID: Y63VVkv5TIexc6mJkaAcgw==
X-CSE-MsgGUID: vqrvbAUNS7KWouksLLEMPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="185402287"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 29 Oct 2025 12:26:32 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEBoT-000L5y-2q;
	Wed, 29 Oct 2025 19:26:29 +0000
Date: Thu, 30 Oct 2025 03:25:44 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
Message-ID: <202510300316.UL4gxAlC-lkp@intel.com>
References: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2797D16000F
X-Rspamd-Server: rspam02
X-Stat-Signature: yqunybsxb3enm3dob96r6t6peoy5i47i
X-HE-Tag: 1761765998-591478
X-HE-Meta: U2FsdGVkX1++dBYrqHKkTOt67v5bsueJZD6I1JPbQToCMXLltoO2bg+pHTuKis6Kb1Ce0WAgvfl/p8UEX4mqy+oM6+FWlNzlcqH8axIPZn2wJxHOzf5D+U5o4QwuX/uczRz85Fn7CJ+Id0G0ioj0p+ElKNzu1hhuutq2QyxjlmE5H4oxQbxP9G+ODH4x7KbIq/3CbkbRcQBTP40mT5UyWcZZoPS7LqS5mP/Rsei9V+Kb3WlK2XSNVh2X0bVy/yhLj2FD+MEAHQkC0KSEbw0EamTfxs+oXn1BDRufDSDZYnyAR1QQujp5Gv+dMCNWzAxZuoDhhjVbOF3Hk/V1OXIC3iyvuXFU4i7OCKQBYLi+JCCLASuDYNPgEuR7l85PhFGSnhXiOOhu2ZGfZZGxl5dCXKfRZ9Nvom1UQ4gBn2RK72K2k6J0YoKnd89IWiJubumDImctiMFA4+VHJc97g2LzHlQpNip4tAoaB9A334oCcpShPy+sv3swGshie70Un+TvZZhpU1YBwO9XDEPsqTbgWebBG1rUspwaEbgoOBzriVFsfc/7vClDpf4uZcNApGTccekXbezZtmHmNOfnSssGa9mOQW4buMuOe42MXFW9D2bmBeST6weli4pnWW3HfSinnbK+gzn0YpZShxlItGnwbwWuTKOxBejKNgZS0Rwt8ZBfoUbfoziiv1hoJFKBPX8vS2EK2mzu9V+fFNyweGK76IkN+DpPzUnimNFRcUu0MNnBH1BCrsy0DnXMKgGHw4zrY0VERvU4EqfTwTaR6nXTe+2UdcfmkLYthbRXrDgYqAYe6Wg5AtBhD0Tw0aHsj14zLNmq5eRGmJZBE7O5sn3+tz3gpD/6MrtTPrR0dgnoxDCVQnAw6Rf2lrMSW0b/qRkZ2RO4BZBshcUVh5oRW9N8cFlNB6Nd4D3rAfEMC31X1ZHQ0OskXBUthgCgrFLVAeCBp1Oo5NytXKWfnfSmpaW
 kJLGeoON
 UAqgnJPfWksyhpTw8dFQlAPqwCSo0X1dRHHdP+nRjsD7dL4fvvFizc9QnT3ndEz+ZpTwxcb3sgvoVzkBs19ZE462tlC+gvgEnTkxyA5h+wB+lblW1xl6w7SuF005q5yDQUWX6QsGqnclNLHhyOIvpDvsjJweXngouYepr6aArOzkJfWXfM7eGFVfy3sSB92kAqVmA0nb/pi5J+HwTlLWetEroDWHy5dx3N7YGnw8WUX15qcWiOvlB+ndqJhTsYnnq3wM5+MqxseNYG29NIUDaSCnEX98c+o+47raMkduMQXLuCQh8J/V+SChkBnL5SBHkQMaXG2F/3MrhnOZGqLDCMVHHKZiQdXAX3+9riuU2vBhTjV6p4Wtsiibsyzug6H7bMF/K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build errors:

[auto build test ERROR on f30d294530d939fa4b77d61bc60f25c4284841fa]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251030-000506
base:   f30d294530d939fa4b77d61bc60f25c4284841fa
patch link:    https://lore.kernel.org/r/20251029-swap-table-p2-v1-14-3d43f3b6ec32%40tencent.com
patch subject: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20251030/202510300316.UL4gxAlC-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251030/202510300316.UL4gxAlC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510300316.UL4gxAlC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/vmscan.c:70:
   mm/swap.h: In function 'swap_cache_add_folio':
   mm/swap.h:465:1: warning: no return statement in function returning non-void [-Wreturn-type]
     465 | }
         | ^
   mm/vmscan.c: In function 'shrink_folio_list':
>> mm/vmscan.c:1298:37: error: too few arguments to function 'folio_alloc_swap'
    1298 |                                 if (folio_alloc_swap(folio)) {
         |                                     ^~~~~~~~~~~~~~~~
   mm/swap.h:388:19: note: declared here
     388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp)
         |                   ^~~~~~~~~~~~~~~~
   mm/vmscan.c:1314:45: error: too few arguments to function 'folio_alloc_swap'
    1314 |                                         if (folio_alloc_swap(folio))
         |                                             ^~~~~~~~~~~~~~~~
   mm/swap.h:388:19: note: declared here
     388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp)
         |                   ^~~~~~~~~~~~~~~~
--
   In file included from mm/shmem.c:44:
   mm/swap.h: In function 'swap_cache_add_folio':
   mm/swap.h:465:1: warning: no return statement in function returning non-void [-Wreturn-type]
     465 | }
         | ^
   mm/shmem.c: In function 'shmem_writeout':
>> mm/shmem.c:1649:14: error: too few arguments to function 'folio_alloc_swap'
    1649 |         if (!folio_alloc_swap(folio)) {
         |              ^~~~~~~~~~~~~~~~
   mm/swap.h:388:19: note: declared here
     388 | static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp)
         |                   ^~~~~~~~~~~~~~~~


vim +/folio_alloc_swap +1298 mm/vmscan.c

d791ea676b6648 NeilBrown               2022-05-09  1072  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1073  /*
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1074)  * shrink_folio_list() returns the number of reclaimed pages
^1da177e4c3f41 Linus Torvalds          2005-04-16  1075   */
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1076) static unsigned int shrink_folio_list(struct list_head *folio_list,
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1077) 		struct pglist_data *pgdat, struct scan_control *sc,
7d709f49babc28 Gregory Price           2025-04-24  1078  		struct reclaim_stat *stat, bool ignore_references,
7d709f49babc28 Gregory Price           2025-04-24  1079  		struct mem_cgroup *memcg)
^1da177e4c3f41 Linus Torvalds          2005-04-16  1080  {
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1081) 	struct folio_batch free_folios;
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1082) 	LIST_HEAD(ret_folios);
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1083) 	LIST_HEAD(demote_folios);
a479b078fddb0a Li Zhijian              2025-01-10  1084  	unsigned int nr_reclaimed = 0, nr_demoted = 0;
730ec8c01a2bd6 Maninder Singh          2020-06-03  1085  	unsigned int pgactivate = 0;
26aa2d199d6f2c Dave Hansen             2021-09-02  1086  	bool do_demote_pass;
2282679fb20bf0 NeilBrown               2022-05-09  1087  	struct swap_iocb *plug = NULL;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1088  
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1089) 	folio_batch_init(&free_folios);
060f005f074791 Kirill Tkhai            2019-03-05  1090  	memset(stat, 0, sizeof(*stat));
^1da177e4c3f41 Linus Torvalds          2005-04-16  1091  	cond_resched();
7d709f49babc28 Gregory Price           2025-04-24  1092  	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1093  
26aa2d199d6f2c Dave Hansen             2021-09-02  1094  retry:
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1095) 	while (!list_empty(folio_list)) {
^1da177e4c3f41 Linus Torvalds          2005-04-16  1096  		struct address_space *mapping;
be7c07d60e13ac Matthew Wilcox (Oracle  2021-12-23  1097) 		struct folio *folio;
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1098) 		enum folio_references references = FOLIOREF_RECLAIM;
d791ea676b6648 NeilBrown               2022-05-09  1099  		bool dirty, writeback;
98879b3b9edc16 Yang Shi                2019-07-11  1100  		unsigned int nr_pages;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1101  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1102  		cond_resched();
^1da177e4c3f41 Linus Torvalds          2005-04-16  1103  
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1104) 		folio = lru_to_folio(folio_list);
be7c07d60e13ac Matthew Wilcox (Oracle  2021-12-23  1105) 		list_del(&folio->lru);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1106  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1107) 		if (!folio_trylock(folio))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1108  			goto keep;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1109  
1b0449544c6482 Jinjiang Tu             2025-03-18  1110  		if (folio_contain_hwpoisoned_page(folio)) {
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1111  			/*
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1112  			 * unmap_poisoned_folio() can't handle large
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1113  			 * folio, just skip it. memory_failure() will
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1114  			 * handle it if the UCE is triggered again.
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1115  			 */
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1116  			if (folio_test_large(folio))
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1117  				goto keep_locked;
9f1e8cd0b7c4c9 Jinjiang Tu             2025-06-27  1118  
1b0449544c6482 Jinjiang Tu             2025-03-18  1119  			unmap_poisoned_folio(folio, folio_pfn(folio), false);
1b0449544c6482 Jinjiang Tu             2025-03-18  1120  			folio_unlock(folio);
1b0449544c6482 Jinjiang Tu             2025-03-18  1121  			folio_put(folio);
1b0449544c6482 Jinjiang Tu             2025-03-18  1122  			continue;
1b0449544c6482 Jinjiang Tu             2025-03-18  1123  		}
1b0449544c6482 Jinjiang Tu             2025-03-18  1124  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1125) 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1126  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1127) 		nr_pages = folio_nr_pages(folio);
98879b3b9edc16 Yang Shi                2019-07-11  1128  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1129) 		/* Account the number of base pages */
98879b3b9edc16 Yang Shi                2019-07-11  1130  		sc->nr_scanned += nr_pages;
80e4342601abfa Christoph Lameter       2006-02-11  1131  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1132) 		if (unlikely(!folio_evictable(folio)))
ad6b67041a4549 Minchan Kim             2017-05-03  1133  			goto activate_locked;
894bc310419ac9 Lee Schermerhorn        2008-10-18  1134  
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1135) 		if (!sc->may_unmap && folio_mapped(folio))
80e4342601abfa Christoph Lameter       2006-02-11  1136  			goto keep_locked;
80e4342601abfa Christoph Lameter       2006-02-11  1137  
e2be15f6c3eece Mel Gorman              2013-07-03  1138  		/*
894befec4d70b1 Andrey Ryabinin         2018-04-10  1139  		 * The number of dirty pages determines if a node is marked
8cd7c588decf47 Mel Gorman              2021-11-05  1140  		 * reclaim_congested. kswapd will stall and start writing
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1141) 		 * folios if the tail of the LRU is all dirty unqueued folios.
e2be15f6c3eece Mel Gorman              2013-07-03  1142  		 */
e20c41b1091a24 Matthew Wilcox (Oracle  2022-01-17  1143) 		folio_check_dirty_writeback(folio, &dirty, &writeback);
e2be15f6c3eece Mel Gorman              2013-07-03  1144  		if (dirty || writeback)
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1145) 			stat->nr_dirty += nr_pages;
e2be15f6c3eece Mel Gorman              2013-07-03  1146  
e2be15f6c3eece Mel Gorman              2013-07-03  1147  		if (dirty && !writeback)
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1148) 			stat->nr_unqueued_dirty += nr_pages;
e2be15f6c3eece Mel Gorman              2013-07-03  1149  
d04e8acd03e5c3 Mel Gorman              2013-07-03  1150  		/*
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1151) 		 * Treat this folio as congested if folios are cycling
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1152) 		 * through the LRU so quickly that the folios marked
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1153) 		 * for immediate reclaim are making it to the end of
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1154) 		 * the LRU a second time.
d04e8acd03e5c3 Mel Gorman              2013-07-03  1155  		 */
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1156) 		if (writeback && folio_test_reclaim(folio))
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1157) 			stat->nr_congested += nr_pages;
e2be15f6c3eece Mel Gorman              2013-07-03  1158  
e62e384e9da8d9 Michal Hocko            2012-07-31  1159  		/*
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1160) 		 * If a folio at the tail of the LRU is under writeback, there
283aba9f9e0e48 Mel Gorman              2013-07-03  1161  		 * are three cases to consider.
283aba9f9e0e48 Mel Gorman              2013-07-03  1162  		 *
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1163) 		 * 1) If reclaim is encountering an excessive number
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1164) 		 *    of folios under writeback and this folio has both
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1165) 		 *    the writeback and reclaim flags set, then it
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1166) 		 *    indicates that folios are being queued for I/O but
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1167) 		 *    are being recycled through the LRU before the I/O
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1168) 		 *    can complete. Waiting on the folio itself risks an
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1169) 		 *    indefinite stall if it is impossible to writeback
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1170) 		 *    the folio due to I/O error or disconnected storage
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1171) 		 *    so instead note that the LRU is being scanned too
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1172) 		 *    quickly and the caller can stall after the folio
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1173) 		 *    list has been processed.
283aba9f9e0e48 Mel Gorman              2013-07-03  1174  		 *
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1175) 		 * 2) Global or new memcg reclaim encounters a folio that is
ecf5fc6e9654cd Michal Hocko            2015-08-04  1176  		 *    not marked for immediate reclaim, or the caller does not
ecf5fc6e9654cd Michal Hocko            2015-08-04  1177  		 *    have __GFP_FS (or __GFP_IO if it's simply going to swap,
0c4f8ed498cea1 Joanne Koong            2025-04-14  1178  		 *    not to fs), or the folio belongs to a mapping where
0c4f8ed498cea1 Joanne Koong            2025-04-14  1179  		 *    waiting on writeback during reclaim may lead to a deadlock.
0c4f8ed498cea1 Joanne Koong            2025-04-14  1180  		 *    In this case mark the folio for immediate reclaim and
0c4f8ed498cea1 Joanne Koong            2025-04-14  1181  		 *    continue scanning.
283aba9f9e0e48 Mel Gorman              2013-07-03  1182  		 *
d791ea676b6648 NeilBrown               2022-05-09  1183  		 *    Require may_enter_fs() because we would wait on fs, which
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1184) 		 *    may not have submitted I/O yet. And the loop driver might
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1185) 		 *    enter reclaim, and deadlock if it waits on a folio for
283aba9f9e0e48 Mel Gorman              2013-07-03  1186  		 *    which it is needed to do the write (loop masks off
283aba9f9e0e48 Mel Gorman              2013-07-03  1187  		 *    __GFP_IO|__GFP_FS for this reason); but more thought
283aba9f9e0e48 Mel Gorman              2013-07-03  1188  		 *    would probably show more reasons.
283aba9f9e0e48 Mel Gorman              2013-07-03  1189  		 *
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1190) 		 * 3) Legacy memcg encounters a folio that already has the
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1191) 		 *    reclaim flag set. memcg does not have any dirty folio
283aba9f9e0e48 Mel Gorman              2013-07-03  1192  		 *    throttling so we could easily OOM just because too many
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1193) 		 *    folios are in writeback and there is nothing else to
283aba9f9e0e48 Mel Gorman              2013-07-03  1194  		 *    reclaim. Wait for the writeback to complete.
c55e8d035b28b2 Johannes Weiner         2017-02-24  1195  		 *
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1196) 		 * In cases 1) and 2) we activate the folios to get them out of
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1197) 		 * the way while we continue scanning for clean folios on the
c55e8d035b28b2 Johannes Weiner         2017-02-24  1198  		 * inactive list and refilling from the active list. The
c55e8d035b28b2 Johannes Weiner         2017-02-24  1199  		 * observation here is that waiting for disk writes is more
c55e8d035b28b2 Johannes Weiner         2017-02-24  1200  		 * expensive than potentially causing reloads down the line.
c55e8d035b28b2 Johannes Weiner         2017-02-24  1201  		 * Since they're marked for immediate reclaim, they won't put
c55e8d035b28b2 Johannes Weiner         2017-02-24  1202  		 * memory pressure on the cache working set any longer than it
c55e8d035b28b2 Johannes Weiner         2017-02-24  1203  		 * takes to write them to disk.
e62e384e9da8d9 Michal Hocko            2012-07-31  1204  		 */
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1205) 		if (folio_test_writeback(folio)) {
0c4f8ed498cea1 Joanne Koong            2025-04-14  1206  			mapping = folio_mapping(folio);
0c4f8ed498cea1 Joanne Koong            2025-04-14  1207  
283aba9f9e0e48 Mel Gorman              2013-07-03  1208  			/* Case 1 above */
283aba9f9e0e48 Mel Gorman              2013-07-03  1209  			if (current_is_kswapd() &&
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1210) 			    folio_test_reclaim(folio) &&
599d0c954f91d0 Mel Gorman              2016-07-28  1211  			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1212) 				stat->nr_immediate += nr_pages;
c55e8d035b28b2 Johannes Weiner         2017-02-24  1213  				goto activate_locked;
283aba9f9e0e48 Mel Gorman              2013-07-03  1214  
283aba9f9e0e48 Mel Gorman              2013-07-03  1215  			/* Case 2 above */
b5ead35e7e1d34 Johannes Weiner         2019-11-30  1216  			} else if (writeback_throttling_sane(sc) ||
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1217) 			    !folio_test_reclaim(folio) ||
0c4f8ed498cea1 Joanne Koong            2025-04-14  1218  			    !may_enter_fs(folio, sc->gfp_mask) ||
0c4f8ed498cea1 Joanne Koong            2025-04-14  1219  			    (mapping &&
0c4f8ed498cea1 Joanne Koong            2025-04-14  1220  			     mapping_writeback_may_deadlock_on_reclaim(mapping))) {
c3b94f44fcb072 Hugh Dickins            2012-07-31  1221  				/*
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1222) 				 * This is slightly racy -
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1223) 				 * folio_end_writeback() might have
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1224) 				 * just cleared the reclaim flag, then
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1225) 				 * setting the reclaim flag here ends up
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1226) 				 * interpreted as the readahead flag - but
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1227) 				 * that does not matter enough to care.
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1228) 				 * What we do want is for this folio to
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1229) 				 * have the reclaim flag set next time
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1230) 				 * memcg reclaim reaches the tests above,
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1231) 				 * so it will then wait for writeback to
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1232) 				 * avoid OOM; and it's also appropriate
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1233) 				 * in global reclaim.
c3b94f44fcb072 Hugh Dickins            2012-07-31  1234  				 */
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1235) 				folio_set_reclaim(folio);
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1236) 				stat->nr_writeback += nr_pages;
c55e8d035b28b2 Johannes Weiner         2017-02-24  1237  				goto activate_locked;
283aba9f9e0e48 Mel Gorman              2013-07-03  1238  
283aba9f9e0e48 Mel Gorman              2013-07-03  1239  			/* Case 3 above */
283aba9f9e0e48 Mel Gorman              2013-07-03  1240  			} else {
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1241) 				folio_unlock(folio);
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1242) 				folio_wait_writeback(folio);
d33e4e1412c8b6 Matthew Wilcox (Oracle  2022-05-12  1243) 				/* then go back and try same folio again */
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1244) 				list_add_tail(&folio->lru, folio_list);
7fadc820222497 Hugh Dickins            2015-09-08  1245  				continue;
e62e384e9da8d9 Michal Hocko            2012-07-31  1246  			}
283aba9f9e0e48 Mel Gorman              2013-07-03  1247  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1248  
8940b34a4e082a Minchan Kim             2019-09-25  1249  		if (!ignore_references)
d92013d1e5e47f Matthew Wilcox (Oracle  2022-02-15  1250) 			references = folio_check_references(folio, sc);
02c6de8d757cb3 Minchan Kim             2012-10-08  1251  
dfc8d636cdb95f Johannes Weiner         2010-03-05  1252  		switch (references) {
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1253) 		case FOLIOREF_ACTIVATE:
^1da177e4c3f41 Linus Torvalds          2005-04-16  1254  			goto activate_locked;
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1255) 		case FOLIOREF_KEEP:
98879b3b9edc16 Yang Shi                2019-07-11  1256  			stat->nr_ref_keep += nr_pages;
645747462435d8 Johannes Weiner         2010-03-05  1257  			goto keep_locked;
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1258) 		case FOLIOREF_RECLAIM:
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1259) 		case FOLIOREF_RECLAIM_CLEAN:
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1260) 			; /* try to reclaim the folio below */
dfc8d636cdb95f Johannes Weiner         2010-03-05  1261  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1262  
26aa2d199d6f2c Dave Hansen             2021-09-02  1263  		/*
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1264) 		 * Before reclaiming the folio, try to relocate
26aa2d199d6f2c Dave Hansen             2021-09-02  1265  		 * its contents to another node.
26aa2d199d6f2c Dave Hansen             2021-09-02  1266  		 */
26aa2d199d6f2c Dave Hansen             2021-09-02  1267  		if (do_demote_pass &&
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1268) 		    (thp_migration_supported() || !folio_test_large(folio))) {
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1269) 			list_add(&folio->lru, &demote_folios);
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1270) 			folio_unlock(folio);
26aa2d199d6f2c Dave Hansen             2021-09-02  1271  			continue;
26aa2d199d6f2c Dave Hansen             2021-09-02  1272  		}
26aa2d199d6f2c Dave Hansen             2021-09-02  1273  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1274  		/*
^1da177e4c3f41 Linus Torvalds          2005-04-16  1275  		 * Anonymous process memory has backing store?
^1da177e4c3f41 Linus Torvalds          2005-04-16  1276  		 * Try to allocate it some swap space here.
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1277) 		 * Lazyfree folio could be freed directly
^1da177e4c3f41 Linus Torvalds          2005-04-16  1278  		 */
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1279) 		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1280) 			if (!folio_test_swapcache(folio)) {
63eb6b93ce725e Hugh Dickins            2008-11-19  1281  				if (!(sc->gfp_mask & __GFP_IO))
63eb6b93ce725e Hugh Dickins            2008-11-19  1282  					goto keep_locked;
d4b4084ac3154c Matthew Wilcox (Oracle  2022-02-04  1283) 				if (folio_maybe_dma_pinned(folio))
feb889fb40fafc Linus Torvalds          2021-01-16  1284  					goto keep_locked;
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1285) 				if (folio_test_large(folio)) {
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1286) 					/* cannot split folio, skip it */
8710f6ed34e7bc David Hildenbrand       2024-08-02  1287  					if (!can_split_folio(folio, 1, NULL))
b8f593cd0896b8 Ying Huang              2017-07-06  1288  						goto activate_locked;
747552b1e71b40 Ying Huang              2017-07-06  1289  					/*
5ed890ce514785 Ryan Roberts            2024-04-08  1290  					 * Split partially mapped folios right away.
5ed890ce514785 Ryan Roberts            2024-04-08  1291  					 * We can free the unmapped pages without IO.
747552b1e71b40 Ying Huang              2017-07-06  1292  					 */
8422acdc97ed58 Usama Arif              2024-08-30  1293  					if (data_race(!list_empty(&folio->_deferred_list) &&
8422acdc97ed58 Usama Arif              2024-08-30  1294  					    folio_test_partially_mapped(folio)) &&
5ed890ce514785 Ryan Roberts            2024-04-08  1295  					    split_folio_to_list(folio, folio_list))
747552b1e71b40 Ying Huang              2017-07-06  1296  						goto activate_locked;
747552b1e71b40 Ying Huang              2017-07-06  1297  				}
7d14492199f93c Kairui Song             2025-10-24 @1298  				if (folio_alloc_swap(folio)) {
d0f048ac39f6a7 Barry Song              2024-04-12  1299  					int __maybe_unused order = folio_order(folio);
d0f048ac39f6a7 Barry Song              2024-04-12  1300  
09c02e56327bda Matthew Wilcox (Oracle  2022-05-12  1301) 					if (!folio_test_large(folio))
98879b3b9edc16 Yang Shi                2019-07-11  1302  						goto activate_locked_split;
bd4c82c22c367e Ying Huang              2017-09-06  1303  					/* Fallback to swap normal pages */
5ed890ce514785 Ryan Roberts            2024-04-08  1304  					if (split_folio_to_list(folio, folio_list))
0f0746589e4be0 Minchan Kim             2017-07-06  1305  						goto activate_locked;
fe490cc0fe9e6e Ying Huang              2017-09-06  1306  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
5ed890ce514785 Ryan Roberts            2024-04-08  1307  					if (nr_pages >= HPAGE_PMD_NR) {
5ed890ce514785 Ryan Roberts            2024-04-08  1308  						count_memcg_folio_events(folio,
5ed890ce514785 Ryan Roberts            2024-04-08  1309  							THP_SWPOUT_FALLBACK, 1);
fe490cc0fe9e6e Ying Huang              2017-09-06  1310  						count_vm_event(THP_SWPOUT_FALLBACK);
5ed890ce514785 Ryan Roberts            2024-04-08  1311  					}
fe490cc0fe9e6e Ying Huang              2017-09-06  1312  #endif
e26060d1fbd31a Kanchana P Sridhar      2024-10-02  1313  					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
7d14492199f93c Kairui Song             2025-10-24  1314  					if (folio_alloc_swap(folio))
98879b3b9edc16 Yang Shi                2019-07-11  1315  						goto activate_locked_split;
0f0746589e4be0 Minchan Kim             2017-07-06  1316  				}
b487a2da3575b6 Kairui Song             2025-03-14  1317  				/*
b487a2da3575b6 Kairui Song             2025-03-14  1318  				 * Normally the folio will be dirtied in unmap because its
b487a2da3575b6 Kairui Song             2025-03-14  1319  				 * pte should be dirty. A special case is MADV_FREE page. The
b487a2da3575b6 Kairui Song             2025-03-14  1320  				 * page's pte could have dirty bit cleared but the folio's
b487a2da3575b6 Kairui Song             2025-03-14  1321  				 * SwapBacked flag is still set because clearing the dirty bit
b487a2da3575b6 Kairui Song             2025-03-14  1322  				 * and SwapBacked flag has no lock protected. For such folio,
b487a2da3575b6 Kairui Song             2025-03-14  1323  				 * unmap will not set dirty bit for it, so folio reclaim will
b487a2da3575b6 Kairui Song             2025-03-14  1324  				 * not write the folio out. This can cause data corruption when
b487a2da3575b6 Kairui Song             2025-03-14  1325  				 * the folio is swapped in later. Always setting the dirty flag
b487a2da3575b6 Kairui Song             2025-03-14  1326  				 * for the folio solves the problem.
b487a2da3575b6 Kairui Song             2025-03-14  1327  				 */
b487a2da3575b6 Kairui Song             2025-03-14  1328  				folio_mark_dirty(folio);
bd4c82c22c367e Ying Huang              2017-09-06  1329  			}
e2be15f6c3eece Mel Gorman              2013-07-03  1330  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1331  
98879b3b9edc16 Yang Shi                2019-07-11  1332  		/*
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1333) 		 * If the folio was split above, the tail pages will make
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1334) 		 * their own pass through this function and be accounted
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1335) 		 * then.
98879b3b9edc16 Yang Shi                2019-07-11  1336  		 */
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1337) 		if ((nr_pages > 1) && !folio_test_large(folio)) {
98879b3b9edc16 Yang Shi                2019-07-11  1338  			sc->nr_scanned -= (nr_pages - 1);
98879b3b9edc16 Yang Shi                2019-07-11  1339  			nr_pages = 1;
98879b3b9edc16 Yang Shi                2019-07-11  1340  		}
98879b3b9edc16 Yang Shi                2019-07-11  1341  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1342  		/*
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1343) 		 * The folio is mapped into the page tables of one or more
^1da177e4c3f41 Linus Torvalds          2005-04-16  1344  		 * processes. Try to unmap it here.
^1da177e4c3f41 Linus Torvalds          2005-04-16  1345  		 */
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1346) 		if (folio_mapped(folio)) {
013339df116c2e Shakeel Butt            2020-12-14  1347  			enum ttu_flags flags = TTU_BATCH_FLUSH;
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1348) 			bool was_swapbacked = folio_test_swapbacked(folio);
bd4c82c22c367e Ying Huang              2017-09-06  1349  
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1350) 			if (folio_test_pmd_mappable(folio))
bd4c82c22c367e Ying Huang              2017-09-06  1351  				flags |= TTU_SPLIT_HUGE_PMD;
73bc32875ee9b1 Barry Song              2024-03-06  1352  			/*
73bc32875ee9b1 Barry Song              2024-03-06  1353  			 * Without TTU_SYNC, try_to_unmap will only begin to
73bc32875ee9b1 Barry Song              2024-03-06  1354  			 * hold PTL from the first present PTE within a large
73bc32875ee9b1 Barry Song              2024-03-06  1355  			 * folio. Some initial PTEs might be skipped due to
73bc32875ee9b1 Barry Song              2024-03-06  1356  			 * races with parallel PTE writes in which PTEs can be
73bc32875ee9b1 Barry Song              2024-03-06  1357  			 * cleared temporarily before being written new present
73bc32875ee9b1 Barry Song              2024-03-06  1358  			 * values. This will lead to a large folio is still
73bc32875ee9b1 Barry Song              2024-03-06  1359  			 * mapped while some subpages have been partially
73bc32875ee9b1 Barry Song              2024-03-06  1360  			 * unmapped after try_to_unmap; TTU_SYNC helps
73bc32875ee9b1 Barry Song              2024-03-06  1361  			 * try_to_unmap acquire PTL from the first PTE,
73bc32875ee9b1 Barry Song              2024-03-06  1362  			 * eliminating the influence of temporary PTE values.
73bc32875ee9b1 Barry Song              2024-03-06  1363  			 */
e5a119c4a6835a Barry Song              2024-06-30  1364  			if (folio_test_large(folio))
73bc32875ee9b1 Barry Song              2024-03-06  1365  				flags |= TTU_SYNC;
1f318a9b0dc399 Jaewon Kim              2020-06-03  1366  
869f7ee6f64773 Matthew Wilcox (Oracle  2022-02-15  1367) 			try_to_unmap(folio, flags);
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1368) 			if (folio_mapped(folio)) {
98879b3b9edc16 Yang Shi                2019-07-11  1369  				stat->nr_unmap_fail += nr_pages;
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1370) 				if (!was_swapbacked &&
1bee2c1677bcb5 Matthew Wilcox (Oracle  2022-05-12  1371) 				    folio_test_swapbacked(folio))
1f318a9b0dc399 Jaewon Kim              2020-06-03  1372  					stat->nr_lazyfree_fail += nr_pages;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1373  				goto activate_locked;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1374  			}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1375  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1376  
d824ec2a154677 Jan Kara                2023-04-28  1377  		/*
d824ec2a154677 Jan Kara                2023-04-28  1378  		 * Folio is unmapped now so it cannot be newly pinned anymore.
d824ec2a154677 Jan Kara                2023-04-28  1379  		 * No point in trying to reclaim folio if it is pinned.
d824ec2a154677 Jan Kara                2023-04-28  1380  		 * Furthermore we don't want to reclaim underlying fs metadata
d824ec2a154677 Jan Kara                2023-04-28  1381  		 * if the folio is pinned and thus potentially modified by the
d824ec2a154677 Jan Kara                2023-04-28  1382  		 * pinning process as that may upset the filesystem.
d824ec2a154677 Jan Kara                2023-04-28  1383  		 */
d824ec2a154677 Jan Kara                2023-04-28  1384  		if (folio_maybe_dma_pinned(folio))
d824ec2a154677 Jan Kara                2023-04-28  1385  			goto activate_locked;
d824ec2a154677 Jan Kara                2023-04-28  1386  
5441d4902f9692 Matthew Wilcox (Oracle  2022-05-12  1387) 		mapping = folio_mapping(folio);
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1388) 		if (folio_test_dirty(folio)) {
e2a80749555d73 Baolin Wang             2025-10-17  1389  			if (folio_is_file_lru(folio)) {
49ea7eb65e7c50 Mel Gorman              2011-10-31  1390  				/*
49ea7eb65e7c50 Mel Gorman              2011-10-31  1391  				 * Immediately reclaim when written back.
5a9e34747c9f73 Vishal Moola (Oracle    2022-12-21  1392) 				 * Similar in principle to folio_deactivate()
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1393) 				 * except we already have the folio isolated
49ea7eb65e7c50 Mel Gorman              2011-10-31  1394  				 * and know it's dirty
49ea7eb65e7c50 Mel Gorman              2011-10-31  1395  				 */
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1396) 				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1397) 						nr_pages);
e2a80749555d73 Baolin Wang             2025-10-17  1398  				if (!folio_test_reclaim(folio))
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1399) 					folio_set_reclaim(folio);
49ea7eb65e7c50 Mel Gorman              2011-10-31  1400  
c55e8d035b28b2 Johannes Weiner         2017-02-24  1401  				goto activate_locked;
ee72886d8ed5d9 Mel Gorman              2011-10-31  1402  			}
ee72886d8ed5d9 Mel Gorman              2011-10-31  1403  
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1404) 			if (references == FOLIOREF_RECLAIM_CLEAN)
^1da177e4c3f41 Linus Torvalds          2005-04-16  1405  				goto keep_locked;
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1406) 			if (!may_enter_fs(folio, sc->gfp_mask))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1407  				goto keep_locked;
52a8363eae3872 Christoph Lameter       2006-02-01  1408  			if (!sc->may_writepage)
^1da177e4c3f41 Linus Torvalds          2005-04-16  1409  				goto keep_locked;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1410  
d950c9477d51f0 Mel Gorman              2015-09-04  1411  			/*
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1412) 			 * Folio is dirty. Flush the TLB if a writable entry
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1413) 			 * potentially exists to avoid CPU writes after I/O
d950c9477d51f0 Mel Gorman              2015-09-04  1414  			 * starts and then write it out here.
d950c9477d51f0 Mel Gorman              2015-09-04  1415  			 */
d950c9477d51f0 Mel Gorman              2015-09-04  1416  			try_to_unmap_flush_dirty();
809bc86517cc40 Baolin Wang             2024-08-12  1417  			switch (pageout(folio, mapping, &plug, folio_list)) {
^1da177e4c3f41 Linus Torvalds          2005-04-16  1418  			case PAGE_KEEP:
^1da177e4c3f41 Linus Torvalds          2005-04-16  1419  				goto keep_locked;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1420  			case PAGE_ACTIVATE:
809bc86517cc40 Baolin Wang             2024-08-12  1421  				/*
809bc86517cc40 Baolin Wang             2024-08-12  1422  				 * If shmem folio is split when writeback to swap,
809bc86517cc40 Baolin Wang             2024-08-12  1423  				 * the tail pages will make their own pass through
809bc86517cc40 Baolin Wang             2024-08-12  1424  				 * this function and be accounted then.
809bc86517cc40 Baolin Wang             2024-08-12  1425  				 */
809bc86517cc40 Baolin Wang             2024-08-12  1426  				if (nr_pages > 1 && !folio_test_large(folio)) {
809bc86517cc40 Baolin Wang             2024-08-12  1427  					sc->nr_scanned -= (nr_pages - 1);
809bc86517cc40 Baolin Wang             2024-08-12  1428  					nr_pages = 1;
809bc86517cc40 Baolin Wang             2024-08-12  1429  				}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1430  				goto activate_locked;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1431  			case PAGE_SUCCESS:
809bc86517cc40 Baolin Wang             2024-08-12  1432  				if (nr_pages > 1 && !folio_test_large(folio)) {
809bc86517cc40 Baolin Wang             2024-08-12  1433  					sc->nr_scanned -= (nr_pages - 1);
809bc86517cc40 Baolin Wang             2024-08-12  1434  					nr_pages = 1;
809bc86517cc40 Baolin Wang             2024-08-12  1435  				}
c79b7b96db8b12 Matthew Wilcox (Oracle  2022-01-17  1436) 				stat->nr_pageout += nr_pages;
96f8bf4fb1dd26 Johannes Weiner         2020-06-03  1437  
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1438) 				if (folio_test_writeback(folio))
41ac1999c3e356 Mel Gorman              2012-05-29  1439  					goto keep;
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1440) 				if (folio_test_dirty(folio))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1441  					goto keep;
7d3579e8e61937 KOSAKI Motohiro         2010-10-26  1442  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1443  				/*
^1da177e4c3f41 Linus Torvalds          2005-04-16  1444  				 * A synchronous write - probably a ramdisk.  Go
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1445) 				 * ahead and try to reclaim the folio.
^1da177e4c3f41 Linus Torvalds          2005-04-16  1446  				 */
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1447) 				if (!folio_trylock(folio))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1448  					goto keep;
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1449) 				if (folio_test_dirty(folio) ||
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1450) 				    folio_test_writeback(folio))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1451  					goto keep_locked;
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1452) 				mapping = folio_mapping(folio);
01359eb2013b4b Gustavo A. R. Silva     2020-12-14  1453  				fallthrough;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1454  			case PAGE_CLEAN:
49bd2bf9679f4a Matthew Wilcox (Oracle  2022-05-12  1455) 				; /* try to free the folio below */
^1da177e4c3f41 Linus Torvalds          2005-04-16  1456  			}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1457  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1458  
^1da177e4c3f41 Linus Torvalds          2005-04-16  1459  		/*
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1460) 		 * If the folio has buffers, try to free the buffer
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1461) 		 * mappings associated with this folio. If we succeed
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1462) 		 * we try to free the folio as well.
^1da177e4c3f41 Linus Torvalds          2005-04-16  1463  		 *
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1464) 		 * We do this even if the folio is dirty.
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1465) 		 * filemap_release_folio() does not perform I/O, but it
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1466) 		 * is possible for a folio to have the dirty flag set,
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1467) 		 * but it is actually clean (all its buffers are clean).
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1468) 		 * This happens if the buffers were written out directly,
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1469) 		 * with submit_bh(). ext3 will do this, as well as
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1470) 		 * the blockdev mapping.  filemap_release_folio() will
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1471) 		 * discover that cleanness and will drop the buffers
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1472) 		 * and mark the folio clean - it can be freed.
^1da177e4c3f41 Linus Torvalds          2005-04-16  1473  		 *
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1474) 		 * Rarely, folios can have buffers and no ->mapping.
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1475) 		 * These are the folios which were not successfully
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1476) 		 * invalidated in truncate_cleanup_folio().  We try to
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1477) 		 * drop those buffers here and if that worked, and the
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1478) 		 * folio is no longer mapped into process address space
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1479) 		 * (refcount == 1) it can be freed.  Otherwise, leave
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1480) 		 * the folio on the LRU so it is swappable.
^1da177e4c3f41 Linus Torvalds          2005-04-16  1481  		 */
0201ebf274a306 David Howells           2023-06-28  1482  		if (folio_needs_release(folio)) {
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1483) 			if (!filemap_release_folio(folio, sc->gfp_mask))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1484  				goto activate_locked;
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1485) 			if (!mapping && folio_ref_count(folio) == 1) {
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1486) 				folio_unlock(folio);
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1487) 				if (folio_put_testzero(folio))
^1da177e4c3f41 Linus Torvalds          2005-04-16  1488  					goto free_it;
e286781d5f2e9c Nicholas Piggin         2008-07-25  1489  				else {
e286781d5f2e9c Nicholas Piggin         2008-07-25  1490  					/*
e286781d5f2e9c Nicholas Piggin         2008-07-25  1491  					 * rare race with speculative reference.
e286781d5f2e9c Nicholas Piggin         2008-07-25  1492  					 * the speculative reference will free
0a36111c8c20b2 Matthew Wilcox (Oracle  2022-05-12  1493) 					 * this folio shortly, so we may
e286781d5f2e9c Nicholas Piggin         2008-07-25  1494  					 * increment nr_reclaimed here (and
e286781d5f2e9c Nicholas Piggin         2008-07-25  1495  					 * leave it off the LRU).
e286781d5f2e9c Nicholas Piggin         2008-07-25  1496  					 */
9aafcffc18785f Miaohe Lin              2022-05-12  1497  					nr_reclaimed += nr_pages;
e286781d5f2e9c Nicholas Piggin         2008-07-25  1498  					continue;
e286781d5f2e9c Nicholas Piggin         2008-07-25  1499  				}
e286781d5f2e9c Nicholas Piggin         2008-07-25  1500  			}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1501  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1502  
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1503) 		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
802a3a92ad7ac0 Shaohua Li              2017-05-03  1504  			/* follow __remove_mapping for reference */
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1505) 			if (!folio_ref_freeze(folio, 1))
49d2e9cc454436 Christoph Lameter       2006-01-08  1506  				goto keep_locked;
d17be2d9ff6c68 Miaohe Lin              2021-09-02  1507  			/*
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1508) 			 * The folio has only one reference left, which is
d17be2d9ff6c68 Miaohe Lin              2021-09-02  1509  			 * from the isolation. After the caller puts the
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1510) 			 * folio back on the lru and drops the reference, the
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1511) 			 * folio will be freed anyway. It doesn't matter
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1512) 			 * which lru it goes on. So we don't bother checking
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1513) 			 * the dirty flag here.
d17be2d9ff6c68 Miaohe Lin              2021-09-02  1514  			 */
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1515) 			count_vm_events(PGLAZYFREED, nr_pages);
64daa5d818ae34 Matthew Wilcox (Oracle  2022-05-12  1516) 			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
be7c07d60e13ac Matthew Wilcox (Oracle  2021-12-23  1517) 		} else if (!mapping || !__remove_mapping(mapping, folio, true,
b910718a948a91 Johannes Weiner         2019-11-30  1518  							 sc->target_mem_cgroup))
802a3a92ad7ac0 Shaohua Li              2017-05-03  1519  			goto keep_locked;
9a1ea439b16b92 Hugh Dickins            2018-12-28  1520  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1521) 		folio_unlock(folio);
e286781d5f2e9c Nicholas Piggin         2008-07-25  1522  free_it:
98879b3b9edc16 Yang Shi                2019-07-11  1523  		/*
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1524) 		 * Folio may get swapped out as a whole, need to account
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1525) 		 * all pages in it.
98879b3b9edc16 Yang Shi                2019-07-11  1526  		 */
98879b3b9edc16 Yang Shi                2019-07-11  1527  		nr_reclaimed += nr_pages;
abe4c3b50c3f25 Mel Gorman              2010-08-09  1528  
f8f931bba0f920 Hugh Dickins            2024-10-27  1529  		folio_unqueue_deferred_split(folio);
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1530) 		if (folio_batch_add(&free_folios, folio) == 0) {
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1531) 			mem_cgroup_uncharge_folios(&free_folios);
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1532) 			try_to_unmap_flush();
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1533) 			free_unref_folios(&free_folios);
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1534) 		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1535  		continue;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1536  
98879b3b9edc16 Yang Shi                2019-07-11  1537  activate_locked_split:
98879b3b9edc16 Yang Shi                2019-07-11  1538  		/*
98879b3b9edc16 Yang Shi                2019-07-11  1539  		 * The tail pages that are failed to add into swap cache
98879b3b9edc16 Yang Shi                2019-07-11  1540  		 * reach here.  Fixup nr_scanned and nr_pages.
98879b3b9edc16 Yang Shi                2019-07-11  1541  		 */
98879b3b9edc16 Yang Shi                2019-07-11  1542  		if (nr_pages > 1) {
98879b3b9edc16 Yang Shi                2019-07-11  1543  			sc->nr_scanned -= (nr_pages - 1);
98879b3b9edc16 Yang Shi                2019-07-11  1544  			nr_pages = 1;
98879b3b9edc16 Yang Shi                2019-07-11  1545  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1546  activate_locked:
68a22394c286a2 Rik van Riel            2008-10-18  1547  		/* Not a candidate for swapping, so reclaim swap space. */
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1548) 		if (folio_test_swapcache(folio) &&
9202d527b715f6 Matthew Wilcox (Oracle  2022-09-02  1549) 		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
bdb0ed54a4768d Matthew Wilcox (Oracle  2022-09-02  1550) 			folio_free_swap(folio);
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1551) 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1552) 		if (!folio_test_mlocked(folio)) {
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1553) 			int type = folio_is_file_lru(folio);
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1554) 			folio_set_active(folio);
98879b3b9edc16 Yang Shi                2019-07-11  1555  			stat->nr_activate[type] += nr_pages;
246b648038096c Matthew Wilcox (Oracle  2022-05-12  1556) 			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
ad6b67041a4549 Minchan Kim             2017-05-03  1557  		}
^1da177e4c3f41 Linus Torvalds          2005-04-16  1558  keep_locked:
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1559) 		folio_unlock(folio);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1560  keep:
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1561) 		list_add(&folio->lru, &ret_folios);
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1562) 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1563) 				folio_test_unevictable(folio), folio);
^1da177e4c3f41 Linus Torvalds          2005-04-16  1564  	}
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1565) 	/* 'folio_list' is always empty here */
26aa2d199d6f2c Dave Hansen             2021-09-02  1566  
c28a0e9695b724 Matthew Wilcox (Oracle  2022-05-12  1567) 	/* Migrate folios selected for demotion */
a479b078fddb0a Li Zhijian              2025-01-10  1568  	nr_demoted = demote_folio_list(&demote_folios, pgdat);
a479b078fddb0a Li Zhijian              2025-01-10  1569  	nr_reclaimed += nr_demoted;
a479b078fddb0a Li Zhijian              2025-01-10  1570  	stat->nr_demoted += nr_demoted;
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1571) 	/* Folios that could not be demoted are still in @demote_folios */
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1572) 	if (!list_empty(&demote_folios)) {
6b426d071419a4 Mina Almasry            2022-12-01  1573  		/* Folios which weren't demoted go back on @folio_list */
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1574) 		list_splice_init(&demote_folios, folio_list);
6b426d071419a4 Mina Almasry            2022-12-01  1575  
6b426d071419a4 Mina Almasry            2022-12-01  1576  		/*
6b426d071419a4 Mina Almasry            2022-12-01  1577  		 * goto retry to reclaim the undemoted folios in folio_list if
6b426d071419a4 Mina Almasry            2022-12-01  1578  		 * desired.
6b426d071419a4 Mina Almasry            2022-12-01  1579  		 *
6b426d071419a4 Mina Almasry            2022-12-01  1580  		 * Reclaiming directly from top tier nodes is not often desired
6b426d071419a4 Mina Almasry            2022-12-01  1581  		 * due to it breaking the LRU ordering: in general memory
6b426d071419a4 Mina Almasry            2022-12-01  1582  		 * should be reclaimed from lower tier nodes and demoted from
6b426d071419a4 Mina Almasry            2022-12-01  1583  		 * top tier nodes.
6b426d071419a4 Mina Almasry            2022-12-01  1584  		 *
6b426d071419a4 Mina Almasry            2022-12-01  1585  		 * However, disabling reclaim from top tier nodes entirely
6b426d071419a4 Mina Almasry            2022-12-01  1586  		 * would cause ooms in edge scenarios where lower tier memory
6b426d071419a4 Mina Almasry            2022-12-01  1587  		 * is unreclaimable for whatever reason, eg memory being
6b426d071419a4 Mina Almasry            2022-12-01  1588  		 * mlocked or too hot to reclaim. We can disable reclaim
6b426d071419a4 Mina Almasry            2022-12-01  1589  		 * from top tier nodes in proactive reclaim though as that is
6b426d071419a4 Mina Almasry            2022-12-01  1590  		 * not real memory pressure.
6b426d071419a4 Mina Almasry            2022-12-01  1591  		 */
6b426d071419a4 Mina Almasry            2022-12-01  1592  		if (!sc->proactive) {
26aa2d199d6f2c Dave Hansen             2021-09-02  1593  			do_demote_pass = false;
26aa2d199d6f2c Dave Hansen             2021-09-02  1594  			goto retry;
26aa2d199d6f2c Dave Hansen             2021-09-02  1595  		}
6b426d071419a4 Mina Almasry            2022-12-01  1596  	}
abe4c3b50c3f25 Mel Gorman              2010-08-09  1597  
98879b3b9edc16 Yang Shi                2019-07-11  1598  	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
98879b3b9edc16 Yang Shi                2019-07-11  1599  
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1600) 	mem_cgroup_uncharge_folios(&free_folios);
72b252aed506b8 Mel Gorman              2015-09-04  1601  	try_to_unmap_flush();
bc2ff4cbc3294c Matthew Wilcox (Oracle  2024-02-27  1602) 	free_unref_folios(&free_folios);
abe4c3b50c3f25 Mel Gorman              2010-08-09  1603  
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1604) 	list_splice(&ret_folios, folio_list);
886cf1901db962 Kirill Tkhai            2019-05-13  1605  	count_vm_events(PGACTIVATE, pgactivate);
060f005f074791 Kirill Tkhai            2019-03-05  1606  
2282679fb20bf0 NeilBrown               2022-05-09  1607  	if (plug)
2282679fb20bf0 NeilBrown               2022-05-09  1608  		swap_write_unplug(plug);
05ff51376f01fd Andrew Morton           2006-03-22  1609  	return nr_reclaimed;
^1da177e4c3f41 Linus Torvalds          2005-04-16  1610  }
^1da177e4c3f41 Linus Torvalds          2005-04-16  1611  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

