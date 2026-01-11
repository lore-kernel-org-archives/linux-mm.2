Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00264D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 17:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F436B0088; Sun, 11 Jan 2026 12:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DBD6B0089; Sun, 11 Jan 2026 12:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E696B008A; Sun, 11 Jan 2026 12:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7D06B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:52:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B01FF160D42
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:52:00 +0000 (UTC)
X-FDA: 84320426400.19.7231439
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E1A8180005
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:51:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dt1U4NLa;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768153918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wluzTeW/vGXIBoBW+X0+ls9TRKGYqmH4YdckFNXN9s=;
	b=CmhiAaGB4Hwji3sQQzFgJp5VAUBYwWW/g4jsDN546HHSSqERkf9zCujuEBCG3uFp3D8oJd
	Ub2g9p8RIhrRT10JPjO3nwghmuVWcHn4RUDXPg1d5i/rX8IHEO2+n69mESKqz8XgJX7+vy
	3UnKdNMhN4Q7R5XrqHglZafPReuwYp0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dt1U4NLa;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768153918; a=rsa-sha256;
	cv=none;
	b=6tX/Ijh6aciP/m+HWk5C4VQ05dh/E/FN6HzXHFKpojWKH0RQD4IDAbslcWuLHoeCxw1X8E
	2FcjUSZsd3a6VRO8gJrmcVVpAUxKqeKn53wAkD5ZOi65Bg7EyFNb5QN+7Gu1iYU7AKp8st
	AwAnf9Pc6RSHsrs1KkDv6amfYxLzb+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768153917; x=1799689917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=viw5OtDo1SR27nNYQb3yaEG9m7nx3g9bn+c8S3YKMHk=;
  b=dt1U4NLaq4/lQfLLRH7k2zsRGgPN8srIr338TlWBzbOwQZ+juNo0O4WY
   xSwUeAxMFgiAt5MdrcIeooYL37KBgA2RocKVg92fXcsO4S2PCYR/WXUSb
   I3fVMuUrnlcMah+kAPDmlJ7aVUesPKUmxs1brGgGl8pLF/Fw7XFIxl/tv
   Fk7YgUMOVMedYucWMXk0/lB94zU7/+7axc9hRVxIqgU4RGQUXDqbijx1r
   kxjNHG3XOeB0HZrxbCjQkAfTs6KiMz0CZdYHzY2yvSBr4l6PenhtI7q7A
   ebBYhAvLjTcmx3T+6irA8mT0HasreY59PAl0xNsfcjptFHde6pLvYo3OW
   w==;
X-CSE-ConnectionGUID: f123gIrPTBG+8fTX13xn7g==
X-CSE-MsgGUID: T+cajcJUSLWCZlC7oG10xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="86864398"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="86864398"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 09:51:56 -0800
X-CSE-ConnectionGUID: BnhW/eJpSvecJ7L2w8Biag==
X-CSE-MsgGUID: 4j/oD/w/Tj6xSu7Z4uxK7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208052625"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 11 Jan 2026 09:51:49 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vezbO-00000000Cai-2yxL;
	Sun, 11 Jan 2026 17:51:46 +0000
Date: Mon, 12 Jan 2026 01:50:49 +0800
From: kernel test robot <lkp@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202601120122.xSlEJ1AJ-lkp@intel.com>
References: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
X-Rspamd-Queue-Id: 8E1A8180005
X-Stat-Signature: jumr8f9oa53rtnt1s35parpidd8kw85u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768153917-341100
X-HE-Meta: U2FsdGVkX1/9ZVJ23PbJBmKz7sKLtm2tysIn/D2jsGz0uzR4Cai2r89g6jao4DOvxhWWy8f6vHnD0ml+bYQO1vscnDM0fPOdfMuZcHKutoHy7l6Wn1GUAxd7HMPyi7AAMkIajQpBKD73fMJdvbwgiyWC1XimREF1x4wyKE2Ib06cHrR0f/Kdth42aEc9Ty49nAysDzFB8YXChnpc8I1PiGjTDbIOkp/yuWSkJLIXb1bHMitdq+EKLpiPdiTwYroYxwULUYARLpoaHC+xIEtitq6iGbfGFc6zOgYFn93fIMsIjKtbsccY3fUSYkXnIJdUrRES5Fez2ZQgV4vuFbdfbKpwL57/ZISlxl5n9LznMMxiYfWjggPptgOXcIm6YVTT/krigc+T/WUjvn6D46pIIX6KHSqmMS1/vW7XjBdAHgrZgLfuM8lK4A9Pl8YD06wmKTj2UDDyuLkIpKzNkQuojlCU5UxJgfCUAP94cphrXYW6iruAaUBd8WQvCTgO1rARJL4EWkDuw7Msl9FeyqI8xwZ1v+fr/OSHg7w+bQXzmfDbgZlZu/hT2H8nmyMhzdisU96krRotf1upEYPFZhtZiy4gVQuTE3/hRg60PtHSS87CdW4mn4CB0qFTZKL9SbHmlfARJt+GqksuwB0x/VXbC9s+7IvFuKanb0N0X93VhdEQHA3iMh/cPMMdAHzFxVhTTJiGEzZlUfqrWG0HCVvsMHy82OEFKKixfQDWVeG7F5ZdLM28debDvr6o1d6V4pVC6ipM2PyA57Az+lXCaJzY57Ynbb/q7ORBW8KqfRhsSMEqzM2ZjHUot9Teu4Um5CQMmRbuBR5gN2KyBGBqCF1haiUOimWZreRNd4ali7ITy/9AkW9ovkOE2CcZCD/MWcUswdccJB5/9V4dEknUgtLuIyeNddkFU4o8Cuu3S6/yWHS/YoxAiC2Be6kd2451yNQTagLrijiTY80msdzrNcC
 /itYfYSi
 tXzz7EDSVH8CON+GpOEqtROv+wL8TFGrqJBfKeh2YH6r2GkV05g5DyuzBT8XO51suPR/v5teDQORLigMllsZBVJPQRwwxY9OjzQCYkh1UtTQ9Z7blvwRRGRL3lZeNdfxM/JbUMQgtWyUD6hbkSyCJKaoABO2DB1e0gafSkx5Ti3HI6M/QU/AWDcn5Lgs1dg9WWZb/Hk82WB3vJDXE32GB15zBowh9OlPAJg0SLOJab2Yh94Y9VGF9L7YPC8OD25fTgzQQGglqMZEicVlzxz74uB08ZEnvkJdE2twDCBrI2m80O/NB8ZZdFmuywa4B6gxhTeUOoy6f2/xbNa36H0qTuMXiOAIGENHmd499bLUrgdHqel01KOfpVTa8uL0JKddQCwRiNHVDgqNGAckF1JrudwmTZpGYU55SpxoEQ9mSxoacke0zKk3gQkRY7GlePlZH28EOmPFYDbknU+mO7YbBUkOBZlKPl7QPOSh3
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
config: arc-randconfig-002-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120122.xSlEJ1AJ-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120122.xSlEJ1AJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601120122.xSlEJ1AJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/arc/include/asm/bug.h:30,
                    from include/linux/bug.h:5,
                    from include/linux/slab.h:15,
                    from kernel/fork.c:16:
   kernel/fork.c: In function 'check_mm':
>> include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^~~~~~
   include/linux/printk.h:483:11: note: in definition of macro 'printk_index_wrap'
      _p_func(_fmt, ##__VA_ARGS__);    \
              ^~~~
   include/linux/printk.h:534:2: note: in expansion of macro 'printk'
     printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
     ^~~~~~
   include/linux/kern_levels.h:9:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_ALERT KERN_SOH "1" /* action must be taken immediately */
                       ^~~~~~~~
   include/linux/printk.h:534:9: note: in expansion of macro 'KERN_ALERT'
     printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~~
   kernel/fork.c:635:4: note: in expansion of macro 'pr_alert'
       pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
       ^~~~~~~~
   kernel/fork.c:635:61: note: format string is defined here
       pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
                                                              ~~^
                                                              %d


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

