Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25415CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E1F8E0003; Thu,  6 Nov 2025 09:38:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE018E0002; Thu,  6 Nov 2025 09:38:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F40B8E0003; Thu,  6 Nov 2025 09:38:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA7C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:38:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 081271DC757
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:38:31 +0000 (UTC)
X-FDA: 84080438022.08.562E43D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id 45CF4A0014
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:38:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PqtkRJ2N;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762439909; a=rsa-sha256;
	cv=none;
	b=c+OGJnjhV967RlmZiia3r1cYXRGcXTctGzvjZEjRSkql4e5s1u1+n6imZ+DftqXoXD8QEb
	trRxXhh0SFsDqHLVe1FAPCzXkJqTrHKrQ7l/YXJfT9UPpnuXlQj+Pv6/A6EMGvxQrfHpsV
	0IqxSYn8AAb6D5439pIdpm2vKwMlCck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PqtkRJ2N;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762439909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCE+9CfoyKV8XD5hYJc6hb73qx5l55wY+Ra4OYv3HLI=;
	b=zZJf8L5TOi1O5GONYcaPdEUYFSJ9X0hDE8LZXx91Il/T+fuApWXqo3BDKWWy1Mq78q4dam
	f74ZQGRUgZ5ntXrpjO1jivWilSJXcDMlXKdfy3C5iY7wTOxWmCoF1JD5mGDQO4WOudL24W
	3jT/kmDwwaL12suNeIiYyOb/WmVUGvc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762439908; x=1793975908;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qjA9ze1XqObCgR5Te5hbEW9wde11R4+WtauacdBNGBU=;
  b=PqtkRJ2N/cHUhQQizgwWyTARzg5buqBJhcUJVJEEhgXzsBuU0TjITIU7
   NFsbNAUzkg91BEbNPfcHpLeln/yxEowvvkBtTNfZeA0SwKYq5eDcTGsBt
   rd2MF0juIFotM/rYLy/W58BVu5W3L6RwQQDkicVlg3xXyuDK8uSgCrobS
   GvCWCKyNvuEQuXmMonL6FMapTLQY4zSeC3JXpoYOVW+Y2tIS9allM3Lbq
   b7Cr/0A2tMFHIBHQSm3SHcnyNspfvPk5V9jqBUDPiQ2W2qKXGviOJNL0X
   D1yW1t8Q9XUVIw4dsZmsREWNc8bZssJrOuvkoOcWKhiZrhfr0uj50R3J6
   w==;
X-CSE-ConnectionGUID: pD/0rF9SSEuqdj4oAW8FCA==
X-CSE-MsgGUID: 0Tsv0NDjS5m2eCAdcRbIXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="68436344"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="68436344"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 06:38:27 -0800
X-CSE-ConnectionGUID: QD+x6HneTv6Gu9i9eTzITQ==
X-CSE-MsgGUID: JYgGY/w/QwKQkjtpz9L0SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="187716231"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 06 Nov 2025 06:38:24 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vH182-000U1I-14;
	Thu, 06 Nov 2025 14:38:22 +0000
Date: Thu, 6 Nov 2025 22:38:04 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <202511062223.ocoUvCBI-lkp@intel.com>
References: <20251105161935.545400234@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105161935.545400234@kernel.org>
X-Rspamd-Queue-Id: 45CF4A0014
X-Rspamd-Server: rspam07
X-Stat-Signature: n57fsgyjupfj4tkp8ch8jnxah5wtk4cb
X-Rspam-User: 
X-HE-Tag: 1762439908-21409
X-HE-Meta: U2FsdGVkX18JEmvIfGSQMmhfIr7FiaSkj8yrJnBpuXHxUAtovEpwj8Ie26YKI32zGi3mt8BPkjGXnPytNshBvTobHteJPESMzpA0iXqfxm6JmZH7p9f9eMuo/u9ivtmc60+sH2Jfv8Sz7O0NEj7ynOZHmgZcrbrA4WA8XwtVrAnImKsM1KBb9zCmAmAzjIHJeXlud9A8QLIJa/hrltkBczhrUuutYOtFiBCYCHXHpuHLI5fVHHQ46/tgnnDJaNQ4Qi7Odlu8Ur+iz3YG5dKrKaNw43Q/yR5zy+Fb9dN6PPc8iDJPEvVbO82CstmoSe+nB3TItXywNsQC1VpYlDilgBFofS6TsuhXMY+vEGXOaHASsXf1kSE7M2u3ndexew3VxrRyju43OCI2/Q3FUufOHVxp+KimM3BZ3ALwoq3DdHPujwg5ONFz84RSWI5BfGUk5vhSITDqwGcCpGjRx34PcgrX0+xf/dB/vUlBNRI9nciKAViPrFAADMhBazGS++fdzqmSZkSBivANMaxgInqXVjSui13POBQVm0m++bjACfrTJLvf2//wRIK/+LMtIIzVhQxwE914EuazDPqADQmNRLAYyku1v5zVbWDj0d1m4PQX2cGgKpz7J+dz2T39Y2Yv+iuA7fh1dMThp+ZlEglnQhXv04m6vRRXDKC/pcwg+LQ8kKLsdNfyM9I8LlI2uxD24twnMyB7ntxrAh8+MgOGRGF9Tf7ps1Wk3G3ZX6v9sggP9MItTac6sCbdTaKkD5MtO68yBk9Jf/y48uUAkZ13XmZ5QxKut0ZTnsJ7AjwRHFbMK0HNDkyYwYC/G55koMEYnHJHMPw9n6zx1pFMq1VIYGeUmGSQVm0FsEs/6YosANLqhrINw0A6QK/xjAAtfRgT1ADie8vPlkGmGOazuIhl6BmW1yDo1xckocNdeqwcKGYFt54z+jhMl6Fy5brOhbIdOmdRnu2ynMcE1l592xH
 S1h+5yt5
 Ve87H1jQJvJ/HMGNQkBU4G8XBK3pTLzVDwAbF8JsnmM27w8cyRtfvc0SRJ2Mgn5XO2fgkb2TPMzrRLPApWnMHbnkRIcpoNCIW3paotq+ShQKpe1dz4P7pMSXOJ22AWdVi8LFyxEsYRF1mqOPb9renY8o087cUCkvbJAPdAaMOhaLz0b5QTM5q+VLHPS23J5GLqvqE5d7r7SmdHNYlA9zjn8IhyWAisWsDnobM7uOoYjtjyC4nCwpx2iXwAB8HsjchnMY1v5CANM10zG1+C7EnEAbeH9dnSN89ztanJFRvbB+hyZpH6+mzbbVUOolU9/t3dmGIGXhYk0M8xNOx+wD8/z3joYkjH+iDZnWZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[cannot apply to linus/master v6.18-rc4 next-20251106]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Remove-dummy-options-and-flags/20251106-010511
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20251105161935.545400234%40kernel.org
patch subject: [PATCH 3/5] tracing: Have tracer option be instance specific
config: i386-buildonly-randconfig-003-20251106 (https://download.01.org/0day-ci/archive/20251106/202511062223.ocoUvCBI-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251106/202511062223.ocoUvCBI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511062223.ocoUvCBI-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   kernel/trace/trace.c: In function 'run_tracer_selftest':
>> kernel/trace/trace.c:2174:30: error: 'type' redeclared as different kind of symbol
    2174 |         struct trace_tracer *type = tracers->trace;
         |                              ^~~~
   kernel/trace/trace.c:2171:47: note: previous definition of 'type' with type 'struct tracer *'
    2171 | static int run_tracer_selftest(struct tracer *type)
         |                                ~~~~~~~~~~~~~~~^~~~
>> kernel/trace/trace.c:2174:37: error: 'tracers' undeclared (first use in this function)
    2174 |         struct trace_tracer *type = tracers->trace;
         |                                     ^~~~~~~
   kernel/trace/trace.c:2174:37: note: each undeclared identifier is reported only once for each function it appears in
>> kernel/trace/trace.c:2180:18: error: invalid use of undefined type 'struct trace_tracer'
    2180 |         if (!type->selftest || tracing_selftest_disabled)
         |                  ^~
>> kernel/trace/trace.c:2189:38: error: passing argument 1 of 'save_selftest' from incompatible pointer type [-Wincompatible-pointer-types]
    2189 |                 return save_selftest(type);
         |                                      ^~~~
         |                                      |
         |                                      struct trace_tracer *
   kernel/trace/trace.c:2158:41: note: expected 'struct tracer *' but argument is of type 'struct trace_tracer *'
    2158 | static int save_selftest(struct tracer *type)
         |                          ~~~~~~~~~~~~~~~^~~~
   In file included from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:108,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from include/linux/ring_buffer.h:5,
                    from kernel/trace/trace.c:15:
   kernel/trace/trace.c:2193:29: error: invalid use of undefined type 'struct trace_tracer'
    2193 |                         type->name);
         |                             ^~
   include/linux/printk.h:484:33: note: in definition of macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:565:9: note: in expansion of macro 'printk'
     565 |         printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   kernel/trace/trace.c:2192:17: note: in expansion of macro 'pr_warn'
    2192 |                 pr_warn("Selftest for tracer %s skipped due to tracing disabled\n",
         |                 ^~~~~~~
>> kernel/trace/trace.c:2206:27: error: assignment to 'struct tracer *' from incompatible pointer type 'struct trace_tracer *' [-Wincompatible-pointer-types]
    2206 |         tr->current_trace = type;
         |                           ^
   kernel/trace/trace.c:2207:39: error: invalid use of undefined type 'struct trace_tracer'
    2207 |         tr->current_trace_flags = type->flags ? : type->default_flags;
         |                                       ^~
   kernel/trace/trace.c:2207:55: error: invalid use of undefined type 'struct trace_tracer'
    2207 |         tr->current_trace_flags = type->flags ? : type->default_flags;
         |                                                       ^~
   kernel/trace/trace.c:2210:17: error: invalid use of undefined type 'struct trace_tracer'
    2210 |         if (type->use_max_tr) {
         |                 ^~
   kernel/trace/trace.c:2220:44: error: invalid use of undefined type 'struct trace_tracer'
    2220 |         pr_info("Testing tracer %s: ", type->name);
         |                                            ^~
   include/linux/printk.h:484:33: note: in definition of macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:585:9: note: in expansion of macro 'printk'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   kernel/trace/trace.c:2220:9: note: in expansion of macro 'pr_info'
    2220 |         pr_info("Testing tracer %s: ", type->name);
         |         ^~~~~~~
   kernel/trace/trace.c:2221:19: error: invalid use of undefined type 'struct trace_tracer'
    2221 |         ret = type->selftest(type, tr);
         |                   ^~
   kernel/trace/trace.c:2235:17: error: invalid use of undefined type 'struct trace_tracer'
    2235 |         if (type->use_max_tr) {
         |                 ^~
>> kernel/trace/trace.c:2176:30: warning: unused variable 'flags' [-Wunused-variable]
    2176 |         struct tracer_flags *flags;
         |                              ^~~~~
   kernel/trace/trace.c: In function 'tracing_trace_options_show':
   kernel/trace/trace.c:5172:24: warning: variable 'trace' set but not used [-Wunused-but-set-variable]
    5172 |         struct tracer *trace;
         |                        ^~~~~


vim +/type +2174 kernel/trace/trace.c

  2170	
> 2171	static int run_tracer_selftest(struct tracer *type)
  2172	{
  2173		struct trace_array *tr = &global_trace;
> 2174		struct trace_tracer *type = tracers->trace;
  2175		struct tracer_flags *saved_flags = tr->current_trace_flags;
> 2176		struct tracer_flags *flags;
  2177		struct tracer *saved_tracer = tr->current_trace;
  2178		int ret;
  2179	
> 2180		if (!type->selftest || tracing_selftest_disabled)
  2181			return 0;
  2182	
  2183		/*
  2184		 * If a tracer registers early in boot up (before scheduling is
  2185		 * initialized and such), then do not run its selftests yet.
  2186		 * Instead, run it a little later in the boot process.
  2187		 */
  2188		if (!selftests_can_run)
> 2189			return save_selftest(type);
  2190	
  2191		if (!tracing_is_on()) {
> 2192			pr_warn("Selftest for tracer %s skipped due to tracing disabled\n",
  2193				type->name);
  2194			return 0;
  2195		}
  2196	
  2197		/*
  2198		 * Run a selftest on this tracer.
  2199		 * Here we reset the trace buffer, and set the current
  2200		 * tracer to be this tracer. The tracer can then run some
  2201		 * internal tracing to verify that everything is in order.
  2202		 * If we fail, we do not register this tracer.
  2203		 */
  2204		tracing_reset_online_cpus(&tr->array_buffer);
  2205	
> 2206		tr->current_trace = type;
  2207		tr->current_trace_flags = type->flags ? : type->default_flags;
  2208	
  2209	#ifdef CONFIG_TRACER_MAX_TRACE
  2210		if (type->use_max_tr) {
  2211			/* If we expanded the buffers, make sure the max is expanded too */
  2212			if (tr->ring_buffer_expanded)
  2213				ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
  2214						   RING_BUFFER_ALL_CPUS);
  2215			tr->allocated_snapshot = true;
  2216		}
  2217	#endif
  2218	
  2219		/* the test is responsible for initializing and enabling */
> 2220		pr_info("Testing tracer %s: ", type->name);
  2221		ret = type->selftest(type, tr);
  2222		/* the test is responsible for resetting too */
  2223		tr->current_trace = saved_tracer;
  2224		tr->current_trace_flags = saved_flags;
  2225		if (ret) {
  2226			printk(KERN_CONT "FAILED!\n");
  2227			/* Add the warning after printing 'FAILED' */
  2228			WARN_ON(1);
  2229			return -1;
  2230		}
  2231		/* Only reset on passing, to avoid touching corrupted buffers */
  2232		tracing_reset_online_cpus(&tr->array_buffer);
  2233	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

