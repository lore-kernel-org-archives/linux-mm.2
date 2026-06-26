Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 187EACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34B66B0141; Fri, 26 Jun 2026 08:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5EC6B0142; Fri, 26 Jun 2026 08:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5546B0143; Fri, 26 Jun 2026 08:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 708CB6B0141
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:19:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9784140248
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:19:15 +0000 (UTC)
X-FDA: 84921968670.11.75A1338
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id E55E6140012
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:19:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V0w2uf/4";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782476353;
	b=R0QxK9iNodNPwP3g8wfArD42mkCBG3R8WOqEm8kB6jtNeBABvjYQmxV1tn3zBMkoSI0G/b
	NSP9uFDmYM3KaYuUeNl1ji5JZweKmdWErwh8zpwyYsBHEK5OGc4b7Ua+zuT+Ynfuxfx0h7
	/GdUeHEpVzfEOHqz6vHxsqwfSYfAjow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782476353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+635jAP74cILid/VjVnOFMbTdZdU5d8MekjDdI9qfE=;
	b=oXJQEp7lm098z5jy0H+c4zNDS89gEBVYoH2YHR7sQhBPQcXF4Cns5MrvXMDWQAYSYb8df9
	b9lssaSmOGZJnqWqBGrRp1/fuJXDDalxqxQqx67Dmo/QnaufrgAcWRU4iSIYdg6tScXpS/
	HOkVAR9xjx+STgVdfUpghfz/F1gBRJ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V0w2uf/4";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782476353; x=1814012353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zh8/CZ/D5v8hhilZYJEpZDOhefxyT69L7QytBFAypG8=;
  b=V0w2uf/4ewPjZ8BP1ZBJFr/LolZSJqL9kaLJ+6fHd23jqXe2at1CuRiP
   4ai4TrAn+P8nzGfh/xYV7IvvoWk00UcpJybm5MZhmP02C1T31wJDD3rSz
   9mDh5v6TnpxSxWm5Qe6veC4XPb7O02sMh98+VWBx9six8TENsx3GB+zG4
   9Knt6jO+bL+tAqTDpnOo07eFm2epcjtprIQKQSO3ncf5NeKTMyOJPwRcF
   Se8G9XLr3PJs+IyW5njVfhkS6WyQlEuH9SWvZVVZeyK+kzs8z9/1czRjH
   QNhcD+QwLuQnRA1Eq086TQbsoNDkkCOVvoWshgNKsG1YGafCtFrczhN4o
   Q==;
X-CSE-ConnectionGUID: YATXP0+BRmCf1YU0QlB/6w==
X-CSE-MsgGUID: FZaX2bM/TXiNtwcXG+RGKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="86947321"
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="86947321"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 05:19:11 -0700
X-CSE-ConnectionGUID: H2XLAHS6TqyEopNz8WO6OA==
X-CSE-MsgGUID: 4/nvKSZxQI6cL2O08tYEMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="244915402"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 26 Jun 2026 05:19:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wd5WT-0000000053t-211S;
	Fri, 26 Jun 2026 12:19:05 +0000
Date: Fri, 26 Jun 2026 20:18:32 +0800
From: kernel test robot <lkp@intel.com>
To: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, david@kernel.org, surenb@google.com,
	fvdl@google.com, gthelen@google.com, souravpanda@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/hugetlb_cma: support percentage-based hugetlb_cma
 reservation
Message-ID: <202606262023.IKUrn01I-lkp@intel.com>
References: <20260625215900.2151690-1-souravpanda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625215900.2151690-1-souravpanda@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E55E6140012
X-Rspam-User: 
X-Stat-Signature: 6mr31j4e1hckskhy3ns8m7iic1znz9k4
X-HE-Tag: 1782476352-557617
X-HE-Meta: U2FsdGVkX19ewFH9wP96CzWgeZsDdDHLk4/w1QbINGo4B1R28Xu+0B29Pmt+h8OANle9dz28vQsNA4q/UvLTvSM2vp/il0xNn4ZajNAbfHQZp8BtjtPmwSvbqGmt1Vwf1SL1tJ7gnRz14/spuqQdKPcCYHJsoUZiCXCzqDJm4/HOhw4B819OFyP/N7MJIp95YJ1S9N27ovCzsPHf4CCi4WXrgx679eDDKhuKx4dS8JslhzjG+ZMnU/+BCxIg74MHipHk34MOIbtmygSutgJYFirCNMYAJ/842hBS3vze9nNG4BL6DsjQbNmfRPSyhl+2VvamlE5WghPrtSID6GQwdXUE3+3r+ngsxV4BquOcTcB6mGNSYvHLxrMft6pWY0Z9GTBsk9uMDX5ZFLSnEYhSMjDn/6iUkddPGl8/rpVz8QuLmK2Gj9wMzJMYJA5vQ5JcnLyDbsdd0+pGL9dvRFa886QPRsPLdx2yPUm7y3WvJ+7kki4RDeT5UgpaopW25ErwXjuYgrW9b5FZjAbEKWQQnfIzWCJpQ+1d+ZgMKkDX39CUWs0ofvt59J7GQWf7QBklP91xR4MUco3oocS/Ydx2J3ddM3r3A7o8jcX5Ig1/vmbdNutaBRtPBAt44sRvEwYPhpmImBYzE8+oxXQRA17oNHAPWxRNtMVJb8B0y3ZN88V0hHRGC3sxkZEM0Qr3DmifmTX03an/V5Lx3SPBbgyFXoU1UXGBtCzPGu8kS2MNuOcKn+cCRqQr9MzmbEBlEJlNRhf6TqB9WZ2oLhN8JOXKrHSYtFDF9iaH9oUAf/pKSdLJdax2nHngkRqFRw6xgvjK8uHEKdSwiL/Ii+GuzD8zlEHW/pVESLgnpOufg32A48C9caND98198RInl8q047cqP/5LfN3FbxPEjh0QbThexNtPGzgmMa4Jr5LTt2o30/0vZY8Th5Dmi3jnp3RE/PJZOD3wZh7t7/h+cIjzaxz
 yFYpV1Ky
 VQKM5hOTcMl06/JnzZR+tu8iwpxlM8SgIMoADQNMxZnZqA2LNYLESDwIkSur2SZg753EY+csFJpoKvQ203p8uuTO+3P/1kAIAOnKV9ZSv/cm0BWM5jquPoM1L7qfusZHEl+kF6DTZdQqHvb/Q9rZSu9bbR2P1wfvYcx4rewDR9Q2Op7h/RI7KWtehKDyIzJlVOW7LFScHzJSOD3rMxCNpLanEXWZng1TGu2DJhCBA9o6t/WoGp1c/tMQtheO0sz4edtUtdrqZ0hvEUcMCzf3xMx2SEPPtnbqMKMWweq4mN6MUzcHjqrRSfjUrUN3TjCz+f4S4i1HLwTAhoOekWvlFMjSVDT4n3EdnttIYs2hmNRwZqA5YgSE5ax3PuDzHWmoT+Q6EhnBPGDTYawdeQY7U9OKu3yEEV7lmDslLnmMFhuVP2VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sourav,

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.1]
[also build test ERROR on linus/master]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sourav-Panda/mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation/20260626-060014
base:   v7.1
patch link:    https://lore.kernel.org/r/20260625215900.2151690-1-souravpanda%40google.com
patch subject: [PATCH v1] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
config: i386-randconfig-062-20260626 (https://download.01.org/0day-ci/archive/20260626/202606262023.IKUrn01I-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260626/202606262023.IKUrn01I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: mm/hugetlb_cma.o: in function `hugetlb_cma_reserve':
>> mm/hugetlb_cma.c:219:(.init.text+0x21b): undefined reference to `__udivmoddi4'
>> ld: mm/hugetlb_cma.c:219:(.init.text+0x22f): undefined reference to `__udivdi3'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MFD_STMFX
   Depends on [n]: HAS_IOMEM [=y] && I2C [=y] && OF [=n]
   Selected by [y]:
   - PINCTRL_STMFX [=y] && PINCTRL [=y] && I2C [=y] && HAS_IOMEM [=y]


vim +219 mm/hugetlb_cma.c

   189	
   190	void __init hugetlb_cma_reserve(void)
   191	{
   192		unsigned long size, reserved, per_node, order;
   193		bool node_specific_cma_alloc = false;
   194		bool has_node_specific_param = false;
   195		int nid;
   196	
   197		for (nid = 0; nid < MAX_NUMNODES; nid++) {
   198			if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
   199				has_node_specific_param = true;
   200				break;
   201			}
   202		}
   203	
   204		if (has_node_specific_param) {
   205			for (nid = 0; nid < MAX_NUMNODES; nid++) {
   206				if (hugetlb_cma_percent_in_node[nid]) {
   207					unsigned long node_gfp_mem = memblock_node_memory_size(nid);
   208					unsigned long s;
   209	
   210					s = mult_frac(node_gfp_mem,
   211						      hugetlb_cma_percent_in_node[nid],
   212						      100);
   213	
   214					hugetlb_cma_size_in_node[nid] = s;
   215					hugetlb_cma_size += s;
   216				}
   217			}
   218		} else if (hugetlb_cma_percent) {
 > 219			hugetlb_cma_size = mult_frac(memblock_phys_mem_size(), hugetlb_cma_percent, 100);
   220		}
   221	
   222		if (!hugetlb_cma_size)
   223			return;
   224	
   225		order = arch_hugetlb_cma_order();
   226		if (!order) {
   227			pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
   228			return;
   229		}
   230	
   231		/*
   232		 * HugeTLB CMA reservation is required for gigantic
   233		 * huge pages which could not be allocated via the
   234		 * page allocator. Just warn if there is any change
   235		 * breaking this assumption.
   236		 */
   237		VM_WARN_ON(order <= MAX_PAGE_ORDER);
   238	
   239		hugetlb_bootmem_set_nodes();
   240	
   241		for (nid = 0; nid < MAX_NUMNODES; nid++) {
   242			if (hugetlb_cma_size_in_node[nid] == 0)
   243				continue;
   244	
   245			if (!node_isset(nid, hugetlb_bootmem_nodes)) {
   246				pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
   247				hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
   248				hugetlb_cma_size_in_node[nid] = 0;
   249				continue;
   250			}
   251	
   252			if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
   253				pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
   254					nid, (PAGE_SIZE << order) / SZ_1M);
   255				hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
   256				hugetlb_cma_size_in_node[nid] = 0;
   257			} else {
   258				node_specific_cma_alloc = true;
   259			}
   260		}
   261	
   262		/* Validate the CMA size again in case some invalid nodes specified. */
   263		if (!hugetlb_cma_size)
   264			return;
   265	
   266		if (hugetlb_cma_size < (PAGE_SIZE << order)) {
   267			pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
   268				(PAGE_SIZE << order) / SZ_1M);
   269			hugetlb_cma_size = 0;
   270			return;
   271		}
   272	
   273		if (!node_specific_cma_alloc) {
   274			/*
   275			 * If 3 GB area is requested on a machine with 4 numa nodes,
   276			 * let's allocate 1 GB on first three nodes and ignore the last one.
   277			 */
   278			per_node = DIV_ROUND_UP(hugetlb_cma_size,
   279						nodes_weight(hugetlb_bootmem_nodes));
   280			per_node = round_up(per_node, PAGE_SIZE << order);
   281			pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
   282				hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
   283		}
   284	
   285		reserved = 0;
   286		for_each_node_mask(nid, hugetlb_bootmem_nodes) {
   287			int res;
   288			char name[CMA_MAX_NAME];
   289	
   290			if (node_specific_cma_alloc) {
   291				if (hugetlb_cma_size_in_node[nid] == 0)
   292					continue;
   293	
   294				size = hugetlb_cma_size_in_node[nid];
   295			} else {
   296				size = min(per_node, hugetlb_cma_size - reserved);
   297			}
   298	
   299			size = round_up(size, PAGE_SIZE << order);
   300	
   301			snprintf(name, sizeof(name), "hugetlb%d", nid);
   302			/*
   303			 * Note that 'order per bit' is based on smallest size that
   304			 * may be returned to CMA allocator in the case of
   305			 * huge page demotion.
   306			 */
   307			res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
   308						HUGETLB_PAGE_ORDER, name,
   309						&hugetlb_cma[nid], nid);
   310			if (res) {
   311				pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
   312					res, nid);
   313				continue;
   314			}
   315	
   316			reserved += size;
   317			pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
   318				size / SZ_1M, nid);
   319	
   320			if (reserved >= hugetlb_cma_size)
   321				break;
   322		}
   323	
   324		if (!reserved)
   325			/*
   326			 * hugetlb_cma_size is used to determine if allocations from
   327			 * cma are possible.  Set to zero if no cma regions are set up.
   328			 */
   329			hugetlb_cma_size = 0;
   330	}
   331	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

