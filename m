Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D13D778B1
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 01:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BABD6B0005; Sun, 25 Jan 2026 20:04:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391ED6B0088; Sun, 25 Jan 2026 20:04:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2674B6B0089; Sun, 25 Jan 2026 20:04:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12D576B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 20:04:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF2421B026B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:04:15 +0000 (UTC)
X-FDA: 84372318870.22.ABF1A5B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9CBB4000F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:04:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NUbHtmEM;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769389453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gyLmNV3bcrq7q/Q7KM/2N3tSNKpRfMHW6e6aWOb+xQ=;
	b=zePe/CEx22fzMygmSboFlRplpA/qK/6VfbdnahZMakSPA5ZjLu6rDtAMDLNcwT4fKcdSul
	wrHqb6vYwgxVfJ86KPp7MpNZSYUcDL25udkT9LHXorMsIgeH2HSwUyz82lO0LnuqAQt28H
	NNmWOVFnP+bqjy7/sHz+Y0Cng803TVk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NUbHtmEM;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769389453; a=rsa-sha256;
	cv=none;
	b=wBpxIUr640DUvW2XOGYEe5ANMl42DkNcJHTL7sc6aiYboog2wsZZzTMBhQpmVEBwxc7r/f
	OylrSthKEUaEqHemOEe+fK+JvEESlMlfoXiuTRC65zK5pT+vC7GDg/o2/M03pyAdjCXJ4r
	nDHC5nn0aO82kvYDIqXsNUScneWl2K4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769389453; x=1800925453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XRcP8IljFz66L9N9RGSap4tlNSAvDJZfAmf2dxUz7QY=;
  b=NUbHtmEMY6SxDK3Ii0x6bOTvGEM/KQ29+1saIe+iiy6ONPxC+y3mZ8SO
   m+ghvNZs1extwlLmyF9z4DYmw+n88hfaD8Vk9IQih2RWKsvo1swi4RUht
   lQGRbIwDGkvPCHGm8QSi0Vivk+LmQ6tJTp4NjwB0fL+aywgnxkR9bixew
   K23PAMVhH7NDUP/f/s6BrvEGV2B/aHrr7E3pI7CnOh8WK9fvZTMvW8cRW
   3qvtWyrBKWcp6kuJt4HsLj+68P48fh35DWvDhHBCwnEAufGROOQKA0BRw
   VmebWtVbpov0wXUrYoW1KMY1k0XMdvICyiKScdurcUMyswGA/ippSh5g7
   g==;
X-CSE-ConnectionGUID: 2rxVR24IQkui8axk3zrRXg==
X-CSE-MsgGUID: TznJ/yQeQuuQgPRXJd9JeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="58144409"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="58144409"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 17:04:11 -0800
X-CSE-ConnectionGUID: /40tp3fYT8OGyAs5b86fQw==
X-CSE-MsgGUID: /C8LUwolQhCXGWCwo23Ptg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207150278"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 25 Jan 2026 17:04:08 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkB1R-00000000Wms-3NtU;
	Mon, 26 Jan 2026 01:04:05 +0000
Date: Mon, 26 Jan 2026 09:03:59 +0800
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
Message-ID: <202601260934.Lhdzyzmg-lkp@intel.com>
References: <20260126-swap-table-p3-v1-9-a74155fab9b0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-swap-table-p3-v1-9-a74155fab9b0@tencent.com>
X-Stat-Signature: t4zxfporazrdiqza3kahq6f6hxw1xxfq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9CBB4000F
X-HE-Tag: 1769389452-787462
X-HE-Meta: U2FsdGVkX19GJ+4+9yAB/bborzkHJeRJHjfVvgmh83ZxlaEAQbYRQ61vAc88tZSMN9CwidnfxhaoTBtDf/exZbqkiftYqLR0INu9yYyzQ23KOWmgPfkUK5RojQ2lSTN4T+PyLvttogoiCrw/98C+TF0HCTZy3Q2vmH6oS6YgfpiXRp2HZRpA23Ai9csn33/hoJTjoyzTb8ha7ZwpU7nHVN/78RRyXJMqOMkMfQLLjNUMms/FvqEkPJ9kNf599psrEZa8/sKsIWKgty+AF9PNT3XaynSyvd+YevSDYlOYq3P/ipj62a+yT6EvDrWVhqO4N7M4I4zsxNwvzOkh6c0PeCYV+mVq4C1PaU12FRVE5NEnb6QZCheCqVWGSSJrbdFkn47kfrgoDgSaM5ijayGTbUsgzVjux4v7DocfzLfUe0NYSJaLLWsAE78ujcownD6rChHD2D2fAto+s9ho4vkX2L6sPirIM2AoaDTTylysJtnH8ULj+gNLEDJdwMgtxiKBNrMKUbt1Q2e9+Pi7pnijw46QHcTtCt8eB9jKq/GjU34uIviIdNpKwD7oI3VjuIxvN2tJP33pmsHFjwzcgElaraw8wXf5KP/3c4oUTH+0bFYvWMK+omXzHka3o+G8EvcbrObfnbG/o14jtmHH2jDOgyXhRNJMQp2qzpNRpSTE93Oynqa/QEbPKJF2Zdx8S/tmATGXbCx0D/QagB6eIkbmBtW+uBvyTJ3CZIdSKMxIHIhCqE8HOuI8F0WK76elw42AzWmpYX/1hDwKFzn7UL8DDT4qIL+2vRDsCb3oRHhPsW5InI692hxGbQL4u//CQUqpU8r7W8eWAunlJBRTsaXQcqGqsFQZE+wosGm+daUSpXQ1Wz1bOTTjdeYR1oJKuDPvRS+W7T8yalnyH2pcWKjre/1OHhfcYGMydABWUGQH2aXka3D/CrXCAoTZJrlr5pAyqELbvQ/IX/uNNr3Vf/5
 hmdlC4OP
 bB8JoC7CTXgAI4Dz2KIDBLDl+xJzxpXo0vRkJN53XvCMVO26uJ7BtrngH9quYOd4VceaCf+isrmPczR42p4vAfguGdVpIbNPRCFZDCoeuclGF8vQBvc2Ku2QISKmMveNDu8cYvq6fR+NoFh03G6LTb1jjVfBDwd8uBSw+iuRdlZJwr0Yda079D5GgjKwHUZy0fTYUUumqtNPTy4mj7TP1Y8bGDr4YaUlqpzvK8WJe2Rbk8yEKXV6ytCLyTEemmAg8odl8QJcwpWvTokwEMHE34MWztLFrJkypX/2OJfgFDimUGZOyGimgfb8u+DSXRMioHcL+Zh9kgzfRBu2t5BX8e+iZZLSIEaeskC89H1AZHB0Kj8irVysxhfcjxEFWeTjfhS8b
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
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20260126/202601260934.Lhdzyzmg-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260126/202601260934.Lhdzyzmg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601260934.Lhdzyzmg-lkp@intel.com/

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

