Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC936F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3D96B00A2; Sat,  7 Mar 2026 14:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BB66B00A3; Sat,  7 Mar 2026 14:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160FC6B00A4; Sat,  7 Mar 2026 14:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3E476B00A2
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:58:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2568B662E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:58:18 +0000 (UTC)
X-FDA: 84520328676.01.5B03183
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id E4199160003
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:58:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PsZQ3g0W;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0frC3pflUkKX2BrGrk9TXUdtd3fwNbVNAduvnPqztVc=;
	b=zvhzCsMC0SIqIEyBMWbf0HQkPMiBS7QIA+PnpkSpdbErOA8L6AGKfUEieWQkrG//RMSWGf
	jNTqie9BZq+fZPHRWdRtkHoIggl11oX0+uzaWYz3pWNlETKKgx64a3N8fegTxfDe8SEidg
	d4OspOoG1KZUmcBLpXt6nPqjZs5zaRA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PsZQ3g0W;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913496; a=rsa-sha256;
	cv=none;
	b=S182NKIDKAW/fwp641YlWr5PqGKo8h4NmDrFHh71aD9t2aK/prxexsiND8gR8HCz2V6I47
	O+jYpd1w8/l5O/V+z6aovkFPFZoOLjYqUVs2nBiZ0X9GhR9xScE6E8F8hl/emXapu9POS6
	YVZZWrz433TYkj8lNNO/vBZfuj9nyDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772913495; x=1804449495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6EfkCLhJg+AlZw6TkaO6d/504vUAp5tN3HoH1lQUwjY=;
  b=PsZQ3g0Ww+/LcdZffJdtXzZEhNRB2M3P6KwGOiM7XOSbrEffO4GyQdDK
   DeyHrVNLGhTI//bQMfqzWsDDVr4o1VSx87+IArJJ9vCPRZjPJiBmyeSQ5
   cNqju1LUhP+qJAZzjOzLDPDUa1qA94bqy2rR+drGetF+nPPEh6xjuTb/k
   4YgLZLwPwM8NUQNyqTR3XeiqabipVmOwdogADUhY6HZ/2GbLePfk4EMiq
   Q1itH2nGnTUi0KjmmjaphXZ7ubOo8iX6HUtLHS8FkZ57yWZtCz7nHQ7by
   kN4X8eWvOIQkU0vAnTgz5iHHLSkC/35aQgd5fogwgRejzMi9XcWySwY8E
   Q==;
X-CSE-ConnectionGUID: xHiBlDIdSAGlP8vzXLBKtg==
X-CSE-MsgGUID: 7+Yyh4xaS0CEGOHnLfJaiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="74038492"
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="74038492"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2026 11:58:13 -0800
X-CSE-ConnectionGUID: Wlk16Iu4Q/eU4k+9d912cQ==
X-CSE-MsgGUID: /0+ldayrS5+1d6aZKJqv6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="218552919"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 07 Mar 2026 11:58:05 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyxmj-000000002b5-2cTQ;
	Sat, 07 Mar 2026 19:58:01 +0000
Date: Sun, 8 Mar 2026 03:57:41 +0800
From: kernel test robot <lkp@intel.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz
Cc: oe-kbuild-all@lists.linux.dev, apopple@nvidia.com,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <202603080349.ya7tIjgk-lkp@intel.com>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4199160003
X-Stat-Signature: 8dfjzz4u8pmizmcodywzq71tbx3n4khg
X-Rspam-User: 
X-HE-Tag: 1772913494-94631
X-HE-Meta: U2FsdGVkX1+YBrhQaCwyDORPtzQH5ni4sO5VdDWordBZkEvzkodvjIOWcWiHAIKXH1NvlaWAueTn6wi9AM0+WeAps7CPNd8BQGah1lhTIxnnuWPviEswInMzoQfvnhtaQgnHWNNlI/JHjnsLhGaW4DPacTjXzjJRKTyY78KLtCp+CLkdG5kLCaxx15qpogU0S21VqENlGHnJ0QRpx9emQV+0Hb2veIo01HH0crZ5vVe5rdZnKUEA8aYcBsaZBKpOQUfCYXjRfI44q3N0XnYMVgpCN3o6HpxHyao06jV9dNpL8I1maHqwtJJAD9Ul7BqOAKaJZrAGKj9RbHRZCHgLAJ1HW6X8M6ypMRFXJd83XRWIIlVHnHkAsANfCaYXIr6V6UiGow2p+j7IvpSow4QFUCbvWAb3VDRh6AvdaGbbKXSG1VfDKFJdm2jEYGJQkNwcmNRbcRXg27e7OL0zV0QPrCwAYCcJ8ZZfdSsD6KXSk/itv8bzT1dlV3OGw8q2llkDrxDsPA7hGdw8cb/ei8OnG0wI/fVhxuJ3tBGjsKoYBZvE435Vd5DsuEgKaAoK+V4y8CoFr4q/azTt77hWiXta5qy1CDWq2x72cwllbicwHj/xNI+o+mGA7ENWEmTByDWKbN48eSg7jHK7ci+FVUYicnTLdbiQZ7LBBLvV3s+emsZbI/nMxpf9agRzseCUMna+Eug/r2l4ZmPexJlmpCrXuiaULZeUzUmwMF8S5bTkINHS9VT+8PFlTUUXG9cMBseAASC9zpjlSOMYoaE9AAHJv55psEXvAA18QnUTvBxOu3r4jj3Nmi3Itej4Ml3ApVwKlWt2i0Kgb9ohcgyz/3jYiS0qA12AcebctTCCCZyRX9ULqnDj88msNooPPu4Ah0YgrqjCB2+Vpepnjk3l+j3ljhczzlfPsNW9og0QYQ///OYP+lu3Evh5y10csq5ceSQwDBKuhhABGfnjKiUjmcI
 IjixYxDE
 iLd6YZx+OWY/PGzZKZGlLrqm+7fnvj903PFmJfw/vaf17GarOIL1kmTFJb0bKRHRP7ZwPX9BFbH0QPKY329/t47xrXzDi3FHeDTXp9YyBOJWk7Fuc7KSB4vhjyt6s8uc7fXfTxd+MLn81ckmn1C6t84l9qH2+3Mr5xt1LotKCcTlIoi3d11OcbnWkrzPyh19efQ5nKAfZeq+ZC+sVOAAplrTJ4gLZMn3VmO1rkcXp3snTrjlYs1G3YYRH0WD3oNJk3HzU+HLFs+V7vwK19K5Qy7VYKWZuvwrI5qRk/JgLVecraxXHDSNwQ0VRjgWMvdZ7gk2nnZPlWtg59z0wHhmxcUDieZqIP7lDfPGw7ecugWL4zLxNvaW37oPjh0Kr7xDRiBQEH+kmFDB2av3ISmVGbP9w9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi JP,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/JP-Kobryn-Meta/mm-mempolicy-track-page-allocations-per-mempolicy/20260307-125642
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260307045520.247998-1-jp.kobryn%40linux.dev
patch subject: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
config: arm64-randconfig-001-20260307 (https://download.01.org/0day-ci/archive/20260308/202603080349.ya7tIjgk-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260308/202603080349.ya7tIjgk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603080349.ya7tIjgk-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   mm/mempolicy.c: In function 'mpol_count_numa_alloc':
>> mm/mempolicy.c:2489:10: error: implicit declaration of function 'mem_cgroup_from_task'; did you mean 'perf_cgroup_from_task'? [-Werror=implicit-function-declaration]
     memcg = mem_cgroup_from_task(current);
             ^~~~~~~~~~~~~~~~~~~~
             perf_cgroup_from_task
>> mm/mempolicy.c:2489:8: warning: assignment to 'struct mem_cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     memcg = mem_cgroup_from_task(current);
           ^
   cc1: some warnings being treated as errors


vim +2489 mm/mempolicy.c

  2429	
  2430	/*
  2431	 * Count a mempolicy allocation. Stats are tracked per-node and per-cgroup.
  2432	 * The following numa_{hit/miss/foreign} pattern is used:
  2433	 *
  2434	 *   hit
  2435	 *     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
  2436	 *     - for other policies, allocation succeeded on intended node
  2437	 *     - counted on the node of the allocation
  2438	 *   miss
  2439	 *     - allocation intended for other node, but happened on this one
  2440	 *     - counted on other node
  2441	 *   foreign
  2442	 *     - allocation intended on this node, but happened on other node
  2443	 *     - counted on this node
  2444	 */
  2445	static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
  2446					  struct page *page, unsigned int order)
  2447	{
  2448		int actual_nid = page_to_nid(page);
  2449		long nr_pages = 1L << order;
  2450		enum node_stat_item hit_idx;
  2451		struct mem_cgroup *memcg;
  2452		struct lruvec *lruvec;
  2453		bool is_hit;
  2454	
  2455		if (!root_mem_cgroup || mem_cgroup_disabled())
  2456			return;
  2457	
  2458		/*
  2459		 * Start with hit then use +1 or +2 later on to change to miss or
  2460		 * foreign respectively if needed.
  2461		 */
  2462		switch (pol->mode) {
  2463		case MPOL_PREFERRED:
  2464			hit_idx = NUMA_MPOL_PREFERRED_HIT;
  2465			break;
  2466		case MPOL_PREFERRED_MANY:
  2467			hit_idx = NUMA_MPOL_PREFERRED_MANY_HIT;
  2468			break;
  2469		case MPOL_BIND:
  2470			hit_idx = NUMA_MPOL_BIND_HIT;
  2471			break;
  2472		case MPOL_INTERLEAVE:
  2473			hit_idx = NUMA_MPOL_INTERLEAVE_HIT;
  2474			break;
  2475		case MPOL_WEIGHTED_INTERLEAVE:
  2476			hit_idx = NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT;
  2477			break;
  2478		default:
  2479			hit_idx = NUMA_MPOL_LOCAL_HIT;
  2480			break;
  2481		}
  2482	
  2483		if (pol->mode == MPOL_BIND || pol->mode == MPOL_PREFERRED_MANY)
  2484			is_hit = node_isset(actual_nid, pol->nodes);
  2485		else
  2486			is_hit = (actual_nid == intended_nid);
  2487	
  2488		rcu_read_lock();
> 2489		memcg = mem_cgroup_from_task(current);
  2490	
  2491		if (is_hit) {
  2492			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
  2493			mod_lruvec_state(lruvec, hit_idx, nr_pages);
  2494		} else {
  2495			/* account for miss on the fallback node */
  2496			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
  2497			mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
  2498	
  2499			/* account for foreign on the intended node */
  2500			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
  2501			mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
  2502		}
  2503	
  2504		rcu_read_unlock();
  2505	}
  2506	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

