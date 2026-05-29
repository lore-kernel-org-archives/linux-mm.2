Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71180CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9555E6B0005; Fri, 29 May 2026 02:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D406B0088; Fri, 29 May 2026 02:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C5B6B008A; Fri, 29 May 2026 02:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718B36B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:49:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BD2199B96
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:49:52 +0000 (UTC)
X-FDA: 84819532224.23.7620438
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B8E5140005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:49:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLZ9x0XE;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780037390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6brmnY3liayu5xTfblnfxHdDW47PpxGEv/wHEZc/oBU=;
	b=0/uyYMx7mO1Km6upIqTuRJpU9FUDcIOs1HTVD1kLv7ZMjKaKY1uGQd6Pc885vdFGRzBQ+0
	h+I7z5bS/oQbw9VwAXfpfnMqPTiDthxuOnc8Xop9rL5IjXRemQEyiBrOD/KGGPRzFDNIum
	tr8cubEkxjVHF5Sct8Nq2kVydw2PHBY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kLZ9x0XE;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780037390; a=rsa-sha256;
	cv=none;
	b=5rZiHY385ntVh6KM7M+KnynfJyXXndSPcSCJNxIdqk9ZtQSJGcb2rA5udnypxCTAlBa/Az
	bePphWg0wJIiZv6pKr2lrUAXnkYkC/QyIKS6kUpEDBnkZdKQNGhq0Jq5xAfpIYTc6HZnGk
	TZz/CC+jMwYUkJKPsBEg9L7D9/Ua6dA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780037390; x=1811573390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4xx0DbleGfoyvUuQjW3FtKSISI+UIEl20NwmXWATzKo=;
  b=kLZ9x0XEiKSU2xolx562X8mh1j1obXCdILxQm2TSmz6JBhS1guOP1hR7
   9sJ4dTl7sYZbwBa9hJyzzqaKU6+pOS7PvZ5HZBu9yK3nuKc8lM88FSHeP
   R4/C18uN+ubTZ8j0FP2i4zoaz14PQh0KYHmfzErSUoRAsRvVMP8JUl8eJ
   n5lEWOYHRMGYH5ltiQqW/TeUkZnwb95NL8UNFEWHTIs3rT2q395KnT0fK
   otTd2heX/OucWDva0GmRYywWlki6L26uSrVR4/1FSD1FabkYKP3Tb94CL
   oCg8mnkAWn5RNasQ6uN72+9sVcczalGRQV2z8HbOdEDy0XRpK/7H0yfLb
   A==;
X-CSE-ConnectionGUID: E2xZb7VTTpqMJhThXfy4FA==
X-CSE-MsgGUID: lVDbfQh9TiCR35Fr/35MAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80857838"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80857838"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 23:49:49 -0700
X-CSE-ConnectionGUID: 5ftVuP7NR5aF2glJOos2Bg==
X-CSE-MsgGUID: w0iBaxAxSIeYrez9/ZMeqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="238373530"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 28 May 2026 23:49:47 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSr2O-000000006rS-1Rn7;
	Fri, 29 May 2026 06:49:44 +0000
Date: Fri, 29 May 2026 14:48:52 +0800
From: kernel test robot <lkp@intel.com>
To: liuqiqi@kylinos.cn, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, ying.huang@linux.alibaba.com,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier
 identifier
Message-ID: <202605291449.2jXZbqUJ-lkp@intel.com>
References: <20260528134212.240492-2-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528134212.240492-2-liuqiqi@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B8E5140005
X-Stat-Signature: gsghmhru39nbwdf1yekr65wbj6s1d43r
X-HE-Tag: 1780037389-884264
X-HE-Meta: U2FsdGVkX1/LaIshGdBm+cCB+bueVcQ2PEQI4eyl5olAWOW5tpgEI6y9gFWU4YP1P3UW5KgKWbTnkdsnxQAjxdVyA2oDjAW3umaOae8qC2mNYi8CQXqOpGSdfDxh6Zg8BKt3QbLFcwoUZ4RSHnPJE1a0I42w9EFdL6+1rnQhDZpa2/tZbh3VcdSz/lCLSBcm/FLQK5cdAQKRUX/HwzJ2vO+SrrKWK2oLEKa/8BMtGN0t6oKevM0txX2ujuq+Q6fBFdSAgFC0xLeEz3uEVv9NxtJT1gLeW7vJjxV5agntipy6ztIEGtxko/q5nLgBDAWBfvjgPrVkNAAB/mwG79OhEZEjPbXdypLpRdAB3/BQFEMfql9xUfgzXaTENDyoLS88gV79bN7J5TFZMSWlKPxjl+WITgY35Y4byjbrzZMbZR2QqJqImeQySXvreuP9bjcIgWETKAdsM1oh0qz7LEdImS3tixlrxQT9Ui5VDopZgoKTe9uhSNyF9nnweUoNlX8r3rz5Zwe5FtqnQuoRwJrFEFAxIKPeuLTTfnpTqNOPIbzxFczG9Fb9XTY3iAq00CslGt+RQltTJ11Ll+3r40szT2xQBTiYsWwlmTU+J4IOwdx+7Jtpcn5LN1St/REx1Xcvbo9uvMctwzo55O0bjFgD5mYk/jsQsfeJ59/cWqF/fxiQfh0dO+cSflp6EMVk5pn0ycjzXGiIVBiT8YQghkMfOHFMipJMDdiZwXPkU/pngKlYUczj1a/q6gAMkUwVoqrIdqTISSsNm1icSajP4NdYfrsOU0gOydI+OVH8JOSLUca2Cwng9eamb7aLUarVStCDhXaDm+R/WA9utS7nyhbTvsZ7bp5DlB5+OrhZZf88jUB0NjJ4u7Tb5MZp+UaCkizueqgLCwZTuJ2LdKM31ZVxXlJHaW2Sfw9+nMIyMeKTlN4yoVwVL9EsFSHnYkRqPEuDg7vLUCMC4X17wtvmscw
 MEmFJYgP
 Aen45Gpipt9oWVlrOQ9kG2JCfCbOnIBqtFuL00fB93wYujYnXJQJD09/nx9P0EAxCsm9LBPnOepi83/aEJqSpDqpD78s9kqEZuKl2WHan0VXmbGPzJbJe9A7AYo3iIm76cqFO0wnO69uSucJiZ9Txq99SkXO9SEdIgc7GLXaWr3iNKZO6MsXaEpCT59MgWzBkeliHgm79u+7cyCa0f8CpoSCIszSIqdB/B0g7pAcWZXiUITxo4c7OQtjmaGYEESf3BHkKx6QScxDEn8JXksFGRX77Hx+SitxdeCwxhogsdNoRUiFD9BFXPp4GlO4n0Zh99axc5W5HnJpHkzi93pt/JwIusoNuuT7H6f+Qu+iRNGqtJ8ui+Cc2hFlqeqR+7kK8MvkVeLwIsVsH4/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on rppt-memblock/for-next rppt-memblock/fixes linus/master v7.1-rc5 next-20260528]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/liuqiqi-kylinos-cn/mm-memory-tier-add-node_tier_id-as-stable-tier-identifier/20260528-214338
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260528134212.240492-2-liuqiqi%40kylinos.cn
patch subject: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier identifier
config: um-allnoconfig (https://download.01.org/0day-ci/archive/20260529/202605291449.2jXZbqUJ-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291449.2jXZbqUJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291449.2jXZbqUJ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/mm_init.c:1713:9: error: no member named 'node_tier_id' in 'struct pglist_data'
    1713 |         pgdat->node_tier_id = -1;
         |         ~~~~~  ^
   1 error generated.


vim +1713 mm/mm_init.c

  1698	
  1699	static void __init free_area_init_node(int nid)
  1700	{
  1701		pg_data_t *pgdat = NODE_DATA(nid);
  1702		unsigned long start_pfn = 0;
  1703		unsigned long end_pfn = 0;
  1704	
  1705		/* pg_data_t should be reset to zero when it's allocated */
  1706		WARN_ON(pgdat->nr_zones || pgdat->kswapd_highest_zoneidx);
  1707	
  1708		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
  1709	
  1710		pgdat->node_id = nid;
  1711		pgdat->node_start_pfn = start_pfn;
  1712		pgdat->per_cpu_nodestats = NULL;
> 1713		pgdat->node_tier_id = -1;
  1714	
  1715		if (start_pfn != end_pfn) {
  1716			pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
  1717				(u64)start_pfn << PAGE_SHIFT,
  1718				end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
  1719	
  1720			calculate_node_totalpages(pgdat, start_pfn, end_pfn);
  1721		} else {
  1722			pr_info("Initmem setup node %d as memoryless\n", nid);
  1723	
  1724			reset_memoryless_node_totalpages(pgdat);
  1725		}
  1726	
  1727		alloc_node_mem_map(pgdat);
  1728		pgdat_set_deferred_range(pgdat);
  1729	
  1730		free_area_init_core(pgdat);
  1731		lru_gen_init_pgdat(pgdat);
  1732	}
  1733	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

