Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AE6E668AE
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 14:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD66A6B0088; Sat, 20 Dec 2025 09:35:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E1C6B0089; Sat, 20 Dec 2025 09:35:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC35F6B008A; Sat, 20 Dec 2025 09:35:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 990E56B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 09:35:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A29013B53F
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:35:15 +0000 (UTC)
X-FDA: 84240096990.20.96AE387
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D555140006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:35:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MT/3ZRRi";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766241313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB226Wi7efd2+NT1O7GqebQ9wbCxsawWFmaSHLvvT80=;
	b=5VpLrcd4SOtazHzmyA+4qIFz701apFg+XDeNnLtOwIpZ4Pn2SBm5bJghlnRsVPb07PC3Sq
	DO3O/BeJOfBpNx60b7guO+g4UygCQyuype+PU2jTwmPXkkPkARy/LfFqop/NSjrXe3baC8
	LGegDsrBydS8iHC7IXnWa6/5wjnFtO8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MT/3ZRRi";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766241313; a=rsa-sha256;
	cv=none;
	b=Wy8ckILxrLIWHyI14aCIowHubeWO11rW74Rz25d/wlWO9Q4nqh4YRcLYE/k8xkZRo7xfv8
	HngyicOC7U6wDvmyEcw5vAgS41AH5CEN9Foy2ZSJJXrfooBZcTm8gt5OntmmVf125DuHUK
	nUj9EC1aRtiYKoz78rwWlGWFN7UwS5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766241313; x=1797777313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lcqfRcZnUhdZtM2v+VZSf69JMQrf1vkEY0OB5dx1RO8=;
  b=MT/3ZRRitBPXmaJeaus+xwyJjgkTRK27QaIa0KhqkLUtRnchtURyx97o
   ucIHF42PPv3bhKwyuMqG/wM9KZ9WmflpMLMorZQiV2R5rnlgHF0gO162w
   TmQrL7LDthu0LbnGSidfhsPf7xPBdrhkasM8Y3MZ7sXp4GEqtSQ5VrFlh
   P9RxL7viOc6BrS0y1KfPE4P5i5bHjEyf4/NxuEGSLVocHBeYWHYGRqhZo
   DK7NXndM/9v3v4umCYQ768CUFYnklpPsxaFBQP88APjmmQYYXckZYBXwI
   mCygrdkGDj+C83CLgP+V7r494MtXy2oJg3sIckQMHQylPFdyzzLkD/Vau
   Q==;
X-CSE-ConnectionGUID: +pK3Dj8wSuyfbuV0vaYrmg==
X-CSE-MsgGUID: W+HXpGGTS1C30jvsoUj99A==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="93650024"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="93650024"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:35:10 -0800
X-CSE-ConnectionGUID: lpBrIjs7QE6cywKFsDUrqQ==
X-CSE-MsgGUID: T6t0zGU8RnGO6Mtxlbp0og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199023547"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 06:35:07 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWy2z-000000004eW-1HuP;
	Sat, 20 Dec 2025 14:35:05 +0000
Date: Sat, 20 Dec 2025 22:34:47 +0800
From: kernel test robot <lkp@intel.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Message-ID: <202512202141.mGkUgIRF-lkp@intel.com>
References: <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D555140006
X-Stat-Signature: ng9kepmrp7cbikhi4c347rbgfnssjfm9
X-HE-Tag: 1766241312-167023
X-HE-Meta: U2FsdGVkX18TWvJ6ozTTGGo0lpTvukTNw/tgRgjusmOwBDhINd+89EP/uc9wtqY0zrGRo2NxXWAv37MhY1YuCGOIE20zmdWB+N/kzxXGjUMTDZWh46K0FrK93p/4D2+uBtKGVGc2swlCsqQH/cnCtzvrGxsMqQuEZgH0R86ObvegHksE3W6ZrU0jbhVX2FERLeTyGOkd9eL6M/xx0y1thVZj/7axdXN3V2sEZWtMyrVet7/HUmPJ1sOlINMReyoRIkI4yLvTLu42yht8lhaO6RnJd+7LG4nVBNgDou1fcCjhgxlvA/g98Uw/P0lU6prRTDjf/H816APgDpwElC246LZySzTsTRpye+kKW70S7memcnpPbFCSmN+FWHezblnObFV5Mvmo2UKvzemJqImwJ2jHjCE3796LKseNYge4+8YrGTNda6WaFmEJHcRqlIhVT9E/z9oN/UGhfj1OLTJwvU9WXFCM1HBnC5GJl6stt7U2GSggdlWup5L2UB8YNv6FqsDLfQlANYDYIK6EkMoa6tvKPAhiaylYICGPJPBvtFoannGfDQFv8e+Kt/trNqkCzoryXROfzMG3NEaBQL0PiUga/qprmVPViChpx8IJ/fDo5qbN2waVLg2ojB9VKJvgJV50wpUreZs3+CY5ZEMmW9k19++sfoZBcGNIMvC79yqWqLfD69ZZpovPoKUXQBmCaWZkBRBAEzOebbIiD3pXkFnoQvRWUOO+O0NquxP+wzMho36jaRuB5ty8AvyjBmmV5dodw4zUTg9J3gM71dpupLrbHVqzuN8eTteRuHYh6ixda7CCa4JKzF7aT6AoPhOZBkabWJhNkDkpohRNnGJtdPZ+4Vk/UzrbwkNEs/tSzi0w0ANLnLpSFNI8iGV2ghVTYT3kvj0MR3XEMsO5KWiOgFfT3NJUbuFLQQS6vW/7lrk=
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

url:    https://github.com/intel-lab-lkp/linux/commits/Kefeng-Wang/mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page/20251216-195027
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251216114844.2126250-6-wangkefeng.wang%40huawei.com
patch subject: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
config: s390-randconfig-r053-20251218 (https://download.01.org/0day-ci/archive/20251220/202512202141.mGkUgIRF-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202141.mGkUgIRF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202141.mGkUgIRF-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/hugetlb_cma.c: In function 'hugetlb_cma_alloc_folio':
>> mm/hugetlb_cma.c:44:11: warning: array subscript [0, 0] is outside array bounds of 'struct cma *[1]' [-Warray-bounds]
       page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for CAN_DEV
   Depends on [n]: NETDEVICES [=n] && CAN [=m]
   Selected by [m]:
   - CAN [=m] && NET [=y]


vim +44 mm/hugetlb_cma.c

    28	
    29	struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
    30					      int nid, nodemask_t *nodemask)
    31	{
    32		int node;
    33		struct folio *folio;
    34		struct page *page = NULL;
    35	
    36		if (hugetlb_cma[nid])
    37			page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
    38	
    39		if (!page && !(gfp_mask & __GFP_THISNODE)) {
    40			for_each_node_mask(node, *nodemask) {
    41				if (node == nid || !hugetlb_cma[node])
    42					continue;
    43	
  > 44				page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
    45				if (page)
    46					break;
    47			}
    48		}
    49	
    50		if (!page)
    51			return NULL;
    52	
    53		set_page_refcounted(page);
    54		folio = page_folio(page);
    55		folio_set_hugetlb_cma(folio);
    56		return folio;
    57	}
    58	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

