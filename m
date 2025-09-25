Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AECCCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8ED68E000B; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66008E0008; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3488E000B; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5C688E0007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66DA71601FC
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:37:21 +0000 (UTC)
X-FDA: 83927874282.22.A3655EB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id D34D112000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:37:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UkJuCUSJ;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758807439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnVD81UzFoKNHG1Xf5/z0C7K03T3UUQUF/YZIrNB2Hw=;
	b=jeVU0DrHA3V9dqCxKftCI31JZbG5lbk8sQaiZv/UPtzNriBlV9JxoqF71tu8C9UCHsISxi
	fY8e9OkLXeGsgfLRmv/qS9Gqgy4w+Ad9NAdDaDG1gQ8GiUvPdzmt4NALFZ25RS9t1lQs/Z
	Kv/j39b3GGasPOfPWCbjb5vZqjRDHoM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UkJuCUSJ;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758807439; a=rsa-sha256;
	cv=none;
	b=S9tUM9r3Mfi80ASvVJ6FRN1sLDFqMcItSz3LvI+fxhQnnAK0YaPZOBoCyPUaLjklwDlgBD
	4yx13P6czouTjpnWiMEQ8l2/qmPNBLU/e14H96PuwPLTE3F+S6iYtWNU6FjkjN7tog9Vwf
	0hc9M4T/I1VM1Dg2uELE1WQ6vBfkfhA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758807439; x=1790343439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1PwuzYRVc23Mq8CgsDZzvk5lpGEPYfH8eH4KmEqBYAc=;
  b=UkJuCUSJAQKfJo2rkPDBc/469p+OVqSfQHSO+AaL+jqfw1noKNrameAD
   rOGqYw9or8atMiHBv1/esMVipwJN7CCoTbXiAD0qDbjf8JE5e3XS5j/t+
   KG8D4jPJnS+khG0TeSEkeOqr+kQv37l3WYdA/tVRjwo2yDnSHavEdVLvQ
   8w+iA3qS/we8wbqFuq/ETYqbK5aE7I/CCYN76srPB4iXWcHB3JLs6uwLD
   e+1CypMI8moBfOpTpH0lsDTBS3+IjBsqL5AmlwQB/qNesBjI8zTg6kqaU
   bC+11yMA/9rG+k6g40TGF8rhnC1uWoWcJRlMpK80VcIrRxjH0DiLuXhsj
   w==;
X-CSE-ConnectionGUID: L2yEKD8CRfaenie4IVr5dA==
X-CSE-MsgGUID: lxVkiYBLQROFamjM8l7hPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64933484"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64933484"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 06:37:17 -0700
X-CSE-ConnectionGUID: RqjohgBhTrK2Brz6zCpW4A==
X-CSE-MsgGUID: kePJyFd+RPis6CrCcuMkcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="177393010"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 25 Sep 2025 06:37:10 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1m9k-0005GJ-05;
	Thu, 25 Sep 2025 13:37:08 +0000
Date: Thu, 25 Sep 2025 21:36:47 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, peterz@infradead.org, bp@alien8.de,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 13/21] mm/page_alloc_test: unit test pindex helpers
Message-ID: <202509252146.WmdVQlgy-lkp@intel.com>
References: <20250924-b4-asi-page-alloc-v1-13-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-13-2d861768041f@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D34D112000C
X-Stat-Signature: yiyut6csmqo65n66hcbeux5id3daadys
X-HE-Tag: 1758807438-694002
X-HE-Meta: U2FsdGVkX1+fx5HMCGwLT3gA31Oam5ZTaVMu7dw7t2xfk6L1NIRu+H1GDV6MlYefraaSeq4TUl068dprDRdv1Y/NGDFE/5rzq9N70vnbKdP+K7BO3lAZGpB4bmFYL8ug9chR/pZs4ptg7A5U0vKWHZzwNK3Aa482eDQNdQw0L00EgJkKo91TOO8hWgssXkSxcEW6PwVFfwQEk5CI/dhiWmoqEOlMbR2X5lIyi/OPpd20VMZkjLL8aAb2+n4HTFgL8o4wbhDIz/7ZY2eGflkwfwSySh5siuoHIf2yuS09M8mxCYBXUb1VNB/+v3MOLfjuac0HsrDakpqUh036mFgCkX/vwHZlhEE53XHAOJewYHqJbHC9ip1LBXyJCQPF/ggqgARcxbk2IYGsHvxK2CuOSujP8ix9C5GWyv9lOcq6jJbnKguJ3eme/dpH0pZkaRjd1QYAXAlPJmbFtFsWfnCgWbvPJ2TKXxMDcT/uv3ZQ3Y8TOaOxZMg6WQr2TwV1OkTQBRkTBRaN45a07it8eD83N9H2RtXoYiIJTdpjg3EdkXGXWwfMqygMsSB9mtH9ab8NW5bXtUC61AtHAol1VSIBCSDRJ5R8Xfq/8IgRlWNnYRV8Xd+zbKr9Rh4GGfDcLdikf4DU97onq3PwcL47pcbrUdeEl+tvl4nZceJPQQOli1obqJ63Wg4/15bGExc8NQpwu+4EjDDQpo1TVHpKPCcljnxV9cpPSWKI6C3bE5iaYrO4cLba0S0E3N8Jy2zUFqw3lRxy9iqw/J1NRvHt+w7VLL7xWJA9cfwcaETGiN0NSlYgkFQ/z8VK/wQ5qPUTMH5fv0BH4yw3e4Qfx50z/ouuZIO5u5kb2gaDeuS/Oue07JzGlWElFsLubX04+YGnmbb3btgz+F4MctblDrBME2VGtuCWGZ0dpQHmLuSGbWGzn/1jD8uOB3HDz6HvTU5nDGZlxb4mSbftBnUkoriITNJ
 3sJED+qL
 QBQABkdIUv4OU2p/8GWjZIYO8ric0ESQFSjXz8C9Tn+3swOC+jj4V9MRBtzwhygvV6ttVmVbz6TB2pydfL+yNVfZsJRgJIT7JDFksTkyZ45JuVfiMOWxS0CKqeF+XslJ6YS/vBXYNHq4ZeBn2IyBT/dYUcwFDLhWw36nfVCCt/I5achCULQQRngg8r9k7XuMXwE4UPXl500n+dwv9cYbRfz6Vi0kB2BbHRrvDLK62JSEVMXo2i3RHw5RVs8bODIcFJD83IE/QmrOtrYRrdtjlo7YFVjKmfPpgXTz9OhP+12hrvLPPp3MukekTW5wbnxqpL1+0nwbZh05qaUnO/UEqGqPzFpRurTaLLW5uCzIL9lQJ2OTvDU0absa0+K4bCDdlspQFQyC2ObNzKa4Ir8rCvHTTQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build errors:

[auto build test ERROR on bf2602a3cb2381fb1a04bf1c39a290518d2538d1]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/x86-mm-asi-Add-CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION/20250924-230633
base:   bf2602a3cb2381fb1a04bf1c39a290518d2538d1
patch link:    https://lore.kernel.org/r/20250924-b4-asi-page-alloc-v1-13-2d861768041f%40google.com
patch subject: [PATCH 13/21] mm/page_alloc_test: unit test pindex helpers
config: x86_64-buildonly-randconfig-006-20250925 (https://download.01.org/0day-ci/archive/20250925/202509252146.WmdVQlgy-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250925/202509252146.WmdVQlgy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509252146.WmdVQlgy-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/page_alloc_test.c: In function 'test_pindex_helpers':
>> mm/page_alloc_test.c:19:30: error: implicit declaration of function 'pcp_allowed_order' [-Wimplicit-function-declaration]
      19 |                         if (!pcp_allowed_order(order))
         |                              ^~~~~~~~~~~~~~~~~
>> mm/page_alloc_test.c:24:55: error: implicit declaration of function 'order_to_pindex' [-Wimplicit-function-declaration]
      24 |                                 unsigned int pindex = order_to_pindex(ft, order);
         |                                                       ^~~~~~~~~~~~~~~
>> mm/page_alloc_test.c:44:45: error: implicit declaration of function 'pindex_to_order'; did you mean 'next_order'? [-Wimplicit-function-declaration]
      44 |                                 got_order = pindex_to_order(pindex);
         |                                             ^~~~~~~~~~~~~~~
         |                                             next_order


vim +/pcp_allowed_order +19 mm/page_alloc_test.c

     8	
     9	/* This just checks for basic arithmetic errors. */
    10	static void test_pindex_helpers(struct kunit *test)
    11	{
    12		unsigned long bitmap[bitmap_size(NR_PCP_LISTS)];
    13	
    14		/* Bit means "pindex not yet used". */
    15		bitmap_fill(bitmap, NR_PCP_LISTS);
    16	
    17		for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) {
    18			for (unsigned int mt = 0; mt < MIGRATE_PCPTYPES; mt++)  {
  > 19				if (!pcp_allowed_order(order))
    20					continue;
    21	
    22				for (int sensitive = 0; sensitive < NR_SENSITIVITIES; sensitive++) {
    23					freetype_t ft = migrate_to_freetype(mt, sensitive);
  > 24					unsigned int pindex = order_to_pindex(ft, order);
    25					int got_order;
    26	
    27					KUNIT_ASSERT_LT_MSG(test, pindex, NR_PCP_LISTS,
    28						"invalid pindex %d (order %d mt %d sensitive %d)",
    29						pindex, order, mt, sensitive);
    30					KUNIT_EXPECT_TRUE_MSG(test, test_bit(pindex, bitmap),
    31						"pindex %d reused (order %d mt %d sensitive %d)",
    32						pindex, order, mt, sensitive);
    33	
    34					/*
    35					 * For THP, two migratetypes map to the
    36					 * same pindex, just manually exclude one
    37					 * of those cases.
    38					 */
    39					if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
    40					      order == HPAGE_PMD_ORDER &&
    41					      mt == min(MIGRATE_UNMOVABLE, MIGRATE_RECLAIMABLE)))
    42						clear_bit(pindex, bitmap);
    43	
  > 44					got_order = pindex_to_order(pindex);
    45					KUNIT_EXPECT_EQ_MSG(test, order, got_order,
    46						"roundtrip failed, got %d want %d (pindex %d mt %d sensitive %d)",
    47						got_order, order, pindex, mt, sensitive);
    48	
    49				}
    50			}
    51		}
    52	
    53		KUNIT_EXPECT_TRUE_MSG(test, bitmap_empty(bitmap, NR_PCP_LISTS),
    54			"unused pindices: %*pbl", NR_PCP_LISTS, bitmap);
    55	}
    56	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

