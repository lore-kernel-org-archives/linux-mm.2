Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320F1FC9EFE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 14:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201206B0005; Sat,  7 Mar 2026 09:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEE86B0089; Sat,  7 Mar 2026 09:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091056B008A; Sat,  7 Mar 2026 09:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB0046B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:33:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ECB51A026B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:33:33 +0000 (UTC)
X-FDA: 84519510306.03.4494186
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5DF780009
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:33:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jwVbHPRL;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772894011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wm9AUsieKINCDCA+yyB5GmYYUIOngh9Dp+zyEKNVaGc=;
	b=yzBO9KHq9mLuWqUzlYODLZC2LXwlkXn/T9nGbU7Nx3ukjDv/Pj5EEzIHHoKoWWXhNOl0zh
	bnT3vZtC+7r5+vS8GejbNe65lzUETmHnNfW5tug/JSU2EjgQBuEYSuQf0zE48dUiPHwYb8
	ZpeoSUfx67ENKeLzRUUdF5Aj0bHo1og=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jwVbHPRL;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772894011; a=rsa-sha256;
	cv=none;
	b=Eud6VlyhAnwNEOzaq5ckToQQQD4rOsAVs3eicrH+wuVx9P76oaibGV1/AL0hB1/ovMOHj7
	2afj9okASKEFeATClul4LR03nO6dWQsaq4y7ufQf2A2mddcIbLsEvqf/7vmvxsLnnAtogV
	JMPKMmYxiXiKyNKCTL5MGlIlcKkEvo0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772894010; x=1804430010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MQ+yt5XOavwgGdppdINTOkJAiLO6+ABk5bgoDv4J9aI=;
  b=jwVbHPRLmf3jbN0Kx1hu2Vrlv3tTF1HprGJy5IqF75uft5+G8CSmi/1l
   XpP2DZuSTlEaxms+XEfKe104adWGJ25cqrCHpOOEQeysBcK54tpRBbtRK
   v8PMkXR5R0VyPXfCT3DMR6o5dfPprFiCu+OxH4B4MGJuJEm3RZ7UXT5Xx
   +u6sr7vnBb2A8nFyN6w1iV3dLx0Ah3Qa1C6Eyk1Gjac4CaSD4aQK4TlOY
   g6VXapwdVyMIxTU61Ee9IQdBPLPkUfMYNkczqee70EnK611pJVxT9dkc7
   eNB9PQKp3bU5wWfBbs82ZXVbwIZdfGlHiFALO4FVzYhJqj6Mff9z5Aq9T
   g==;
X-CSE-ConnectionGUID: N+qC0HgaRi29/0VjcfMi1w==
X-CSE-MsgGUID: A4tXhziUQBSWczt+N1Z+vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="74171590"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="74171590"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2026 06:33:28 -0800
X-CSE-ConnectionGUID: bfLuj/j3TcaKl8o5BKZvKg==
X-CSE-MsgGUID: 5d60jMlaTaa8hpa25AhjXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="215902739"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 07 Mar 2026 06:33:21 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vysiT-0000000025R-3M8N;
	Sat, 07 Mar 2026 14:33:17 +0000
Date: Sat, 7 Mar 2026 22:32:47 +0800
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
Message-ID: <202603072210.TSPUKsyq-lkp@intel.com>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
X-Rspamd-Queue-Id: D5DF780009
X-Rspamd-Server: rspam07
X-Stat-Signature: wknm3igefa4o4ncfzh7y6er6ismt644q
X-Rspam-User: 
X-HE-Tag: 1772894009-379914
X-HE-Meta: U2FsdGVkX1+wwvYgryFyiiHx0C1FzEgHl7nYTAbNlFzQd8lzM/DnZJhWQZDW7SMn2LA+C5l8Keb1oX9fsrB4wbP4ICfSeolqXXwE1NoxCFOybub5ttaVZYcznFAqb+4WcuLUg+j6SgUdYXOr6MjWbODo/qHLzy1Wv2U/isBLWkcaSauifWI2U3HugUy8m1iws+E88vWG+/5f8Owpm3wm2E/I0lEcb/0yernNeaWcMHbTi7Q15kjokYW8YedGylBB86/mvrSc57Fr0ZnHWLKK+mwH0ghYoKUAancdAbwH0u3CCYzu3vjgelPV8081Rz+Qif7yVgbVIyL4cILm+KKpX5mioP04HzE+60YRDtE8nWO1T0H87ohhlJLFFX3Fo/oxQAarMOvTFm0XcebXlfFUGNzUv3qqbUTRrl1eKGFbwjODb0FQIUamE8O35QGBa+IBBq0mZRbCQ5BlQLZxqOmoOTJ4RhOj5IWuj6HDnQ9EYavwBAwYbzAvMJglYgW5d1xbpmZQixZSUjRP+p6E5m+adBc+b6kE7i41B+XGAU8EEJNysL/KQx3zak+ujAQmHKcGypgSet5RGEplbhNSxSwiQysM/CN06yqdoB6osyzVV/t5vUQr1uxZUVyZ0pQ8CMu0P1IzRv52O0rIqQmCUTLtsUjyaYjMBdGLB/OqoWf0amYMxYxhfAZudJXEfMmU/tlAKVEcWpitKmEwsVRPFAJhvQ5yErXtJ+6Hd5bQdMSWU0ZlQwTjPeDIAqWwMSbaKTNtN+MYOMTpo97a2HSsc3Q15ocLNH/aHgRrwzBHyBs1vW21FyRW8X9YnVxzFLLdZ+eTUfri6ZgwaEX1FmD9q1/rz091gd38XyikzpbXcsQ87KaJPiq6yFNWwYN47RhAJpZ/QzGJr+bskcxM04wIsXWOqjOtoOPr6iUl4o2RB99xSTjWIOFP3F9JPzX7JQ/Wh7CpamKeegnjjA4pBl9tPu6
 65qZ5mxz
 atSaHVRVTHT2XYYY1MH17YsbIFcW1Y0BKozzopuLQkcqzbSdoe2LTXk5XrczII9twMiAan6x9j05TTA42aH7Tu3R5R2ZZ3/s0IX2YnyWJXUPQXuQbrAf8xCp1wLyr1wKuBzpO1lYGiaHikV7MhwYwoXbjr+zOl1E9QeGY1fgz9jXyfujezcc4VEbikFtBApqSgGcPdAOTuPxUIP5ILY9OoZKOk8tCktUawKupRfrf6Awn5DwGcQaFz5D4pqItSsGRRrCtXRG7P2QKgHX9YuFrCGhgCZys9DoIPnc54OI97B5kCTTCuvZ4oJUV6qtdUXVZN2v+Umm7IAHZf6YW54LGQSvXAOQjLtDc8Ua67a0CwUJosnEh5Hsn9lwHI4af/RrGoynm2+8TUYUTJosH+Vzu3dsCKg==
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
config: x86_64-randconfig-074-20260307 (https://download.01.org/0day-ci/archive/20260307/202603072210.TSPUKsyq-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603072210.TSPUKsyq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603072210.TSPUKsyq-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/mempolicy.c: In function 'mpol_count_numa_alloc':
   mm/mempolicy.c:2489:17: error: implicit declaration of function 'mem_cgroup_from_task'; did you mean 'mem_cgroup_from_css'? [-Wimplicit-function-declaration]
    2489 |         memcg = mem_cgroup_from_task(current);
         |                 ^~~~~~~~~~~~~~~~~~~~
         |                 mem_cgroup_from_css
>> mm/mempolicy.c:2489:15: error: assignment to 'struct mem_cgroup *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    2489 |         memcg = mem_cgroup_from_task(current);
         |               ^


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

