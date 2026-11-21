Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57F1606A335
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jluIrJtI
Received: by kanga.kvack.org (Postfix)
	id C2C496B05B3; Sat, 21 Nov 2026 02:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03E86B05B4; Sat, 21 Nov 2026 02:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A7C6B05B5; Sat, 21 Nov 2026 02:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 858166B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:47:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FE7FA0365
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:47:02 +0000 (UTC)
X-FDA: 85458345084.12.2751EA6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE67040004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:46:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jluIrJtI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795247220;
	b=HtQ17ehnr6utBiinXwKVXXHGTJg90pzXmtGd9OYjRAhNqN3ZQ9Eki0UvfoWsEZlCx8nY3q
	u9PtkC5ll2CCLFAb5WamVSnI8REN0jYpzQlNq7/ClCF1dXG01sMHqHYc1/7vlj3QM4pe4p
	2+ziHTAHFUoLeW8AGoQ6/oRooLtf/6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795247220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUt3ilp/MbYiddXzWat/1cfv3L8ANihyCynGRUpxkj0=;
	b=h3j0Cm16QG/F6fHVdSMeBEn0Gt3ER+MLDnHrnVRWdiUSIXhGFXE2wDxFpiR9mBMB+SF04M
	oO0+L+z+K6ejxBLcBzV1jlD1G8VE1D4N+QeGcnB5CiPVrpuFBkfA4/Q73qIfdNyohsVhCk
	o+gru1k7hJv8caXwXLNSmpXVbGhUai8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jluIrJtI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795247219; x=1826783219;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Pg1BhUYFt8ZDrzTh0ylBvqkYCJh/9VFw/AThGXyM5I=;
  b=jluIrJtIQyM0yMIQ6srk5TM4iNVA2D5jyZNF6JoVEgG9zredLPk/LMrt
   VXhtbUPUJjV7k8I5uH4MO0fT7Bj5kCiWlMsB9pjFchj/TyuliA4kHzBXg
   FYqOcJ+/faex64a5ey+EVusqbnX3A8WhF+bGzqjTpHiTPyBYr0ENfQb6i
   bjIacgqVaAmuZKm83WNJtNwxCe8x40IrCoh00xUYx1ygMxQOWDHwLRqHK
   Beacqv5UNZRnNlLjSg1UEzNKszUWveOkf1bK2EdDYKLZPAR/YJAp1hNk2
   Rr8+zShVPNpSUh9IJ1zpNX2VImmNSbzq7IggeAYkRQgRj+qZ5W7wwm1um
   w==;
X-CSE-ConnectionGUID: PhyFv8d5TaGmM/adFY97SA==
X-CSE-MsgGUID: b5hWbDXhRC+eHv7lsEjUfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4119028"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4119028"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 23:46:58 -0800
X-CSE-ConnectionGUID: /A1rNDpfSRKPQJZ/G5VcoA==
X-CSE-MsgGUID: rKyVTveQSDmIR0gpKJ/nNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="10869395"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 20 Nov 2026 23:46:51 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUfo7-00000001Jjv-3U8J;
	Sat, 21 Nov 2026 07:46:47 +0000
Date: Sat, 21 Nov 2026 15:46:32 +0800
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
Message-ID: <202611211523.63iOZgBX-lkp@intel.com>
References: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE67040004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: c7nk4i9iueiywwjog9amyxyndpbycfns
X-HE-Tag: 1795247218-828899
X-HE-Meta: U2FsdGVkX1/cooUqoZY/HpeJsbIYSmXosVU0Aa2b8CVV2shLSv93OLYPXNnNRSD4SvTQpQgrAhAZ2g0r7WSAGRCbhsTq72a6s8SyMj00xXCF1h8TAymwReguvYmXaQyQsJzGl9Jji+papD3gNRH3/ZZU3amXjD/BccmVa480A1luAPmBDQJ9h60JcCaQziOQfXgT8Ux54EI7Ebo/I0hSZ6GWP8EQuX21ZatiMINfOuxXdqIhK3t5CbAZaDcuqIAv+wylSLSBaCBmofbATcVN2i5oemlcPpdxQQNRMz/zCqrtQPlhLAf1eV76fC/UeUC1TdfeaZWdaTlopj9ZSCeOHuWFG95aDDDe8wFFYL9WnJMKzC/4gmLdZRtQgE0MJIlbVwPkgehQrF2D032WngPFwicLf7mAF/yyBSXf4e0FrhAZeBMSLlPXKBKMsrB+OJlBCeBcdy7bKOzg6UR7T9hcBJ2qr81F/Qe0MnUSCUe9g+XpPtAtU3beqeIZ2RoIOptFIqmr6xv7BxFJna5l5sYSdl2f3g+H2TmjwSaETWWVSScnoCyOLAQYFRtzAvuVdP4P1oQbVZLSUxdfh/MtBd/H3M9sIqv/geINVt4EM5REQnhGmdNIrNaYXEqrU1yss1fscTmiBrJjqbMOoGdGTj+c76LY8IfXI0auTr6JAJ+XpbUfA9xnpYcH6jachDw/NUDW8y8wbJ9tp3ut9jJfKEX7TicTYEyJ7cSFM4wT2xmSEq3PcHx28zPFdNCFM5hvZFQO2dmfzaAbooeWAGMv29cCYqfWCPvlqX3XT6s5w8uTOiw0oQwUHExOYZzcRpGnGcozVsg8Li79W8vcNbwr+EnfFJIT1lJ6O3tnLkaSkge+v9yAlvURhlGLIGlUlL7/7Kh4k6JpNZE2XzWvM/dn9f+opjCsDofKOqLmCpQpsuSG9laTqE0JsvZOry0PJSAxMHxLw5Ln+1+3D3E1liu65EK
 wxiwUmJr
 OHh6oKhMTkQpcjXxYNvCfCnWpNYMw8gpvZxvMHftmpGpnbLpKSfb7jYe6ilVLxDbnVKP2AsVa7NV+Jvr5WohCcTszNc2Kqxya91iyss3PSh5xJh7bzofVRaEkyR/FsPfPs2ahGIXt5chNBaSRQxAkRAfh7N6oJqS1q+Oav7EgjY501hytsJU+u6FiKqTeyU3u1Rv4j/fn8VtT5tUCQ/3oKKYUSip8k6JNzbn6SMUTBAHnnOWsuuWPFEjDxFs2SrFQbr/aczLoWTd+hhmqBVJP7vp19V8AhIeVXlP8X4oWW7pVuuCeL28rGbgeFzZLxk6eHni/zQa7nzAcqyzvAweHUdjWx31MHyUNrxvugOB4YwUolV8OpcGvJBl4jD7+EUqLEmh8BqUk8/FIiUS080QTcVPWfErDrjWomHDZLH29Dt2egYS/aOCqo8FAe6d9DcsajNQbb5olkgP+DpWQja0e5g0xLG1LarGhjV6wQTd08yco45eB0ybVYBeEebg1PYVCETwZ1q5REbHtYjCdRZdflRhfD4P/Qw9+//xgTcY3ff8m/6+9MWP58DbrSn8sBeL/EIV0/DFhwmejFituRkwuoX0htCj8CBG4vEpvBM5+69f0XNQhXH3/TJyQott9P+GRPWxt27r/6ZOGi12rB2jzySBvsoDS2uyFo/0MgeTBEsXr2hxZ82wAkEU2qIs5H1z7rDwZQGMOU8u9nix/e2ef3/sWBPMN5aQvRxq5XnymZ/3aVnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Gregory,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 15f114dac9a7bde1796f0e54e22726fd31cfa8a5]

url:    https://github.com/intel-lab-lkp/linux/commits/Gregory-Price-via-B4-Relay/nodemask-add-node-state-iterators/20261120-130852
base:   15f114dac9a7bde1796f0e54e22726fd31cfa8a5
patch link:    https://lore.kernel.org/r/20261120-private_nodes_v6-v1-54-74f5f9a115c2%40gourry.net
patch subject: [PATCH 54/60] mm/migrate: route explicit NUMA migration to private nodes
config: nios2-defconfig (https://download.01.org/0day-ci/archive/20261121/202611211523.63iOZgBX-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/202611211523.63iOZgBX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611211523.63iOZgBX-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/migrate.c: In function 'alloc_migration_target':
   mm/migrate.c:2254:24: error: implicit declaration of function '__folio_alloc_flags'; did you mean 'folio_alloc_swap'? [-Werror=implicit-function-declaration]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^~~~~~~~~~~~~~~~~~~
         |                        folio_alloc_swap
>> mm/migrate.c:2254:24: warning: returning 'int' from a function with return type 'struct folio *' makes pointer from integer without a cast [-Wint-conversion]
    2254 |                 return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2255 |                                            mtc->alloc_flags);
         |                                            ~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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

