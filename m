Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28391D37E3D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F436B0088; Wed, 14 Jan 2026 09:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECFC6B008C; Wed, 14 Jan 2026 09:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820496B0092; Wed, 14 Jan 2026 09:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 717BB6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:58:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E52FD8BF76
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:57:59 +0000 (UTC)
X-FDA: 84330874278.04.85B7178
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D78520006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:57:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yuoc2KhH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768402677; a=rsa-sha256;
	cv=none;
	b=7t847MOVEB5ZBq9shKp2uLpvrrEaMa7mqIRM2eoIbZGq6fATZ4TjHA/lVFj3KwpGKMbxQM
	ww7jjUr7DUy/5i8+UyPS88IMkXl8eC4IZEaeclRjhVL7eMweeqLVuY3IRTC7KM5WROPPOn
	guhK8DmpXqA9kyxhdU57JPag3RQXu0A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yuoc2KhH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768402677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kMOOHovPFqNdPW3v419Vpdi4zpW0ewRV/ZPKYJAiDo=;
	b=h/fmAqAFfWhXqbBEBeBFMNS+TYOdrW02E2eEAniJMs9ewszPXSsIR/WM3U9/SJMHibdlvX
	x3zYNHnG0/9p1zt8olLkFkxU5co/ykUqqzJRobfr6VMQdheiN/IaSwa/A/OhPjX4r0AxMY
	p/s3tieFEnn0SXip/fpLltYWcQ89z9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768402678; x=1799938678;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FslN2L09yYFbdDNdXcQIOdZUN9q5mwNNHyvbq2eRO9o=;
  b=Yuoc2KhHmKGeXCiklF3Munenr58FKg2HAbHxA1KCWspC1v+uZbRC7sGX
   xeUWMi9Jo5NiaYkrxcGFMwh5XAjiaiM6CQ6H5GLU4h1nRZkuHAKaWF+xR
   7+okPpX+h3Xs+FQuDn8AUTxkb1oCEiCCzK/o2Arp4g32BsTUpXr1+bxDX
   pP262BgfLZ5eLIA7CXoBYECiArv+9MgII/97kY+LnfMq142JsFqvAJ7XG
   +Y+6MS9HxH1OQJiZyKBGXtfhvseS/7QDUZ++szWoqTvbr2S1JlqLH0vsf
   mgjFjXJMegcfHBDachfyENeumXLr8v2GYdIBDH3xJs8iPy2gD1+hSzoK9
   g==;
X-CSE-ConnectionGUID: hIF6OokBT8ujniA6tgGFag==
X-CSE-MsgGUID: QE8kMK/3TiKBI0HB5dDEPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69622454"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="69622454"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 06:57:56 -0800
X-CSE-ConnectionGUID: s1J9TIOqSo6jHPDZE2Z4JA==
X-CSE-MsgGUID: +l7YJBXmRZSVvVtkW6Wg2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="204723017"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 14 Jan 2026 06:57:53 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vg2Ji-00000000GW8-2mSy;
	Wed, 14 Jan 2026 14:57:50 +0000
Date: Wed, 14 Jan 2026 22:57:19 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601142231.LW22PqTJ-lkp@intel.com>
References: <20260114091923.3950465-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260114091923.3950465-2-mpenttil@redhat.com>
X-Rspam-User: 
X-Stat-Signature: qagyaiuaq9e4nqe5w66e7rcxpzn9qbqc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D78520006
X-HE-Tag: 1768402677-866367
X-HE-Meta: U2FsdGVkX190EvXj7xERkMgeGrB7wvcQMiwp52gIxPta1qWFWStpXo4PuAYvOtCADEryHKehheV1NjlYssOZ530h6fdpQFSrwHTafiYKS0+zBIJoVR7OWiNfKjvKHHsucdMbHk2BaLcUZxgeOj7sFTs/2SzQhkAYM4Kyf4W1lxrZ1sdF5deKDA8CN5HCBbvdWoM4DCP2Lnl1mQXznMxu36IbwI0q5NAsmXvLNJbjRs9kgYC49/B3r0/RY9HvyBTn4cEQ7Hx7bnXYi5aI9Xmrzp4XPKEZaExUmDjgkoIboZYerJF94Ajv+37LKV4e0Gyv1Rh2ArWGmcSq6uSdgBE2/DQxzO9avTj9QbFYdAGl3Fqf907ZI5NRFue1uxuh38xpBrK2ejASSvbx9hQz6SeimL8UnVqg8hZL2GUkjS+Psyk7R/0i23hn9iQ4875LoqY8ObFfok4xnpxB5clr8ie0kZ29ghKhKlmk20P5+YGsHti0wryr04T6BJoyZu3nZDpjnvYPPkhAOTy8lbCO3vaaeKIqml0qzMWqmPkUrcvi2SFWtyXr33jFxnpONsu3p9OJrsWg6U/syGCCeSdAvRb0cLSToMf5fUzndvs82DP01qGgRd+aAQTRAPDPb2/uu72rHeQ1zpCEYisGWdvKg1DqLM/tN4VmixlJMycosekoqd/wGZeeodA6kre1/eqmrL35wH8wWB6CV9ste0BAvGSpDZmdKAdsH46w8+RzMNwEyxn8FgnybTcJveaYwK66MPyIen2awOy6z3p0pIG/1DSfaFxe+GR1J2CsKbdug5Onfk6n1PRqWB4UFRRfJXSuGZFnxUB/YvaFtS2Fa5J55CRLIQaFbkA0mPFBsVQU9xZD0BdDI5YcDbf6NLjEzD1pBeunOYbMkTk+TwmC54KKyfN0e8/S1hHyf0BvR+SYmpm1v31uaMnO+SDZQIwSPVuX+QUS98sKxmSciCIquZpdZiy
 3EIdUxJK
 boBcKLmx+7QBb2NtKN5IIl3179KvqQFI08E2Gi9NsasFXh636GD5rKrehePsfyu4mkG3ysa8woIm+/aBhNHY10G/JQx3e7EhFSJ1nRV1n+w8ytoLFB4EEpFgzsgD0HsGeQE824is13+D/Gcpw9xHxSPHD1tBZ/Ako4yL01vKBEsnibBzRrXrQ4MSqfWPwY8HBoqENAGc9relUB0Q8YF9T+qG3Rzvp+FyVmRpQd9F5wOkM7t3C0un6MEZREjYAdXczqdRExVBAKgvE1dhmGyR0mXZfnIkpIRtLD4t9GqFdNGN7nzRId0DugSjHBt8KnUoffuD9PVXIsBo6GkwatlAsCV6I8MaC2wazldqKW8mnJB4G8Ek+sNMQcjYVErS7MKeN6uF16EWhVH14aAq79r8Lwqmc7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on linus/master v6.19-rc5 next-20260114]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260114-172232
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260114091923.3950465-2-mpenttil%40redhat.com
patch subject: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20260114/202601142231.LW22PqTJ-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601142231.LW22PqTJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601142231.LW22PqTJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/hmm.c: In function 'hmm_vma_handle_absent_pmd':
>> mm/hmm.c:423:27: warning: unused variable 'range' [-Wunused-variable]
     423 |         struct hmm_range *range = hmm_vma_walk->range;
         |                           ^~~~~


vim +/range +423 mm/hmm.c

53f5c3f489ecddc Jérôme Glisse   2018-04-10  369  
10b9feee2d0dc81 Francois Dugast 2025-09-08  370  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
10b9feee2d0dc81 Francois Dugast 2025-09-08  371  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
10b9feee2d0dc81 Francois Dugast 2025-09-08  372  				     unsigned long end, unsigned long *hmm_pfns,
10b9feee2d0dc81 Francois Dugast 2025-09-08  373  				     pmd_t pmd)
10b9feee2d0dc81 Francois Dugast 2025-09-08  374  {
10b9feee2d0dc81 Francois Dugast 2025-09-08  375  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
10b9feee2d0dc81 Francois Dugast 2025-09-08  376  	struct hmm_range *range = hmm_vma_walk->range;
10b9feee2d0dc81 Francois Dugast 2025-09-08  377  	unsigned long npages = (end - start) >> PAGE_SHIFT;
0ac881efe164685 Lorenzo Stoakes 2025-11-10  378  	const softleaf_t entry = softleaf_from_pmd(pmd);
10b9feee2d0dc81 Francois Dugast 2025-09-08  379  	unsigned long addr = start;
10b9feee2d0dc81 Francois Dugast 2025-09-08  380  	unsigned int required_fault;
10b9feee2d0dc81 Francois Dugast 2025-09-08  381  
0ac881efe164685 Lorenzo Stoakes 2025-11-10  382  	if (softleaf_is_device_private(entry) &&
0ac881efe164685 Lorenzo Stoakes 2025-11-10  383  	    softleaf_to_folio(entry)->pgmap->owner ==
10b9feee2d0dc81 Francois Dugast 2025-09-08  384  	    range->dev_private_owner) {
10b9feee2d0dc81 Francois Dugast 2025-09-08  385  		unsigned long cpu_flags = HMM_PFN_VALID |
10b9feee2d0dc81 Francois Dugast 2025-09-08  386  			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
0ac881efe164685 Lorenzo Stoakes 2025-11-10  387  		unsigned long pfn = softleaf_to_pfn(entry);
10b9feee2d0dc81 Francois Dugast 2025-09-08  388  		unsigned long i;
10b9feee2d0dc81 Francois Dugast 2025-09-08  389  
0ac881efe164685 Lorenzo Stoakes 2025-11-10  390  		if (softleaf_is_device_private_write(entry))
10b9feee2d0dc81 Francois Dugast 2025-09-08  391  			cpu_flags |= HMM_PFN_WRITE;
10b9feee2d0dc81 Francois Dugast 2025-09-08  392  
10b9feee2d0dc81 Francois Dugast 2025-09-08  393  		/*
10b9feee2d0dc81 Francois Dugast 2025-09-08  394  		 * Fully populate the PFN list though subsequent PFNs could be
10b9feee2d0dc81 Francois Dugast 2025-09-08  395  		 * inferred, because drivers which are not yet aware of large
10b9feee2d0dc81 Francois Dugast 2025-09-08  396  		 * folios probably do not support sparsely populated PFN lists.
10b9feee2d0dc81 Francois Dugast 2025-09-08  397  		 */
10b9feee2d0dc81 Francois Dugast 2025-09-08  398  		for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
10b9feee2d0dc81 Francois Dugast 2025-09-08  399  			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
10b9feee2d0dc81 Francois Dugast 2025-09-08  400  			hmm_pfns[i] |= pfn | cpu_flags;
10b9feee2d0dc81 Francois Dugast 2025-09-08  401  		}
10b9feee2d0dc81 Francois Dugast 2025-09-08  402  
10b9feee2d0dc81 Francois Dugast 2025-09-08  403  		return 0;
10b9feee2d0dc81 Francois Dugast 2025-09-08  404  	}
10b9feee2d0dc81 Francois Dugast 2025-09-08  405  
10b9feee2d0dc81 Francois Dugast 2025-09-08  406  	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
10b9feee2d0dc81 Francois Dugast 2025-09-08  407  					      npages, 0);
10b9feee2d0dc81 Francois Dugast 2025-09-08  408  	if (required_fault) {
0ac881efe164685 Lorenzo Stoakes 2025-11-10  409  		if (softleaf_is_device_private(entry))
10b9feee2d0dc81 Francois Dugast 2025-09-08  410  			return hmm_vma_fault(addr, end, required_fault, walk);
10b9feee2d0dc81 Francois Dugast 2025-09-08  411  		else
10b9feee2d0dc81 Francois Dugast 2025-09-08  412  			return -EFAULT;
10b9feee2d0dc81 Francois Dugast 2025-09-08  413  	}
10b9feee2d0dc81 Francois Dugast 2025-09-08  414  
70d15e6adfafc3e Mika Penttilä   2026-01-14  415  	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
10b9feee2d0dc81 Francois Dugast 2025-09-08  416  }
10b9feee2d0dc81 Francois Dugast 2025-09-08  417  #else
10b9feee2d0dc81 Francois Dugast 2025-09-08  418  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
10b9feee2d0dc81 Francois Dugast 2025-09-08  419  				     unsigned long end, unsigned long *hmm_pfns,
10b9feee2d0dc81 Francois Dugast 2025-09-08  420  				     pmd_t pmd)
10b9feee2d0dc81 Francois Dugast 2025-09-08  421  {
10b9feee2d0dc81 Francois Dugast 2025-09-08  422  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
10b9feee2d0dc81 Francois Dugast 2025-09-08 @423  	struct hmm_range *range = hmm_vma_walk->range;
10b9feee2d0dc81 Francois Dugast 2025-09-08  424  	unsigned long npages = (end - start) >> PAGE_SHIFT;
10b9feee2d0dc81 Francois Dugast 2025-09-08  425  
10b9feee2d0dc81 Francois Dugast 2025-09-08  426  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
10b9feee2d0dc81 Francois Dugast 2025-09-08  427  		return -EFAULT;
70d15e6adfafc3e Mika Penttilä   2026-01-14  428  	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
10b9feee2d0dc81 Francois Dugast 2025-09-08  429  }
10b9feee2d0dc81 Francois Dugast 2025-09-08  430  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
10b9feee2d0dc81 Francois Dugast 2025-09-08  431  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

