Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C5DF43689
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 10:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B505A6B00D2; Fri, 17 Apr 2026 06:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01936B00D3; Fri, 17 Apr 2026 06:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A175F6B00D4; Fri, 17 Apr 2026 06:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 910606B00D2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:02:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A81C01B91C5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:02:33 +0000 (UTC)
X-FDA: 84667608186.07.D09191F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id D35CAA000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:02:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U2rmSJJt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776420151; a=rsa-sha256;
	cv=none;
	b=RjBpO4DonICfFTW7v5fUxiq5i40WXjNEYcJeSOoSlp1M04nOROoL2sYipOnXVRboHO2mLb
	c6rAhvmxyvr8SjHfNtgHn/y4vCbiRNyDnv2IyC8G/eg2DdyCTywYreQqWWoe26/Ac6B/R6
	2jYKL+FmQSP1I9t+45QpdtkfRJkJ6Hs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U2rmSJJt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776420151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Hex+EbXJGejSuOhmB64ekPEq2ZYhYwLjSXWdhSFN71c=;
	b=Vh6IWGVjsKGpBp2Q6xSyWt83QYk48AD5C7SSwRby9WklAz2blTrUniq+zP7Hd0uexjhasN
	uxa8CQXKuWXYt/RdwxDOfVAMsoQzoqfyu3d9SypEb013lpVa99kfcTbGAp1y9BDWBynd7V
	Tb/ExBHvJv8YG1v+MHMLWoQJzHuVy7M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776420151; x=1807956151;
  h=date:from:to:cc:subject:message-id;
  bh=dSV6xuUYZ7DtAUwZBTQNUQfsHXf3jKjiBNh2dosyCIE=;
  b=U2rmSJJt3puWo2FQ56oWf8jugYhcae75vFFlotYNmxo1z17yW/GXHPa0
   wteZrgLDg9FAaVDtv1WUZqe0mTtX8+C3njz8EA8eCUeCg2MYhrnRJ8bpo
   7VL0OgUtEJyjCTHIZfEhSV4f8+VCG6CPHfTZRn/utVNhCZMuxX4nvoBkL
   /ezytrsgPLd2mgQkQcZu/1ajLGV7cAZ+dtC+dSI7YrY/IRJUZlYKpbMQy
   hqkVhS0O5EexvX21Ark0EyzLNY7N9EfLglwRbFUE79Zxtn1xLIFbqWnWx
   U+ja1BV9BrvnYt+YJ4MAAsRi/2WaxzCLm4MeRgvRrsG3X5E5MR4XG7nkK
   g==;
X-CSE-ConnectionGUID: jUkG2jTJR7qIH7dppCZ2mg==
X-CSE-MsgGUID: RLJNF1HAR26/e7aY+dya9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77134589"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="77134589"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 03:02:29 -0700
X-CSE-ConnectionGUID: RlwO/DlgQ9a04nH2Gcpwyg==
X-CSE-MsgGUID: 0qth6167RqKe184jNxLfTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="226651740"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 17 Apr 2026 03:02:27 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wDg1o-000000000D7-2Iwp;
	Fri, 17 Apr 2026 10:02:24 +0000
Date: Fri, 17 Apr 2026 18:02:19 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 163/164] mm/sparse-vmemmap.c:766:35: sparse:
 sparse: cast removes address space '__rcu' of expression
Message-ID: <202604171755.GRWIpPjV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Stat-Signature: m5j7a7zwxhi6k5tfqo64z1gtciywyfdw
X-Rspam-User: 
X-Rspamd-Queue-Id: D35CAA000D
X-HE-Tag: 1776420150-689334
X-HE-Meta: U2FsdGVkX1+dkroSfYz9chSPW3UZbqWy8270ft6b7k38XES1vsDXwfbYPoebB6LDHxbi2nynEr66W3LYCb5YAVAAO3uWaUihPH0qCt/K7UISAauO1ylUft+JZdZuBO3P14ykMtTYZMTCQYIYvASZj/h7Ec12ZezC68I6kZa2nCQcofGkn+RmZaR+KExE5nZRTBhKYXZ0aORDQw+l2+oPN5EHw98sjS7iv754fGs0C8zV2mtT3+EvUg1KEIP10+1AZFFlWmuO2+20SKN8QPI3Fi9qZi7EkWrrWQ6V5GfmdVKwo1YfJ09wKRqZqvg03QA0beU70cH8da6c9cLbYS0n7OICp6cLkLNdYddJBLhjFDvSk6SCXtggXgyUdkOr+XP2vQ43CMMDmtpocQOZrN5WGdV3YptlDbi44thoEb6a9FmzIhpi5rOORf92u8HFqynrp9wTE6uMfnu45Aoghif+X4Jvwo33CT495Xd+rkaLVHb8ZS3hbdw8hiUXUdULKr4FxIVKYDmv+frNVvFe2WTsPO92mugjfLhltPjbc/WlfTDfODcsxFrI4JcQdXnZ66ba+Pdtp7UTMOCfDI4yUc0O5d3wjhEATMmrLWLtxjgrIaIdjKhNi6VI4Oywqaed9QAtaAKNdzUYu5PrIPHLkMehzfCWcMo1idxnyJHuNjQrWXBjyT8JgkYDIa8uKfyte448dtq5TEXfNYMrkCWvT04F555dfwKVY4Qz14QnD0MoOBeNPzjCUmqsIu+ut7cfFyTKEfZNrBxViZBYVqVbW/dIYjjLcprG0hbdQGrWf5neZC2QKeXHUmrZkTciftmK7Ff/fcuFYzmqY+xfPReo0n28kISnW2HbpsZgaA5IWPe6cNCqtbl1u6ntcXq+Qq4db+z1gu1X1Ep3FooozcUvW2ZA942cJ4p0Zd4mgRarEF7xfb4A1aL7MQsz37gsMOBpZiKzuGmT4CCV7fxHQQT9zDb
 4gFRXuOx
 GBS42Kl1pwhHm7TxF7ZkQSkjm2VvOucnWR2oYytkKH4ToORewg80JoJuxkfn5zbPuycBquNFnl1AEs4udkGrRTHWNhyd+nQIPOAOo7wlU/e4N77r0X7hhyNtlzzmvzHcXz/xYuDLEow0FOCsOf2oGAq4ifHCTtCo7RYMJYsxMgBk2FimXS/9IXKXzpgQwG2qs/ezPKGsdJNXSVRZ/561TAYqj3159PMPKVqX8j0tcyjoxKo2Fb9mCneY6N9EnUSsJqAwxK1JVJb4I9uKduHhi+ApyTjPcMoxTyNywnnD4lrWaETPSwkgVadaYNW1aWCMQmSRq96IW6NQpoFilTFJSzZedSfiNN/XMm+y6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   ee03ca7d1cb1223d0e14dfd3b48478545af75253
commit: 8568f268a5183e0fd5fbd33569b6513038b62f27 [163/164] mm/sparse: fix race on mem_section->usage in pfn walkers
config: arm64-randconfig-r122-20260417 (https://download.01.org/0day-ci/archive/20260417/202604171755.GRWIpPjV-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260417/202604171755.GRWIpPjV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604171755.GRWIpPjV-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/sparse-vmemmap.c:616:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long *map @@     got unsigned long [noderef] __rcu * @@
   mm/sparse-vmemmap.c:616:39: sparse:     expected unsigned long *map
   mm/sparse-vmemmap.c:616:39: sparse:     got unsigned long [noderef] __rcu *
   mm/sparse-vmemmap.c:684:17: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected unsigned long *subsection_map @@     got unsigned long [noderef] __rcu * @@
   mm/sparse-vmemmap.c:684:17: sparse:     expected unsigned long *subsection_map
   mm/sparse-vmemmap.c:684:17: sparse:     got unsigned long [noderef] __rcu *
   mm/sparse-vmemmap.c:701:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long const *src @@     got unsigned long [noderef] __rcu * @@
   mm/sparse-vmemmap.c:701:55: sparse:     expected unsigned long const *src
   mm/sparse-vmemmap.c:701:55: sparse:     got unsigned long [noderef] __rcu *
   mm/sparse-vmemmap.c:714:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned long *subsection_map @@     got unsigned long [noderef] __rcu * @@
   mm/sparse-vmemmap.c:714:24: sparse:     expected unsigned long *subsection_map
   mm/sparse-vmemmap.c:714:24: sparse:     got unsigned long [noderef] __rcu *
>> mm/sparse-vmemmap.c:766:35: sparse: sparse: cast removes address space '__rcu' of expression
   mm/sparse-vmemmap.c:805:27: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mem_section_usage [noderef] __rcu *usage @@     got struct mem_section_usage *[assigned] usage @@
   mm/sparse-vmemmap.c:805:27: sparse:     expected struct mem_section_usage [noderef] __rcu *usage
   mm/sparse-vmemmap.c:805:27: sparse:     got struct mem_section_usage *[assigned] usage
   mm/sparse-vmemmap.c:884:59: sparse: sparse: incorrect type in argument 4 (different address spaces) @@     expected struct mem_section_usage *usage @@     got struct mem_section_usage [noderef] __rcu *usage @@
   mm/sparse-vmemmap.c:884:59: sparse:     expected struct mem_section_usage *usage
   mm/sparse-vmemmap.c:884:59: sparse:     got struct mem_section_usage [noderef] __rcu *usage
   mm/sparse-vmemmap.c: note: in included file:
   mm/internal.h:987:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mem_section_usage [noderef] __rcu *usage @@     got struct mem_section_usage *usage @@
   mm/internal.h:987:19: sparse:     expected struct mem_section_usage [noderef] __rcu *usage
   mm/internal.h:987:19: sparse:     got struct mem_section_usage *usage

vim +/__rcu +766 mm/sparse-vmemmap.c

738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  726) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  727) /*
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  728)  * To deactivate a memory region, there are 3 cases to handle:
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  729)  *
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  730)  * 1. deactivation of a partial hot-added section:
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  731)  *      a) section was present at memory init.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  732)  *      b) section was hot-added post memory init.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  733)  * 2. deactivation of a complete hot-added section.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  734)  * 3. deactivation of a complete section from memory init.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  735)  *
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  736)  * For 1, when subsection_map does not empty we will not be freeing the
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  737)  * usage map, but still need to free the vmemmap range.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  738)  */
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  739) static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  740) 		struct vmem_altmap *altmap)
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  741) {
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  742) 	struct mem_section *ms = __pfn_to_section(pfn);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  743) 	bool section_is_early = early_section(ms);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  744) 	struct page *memmap = NULL;
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  745) 	bool empty;
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  746) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  747) 	if (clear_subsection_map(pfn, nr_pages))
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  748) 		return;
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  749) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  750) 	empty = is_subsection_map_empty(ms);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  751) 	if (empty) {
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  752) 		/*
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  753) 		 * Mark the section invalid so that valid_section()
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  754) 		 * return false. This prevents code from dereferencing
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  755) 		 * ms->usage array.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  756) 		 */
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  757) 		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  758) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  759) 		/*
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  760) 		 * When removing an early section, the usage map is kept (as the
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  761) 		 * usage maps of other sections fall into the same page). It
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  762) 		 * will be re-used when re-adding the section - which is then no
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  763) 		 * longer an early section. If the usage map is PageReserved, it
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  764) 		 * was allocated during boot.
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  765) 		 */
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20 @766) 		if (!PageReserved(virt_to_page(ms->usage))) {
8568f268a5183e Muchun Song             2026-04-15  767  			struct mem_section_usage *usage;
8568f268a5183e Muchun Song             2026-04-15  768  
8568f268a5183e Muchun Song             2026-04-15  769  			usage = rcu_replace_pointer(ms->usage, NULL, true);
8568f268a5183e Muchun Song             2026-04-15  770  			kfree_rcu(usage, rcu);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  771) 		}
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  772) 		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  773) 	}
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  774) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  775) 	/*
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  776) 	 * The memmap of early sections is always fully populated. See
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  777) 	 * section_activate() and pfn_valid() .
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  778) 	 */
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  779) 	if (!section_is_early) {
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  780) 		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  781) 		depopulate_section_memmap(pfn, nr_pages, altmap);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  782) 	} else if (memmap) {
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  783) 		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  784) 							  PAGE_SIZE)));
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  785) 		free_map_bootmem(memmap);
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  786) 	}
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  787) 
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  788) 	if (empty)
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  789) 		ms->section_mem_map = (unsigned long)NULL;
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  790) }
738de20c4fafe6 David Hildenbrand (Arm  2026-03-20  791) 

:::::: The code at line 766 was first introduced by commit
:::::: 738de20c4fafe64290c5086d683254f60e837db6 mm/sparse: move memory hotplug bits to sparse-vmemmap.c

:::::: TO: David Hildenbrand (Arm) <david@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

