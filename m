Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3417CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D1E6B0005; Fri, 29 May 2026 01:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECDAC6B0088; Fri, 29 May 2026 01:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC3A6B008A; Fri, 29 May 2026 01:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C44FF6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:55:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 676E3A11AB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:55:49 +0000 (UTC)
X-FDA: 84819396018.02.FD9FC51
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADD40A0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:55:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DPLfV/RT";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780034147; a=rsa-sha256;
	cv=none;
	b=rcc/ROCsg2ZKdKDPKNTsrn1/o4bWge9QyEg6YBvw1OAXRZ0XalssE/dHIaZrHWhak9U2PC
	35WF1+jA0PTtQKt+TFO1ehjZponZYltDliFeNEBt5GC4KWyBhzZQ0tZo2TzziHGRn/0eOH
	2vsZU6c21a0ozmefFDwhyifx44Moij4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DPLfV/RT";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780034147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=1duF9vl2eNSzsTCC+gJjq1qmoJk6njlhRLK2k1VsfWg=;
	b=v3q5L7fZvVvj/Zd9BVJLe89fDnDwlH8dlHcvNV0UQ//dfG999LbGxTQzIurOUKgfG0E4Ql
	xl0elsRrIlIeV6tLU6r10HBzj4/sQMHS1Ar/FoaKdZBeFgAdMtRooAm+UTbO8fU1TnDuQ0
	uFozRxPhVQqDF2M+JVRv2vGd9f2bIFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780034147; x=1811570147;
  h=date:from:to:cc:subject:message-id;
  bh=JK0LUCE0peVgGY8IO/ARXuwtHxegxsrHg0YpZIXyQFA=;
  b=DPLfV/RTmlTDgZM7kqUhQtgbe51EMOLupZOiMOdY5MbpjIklNEzxI/i3
   xkUkg8/HEZV5q4Y96P6ZInqhUAsz+2ilG9CGsXBMpy744C2cHkZVT5qIL
   ZmV1uOiUBpNUCfogx/O0fDHEouzPeOCyX1fEItJp6QcyEslGtHbz9yH7x
   cXas65Lf2ovbwO+whavfBCntPtWELNah2MXbleXmm0bo5VbM+Qh4pxtLJ
   grPv67lHAz18okjxoP8i7tbnYb4UNdLhJs9i7kUogXne2KN5xtkXrHiaz
   f59CGEicVAmapx6FCiOog1V6beSdeSAaSG7tEeFBwk03j6hc5j1hSXxjd
   w==;
X-CSE-ConnectionGUID: Y7i20hPkToeT0OyaucYOJQ==
X-CSE-MsgGUID: vEKq4FXyROeA8Z96M3XaDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80996012"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80996012"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 22:55:45 -0700
X-CSE-ConnectionGUID: bA5KttrAQuWQN4a6VpMJBQ==
X-CSE-MsgGUID: Mlps386ZT8mJxptYAnZEiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="246767638"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 May 2026 22:55:43 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSqC4-000000006oc-2DgV;
	Fri, 29 May 2026 05:55:40 +0000
Date: Fri, 29 May 2026 13:55:04 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <kasong@tencent.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 8522/9137] mm/memcontrol-v1.c:651:31:
 error: implicit declaration of function 'swp_cluster_offset'
Message-ID: <202605291334.abNeADbG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ADD40A0002
X-Stat-Signature: o8jzc1tzdruz9tpjyqtboa8exxugq1u1
X-HE-Tag: 1780034146-696528
X-HE-Meta: U2FsdGVkX19k/Pnfj5lIgptXV1csbW1IQlyccULOIox9KxZyFobrp8RrbUt/9eEr4uNVeVTrt1u4GzPP9gTg5p4a2h9bkKMk6VD1NSHNxLtFlXV5a1bLre8u6IOSGnpxBuUdM8JFWr+DqOhG8yirqzXBV45pEQ0/4sIGXJoCOOM19PiEHACbjzVuXsMc0HmAgE59uI4bAG839Wtf0AvKC63RqjkUmv42jriubIwEb087boYFAgguUh7/18Lq+rwWZV2p01vGs7e+5sGmMTtxD7SNyVDGFVOWZE3TiwP8A+5/EA4O7MgDyVsk7ptB0FaT9kgSBcE8yL1pLY0ZWAq5aUbMMDNKO1leoA8nYTZuSnaUEmhAoExJTf1MIs59UE9Y8nulZ7FA12uYl+NcAgw1+pL7iKaRjuHvra1QgY3vFAFpTqHwi80XvbsOkkS2Zn0B7VJki25ebGncX3Tv0txTrF/MPbATUYACBEcVhiZxEe53o3ta0/fOEI+U6fhOpg8dMZuk2hw9ruTMZr3JmfsIe5OSo7knMMNGSGSNbRNjPF02KZ3y3+UWgSG6efRc1EriHVp0EUgCeyImrRiPcyP3ckmEOndlzwefpmE974PVqwbpYPCdGU96Qmt05xaD8+WLFUAMKmzkfOw9ftJhg1JSL35r6Uii3YyNVJR4SBbX9IWERvmCh1rwaCd36oZaLBy3Eo05E0jMKUY/qYJsLKd/J8TTXwvZ/UnDDWZkDm8XTg9WFb0ZNXNEdfI8N0L/orbTUlKbGpub27rmYX5Uj2jsAYqtUrgiuEs6XLfhkTkd75wh3pA/K0PG9dtcgtffjOrVfOf9N3tszlEypnmbgv2q4GRCEBMT3cWZ3ZX+xHlip8G/zXBViJD1IsdGBbJMHoj38hU+XGztoX+qo68LS8H3KaPcnoQdP0TPl1Mxwmo7NenaRFhC+hlmZeyKbo9HzCNnT+sioWITWapN+UST+Xq
 bo/5wfQQ
 up8tVg9NDC9BI61Gb1MRKdEiXkOSxd4rGh2L0wVD7WDed+G7gEewqBY2s7eMH/Ftw7n39J2w7HA6RP/niGQ89LpwT2kTOtn507A7XuLLd+CUk98CBe6k3ZxnvdvEgQP0q1+ncxusCxYKLMuLAf984jSP2GjQ0c052wdFPrirT1nPUAfSGbBuEIc+XHTEHL2uaWdEEynGMsSfJ4xYMq0RbvyU3wl/AOmIs1zQvY1qkYZOCw3HWzUMwNYTFGK3Af9nsXRKZTA6ZGVYWXUrr7JglomnrCLTbGhyFQbwL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f7af91adc230aa99e23330ecf85bc9badd9780ad
commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [8522/9137] mm/memcg, swap: store cgroup id in cluster table directly
config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260529/202605291334.abNeADbG-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291334.abNeADbG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291334.abNeADbG-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memcontrol-v1.c: In function '__memcg1_swapout':
>> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
     651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
         |                               ^~~~~~~~~~~~~~~~~~


vim +/swp_cluster_offset +651 mm/memcontrol-v1.c

   606	
   607	/**
   608	 * __memcg1_swapout - transfer a memsw charge to swap
   609	 * @folio: folio whose memsw charge to transfer
   610	 * @ci: the locked swap cluster holding the swap entries
   611	 *
   612	 * Transfer the memsw charge of @folio to the swap entry stored in
   613	 * folio->swap.
   614	 *
   615	 * Context: folio must be isolated, unmapped, locked and is just about to
   616	 * be freed, and caller must disable IRQs and hold the swap cluster lock.
   617	 */
   618	void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
   619	{
   620		struct mem_cgroup *memcg, *swap_memcg;
   621		struct obj_cgroup *objcg;
   622		unsigned int nr_entries;
   623	
   624		VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
   625		VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
   626		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
   627		VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
   628	
   629		if (mem_cgroup_disabled())
   630			return;
   631	
   632		if (!do_memsw_account())
   633			return;
   634	
   635		objcg = folio_objcg(folio);
   636		VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
   637		if (!objcg)
   638			return;
   639	
   640		rcu_read_lock();
   641		memcg = obj_cgroup_memcg(objcg);
   642		/*
   643		 * In case the memcg owning these pages has been offlined and doesn't
   644		 * have an ID allocated to it anymore, charge the closest online
   645		 * ancestor for the swap instead and transfer the memory+swap charge.
   646		 */
   647		nr_entries = folio_nr_pages(folio);
   648		swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
   649		mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
   650	
 > 651		__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
   652				  mem_cgroup_private_id(swap_memcg));
   653	
   654		folio_unqueue_deferred_split(folio);
   655		folio->memcg_data = 0;
   656	
   657		if (!obj_cgroup_is_root(objcg))
   658			page_counter_uncharge(&memcg->memory, nr_entries);
   659	
   660		if (memcg != swap_memcg) {
   661			if (!mem_cgroup_is_root(swap_memcg))
   662				page_counter_charge(&swap_memcg->memsw, nr_entries);
   663			page_counter_uncharge(&memcg->memsw, nr_entries);
   664		}
   665	
   666		/*
   667		 * The caller must hold the swap cluster lock with IRQ off. It is
   668		 * important here to have the interrupts disabled because it is the
   669		 * only synchronisation we have for updating the per-CPU variables.
   670		 */
   671		preempt_disable_nested();
   672		VM_WARN_ON_IRQS_ENABLED();
   673		memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
   674		preempt_enable_nested();
   675		memcg1_check_events(memcg, folio_nid(folio));
   676	
   677		rcu_read_unlock();
   678		obj_cgroup_put(objcg);
   679	}
   680	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

