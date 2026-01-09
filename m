Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9379D26D67
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4913F6B0088; Fri,  9 Jan 2026 10:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472A46B0089; Fri,  9 Jan 2026 10:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EED6B008A; Fri,  9 Jan 2026 10:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 276406B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:22:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8080F1A01CB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:22:35 +0000 (UTC)
X-FDA: 84312792270.05.AA0C681
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA00D1C0018
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:22:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767972153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rAozNa/Z+tqH/giXVo/fp/b7+Zy4Dz4yZ8ziQWD3XhE=;
	b=SdurPNXIMnfylTG9JZ8Xoi8w/7tItZJkPfxYFy4PLIlI2nCFJ5q+fds0+vhF9loLDt7G/P
	rIti80DavvVAqNGfYBozQPLMc9rjqVDVl+YaUYS/VAADFIhjchvWSSK/B11gX6G4L4ur+/
	Owdyc/C7nKEP4dL3xEN3BxPSMM28ZAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767972153; a=rsa-sha256;
	cv=none;
	b=Zjlv5XQDMbFsgvlO2IE8+S99/s+wLZBrBcfKWZ7yyzdQTzBUfYoukzcn5etdqMjxZ0pCej
	P/86zguA5vGLEdxPd1imO5GgLfTDi2oiba3bgbkSrsJlzJjHpZoEaPUY291BbSL3kHvRwt
	YlSkGng9OhFT6IffglplKEX1sJiHarc=
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32F721398C3;
	Fri,  9 Jan 2026 15:22:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id D407020037;
	Fri,  9 Jan 2026 15:22:29 +0000 (UTC)
Date: Fri, 9 Jan 2026 10:23:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, lkp@intel.com,
 oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <20260109102301.19daeb27@gandalf.local.home>
In-Reply-To: <202511071533.domGENBS-lkp@intel.com>
References: <20251105161935.545400234@kernel.org>
	<202511071533.domGENBS-lkp@intel.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19jdSeoFBztHLOMU/lMm14vAteYNKPwXT0=
X-HE-Meta: U2FsdGVkX19ilsxq7u3MRtKL3dJWwByiZPh/dNykQoGfoiGRpH0i/9tNzbovF3etCkRCiRnHo67ShzJFR/TraY0X0a9rM0tfe2y6bnDYxcu0iNSbLdNupEDNpoREIG8kiiV2i0pLDtLKSY8sKgGq0GEuZauFHyo4PITU50uRah6+FlLoS8w5Qyivk6Ee+beVybcCb7dexIMQy2UaVsru7qRMocTetT5YY+f2ZfBaBdn9FI0gDV25+4Mcn4mWhfr3Q/0CJd8HA68QvRB3EjoCMa9AX9JXcPu+3ezm/eGMG2WDkxQMuCckiyUEIvqbV3rrGoh9OFBNR6KXtvyT8FzvabHby38Ah4Wc3MGLKpJhF68+U9PWPpv6gwZpjzPdzv5Zhleh7hguR73jsagOpzzOhgaj25IoZY7Pf0i1lB3A5ROKNBONjkfzbHQXswos25UOP7DjiG+U+l55bw7GCXi+W7A6UTqnz/VcizWk5Q2JAFmq6RhP7PU6BaVhFOzmiM6zQwqiT3rbbzdHA/1gHeXNng==
X-Rspamd-Queue-Id: BA00D1C0018
X-Stat-Signature: 5ts5jgdwjg7an8rtt8yece7cajhzc5r6
X-HE-Tag-Orig: 1767972149-424104
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767972153-555630
X-HE-Meta: U2FsdGVkX189e/lRfq1X7XDuy+Kf4Cn0AMcT/wnPa7NhI1qYR0w354dHx4HAElHxzUl5Pjlig171n5gc/00GPloXA3k2nWdk3SiELysVgjt4EXQs4OGBT7fdhmrtpdBofdUl6pfCfDYIWPmoorcPug+QBGganf3fpzg8vm9xxy25qxUUAQVOgVn2sMyjAZhPFyCbFuzgXhy53D/TXaEpvoPZLsKyDtlANfwFk70snVVQPTu3wuqogfaw1EKpyUsJuNcLz7BRa1CqEVyG0txTc7/aGPorIH5J9RAUfpBt0/IyWemSoEJJSUN6kZaMh2C7BkAEOtJzF4dfk3PMUfUQQ0wO2XrC4LiyVndYsq41XY3319QH7zhVNS9IYGkxwOiLIxGvoqOxjtljGVB086jX9Sd08m8NOT4FJCOQBcGfZdRB2zbDtulwlRuRIYqD60ptKfATrCK4bTKpxG8l+qJ9NsSe1TzNZtgyN8YPpG/Fpv719rT5RtdbeVQUBd36PRvkN7F2Mb8DZ5P/2Trx6z60rPOBkTG74mFyCN7nob6eon5Ov66ffqJ+2lx0uo9EzyL9Pki3/4z1xti8Dxcw+wRWE6Jbccq9DM+yfOCLAXw4ndCjvFwY7v+OEriiTJX7kejHu9B5JkUE/h/+P7okgfAGJRV2GceTJC+47VQCQ4QCUgul0TpZG1e2Cfek9M0zSnWXPryb8AVDx79Y1lkz8WC09q82rBfOS77t/SjifC9uQueAKkFveKiDNUW8qJR8LIRdpvRbpKeGSBtE8LzJiovDhoa1mj/sK5FwTRr4SLEhADoPf9b7yOu2ys1E7YTlZg7dAbyxpntZoazMVe/aLqdDOTjM0jQ6OkZUl8srNCarNV3wyaU9YzhYbl9fBqwiQDuQ2+juO9TAdIP9/DDCHnXFGo1TClXuaAgm2JjAvPdkhML2DdF2Co0uHlCcy/uE7NXhpfN+wxXkw+xfDfKHxQu
 giIhUGqK
 lx0uYwjEX4Y50q1B6ye7KhcxB2ZGXUwkmJsE/1osdgsrvRDbVGzKzUgZERHImCwc7fFmZPm/WNMQVc6sB196uvLRpys10SZWC69geZ7QIe9Oo1C7lBhn1+9CU0hg9ctF7V1iEOYHSnD7MGRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Jan 2026 18:23:31 +0300
Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Hi Steven,

Hi Dan,

> 
> kernel test robot noticed the following build warnings:
> 
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Remove-dummy-options-and-flags/20251106-010511
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
> patch link:    https://lore.kernel.org/r/20251105161935.545400234%40kernel.org

This is an old patch (v1) and v3 fixed this issue:
   https://lore.kernel.org/all/20251110234341.767135255@kernel.org/

 and v4 was applied and is now in mainline.

The patch you are reporting on was sent Nov 5th, the fix was sent Nov 10th.

Why is this sending reports about an old patch that is obsolete? Is there
something wrong with your setup?

-- Steve

> patch subject: [PATCH 3/5] tracing: Have tracer option be instance specific
> config: i386-randconfig-r072-20251107 (https://download.01.org/0day-ci/archive/20251107/202511071533.domGENBS-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202511071533.domGENBS-lkp@intel.com/
> 
> smatch warnings:
> kernel/trace/trace.c:6313 tracing_set_tracer() warn: iterator used outside loop: 't'
> 
> vim +/t +6313 kernel/trace/trace.c
> 
> 9c5b9d3d65e4858 Masami Hiramatsu         2020-01-11  6285  int tracing_set_tracer(struct trace_array *tr, const char *buf)
> 09d23a1d8a82e81 Steven Rostedt (Red Hat  2015-02-03  6286) {
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6287  	struct tracer *trace;
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6288  	struct tracers *t;
> 12883efb670c28d Steven Rostedt (Red Hat  2013-03-05  6289) #ifdef CONFIG_TRACER_MAX_TRACE
> 34600f0e9c33c9c Steven Rostedt           2013-01-22  6290  	bool had_max_tr;
> 12883efb670c28d Steven Rostedt (Red Hat  2013-03-05  6291) #endif
> d33b10c0c73adca Steven Rostedt           2024-12-24  6292  	int ret;
> bc0c38d139ec7fc Steven Rostedt           2008-05-12  6293  
> d33b10c0c73adca Steven Rostedt           2024-12-24  6294  	guard(mutex)(&trace_types_lock);
> 1027fcb206a0fb8 Steven Rostedt           2009-03-12  6295  
> 7a1d1e4b9639ff0 Steven Rostedt (Google   2024-06-12  6296) 	update_last_data(tr);
> 7a1d1e4b9639ff0 Steven Rostedt (Google   2024-06-12  6297) 
> a1f157c7a3bb342 Zheng Yejian             2023-09-06  6298  	if (!tr->ring_buffer_expanded) {
> 2b6080f28c7cc3e Steven Rostedt           2012-05-11  6299  		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
> 438ced1720b5840 Vaibhav Nagarnaik        2012-02-02  6300  						RING_BUFFER_ALL_CPUS);
> 73c5162aa362a54 Steven Rostedt           2009-03-11  6301  		if (ret < 0)
> d33b10c0c73adca Steven Rostedt           2024-12-24  6302  			return ret;
> 73c5162aa362a54 Steven Rostedt           2009-03-11  6303  		ret = 0;
> 73c5162aa362a54 Steven Rostedt           2009-03-11  6304  	}
> 73c5162aa362a54 Steven Rostedt           2009-03-11  6305  
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6306  	list_for_each_entry(t, &tr->tracers, list) {
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6307  		if (strcmp(t->tracer->name, buf) == 0)
> bc0c38d139ec7fc Steven Rostedt           2008-05-12  6308  			break;
> bc0c38d139ec7fc Steven Rostedt           2008-05-12  6309  	}
> d33b10c0c73adca Steven Rostedt           2024-12-24  6310  	if (!t)
> 
> t can't be NULL here.  It needs to be if (list_entry_is_head()) return;
> 
> d33b10c0c73adca Steven Rostedt           2024-12-24  6311  		return -EINVAL;
> d33b10c0c73adca Steven Rostedt           2024-12-24  6312  
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05 @6313  	if (t->tracer == tr->current_trace)
> d33b10c0c73adca Steven Rostedt           2024-12-24  6314  		return 0;
> bc0c38d139ec7fc Steven Rostedt           2008-05-12  6315  
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6316  	trace = t->tracer;
> 4699bbb369ba1d3 Steven Rostedt           2025-11-05  6317  
> 


