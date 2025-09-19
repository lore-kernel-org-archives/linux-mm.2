Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C566DCAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27E98E00E7; Thu, 18 Sep 2025 21:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD91A8E0008; Thu, 18 Sep 2025 21:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEBE8E00E7; Thu, 18 Sep 2025 21:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA59C8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:40:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76D1311A5B3
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:40:35 +0000 (UTC)
X-FDA: 83904295230.28.4461418
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id D744480002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:40:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hm7fikyD;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758246033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unHU10lm1KrLzncLPxG4RlMWeF4+BBle0WhdeoN7Z8o=;
	b=rKGZYMJyNFHnoP9j9QZwIKQcVXjoV4dBE2TRLm/BsWQYrccgR48w+dbka0YmKh8GFVmsh0
	vCzAgyXHkKSeqC0yJd6QE6D0zUWWM5dljR4SIg2tsTtvdUr/UhRlnUv7YU0zENHBqVgIQ4
	P7lhz3oLy4XrK3zeGWPs6E4eXkXkulc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hm7fikyD;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758246033; a=rsa-sha256;
	cv=none;
	b=SYmY1M3HjE4DRBEgXyrYVR0wOh49G2X9arf5It2G9QSViFh+flH7yip97LmIrphNMtmitf
	lIiMcRxly9M4MaGACEEisZVg0EXLmQKVdTvMCYyg/7ID5jdLITh4b4oHc5FhpETP8dS2zS
	6+jza4n0n1AtISSiQQWtJnGuq1HiSGI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758246033; x=1789782033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=itbhvlGa/67NE/x0tLhEoVen0fCwr+8EnXPRMpPCprc=;
  b=hm7fikyDE2ARUCTyegcMoTtyVLzEkUEij4XDXww2mWzRA83Bu+zPzdIs
   9YrIwY6GOcfPOlKHuCJzf/TPOClLw6acThzW1S/j7fQqbahGMEcn/zfWo
   DnIS3wEXzXcyLVdmpRWRBNe7DnoCtSZSAVRTEMHARfsoX8AYdFGN5DWy5
   shU3vQo7DgjT2Z/fwLd14qnw21vij1Q94P2zz1gn6isSi5naAHIRUTfad
   FPlNNBS5YB3PnCDNwmTCj/q9YwZ29toiDVm60YE4laztSZeSDA3aj6JXq
   67xirtjeMwGkpnfv54zxHHrys0TCpWWr9ndeKVI6oNUQPGqlGqK6QP8ja
   w==;
X-CSE-ConnectionGUID: ryN5aykqTKeH9pv9xfLxPg==
X-CSE-MsgGUID: sCbw1m3zTYSELg+o83HRIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="64410831"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="64410831"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 18:40:31 -0700
X-CSE-ConnectionGUID: 0XL0fEMrSzW+woQKr4uqsg==
X-CSE-MsgGUID: d5JDo9e8QVGzdgMYHpuebQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="175624749"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2025 18:40:27 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzQ6r-0003t5-0z;
	Fri, 19 Sep 2025 01:40:25 +0000
Date: Fri, 19 Sep 2025 09:40:20 +0800
From: kernel test robot <lkp@intel.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
Message-ID: <202509190917.wgDdVYHL-lkp@intel.com>
References: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
X-Stat-Signature: kd3gfoo3nbdndum78fygcnbasdeb1sen
X-Rspam-User: 
X-Rspamd-Queue-Id: D744480002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758246032-98097
X-HE-Meta: U2FsdGVkX1+kXvhU4d/RoAhKPeQgnPCezEG9X/Y81wZohlz2c7+3EuOL9jyJwm4BmNXR1ISCuaR0Bp94I+BSUCvM7xAyLe3h1mr6P8sE/jpdsvg8xWPituFZoNhXm8vVHlkS8JMdAilFHttxBvzMXzBYcHO5iFyMLyi43ZuuvMOQjMsvsEhwG8XyO7nZtECfaa3Xx8mg9gaPyhgWV6lB1AULSLCg8pei1BGKh2d+/asIOh7UzP6OBTIFhCPhJZNf8pI3P32FHZaiJIPkSJcTzuwxkXYHXv18XsMimujxLi1CK/sKENRIPaEIF3BctBE/Zd4IamexG8lKyp3dElLbRUBgNYmQAP2sfd0EnDIyIRWC76TgZHk9C5HdL6Vnnk4jX0jxg7PU9xbjO9G/DdirXVMBQCfGHwG0bgSexJ5BflfEFgiQzBITGj1gCxDJZcS20Cx/1Ch1I8dpWeJP7HjfBA/ue1bELwn2aT2xaKUGQowd52Os6VMkcpX9ka9yrOGS8LSs/E7D9LkPFYfX1Z4pPkKj9fbjHyXGD0/3qLiIVIxqLttKLpJYuylI6SQdeM9RDVM83hi8GlYzuhAOgky0v/GSEHP3/AB4CrTeeEHzRivP97GSl+zMkXA6qOgacvtQO6JcEjb6Tt1Vcxlc2XcxeI8bTrZj2U1IGPcVy9TaGNitRiZ8zdbyn5POHZh2q8PgBR9TGcorsxjZqdqthMr+fThR2AY/2GK8smk88ozHnaXrGrbSf0LBSGoOOEwdEEqiEXmG6wvVuq3X3tOax31WoJCLh7hqnrTx+7tS58BHOM2yJZUuUN1ICy8UbTV1cWQMhiaQ9hdOtO+qYqLX8MOvVigXNJYgCEBTtFUf3ik6y9ppmDT4+Tx86wlIkKRTFKYIxS/6WK/AHRrlRxH1/IbOs+JKZ0amp59WeBL2mnN/FTDzdFuT6gF8cRVrjXeLTfWmsiqOHhhSKu4952g1LJh
 8rsv27ua
 ESNNw5r540h7VwOIzXLM/g+GhzvKNdoPC6bnE6SGZAG9eSQDEbT8PHCKOf3x2pUp1PoaiIRyUmoh2pjhrmoN4O2DBVYBMvRdEfIhxVHKvIzsn/VYg7Kewcey0O3AqxOuD5TEbAsaIbSbqxQVcE2IiMpdreuAQEP7G6JwXz/jXyezueRUipQL/Pj3akMONK3mv3LVTpehYD8ZOzr+8zGKKo4T+nkGC9ZqgryQFKeKv/3E0I4UlM7jGR4ljXzLRTkZJythElD2fOna9w2kbuDNtBltWaIom07i4+etO0ZldYQ1kCDlyGscv+Xs7ixf69Wwa6nWxsDSzRTgRdV3Z3kuVMci6BAfgov0otcjPl5S5BygMFyVszcaasVFy4z4Rnm6kTIiz0zRy1iHuYh1f3Sv9VVNA/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kefeng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Kefeng-Wang/mm-page_alloc-optimize-pfn_range_valid_contig/20250918-212431
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250918132000.1951232-2-wangkefeng.wang%40huawei.com
patch subject: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250919/202509190917.wgDdVYHL-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250919/202509190917.wgDdVYHL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509190917.wgDdVYHL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/page_alloc.c:7033:7: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
    7033 |                 if (folio_test_pgtable(folio) | folio_test_stack(folio))
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                               ||
   mm/page_alloc.c:7033:7: note: cast one or both operands to int to silence this warning
   1 warning generated.


vim +7033 mm/page_alloc.c

  7009	
  7010	static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
  7011					   unsigned long nr_pages)
  7012	{
  7013		unsigned long i, end_pfn = start_pfn + nr_pages;
  7014		struct page *page;
  7015		struct folio *folio;
  7016	
  7017		for (i = start_pfn; i < end_pfn; i++) {
  7018			page = pfn_to_online_page(i);
  7019			if (!page)
  7020				return false;
  7021	
  7022			if (page_zone(page) != z)
  7023				return false;
  7024	
  7025			folio = page_folio(page);
  7026			if (folio_test_reserved(folio))
  7027				return false;
  7028	
  7029			if (folio_test_hugetlb(folio))
  7030				return false;
  7031	
  7032			/* The following type of folios aren't migrated */
> 7033			if (folio_test_pgtable(folio) | folio_test_stack(folio))
  7034				return false;
  7035	
  7036			/*
  7037			 * For compound pages such as THP and non-compound high
  7038			 * order buddy pages, save potentially a lot of iterations
  7039			 * if we can skip them at once.
  7040			 */
  7041			if (PageCompound(page))
  7042				i += (1UL << compound_order(page)) - 1;
  7043			else if (PageBuddy(page))
  7044				i += (1UL << buddy_order(page)) - 1;
  7045		}
  7046		return true;
  7047	}
  7048	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

