Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC347CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7078E000B; Wed, 24 Sep 2025 05:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157858E0001; Wed, 24 Sep 2025 05:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01FBF8E000B; Wed, 24 Sep 2025 05:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E002A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:50:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A1F41DF0C2
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:50:21 +0000 (UTC)
X-FDA: 83923673442.28.A4268AC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A3EFA0022
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:50:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiI92JAA;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKWiW39klBuMqSIpTYR1bMJcvvgUJIRkPs2jr53cWOE=;
	b=YHdmNOz7l08T/Om2Oqo3SHwAJyJUVcq1B4Jqd34qjVNypBfrZsYVKpriLsYnanM8eMM2cC
	pbZZuXA2qZAk4oUF+r/JiaKXhHs1U/0+hgaf6IcUWRmKAji9kmB0MGrU0W9bZrGAdM0GSW
	lPAEf6Qy2VsDnuFeHGm6CdYW2Nnsoz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707419; a=rsa-sha256;
	cv=none;
	b=Uejr+4dibVChIXGN1eM3Q102zTbVgZrYwWUf0jUeDuCdNkvISlStYeYdqbCRCV9eCUXs1W
	T8Yceu4dvSU+HAg90Et9iiKAF97h/STOm+foBrdB4sa3MXI3IJXQ6JuCyRbpsHXbeN7ET8
	hC5uQVZR2KefyBjlC1G0WyRRQsSGBFs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiI92JAA;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758707419; x=1790243419;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fkLjEPUde/BCOSe6yVlFN8pwS/oHwwImtIyGcjmkrfY=;
  b=NiI92JAAwW8p+O8Ey9YCnf0cjBGvMHHpVwri66l5mt4nli4hEVwP6blM
   4RwIyAt7PBrrioi1pfE3BQB0bn+8XuKrnuB9duCrLQRCu20KIWr7+2O+b
   cBjr7ba4mzo0rS9qD6lDTsMMmki0yJNIgFmzne53q+gdZGK6Y9T2W3BVM
   s9/k4CP4T4MWmJgxKvS+xS+itT4TjgNsMHS/15wkkJjkzaQlQ+dEbKdq0
   jzigQ7sjYOIxSutG1PmIkQ16yXOCcPAu5jIgaRsnW8axV1Yo6xeYk9aTJ
   8XEf716ZSIY+K++ESl51kwBA606u2iBBricDJVTdX8d61e6IJhEkRzOYq
   w==;
X-CSE-ConnectionGUID: 0wQeMaF1QHq3gZuF9wEcfw==
X-CSE-MsgGUID: mgPSuLuZQwyjR0m4mnx3zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="64838719"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="64838719"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 02:50:17 -0700
X-CSE-ConnectionGUID: FUSXk/+JSgmzq06LQGCeZw==
X-CSE-MsgGUID: ph54oh55TcehMfikD49uFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="177769371"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 24 Sep 2025 02:50:13 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1M8R-000413-1s;
	Wed, 24 Sep 2025 09:50:08 +0000
Date: Wed, 24 Sep 2025 17:49:46 +0800
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
	Ian Rogers <irogers@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 7/8] tracing: Add syscall_user_buf_size to limit
 amount written
Message-ID: <202509241709.5vLMGNLe-lkp@intel.com>
References: <20250923130714.603760198@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923130714.603760198@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A3EFA0022
X-Stat-Signature: gr73tmpsrxtangrtdeijz67364pjixzp
X-Rspam-User: 
X-HE-Tag: 1758707418-201084
X-HE-Meta: U2FsdGVkX19HqELQN0ZdSPXc2JcFdpFKqwrxwqnusznZtNaUzgMHllkAAa86Ka6136gQowaMAQRRoxLFC93pKPKaQqDNLu8YZIzpaIhcmLRcze4Nx46dWUzIfLrnwqsvhMHfHCtncwcm+StPtNzUBLmH3EXRIqkHf+R+/0pkV4QYvE/0FjVDRJkSGBBJG3niB9v4V1rvOVTHECcfO8QhtenOGfR++fmInrlu2P0CWfMUF4uRYaJqOCNorYhcrkKUjAO/OvuTw5v1C2Y1I28B4jg2EKA9T7tHAYQGjMgn06wzySJfBmtQereJraQ+RgLoT/En8dtptkl/Vx1FgHwTr64ox+Eb8wYdIrcM/iGxRWOLZAnmgt/CCBGvX8r1bpdrPpOGGz3TWtA7xyu/1iiJNCNjT7mBgKLJ+PMKCuWRiIuqo7KQjqi4RdHe8/JBvzhAn719Pjo0VQQWaFeY5o9HKGUg1wtNIerhE1vSucVl+498znRceueMcHMkSuk+1fzg3f1iUfsCX51imYuy9jVJ5d1U/F+7Fhj5Dw2UNl98mFzJLxLz7Ulzh/1NdFRe5RDO87uq1+aRbZXFco3SXsaJbIGNkTCFA91lpVC/+m3VmB8HZUsyqxjgmTZ5QQK5V/dpd5g4+xJhV0cdEjTCRQiVfR9Pg0/X2K8rsuqEhj78NETHJbtd0Ts54aWb/jXQbyF8F64UDEn5I4VC1MHEAznuaXK9aawlN28YRjvQvYTT6/PieRWMRTWO23jH40myKBMClMqVWND+o/9v4Ag9R8w6tS7Nw4aU3xUSTxOF/cbIU2w2uQ3fT56RcNDZy2OqguBQNvYJwusqELQAKtP3gQ71Zh1gElb5Twhqxg6U5EvjvefO/Ot8PpWQM0bzqeRuxl4xl0eVKZBkN43PQ0gonTSDBgfLAwTR41XnHFSxhN7maWpI9wHgiBY6Zh9k0Mhivzc2FAGKgWuA/xMDpj1mw81
 HFWBF1An
 5KA8wG2p9s3nxneb7X61f22XlRQwjHRpFHbYav+ikJhvqjN2aAE099ZnhQsL+H+3Lm5pN2dv2Yxaazz/9vsHpyxhwsiGb1ovmgM+VlfHaLULzjtgS+eQO90GW6EQrzsJ8yZVFy3sHaj/DdsU3adUwYDt7U+T5hQBf5ZaUPz7E0KDQYL6YNJnEBh3eQ9s+qrAqonvAuMvCHgprqNVnelcMpMuMFvycwn5sMNUqon6ggZjVpiUPBRIljHtM6ZGt9EmTkk4+EowNW9a7NC4dmi7JiO/x5H/KrI5hOQBAG3/A4dBI/oHYaOTBajf58Xas6pLwi/2ahwuOAbOvlGalMccE5IN0v/v6lA9V1yfgRm0Rvqrixzzugh1Uycs34HS2mXfeq1EGFSYz2AZ5dQBOgLgmW1gRrQ==
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
[also build test ERROR on linus/master v6.17-rc7 next-20250923]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Replace-syscall-RCU-pointer-assignment-with-READ-WRITE_ONCE/20250923-210948
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250923130714.603760198%40kernel.org
patch subject: [PATCH v2 7/8] tracing: Add syscall_user_buf_size to limit amount written
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250924/202509241709.5vLMGNLe-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250924/202509241709.5vLMGNLe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509241709.5vLMGNLe-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/trace/trace.c:11128:32: error: use of undeclared identifier 'CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT'
    11128 |         global_trace.syscall_buf_sz = CONFIG_TRACE_SYSCALL_BUF_SIZE_DEFAULT;
          |                                       ^
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

