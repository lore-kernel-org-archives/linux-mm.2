Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625C4CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A26C6B00B8; Thu, 28 May 2026 05:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979D46B00B9; Thu, 28 May 2026 05:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8904B6B00BA; Thu, 28 May 2026 05:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6546B00B8
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:59:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A2FA407A3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:59:17 +0000 (UTC)
X-FDA: 84816380754.13.A270F58
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id 43DDCC000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:59:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Cx/KDjUw";
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=SzY55nFqnsKo/LgokyYRTDsyvITE44X205hY7udu7SU=;
	b=A0Oql1BHWkcmaQFThFX5Wwm+o1g7YBm/sj0p74n9i+Fj9LZAN6UZdHonXO5zqkzT+TOhLA
	tzL1z+2gEQZB0+HWSAz7xUyFOpdifofQ2/ofrRGHDJBbpa7TF2lCx7ghW9foBJ6tUxQy7g
	OIleU57ZB1L2aokUllIcDUDysd29OGY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Cx/KDjUw";
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779962355; a=rsa-sha256;
	cv=none;
	b=GlGhfVN5gyykmWKiT6a+lI4cMplQ0XLPSYh5azDKWOc6XS/a8h9dq8YxE6MRNCrDNYCY3j
	MwQiSi9Ni1jEjvVUe+E/LXcC2Y+6egGvSDyJf9lryrq88u7S/7/j8UBI1KPXs8CxH7Qc8r
	A2cLauARXPQ1oXY7odle0iMcsLDFDyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779962354; x=1811498354;
  h=date:from:to:cc:subject:message-id;
  bh=YcSqz8rIvXiHdos4uH83Vi6/oh8HcyJ26DO/bOa0v+Y=;
  b=Cx/KDjUwngJWmG9b+5D3k7sPvvDyhkwqX10zV2FIhCZgR4LhuxMRror5
   dVv6pw2KEF0p3e10Ib/8MPaVDjSzREGf6zFE38bhPtAiWvNB/675a7DmC
   E/LmetajrDgLuA08CAraptstIrJftEfOUxvE2yrnnI8CrGdpxMQHnes5v
   waqNuQFEaxQnHM3Yr4zd4KWZRXXlVeiLqbqDznPNhr5weHnXM5XPTeKDT
   Wfy1DZz+YjpN6P9EriCDv4DqPGxxJhrCdBzTYt2YESHfRvC83yRiwq2d7
   w3zgmZ07VN+JCXqvc18qIorBR5J8QYVq5YOVuH3MFsYZ9Arn96va3Uc5x
   Q==;
X-CSE-ConnectionGUID: Y4OIK9C6Sma667u6OALOqQ==
X-CSE-MsgGUID: QUTJl+w3S0e9hrJKb16wdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="103475571"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="103475571"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 02:59:13 -0700
X-CSE-ConnectionGUID: 1FjPrJFQQ1+Oxhf9yFQ8GQ==
X-CSE-MsgGUID: THrLNQ56Ta2juBfqiuYhwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="239933896"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 28 May 2026 02:59:10 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSXW7-000000005oM-1KFU;
	Thu, 28 May 2026 09:59:07 +0000
Date: Thu, 28 May 2026 17:58:34 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <kasong@tencent.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 199/420] mm/memcontrol-v1.c:651:24:
 error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do
 not support implicit function declarations
Message-ID: <202605281711.bSeZlErK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 3sted87ayc8etau333zxrbqbrtmwdui6
X-Rspamd-Queue-Id: 43DDCC000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779962353-209832
X-HE-Meta: U2FsdGVkX19tyEA95fzH8l4JVr1SCvQLxo8LkMQmmC/3qqDNjLin22Uj7/mnCeIddVXGimX3ivmvh3ZY0lUqS29oxZUjkObGwtRBGDDzvyDHMQq640FKLHd0Ieqywb8/RWCkejAoonwx8pBRYUkhMj/Rx3Ux0/tjywPz74PjPRBjcGwZssPM5cGbY4jk6hSF//e+0C3lHlQuzwPYurTDi6f9b+mbcNGczOguuqfCAjEXQBaZvkGr5novhduMmSTDrERpU3tvl0A9fVM5viWO0yhYzgXHa+JOX8Xsyyaw4fQusQcFWFSSmyRjHKMGjXGdOS0RauqO2oS6HocOOE/SgM+lAMHRfryus8rGwOyWYCV+9HHlK4QT6d18xaSUQuzgbCrQGIM6aeDt40spfTtivxOG8YfNbBy7wwrWslHt9qjZkgR4zu9sYkUwmKXWdB1JF7aQq2KxXrTAoOlGRWRjjcFF0ZueDAPwavKlWwLvI/7je/WS/gsb4ErJsE5JrPQ3QoCcMmNAQdF5C1YBuGdaROOZ2z6Iska1yJCs06+RGXb23znvy3PBkpH4VFzo6MzYn0o6lstuucvQB64/NGE5UjmxDZpozMm/fBZDp5KD+FQj+D4GhLBZzLr+nRbHiJOiFZFMLj8uiwmwfazRe4RBipHvl5k5k5FLf9bobUUeqcBUsZgdGrkBJAdP2NXsHikgjXmtEniufEPd6Jf/zd45mWs0D6q+uX1l3D2JYUYcGf5ik58JjwT/z/A8+YNXtaq1in+jixONDVHB60YcEtBuVYlwpW0OMyg3KApON4QwtvIfyUxFVsFO1+05urkaUee5smhrENpCKeRg2NkYbkrgBB8Kdbo4I+AMK3ugoe0WS45FltDMsrkXEgHDm6hlZ/FUCKa5Sw3Gv+xayZGOm6HBoOuT2fLoD2AGUCl8YXXoWMm6fd1//Zibr8PtN3cEMtPo+9Ffn1Vm5PFPVhZ8LEd
 8OzcUqCk
 QYHBiBdy+sQvyaWdbJLbbomOENdFIXonTlAa1D6NvV+pdev5e5MrC6A0njpBXNSdBK2a+kQ9t2u0Q01uXR+3GjPFwD1FD+0ePYrPzZmIyb1MJppxj0R36hpXbTi/fGmb3e1HcL0h8Fa16Dxf1otxv+keH41FfnaZV/x5Kp7ETEwNckkPUfq/ab92tNvVd/2xRooVikjPr2rJzW/UMqvyt6Byeh1Qa0UiOeVidnfUCHueZbvJL2ZZm9/PmC+PowQ/Qtto5nCYIbVr9QwzIFrhV52Vgp7bA9QmDVnZw1hw+xxWURTl/RO6T8iQJfE4ktNwER9Rb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   8a74e22643189e0ae339afc91110ddb4cab1941b
commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [199/420] mm/memcg, swap: store cgroup id in cluster table directly
config: arm-randconfig-004-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281711.bSeZlErK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memcontrol-v1.c:651:24: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
         |                               ^
   mm/memcontrol-v1.c:721:31: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     721 |         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
         |                                      ^
   2 errors generated.


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

