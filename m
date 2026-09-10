Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 662E7C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4B36B0096; Thu, 10 Sep 2026 10:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4739B6B009B; Thu, 10 Sep 2026 10:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363946B009D; Thu, 10 Sep 2026 10:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 073AC6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:41:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41C551C2554
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:41:53 +0000 (UTC)
X-FDA: 85198116906.22.9BB9AA5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id B0FA5C0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:41:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kY8kccdu;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051311;
	b=qyxU9jif0TG/iMkZLAtqLxC26QcdiqxjUCX1jbYEa9ws0BsIvyiy8WcxjGK2jHQbgvSDTX
	stp1+KVpEAqILWWttgGfPE5K7U/YQUROPo67vL1mFUDMFNZYQteAUyLm9vBzWGt/mBMzKe
	vg/a7LaOmTjeh91kTsrkNEWy4ZOxu3k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kY8kccdu;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mU3K5+jau8+iCxdCzIePFTHJ/DZz5fC5+egA358ciJY=;
	b=PLq+rxGXfXPxw73HhwlhOqvVXt1XokR0cjuOb10w+5DHehC7r53OC//C6FyCP0Sz8X+kgA
	jwum3dseSDZJ/iVOcksXywQNzOBGRERKlnKq+Te5u4r9y+94HPnG4LZHY4wwcugrqOUHyC
	SXHy8kUlEZC/WhAVIeJ6qouWvMvWNeA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789051310; x=1820587310;
  h=date:from:to:cc:subject:message-id;
  bh=R8KaQwcEEbcL1aXyhF5pAZylzGCyNoHirqH1AYSFaj8=;
  b=kY8kccduUVWN19tPH07kqdq7Vo9AVfHHb5sdvKQfOTqcyP3/rhRmMeAE
   qoo/TrH/jEAGYzZzLj+6y9vq0JoHSXJylMnpCdXIlfAwbrXFWYEgkY0Vm
   qQVAjd0WEykm0+QIppAHQgxKmWLfUlhq2lK62QmKVubFSXK9byixj2W/I
   hcwiGTaCSczGw9TOC8cPE+um/QDThGS+kuBDdxvuvQRC9S9cRT7ccGvpx
   Q0FMqIzfpKrWH3iymP+odVsq+zrvHhSLIafyqCxgY+VZUUXjyUTdnBhZp
   2245WXXY1KF1tdaTRsJdF6jrutoRQxJwLGtZBlpGv+hLrhs/xxAhfZhlc
   g==;
X-CSE-ConnectionGUID: EZxs0P+iT4WI9WSMiSGleg==
X-CSE-MsgGUID: gQQwcouyQQy/nQw+j1C52g==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89542880"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="89542880"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 07:41:49 -0700
X-CSE-ConnectionGUID: caQsilGcQei5gmFcYG8JiA==
X-CSE-MsgGUID: NjDI8RGrQe2OJT7FOjDWRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275436798"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 10 Sep 2026 07:41:48 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4fxu-0000000007e-2lRZ;
	Thu, 10 Sep 2026 14:41:31 +0000
Date: Thu, 10 Sep 2026 22:31:47 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 implicit declaration of function 'device_zone'; did you mean 'device_move'?
Message-ID: <202609102250.lIycVv3n-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0FA5C0008
X-Rspam-User: 
X-Stat-Signature: uyy5gh5t3hh7wz8qtxifrtt9emqurho5
X-HE-Tag: 1789051310-457798
X-HE-Meta: U2FsdGVkX19RSh6wDUTnaclJlHkKeHE2u2xZBt04/SuLUcm71vor0pn2IXqkcfd6dk2bQFP1DfwVOn3IkcGuBabWWuTMYX46cQhseQG4/oHS/KstSwASCSJVF3NNPGAaS6maDWxrgU2WzcPPbQKo9k53RRYxyijHkDTlQNW2LEQfQYNey1K0U2a0xUHlBJV3SalzGwdpPNuuzgdiu60F54Hz0BU9+KFskzUfdyHzVZnsueS2eRmNMSdhpeuKY0xyOJv4FTPl9rnYN9UnVUKROmyDA4uf9vzSmmG+7qhIWpVpgzgWWVXW4jjxctBoGFMQlPnDD37SSXrICQuhNAkeDfWXra4lNbXVRhu30mKqwohxRmForKG5Gbss/CaBeJ4PttE56u5JZV/9sp8X3zZlAuK2OsXDgSk6zYe84CVi4ExQDyshitTAfJBr6mQdui9KbK8oOxCY2fEOZ3Wd6TDBq/1W4mT316vZJIPjWtokrLHP/5h91qYyAkijtfS77QeqnRKN9zgcvhLJ1y4c9NHqbfkwZFZe9SBmND1sqRsnKpsqC83otvXksAbIC7doXc16rfGFVsFx1vTC7i5287BEzzNCmckK95BWonvDqoqkTgpk6/eb5dWNNgu4R435wRe21HK2q9spFJvbAzRvP+AvDiWr711CfC0Xtk1xcTNV9sYgRU7kw0nTgn0pE4e44tpvNRPrD+1Frj22t2pg2gc4qL83bHod6YYV5kuzDgcI/4XEHjywHyuw8hvr/21A7n7KnetobFGsLrLgW28Xto0NLRztg6NGr2WDjK76qGmNAKH+keAVvrqEjEhDj+PVZqx6rUqAs7r07chRhOxnRE2dYax5ih6zH1aGmceFB2YIB2FFSAbT8z6UJGehdDqEHdSGXzwLl90CKpHKIb74cfz/WLCysoYAmyqoauY/THEXXxpeAqpRGm/CbHy8iKzEAI0IMYXDt/ySFwnzIxmgbsc
 crNeuY7e
 gIVtR+RMDdts6UkRd9kthf+DxpC75ObuTMAYd+Jqf3fR3KZREwZhZeQsbI5gMTRGwH/lW9RdsZEMBWf6rbykc701HxiEKWGRShY9hPLt1qsZnfjJv1+vvx5FuyF2vakq+i2Xq6kksJN1naYCQAbk8jhw5+rd/VgWkbEyDHnv29t6IXTnSor6X+d5a+arL56+IAvKIca2087aIRaZke8s2fv+PzhwyVD6Uo+RsEHBR9CeWsGz0jLw8JOw1OtXQK4Tw/m+TvBX78VaPj7SUuiBqRka1cg/6uPGU29X8uKQnip2FnXDs4NboH9pAh2v0tN3LM/lfHfVtQgc2ocAgdCjHFYurAxQYqIQBczxFibJtl2AWJQfcgo4BHUpqVVrH56QUyo8mD2hZlMzhd5utdL5YljSqmhkwKYPusewnXuSVyS4Qu5MNJNC3XbjE+25dsh3xF+KDR147hPAXcoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   cf558a250cf4475a8936902b8978fbb6c61016f8
commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
config: s390-randconfig-r121-20260910 (https://download.01.org/0day-ci/archive/20260910/202609102250.lIycVv3n-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.4.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609102250.lIycVv3n-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
>> mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Werror=implicit-function-declaration]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~
         |                                                device_move
>> mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~~~~~~~
         |                                                |
         |                                                int
   mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argument is of type 'int'
     172 | struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
         |                                                                 ~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors


vim +507 mm/sparse-vmemmap.c

4917f55b4ef963 Joao Martins    2022-04-28  494  
4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
4917f55b4ef963 Joao Martins    2022-04-28  496  						     unsigned long start,
4917f55b4ef963 Joao Martins    2022-04-28  497  						     unsigned long end, int node,
4917f55b4ef963 Joao Martins    2022-04-28  498  						     struct dev_pagemap *pgmap)
4917f55b4ef963 Joao Martins    2022-04-28  499  {
4917f55b4ef963 Joao Martins    2022-04-28  500  	unsigned long size, addr;
4917f55b4ef963 Joao Martins    2022-04-28  501  	pte_t *pte;
4917f55b4ef963 Joao Martins    2022-04-28  502  	int rc;
d1d11861d8a018 Muchun Song     2026-09-08  503  	unsigned long flags = VMEMMAP_POPULATE_DAX;
8fbaacc4a64bd1 Muchun Song     2026-09-08  504  	struct page *page;
8fbaacc4a64bd1 Muchun Song     2026-09-08  505  	unsigned int order = pfn_to_section_order(start_pfn);
4917f55b4ef963 Joao Martins    2022-04-28  506  
8fbaacc4a64bd1 Muchun Song     2026-09-08 @507  	page = vmemmap_shared_tail_page(order, device_zone(node));
8fbaacc4a64bd1 Muchun Song     2026-09-08  508  	if (!page)
4917f55b4ef963 Joao Martins    2022-04-28  509  		return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  510  
8fbaacc4a64bd1 Muchun Song     2026-09-08  511  	if (reuse_compound_section(start_pfn, pgmap))
4917f55b4ef963 Joao Martins    2022-04-28  512  		return vmemmap_populate_range(start, end, node, NULL,
8fbaacc4a64bd1 Muchun Song     2026-09-08  513  					      page_to_pfn(page), flags);
4917f55b4ef963 Joao Martins    2022-04-28  514  
8fbaacc4a64bd1 Muchun Song     2026-09-08  515  	size = min(end - start, (1UL << order) * sizeof(struct page));
4917f55b4ef963 Joao Martins    2022-04-28  516  	for (addr = start; addr < end; addr += size) {
55896f935a60b9 Gautam Menghani 2022-06-12  517  		unsigned long next, last = addr + size;
4917f55b4ef963 Joao Martins    2022-04-28  518  
4917f55b4ef963 Joao Martins    2022-04-28  519  		/* Populate the head page vmemmap page */
d1d11861d8a018 Muchun Song     2026-09-08  520  		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
4917f55b4ef963 Joao Martins    2022-04-28  521  		if (!pte)
4917f55b4ef963 Joao Martins    2022-04-28  522  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  523  
4917f55b4ef963 Joao Martins    2022-04-28  524  		/* Populate the tail pages vmemmap page */
4917f55b4ef963 Joao Martins    2022-04-28  525  		next = addr + PAGE_SIZE;
d1d11861d8a018 Muchun Song     2026-09-08  526  		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
4917f55b4ef963 Joao Martins    2022-04-28  527  		if (!pte)
4917f55b4ef963 Joao Martins    2022-04-28  528  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  529  
4917f55b4ef963 Joao Martins    2022-04-28  530  		/*
8fbaacc4a64bd1 Muchun Song     2026-09-08  531  		 * Reuse the shared page for the rest of tail pages
ee65728e103bb7 Mike Rapoport   2022-06-27  532  		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
4917f55b4ef963 Joao Martins    2022-04-28  533  		 */
4917f55b4ef963 Joao Martins    2022-04-28  534  		next += PAGE_SIZE;
4917f55b4ef963 Joao Martins    2022-04-28  535  		rc = vmemmap_populate_range(next, last, node, NULL,
8fbaacc4a64bd1 Muchun Song     2026-09-08  536  					    page_to_pfn(page), flags);
4917f55b4ef963 Joao Martins    2022-04-28  537  		if (rc)
4917f55b4ef963 Joao Martins    2022-04-28  538  			return -ENOMEM;
4917f55b4ef963 Joao Martins    2022-04-28  539  	}
4917f55b4ef963 Joao Martins    2022-04-28  540  
4917f55b4ef963 Joao Martins    2022-04-28  541  	return 0;
2beea70a3edc03 Joao Martins    2022-04-28  542  }
2beea70a3edc03 Joao Martins    2022-04-28  543  

:::::: The code at line 507 was first introduced by commit
:::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages

:::::: TO: Muchun Song <songmuchun@bytedance.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

