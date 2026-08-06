Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE70C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232726B00AB; Thu,  6 Aug 2026 17:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E29A6B00AC; Thu,  6 Aug 2026 17:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F90F6B00AD; Thu,  6 Aug 2026 17:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAB646B00AB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:01:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61DCE160205
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:01:57 +0000 (UTC)
X-FDA: 85072066674.08.952EFEA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id B71BE14000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:01:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mf2vSbW4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786050115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gmX44P5+RP71AkFBiGVrks8QrqRAPBpUiK6dO9jkLu0=;
	b=1ZooxmHYJkBlpYggueuS1bRgdB2ADrXkQQdbpB4dhz3uRP5H+DT62rNJNopDL3z9tRjhzV
	YAxSiMCuG0139QqILvYvDDejKTf82snNYAU1kY5gUyrGkdVEQiRpEHmP7FmEWd6LRdlgu7
	OgNRHSkNuF7Dek5DL8uxdVVRn5VAvQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mf2vSbW4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786050115;
	b=X1Z7Q/BhxMVQNKYKOi4EZ1Q2pNv8AkVgUNnqUs6b/xS5EYfw7tRvabkV77OZdTuFCbgn9y
	Y83QPBkNukCZTWzNp52BxgI7BNRWCyxbU7VhUjaqNiMJ4wVYk/EwvS7WG1yiYy3X1E8epN
	M3BBF7+8wzDl1ACQ+zc+WKtA34wXxLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786050115; x=1817586115;
  h=date:from:to:cc:subject:message-id;
  bh=yryCtzWs+HndbVGznUBI8u8i9GCMRbr6z55Vw4+4TOk=;
  b=Mf2vSbW4yv8jeYJZwvlSi4hxqZp6iBejdB+TF6/szjdLLXvl5+Ry2Pv7
   TZxZmNWIMl4kVaSbIzSLCuMRRaHcaC5kJdmBp55+fAyByuBBWOuSaTzjO
   wy+5BhrVuLyGnAhdxjvjxfZ2VjjyZC/uKUg3RUsf1jidmZEpydAo45CKq
   f+eCnGGd6UvwkhQJaLGKWGGAKXtT2rIm4RBg9B0nEtahK9J3nlg1lre19
   Kb8k7NAa07WJbovPBbDwCVMpJbfgr6Q7a5AJVJNyvCimHvzc7EHSGI/ZR
   GhqVbMPpgoRcAXPzTmuS9te+kFh23ovlfkHM1JJ8jE9KmWhmM3GLjG2O4
   Q==;
X-CSE-ConnectionGUID: mbOC81FgSeSc4ptWCRC2Uw==
X-CSE-MsgGUID: 34BpZQHqQlyaP/lHHp6exg==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="98020105"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="98020105"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 14:01:53 -0700
X-CSE-ConnectionGUID: /iRqHV/lRF27EIYwLuZWLw==
X-CSE-MsgGUID: Dhr5WiOcRnu5bMkqqHxEpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="266055668"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 06 Aug 2026 14:01:52 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws5Dp-00000000GEj-3IUa;
	Thu, 06 Aug 2026 21:01:49 +0000
Date: Fri, 07 Aug 2026 05:01:04 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 8777/13479] mm/hugetlb.c:3095:39:
 warning: array subscript 4294967295 is above array bounds of 'struct
 list_head[1]'
Message-ID: <202608070433.x3vNSfjt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B71BE14000A
X-Stat-Signature: ef79gp8ihg3wixm858qmz64fd7wxp7nb
X-Rspam-User: 
X-HE-Tag: 1786050114-347743
X-HE-Meta: U2FsdGVkX1/iwgGPIcxSfe1Ri9HcuIENC6oa0yNSHTLRC6PEauRPJYrKShzD6436eavRSX8jGrMx8U+65RM+af6ejM1sNmyeZYsbPGzFHAh80GeiYRAAPgtIHXuH1EdnA7lSfb4gIVMAgeg2xk4nJGxlpCDEe8vyFBqB3lkuSJ7tuBVxZS+ya2CCBWdZ31mRKLrryLq8OjVc2acZwbVCdzRK+CadhYdZ3IwYnvuZSgMEZopkeeACHuXaX+SsJyTSY6S6wGt75NRqbS9q2M2WYCuU9mMQQjrmbBujzphgiYx2yajIt9qIapHUiEZJJtloFlc0moVPiNxveFMY6lLFEsnCv99XuZ3E4OhZps/pfPNHYv64fIBhWyhHtyovyInYqgij+yTaVUSfuNjJwzvJLAUE7N8u1rfWvJdK1H5Bu7Txshn4rtLKXaSYgwWptAO5Pd8MkPJJkuXJisP8iOvBvRWhw67ygbaqwcU8jY5gG9FHHNJTqSZeyovzSBjzfbKySKDegf2JYjn/ranNW2JTQZ3kK4t4hWIVa39SOZx4xNmchw5VgTh4TLWPxCSHjylgkghmnpnwh1zoIw/gwmIVP+sQY9bn76ML5YejEzYTrND10Wf9pXtwrTfcfloFof6+YpWnAz5+k2HUp2ANJInVUJqXFxCIUiJQlppy5cRu/b+QLWRaEMAyW1FD99r62+h7A/cD2rSLWCoDkKRpkprf6E2zawTXRLLvKSDj53qGEYgX9Fyp95688L2GvX69B4gX0PhzoHUnTkQFwb4Q0j0WMizoESDDNesFhyWsgK+MlBYqkZTFGl1vAlZL0hBS2baF2twptk5c5nIKZT0tLhD/l+KH0W33ADSZ6R6LZqk5nEBVEbAVrAT9JHWo4YgB7XZev8k9Yl26yidn+BWPx+pvEvj/+Yg0d9QKrw2QkI92xqDNM6STeN0Ql4xA3lFNE/3WGlkmtHue9wUV0fj1ze0
 5Q2E5rpD
 DYh9tQdbUJCUHOKAbLLLdU1xIqJa0u4/PpFZgMO/fLxTZ3WS1xM40Jwkjsp3wrJZdM5Kje01u2XO+VYzyFedHHiyXzu8RrAFgWLkPCP9If0b+ZiSUNQakkO10zJKE9/n5gMkj2g9y7RbVwpKbWjvyGFhU/45hapVzNxY7T8/i6K0ZQvnwAB9mVRTwdidkjRTjFgOdAwD8WOq/VVxnYssgxLHX7xVvw+c61rIOZN3i621kdThaTmBChLrB6ytvWBZ4E2d0S9s12rhRycV3Tux3MmZFGWMOppE/z6jAkNHbNSkJCSvGsefhhfQbxhZIfST92yOb3gkLsNkXt4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   ea2bff00da89d7767d677bb68470130ba96f4928
commit: 20549ccf4da49ff6dcb35ffc741f92aa92e07aeb [8777/13479] mm/hugetlb: free cross-zone bootmem gigantic pages after allocation
config: parisc-randconfig-002-20260807 (https://download.01.org/0day-ci/archive/20260807/202608070433.x3vNSfjt-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260807/202608070433.x3vNSfjt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608070433.x3vNSfjt-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
>> mm/hugetlb.c:3095:39: warning: array subscript 4294967295 is above array bounds of 'struct list_head[1]' [-Warray-bounds]
       list_add(&m->list, &huge_boot_pages[nid_request]);
                           ~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   In file included from mm/hugetlb.c:6:
>> include/linux/list.h:163:12: warning: array subscript -1 is below array bounds of 'struct list_head[1]' [-Warray-bounds]
     new->prev = prev;
     ~~~~~~~~~~^~~~~~


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

