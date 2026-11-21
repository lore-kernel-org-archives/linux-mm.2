Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D45606A325
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 08:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iNq1gatA
Received: by kanga.kvack.org (Postfix)
	id 736236B00EF; Sat, 21 Nov 2026 03:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7396B05B0; Sat, 21 Nov 2026 03:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6D56B05B1; Sat, 21 Nov 2026 03:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F106B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:18:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB7A8160385
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:18:22 +0000 (UTC)
X-FDA: 85458424044.19.D5800B2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 045C640004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:18:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iNq1gatA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795249101;
	b=7DyOXDad59uVb/Qeb/U+j/or+td0UCDjlnw/8RPY+ZKzqhMFO8wMJ6xlYDUUlgaxOpa9lH
	WQhtjpcXubfygk4XoHSno43ZpaErRgu9jO6HMZDGHDZ1Dr3gpm7Z/M19TmNOYqB4WP2wvu
	pcljcYn+oG92XGVRG6G05x23nMvYSvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795249101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCYPhItWmnp0/5nxKzmcWIir9eopxc4FlvC5rliCc3Q=;
	b=5L1Grp63XgaRkvuUnMiDqyNCM/oFHmjmYlLMtMrnVevIQ5JFfvW2ehzbxkb6+tvFtK3MaJ
	C+O/9RYb4gT3aRVv1Ks5HEHzNDgozR66PajpbtAZi35dVFKee8+4MHyrfCtxL/NorprVJd
	+61hwYF2VJqEhyPXTLn2gb8v4ptHbuU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iNq1gatA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795249100; x=1826785100;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pO0cciCz4qBsH+lwwoCOo6yiJg2x8jY4K93217h6gAw=;
  b=iNq1gatAPXBkM9tPp5m4PBNdWxCX4Atl6ak4z/0zGIKEIpHAmMRT88gz
   cmbqusK5RcA0aA2QCK4ThspJ3U83F+rOXZA8OKULtk3Y9n7HGMiUwJISI
   g+cKCGaVThup1xYlB8vNu6G7WVYRY95RtqiDl/ttVmI4Smdb/2HfXhC/u
   qIeEveqg8fzFJmlXrtboITOEpCKiY6mhNhg8/N0byicbwKvR3PDD1OttD
   +nLnEhMDqO0FbVhJeSTcDtnR3FYjEiIvkEDWEkykyAy150KziEXDSs9TV
   AyBNkYWbdblAvgncLfBAfcR16OLZzAZEiVQuED6sy2sHO5mrXcIStG2Sb
   A==;
X-CSE-ConnectionGUID: dw3kzDWyQymRZa7/LO9H9w==
X-CSE-MsgGUID: DzHkJPt1RWG4gMvqFg84AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4016231"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4016231"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2026 00:18:18 -0800
X-CSE-ConnectionGUID: PWrLIszdQNecO3b3uFVshg==
X-CSE-MsgGUID: OqtUL30ETRu4ekM85ukBbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="12709521"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 21 Nov 2026 00:18:11 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUgIR-00000001Jln-0CGj;
	Sat, 21 Nov 2026 08:18:07 +0000
Date: Sat, 21 Nov 2026 16:17:22 +0800
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 54/60] mm/migrate: route explicit NUMA migration to
 private nodes
Message-ID: <202611211538.vaJ4R864-lkp@intel.com>
References: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Stat-Signature: 95k9xztnnfszgr675if5jr38nropspfd
X-Rspamd-Queue-Id: 045C640004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795249099-745417
X-HE-Meta: U2FsdGVkX1+k0VFIy365nc20zuLrOUDHbkWEPHGFj0OOmekZ4RxtAhzRFgeB1CJVPQwPkJ3E5U0fWUj4HAnUaWG8oxjOuzj3NQeMcpFUdWNp+wPVUrQPLhK/YOX3Pu5WS5v3ahk4k829q71Ke/gSDJACieTzU1tfTe1VYItBsMnW7xzEB2Aoqxt2WpoQe/Yu403t55BwxEJ9aPmCqZg5KyC1pzzHuztZRFZqclifyfWGnMcZUqLhG9mhS9tlsdnSdUe+aPLTgr4VKCw+y/4sRYU6QlqcX0ZWmDrlUDIY36AkTlJH0VtJbdFTcaKVT7qigi0OoKo1PYa17zBQaKT+3qsIyPvG4FwFchFUNoP0K+i2LeEDWYoFGqQQ6umTXUXfKHM/vefasyYZG1lMdArdan+c7uhwhWWx+A85B991LU3Qnzc7qWUU8mwzqIpW1yY2DeSc+k96SlUJIOcX+brO1IkN+ElazPIsZBA2+jcBRC/0bt1PK1Gb1pyzlT+yh02R2ZkPBLwdSkQFa6uiwLnGtZjXNnmjcMe/uK47kfkBSQzbOeLUSxoACFAR5CT1Ph65idSYcrnaxWPjnKxhfV3I9wwSqybMQxM2xB1bq3ZK1NWzMXu/B1LWtejy3glBbFpcjPst2L/ys6iMmPtQ5ck5H2UJF2t0HG8gQDwfgZwMHK3/LYoT8BTU8PIRkYscCMxC6qYr3gy9TWS0c2KP5aU53dlpPDYxo++pSytigsbObZxk32y5h+JX+swYNcTmVWn/JIt8G5mOQSI7TQTPwDWHMgbhdpiamPTzHJXqUDvuvDwOtdWzavXtklT4SeCei/8lOnuVE0NKzFuMQbi/P1tvmymBfodn7sZK6eK36yXi+dtyiVSW4rIcRblwh2XECc2ND/2camEal6buCph54jJkb4DyXk23Bj00IKYCBlD36d13C2bT7vwu3DZI9mnDQxn+nVHf2x/Xx2M1ElqSwCz
 rvO9/4Lf
 bf9ZFku+wEPfevjLOXs0/gXw/8VLs72ZG0vg2s9ZkyEFV1/Un2GlS+hOStHdhg649Psb0PY3GtAhiwoDpfc59tMmq5oytbDYa8hfb35Pw3kjiN6Z777Mc2lyBuaGQCMdWQmUI7ehJuZI7NQPdxkfwJIyT/ItUBlyW02ge00lQYNfvRlos836KxDsDRoHVdDkzjIt3BANEI2r0szO5RqUJmqdwrg1Ln/KAsb6MzofIRvekWy8eOR/ZCkXvhHzlW1cCPQca1SL6deQcJ0aukESWqGDALajC80OCVbudKBF4hk2wRTVJqOtmxqRzgDGe6VQ5e2gRBoKctGuu8p/LGvs9tJs2Lp4o1ZGkxNDRkDrxU9vELn7gTEdgsx4mJoUS4vYB84gc8YJgUavg0ROIUYr8vE2Bc3mkTOxNv2eKPIrdxPt9CkTTxIqHGgHYFZ47avp/WYyqDTAYdoFjIuu4xMFU9cwZ41Zziv+lKYWx0jm24Ux6ZqB9d+ogk84ei0Ecxu22qZ7Z66vv1f3WKj8xDOXofZqKhgOseFX9GSfFDANArqFkVoh0+wCS6b6zTIzRWkvy2v3xETxuaZpgM46RmE2rC9D7tMHC0+S/RNoi2kUqSglZS3Fge4MnZUyebN4TSpggtIeL3p9XeeoVatTH7XInhPrAENBK5cKnTny55jwAMTpjC3KW1GxFzwQNqPYOafUGrobdqMDBO1AX9e/GMbQQtLpl25b8Equa+F4bo8JVyfQf958=
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
config: arm-jornada720_defconfig (https://download.01.org/0day-ci/archive/20261121/202611211538.vaJ4R864-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 3b14d7c370558b46e5f0c6494a05c492e59bf32c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/202611211538.vaJ4R864-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611211538.vaJ4R864-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/migrate.c:2254:10: error: call to undeclared function '__folio_alloc_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^
>> mm/migrate.c:2254:10: error: incompatible integer to pointer conversion returning 'int' from a function with result type 'struct folio *' [-Wint-conversion]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2255 |                                            mtc->alloc_flags);
         |                                            ~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +/__folio_alloc_flags +2254 mm/migrate.c

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

