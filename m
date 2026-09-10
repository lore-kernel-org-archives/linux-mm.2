Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6999DC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCFE6B0095; Thu, 10 Sep 2026 11:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140B06B009D; Thu, 10 Sep 2026 11:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23016B009E; Thu, 10 Sep 2026 11:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B89176B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:43:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07432A5071
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:40 +0000 (UTC)
X-FDA: 85198272600.22.0A2BF91
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id B5AA91A000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ke0Hp5ek;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789055018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+SBpbCeAD6o57FQtJyEl9COkk8XXsW31QxtrINw23GU=;
	b=wVf6xY44XxkiThE/fJT0pdSR9uVNMN1UHG4BrUhx3yNmQBVy3Tjf9/Exr1v/fiw9alr7y9
	zKFXJSRr7OcA3LVjkJ6ga89oOxxWTQ+Z+heslqVCJMLIAsVHQvpLHxbRCAy0NBcJdyOV65
	rQ9IWf4l6xl+XuechmVW78BiNjznjZM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ke0Hp5ek;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789055018;
	b=hR3BNRAx98g6Dly3/CrUXIS1mk187cdZ8janiV+880yyc9gX4RbEgbLPFSckvwBVx3F8x4
	0LPZDXfSFNHkbAOg0KOHqSt4R66mbdsP5I8pIt7PRo3e9GXsr9Tu0DcWLX1kxOVOytYYg/
	tcxYtT5DxUj8TEYRqy922/IlEA1NMEs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789055018; x=1820591018;
  h=date:from:to:cc:subject:message-id;
  bh=APtQhSLP5v64rwA65uzWlON02O9fx46Bp5IZaCHaeBY=;
  b=ke0Hp5ekWlgHsen/ifyx0YRB/FtiAFeW+1MeJck2nQjN85ORpSI4H8E4
   IDt684DfGbJ6KNeo23gaQkA/ao1A+OWPxtBHJRaIb4miWGIRHEbAZBNvD
   cxnwmH7TocWbLc22fLzpaBxdYhATZ8TZH4Ru35H5ozfARLeTQQleKrvpO
   5mRJs51XeOKfZ5e7WizcRA8AodCuXTW3yewWzmgNPl1VZupFwoTQ9VRDR
   4mxtmhPzBQy+UepcSTMLUcwSAdnQ5Cndbz6qLzjXqwtVgmU9KeCMGZ6lZ
   w0J11YRA8a9zIs8xjIcDtt8zaM4fq+JQOyILSsCULE2o7ZpE62aJuYyDX
   Q==;
X-CSE-ConnectionGUID: 7cAGnfoWSeGozM9PA09CVQ==
X-CSE-MsgGUID: 4rMbrvY+Tyu6Y5lz1hmVGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="93200695"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="93200695"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:43:34 -0700
X-CSE-ConnectionGUID: ML1rlYKQRBGLkAIGYT/jhw==
X-CSE-MsgGUID: DjgB8EBKReqmRYuOGP+O9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="301572130"
Received: from igk-lkp-server01.igk.intel.com (HELO 2232cf45ba3c) ([10.211.93.152])
  by orviesa002.jf.intel.com with ESMTP; 10 Sep 2026 08:43:31 -0700
Received: from kbuild by 2232cf45ba3c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4gvx-000000000RD-2y6a;
	Thu, 10 Sep 2026 15:43:29 +0000
Date: Thu, 10 Sep 2026 17:42:37 +0200
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer
 without a cast
Message-ID: <202609101047.wFyYfjz9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5AA91A000C
X-Stat-Signature: rcctchzcfxxkfg58eygzs5uphuh3ym1b
X-Rspam-User: 
X-HE-Tag: 1789055017-381204
X-HE-Meta: U2FsdGVkX18KvQz5ebmCru5h6RrTATpuq4fZJ7AOdHw2ve/cDq4TUX/RVkcgJScfqV3XnHhKnfEmQQ8mDD7EPMZobthkmlCsy3JeV+zFDH2rWvp4xQrEEA6XVPpA/pP68VHBzfLuRqw8wAujj+Qis7s9zJBn2TNS5AkRX0VLN4UpLWv/AQeDYSMXfixXUJcphKhegHr71ybExz1h+fiQI6J4ln23i1DO1gLZ+r6YTred/qIGdHbcDqp0iCuYjyM2AATxKocUCa2Sfq1ezZRE9tAmvRCHeGKaZIBwJJuqDXGwCDnu64EAiScs0AaSZSqB/2l6Z7buGSeMhyQU8SZCnFC8QQ18836GBZwXa9kcdH+jjZ7AkE/LwLtgxzQ/tIbfmZ2hIZeTLHjL5cHikGStYU4nu3APGptzvOQoL5qw89uXs/LwVczID7RPcO7C1H73nVxSnsVTrnYhVENEY3aYruRNzhSO6inh4skEbERUJLtCauAnZBqb1qE2l4hxOWwJMBg0K3fymGjfE37gu1fhQ4/tvAm6Bk5Hq3twF8OCgrPTqOjZoAwF48E6HUjMaMczbyujA9CrnjEOB8TjTfeN7agzKLQZ2UmzAZd1S5HU+RO6AHmVK23bR92wGGOgOtVWDyLmucSZi5BTlhC4X3z7ya0IOEV1JIMz3l/S2gszF0uq76gRvFhZhSsh0PIxJDFRQRhs4X78xCdGwXMkRe3FXcY9+c2bY+DjPX+6QT0ssYOqYK5EF9AMGDxaCZs+pSgsXIS2WpWC0Pep4qEttThGsRFD425aXU3gHCItElDanEpOSHNeZf7+R4L6Tmm8RkBb7goQSKotYm/YNCYHBWoZI3NMSOca7XaOkrWDGKqBNi/c/c6Z6tk45wazJovZN6MmXLdyjH8teH1DBgO0tnpyZxoEqDwD+NqX8wsuKIUe3fWq+d2xSWWwafFd6x3xNECc9e8Z9G4eQlal3fWF+wN
 WckXcbRV
 WganQlRnAHKRbhjotmFmzZ1fEDgGTk4FuhKlYFEu1It24bIDa/KpDdJH3zuXEFAVUS36/vpqK8J3VDncEg+xZNxTMMmQJiMfwmDI9x/Q6bJGGWs3vSLsDFpyptIhpmH/F3+Dfp7yth09nwwPIJ3YxSs5QVZGSTGdiZ71yy7hPLD4lw/i3Ga0gTS0nrs8SsrqOqveEkFgVHm1FLQOtErkSSZXeZVHzlw32VP9KAoaVJRcvI4CXKrw6svI0JMSe/FVilC5vBa2HrAimSt0IZz3yzIyvtmDiABDRPG7EBKXcUiaRdsj/an168IFVR7HH8rFPYofNSfYZNVMPCfIoG7YnT+mIJSt7X6c/4gID5DyTZydAt6EcqGIYV0u9mlQ5VCFZf09ecSQmaIP6Oam/9M+0jPgAobZF3/9qSDWN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   cf558a250cf4475a8936902b8978fbb6c61016f8
commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260910/202609101047.wFyYfjz9-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609101047.wFyYfjz9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609101047.wFyYfjz9-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
   mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Wimplicit-function-declaration]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~
         |                                                device_move
>> mm/sparse-vmemmap.c:507:48: error: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
     507 |         page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                ^~~~~~~~~~~~~~~~~
         |                                                |
         |                                                int
   mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argument is of type 'int'
     172 | struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
         |                                                                 ~~~~~~~~~~~~~^~~~


vim +/vmemmap_shared_tail_page +507 mm/sparse-vmemmap.c

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

