Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6905C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621F78E0005; Wed,  6 Aug 2025 10:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ABBA8E0003; Wed,  6 Aug 2025 10:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4737C8E0005; Wed,  6 Aug 2025 10:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 357648E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:51:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8F11819D5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:51:08 +0000 (UTC)
X-FDA: 83746620216.25.9DD12A6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5DC8740005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:51:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GyQbGQSh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754491866; a=rsa-sha256;
	cv=none;
	b=JPW08/hycr+8g4iyKljLOCxDbPRsHDEV/xDZ8H+MJiMdgJfZAsSsqdf3pYkVtTgUOXMbkE
	6lGqfaKrSNvW4VMW+V029FiKQK7dZ6AX/XrzNmKXUX2YQwowcno0iqjEs3kbDr+GDiZLvl
	uIzpSki6L+0aDk+Rb5Qtb56ZDBbZZWw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GyQbGQSh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754491866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCgDgJvA/YpJxdcLudWADFk4ALMp3oDElwmaAYQQxas=;
	b=nX8P38sSKAtij1DWIY3RN3LUAdYT0RmC9quYlyZzjjLn3vlu8o51ENhrWyKKXv6DffIMD7
	4ruN/DvZaPh2R9ePG2yqynZ/xXNqv5QIh1aWc17DZ+V5UKbLzhoQjDArH3wlKbiHIpLh2s
	qilknBmyxg/cTAEINDfe1iD0zM6YfgQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754491867; x=1786027867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jYOf2US5bWDo7NlujX8N73KHv16qVgm8SXDzuRBuNuI=;
  b=GyQbGQShfKIoaE1ejIjG34pASJ48cgh0j5RIxCksZgawWbVDiK7X2IBD
   sKLO+NxxqQv8zD15nO1MpPZrkT/IhhHMOxeYiDGNc8dR7/3AbIifprE8P
   qPb7nZVmS1+PIDd34GeVROQuI5AvxJPJ06I6S3isXVsaic/QXSwEZ+ZOj
   wi9EVZBHreYI6T1aZI272Ap/z11bvILIgxh7sLDJQzmXohwAS/ErnB1BZ
   RgWs6i8acHRfQ//hqW3FucPnWiYh0frrlkvc7rQU7RfzsxWe+T2ytmff9
   a8yiAnEarJ5UEt+G10/jXq8GolLeTrkkjpaOszOCmTMoX70B0CCLS0hZS
   w==;
X-CSE-ConnectionGUID: AwKpJ+mqSxq3pxCNI6ewrA==
X-CSE-MsgGUID: kRcH8usUSXGX1Q01DW48LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67078665"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="67078665"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 07:51:05 -0700
X-CSE-ConnectionGUID: XH6+x08qTfGWxhF0zUB9XA==
X-CSE-MsgGUID: acmb15dRTzSsSmXqlb9RyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="165567416"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 06 Aug 2025 07:51:01 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujfTn-0001n8-00;
	Wed, 06 Aug 2025 14:50:59 +0000
Date: Wed, 6 Aug 2025 22:50:14 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	Ian Rogers <irogers@google.com>, aahringo@redhat.com,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: Re: [PATCH 7/7] tracing: Add syscall_user_buf_size to limit amount
 written
Message-ID: <202508062211.cwYqtLu0-lkp@intel.com>
References: <20250805193235.747004484@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805193235.747004484@kernel.org>
X-Rspamd-Queue-Id: 5DC8740005
X-Stat-Signature: hzdgex4iqeydh3jchpixcto8fradd1u6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754491866-148163
X-HE-Meta: U2FsdGVkX1/V2tZ2PNfaWeksj2tcMfd1Mh1RBbW3oPiVZYvoKf9yboA/ES331OwQtLbILcytEgrbuorsu3aR7f8K5iFixGMNoe6ARjpY69qrVVJszeHht+HMspigOQDVbeaCmt5N3rgo49vL0iZDHdPRaNQRP0IgW7iCdqU0DsXbLFf3Gv2iWv1dgVQns18dRH02t9XckZ9nty2d1qfEdNckd3BOHdlp4VTY3Ysx8d+1wOouxE0nt0HoboBMG6dQE3stgm312T/TdZklspMSgiF7jNFMyUE+9AQExgQeJzbi0lprN6od1NB8cNLBAa1FdAVq6HjtPAdo04p3dLvrpek/XV9UbJKtOrAr8wZrXKCfCFqnXV8ivzHS9yCJEDnZEGQRI3JaUyiYO/unKT2S5eu4C3LEbvhWlRgXmicw/wOarxnIQxXvY9OzoFio00gGYo2l6T/BPMSVZEFzku8cQ//xqPbsV4hvAnOJV9rBe+jaPKmg2ZJWuJy+HvlWPL5zWqe9jsULVt518ZH2MsvTT+WjCXNNgzG4hF/o6/cG+JWCT6xxjwQQrlDDFlLXJ5u1P50lplySmrWgaFprxSer+Dg0Osyux3vRee315yIVqjcFIxiTA+mx2oEs2qbnTIYu8Y7dNEf6CjhgnliR0/k9suZtIDULyVBga1BfvqxFkNTsHYX9cocF12iSeerov2ycazzvaXhlu86sTtSPCpx2VM346hk1VFDoWekXYAeqzrDvSeOG4ubKIXQnCT8kMcq0cGX9JRVzAKd/f4RUW/tRVmDCGmMqgPKj6yc3G3/2imaiwHVePZCN80rirKR5375NqS+FJh3YwNjO1llqZRp5ZAjOqbsAwo/z5Xno0BHePjJ5MueCi17f7U14egdV/UmGg/M73OU4gk31kpTOaiAJxgoCkLGnujLQ/76TnpIdRNrKps5F28i2N6zMUB8zOqBTRggzEp4Yd4eNSn3FhHG
 WGFST6qo
 v0bnSQXmbOXvhD/FTOfNhihlKtJ//+KiJNQbL9HP8XzhZJMWCicWffxAcC1y4VRkCr2ktCwWe5nvFaJtsOysxkYKA5npGKgxSezLirlgp5oDkVkgggC/GQiymHd4jSR3sax4U7FIKf4cJ7HOROMGvePEGArw0CuogBg9f6u3/kcATIFhkpx3Gjjt7oU1Co9tYEqnxNi8PoR7+NHX3IU0RqINJlLwJd8Exc19eYe8EHQt/JKrAudrvU6xA1LZ99waF2XE0bGOPJx8h7K354gDYOIu71roR5Xu7Nm6F82z2uOpA9/bLQjvj448Nk0H934S5n5ihxneexm4bQ/BffqogwR0lRNd1hpMLN7RTfUROPdDn9PayR8eKhKZCP42sMa9H3p6onwo8UdH42FA=
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
[also build test ERROR on linus/master v6.16 next-20250806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Replace-syscall-RCU-pointer-assignment-with-READ-WRITE_ONCE/20250806-122312
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250805193235.747004484%40kernel.org
patch subject: [PATCH 7/7] tracing: Add syscall_user_buf_size to limit amount written
config: hexagon-randconfig-002-20250806 (https://download.01.org/0day-ci/archive/20250806/202508062211.cwYqtLu0-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 7b8dea265e72c3037b6b1e54d5ab51b7e14f328b)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250806/202508062211.cwYqtLu0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508062211.cwYqtLu0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/trace/trace.c:11128:32: error: use of undeclared identifier 'CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT'
    11128 |         global_trace.syscall_buf_sz = CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT;
          |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +/CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT +11128 kernel/trace/trace.c

 11110	
 11111		init_trace_flags_index(&global_trace);
 11112	
 11113		register_tracer(&nop_trace);
 11114	
 11115		/* Function tracing may start here (via kernel command line) */
 11116		init_function_trace();
 11117	
 11118		/* All seems OK, enable tracing */
 11119		tracing_disabled = 0;
 11120	
 11121		atomic_notifier_chain_register(&panic_notifier_list,
 11122					       &trace_panic_notifier);
 11123	
 11124		register_die_notifier(&trace_die_notifier);
 11125	
 11126		global_trace.flags = TRACE_ARRAY_FL_GLOBAL;
 11127	
 11128		global_trace.syscall_buf_sz = CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT;
 11129	
 11130		INIT_LIST_HEAD(&global_trace.systems);
 11131		INIT_LIST_HEAD(&global_trace.events);
 11132		INIT_LIST_HEAD(&global_trace.hist_vars);
 11133		INIT_LIST_HEAD(&global_trace.err_log);
 11134		list_add(&global_trace.marker_list, &marker_copies);
 11135		list_add(&global_trace.list, &ftrace_trace_arrays);
 11136	
 11137		apply_trace_boot_options();
 11138	
 11139		register_snapshot_cmd();
 11140	
 11141		return 0;
 11142	
 11143	out_free_pipe_cpumask:
 11144		free_cpumask_var(global_trace.pipe_cpumask);
 11145	out_free_savedcmd:
 11146		trace_free_saved_cmdlines_buffer();
 11147	out_free_temp_buffer:
 11148		ring_buffer_free(temp_buffer);
 11149	out_rm_hp_state:
 11150		cpuhp_remove_multi_state(CPUHP_TRACE_RB_PREPARE);
 11151	out_free_cpumask:
 11152		free_cpumask_var(global_trace.tracing_cpumask);
 11153	out_free_buffer_mask:
 11154		free_cpumask_var(tracing_buffer_mask);
 11155		return ret;
 11156	}
 11157	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

