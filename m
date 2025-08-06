Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3782EC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD8E8E0005; Wed,  6 Aug 2025 18:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F548E0002; Wed,  6 Aug 2025 18:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26DF8E0005; Wed,  6 Aug 2025 18:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A46AF8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:06:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49A791406BC
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:06:47 +0000 (UTC)
X-FDA: 83747718054.08.A952A08
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1E49920009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:06:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hbRbhwyy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754518005; a=rsa-sha256;
	cv=none;
	b=oXGSaEBxGraQPNK/+wTO7zvdphZgGU4kpyicNlP5ab8PXD974opPPd82dXisiWhzPwmJKv
	bJFhU5KA4/NPT3ysYA/LChHvNEwonNNKfTZhLL5Eei/hi2Hmv2G1j4meNuCwv6LmD+dZ2o
	b5nne8Vfm2LEaHkPWjRqNYTUF/XP6nY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hbRbhwyy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754518005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qciXj69OL2b0eqOFM56p8ePh/y0f41hxN0dwQCus4hg=;
	b=yleRQVIW4MkMKdeJFw//ytnPOGPgPU4QitrQtWvVj7dpqQanzWQ0Pz9+wbq8EOk0YIxLd5
	gun6kHOrFUVT+b63Klv9/0s/kODFcEiw5a+RHXz0Fa8SRrmxrP+38am/Ao7oTkWmrQ3aJE
	BIEWfFuSroMA+QVhTUgEri1EIwkrCfk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754518005; x=1786054005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2rUd3i6DivO+05DXaSp+LgSEmwownIpwutoceQhLjrQ=;
  b=hbRbhwyyfA6hzMHLeSC0lZtRUM5Hp/FHpfKVEj4hpYQKnSFUr0UpnRqz
   efMQfDqJRNQ4bPkMeMJaQjzi8jcc6R2mOuwPAIY14eWsjKxHdg2GdsFpx
   Lkw8fHCMeFAv0u3mD2FUWouBbi7A2Cf4zkskLWmboNdZUGYLdeiQQMe3R
   idceLWEbnPEhfGumsnpZr3ckstZVUs8wrSgw6e0WT1MvkSlX7MZTM/rZH
   qweAeTrc+WOlxSjF3XxyX+sM/sqSwthN0UwMKB+19nMvD/bcEAgrnMogU
   U9KsJ/fpmTqROWQ8d4M7BFdmDmbIGX6EZK85JcOIWbDYm/8nPvj6y95UP
   w==;
X-CSE-ConnectionGUID: uZFegJxjRXOagjoM4O7MwQ==
X-CSE-MsgGUID: StBDUBHLT+6uuE7xo1MQRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56764621"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56764621"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 15:06:43 -0700
X-CSE-ConnectionGUID: qYezRnfIQiaHI8qbrVdEHw==
X-CSE-MsgGUID: OXzz8Kv+RN+UEkRdj15dWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="169136448"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 06 Aug 2025 15:06:40 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujmHN-00029C-0f;
	Wed, 06 Aug 2025 22:06:37 +0000
Date: Thu, 7 Aug 2025 06:05:53 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>, Tom Zanussi <zanussi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>, aahringo@redhat.com,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 1/7] tracing: Replace syscall RCU pointer assignment with
 READ/WRITE_ONCE()
Message-ID: <202508070546.KmEoxWkg-lkp@intel.com>
References: <20250805193234.745705874@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805193234.745705874@kernel.org>
X-Stat-Signature: wh3n3uk6h1kik63fro3np4pnqco17hdz
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E49920009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754518004-868405
X-HE-Meta: U2FsdGVkX19zjP9DUF5l7m+m9l9KxbeRiZNp0oFV1vipu9t01m3ROPzpzqMB+5xZPrbk6Mb1CSKxgu+pSFa6ZBSMF1/Sdat6lGzAKHxknSuZqZgbRqAVXkDEGxk+RlixQ/7nI2aUzDZhKxtW8NGdMuRovak3tcf98J9nbQNdJLJrgKbN+HO7P2NCdD2voPcFBbpY8LqAG4xtQChIOGoPM1tCyiIkzgL3prmtcyg9kcUC7fJA6rK8BF40cVn6t9hC44ee0VF7a+ECRdXRsBJmUrbcIVE109ISOGx0ZI6HjDU2mDN8WlyfVL2CF3UvnWmLQgBhj9UPnj8txRsgXGkI8fvDucg48fIzrlckOr3CWHonBwucnnAbevTnnlBOtHlwhJTQO36xjQgLC5nfoLkmUyQHpCt1kWxzJtctlfXCeDRIS4Jzl0alK2QH4J0pZHIX2EoH3jq4lKFJZi4fIePGJDlzHvqwtG8GYkyjxS2kTVMOn9fDXbUZ6ncr5O/EuaxjjNLtceKNqVLw+3jpyZh+CiPQB4L0wvz7FF62pLKBQvaHdRsQZAtk/WXBJp4USt3NoKtZfurKe7vKU2IejKV7XD/dyxtI0qED+w2bb9v4RUjyFgKRzxDzhd3XfLLh1zLdIl5GU8Qf75bYHKCiwhCtvp7P01Azp7Axb9o3Z3RFCE/qA+XtvcLO0DfJV1WFa+vim5RX82Xy801F1qTQm0UYPJe/6yDPXesVdsSzGYHTU+BF41/ngdbJft/vQqkefe1CUa+bhYmKONC1WDfnNj+HXKkGDRqkglmKJUJ1X5v3FrJaHTtKQsAj3s9D4sJQoWmdzIbb/Vdnw8doigSYKUIDaIIEGvn92TrdYNqVCUlMSXNYl2gddf1mcWsJVEWIfEzUTucaFHDyG1jWbTmQCJ9Cm9QyodGdp8fsjPX6tb9bnS4IAyh5Ve3z7bPAROzI85pyiJsJHvoMp38VhoPFn+m
 /Tr0eRW8
 b72FEmBn1xh3xh9txOfVxz4z34EYqqgJJh9vwT6GwvHn8vWKw9toIeJaVN1JyjlLeWcd6wPaIi/ONyUS5E6PNYjhIzNOJbewYVIcqQvFjCDbm1AVFbMQlTLOAla2EQ0wvLSrCRtVTLUy84ZGZuOusCEVhLXkyq57ivmBMWpEXPtkSogTosit2Q6BI3DxeuusXt1kfVyapZ6Gl30mTu0VL1olWdwBVMJZYuE9lTWOSL75XLRh/DcHZVk57pxZ0GW6jMsTF1feykJeZ+JwcNthkPiX+evIsPjNPRDH/Npzpb9BrinDblm5IyI+aqfHhN+fTl3/mfDDVxN5SQrkUbhvDzNy5IaEyMQQG5IwxyAOE6PWzYDy4xK4qnwdiXJly304bVuVtPh1FxgECc5mQG/RzaLLvtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on trace/for-next]
[also build test WARNING on linus/master v6.16 next-20250806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Replace-syscall-RCU-pointer-assignment-with-READ-WRITE_ONCE/20250806-122312
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250805193234.745705874%40kernel.org
patch subject: [PATCH 1/7] tracing: Replace syscall RCU pointer assignment with READ/WRITE_ONCE()
config: x86_64-randconfig-123-20250806 (https://download.01.org/0day-ci/archive/20250807/202508070546.KmEoxWkg-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508070546.KmEoxWkg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508070546.KmEoxWkg-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/trace/trace_syscalls.c:313:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct trace_event_file *trace_file @@     got struct trace_event_file [noderef] __rcu * @@
   kernel/trace/trace_syscalls.c:313:20: sparse:     expected struct trace_event_file *trace_file
   kernel/trace/trace_syscalls.c:313:20: sparse:     got struct trace_event_file [noderef] __rcu *
   kernel/trace/trace_syscalls.c:358:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct trace_event_file *trace_file @@     got struct trace_event_file [noderef] __rcu * @@
   kernel/trace/trace_syscalls.c:358:20: sparse:     expected struct trace_event_file *trace_file
   kernel/trace/trace_syscalls.c:358:20: sparse:     got struct trace_event_file [noderef] __rcu *
>> kernel/trace/trace_syscalls.c:394:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct trace_event_file [noderef] __rcu *volatile @@     got struct trace_event_file *file @@
   kernel/trace/trace_syscalls.c:394:17: sparse:     expected struct trace_event_file [noderef] __rcu *volatile
   kernel/trace/trace_syscalls.c:394:17: sparse:     got struct trace_event_file *file
   kernel/trace/trace_syscalls.c:432:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct trace_event_file [noderef] __rcu *volatile @@     got struct trace_event_file *file @@
   kernel/trace/trace_syscalls.c:432:17: sparse:     expected struct trace_event_file [noderef] __rcu *volatile
   kernel/trace/trace_syscalls.c:432:17: sparse:     got struct trace_event_file *file

vim +313 kernel/trace/trace_syscalls.c

   290	
   291	static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
   292	{
   293		struct trace_array *tr = data;
   294		struct trace_event_file *trace_file;
   295		struct syscall_trace_enter *entry;
   296		struct syscall_metadata *sys_data;
   297		struct trace_event_buffer fbuffer;
   298		unsigned long args[6];
   299		int syscall_nr;
   300		int size;
   301	
   302		/*
   303		 * Syscall probe called with preemption enabled, but the ring
   304		 * buffer and per-cpu data require preemption to be disabled.
   305		 */
   306		might_fault();
   307		guard(preempt_notrace)();
   308	
   309		syscall_nr = trace_get_syscall_nr(current, regs);
   310		if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
   311			return;
   312	
 > 313		trace_file = READ_ONCE(tr->enter_syscall_files[syscall_nr]);
   314		if (!trace_file)
   315			return;
   316	
   317		if (trace_trigger_soft_disabled(trace_file))
   318			return;
   319	
   320		sys_data = syscall_nr_to_meta(syscall_nr);
   321		if (!sys_data)
   322			return;
   323	
   324		size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
   325	
   326		entry = trace_event_buffer_reserve(&fbuffer, trace_file, size);
   327		if (!entry)
   328			return;
   329	
   330		entry = ring_buffer_event_data(fbuffer.event);
   331		entry->nr = syscall_nr;
   332		syscall_get_arguments(current, regs, args);
   333		memcpy(entry->args, args, sizeof(unsigned long) * sys_data->nb_args);
   334	
   335		trace_event_buffer_commit(&fbuffer);
   336	}
   337	
   338	static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
   339	{
   340		struct trace_array *tr = data;
   341		struct trace_event_file *trace_file;
   342		struct syscall_trace_exit *entry;
   343		struct syscall_metadata *sys_data;
   344		struct trace_event_buffer fbuffer;
   345		int syscall_nr;
   346	
   347		/*
   348		 * Syscall probe called with preemption enabled, but the ring
   349		 * buffer and per-cpu data require preemption to be disabled.
   350		 */
   351		might_fault();
   352		guard(preempt_notrace)();
   353	
   354		syscall_nr = trace_get_syscall_nr(current, regs);
   355		if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
   356			return;
   357	
   358		trace_file = READ_ONCE(tr->exit_syscall_files[syscall_nr]);
   359		if (!trace_file)
   360			return;
   361	
   362		if (trace_trigger_soft_disabled(trace_file))
   363			return;
   364	
   365		sys_data = syscall_nr_to_meta(syscall_nr);
   366		if (!sys_data)
   367			return;
   368	
   369		entry = trace_event_buffer_reserve(&fbuffer, trace_file, sizeof(*entry));
   370		if (!entry)
   371			return;
   372	
   373		entry = ring_buffer_event_data(fbuffer.event);
   374		entry->nr = syscall_nr;
   375		entry->ret = syscall_get_return_value(current, regs);
   376	
   377		trace_event_buffer_commit(&fbuffer);
   378	}
   379	
   380	static int reg_event_syscall_enter(struct trace_event_file *file,
   381					   struct trace_event_call *call)
   382	{
   383		struct trace_array *tr = file->tr;
   384		int ret = 0;
   385		int num;
   386	
   387		num = ((struct syscall_metadata *)call->data)->syscall_nr;
   388		if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
   389			return -ENOSYS;
   390		mutex_lock(&syscall_trace_lock);
   391		if (!tr->sys_refcount_enter)
   392			ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
   393		if (!ret) {
 > 394			WRITE_ONCE(tr->enter_syscall_files[num], file);
   395			tr->sys_refcount_enter++;
   396		}
   397		mutex_unlock(&syscall_trace_lock);
   398		return ret;
   399	}
   400	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

