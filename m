Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEC6FEE4F7
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 19:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9D16B0005; Sat, 28 Feb 2026 14:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666D16B0089; Sat, 28 Feb 2026 14:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5661D6B008A; Sat, 28 Feb 2026 14:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4205C6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:23:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3B4A140222
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:23:56 +0000 (UTC)
X-FDA: 84494840472.06.BB5A40E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id 21D691A0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:23:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dza6hlPK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772306635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhIzrTtUMqa93CBU2YCTGkUhAinboBhL9pWEgiMzLIw=;
	b=Y6U50G03OuGCvyLCuppNPWhYM17jcm7pckTFRbMnMJnX0w9UR9eoU+bukDM1VuTOBu617B
	fVTm79BjF/Ohpdf41IyxXHSJQAE1VYxZwuLz3bUvIcKSAiLCHrX6e5JgiFt6x1KBKEEM3V
	d1hOKZ09nHW1NAP5zYtPEt2nPwqLugI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772306635; a=rsa-sha256;
	cv=none;
	b=upkQuNl6cYp2+tT4KjM3oJqhYn6Nq/gsp66W2i4So/syQVWAp93uDj80lteNoFs510sUQx
	BTldH+iqXg2W2T5yez+pHkbMMW4KAgS62lc0IqCAcV89sarA4kozuqr5vUipZtJVHgf3O+
	PzOWr0vJMT4rayp3Ps2iSX7BS63hx5g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dza6hlPK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772306633; x=1803842633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z0YaTKoQyykIK7uZDjwfoLRsCjKJQeRAJv81t7QHMDo=;
  b=Dza6hlPKPKu8zwYSVp42mRUoPqXfwWI/KmyJgUA42VJ4r5LYc9nf7a/F
   /Fydl5Hui34VOwo0enlB4D5JjfjZDDoQeqVK6zRYgbZZTa1LcI6sxzRcZ
   TyYsbnrGm4jZDWsxyLLKmY8y0qDND2i6BTQjlrwxIt8KgFZnZtehV/loI
   rk0VW/v4jUaXedUMV/kPMf5eVr24xdL1sIO/vZcobe+u1xp642B9YWoq/
   Fyiwwn/htdXAcwJ1ewjAmfHwr24Nf95ul/jLpHF3s9LVtK4QMM4y4eD/v
   oM48+n38rMOWcPA9Y8850pPzfbpdnfX/ClvRsSpao0t24V5FHloy5lIm3
   Q==;
X-CSE-ConnectionGUID: jjMX1eYpQ6qwYxuOZdFpOQ==
X-CSE-MsgGUID: rsbVIIJWQPaeckg07EWvuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="77233689"
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="77233689"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2026 11:23:51 -0800
X-CSE-ConnectionGUID: EiPGYCTiTI6ZZJtYSEOXyg==
X-CSE-MsgGUID: mKCrLRFHTfmk2fLG9wMivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="221854951"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Feb 2026 11:23:48 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwPuj-00000000089-2EHh;
	Sat, 28 Feb 2026 19:23:45 +0000
Date: Sun, 1 Mar 2026 03:23:00 +0800
From: kernel test robot <lkp@intel.com>
To: Leno Hou <lenohou@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Leno Hou <lenohou@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Barry Song <21cnbao@gmail.com>, Jialing Wang <wjl.linux@gmail.com>,
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Message-ID: <202603010300.t6GYRWjK-lkp@intel.com>
References: <20260228161008.707-1-lenohou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228161008.707-1-lenohou@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21D691A0002
X-Stat-Signature: mmr64wg3166wzueawgddkucgkwzsmd7c
X-Rspam-User: 
X-HE-Tag: 1772306632-436511
X-HE-Meta: U2FsdGVkX1/6Js9YQItIoFa5/qztFvd9GQLLKCPkgSEsKOQOHpGcHFUzHafxAYlzM2YMsXcfqWD8Ed2vZMRg70jM52Y4bO2dMU/1i8aXdV/jX8Q1G9i+ppyqWNfv+72TBVX/PBOUbNeqdzXixbn3imvIE+g19iqu67Wu8HaYbUq1adnru3fxEN3VUKqfhetwSTCEYbGz0zVBIo+VAYyVosJzU+DxlTXyiKFPEKq1q/Y+cRCvuwevc07lE8bPM3oxPls6FImh/4qlVJCJG1/j/0C1Pp/IUC7g6pgWKscpKbAsgqL/RfsAx9I5kF26Cts96aQzOu1NJWloZxE3QjGjhxL6GilA4M6zpiwsZWkldI8L92R+jKAAO8mDlrPH1GSl51ff9qF9GPXCZiiFcddgAXAHtLDj4yYTynSTSO4hT5wFokKodXC2Iu1ws4YAg7TO68VJN66v3myRt6QNVzO3hTHVNvsHbvJw/wxXLmT/b5jlk+WJHHW9LVzy3LKjclTOHZpM8l7nrgUzvZHy1LpRKxM7zk0MjXzNZILHU8pVeyT8v6EojBuHQHGEWGkmbOmjkawoWJm+XZtNJEVRXHmJdVMrcSknGxIVat94lTE7hTBslNmXAQLYMX8/0ybRhULnzjTTxTJgJdlKGMNSwpRV3NOgLNQrPBpH7PXCrsVWtSFmyRut1xWKqlajGa8NQeTBzM+UpD7oRpYLQdHK1UzZ9lpTlRNFOskqOOx3ZD3SKqHRBs7ddifKqXJ1K05W6VgaSDEY37AJE+IZIN+CAH0H7uVGq38rjJ4/YvOEvV1CbqFA3OrCcos2YFiJFsRMMjZu5iagQh5S3r/ZE6GnmuuUmrHNW56K4KS0RDEnDhVhZH9ym03rahD2K5cGco6mzjASXRskeuNRcXUR5Rg3ozMSvRX8QziOF3fXCFGe0K6amps7EZAQIxr2rq08rD8OGKWYpwbap/KfLeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leno,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.0-rc1]
[also build test WARNING on linus/master next-20260227]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Leno-Hou/mm-mglru-fix-cgroup-OOM-during-MGLRU-state-switching/20260301-001148
base:   v7.0-rc1
patch link:    https://lore.kernel.org/r/20260228161008.707-1-lenohou%40gmail.com
patch subject: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
config: um-defconfig (https://download.01.org/0day-ci/archive/20260301/202603010300.t6GYRWjK-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9a109fbb6e184ec9bcce10615949f598f4c974a9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603010300.t6GYRWjK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603010300.t6GYRWjK-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
   mm/vmscan.c:5786:48: error: no member named 'lrugen' in 'struct lruvec'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                               ~~~~~~  ^
>> mm/vmscan.c:5788:37: warning: '&&' within '||' [-Wlogical-op-parentheses]
    5788 |         if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
         |                            ~~ ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5788:37: note: place parentheses around the '&&' expression to silence this warning
    5788 |         if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
         |                                            ^                   
         |                               (                                )
   1 warning and 18 errors generated.


vim +5788 mm/vmscan.c

  5774	
  5775	static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
  5776	{
  5777		unsigned long nr[NR_LRU_LISTS];
  5778		unsigned long targets[NR_LRU_LISTS];
  5779		unsigned long nr_to_scan;
  5780		enum lru_list lru;
  5781		unsigned long nr_reclaimed = 0;
  5782		unsigned long nr_to_reclaim = sc->nr_to_reclaim;
  5783		bool proportional_reclaim;
  5784		struct blk_plug plug;
  5785		bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
  5786		bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
  5787	
> 5788		if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
  5789			lru_gen_shrink_lruvec(lruvec, sc);
  5790	
  5791			if (!lru_draining)
  5792				return;
  5793	
  5794		}
  5795	
  5796		get_scan_count(lruvec, sc, nr);
  5797	
  5798		/* Record the original scan target for proportional adjustments later */
  5799		memcpy(targets, nr, sizeof(nr));
  5800	
  5801		/*
  5802		 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
  5803		 * event that can occur when there is little memory pressure e.g.
  5804		 * multiple streaming readers/writers. Hence, we do not abort scanning
  5805		 * when the requested number of pages are reclaimed when scanning at
  5806		 * DEF_PRIORITY on the assumption that the fact we are direct
  5807		 * reclaiming implies that kswapd is not keeping up and it is best to
  5808		 * do a batch of work at once. For memcg reclaim one check is made to
  5809		 * abort proportional reclaim if either the file or anon lru has already
  5810		 * dropped to zero at the first pass.
  5811		 */
  5812		proportional_reclaim = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
  5813					sc->priority == DEF_PRIORITY);
  5814	
  5815		blk_start_plug(&plug);
  5816		while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
  5817						nr[LRU_INACTIVE_FILE]) {
  5818			unsigned long nr_anon, nr_file, percentage;
  5819			unsigned long nr_scanned;
  5820	
  5821			for_each_evictable_lru(lru) {
  5822				if (nr[lru]) {
  5823					nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
  5824					nr[lru] -= nr_to_scan;
  5825	
  5826					nr_reclaimed += shrink_list(lru, nr_to_scan,
  5827								    lruvec, sc);
  5828				}
  5829			}
  5830	
  5831			cond_resched();
  5832	
  5833			if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
  5834				continue;
  5835	
  5836			/*
  5837			 * For kswapd and memcg, reclaim at least the number of pages
  5838			 * requested. Ensure that the anon and file LRUs are scanned
  5839			 * proportionally what was requested by get_scan_count(). We
  5840			 * stop reclaiming one LRU and reduce the amount scanning
  5841			 * proportional to the original scan target.
  5842			 */
  5843			nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
  5844			nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
  5845	
  5846			/*
  5847			 * It's just vindictive to attack the larger once the smaller
  5848			 * has gone to zero.  And given the way we stop scanning the
  5849			 * smaller below, this makes sure that we only make one nudge
  5850			 * towards proportionality once we've got nr_to_reclaim.
  5851			 */
  5852			if (!nr_file || !nr_anon)
  5853				break;
  5854	
  5855			if (nr_file > nr_anon) {
  5856				unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
  5857							targets[LRU_ACTIVE_ANON] + 1;
  5858				lru = LRU_BASE;
  5859				percentage = nr_anon * 100 / scan_target;
  5860			} else {
  5861				unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
  5862							targets[LRU_ACTIVE_FILE] + 1;
  5863				lru = LRU_FILE;
  5864				percentage = nr_file * 100 / scan_target;
  5865			}
  5866	
  5867			/* Stop scanning the smaller of the LRU */
  5868			nr[lru] = 0;
  5869			nr[lru + LRU_ACTIVE] = 0;
  5870	
  5871			/*
  5872			 * Recalculate the other LRU scan count based on its original
  5873			 * scan target and the percentage scanning already complete
  5874			 */
  5875			lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
  5876			nr_scanned = targets[lru] - nr[lru];
  5877			nr[lru] = targets[lru] * (100 - percentage) / 100;
  5878			nr[lru] -= min(nr[lru], nr_scanned);
  5879	
  5880			lru += LRU_ACTIVE;
  5881			nr_scanned = targets[lru] - nr[lru];
  5882			nr[lru] = targets[lru] * (100 - percentage) / 100;
  5883			nr[lru] -= min(nr[lru], nr_scanned);
  5884		}
  5885		blk_finish_plug(&plug);
  5886		sc->nr_reclaimed += nr_reclaimed;
  5887	
  5888		/*
  5889		 * Even if we did not try to evict anon pages at all, we want to
  5890		 * rebalance the anon lru active/inactive ratio.
  5891		 */
  5892		if (can_age_anon_pages(lruvec, sc) &&
  5893		    inactive_is_low(lruvec, LRU_INACTIVE_ANON))
  5894			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
  5895					   sc, LRU_ACTIVE_ANON);
  5896	}
  5897	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

