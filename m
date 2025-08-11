Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28305CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 16:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81D48E007B; Mon, 11 Aug 2025 12:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59A18E0060; Mon, 11 Aug 2025 12:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F4C8E007B; Mon, 11 Aug 2025 12:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCC18E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:38:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AB5A115505
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:38:14 +0000 (UTC)
X-FDA: 83765034108.29.72417C1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB1571A0016
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:38:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mMYdM3t0;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754930292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLBFO3sE0QYmvWUOye+kTLxoUvpDpRSjLo8uYeOXnGI=;
	b=ucgaXsGY+vowUb5dyMmGqkAZQPEDudbsweLkDF/0BoBR+1LxVkZzprhL7tl54at0bw/yHJ
	ofCPLzQOkCnsoFW0y2mLGbRFfF+f8q80+qOMgwOXuVZwobs2+yn4ymaXwxHYYcGtBTjedD
	YgsgX7PH+psKnwu+XSakhprrqsjYU1M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mMYdM3t0;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754930292; a=rsa-sha256;
	cv=none;
	b=HHkd3WzrX6TPbowngZfivvh+QTvrTRGoyEpO+oem/bKk1QpDpPmG36epeH1nc/DCTxf6I9
	8hftWQpRV0AL8zp9Lmwofg2ehMYTEV9YNc4bdhn/bKKqSlloABDmJcXcODYG5KULpPDfCF
	qeTgarruBLmpdYl+TEdkZxlggYVYmDw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754930292; x=1786466292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BbTuVHr+iVlQaDazHxjBuHQ4kO0f2OoDYdK/7dg5KIc=;
  b=mMYdM3t0Gh5Koy4glT88Pn4EsA1xtPm7zx3522azmGbP+PQH2QdpoUBi
   LKlMEOWxELAN0cvMODrTKZ/2DUSCNy+z7UPFY3h19S5YPv3O+FxVS0JtL
   GKGX5iXJAORsVl3/7l8YL+OrvKWDd9pn/gFbTMbBlQyHLYhxxu1ltnmur
   IfmGZtm0M9PkI1J90OgKGeXXKip8pvetxLPucuRaoYjGeiSwokvw4xi8e
   tJb5gXmYjJOOQJp+G+cmQ/VKWMe+En6s8wMTUHQLv5RMBMTdQoJPLBjTU
   8wKHviS3wxM85xlwzbD5O5R04SKtcorP0deyug7k1k+UElDXhrb10eyQH
   Q==;
X-CSE-ConnectionGUID: u9mhAAavQQ6umj05l8vaVA==
X-CSE-MsgGUID: zt4PqUvvTJiZeo0tam/cnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79758168"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="79758168"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 09:38:11 -0700
X-CSE-ConnectionGUID: TDP4/e4EQrSWCi7i04h+1A==
X-CSE-MsgGUID: 9c0zMKftRGWOAK/zIJc8KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="170164645"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 11 Aug 2025 09:38:04 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ulVWy-00062G-2H;
	Mon, 11 Aug 2025 16:37:55 +0000
Date: Tue, 12 Aug 2025 00:37:42 +0800
From: kernel test robot <lkp@intel.com>
To: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, bhupesh@igalia.com,
	kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	oliver.sang@intel.com, lkp@intel.com, laoar.shao@gmail.com,
	pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de
Subject: Re: [PATCH v7 4/4] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <202508120011.j4Pmr6Rf-lkp@intel.com>
References: <20250811064609.918593-5-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-5-bhupesh@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EB1571A0016
X-Rspamd-Server: rspam06
X-Stat-Signature: s64o5f64e85b54qwmit1fa9qay5txpek
X-HE-Tag: 1754930291-527148
X-HE-Meta: U2FsdGVkX1+nNWjIAThJR0MbopNePtVgLB1ZUDb6yUCwECAStJDkCdAthw2rlGheI+CYFR45U+M//kR57Q18Xt7cF9iBquOvDoD0c46we6WsPFpAwughh+nMjZyU+UZ/Qe/wNzcNcVnLOLcWr7LVoed0H6jZhSEkcRaZUPWYMpK0jEVKvBvFDcFxXUttZgXvOi0csyJvYHxqRnXxuvaz5n/2eE893qwTKc9iGO+FdrPxnAnz/Pahp9iUJc79eJDUkwB3PpQvlq0tI3nXt8LCYkAcTD2mrN7XbNWaBWTV72Y/eihmvelnMC4pGWaoy3TZKuAzyTnt3CPXwKOth3HQjiqo2TpsJ6A/iWYoAme908zcUGPDwYYcj+iN4qqAyAWtGdMI58LlTCJHDQVPQ4GmvI49vVE5S6TvnCzAAhgKuSti6DYVFTTxhlH7RgG1KO6E2TEj9VRe7HuRqrMAnH0hrc5T0fhFN8pasZkWa5Ftio3oh+Cwl2dqH+uEwuk/87/sjf0k42zGmbEs/6s+eLdl9MPjGmXVCLtsKUU+ge1Nq5+A/ZCoIGoty3rvKDB1+uh2UtyicGvnMsd+kBqykhJO14x2EhQiauI3BS+Gs1wIfcaZKB+e0HExajk172PpVrMXzncUVzOomuHmbpME0QAjjUcpp6owU0Q1jUFI/KGML/B2VyWk25/Oj9zaIe0MkSgyDeYFlRRqGP4Upk9MSUc3kN6a0PCCEiMdSVUYIiG3s9+QLFqGXVJnxIGej51qn06o0wVre/0dASy4U6TqsaTOlf1goTWBHEKF2mTM5cir5HvzgLHmGZ+fKbvEqNEXZx04HGqAQ7xPYmLVUQqDJxZ1MgsFSeYcI9HF8nPE5KSvks0rxJgfGcWcRznaXtx2dkfd7/WHF3bxGQj8uAhlHnDkZORYSadKDBvKpDK6Bjq9Btznr5/llBiZSv/pkXgQNtPW08OXbrh/Fbz1WMANrds
 P1QsjvxP
 weKgWJT1ncZK4koQ7RWcSjZPXWfFUgZNDBnwKUlfJRSej9r4yqwovc6TPGuERZ0J0mt6MWkBiNW+B5hTajIxRzKeUc2QTkvu/vEZ92uPo5j1Xtf+tjzwi4teFXTo96kpJF0EhAkPZzOWZTR3i3G1jU8ilBuHvAf0kJCzBkcEx6GLs2DytzpPvTJLjAGEuT1dk3zLCslSv3B98iIU2Zrm6UrGxIy1Z11Ap753sdZWjL0s2QAZjZ6oLMbEHrEU7hoqRZ/FPHIPlXT8LyMBAlQEX8gGRg/1HqOKolDXi7v0vkRMy0veoKLkbqN7KFkzl3RKYLQUMPmi4vXQvg5eqn3k8rizmJ6sTGpZs3rlvTpFzxav/+QjzPG/8Rk5jD+0kQDxK/FpwppF+y6Onx5R591oML13u4zOvmBBhOPb20i2vLe2yTiwm8yOqPzTA7gxV84s726qIEp91+F6ijkvlBTWul1Xx2jSIRz5Wy7Yo/KRZY4dwZdk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bhupesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250808]
[cannot apply to trace/for-next tip/sched/core brauner-vfs/vfs.all linus/master v6.17-rc1 v6.16 v6.16-rc7 v6.17-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250811-144920
base:   next-20250808
patch link:    https://lore.kernel.org/r/20250811064609.918593-5-bhupesh%40igalia.com
patch subject: [PATCH v7 4/4] treewide: Switch memcpy() users of 'task->comm' to a more safer implementation
config: x86_64-buildonly-randconfig-001-20250811 (https://download.01.org/0day-ci/archive/20250812/202508120011.j4Pmr6Rf-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250812/202508120011.j4Pmr6Rf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508120011.j4Pmr6Rf-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/sched.h:901,
                    from kernel/sched/core.c:85:
   include/trace/events/sched.h: In function 'do_trace_event_raw_event_sched_skip_cpuset_numa':
>> include/trace/events/sched.h:796:39: error: passing argument 1 of '__cstr_array_copy' from incompatible pointer type [-Werror=incompatible-pointer-types]
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
   include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
     427 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
     435 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/sched.h:775:1: note: in expansion of macro 'TRACE_EVENT'
     775 | TRACE_EVENT(sched_skip_cpuset_numa,
         | ^~~~~~~~~~~
   include/trace/events/sched.h:789:9: note: in expansion of macro 'TP_fast_assign'
     789 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/sched.h:796:17: note: in expansion of macro 'get_task_array'
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                 ^~~~~~~~~~~~~~
   In file included from include/linux/percpu.h:12,
                    from arch/x86/include/asm/msr.h:16,
                    from arch/x86/include/asm/tsc.h:11,
                    from arch/x86/include/asm/timex.h:6,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/fs.h:11,
                    from include/linux/highmem.h:5,
                    from kernel/sched/core.c:10:
   include/linux/sched.h:1991:33: note: expected 'char *' but argument is of type 'long unsigned int *'
    1991 |         __cstr_array_copy(char *dst, const char *src,
         |                           ~~~~~~^~~
   include/trace/events/sched.h:796:69: error: passing argument 2 of '__cstr_array_copy' from incompatible pointer type [-Werror=incompatible-pointer-types]
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                                                      ~~~~~~~~~~~~~~~^~~~~~
         |                                                                     |
         |                                                                     long unsigned int *
   include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
     427 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
     435 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/sched.h:775:1: note: in expansion of macro 'TRACE_EVENT'
     775 | TRACE_EVENT(sched_skip_cpuset_numa,
         | ^~~~~~~~~~~
   include/trace/events/sched.h:789:9: note: in expansion of macro 'TP_fast_assign'
     789 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/sched.h:796:17: note: in expansion of macro 'get_task_array'
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                 ^~~~~~~~~~~~~~
   include/linux/sched.h:1991:50: note: expected 'const char *' but argument is of type 'long unsigned int *'
    1991 |         __cstr_array_copy(char *dst, const char *src,
         |                                      ~~~~~~~~~~~~^~~
   In file included from include/trace/define_trace.h:133:
   include/trace/events/sched.h: In function 'do_perf_trace_sched_skip_cpuset_numa':
>> include/trace/events/sched.h:796:39: error: passing argument 1 of '__cstr_array_copy' from incompatible pointer type [-Werror=incompatible-pointer-types]
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
   include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
      51 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
      67 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/sched.h:775:1: note: in expansion of macro 'TRACE_EVENT'
     775 | TRACE_EVENT(sched_skip_cpuset_numa,
         | ^~~~~~~~~~~
   include/trace/events/sched.h:789:9: note: in expansion of macro 'TP_fast_assign'
     789 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/sched.h:796:17: note: in expansion of macro 'get_task_array'
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                 ^~~~~~~~~~~~~~
   include/linux/sched.h:1991:33: note: expected 'char *' but argument is of type 'long unsigned int *'
    1991 |         __cstr_array_copy(char *dst, const char *src,
         |                           ~~~~~~^~~
   include/trace/events/sched.h:796:69: error: passing argument 2 of '__cstr_array_copy' from incompatible pointer type [-Werror=incompatible-pointer-types]
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                                                      ~~~~~~~~~~~~~~~^~~~~~
         |                                                                     |
         |                                                                     long unsigned int *
   include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
      51 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
      67 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/sched.h:775:1: note: in expansion of macro 'TRACE_EVENT'
     775 | TRACE_EVENT(sched_skip_cpuset_numa,
         | ^~~~~~~~~~~
   include/trace/events/sched.h:789:9: note: in expansion of macro 'TP_fast_assign'
     789 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/sched.h:796:17: note: in expansion of macro 'get_task_array'
     796 |                 get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
         |                 ^~~~~~~~~~~~~~
   include/linux/sched.h:1991:50: note: expected 'const char *' but argument is of type 'long unsigned int *'
    1991 |         __cstr_array_copy(char *dst, const char *src,
         |                                      ~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors


vim +/__cstr_array_copy +796 include/trace/events/sched.h

   776	
   777		TP_PROTO(struct task_struct *tsk, nodemask_t *mem_allowed_ptr),
   778	
   779		TP_ARGS(tsk, mem_allowed_ptr),
   780	
   781		TP_STRUCT__entry(
   782			__array( char,		comm,		TASK_COMM_LEN		)
   783			__field( pid_t,		pid					)
   784			__field( pid_t,		tgid					)
   785			__field( pid_t,		ngid					)
   786			__array( unsigned long, mem_allowed, BITS_TO_LONGS(MAX_NUMNODES))
   787		),
   788	
   789		TP_fast_assign(
   790			get_task_array(__entry->comm, tsk->comm);
   791			__entry->pid		 = task_pid_nr(tsk);
   792			__entry->tgid		 = task_tgid_nr(tsk);
   793			__entry->ngid		 = task_numa_group_id(tsk);
   794			BUILD_BUG_ON(sizeof(nodemask_t) != \
   795				     BITS_TO_LONGS(MAX_NUMNODES) * sizeof(long));
 > 796			get_task_array(__entry->mem_allowed, mem_allowed_ptr->bits);
   797		),
   798	
   799		TP_printk("comm=%s pid=%d tgid=%d ngid=%d mem_nodes_allowed=%*pbl",
   800			  __entry->comm,
   801			  __entry->pid,
   802			  __entry->tgid,
   803			  __entry->ngid,
   804			  MAX_NUMNODES, __entry->mem_allowed)
   805	);
   806	#endif /* CONFIG_NUMA_BALANCING */
   807	
   808	/*
   809	 * Tracepoint for waking a polling cpu without an IPI.
   810	 */
   811	TRACE_EVENT(sched_wake_idle_without_ipi,
   812	
   813		TP_PROTO(int cpu),
   814	
   815		TP_ARGS(cpu),
   816	
   817		TP_STRUCT__entry(
   818			__field(	int,	cpu	)
   819		),
   820	
   821		TP_fast_assign(
   822			__entry->cpu	= cpu;
   823		),
   824	
   825		TP_printk("cpu=%d", __entry->cpu)
   826	);
   827	
   828	/*
   829	 * Following tracepoints are not exported in tracefs and provide hooking
   830	 * mechanisms only for testing and debugging purposes.
   831	 */
   832	DECLARE_TRACE(pelt_cfs,
   833		TP_PROTO(struct cfs_rq *cfs_rq),
   834		TP_ARGS(cfs_rq));
   835	
   836	DECLARE_TRACE(pelt_rt,
   837		TP_PROTO(struct rq *rq),
   838		TP_ARGS(rq));
   839	
   840	DECLARE_TRACE(pelt_dl,
   841		TP_PROTO(struct rq *rq),
   842		TP_ARGS(rq));
   843	
   844	DECLARE_TRACE(pelt_hw,
   845		TP_PROTO(struct rq *rq),
   846		TP_ARGS(rq));
   847	
   848	DECLARE_TRACE(pelt_irq,
   849		TP_PROTO(struct rq *rq),
   850		TP_ARGS(rq));
   851	
   852	DECLARE_TRACE(pelt_se,
   853		TP_PROTO(struct sched_entity *se),
   854		TP_ARGS(se));
   855	
   856	DECLARE_TRACE(sched_cpu_capacity,
   857		TP_PROTO(struct rq *rq),
   858		TP_ARGS(rq));
   859	
   860	DECLARE_TRACE(sched_overutilized,
   861		TP_PROTO(struct root_domain *rd, bool overutilized),
   862		TP_ARGS(rd, overutilized));
   863	
   864	DECLARE_TRACE(sched_util_est_cfs,
   865		TP_PROTO(struct cfs_rq *cfs_rq),
   866		TP_ARGS(cfs_rq));
   867	
   868	DECLARE_TRACE(sched_util_est_se,
   869		TP_PROTO(struct sched_entity *se),
   870		TP_ARGS(se));
   871	
   872	DECLARE_TRACE(sched_update_nr_running,
   873		TP_PROTO(struct rq *rq, int change),
   874		TP_ARGS(rq, change));
   875	
   876	DECLARE_TRACE(sched_compute_energy,
   877		TP_PROTO(struct task_struct *p, int dst_cpu, unsigned long energy,
   878			 unsigned long max_util, unsigned long busy_time),
   879		TP_ARGS(p, dst_cpu, energy, max_util, busy_time));
   880	
   881	DECLARE_TRACE(sched_entry,
   882		TP_PROTO(bool preempt),
   883		TP_ARGS(preempt));
   884	
   885	DECLARE_TRACE(sched_exit,
   886		TP_PROTO(bool is_switch),
   887		TP_ARGS(is_switch));
   888	
   889	DECLARE_TRACE_CONDITION(sched_set_state,
   890		TP_PROTO(struct task_struct *tsk, int state),
   891		TP_ARGS(tsk, state),
   892		TP_CONDITION(!!(tsk->__state) != !!state));
   893	
   894	DECLARE_TRACE(sched_set_need_resched,
   895		TP_PROTO(struct task_struct *tsk, int cpu, int tif),
   896		TP_ARGS(tsk, cpu, tif));
   897	
   898	#endif /* _TRACE_SCHED_H */
   899	
   900	/* This part must be outside protection */
 > 901	#include <trace/define_trace.h>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

