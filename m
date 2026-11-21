Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F970606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eo9bpYz2
Received: by kanga.kvack.org (Postfix)
	id 7D12D6B00EF; Sat, 21 Nov 2026 07:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734216B05B0; Sat, 21 Nov 2026 07:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649C36B05B1; Sat, 21 Nov 2026 07:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 365426B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:04:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9DCEC0426
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:04:28 +0000 (UTC)
X-FDA: 85458993816.20.7527A84
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 98A10140003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:04:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eo9bpYz2;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795262666;
	b=KmZf9grusSZ03mObozvPxy46QmO8AX6wY4XpoPgdhtHNdgorFFOH4BBLe3y4l+anqKx31v
	6Y+ynUD/cEFDkvT4PMjnALStR/fP8p342Nj9xek3PCHis0otvUeJXPibi/Hyln779KSaRp
	NTfc9+mTuT+ElQ1i4TQ9yL6EMHoB/Y8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795262666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XwtdwbZYFdmmX1DSJG9P7gRtCoB3o3/Wv87V3JsG8c=;
	b=4KhEzj5P0xQW1CfGx+FMX8g1MBDEAVXaRa14ql9jz4mop3LQuyTjGHpPQce6pv1XeHXoWM
	XfHUo63Eu1MCNmt8HqRVj4Idt6ma1NgemgUSzRW7VBqqour6Kd9sg9NcZw+L1odD5hg3P3
	3xOmrK3wU1ebu2z/5an83D+GydrjI1c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eo9bpYz2;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795262666; x=1826798666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WKdeB+wr3Nzs08DbegGP73NUWcovwjcle7gER9Hs2oU=;
  b=eo9bpYz2H98uJUwXsizDJq7sayd07DayKLfVCB2ZCw2dVLF/qBk+9Pqd
   LH9IxYPCH9/TaCyYtFH97I9FS9D2EqK4wfrsZjodn8I/dN6MwkJnmOf8f
   htqJ0aaQKA6euguj070GtTERWJv6+SnO+0ky1Bk4r6fMl/TjZpM40RQdb
   CIK35UMdQViScpYExcZj+JEFgscp20Oxd7P3BpCHLwNeL+xpvz1lnOgLi
   N3PQZcSEszXNkBEiWIAUB51fcVn0Gs1zuHTnZsKPnJAtNk/yNMH+hFoXV
   aB/t2bLWOT4wJkN5jQuO2uJEMyur/6R6mjtfuHX6kaFPtxfCzsLi2CEbf
   Q==;
X-CSE-ConnectionGUID: g38aszBaTBmDR6JGq0BqiQ==
X-CSE-MsgGUID: ODxFKIaMSfiT/0P/Hi8HsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4230890"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4230890"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2026 04:04:18 -0800
X-CSE-ConnectionGUID: KG/XGnIkSiKaHwllfgg6gA==
X-CSE-MsgGUID: YCGXuvyeRl+S6jfxEcF6oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="10806193"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 21 Nov 2026 04:04:05 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUjp2-00000001K07-37dQ;
	Sat, 21 Nov 2026 12:04:00 +0000
Date: Sat, 21 Nov 2026 20:03:21 +0800
From: kernel test robot <lkp@intel.com>
To: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 54/60] mm/migrate: route explicit NUMA migration to
 private nodes
Message-ID: <202611211932.YlkRbmjS-lkp@intel.com>
References: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 98A10140003
X-Stat-Signature: 39g3d3a3ggtc63ajetxijer3k6ns37k4
X-Rspam-User:
X-HE-Tag: 1795262665-236643
X-HE-Meta: U2FsdGVkX1+1XlB0EJBSGSSr0umkQ6Sz3K9Nhy26p7JqwAXNGN7aWvWi+AKGm0e9bGD9oz/xhA+foF504xTE926K0yQAHFqpmu0ETRCKPcWsOeF8ETtJWq8L1FTveBEdSE63YF7zzItujPjSd/3NWDCZyj+h3kwcMKBbUIx5Wn42WMj3cJ+W/qfOZUbv0ZgGmM4pHZWA8pRYXwBuvb9WtpaJM1F5mqHo8ne3WIUm4YkVuF6ZqhcMtwKSZUyYe8lP4nTB1HSRi8vWhgnq3MvhjtAuoZrXEVDFGN2zgtXSX+uRuhlEM05ODRkFUQdmazTWduyJKVwFaVDzu/fpaJjod4hdWr4h+7KtKtURjE/ahyLWfGdBWcHj7hw54Eyt+9z/FdIwp6orSFK+0bhkDyU5fGNlR4mTEDccqdriESn2dQYlEWs05KycE+da+tjHGA1TTjgk0Gg5SURsBAGkvsbdTWRlXY0pe934gU7WTa0PZsx4rq+zk2pI+pU7m7aeB+JoZ9xRnUu8TuYxL+H2U1OwaOtWAy1MRMWbJB3oIy6Dcx5zQHGMhnWR/3K3e7mdMxwue08tJWig+fUhrk8CzZ9+KiyBJsZEefXHkZc6sKN2NORhpJEVGBnhcx+ZVc3Afdo1wLayqwoX5m8OJwdAh1u+IBMN9mwgzhNIFKjHVgnwoVjZj3XuXN9jTZ9S/iVPDxiXOVXX9CBVE0xwvXgLd7aynH+lW6JSckcQlkFaQDO2udWR/K9nwWPTFEvq2IqlQ2+0i0ApfcEPIigj5hRHxa3PZW+QKkm0tiacgX5thCgIZrRrKvjM+t1vJkOPlsdcBz7hVmKfnU9ICUduPXIE2+3olknnEVe3PdvhpKWtfYH1Qd0azW64y6mMs2Rvu7FLFQ6bl1DCwMPflseDdlawO9hYv11/sptf8ER3lgs2ssakpPlCfx28eYAyFDjmtB4Sz0oQqSmrCcCsLN7mZjvKQSB
 Dr0JXucv
 3ug8Lk721XLHdNSb3bJxPQ21GXAtm/qP3aUFY/cWPj0bMLXLXCSIHkvf638Gy5XnItiAdtoRAwemk8eHqUDV3tTNQSMoVD+0Ws+TcZe5yljNvSGCYna/fRNDBrUc3sduftDV98k9PIiMCJVuVE1qzkKFxAvjO2x2IfULPbNKDw0j0mfhQ1DqCaXG/yneo0DOF2iMBjcXrMC5gqbhf242t9AZ0gBNO9MYlGReYatv+i5P3ZujvQyM5Ri7dSiXXpZSFx7N5xeutj2T9vipmysYlwXiLhJyKhh/5Pp/S83bg/rbRMmp0ud+7mVPgNDPxLwvw6LtAV5W6FkUakdh5qDHhI0+id0uo3xHpIx+MBJW/Vbp9iS9jaDl7AgNDXoxymE4jetZsf1kOR834taJoJSuE273orsg8hCxLv3oKK+pBCz2R3/7ojAkwDkl9HoG1WCXWefPtxyms2a+uVttmB2GornOc+EAyRjmLaszbMB+Q0IQCqYVzE47Ve4TvSICLtBSxobS75n1+SLsBRu1ug2g1ib+t8rF7mWdUhHXI3+jlG+YtxYGIWwUNcFOzvuhZvlHIYbJ5JYC5gLusftGnvhRUmrMImUv57AAhzWnwbp9FJ4lf8AAE+tJNv4ztkfNrQuslh2pwXo9qfixR2PykoISPt5vnMCnyVJ/RirDXylLZ41aqxrhRTQG9+2KHgd9aqbuUZa7YO7/gMZzCNZMx23/z9KIhAyWmQ2kck3R1lgPkOBKkRLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Gregory,

kernel test robot noticed the following build errors:

[auto build test ERROR on 15f114dac9a7bde1796f0e54e22726fd31cfa8a5]

url:    https://github.com/intel-lab-lkp/linux/commits/Gregory-Price-via-B4-Relay/nodemask-add-node-state-iterators/20261120-130852
base:   15f114dac9a7bde1796f0e54e22726fd31cfa8a5
patch link:    https://lore.kernel.org/r/20261120-private_nodes_v6-v1-54-74f5f9a115c2%40gourry.net
patch subject: [PATCH 54/60] mm/migrate: route explicit NUMA migration to private nodes
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261121/202611211932.YlkRbmjS-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/202611211932.YlkRbmjS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611211932.YlkRbmjS-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/migrate.c: In function 'alloc_migration_target':
>> mm/migrate.c:2254:24: error: implicit declaration of function '__folio_alloc_flags'; did you mean 'folio_alloc_swap'? [-Wimplicit-function-declaration]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^~~~~~~~~~~~~~~~~~~
         |                        folio_alloc_swap
>> mm/migrate.c:2254:24: error: returning 'int' from a function with return type 'struct folio *' makes pointer from integer without a cast [-Wint-conversion]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2255 |                                            mtc->alloc_flags);
         |                                            ~~~~~~~~~~~~~~~~~


vim +2254 mm/migrate.c

  2216	
  2217	struct folio *alloc_migration_target(struct folio *src, unsigned long private)
  2218	{
  2219		struct migration_target_control *mtc;
  2220		gfp_t gfp_mask;
  2221		unsigned int order = 0;
  2222		int nid;
  2223		enum zone_type zidx;
  2224	
  2225		mtc = (struct migration_target_control *)private;
  2226		gfp_mask = mtc->gfp_mask;
  2227		nid = mtc->nid;
  2228		if (nid == NUMA_NO_NODE)
  2229			nid = folio_nid(src);
  2230	
  2231		if (folio_test_hugetlb(src)) {
  2232			struct hstate *h = folio_hstate(src);
  2233	
  2234			gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
  2235			return alloc_hugetlb_folio_nodemask(h, nid,
  2236							mtc->nmask, gfp_mask,
  2237							htlb_allow_alloc_fallback(mtc->reason));
  2238		}
  2239	
  2240		if (folio_test_large(src)) {
  2241			/*
  2242			 * clear __GFP_RECLAIM to make the migration callback
  2243			 * consistent with regular THP allocations.
  2244			 */
  2245			gfp_mask &= ~__GFP_RECLAIM;
  2246			gfp_mask |= GFP_TRANSHUGE;
  2247			order = folio_order(src);
  2248		}
  2249		zidx = folio_zonenum(src);
  2250		if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
  2251			gfp_mask |= __GFP_HIGHMEM;
  2252	
  2253		if (mtc->alloc_flags)
> 2254			return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
  2255						   mtc->alloc_flags);
  2256		return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
  2257	}
  2258	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

