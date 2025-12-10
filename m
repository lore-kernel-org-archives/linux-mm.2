Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F635D3B9B7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 01:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA156B0005; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0E56B0007; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B70E6B000A; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2666B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 20:36:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 296E8C038D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:36:36 +0000 (UTC)
X-FDA: 84201846792.09.3134D3B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 135B74000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:36:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zku8P4XP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765330594; a=rsa-sha256;
	cv=none;
	b=NgaCakQFZG4hehZcIkJEm0QY44V+G0edp4yTYqnnvoXPkoNIwwEF5PnsrjTemSVEd5Fj8N
	RzT03DlgftBcJZZTVor/A0MtdzI+SwCeUnpEhet2B2fNLi/Ra3XNRmOx5X1FKMx5m6e9J/
	uPulrcSthrn8Kn8A0AAJRqhAoioNC+Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zku8P4XP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765330594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkBPlVcB3gDbzhTDP+PFFevJPKgj6dN1oKtBBTf7IUo=;
	b=droltHbyxHv+lCNuI4ULRZzILvm/Fk+1BgAT3M0T3e+Yd4+h86bKs20Vn72pyYidOsr9gn
	t+vqkWnd1XAvQY7Cc7qLGlZJvHmF9Jn4tD/MEsa+ru04bvSyFum8J/q4U1OEH/pSYdh2CD
	5kBHJ+AkrXr7nKHOrd6LZT4BM14BJqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765330593; x=1796866593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=khF7mS5pnq1YnL1FTDwYR8u3vG6BRMqesr0++X/h1x0=;
  b=Zku8P4XPsNyseAo0Ie+oJSDYTX4NP5/wdsy6ot3acKJbWhWvDOrFrPXV
   eZeGGneulBXf7Xd9+qI6obWRGDXKdO4nxK9UzngU8SSWnO99i0bojgJPL
   Eo9sErCdycWRul3lxKP/suLMcYwrBvdc05DFU4yEYRwI4rsr9JZ1s+2mN
   4MKfTBAVTTLML50gRfVuD51O9gITxd1LsXpr7ksPmResaWfP/UYuceFxI
   NzRO1cQZ0XPVNt2PmdvB0BhKwzRQef9fOcZIEcv3uK2eSDGART4YB4+/U
   gNfep9bsrXu1jp2QMwdxl9IEWjv+pVu52RWFHMutmEj7VRfHQ4mpf3hGm
   g==;
X-CSE-ConnectionGUID: kkgTRBjZSTe8r2jQeZ2XvA==
X-CSE-MsgGUID: 9JBRyjuWTF+d1pVN9AkBHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="54842116"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="54842116"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:36:31 -0800
X-CSE-ConnectionGUID: u3aX/YPmS3elk3EL5uqLTQ==
X-CSE-MsgGUID: HK6gFFGXSX+9FE+AKcY2hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196281100"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 09 Dec 2025 17:36:27 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vT97x-000000002Ut-1bTw;
	Wed, 10 Dec 2025 01:36:25 +0000
Date: Wed, 10 Dec 2025 09:35:54 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com, chenridong@huaweicloud.com
Subject: Re: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
Message-ID: <202512100924.LqJqXM7P-lkp@intel.com>
References: <20251209130251.1988615-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209130251.1988615-3-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 135B74000A
X-Stat-Signature: e3bofy8f9wpd8sdhxfn531dty37omekp
X-Rspam-User: 
X-HE-Tag: 1765330592-778972
X-HE-Meta: U2FsdGVkX19197JiTKOvCTlimnDqjIDpDY7j6eXD2AGqVym+8DJPfC/AzL4T8OqPfQ3x9XaHfY1dW6k+Sor0WLiMkJjIEPtg5REQdHnf1Eh/zIlMKlB6E7bw1VV/5LXkp1kFwQqMeQ3IvqshVYJDLgnP2tfyU44bd8+wYe4HGoMRgDzUskyu24PzRrjGLJM+NcjIjzDUtnnkAwMB5OIxbmeIqHUoOpkKLD/0nOcF59mYUAJwIfokZuURfZ2LCsBiIcSqIVj8aLYbNzsXM2s2ltLubkxyY9XaAYP2MJfwQZvl72d5VKofjdm7azVKwD+h0ZGDFoB7lqEiFxS7d2Il9ePZ4BSCbZqkNg051sXztdENG43UUyjfEY+r9Hn2eKLC8f7os9W605OLZehTbjd8kwMW7Y+v5HkrUy9lrjCC1BcJlbrwyI3DNPLvI6ydSgHRBCFDJSln5OUjpZDR9jvuBFKcwAXjoUBwWnz+0v3TylRtcErJoG6sZyeinwMbvgqZiV9x3eBU+mAL+YBtAblz11RkMM9Uv+eUje+IYb17/R8sPl9INXm9zJic6kwYSvZY37kqCzjtNDXy78Oskk4YBxktBcoEKkJ8CwicPe9AeavBNmTD9oumufnwm5+lZud1wH86Kd9dlFDJAq5COLWsZsjJQk4YPzjrZWaJadenu6vW6Jb9MQ5y5Z+ydKLoejMn84526VAKxkBSpkVEQLA/ZGkCRYKts40lrQ19F2gBBMU3NfTnpj0xHhZLUzRIVTUe+xOOAkqr0rF0jWMlvTBTnoKqZ2BnP6rSdTbNO5dK4Y0A79aqLlUwCmy1/5pp1uNW9aT3UkEqfGpvlXdgnP4E90GPyK/SX5757hu2MwPBgGPMrw2Z1Cwtj4Idt7/QG1FiJeOhv2XctYSRH3q2DDK0uRLj3lV6iO9fUw5TrZIbR9+4iAKuK0e5wubg16YDAMSSmHzcLAW5UYgxSOmewUJ
 uSoApcjn
 9XSQaHkAtACnpUu/Fi+agv1x+DsHNw4a8UIU3XZs4Q/fhH/B84q74oStcFc32sphqqqCJoYphEwU2uM/6e8lVQb8JfCPq7T0PN/6JVw/L6xgPp7XpN3autwMIZWDadWNpbIXCE+BvfzN1KqocSWHLRDVQnut8pwV71/yJq8VHNldE6DSjyq1mwFy56t2sBc05rkxxgBJHk760xelKAm7URxChE9JMSNEQap+QX4T2h84ERHdPoPw48FR2wOSRa940VTUQRzeAKbMxvEXL7R/zeHd5MvsVfRKZL+qk8GxnQjgweNNyHOtelTw0XP9X3deuf+SgXM6wh0q/+9pdxjluF6bqSk48n7geuWk+ix9Zc/V0PNuVhmnMCKMR6KnSprzVGeWtK7w8yYS3VgJnkJHfYW6GDw==
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
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20251210/202512100924.LqJqXM7P-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512100924.LqJqXM7P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512100924.LqJqXM7P-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/vmscan.c: In function 'apply_proportional_protection':
>> mm/vmscan.c:2488:63: error: invalid use of undefined type 'struct mem_cgroup'
    2488 |                 unsigned long usage = page_counter_read(&memcg->memory);
         |                                                               ^~


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

