Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A7EC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD2A6B0095; Thu, 27 Aug 2026 20:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567696B0096; Thu, 27 Aug 2026 20:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431606B0098; Thu, 27 Aug 2026 20:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 117BB6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:42:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EC25C0232
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:42:53 +0000 (UTC)
X-FDA: 85148828226.11.7750A21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4BC31C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:42:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ChIAHRMc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787877771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlYo7JZKcFMgOKsLvshIMzC/ZB10koVeY1vHOvEGBjk=;
	b=cKEEpn3AinaO9uNIdN25tVUGCFgDksF/AfMKc60ayw1vy9KRQhtONItRkr5TUOk5ur5f3W
	OZHR6Y+0IHqAUj628O5SFScrifsMnRGKlHwh7DiKAttXpOkVPcwLwj31MfAGlUE363naNB
	SE6jahAUQ8SxoIxj/Fb9LP1cSXl7rZ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ChIAHRMc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787877771;
	b=Op3R1/RgC+hHc7zCPqGQF3t/YXKXOAQZGNZuT4WpkS3qmIveSKEpuKFLDp5D2+JN8/Rt8u
	sAt6g3cAYJKAaz+TUma729Y4o7L4v9DKshgUQ5ku6GeKfSfDXtohhWvwVO7qud099ypJh5
	DFILsBFNs+Ylm385xyIhPTdUbo5IBsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787877771; x=1819413771;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rXFUXxlKqBaXuqzdOpAFlhPtekA9ua3NlNpqEnttbNU=;
  b=ChIAHRMcPUB+f9Wqb0zFq8LmA9rU6UOdCUkcKM3IMHAtka7sfHCu8iyu
   UaO1lv9ftnHqNyf+tghC3mhhvsuEuU7mfc9EvOWHhu0DztyJDkAOqaXRy
   x2cO5txMRKYoOL3ciZEmgBsDWvZvxpnyOQ2GHIxpqoD30TDexlQXmcnuW
   WYelzCuCdNC28L6dmjlAGgBKm0RuPzJIJAgM7XnV+5spJvs3RJ+ZwkMVY
   cpY7+3zF2/BnyO46SJU5Pwi/cQzZKa4rjrF2F1VIxwo4HwwQHJYpCJZqR
   9kD0TACxI5qePYo0fnLl7dnQELsZL9WMOIQhSh+O1DiCOhyhl68Up4N+U
   w==;
X-CSE-ConnectionGUID: opoO802TTkq7vfegVlmq2w==
X-CSE-MsgGUID: sxHtg4bNSBWFb6XYkXQm8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="92245952"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="92245952"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:42:50 -0700
X-CSE-ConnectionGUID: XDqL6UANT36uEF3p2NzRAQ==
X-CSE-MsgGUID: xNdi13Q/QkOl/mSsam120g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="271831002"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 27 Aug 2026 17:42:47 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzkg8-00000000ACb-1p3b;
	Fri, 28 Aug 2026 00:42:44 +0000
Date: Fri, 28 Aug 2026 08:42:25 +0800
From: kernel test robot <lkp@intel.com>
To: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <202608280832.9NUcmGpu-lkp@intel.com>
References: <20260827124211.3b94b103@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>
X-Stat-Signature: amoxtsmdskhhu98jzwmcanyj9pa8ggcy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4BC31C0003
X-Rspam-User: 
X-HE-Tag: 1787877770-256352
X-HE-Meta: U2FsdGVkX19hCTEA3FA7kRZyDuILqDwEMUoJFAYfS8OCktnAQbxFi78lMXoKH+OWxFyZjIXjZjSkYSZIB2EBAHLD5T/FavQu3w5R7jEAuJN8h8Ny1rd1qwy1xgiiYuwVcm3uRVVo7VaccqjIGh7zZqGgu88eKr7IthTSZdcgWgvGOrpWRdyUNTbcuSG70yXAM1zzlQZ339ta8PXpD66maWzKo4QtqcDNVWG7dWaR0zn716rW2tFXnYTT87tZdMP37dR2rVzFXMX4KsGNIv9u2ldsOx2/l8cU5XONvZEzKC/eDHkYTx7h3QR1FlwNirnSe1IYnR1ZCgEA6EVXFpopA6B1/hdYLpXhtPKrbnGBKWoLU3jwgoL9aN2Gnl69kUrqmROObBug7GvY117YffM4FFAuguM63FoooFFQlWVEGwpr1pVm1ipNQTvEjZUJBlq+pO9OKLrcof24XTAAneD4TxGvebv7gjo3P5v16GBnCPuCnyRqEmpTvXC7cRNtg3Gtvgwfy7OIvmvtKzj0BsgrpbE5Mq7+g3tlfy1HLAkebHyxcw/1wMJLTH5L4+Et3DupfKl1JAw8ByVqtnd2tkTQhdnNuI8F0Ya+pX3KtAfB/JEsKLNBHDJFEyjECqmyDzNU4vBmkK5CuxHYHLHRrU3sZGVfqKnHQ2zYT27CejSfW3gyKQ1EFLCzMmEy5siC2UiKHGL+gykysRBxEmRsS+C3Wawl/QIX5Vkz97TcDKyeqNsEn4AX+l05G/O5f04923sQKslBxCxtvsbjQhrEIxJP5dSxmxTdAEwQd+FLBTCJA1/Q/BD7O4646CKXWGUIEy3SrXS+FdYzdie3Gv9GPtNh1PqSKaaa3NhQ/++zNrznJFlI7LgtHDPCBi3w14sPN5uGWBavkAvFT9mR9iVImxl8g44M68ri9zibamsCy0Py+1Eu3kWoK6LFVbPYJou+McKIHmjO2SP2pS+s+RHnsle
 eExFetWp
 urQe7PkOQ1eYaZxTd1GTlWvxFO8cMibmx90ArDJhZw6zm75JVOCmCedhpmMmmdsl5dWQatJn7EyYIZlZDfh011yD5oPONYgvN2ayjc2bqoRFpe3mFGAb5vQdLi8oTnH+8wLAEEul+ydbw073z3e58MXwvpO/hmmJ5Z+/NqpLrLIyqnSc0boRffqxTmPBKS/zQOTvWlfC2jijE9jc7JixmQ0YviidpiyFt0JtRQsy9oQa9MuKmaIiprVy7OHOz9oR52rPMgcDi5Jrj7XLNG3qtcdBeavro3JR0DhFeE83BjHQJxCbrm2PREdQIyiQcDEbx8xvMttqB7p9R71rzZqUXCW68KUgWpdCNjiRAXaqqXTkwDbeSiaHD/9lFEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rik,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Rik-van-Riel/mm-memcg-fix-UAF-in-drain_all_stock-async-work-during-offline/20260827-124211
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260827124211.3b94b103%40fangorn
patch subject: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during offline
config: x86_64-randconfig-074-20260828 (https://download.01.org/0day-ci/archive/20260828/202608280832.9NUcmGpu-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608280832.9NUcmGpu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608280832.9NUcmGpu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:2380:6: warning: no previous prototype for function 'drain_all_stock_sync' [-Wmissing-prototypes]
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         |      ^
   mm/memcontrol.c:2380:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         | ^
         | static 
   1 warning generated.


vim +/drain_all_stock_sync +2380 mm/memcontrol.c

  2379	
> 2380	void drain_all_stock_sync(struct mem_cgroup *root_memcg)
  2381	{
  2382		/*
  2383		 * Make sure the workqueue is done with this memcg
  2384		 * before freeing it.
  2385		 */
  2386		__drain_all_stock(root_memcg, true);
  2387		flush_workqueue(memcg_wq);
  2388	}
  2389	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

