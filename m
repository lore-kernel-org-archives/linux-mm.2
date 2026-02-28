Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03290FEE4EE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 20:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698E06B0089; Sat, 28 Feb 2026 15:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670B16B008A; Sat, 28 Feb 2026 15:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5703E6B008C; Sat, 28 Feb 2026 15:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 475F66B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 15:15:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 026CC1C208
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:15:58 +0000 (UTC)
X-FDA: 84494971638.27.DDCD6E3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6C1310000B
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:15:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S1UZT41t;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772309757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+7gruwhhy02oG+7gbkE9luhnFnzdhwD35bIWupITR4=;
	b=OuF2cSZvis90quz3mpUcy3XhMtzCaL8CBjfXzjjDqxwhHcQ7V5Qm3QVypqYgPgNBHB06NR
	qzekQZeE75JWhpXIZvvuV/QznceudJzsITzn8xi/pM7fYpiSzpms1dpbDYSKaA+6hI7pE5
	82Bcur/vCwYZYlpFlxUHI0OEf+ZWB8U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S1UZT41t;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772309757; a=rsa-sha256;
	cv=none;
	b=OmoJ6pNHmNtUj3NSfiOTg+pm/MIeM1aXzVM6JyojFHEHJk0qzg5u2bvqbLX7ntnAKFl4Pj
	a4sFcSGagtZCFv0qSruYlJzQLv/tDQXeLrgFXpsJCAYSvMQadDKE/g0EQhi6ZP8vqkzWbg
	mqrj4Fn+a2SY8ID12ue2FbYtIlRdMmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772309755; x=1803845755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5bfbx1262s2r8MchzD4Pi4s59qo613AKwoiy3cpHTrk=;
  b=S1UZT41trJ0a+f7Rwd3L2ZjtKvQ/Z8dgSVEGaQUF8yAlTcBOdT/o3mew
   A3fSbO0DpI2+yq4vetGVaAAjZcPa0BKzSO+K2421F6cbcixwYVrJrkS5r
   jpbSXNhC+g1QmcpZFfK06p0n2kxd2PssZa1TvmJdxgaDJVe3/EHTn6O/H
   ho8V0EKaGsNbQsAsTfhB2Of0f8AH+xZa50NkG0Qg2eC0CMQYGN/3AWgki
   +WQFiInU5o4+sqEYkNNyaOZneFX/67+vndelyPAoihVUjap7jWwBeTPQ7
   c6uTZshvWxFw1gASP/Gx4mhQrlHtRP6CjPK9U/2HxrfdsqT85OVqaX4Nd
   w==;
X-CSE-ConnectionGUID: b6kZjNfnT6a5n4HrXkOn6Q==
X-CSE-MsgGUID: S3lo3So0RnyH23YDr8OLwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="76977755"
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="76977755"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2026 12:15:53 -0800
X-CSE-ConnectionGUID: LZDtiQVkQNq5oSQJ257D8w==
X-CSE-MsgGUID: X00eL+ZyQRGdIDrOBXn0tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="216463375"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 28 Feb 2026 12:15:50 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwQj4-0000000009t-41HG;
	Sat, 28 Feb 2026 20:15:46 +0000
Date: Sun, 1 Mar 2026 04:15:31 +0800
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
Message-ID: <202603010435.MBtvBCTp-lkp@intel.com>
References: <20260228161008.707-1-lenohou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228161008.707-1-lenohou@gmail.com>
X-Rspamd-Queue-Id: B6C1310000B
X-Stat-Signature: fjxzauymamzxhfiq9f66aibc4198wm4a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772309754-545384
X-HE-Meta: U2FsdGVkX18jI5+Y1wXLGFRuIE62dXniBA7NG7HDlGLQcaSeNiHxHF30It0tY81hhGRqs4NsoVUgqa0sDwPhFz8+rI58VWY7LTIG3cXrviYJ8y3ftyY7+J75XontkfMPJ0Krdt4g5LBNs66wWKOHSVmVOsM3Fu0oJPw2PZXcbiL6NWin6vrjlnziOwy7BFbOX+X5AoCC/b9PVMnYNswsu+YEv7zj4fJ/I5foMdmv/WqxBG0cxwGTgpjEX8WIZFu2uEm7WuUjSffK5+F0o8pfPklcs4kJcleHX+5DwUDdTHBlloo8etvPV0slA4uCfHJOg1IqKhNZzjmffiPqw0yA4Jk83JV2jBivtqDs6sPXZRHnn7VN2F4eGobFGAZRecXKIxhDiMfMLfqexd/8Hv/EKaqWdWeXBCc1HoqVnnFhAnvaPUlRsi78erSxhbw1vYCLNo5HqM3aZnlyLToYZ4UVu3i41RoEgEO4BSIRq1kgvY2DdDtuQBS0XKNM4qQt4om+brp70doDiMm+z2nUyhB0QvuZEAUQMgNaA+0LVV/uLv1rpAyrcJD+ygKnqJg8r5mmu7AQmR5Kvk038xX2D2+JifU1KmGagsqi/J2rDlvrNl9oIYG8UunpSKUCjQuTyvq6tX5s15btjDpFZY07tncOW1NgdEtYiq93zALZhP/DX/8bieo2rKGj/qNk8vd1nbR6DUNWxpVt9BYAkrECpEApWo3x9qdGPp91iOQ6hWoB7NGNpx+aG8IFGkDCyxpA2JrnJctEI250IXD6cQFHnNPI9uKK4+XfQO9HvycYjYcAOGZDFWTYRVGYPbVxGJS0HE3cYA//qBkqf9owFqmWHL6iljQpwX4h6AL2mAS5avMHMoo0SoFVT/YMkSCs6n1NJImjnLn4ggfTPF6eju1BLM0UZR4kI6C3MN3SAS7GcE2XW5h3zrIThV6fMm52oS/6ffHFtfS9AtUFCzL7J9W/fdO
 BFYukukC
 6b6QbIa1DM76HMnnfyCcCLotQCzmsIVm42vFtaWYiBZDLroi416mc98kXgjjjMwDZiTD2Cz61DGQigRiQ3dbxpvzM2nR0yzGD51B4IGIUPWDXKf9zrt6JVg1NjWnUisxrY3pQBV6qO5JKLxAOqZXED6n8gTuTGBOFwY4hUoJEMUcAmKapStqoRPGlW1s0GVWH48HLtNLcpy5PkhJ6umlZpDoK8BuJpyHTy59o90OMabMw4BswoOLyTGZwhfBHkMUMZ+I+5H47hj7ztOCpXq5tFCOSZKaUlWTtAeHRmH2CZTj7uDp9epcRwdR5qHLN0U+FS9Wt7TS/OictjWT0qfC05mjl2fkSsDGOnGovy5ew0pINwLilcNLwATRRTcHW+5ftEqnH5W9bCktjo/5BDCT1hGigL2+5+hL3SpMeDX/srr1Ke+dUKVlVsAUVl5BxZNQgEMS5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leno,

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.0-rc1]
[also build test ERROR on linus/master next-20260227]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Leno-Hou/mm-mglru-fix-cgroup-OOM-during-MGLRU-state-switching/20260301-001148
base:   v7.0-rc1
patch link:    https://lore.kernel.org/r/20260228161008.707-1-lenohou%40gmail.com
patch subject: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
config: um-defconfig (https://download.01.org/0day-ci/archive/20260301/202603010435.MBtvBCTp-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9a109fbb6e184ec9bcce10615949f598f4c974a9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603010435.MBtvBCTp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603010435.MBtvBCTp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                 ~~~~~~  ^
>> mm/vmscan.c:5785:50: error: no member named 'lrugen' in 'struct lruvec'
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
   mm/vmscan.c:5788:37: warning: '&&' within '||' [-Wlogical-op-parentheses]
    5788 |         if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
         |                            ~~ ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5788:37: note: place parentheses around the '&&' expression to silence this warning
    5788 |         if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
         |                                            ^                   
         |                               (                                )
   1 warning and 18 errors generated.


vim +5785 mm/vmscan.c

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
> 5785		bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
  5786		bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
  5787	
  5788		if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
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

