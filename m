Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E69ECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F9C8E001D; Thu, 16 Oct 2025 07:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D176F8E0003; Thu, 16 Oct 2025 07:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CE08E001D; Thu, 16 Oct 2025 07:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B129D8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:37:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D9EB854D6
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:37:29 +0000 (UTC)
X-FDA: 84003777018.14.429A5CD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C19F4000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:37:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="It/MJjus";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760614647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ipC5hm4Z8VJ/wDoI8rLSFwfuP6JyeJQ4m9Wqc3INeU=;
	b=jkQ3akirVz5qiVJ6F9xpDUYB0WA2zTL3SgQsPr6mXwkGDABkss6u1erUS9SVeSLLU+kDc0
	iL8QBMEi1Jmkoh5lehswJ/cRoJO+NnVutCaslJX+h4ZRQd1c/Nnmyz7woW+jaUYaXwf8K8
	5L6jMfnBxPmfZ5P6wh7OKPXKcFzk5Tk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="It/MJjus";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760614647; a=rsa-sha256;
	cv=none;
	b=ZqWAW8NoB5+66Gp4VJlgT7f35K1ya7MJp9LdQHndP8d79ViAvO0NFWyHE4pQrGhH35ae1c
	70cVQqDhcsIjVP2bZcAEWsjoOoZM/SC6ThsZjJYjimsAveQBEWp6y+LdfLM9fw2NYDx5b/
	Skho9R/dl8pKJNnDP4pgpm0TKRWO7QQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760614647; x=1792150647;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v/p5WbwRu7MI/kgIQR21ZD5+uRNrgnKQRlHjro5dlgg=;
  b=It/MJjusYN4foLI8Bx+xg6sGaG2AYSpcngpNhDBzE1usO2Sf3tqeZ0Gu
   1oHh7MjoXo2Lv3x0MLBIpzOKPoi33FiIqYM4GmXIMnEJ/xMY4M3jGE/N8
   7EIaNl1AoEarjy9qfGGjYBofjLO9fyZGPxzR2uha9XS/iVHnUUbUtYRLv
   Ozy9Kl0ZpevUdve72ixPpWS4ecscWDks1UDYTuqwf8mBbdkcn8p1wsGA7
   zYPalSfEHBvBZTbCFvBlbmf0bgreD/jF947BsSBm0rYPoU3Y3IvElAZXk
   o/mH2rZAk/QH0jJnhFaT1gXsTfBzjNzGTjAeLefv7zmnq+BPSBMcGWCzY
   A==;
X-CSE-ConnectionGUID: LrwG4i81Q5uapbeod84DLQ==
X-CSE-MsgGUID: fuSN0XA1R+Cjfm9aMMpucw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="73915743"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="73915743"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 04:37:26 -0700
X-CSE-ConnectionGUID: nDMvKVvDQC+P6DB3xtuWrw==
X-CSE-MsgGUID: WiXBWk7XTBaRTcb235v5bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182228181"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 16 Oct 2025 04:37:20 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9MIH-0004kr-35;
	Thu, 16 Oct 2025 11:37:17 +0000
Date: Thu, 16 Oct 2025 19:36:33 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>, Tom Zanussi <zanussi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 13/13] tracing: Have persistent ring buffer print
 syscalls normally
Message-ID: <202510161956.5wnA6TUc-lkp@intel.com>
References: <20251015173550.225723717@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015173550.225723717@kernel.org>
X-Stat-Signature: 64m6o4t3oeg7cjoycgbbrs3o5q5youf3
X-Rspamd-Queue-Id: 9C19F4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760614646-8988
X-HE-Meta: U2FsdGVkX19I3vdP1i/qG5s7sAS+pPpuoAKU/6YkKlQTV4skE+nxM+rIkbmkt+pbdxEQfnY/zgnwojKDHaku/sX0IefgwwBkUP4eO2qkqfrQ+dTIsNqf0VGDSF8QnSIvGrX2rmVadhDP+9L+sDWFptWgI4fSYmEIouosSCQlKU6htVYFEygo559m703SafRrtCKS3UN+EDhSd52fhGHeYmcGKoM/ffJiGpeEFsfB36ROnulrB0EIAF2TwjZuqqOu4A3YWHx71MyLekEbYqCJxvEL99Zao09un0+wxtuUza9ystLPStuqf6Gm3HTdmrPirxLqZKOtEZUqlhuUbw7No071hpJSS5JkIZJvHmbs/OIgHx1TutJ2F9hwu/j2xvNU/wd/ovEYy8SqOjvjK5mVy1Lf0ylnIybj18In3Jt/vphniBhCXAOYrY3wiuLgYo3a5Yh6rZBP5aywR3rCgZQhpnwSz89jbiVvgoLThN6HGqHacmFLJgAUim3LsK8sM7OVtkbjYFUuirvRSwao2zLa0zqwSMJxSw/rPET/wM1rdH1rmWkcXx8QfToPyqrBqgLzax3GqyoVLyARJXcrdqI645pPLl2Op9fFWwIIgUHpmDRmXW2CEh9SWU5N7TQiz4iBeJbymKHoMMIGdankJWv8GI0ICgMuqjuJtg5bR9n9EABwdK/cg30pNCMRTVYQePqDcTCReahClx9/aw6jkdU8ReFNodTcVSNssXieb6D3NIuVtukr1pEPQGHD+59jaLKAAKC+ntGATsC562PEtipSvkBlS2fsJAKO5/vjhPktAAZZPLVzUKW47Nc90dwM0rt4gy49qsDbcnIROZN5p0BQmP2mn7ozXgadBYTfIrxPEZ433WV5hsq0Ltg+2FaX/+teYwZKiqNhoUmqeDfcM11KySeulivKB2rgdIueyDc6vs6GY/8O9coyc8QeGbmicrhqqT5B8/uwCAaYyOB5eDa
 WW9xqEgE
 ZVZLE5iPb1SkWCzn3xIfIY3dEzlqtT6V4SHsGJ+PlBUkXG4bc87HtYNIdRcHtnf6B/XG+IFZ5BCrsjBpL0OkOvTF0ZYOhdpw8Hv80qfanBpJGtwy+T2lKJGoVt/pgdOD9l5aZ67IS1pSLGglmI9VlYy8QAEBq6QfnSm17K0bqHLaEy7dkF/mPtEPfMit3odYc7KTBRP9VI0TrFimuD5mSi8oNchovZnuigH5pcau+6Ck3AxGkSmeczqmligeUEbBDTlFKBZ3Kd2u/602tRMphjBV+Of4cG/G8gLFPZfUbKgLCMYRF+GSW1Yn5BUV9/J6EiBIb0pNrS8toIGJEn8CFCMuKUCBV1BzAAu8K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.18-rc1 next-20251015]
[cannot apply to trace/for-next acme/perf/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Make-trace_user_fault_read-exposed-to-rest-of-tracing/20251016-014059
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251015173550.225723717%40kernel.org
patch subject: [PATCH v3 13/13] tracing: Have persistent ring buffer print syscalls normally
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20251016/202510161956.5wnA6TUc-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161956.5wnA6TUc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161956.5wnA6TUc-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/trace/trace.c: In function 'print_trace_fmt':
>> kernel/trace/trace.c:4258:47: error: 'enter_syscall_print_funcs' undeclared (first use in this function)
    4258 |                             (event->funcs != &enter_syscall_print_funcs) &&
         |                                               ^~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace.c:4258:47: note: each undeclared identifier is reported only once for each function it appears in
>> kernel/trace/trace.c:4259:47: error: 'exit_syscall_print_funcs' undeclared (first use in this function)
    4259 |                             (event->funcs != &exit_syscall_print_funcs))
         |                                               ^~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace.c: In function 'tracer_alloc_buffers':
   kernel/trace/trace.c:11443:39: error: 'CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT' undeclared (first use in this function)
   11443 |         global_trace.syscall_buf_sz = CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT;
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/enter_syscall_print_funcs +4258 kernel/trace/trace.c

  4222	
  4223	static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
  4224	{
  4225		struct trace_array *tr = iter->tr;
  4226		struct trace_seq *s = &iter->seq;
  4227		unsigned long sym_flags = (tr->trace_flags & TRACE_ITER_SYM_MASK);
  4228		struct trace_entry *entry;
  4229		struct trace_event *event;
  4230	
  4231		entry = iter->ent;
  4232	
  4233		test_cpu_buff_start(iter);
  4234	
  4235		event = ftrace_find_event(entry->type);
  4236	
  4237		if (tr->trace_flags & TRACE_ITER_CONTEXT_INFO) {
  4238			if (iter->iter_flags & TRACE_FILE_LAT_FMT)
  4239				trace_print_lat_context(iter);
  4240			else
  4241				trace_print_context(iter);
  4242		}
  4243	
  4244		if (trace_seq_has_overflowed(s))
  4245			return TRACE_TYPE_PARTIAL_LINE;
  4246	
  4247		if (event) {
  4248			if (tr->trace_flags & TRACE_ITER_FIELDS)
  4249				return print_event_fields(iter, event);
  4250			/*
  4251			 * For TRACE_EVENT() events, the print_fmt is not
  4252			 * safe to use if the array has delta offsets
  4253			 * Force printing via the fields.
  4254			 */
  4255			if ((tr->text_delta)) {
  4256				/* ftrace and system call events are still OK */
  4257				if ((event->type > __TRACE_LAST_TYPE) &&
> 4258				    (event->funcs != &enter_syscall_print_funcs) &&
> 4259				    (event->funcs != &exit_syscall_print_funcs))
  4260				return print_event_fields(iter, event);
  4261			}
  4262			return event->funcs->trace(iter, sym_flags, event);
  4263		}
  4264	
  4265		trace_seq_printf(s, "Unknown type %d\n", entry->type);
  4266	
  4267		return trace_handle_return(s);
  4268	}
  4269	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

