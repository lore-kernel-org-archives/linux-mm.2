Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3BB5CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18536B0005; Tue, 19 May 2026 18:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9596B0088; Tue, 19 May 2026 18:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF7D6B008A; Tue, 19 May 2026 18:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C92C56B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:18:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 615CBC35B1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:18:23 +0000 (UTC)
X-FDA: 84785584086.21.569356B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf31.hostedemail.com (Postfix) with ESMTP id 326F020008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:18:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EI3eV54D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779229101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ag31Na7yPgZAWxrXQm5dYBNxF9fsBlG6k3n53GUHbgk=;
	b=vXCsOg/574G7JDIix5OLH34WSCfRsVcV8284ldW5c0biHuwKgkB6UYEAihfd68p+nSx+kb
	M6PyUF1XEB5IDRvpwoHnY8cbkSvkE/e2HWh7Khu21KmHJAekkYfva3MFe1Rejv2ordx0/7
	W88KYbqlAtxlHB8k7YHZBMsg1E5jXDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779229101; a=rsa-sha256;
	cv=none;
	b=xEhnidTD2LJ6HsRbyIywxUc0EEwTIW1JFseOXJyVi6uf4bZoyTyMIoCBqGabv3hd9HrxXW
	KtRRVXCnCaRbsMoIic6yw0eOCyTWSDMZS1tAdIPsZSQpCNXMk5ITMUW7dQduiaDGtgZwwu
	4WczfoPHgqgLRDP8xckFF3DR/XP+EP4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EI3eV54D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779229101; x=1810765101;
  h=date:from:to:cc:subject:message-id;
  bh=46cIP13NjFBNXD5ScduW0fUCMXqT/+0j1cSD/FS2JYk=;
  b=EI3eV54Dklx5J463r0ci00bbdZfTTbVvwbREm3DZZlqM7lcQxlk6m85X
   f63DAMr3emeiHHm2K4Vjf/+qLGNR6ZoWDdgFNWeTarS+/tj675xK8zEDw
   cp0Hifb2rctRZH3BrNQnY9t1gI11AnV8+v+Fiem0DHeorwp0ia6HTLAky
   SELX+PsEf3rouVNYCQn4Z2uyXaMElhF372YI2Otdx5rSi3sYMXn1+RyeU
   PkiMypqP2nviSTYfq3wAq05O4toFcPtIgaNjpGvVSDVVGDs8jgs0hTAZh
   ek5KgW6B48sJ6fQHwRWkejhJzrD/It4/lunP/vAev44mE538LEtSREYtn
   w==;
X-CSE-ConnectionGUID: CoQZRq8oTECuhFej8IXnNQ==
X-CSE-MsgGUID: iwmZlS6FQi+qnxKLnMFjxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="91516187"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="91516187"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 15:18:20 -0700
X-CSE-ConnectionGUID: FmZePiX/Rjq5BxipSG+Cvw==
X-CSE-MsgGUID: ImB/UQGwQZutYpLm2gfFUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="238922409"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 19 May 2026 15:18:17 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPSlE-0000000021T-06ZY;
	Tue, 19 May 2026 22:18:07 +0000
Date: Wed, 20 May 2026 06:16:25 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <kasong@tencent.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-ID: <202605200624.e9eMvkBW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 326F020008
X-Stat-Signature: 3e1nhxd8nazkwozfcmq15qo5yhggcc4k
X-Rspam-User: 
X-HE-Tag: 1779229100-237860
X-HE-Meta: U2FsdGVkX18kI5jCIJ6jkN3hDlbQbZB2Y3gROKLlI8dS2sODdMdkqtzydi/MjB96KfhJ4H6XM0Bd3LDcDYs7IN3MqyFgIMIeVIDW75lKCfN/VcVKA8oh1XBWkpOm6Nca8xdL3iliK+mZe4J1KdoXkGPd/bXiEB7HYr4cuh4T8la3e1Hwe6OmjXMEWRYgnV7607MU2jCP5lg2KR4AICwyM1Z/KrXXhpdInyL+puWM4fUALGGtGv/7eA+RtnjT1sxt4OTUFscLcxITFUAN9A12B8W1F3BvuPr8iQ/PGaVYEb8Rw0XkIBhnUTPfhOt5btpV5aD/8fVPlpEq5r05wYSrHtpyanUa85FfOaOSynt7whqO74O5klzXK5w6rEYaArBM4R4iFUo+9fuXKAkF6AcnlyduKr4YlHR+02Adnw5+vIQRTrDneBJjj/Ov9De0FeBx+0Jpt0IDe/W9Y+wemaiLrvj5SF7TfQMRTgl+ik41/u+E0cxsxK95zdtWPT6xiyUU1ltqDnIkf0cHEqKAQNyjIMxwuRZhw4cI6nM/vQep09rdT9HWGWm704YCB7sH4l7YLI9ctx99T78CFRto5ycRPHVvzJ9sElC1JSwBFCxMtYUn/OSe5qKUMw39FuR87ZeQJkO+uwhpGxCWelCkoYBkL/jWLgVyyR5EUqFcDX0SGNFxxZy1j9iUiB3U6Uyyrw6Hzt7VdeykSpEX2URUi4IcBquM9s4x+riCnEBhUvFuQABTofiTcoUuEjRlNG1r2w9/njt9FxPeRzHzKMd537+vIbFe7XjepTSdshPuPKmionuyidFrLJt0jkKuRfflhTRXJLtWyCWWiu3NN3L6OYLxSfzVCwp4OVgl6o3sSh6eahcxBYCQfcDJgcwnMZFi9oVafVpQK0KBq28PI2GkOvGVm8BBjVBnB3/RsyYsISNNLTdRL6v0PFQpGTRZzANk15aOESk9tCQdXPWdKRyhERB
 yzvyW1OT
 gXCauaofR2bLjVznnAZ2yYyD3WKpBvf//2I+0Fao1J6osWP8xUKpRrrnno0H1AbOcss48fJvMu61zMMuXbmK/O7ov2Cwlhqs+/TqVunwcAXofv0M+JkWWEv0AHS4MAHJehIwO5IWvP4adZEKOhHe/RqD6AVrUvRBn+a8ZEMv/ykBk36OKtYGSeI3vxTiqUprz9kpth4xIUHHvkVNoYo4LGXSmwU+c8rvXv+fUnnl2lIiw356zrqjj63Hwd0u/3whnwT1yBVW6qH6mGjelH3SU7+uBHmPTq9IKuUkM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/

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

