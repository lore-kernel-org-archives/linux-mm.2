Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92138C88E47
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 04:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7B46B0088; Sun, 25 Jan 2026 23:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765A16B0089; Sun, 25 Jan 2026 23:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672106B008A; Sun, 25 Jan 2026 23:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52D956B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 23:04:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECE69C23AF
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:04:23 +0000 (UTC)
X-FDA: 84372772806.24.B7B0F2C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE5614000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:04:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hqIFCS+A;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769400262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDFQX22Xsj4R11AZviXolGUDrXgB8YyswvyJesUQ5sc=;
	b=2z+8v4As+DiQPA9YVx7oDBrmCndUnp3SJiKibLkpSCXz3k5RCbD5FwCRCPjLc2oyYzGIpL
	vY0aq3/aGZgHfUie3OE/9vj3ectO4SOd9IFPdWilG7p/HjAy7kwwF4Hp2/r+SBKyMpfDKu
	qs1hkN7/5lj9o8U7VewSdiE/S7G1eJg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hqIFCS+A;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769400262; a=rsa-sha256;
	cv=none;
	b=zVq8+4flzXVR6Q81qn9XmdUG2R5+d68QVZxFrQkmrkLSN/jRRGkNUpIRU/ezxXmCZVfZ/1
	rJIeNPsl+TiWLAiYqqs3cTfmjgikLbC17Wj13mq07E9cgv7qzV5VziKJLbQMRBwyUbcGwv
	dP8pDV0nBdfwXvf/jDyOIac7pG43gJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769400260; x=1800936260;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a3iNMLit+kMe8I/F8jE2AjXgR+027BbglltsU6VKmIY=;
  b=hqIFCS+Am/Wi/oAR8t+EohUfqYQaFg2UbU7Tjy6PeuC+r0Vx8ORzNjwh
   6xjgR8+JBOL4SvjCIvVV3NGru+AmSjpImkz/v2XhPpps05KxnHgOwQRAH
   Z5fq1+6USwXgcaL18GXEn0hkoBFbNkNxrCWPyfsUOWxwJwDOY84TQM3so
   RsHP66pDkcOEs8yKir480o5NLT/Pgne0/wSmwhwpW2X5Z1jEtP9FEsOmJ
   +gluN0zK6qxYM0uCy/1N/rXah3ZhVZt/Dwbb+uPV93mALZgZwhPeQ/3b9
   4cAePF27ods3lZ6jqLOlPHMJkbc0MetxTNn2//dCiy10N7D0CulfCrsGS
   Q==;
X-CSE-ConnectionGUID: /01UE98kSt29bqkzGmncSQ==
X-CSE-MsgGUID: wNvyuv08Sx+S8fxXqNt+5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="74419165"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="74419165"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 20:04:19 -0800
X-CSE-ConnectionGUID: UBFIBXBgSiqj3cvyZeQyPQ==
X-CSE-MsgGUID: W4KPQ00FRW2czCeSyjnQdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="206814354"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 25 Jan 2026 20:04:16 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkDpl-000000001Pp-1XbH;
	Mon, 26 Jan 2026 04:04:13 +0000
Date: Mon, 26 Jan 2026 05:04:04 +0100
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <202601260524.qYN30lLA-lkp@intel.com>
References: <20260126-swap-table-p3-v1-9-a74155fab9b0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-swap-table-p3-v1-9-a74155fab9b0@tencent.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 36hza5ricbrytp11d5or6mn7pwhcbj6y
X-Rspam-User: 
X-Rspamd-Queue-Id: BE5614000B
X-HE-Tag: 1769400260-833139
X-HE-Meta: U2FsdGVkX18MAWVJpZPxAcb9aMx/e3zJt0e+w0FbjjMAVBrVICIsNEf+r3E6AXcEtuN28opodK2/GpHUOzW8SMkqMrixp/BylE3E1OrDyES9a+BRk1Qj97/EEUMeYO+SGz68IKIHGFV8LbLI/N/00/+BKz86lso1F/rhiAVDdDQGxKPbQChAMBl3fM/fswM88/F963K1TG/3mi78AVoIjnhv9DcxB1TwS7L7OzNqjZhyU05DHdVvLHoIp7O1jYLYiX6KCgPPtr5I/fsmTiVwcls+C/J2zeK7KmQSnBcsgg+SKKkuz2qedi9LEgNCHObcmmnF+EUVDeKgofHxiWb55/JQIdOkebMscz0HPZtGq00CRHi69DEbaI05LAR7SEdUUPhvEwjCqHVHk7ycHZnE2stl/rbCxCebS3L13m3HBIKYB2B0/ffS19+qLLj1rC3Aup7Kzmw5LwH97yBvkKgysgR7Kg/O/rlfflXGZ1eJsLfAPl8HTSEhq2fSODC6lpXzjUrRGXgO5Z22xIJRkuKxuRoCVcBGniljOgpo4YWDyvmafHoJQffC1SeItk0dPFUWFkT45ag6U+mTFSqJ2vJCA/d7pkUi0mmUa110XB2SpcGNlFCt3KTQhWEBrQSp1Z/k9K4KV5ZS8n8SnlJ7Qp7WmlaZdPp0Ah8ov3qucrBCeZr2Mx1JtIFYqVPc7c73uLu/dFXoSeXtuwqSOu1IvOF7daJ/EBxNuUmReMrp7FDSHAzEYNxOzWq/fchiW9yPZOy7PcPzReL0bubTOQnoA4FkSlCI44n4JE+5C9VyqCufM/3oKv0plcrJScqxd8OWQm3m7xUqlYIudfGM/23+Ie/7c18W7fMt9N26yF02nX3DV26HO051WrrGv4NHN6YIXp+2ocSu6vGjXO2W1UqDerW3HbhCticCrLMTfM3Mpr1PNW8FtMHR6vfJHQCMDWZxh/hSiJEDr15dSM0SbVD4vq1
 w/mWZECa
 GQ1ARCqFATPA6W6/jxQryaLpQo2nVxPbC+KmB+qAeCvDYdHfz55rNRoTZejxB4HpJmUuWR1GOaz4dosiRO3NLTpYFY8bsJMbxXBFPkx0DtOkB2OAi7xvQQfaVfUgY/KyJ73v4g4fSCBOegxOwZVh2uI6wzLLS9RDMADYWjyIVbUF67NlprwfKWkzf8n7pbH7CZ4VfjOf0Mm00GFrDTA2vxrrLApvYYGo0WN1gDHm2guRTi2MbctUlGNJo1WPMjRzjdGEIolXk1KgxLrA15UipYO5DuG/WERDlXB/E5JiqofSDju1ZBtRBKi6rp9iQf/DwJqTXU+ot3iTGLyR5Zu1kS8TtA/m+Lm1a0Mp0CqhEnOh+YAn3nGFbhl+WuGVo6fQ7Hm1O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 10de4550639e9df9242e32e9affc90ed75a27c7d]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator/20260126-020149
base:   10de4550639e9df9242e32e9affc90ed75a27c7d
patch link:    https://lore.kernel.org/r/20260126-swap-table-p3-v1-9-a74155fab9b0%40tencent.com
patch subject: [PATCH 09/12] mm, swap: use the swap table to track the swap count
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260126/202601260524.qYN30lLA-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260126/202601260524.qYN30lLA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601260524.qYN30lLA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/swapfile.c: In function 'unuse_pte_range':
>> mm/swapfile.c:2351:31: warning: variable 'offset' set but not used [-Wunused-but-set-variable]
    2351 |                 unsigned long offset;
         |                               ^~~~~~
>> mm/swapfile.c:2346:34: warning: variable 'si' set but not used [-Wunused-but-set-variable]
    2346 |         struct swap_info_struct *si;
         |                                  ^~


vim +/offset +2351 mm/swapfile.c

^1da177e4c3f41 Linus Torvalds          2005-04-16  2340  
^1da177e4c3f41 Linus Torvalds          2005-04-16  2341  static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
^1da177e4c3f41 Linus Torvalds          2005-04-16  2342  			unsigned long addr, unsigned long end,
10a9c496789fe2 Christoph Hellwig       2022-01-21  2343  			unsigned int type)
^1da177e4c3f41 Linus Torvalds          2005-04-16  2344  {
d850fa72987378 Hugh Dickins            2023-06-08  2345  	pte_t *pte = NULL;
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05 @2346  	struct swap_info_struct *si;
^1da177e4c3f41 Linus Torvalds          2005-04-16  2347  
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2348  	si = swap_info[type];
^1da177e4c3f41 Linus Torvalds          2005-04-16  2349  	do {
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2350) 		struct folio *folio;
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02 @2351) 		unsigned long offset;
0177fe675b3916 Kairui Song             2026-01-26  2352  		unsigned long swp_tb;
3f79b187ad2f67 Kairui Song             2022-12-20  2353  		unsigned char swp_count;
06fb61462bdea3 Lorenzo Stoakes         2025-11-10  2354  		softleaf_t entry;
d850fa72987378 Hugh Dickins            2023-06-08  2355  		int ret;
c33c794828f212 Ryan Roberts            2023-06-12  2356  		pte_t ptent;
d850fa72987378 Hugh Dickins            2023-06-08  2357  
d850fa72987378 Hugh Dickins            2023-06-08  2358  		if (!pte++) {
d850fa72987378 Hugh Dickins            2023-06-08  2359  			pte = pte_offset_map(pmd, addr);
d850fa72987378 Hugh Dickins            2023-06-08  2360  			if (!pte)
d850fa72987378 Hugh Dickins            2023-06-08  2361  				break;
d850fa72987378 Hugh Dickins            2023-06-08  2362  		}
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2363) 
c33c794828f212 Ryan Roberts            2023-06-12  2364  		ptent = ptep_get_lockless(pte);
06fb61462bdea3 Lorenzo Stoakes         2025-11-10  2365  		entry = softleaf_from_pte(ptent);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2366) 
06fb61462bdea3 Lorenzo Stoakes         2025-11-10  2367  		if (!softleaf_is_swap(entry))
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2368  			continue;
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2369  		if (swp_type(entry) != type)
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2370  			continue;
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2371  
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2372  		offset = swp_offset(entry);
044d66c1d2b1c5 Hugh Dickins            2008-02-07  2373  		pte_unmap(pte);
d850fa72987378 Hugh Dickins            2023-06-08  2374  		pte = NULL;
d850fa72987378 Hugh Dickins            2023-06-08  2375  
f28124617f3415 Kairui Song             2025-09-17  2376  		folio = swap_cache_get_folio(entry);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2377) 		if (!folio) {
8c63ca5bc3e19f Will Deacon             2021-01-14  2378  			struct vm_fault vmf = {
8c63ca5bc3e19f Will Deacon             2021-01-14  2379  				.vma = vma,
8c63ca5bc3e19f Will Deacon             2021-01-14  2380  				.address = addr,
824ddc601adc2c Nadav Amit              2022-03-22  2381  				.real_address = addr,
8c63ca5bc3e19f Will Deacon             2021-01-14  2382  				.pmd = pmd,
8c63ca5bc3e19f Will Deacon             2021-01-14  2383  			};
8c63ca5bc3e19f Will Deacon             2021-01-14  2384  
94dc8bffd8b7fe Matthew Wilcox (Oracle  2024-08-07  2385) 			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
ebc5951eea4993 Andrea Righi            2020-06-01  2386  						&vmf);
ebc5951eea4993 Andrea Righi            2020-06-01  2387  		}
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2388) 		if (!folio) {
0177fe675b3916 Kairui Song             2026-01-26  2389  			swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
0177fe675b3916 Kairui Song             2026-01-26  2390  						  swp_cluster_offset(entry));
0177fe675b3916 Kairui Song             2026-01-26  2391  			swp_count = swp_tb_get_count(swp_tb);
0177fe675b3916 Kairui Song             2026-01-26  2392  			if (swp_count <= 0)
d850fa72987378 Hugh Dickins            2023-06-08  2393  				continue;
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2394  			return -ENOMEM;
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2395  		}
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2396  
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2397) 		folio_lock(folio);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2398) 		folio_wait_writeback(folio);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2399) 		ret = unuse_pte(vma, pmd, addr, entry, folio);
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2400  		if (ret < 0) {
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2401) 			folio_unlock(folio);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2402) 			folio_put(folio);
d850fa72987378 Hugh Dickins            2023-06-08  2403  			return ret;
^1da177e4c3f41 Linus Torvalds          2005-04-16  2404  		}
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2405  
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2406) 		folio_free_swap(folio);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2407) 		folio_unlock(folio);
f102cd8b173e06 Matthew Wilcox (Oracle  2022-09-02  2408) 		folio_put(folio);
d850fa72987378 Hugh Dickins            2023-06-08  2409  	} while (addr += PAGE_SIZE, addr != end);
b56a2d8af9147a Vineeth Remanan Pillai  2019-03-05  2410  
d850fa72987378 Hugh Dickins            2023-06-08  2411  	if (pte)
d850fa72987378 Hugh Dickins            2023-06-08  2412  		pte_unmap(pte);
d850fa72987378 Hugh Dickins            2023-06-08  2413  	return 0;
^1da177e4c3f41 Linus Torvalds          2005-04-16  2414  }
^1da177e4c3f41 Linus Torvalds          2005-04-16  2415  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

