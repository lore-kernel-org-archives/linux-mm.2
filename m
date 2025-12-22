Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D587E6B25B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 21:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6233D6B0005; Mon, 22 Dec 2025 16:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A66E6B0089; Mon, 22 Dec 2025 16:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2B46B008A; Mon, 22 Dec 2025 16:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 375676B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:57:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD7BC58BAC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:57:20 +0000 (UTC)
X-FDA: 84248468640.06.2CC686D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 15C0A8000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:57:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DVLYAnZN;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766440638; a=rsa-sha256;
	cv=none;
	b=UoL98xk/9COEl2x+WWdkUluaa/wL8MbyVUK5Sn66gbMJwztNm/Jl8wsKOXZrEqTLHRHnkC
	vY5y0rdesFAeT8dl9aiYCQauCNywMb9WKbj3gqdd+xwS4Bu3zUf1A62TQ4Qm+eGU/S4SKA
	k67kr37Jkz/aw2ChHt94rC0kALNz0Hw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DVLYAnZN;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766440638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo7IoADobymOeYpH/0L2DXKEQzFVZlb1xBxH3xwIsKQ=;
	b=c5Qt1VIb9Ljs6gxAF6gDfvgxb31ysWqK0eszSBZ11pqjZPzby0F37p+mKv+VumCnnrrgly
	lEOl05tEAmkx7lHOsLUW56Ac4cibG8K4Uj4awZzNa2RV4CCkFxOlvHxAbhlAtAuGk5wqtM
	IKC1D1NFgYyUDvPUW3s17nMwxFMt1Ww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766440638; x=1797976638;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nb8viLRr97SzZ6mQSi19rbQ0/XocCdbDMzlJw7HgULg=;
  b=DVLYAnZNMaRgDxM6PwR87Eflhdgs3ffTTNhOaekyR2fyiG269R+p3HBG
   R+5cljUkoY9TvzQDQUvO9AcwbKGmxJmYW6MK/GW/j2TttG17xQdbEQ/Wz
   H8aje+iAUm8qPWzZfuwGeWGME4VvarH4iIl8ERQeGVxohFsZBIYX2qKDE
   r4QJtZ7/T+tAw8AeMjoKxC91iwe8vQEz1B+as9oOdXsmVjLBKkuUCZ/PY
   SkTHdRnYTL4MVLkJq60IWu6tny668+ImX1qjaZc1tahngmJmO9/7wa3At
   ITNZViEckl+MhAf+XXzi0Zn9ODYSkBKDpy9bWOHmlkKFxXeCuYmmtF9hk
   g==;
X-CSE-ConnectionGUID: TCc7Odf4ScObmD28QSaMMg==
X-CSE-MsgGUID: pCpeVa5wR+aa/h6lIhjA7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="79016454"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="79016454"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 13:57:16 -0800
X-CSE-ConnectionGUID: HjkeyhQ7RLuj5IQH3bhLXA==
X-CSE-MsgGUID: FYaVCt9SSeGIuO2CLx9ESQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="223101414"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 22 Dec 2025 13:57:11 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXnts-000000001A9-3mPE;
	Mon, 22 Dec 2025 21:57:08 +0000
Date: Tue, 23 Dec 2025 05:56:20 +0800
From: kernel test robot <lkp@intel.com>
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmscan: respect mems_effective in
 demote_folio_list()
Message-ID: <202512230553.LuiUveL3-lkp@intel.com>
References: <20251221233635.3761887-2-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221233635.3761887-2-bingjiao@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15C0A8000F
X-Rspamd-Server: rspam04
X-Stat-Signature: z7tds9pkwtze63z75i1f1pw95oyq1cth
X-HE-Tag: 1766440637-362408
X-HE-Meta: U2FsdGVkX198KGtzeMqZacFiQMPyjdXS0Qeq4PxIsyvtu03mp/TEX5e/EQR97DmHMRvk8PoqI3Wzcp4F0wlWWQPXRw1BBvvftbBHfWlvd3C8AouZh0/2NtRSJThgs3PSsIEdxDh6ba0QgBKflycQ7UEClAtTUY0MCDekeLiwtIqQmi0+71D/OnJ2jlM6OdLqwZ7LlHu6u5z+DiGKFBiR+0AEL1ZGbc9d23+pdfMHbIffbWDjhWl5D5IqqoAfA6czcceZ+a7kOfnKA2hPUHxdK9mnWAXMbarlxuzOrcLb/Bn+scr4cRTwPWXBheawdUcXSu6SLVnMU/wE8x6dsUgRh0IynELW42IDDTjDqpBHwwtvghTTW6VX5mPIDA7Ltfe0x7kGVxYf/PazmybS3N7TbVVawyDMkvhkL4ysh0mAXpCOMQrqW+refVqqq1flsp45QWG1GxnrVJmCnp/dPA3luaWC6nHB31BEPQPB8nCsXrRV/qwd75ty2GSsRctmAE9E5kzO2V4XyslvAgMKP1M7tbX1FAfgx6fLB4mEBPoW7WMhcO3jlnmBb5nL4cWLb4bU2mYy7TmlZtQ95dOxrT1G+ZAKYQ5YIXSd1tUKxbYjassAP/BUtTA1fQ+eixjI0lLXLh+Fphso1g+RYwCNcDZofix6ebrLRvY2juPfr4TbNMeqgfH6X9MLfksb/Jj4czHbXC0cNHLoYmeGQzNwODGZoK3lhOXN/YeSKe6bURejh1oqlxsgk6uEkVqNgrj4Ol7N+w9XzOyr73KpSDgt9pCe1Xd2oVmhri+37shWLDTNwrlxf5JvpPHCa6u4c7gCy/IRk7vgQuQoqLGiWTHkDTfUy8k+jlldLQcEzDiN4IQKATJ5StQhE026zzdt6Z8N4ahGMi0KTp9PjDQrtfXAYEO6NnaIS4jvFS/R6W5oijMv/y1EnRrl4J37XUbKdWREZpYV0aULpDd5OP6u2oFQ5TH
 GnJ/cY+F
 T8hOLs476aS9I/yrI65T9UZ5WBUHCCvT7U9TKo6YEUYLsEpNhv8LhH9GtdTzntLFzBZQ9rdDq8eQTQ+UgRMRDaXxXR9qVlNwXv6bHpYTuLY9t9n6sgU3o5OyHrsMa1wLCZBLtYlvA53b8KHVquF65qnUPMdECvNV4sxwaxJn0dtFMXXLNPrc2L937x2eusWagKU0WtwcBzkmHDOTdzC9Hei4gHthV1bDQChtF2rzGfJRkd35BEUgSj5+ITZlUeygIvLEuLtbfs3VybMLVHd7oHd2Tz7MVkpURQR8iXRrwEMSnGLS7OKJtPItCYYZxEUsxg2XU9QqKj39yBCwxEA+AFOKkoArhCSwzawZE+fmbpqCJ/lZdfRPBfqhF2RsRLz1e+SA09F8FQ8VDBzSUPWoKpa8dN+0g+WnO4X9QZ67Hw0TNsbBfyhRzzVXvzYMnkOzPcQUebMTwM6EyHT0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bing,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bing-Jiao/mm-vmscan-respect-mems_effective-in-demote_folio_list/20251222-074143
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251221233635.3761887-2-bingjiao%40google.com
patch subject: [PATCH v2 1/2] mm/vmscan: respect mems_effective in demote_folio_list()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251223/202512230553.LuiUveL3-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 185f5fd5ce4c65116ca8cf6df467a682ef090499)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230553.LuiUveL3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230553.LuiUveL3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:61:
   In file included from include/linux/syscalls_api.h:1:
   In file included from include/linux/syscalls.h:96:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:10:
   In file included from include/linux/perf_event.h:53:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:32:
>> include/linux/memcontrol.h:1824:1: warning: non-void function does not return a value [-Wreturn-type]
    1824 | }
         | ^
   1 warning generated.
--
   In file included from arch/arm/kernel/signal.c:12:
   In file included from include/linux/resume_user_mode.h:8:
>> include/linux/memcontrol.h:1824:1: warning: non-void function does not return a value [-Wreturn-type]
    1824 | }
         | ^
   arch/arm/kernel/signal.c:143:15: warning: variable 'aux' set but not used [-Wunused-but-set-variable]
     143 |         char __user *aux;
         |                      ^
   2 warnings generated.
--
   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:61:
   In file included from include/linux/syscalls_api.h:1:
   In file included from include/linux/syscalls.h:96:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:10:
   In file included from include/linux/perf_event.h:53:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:32:
>> include/linux/memcontrol.h:1824:1: warning: non-void function does not return a value [-Wreturn-type]
    1824 | }
         | ^
   1 warning generated.


vim +1824 include/linux/memcontrol.h

  1820	
  1821	static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
  1822							  nodemask_t *mask)
  1823	{
> 1824	}
  1825	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

