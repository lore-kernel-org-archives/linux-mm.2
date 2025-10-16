Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A94CCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB7C8E000B; Thu, 16 Oct 2025 06:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B348E0003; Thu, 16 Oct 2025 06:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A697F8E000B; Thu, 16 Oct 2025 06:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1DB8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:34:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D9041401FF
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:34:55 +0000 (UTC)
X-FDA: 84003619350.15.6B15694
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 47D8910000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:34:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vy5TVNsv;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760610893; a=rsa-sha256;
	cv=none;
	b=nVeSuftADJuP1vP2GDcpkO+ZkAhxst6NRtPZNtrzfL2EnzeR93es0aZHdNbb4n7tTA3os3
	VuZTp3iH5mTG8fMkCPHkNSCSDsjkgGXiDiMFmRGfWdzRca8wjzOrAfodKnPYQIv6GAr+o2
	6vbwab/ThprcHGHzoRCjM5OoydZZjLU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vy5TVNsv;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760610893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb3aSlgVfgrN90R89QkXPn9jNMxJ8WgHu1blEz8RSiY=;
	b=IbDO9ElsSk4uNHDRU9CDL7GdBNTIx0D6nCdd5w8tqOx5Z3d773ux4/B7XmAbKSixeVq3QG
	uttGRvjqBTfnxTMyjDaGdjqa6G+l9OG4Ko6nJc0zz5mnz4blY9o4/DDmDSU3cvHOc5DWiy
	G4P0tyWTidHu5CSyE45+nvM5jZJBWpM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760610892; x=1792146892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VZDy0vrN8u7n/1W5AyMEFHFQCIwaQ3bG9u+5tTcVhok=;
  b=Vy5TVNsvsTE7DfZGhCNEySI3IgpPqBd/RebV7sf3/3JAmGvie6f0Kd4k
   m31syKWOdP3TkolW3kq5gcJiJhZZBXYdOi5UfzhGsaHMQ6S6NdDMTOiyH
   yxutyTMiU1DEUL9bMnSO6eQJ5M7ZG1NnPmE2A7Bu5DuLs+rbtayEfDNdd
   /UcqB1PjYjWb11VO7Ly0kW7TfXtO8SMATxOu2C2m4aVykiXnLzddzB+MK
   o3nHlYhRIv6OuTrllnmWrfrRiubqqZ3j4wrjrpdI/WTfDgnAh5NoEXM/1
   9or5N8JQaoRcCZ8PgQUdSEXOWFPN1Tbqu7ZryYRPOAtoOpclnrfNzCb6f
   Q==;
X-CSE-ConnectionGUID: go1juw8dSD22kVXCBWYyug==
X-CSE-MsgGUID: JKD9pYS2Q4S/2p4SmCdZ2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="66662343"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="66662343"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 03:34:51 -0700
X-CSE-ConnectionGUID: IkronhQIRV+O9w2fLMS2OA==
X-CSE-MsgGUID: WGp9F29oRwqrVtgcUTtTxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="187514273"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 16 Oct 2025 03:34:45 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9LJR-0004hr-1H;
	Thu, 16 Oct 2025 10:34:30 +0000
Date: Thu, 16 Oct 2025 18:33:19 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
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
Message-ID: <202510161708.yF2I7Qqq-lkp@intel.com>
References: <20251015173550.225723717@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015173550.225723717@kernel.org>
X-Rspam-User: 
X-Stat-Signature: qgk4hdqz6fa67ajzbn14j5nysdwt7ix9
X-Rspamd-Queue-Id: 47D8910000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760610892-28509
X-HE-Meta: U2FsdGVkX1/trRy6UpqmN5SP2mWuTKaz0uGLhMaugQmmCXBuSraQx95igqLqQrpCOaoXv+/X86VI8AV7fwChXqx5YTTjy+KBHeXy47UuqhyOSUHLMFEi4fJIozx7OYGEqNjMh8MeCw+mG3I3QTV+2ADFQ8+5zDPXTnBzffBD4mz+sI03fGCEhN804tjpruL35YsWI6FYOrBCXJK84u29pyzZWcE8Px6vNPhgAjzNjjnRIRAMJfoERZdkauZf055oFCukT57GfnjwRiZdQFLEn8VIJEWzqGi9hcD/AYYhfUGpZ/yDSCdrqbrYPRVzw+auzfBg+dWV8ATGcuoUgZgX09OD7DrXmCnkKMoUoNAtrVx33BLejDHt0UwEogr/S/IZz4Ja96PvyF0kKirkO7sDl6IbdFdP3gUFSiDR1E9JeooSo2/3Qbh+TSHbIqGqcPKqCLTguYxlQ22YaPbUxt+CaGp2wfeY+Ti6A7Ddj1exC2IRdmpCPI6i0mxsHj0JOSHDdEl5cUbSZ5e3k3qa3KDcv1nwtTEIVK3Wg8CIHJUBJNNxqBrqR+8ReHgXKSS3NmW3eGrA/ZHhsHZRxViCfbFelN9tKVejEAQvIFhD5fQozQ9pvPa2XLJfbx0T256WksqUiakUQDQ8uKl6tUBgo87tQy7TFzOWTBMnWilQefmk2wCoZiw1N/vbeHcITgmpVnSAKIs1BLEdwe8HyA0cqR1UbKsO1DVW47iWByaN3w5aqvF5c+MA8aHQh1lAp7/cGx9HHQxm3dvCycDWkiouqS19QUMqMhONinMUYn9f5u2ZHKUOQZyaqBEhSJ67AGOuyHtXVclrVpzF68ZsKGT30xoka7txk5OwHf3W0Ez01172UbNehqDZINrISzCRFwrzDjJCJUQ8PB2ANWgOX1uBQTBFIpxtW2gw8aFBoQk4ue1B7nEQog2H+CWekQOPXiqdIYFVc9lxohzMYxgwKPjevsa
 QHlS65BX
 Wctf69mpHMZ+FghbDwKk8WOV4ybysPAHugV39+zW/7cPfVV1fcpggAEFvllBxqs2ktTEd/mRMDICgzqnJYp3KWhZMiJje3R2cpVCQ79QqqUmuq9OLWqGGemN1bIOOAAPBwr8VixDYnHbQxegk6IlFIPbRvSo13qjM5J+K+qhN/fc26D/Zj3S6pXrRrnNkHTeLR9HlcqhWMnN8B0VgMbW9Mw5FZpYFuk9WivFAnj1lgoEveZJ+HWZypQzDk+LCxp5r3C82b7PG5iuBgsVQaSm3q1mDa9eD+LXCLqx3qGc9FcckCYrFcxfhBcRwffzbNJFT9PbiURnAzCVOHisspZYOnjHtTpuQpSIBBPKq
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
config: s390-randconfig-001-20251016 (https://download.01.org/0day-ci/archive/20251016/202510161708.yF2I7Qqq-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161708.yF2I7Qqq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161708.yF2I7Qqq-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/trace/trace.c:4258:26: error: use of undeclared identifier 'enter_syscall_print_funcs'
    4258 |                             (event->funcs != &enter_syscall_print_funcs) &&
         |                                               ^
>> kernel/trace/trace.c:4259:26: error: use of undeclared identifier 'exit_syscall_print_funcs'
    4259 |                             (event->funcs != &exit_syscall_print_funcs))
         |                                               ^
   kernel/trace/trace.c:11443:32: error: use of undeclared identifier 'CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT'
    11443 |         global_trace.syscall_buf_sz = CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT;
          |                                       ^
   3 errors generated.


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

