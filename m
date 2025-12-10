Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C1DD3B9BA
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 01:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4D16B0007; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B516B000C; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BD86B0008; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3EB6B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B7AE14031C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:36:36 +0000 (UTC)
X-FDA: 84201846792.06.00AFE84
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B1A3180002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:36:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QmLk0fh3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765330594; a=rsa-sha256;
	cv=none;
	b=BfhxKicifzKKkxuC9UZCotciOIALNWCVu7I2AddKiHCbfBr5yLy/fZgyyyfK2hXfGe/b+9
	cDkiZzijzVnc1RuyDtOVmXVPgrO88k3AaoH088OHbkny3CVLChjj9wbCyNCbFkYeQtq4Y7
	kRqRP7J5DfnUnoB8kdtPFAtMCDXbC+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QmLk0fh3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765330594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxbvGjr2Y2N79H0lgErfXlSxcOGyB5fPj6Y09U3ZMnk=;
	b=jUPnOqSlbXwHqCMGKXM82Yqe1Fiu+4bFAc8ARazobLJSZPwMIaCCz3qXRsaM1NgLYht1gM
	SVH2X57y+VfA75KnWWyH2kOZsAVvlYB35Dhk9QGEKE+DOWr4Wo4mnF6DMtJHmR2CmCWjF4
	L3Ki4kdnt1r8c/1nSHrS5TvJ3fSGfvI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765330594; x=1796866594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uSDeJjyIQS8Egw5OHsCLIaafNV3WCKJ/9T3J2/OTVzw=;
  b=QmLk0fh3XqNZHZmZ3HBmjEpAS9SXhDfJ48vLgQMiHTgbMblvTeQeb2Yn
   hNypRKLly4Nr4KLGZPDokHXVU++KU0tljMlnn7sWoiSI7feGwvM6Lc4eY
   VVcSbOyNZUS4+6n96lyuRQHGiDYcoA7G759F68at7t0T0Ec+9Bt9UCI/e
   EDku4gczrSX8rfnratckjUjs06JkoUSJJ7J7G7Fqn9B6E6c4UnIVK+dWs
   i30m4jzitZ7Yhvk4nWPEh8l7mfES2RtY21QpnaZUu0THyIcq4qWiwElAq
   iZ1nh0sghlzF7DWwkdrWPsgKnbVJdEL50Qh+9Fht/Pu1wbypPviCi1Xpd
   Q==;
X-CSE-ConnectionGUID: 1CkH9Y4bR/Wdz0LVgXKT1w==
X-CSE-MsgGUID: uQzZHQB6QoKvdFgV2yx7vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="84711136"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="84711136"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:36:32 -0800
X-CSE-ConnectionGUID: cnOgj/h8THab7ux0gRDrTw==
X-CSE-MsgGUID: TIzBoRUfRaGjipsGCM573A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="201303729"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Dec 2025 17:36:27 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vT97x-000000002Ur-1Se8;
	Wed, 10 Dec 2025 01:36:25 +0000
Date: Wed, 10 Dec 2025 09:35:54 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: Re: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
Message-ID: <202512100939.F1LEdUev-lkp@intel.com>
References: <20251209130251.1988615-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209130251.1988615-3-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B1A3180002
X-Stat-Signature: pwgxkd1cz4wczkuk3oqxq51p5tdn6bjz
X-Rspam-User: 
X-HE-Tag: 1765330593-707407
X-HE-Meta: U2FsdGVkX18/zXhgmJHRPIfFJlNmJgf9ZXSush775VxRrXv3advXIfaB17gujb1fxYKqqzqpLtYKi8Nzu3sAqDG7lESkyEkMwwpOC7PHdoPZxQaJrguNQdKJGsRMQfX4OQgTRZm1UGMI17MmVufkOfjOv8rXgN0Bgzg0ov46iAwD7et91t1rnoH3+jbt/R7DLLx4xcwZk7y0h7NmSxqoDoPGD6RkkgHMsXUAabKYJb8kl5Zd9QtCC+olVNmPVwtgicRdR+JCokJG3fJVCv3gnyVmHA95GV3kvHG0JPE8E0ybmF39pKA/SgoB72JfcGHjTk+02kMgql5Lt2NrG9Mvk9kITHgMDY3LwpTIr6LrtmhSFx+pfRvV2LI71COPJ8viatqXtkvDL2qyoPBq/6WuGIuxItR/v5i1bVvWe4Qu13tkQT0pLDlIO4zcUaTpioa3m77hAnX7T6bn2GTkBpw1LWNLSkwWrBRJo0Q55NYgpiU50brUqJC/+SSRc5FjxpcErSr0RwWdk6anaLlIUu0qynBi5uf3X+NAqtiwEXPAdqFiQRNcDeGpV+5/Ghp2D5062Mzqz+sMo6eI7MCKPNv0AE6OhPM/Q6tua5cnONQ4syw3vKISfNhhWSkAjI+ZkItZDsJSvY/xTlqYvFTxVcvKf8YjKb9Xw/h1THCb7Fb6uhhDeYqrGgGW1TcwRrtu6XQzx7gkJ7W0PxeYj0JI4A2pUm7MxLUiUULSYG+LLKfTNnyAadW5Ymn7UiaHCTeQzIdX2REBCQyQPqdK/2H9xvNHCAf9dFaK2HcHpFx3dNhObSZDqnK5mhfMqIWPhI09B3WhojMYxaV95Noh4mUozKDpMyXn6pdTXPbCAYplZ1oN4GFy/HytDNbznLwCyWNarnOau0QX5QgnKvH5+PYVsSfgyBdTzE/O90PrMipE0O5aPE09ynqsRWxUFwOJK+d5R8BcVPTLXdSauVNndr5Zqn3
 zdqV0H1Q
 RZ8ulfwYsUW2mWtb3siJTfDngQ7TwAmTyrcQoqP1qke1lOrTf02vPjO/9DTnVtnScCB3uysM8rURHHXB5mD9cJbJeA/3Kvw2ESJ2SAbjMoUA2ogKksYgExDpt+4omDirkKS7a8XWvh3XsUsKiaCkIQSwxq79mF76cpp+pzEbVnW9Y8V+GDfrJEOEY0AXBdR565iNDZNdnazER5/a8giON0HWEy1vw0YrOwtC4LobBYVlZmyH6LWoowLf3+FRSo7d67LP0XcqGR61HBrxG+ZDqg4JNxWxx/z+IOT8ha8JHAkYjkU5UXSa0stt1zniH6HTvYMFITJ6jEde5yMBht3460XUuElw+Yf9ruunOIpi9QEq+MbvM8ZKg+UBVEk+Cek2oA7uruYEh4YQT/eE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chen,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251209]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/memcg-move-mem_cgroup_usage-memcontrol-v1-c/20251209-211854
base:   next-20251209
patch link:    https://lore.kernel.org/r/20251209130251.1988615-3-chenridong%40huaweicloud.com
patch subject: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251210/202512100939.F1LEdUev-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 6ec8c4351cfc1d0627d1633b02ea787bd29c77d8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512100939.F1LEdUev-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512100939.F1LEdUev-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vmscan.c:2488:49: error: incomplete definition of type 'struct mem_cgroup'
    2488 |                 unsigned long usage = page_counter_read(&memcg->memory);
         |                                                          ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   1 error generated.


vim +2488 mm/vmscan.c

  2450	
  2451	static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
  2452			struct scan_control *sc, unsigned long scan)
  2453	{
  2454		unsigned long min, low;
  2455	
  2456		mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
  2457	
  2458		if (min || low) {
  2459			/*
  2460			 * Scale a cgroup's reclaim pressure by proportioning
  2461			 * its current usage to its memory.low or memory.min
  2462			 * setting.
  2463			 *
  2464			 * This is important, as otherwise scanning aggression
  2465			 * becomes extremely binary -- from nothing as we
  2466			 * approach the memory protection threshold, to totally
  2467			 * nominal as we exceed it.  This results in requiring
  2468			 * setting extremely liberal protection thresholds. It
  2469			 * also means we simply get no protection at all if we
  2470			 * set it too low, which is not ideal.
  2471			 *
  2472			 * If there is any protection in place, we reduce scan
  2473			 * pressure by how much of the total memory used is
  2474			 * within protection thresholds.
  2475			 *
  2476			 * There is one special case: in the first reclaim pass,
  2477			 * we skip over all groups that are within their low
  2478			 * protection. If that fails to reclaim enough pages to
  2479			 * satisfy the reclaim goal, we come back and override
  2480			 * the best-effort low protection. However, we still
  2481			 * ideally want to honor how well-behaved groups are in
  2482			 * that case instead of simply punishing them all
  2483			 * equally. As such, we reclaim them based on how much
  2484			 * memory they are using, reducing the scan pressure
  2485			 * again by how much of the total memory used is under
  2486			 * hard protection.
  2487			 */
> 2488			unsigned long usage = page_counter_read(&memcg->memory);
  2489			unsigned long protection;
  2490	
  2491			/* memory.low scaling, make sure we retry before OOM */
  2492			if (!sc->memcg_low_reclaim && low > min) {
  2493				protection = low;
  2494				sc->memcg_low_skipped = 1;
  2495			} else {
  2496				protection = min;
  2497			}
  2498	
  2499			/* Avoid TOCTOU with earlier protection check */
  2500			usage = max(usage, protection);
  2501	
  2502			scan -= scan * protection / (usage + 1);
  2503	
  2504			/*
  2505			 * Minimally target SWAP_CLUSTER_MAX pages to keep
  2506			 * reclaim moving forwards, avoiding decrementing
  2507			 * sc->priority further than desirable.
  2508			 */
  2509			scan = max(scan, SWAP_CLUSTER_MAX);
  2510		}
  2511		return scan;
  2512	}
  2513	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

