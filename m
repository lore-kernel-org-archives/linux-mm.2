Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D945EF06EE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 02:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB576B0089; Sun,  8 Feb 2026 21:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968E86B0092; Sun,  8 Feb 2026 21:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BB26B0093; Sun,  8 Feb 2026 21:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE0F6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:12:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E516CC237F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:12:44 +0000 (UTC)
X-FDA: 84423294648.02.D379B8C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97B5A140007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:12:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nGSWSU41;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770603162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ylA3L9mIqs8KbpDB18VcTbiBCtNhl7HkIshF9K8Us8=;
	b=B1uw9mL7FFA+089YT46yrvX99Y9JGt3JBPeF2x2KzNjeFOGwemH2z/LzzPGhzTbsZGF86I
	vOBZh9rMPKmkb4nsPAFFAvHUB8GIAR2+N37pWr2xVhI6EjGevI1qAi75rkxW3E3HuBmY/6
	BPW5aKxiAWPoVtbGjPCNJ6/O9t3SOTM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770603162; a=rsa-sha256;
	cv=none;
	b=4PnYWCkkdFJsl4z4sO+sFDxnU/KF6YkaGP4NbR3PE2/q0/DwKNulR6g0Wcw9N5gM2klbhj
	ktd5f0q6rHUMKBj9Md5fAu4WKeMyBm6BIofw6puz3zxCZVYIYjUHPP0BPpiYx6rmunlZpq
	O+FIxxP40NsHxeGRyVdCvIItQIBo+nM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nGSWSU41;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770603163; x=1802139163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JimVqJbGLErbVoUw3/1ZrbUgMnX0GyqHbji4ngZyjxg=;
  b=nGSWSU41GpjvY9Hy8eouGAZfOa0yDxqey/qi9He+9hIbreIpLD4M3KCD
   I+guWutsAKn2ou9oK1NTZkiZMuDTLeYiOdT7NXKUdW/ITpc8w13o7x0PP
   ilypnq3KSO0wcXdsw9dQ5JLlJHbZOsd8g2KaO+pkykz9zk1CHxopClYJt
   24vyqfhUn/mvsvabH5JUl/sHM30uO4idyzkc3nLRXPuqDLEH3yauym47+
   eHUIFjKJywIxKAShP46KyVJ1gzQDRkFW+35RFYWNt4x4iQT3BeuR6jMmN
   l9kiogy8uxOH/yMVsTI6eFiklU6yY/GO53WXzMPJ/IFU7y82zj8q3BkPl
   g==;
X-CSE-ConnectionGUID: xy/mo2QlQdKtentTu3ifVA==
X-CSE-MsgGUID: +xNQoS12TuSpLHFClUPAmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="83152696"
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="83152696"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2026 18:12:41 -0800
X-CSE-ConnectionGUID: xhkRuhfrTKGXkNC6w+H8Gw==
X-CSE-MsgGUID: V2n4KtwMTbyb4rXhMCRIhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="211241351"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 08 Feb 2026 18:12:34 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpGlL-00000000mVk-0Sao;
	Mon, 09 Feb 2026 02:12:31 +0000
Date: Mon, 9 Feb 2026 10:12:02 +0800
From: kernel test robot <lkp@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com,
	yosry.ahmed@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 18/20] memcg: swap: only charge physical swap slots
Message-ID: <202602091006.0jXoavPW-lkp@intel.com>
References: <20260208215839.87595-19-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-19-nphamcs@gmail.com>
X-Rspamd-Queue-Id: 97B5A140007
X-Stat-Signature: 8nzcn8bbtjp85xr8x7pqjdf8g6znp6qs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770603162-106238
X-HE-Meta: U2FsdGVkX1/vMVvfm6Bn6oXJX7SvymZ/hyXA3zP97uBefSmbistUKKAQk6pnooIlh3E0jHm2u+uix+LMQ8NhXex3ecQmGw0tu+2rRtzzupHQ3e8LOmUvu/+1Rb+199GEdndZc6eslalYrYpOFB6d7lgyQtgm6hEzzj4KmPwhCAhuNIT5oz2hDNlnoTlRNebeDM410PdGaKFeWY6mnH2Z1mXvGHLoKU9l9gy8+m2O5TCctc9FpwCp9yBxX0wF1/FUdxBqvnJtTxevc/2KTYafafZ8Y6Mwn0emwV3vjPQ+qK0DX4AnmqRuJCBh6L0OZ+UGQoeIkyDETsaPN+yEmsn69MNUwl9A3iJIplrsVOo07HEiYak/fnq/HgLlSNZxAzqljHFuw4H29SZeTH0WSryl5QpDiZ5p3SdYHYVyiVooXNmrgjhaB1rMPr1Gq6d/sfHAU6kpUC2rdya/PpZqQ2Lsh6FM8HxWWZX4+scp5mEbZMYpWs45F8dD149QXRRNml/sje/cudDOU6ejX+NXrBKG+qf7jFGMdCEPjWF/TpkgwtQk0LARHPjscFsadPXSj+zRiZcZsavZn8yxGLG4hrgCQLMPP0JZRcXLE8G+TVMH1rCPj3fgFttlE8KvtuYf5noKTTiqdrG+WP/BQ14CbaHgAH+cm/dM2xoxxlkVfBvLDjPo9V7m8kBuI0NjRVzZBEHm+in/YsHwtGUSyNtsfT3ctboWKbIzEwzNkzk/pDVoQdNvs83hCqT99NQUODtUYLSIqvgAEKGfgc+gkhfVr25vEX66XU4bIftkYTNNSnC5wWTepymtaaaaQloNUzZngF9CUehoQqVkhI3+Rp0xcpUpYL6QflR/edpg0kASTQx6O/cTa5vMerNGbSQU65v5Qg4u4qV3nsMrVvyUfFOshRo3VBDjDHKTOzsWKNjaLAh0I1LbBv5Ljz0vNjLHPDXVZXU0nj9LasOo/vC04NfBvq1
 sy3AAP2N
 8FjRf58SQgPufzIb89P9LByH3TJ/rW74C1LEDXqpyItjphtfvXbKBYHpWrknweGKfV1lNSXSeOPMLWxxq4khrJFNyWd18CJTXzF2c1uuwz8K+AkQF+yHvySqD9BSKTJvBBwteEg56hbz1Fvnnxsaw7nIQT4h0SFjybbYpq/8qHcfz+YoYIVOw5NSYqSmu8LtIPQap1IhhK627J2+fExsH4L3N5oB4nJxKQarFkn4+aro5dZPbyINQ7+vCVevNpD12aVBLoteAVr0jnqD6i3zH4BghRsWU7/ww+fhypbI4D+7YpR6kZEZMJb9aQjP6QN1faOjsBMcU/q2fUHClmVaKFHgqUwmomw2No4ObKMWhJ/6wqyP+LUJYDpBXL2paqzZ6TJTCkgpWx53dBm3At5Wv9a9MMV7Xp9ZkpZjTWMlFcqRReBm99uZNERYssT6HKYle8E2w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next tip/smp/core next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/swap-rearrange-the-swap-header-file/20260209-065842
base:   linus/master
patch link:    https://lore.kernel.org/r/20260208215839.87595-19-nphamcs%40gmail.com
patch subject: [PATCH v3 18/20] memcg: swap: only charge physical swap slots
config: sparc64-defconfig (https://download.01.org/0day-ci/archive/20260209/202602091006.0jXoavPW-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260209/202602091006.0jXoavPW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602091006.0jXoavPW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vswap.c:637:2: error: call to undeclared function 'mem_cgroup_clear_swap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     637 |         mem_cgroup_clear_swap(entry, 1);
         |         ^
   mm/vswap.c:637:2: note: did you mean 'mem_cgroup_uncharge_swap'?
   include/linux/swap.h:658:20: note: 'mem_cgroup_uncharge_swap' declared here
     658 | static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
         |                    ^
>> mm/vswap.c:661:2: error: call to undeclared function 'mem_cgroup_record_swap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     661 |         mem_cgroup_record_swap(folio, entry);
         |         ^
   mm/vswap.c:661:2: note: did you mean 'mem_cgroup_uncharge_swap'?
   include/linux/swap.h:658:20: note: 'mem_cgroup_uncharge_swap' declared here
     658 | static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
         |                    ^
   2 errors generated.


vim +/mem_cgroup_clear_swap +637 mm/vswap.c

   528	
   529	/*
   530	 * Caller needs to handle races with other operations themselves.
   531	 *
   532	 * Specifically, this function is safe to be called in contexts where the swap
   533	 * entry has been added to the swap cache and the associated folio is locked.
   534	 * We cannot race with other accessors, and the swap entry is guaranteed to be
   535	 * valid the whole time (since swap cache implies one refcount).
   536	 *
   537	 * We cannot assume that the backends will be of the same type,
   538	 * contiguous, etc. We might have a large folio coalesced from subpages with
   539	 * mixed backend, which is only rectified when it is reclaimed.
   540	 */
   541	 static void release_backing(swp_entry_t entry, int nr)
   542	{
   543		struct vswap_cluster *cluster = NULL;
   544		struct swp_desc *desc;
   545		unsigned long flush_nr, phys_swap_start = 0, phys_swap_end = 0;
   546		unsigned long phys_swap_released = 0;
   547		unsigned int phys_swap_type = 0;
   548		bool need_flushing_phys_swap = false;
   549		swp_slot_t flush_slot;
   550		int i;
   551	
   552		VM_WARN_ON(!entry.val);
   553	
   554		rcu_read_lock();
   555		for (i = 0; i < nr; i++) {
   556			desc = vswap_iter(&cluster, entry.val + i);
   557			VM_WARN_ON(!desc);
   558	
   559			/*
   560			 * We batch contiguous physical swap slots for more efficient
   561			 * freeing.
   562			 */
   563			if (phys_swap_start != phys_swap_end &&
   564					(desc->type != VSWAP_SWAPFILE ||
   565						swp_slot_type(desc->slot) != phys_swap_type ||
   566						swp_slot_offset(desc->slot) != phys_swap_end)) {
   567				need_flushing_phys_swap = true;
   568				flush_slot = swp_slot(phys_swap_type, phys_swap_start);
   569				flush_nr = phys_swap_end - phys_swap_start;
   570				phys_swap_start = phys_swap_end = 0;
   571			}
   572	
   573			if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
   574				zswap_entry_free(desc->zswap_entry);
   575			} else if (desc->type == VSWAP_SWAPFILE) {
   576				phys_swap_released++;
   577				if (!phys_swap_start) {
   578					/* start a new contiguous range of phys swap */
   579					phys_swap_start = swp_slot_offset(desc->slot);
   580					phys_swap_end = phys_swap_start + 1;
   581					phys_swap_type = swp_slot_type(desc->slot);
   582				} else {
   583					/* extend the current contiguous range of phys swap */
   584					phys_swap_end++;
   585				}
   586			}
   587	
   588			desc->slot.val = 0;
   589	
   590			if (need_flushing_phys_swap) {
   591				spin_unlock(&cluster->lock);
   592				cluster = NULL;
   593				swap_slot_free_nr(flush_slot, flush_nr);
   594				need_flushing_phys_swap = false;
   595			}
   596		}
   597		if (cluster)
   598			spin_unlock(&cluster->lock);
   599		rcu_read_unlock();
   600	
   601		/* Flush any remaining physical swap range */
   602		if (phys_swap_start) {
   603			flush_slot = swp_slot(phys_swap_type, phys_swap_start);
   604			flush_nr = phys_swap_end - phys_swap_start;
   605			swap_slot_free_nr(flush_slot, flush_nr);
   606		}
   607	
   608		if (phys_swap_released)
   609			mem_cgroup_uncharge_swap(entry, phys_swap_released);
   610	 }
   611	
   612	/*
   613	 * Entered with the cluster locked, but might unlock the cluster.
   614	 * This is because several operations, such as releasing physical swap slots
   615	 * (i.e swap_slot_free_nr()) require the cluster to be unlocked to avoid
   616	 * deadlocks.
   617	 *
   618	 * This is safe, because:
   619	 *
   620	 * 1. The swap entry to be freed has refcnt (swap count and swapcache pin)
   621	 *    down to 0, so no one can change its internal state
   622	 *
   623	 * 2. The swap entry to be freed still holds a refcnt to the cluster, keeping
   624	 *    the cluster itself valid.
   625	 *
   626	 * We will exit the function with the cluster re-locked.
   627	 */
   628	static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
   629		swp_entry_t entry)
   630	{
   631		/* Clear shadow if present */
   632		if (xa_is_value(desc->shadow))
   633			desc->shadow = NULL;
   634		spin_unlock(&cluster->lock);
   635	
   636		release_backing(entry, 1);
 > 637		mem_cgroup_clear_swap(entry, 1);
   638	
   639		/* erase forward mapping and release the virtual slot for reallocation */
   640		spin_lock(&cluster->lock);
   641		release_vswap_slot(cluster, entry.val);
   642	}
   643	
   644	/**
   645	 * folio_alloc_swap - allocate virtual swap space for a folio.
   646	 * @folio: the folio.
   647	 *
   648	 * Return: 0, if the allocation succeeded, -ENOMEM, if the allocation failed.
   649	 */
   650	int folio_alloc_swap(struct folio *folio)
   651	{
   652		swp_entry_t entry;
   653	
   654		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
   655		VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
   656	
   657		entry = vswap_alloc(folio);
   658		if (!entry.val)
   659			return -ENOMEM;
   660	
 > 661		mem_cgroup_record_swap(folio, entry);
   662		swap_cache_add_folio(folio, entry, NULL);
   663	
   664		return 0;
   665	}
   666	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

