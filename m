Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08FBD2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169556B037C; Tue, 20 Jan 2026 02:55:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116896B037E; Tue, 20 Jan 2026 02:55:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F399C6B037F; Tue, 20 Jan 2026 02:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E497A6B037C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:55:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CEFC13AFCA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:55:52 +0000 (UTC)
X-FDA: 84351583344.10.FE0595A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2CA5140007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:55:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="H/zj/Jx6";
	spf=pass (imf04.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768895750; a=rsa-sha256;
	cv=none;
	b=OMDkVwNWDDPAgsBRMQbglLSkw0/0yd2MLZekqSxpL0SamlaeQHkTEIFYwKhpkzESg5uQW1
	KRb371+uWemlnJwMqJb/TFUxtWy7PVl4ai5Oxg5wzhhRrhCF2KOiYXmoRaJsIP+BiAReLt
	nsWZaRqTdr77oU/7d8gEXEWGkCp0nek=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="H/zj/Jx6";
	spf=pass (imf04.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768895750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vI0Ud5+D7pE/b5N08PTHf535OARjGZTRC7uiwx0TQM=;
	b=uW7JmUPEY7j0+ccrGogEzGxW61OzAGRTzs/2q8xgIVBV7dEv7Ufb2netuEzGal3SHtHc0Y
	eVk/36aYqnDpPF1W/qCp9/nJPuHbwuzmbAv929Sf7ZNeJ77ISg8ZGjEHjyJQhtD6+sBb5j
	r71fKsgGEX7l8bj6ovC+XKb+Atfr+3g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768895750; x=1800431750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=L3f5UMHF5dBPZaXmapr7xWQ6PtDNRb8PrrsGqH4TLK8=;
  b=H/zj/Jx6OnWfBi16NAI15JRUEYh0H7TJnHkcvLf2cmlhvqhGinfHNLo9
   PAdwJryZHEF4e7NFCIJb+SdO77y/UHo8U/gLAfYAkCXJCc04JseTUghed
   eaIFYtvSuTstpF6gWlgSpng++yrLHi9fy2ahQEr8+Wcfp3dE91HHVAfJD
   oOBjJcyTscLpuwFvvQFuoxb2q8bg1gYo30qZg7F+IvVdcihCtOIN7muCE
   2vEc/LVyz5e61a2/K9wkNdp5wKvO4XqeA3mlebDutH8qt+Qh6YM3udapQ
   8HRYQRJjBaWpmf6C52UIGo+R6RT/JUykRlUXfhVHnAXQMAcYr7svFwEP0
   Q==;
X-CSE-ConnectionGUID: HvXW6jhpRCq2n6aa4RRv7w==
X-CSE-MsgGUID: 0LUMx9GGRhiulc+Bz2iQ/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81207081"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81207081"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 23:55:48 -0800
X-CSE-ConnectionGUID: La31ubYVRuWO+3LEHm0g4g==
X-CSE-MsgGUID: B4jzu01bQ3Se71q1W8NARQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="206401252"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 19 Jan 2026 23:55:44 -0800
Date: Tue, 20 Jan 2026 16:21:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>,
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
	yu.c.chen@intel.com, zhao1.liu@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aW86/Nc2+bkopFd7@intel.com>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <3ozekmmsscrarwoa7vcytwjn5rxsiyxjrcsirlu3bhmlwtdxzn@s7a6rcxnqadc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ozekmmsscrarwoa7vcytwjn5rxsiyxjrcsirlu3bhmlwtdxzn@s7a6rcxnqadc>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2CA5140007
X-Stat-Signature: xqpuxpfej1m3yqtiofhe7y8bhywyhf7u
X-Rspam-User: 
X-HE-Tag: 1768895748-90939
X-HE-Meta: U2FsdGVkX193nlBIPjkfHuZbvM9NCNIrHQJB6BsJ4BJmbgOR/Nqn9sPkiUnAsxkXsjQj2Gk1kInZMZkX9jV6dnMZBnuy5Pr2GeUHgYA2lBKumu8go9B12o97wArNJXj2sYI5DGZgOcf3fUfjw5J01tqcNi5bcmzHovSLVIAPW/1VtcLLRwAuNwilPL7bS0NcS+7Ku0FYT7hxfXlwz/FFIBdoeSJw3EFWAi5z5Vn8qOMl7KI7uV/hmJD9ijrRCjkxoo1n+HV5GjKZJOhnhuzbdpstH0xD/edrc++E6pS/4Vk5mImqR/8Ij8xzQMafnor9ywM+hUig408xPAGynjLke6uVHDin6kWKzK7/B2jLxSEewy09iAp7/wT/JXqsfF+cdNLyeCHGMF4tqPSnTlK3GcT1gnzMYwfxxnOn+cSKjEHRmrE5BgEI247ChVZbbrPZHESkSxATN5DC5AsI+vwQuCJ+Rmi1MoNmEk2pN1xTn6eqLzjZFn/RdsORRjCnwcpVS+PchnPYTFhfwmI1dnd2igzgnsch9Jd4wA8I7jllEf1cOVCj2rXsBxbEunqxyDUiXS4rKLA5Zx4Q+SWdZhMhtXL7nhrvj2vAPscMcMoqlZ5CYElcMqp0OcaHB14BFBkEyJqLDFAjlgH3roU2rKbvh6rBqJgNWWLuVvMs3EW8igIllgQsVArD0OUpwPbRNz//wqw0kNB7A/X5ciiS/3vrda+UdUUvhMpA2mGT9OSq7EJvbeOpszkSowH6RWz5dhLxhOd8UeyxzLPAifLBHaBp+MVsN1anG8Id7zPs3TRTgJAhJLkAmtijFeY/2+PLQf8jM5fL4EGFmnEoS2vtoaiCQLvR20BtYyPV/lESnQPQzUOMUwghJycgctZwHH2hblahJTLVQQ8RA/SJRCaBhu5Q6HdvuwDltG8AfmpX1FlP5YUnlPb9QiZ83OBEQqU1msf8R83T0Z18sJzG/7s1hP0
 DKarparK
 VqJwXb23BlocxYwNIFYSn9SU7DopbuFy5euJ3Y6SN57qYGvZ1T1taGxoJ6vcnc3LOiHJCVw4kk8OG9R/6oM9UGKe7JkoEg4DZ0vmmGj56deeQl7OhqgjaR5mdfiocjX2kNATqNX81UaGoIENfjwXMQb/o2zzP/9LWhZiVQ8fHUOpBQzCc/r/NAqgeRcuAugrY4RPWv/HwJ1EDX+alM9VY1wExwpT/AgOqo++0oKqRX7CE5MT0ekeYmocFx9Ay8OqkCU83evtWxXfNe0bt1zvnW424k+Cbu8hu7pL9mc5hFMsybomxNXC5VAdBAIceWLJcehSq6oxAJATNzncnNeCqe5lKWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 1. Machine Configuration
> 
> The topology of my machine is as follows:
> 
> CPU(s):              384
> On-line CPU(s) list: 0-383
> Thread(s) per core:  2
> Core(s) per socket:  96
> Socket(s):           2
> NUMA node(s):        2

It seems like this is a GNR machine - maybe SNC could be enabled.

> Since my machine only has 192 cores when counting physical cores, I had to
> enable SMT to support the higher number of tasks in the LKP test cases. My
> configuration was as follows:
> 
> will-it-scale:
>   mode: process
>   test: mmap2
>   no_affinity: 0
>   smt: 1

For lkp, smt parameter is disabled. I tried with smt=1 locally, the
difference between "with fix" & "w/o fix" is not significate. Maybe smt
parameter could be set as 0.

On another machine (2 sockets with SNC3 enabled - 6 NUMA nodes), there's
the similar regression happening when tasks fill up a socket and then
there're more get_partial_node().

> Here's the "perf report --no-children -g" output with the patch:
> 
> ```
> +   30.36%  mmap2_processes  [kernel.kallsyms]     [k] perf_iterate_ctx
> -   28.80%  mmap2_processes  [kernel.kallsyms]     [k] native_queued_spin_lock_slowpath
>    - 24.72% testcase
>       - 24.71% __mmap
>          - 24.68% entry_SYSCALL_64_after_hwframe
>             - do_syscall_64
>                - 24.61% ksys_mmap_pgoff
>                   - 24.57% vm_mmap_pgoff
>                      - 24.51% do_mmap
>                         - 24.30% __mmap_region
>                            - 18.33% mas_preallocate
>                               - 18.30% mas_alloc_nodes
>                                  - 18.30% kmem_cache_alloc_noprof
>                                     - 18.28% __pcs_replace_empty_main
>                                        + 9.06% barn_replace_empty_sheaf
>                                        + 6.12% barn_get_empty_sheaf
>                                        + 3.09% refill_sheaf

this is the difference with my previous perf report: here the proportion
of refill_sheaf is low - it indicates the shaeves are enough in the most
time.

Back to my previous test, I'm guessing that with this fix, under extreme
conditions of massive mmap usage, each CPU now stores an empty spare sheaf
locally. Previously, each CPU's spare sheaf was NULL. So memory pressure
increases with more spare sheaves locally. And in that extreme scenario,
cross-socket remote NUMA access incurs significant overhead — which is why
regression occurs here.

However, testing from 1 task to max tasks (nr_tasks = nr_logical_cpus)
shows overall significant improvements in most scenarios. Regressions
only occur at the specific topology boundaries described above.

I believe the cases with performance gains are more common. So I think
the regression is a corner case. If it does indeed impact certain
workloads in the future, we may need to reconsider optimization at that
time. It can now be used as a reference.

Thanks,
Zhao


