Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48C9D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 18:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1817E6B0088; Sun, 11 Jan 2026 13:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1421D6B0089; Sun, 11 Jan 2026 13:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D666B008A; Sun, 11 Jan 2026 13:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E321F6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:04:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 987478D2D2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:04:01 +0000 (UTC)
X-FDA: 84320456682.16.11F7F7C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 53DDE120004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:03:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GFuxqrdp;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768154639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6u88UsEjVSnN6p8Lt8nDGjkGji6yQxSFFZBgB9gsjmo=;
	b=qNnkfUkEix+4mezs5fdwOH+Dgf6zJOHdE40obDjwrCqRH6gwMJh/I7INkuiMVyeJEfsNKf
	RIsvaEaZPtwuPpa7UJGwARZ4VnXGiOPnfHgpMbGn6DIhU4lZGX8/dh8jn5tYGBonKYx4s5
	dE79PqLR8JD4tWrvSkoUynz6NkgquGc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GFuxqrdp;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768154639; a=rsa-sha256;
	cv=none;
	b=uNUJu+Prqtiyjmvsskj1F8YZnP77coW6heNfY5ZBIWHtJKDTHd9a7NmLXmzmEE78vRFGGM
	JT/1zO8A/hsEmrb2pVRCJQro0SoHiB0KgN2Ej6Fv6eBlLincphuq6hR4cmCxq4ex3ATYVB
	KfyGAVhvrrdxmrxV3HSJeykqBB6jRZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768154639; x=1799690639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zbTnStaZRGXqT6TfypigN7OHnqv2DHIxSoAC5Gw88yg=;
  b=GFuxqrdpvJ4ZyDcybsZCmm4nHSyMkqJv4fdWgRXQWUPgMXRcV5C/BGHu
   ulK4FZI3RUX0Q2Ynpo79SPd0XpljHIOSPYZaVkqh+d/sNSiIKt5XXZB5B
   bcLmRD6WqkBWkQjuQWsbaRh0UMhHobBEEWyWwCQH6ZUTY1kgG6+6h3wbR
   mOW8mti9HdVN59KKB0v3EWi0v2RNIEWsJquNQCf0Bu8gH7/1XB4A0CYiV
   SmGbwkDt2779fd1jXmXNVYjaVPzRjyAePI5yb/xP4pcz+VqtQz4BJgKCK
   NlLo+mEl+0cggAXNGaMGfBaWGSKS90ncHp7XLLUCeuwl+hUMUYMcFFYiP
   w==;
X-CSE-ConnectionGUID: UVJmTIhbQ5y8EIRHgjBQSA==
X-CSE-MsgGUID: uqGe05ygRlSJKw6dGyaMOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="68452013"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="68452013"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 10:03:57 -0800
X-CSE-ConnectionGUID: pCRMPKXFTZmo/M3PkCS/fg==
X-CSE-MsgGUID: EucFxaScS++i9cFiaip57w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208441509"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 11 Jan 2026 10:03:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vezn1-00000000CbA-48AU;
	Sun, 11 Jan 2026 18:03:47 +0000
Date: Mon, 12 Jan 2026 02:03:31 +0800
From: kernel test robot <lkp@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
Message-ID: <202601120124.RK3AWOwu-lkp@intel.com>
References: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
X-Rspamd-Queue-Id: 53DDE120004
X-Stat-Signature: x6ykbi547hw4od4gcco7676sacq4dbxj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768154639-149576
X-HE-Meta: U2FsdGVkX1/euLL71WfCxBhWOZff3AQqpCOnz6PZyyuEgRz0D5mpj//1H3sftysojtW5Uaxv8koE5wX5HMPAvsAy7qEvEZhoiWXQ4zPaR75KTDHJmVTUbsGc9mGKUPcT9NUNEh4MxcEIIU7MMtXIS1WGBGY7t1KKgZVZstfP9/crmkO761HDpkkiyUbl052F1ynJQZXTYhLl7O1VzWJf/yZ2t188xDsRK6ZJttoKH93TbKz8ydDJthv/8vQVO9voyn6KWMdNvhBa32hk+BkwgipAYI7l1OmKxw2d00ROAHwhnsm0IqVari90HrtFqGmTaMulc/mfIi+ijVU1PYTgbg0mzWSScJH4XjshiplJYGd9Ptge4Ci80zA2y7AYcCkhEOIlWNEYm72VI3xHXu60Gr+4J4q38QmNgYIMb+LAQsqjdWO2SvOUEJWE9l3KLCFosGINaqac+0HgXNTHIi5iO37rXiHN/WE1OLY6axmTcbdxy6ygndItvX4cHynZb6Nh2/EROXWHRuV2HqdMuNCKEmeQGoUm8/QDkwPzqiW10QajFWQGackwteUko7PhHENqOf2h9MmPSoHWGjCt4LZzgrEgLGziTTY0mzbUMWAgT4UWjUmfmePWBG3knM4brwtQ1Vk92pbvm6eUehHm6otkUdke5JLMEBY/ghxr7Td+dzEVu64fvnv2EQmqdUPbYjKoXgBZn8hjJJ3lK3hly3Yu7Z9NHBpNn0n7fxEaq9NvAeGsNh320UwLl03TcjoO1Dsd7ozgCoLKziYvuMxP/loRsD8G4IcWx8SwhE/gdwSQvY0fxTNjqLlPASaXC3hzZk0BKtof5LxGc1x96IiNutuPWrkbXtmVyHKt6yNzJvRT13SEokFvXlEiq651xiXNAn2/MMfmDKIO65FIwyRFqZGJ9bClMzlo8KV3HSbah1dP8nDE90laUKRWUoQeNXIXm1G/scRcEVgLsddMlc+kS8p
 qT+e1L/h
 cLE4CW4++hqWcBSsmufYlgElwjT0DiXZHAFxChmV8dRdyWQ06EcMBW0WxmBZkLsbKlDKuYi2ae6SZhyOfoGkqn2/2ODPVKjLuR78xi+dOyvSpWvuzp8Gwn/d1FFVBFQO5j2i0ZRoHw70q5xi48Viwd9Re48Xzhv5heBiblXbpXH9OXNW0IrPKzYJmIHIGnvWcJxTayQoPmH/gvDGXbbm/vQHBMgE/ZSn9gi0wlyD+UKHo9ixTbtvf3kCgGPFxtqqk5nV2VZ3P9HYLDnzb6msWCjj9b0AFwFgRHjwJuMyQdi33bg80ChhDwDTo4tU8nC3hqPZ+1TH2ZDF36tVXltX1w2UDA4F5pAgQC8pCDDbg4OLoA3MdbiOZ+CuVWs0xVak/A0/Sh5u+KrzV7bOIyACQigNuV55+HC47B2QEZ+DuG13De0UbIFeWpn92brkMfNRtf/1fbbKBFo0urcI+CoNU80wJ9XCzgqn8oXILMU3oQcWuPUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260109]
[cannot apply to akpm-mm/mm-everything kees/for-next/execve tip/sched/core linus/master v6.19-rc4 v6.19-rc3 v6.19-rc2 v6.19-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mathieu-Desnoyers/lib-Introduce-hierarchical-per-cpu-counters/20260111-231206
base:   next-20260109
patch link:    https://lore.kernel.org/r/20260111150249.1222944-4-mathieu.desnoyers%40efficios.com
patch subject: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
config: arm-randconfig-001-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120124.RK3AWOwu-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120124.RK3AWOwu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601120124.RK3AWOwu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/fork.c:637:6: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     635 |                         pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
         |                                                                                ~~~
         |                                                                                %d
     636 |                                  mm, resident_page_types[i],
     637 |                                  percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:534:35: note: expanded from macro 'pr_alert'
     534 |         printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
         |                                  ~~~     ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.
--
>> mm/oom_kill.c:351:6: warning: variable 'points_min' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     351 |         if (oom_task_origin(task)) {
         |             ^~~~~~~~~~~~~~~~~~~~~
   mm/oom_kill.c:392:22: note: uninitialized use occurs here
     392 |         oc->chosen_points = points_min;
         |                             ^~~~~~~~~~
   mm/oom_kill.c:351:2: note: remove the 'if' if its condition is always false
     351 |         if (oom_task_origin(task)) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
     352 |                 points = LONG_MAX;
         |                 ~~~~~~~~~~~~~~~~~~
     353 |                 goto select;
         |                 ~~~~~~~~~~~~
     354 |         }
         |         ~
   mm/oom_kill.c:326:25: note: initialize the variable 'points_min' to silence this warning
     326 |         long points, points_min, points_max;
         |                                ^
         |                                 = 0
   1 warning generated.


vim +637 kernel/fork.c

6af8cb80d3a9a6 David Hildenbrand    2025-03-03  625  
d70f2a14b72a4b Andrew Morton        2018-01-31  626  static void check_mm(struct mm_struct *mm)
d70f2a14b72a4b Andrew Morton        2018-01-31  627  {
d70f2a14b72a4b Andrew Morton        2018-01-31  628  	int i;
d70f2a14b72a4b Andrew Morton        2018-01-31  629  
8495f7e6732ed2 Sai Praneeth Prakhya 2019-09-25  630  	BUILD_BUG_ON_MSG(ARRAY_SIZE(resident_page_types) != NR_MM_COUNTERS,
8495f7e6732ed2 Sai Praneeth Prakhya 2019-09-25  631  			 "Please make sure 'struct resident_page_types[]' is updated as well");
8495f7e6732ed2 Sai Praneeth Prakhya 2019-09-25  632  
d70f2a14b72a4b Andrew Morton        2018-01-31  633  	for (i = 0; i < NR_MM_COUNTERS; i++) {
25d942f31cc499 Mathieu Desnoyers    2026-01-11  634  		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
72456781289a6e Mathieu Desnoyers    2026-01-11  635  			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
25d942f31cc499 Mathieu Desnoyers    2026-01-11  636  				 mm, resident_page_types[i],
25d942f31cc499 Mathieu Desnoyers    2026-01-11 @637  				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
881388f3433819 Xuanye Liu           2025-07-23  638  				 current->comm,
881388f3433819 Xuanye Liu           2025-07-23  639  				 task_pid_nr(current));
881388f3433819 Xuanye Liu           2025-07-23  640  	}
d70f2a14b72a4b Andrew Morton        2018-01-31  641  
d70f2a14b72a4b Andrew Morton        2018-01-31  642  	if (mm_pgtables_bytes(mm))
d70f2a14b72a4b Andrew Morton        2018-01-31  643  		pr_alert("BUG: non-zero pgtables_bytes on freeing mm: %ld\n",
d70f2a14b72a4b Andrew Morton        2018-01-31  644  				mm_pgtables_bytes(mm));
d70f2a14b72a4b Andrew Morton        2018-01-31  645  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

