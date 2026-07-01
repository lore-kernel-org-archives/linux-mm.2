Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2D8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526AB6B00A6; Tue, 30 Jun 2026 21:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE7D6B00A8; Tue, 30 Jun 2026 21:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CB16B00A9; Tue, 30 Jun 2026 21:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A71C6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:37:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D4691C5776
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:37:16 +0000 (UTC)
X-FDA: 84938494872.20.3AA840C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5E1E920009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:37:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jMlqi+H6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869834;
	b=WIJTEwbFpbYWQrXaPVccmBqvfZIrv3az9EvqlBtlE2WBEG1rqY3YMY+23UgvnfMrcU3qYa
	+2rkHnI4BASsg5Hx8TDCS6QITpRIcWC4sN+akuApSDV0Yk6mr0tKkBCfQ2GtYa1wKJ3jML
	naK+GAEHlMDtrs9GYj4DrGa6XdAPf/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Das6bGb+MW83RXxVEqhElDByrLHsF2Du+SHh7TI6M5c=;
	b=72TB4PBBc+WmMJXNyB0w0YPv9Jwcwox4b3slQG0gRKS3rCiBHg0m+b4QbLmNxbd9EuAUsN
	9sm8PTljaBePHpe+H0z5rxKD775EEPOIij1VRBGfmr5fhUJx7BCsHELuAOO6cfydmzwvCZ
	gao5FZp+kAU+0MQzq435znKzum/wHUI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jMlqi+H6;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782869833; x=1814405833;
  h=date:from:to:cc:subject:message-id;
  bh=PFxWOFsTYrEDx75BwfRH5hpO6+k30LXq3G+vNZaMPPU=;
  b=jMlqi+H6kC3nHo5bgKgDAXsr+HvKjDNZEoK+2q7Fug1twBceI0QM9VWe
   2ZA0pR59pbP2kowtS2+QPrl4RaKAZq1IWG+ikWcTgTna6LWDHc+Gm6jIz
   CXkk4xVNc0EYQzLm0gr67wbPA4zlrYZ35ebnAa36hFnpKmhFSkKPSdoAh
   1hcaWHb6pnO8ZokeEn4QTeGNqqXFD6l2JbYYmWZTc6UMPvmmz9oldqNRj
   hoAj1e6TabUktNz13UppAl5LFQ4J5PZA5FkMVLIGb1osgfeh8sJH0nMz/
   UzL+mrZWMzAppDXplSdkVCQ9LrseFgBl8BUwezKQ/APuAXiR3GgKTikH4
   w==;
X-CSE-ConnectionGUID: Diy+Yw6XT2mYjhabyRD9nQ==
X-CSE-MsgGUID: NXBi7vozRYqSREmh7OOgHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87427274"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="87427274"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 18:37:12 -0700
X-CSE-ConnectionGUID: Q2TRE87+Qa6oRVXvaxMNLQ==
X-CSE-MsgGUID: BxGRJdSASDerHOYa/gzemg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="256338041"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 30 Jun 2026 18:37:11 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wejsv-000000008pv-1d8Z;
	Wed, 01 Jul 2026 01:37:06 +0000
Date: Wed, 01 Jul 2026 09:36:44 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 1977/2307] mm/hugetlb.c:3095:4: warning:
 array subscript -1 is below array bounds of 'struct list_head[1]'
Message-ID: <202607010945.6lDjBFTU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E1E920009
X-Rspam-User: 
X-Stat-Signature: zpa6edz7rz66hscxix5b3d3qattyzeay
X-HE-Tag: 1782869833-927294
X-HE-Meta: U2FsdGVkX185fCJKgBlvfnkXQBVgL9J6WjNNGjdLz6iUi+33M1Fzox+ITqeCFx/OTE+dPOomZ+qIVXJ0Ri0WfHoavsxYxTnapm/vkN5lXqKsiHdumE/V9tFPwkkYFxZWJz3A9ePR9lEQRJsvnyf/ejWvMnTAgvgvvyuIPhIskwRPLj98sktgf3s3VlaGnjVM96mqO8agQYFDt5Cx8k45VC0XZuvR92s4zWu32qk8VBDsEFRRxs7+DQSCS3IWYYeCyEyho8NkDswO0O8o7XJfp6YCIPboqVasvJwCs8NyL1RA6frblPHEXmxSflWDUPhVH7N+LSuV/DbEdqMy6VYOb9sm6r6EtAkHfUjHJ1BMxTq3B2srn+wwei6cWNra1QZ7q2CKjwpF/6tT7tJJ0Sd0ausLS6IGMlJ+IgACJRog468LjUFvjWnVftcDHLQPzT286vLd0bvXYjmN58DbOyUK1GLEQ/XIbYmDlRqTBgxccMNBW9hEw0PEZDJBimDhda7xHhRb6zoJ0fE0GwLUzb/mEBdpfUj3AxZUHCv/bDu+6Ej07BWE88fFUAxKoWrLir+dDWopVEq+XfFbhe/78NLwoBKZmyQTjGI/H48OcqeHA//S82Z5u/l8DPTUf0SvjRtQmHMb+mreQuOiUsJ6P2B1b6hH7E7JXnBtQwwFYmVE2DwtOJPNAosESBh9cpr6ui6d+l8vTV2fHsbrZG3p936RhmOlDx5J/c+YfHDc07NcCo4NxONokdsLwVzcCHTiJcKhWXdjEy6akBfdSDVV6JHo73C09/bkIiJ9Po9A+NJcFBc2PcRufsZrLW9YPM6PCR4UDYk3gpZ1alGdRccbyUipuCw3k77hEAtWRBt2sUY53VwyCIBS+MMQ36DHbIG0YVCKxILUg3wJKEQR8DzgAV6WTLNTpJ1l1k3IaPmosyGkajKgMphk3oMMoCZ+9OaOVb0w0lofhBo8afi6k8LP7PH
 Eie7etaK
 C9+v8Vahqd/0c/6QNIrE6J2PaQq1lcjC3GXuZIeenIy8qoU6TabkPRkH3Tb7Qgu6h+aL+8oSncLb08eHwMhuYBEhu8a7ljDkUIU33dPYOIXy/2vsYs8ylQVF9iCt4Jgxd7ZCWXH1OUJJcoKVDiuRVdan2RAadB5TnQe8KLszIZYzmEPeYTYOnxpohQyuarfXlHX0vOH1YmBzNXnJBfvk7QGsjMT08R0n5RMy8iX+a3a30gf+N0jC/IMCzOVLdC0nUJcCWs1zf+YcyfGnlhNX6aYmT5MkC7sx/zvZl5PJ3cBg0E83TkD0XTUqWcSCvWLDEA02I4yFz9UFfKxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   be5c93fa674f0fc3c8f359c2143abce6bbb422e6
commit: f48ee682d55e3602fcc194cb93b8398f2546e53f [1977/2307] mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
config: sparc-randconfig-r131-20260701 (https://download.01.org/0day-ci/archive/20260701/202607010945.6lDjBFTU-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260701/202607010945.6lDjBFTU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607010945.6lDjBFTU-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
>> mm/hugetlb.c:3095:4: warning: array subscript -1 is below array bounds of 'struct list_head[1]' [-Warray-bounds]
       list_add(&m->list, &huge_boot_pages[nid_request]);
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +3095 mm/hugetlb.c

  3060	
  3061	static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
  3062	{
  3063		unsigned long pfn;
  3064		unsigned int nid_request = nid;
  3065		struct huge_bootmem_page *m = arch_alloc_bootmem_huge_page(h, nid);
  3066	
  3067		if (!m)
  3068			return false;
  3069	
  3070		pfn = PHYS_PFN(__pa(m));
  3071		nid = early_pfn_to_nid(pfn);
  3072		/*
  3073		 * Use the beginning of the huge page to store the huge_bootmem_page
  3074		 * struct (until gather_bootmem puts them into the mem_map).
  3075		 *
  3076		 * Put them into a private list first because mem_map is not up yet.
  3077		 */
  3078		INIT_LIST_HEAD(&m->list);
  3079		m->hstate = h;
  3080		if (!hugetlb_early_cma(h)) {
  3081			m->cma = NULL;
  3082			m->flags = 0;
  3083		}
  3084	
  3085		/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
  3086		if (!hugetlb_early_cma(h) &&
  3087		    pfn_range_intersects_zones(nid, pfn, pages_per_huge_page(h))) {
  3088			/*
  3089			 * If the allocated page is on a different node than requested
  3090			 * (e.g., on PowerPC LPARs), put it on the requested node's list,
  3091			 * because hugetlb_free_cross_zone_pages() only frees cross-zone
  3092			 * pages belonging to the requested node.
  3093			 */
  3094			if (WARN_ON_ONCE(nid_request != NUMA_NO_NODE && nid != nid_request))
> 3095				list_add(&m->list, &huge_boot_pages[nid_request]);
  3096			else
  3097				list_add(&m->list, &huge_boot_pages[nid]);
  3098		} else {
  3099			list_add_tail(&m->list, &huge_boot_pages[nid]);
  3100			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
  3101			/*
  3102			 * Only initialize the head struct page in memmap_init_reserved_pages,
  3103			 * rest of the struct pages will be initialized by the HugeTLB
  3104			 * subsystem itself.
  3105			 * The head struct page is used to get folio information by the HugeTLB
  3106			 * subsystem like zone id and node id.
  3107			 */
  3108			memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
  3109					huge_page_size(h) - PAGE_SIZE);
  3110		}
  3111	
  3112		return true;
  3113	}
  3114	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

