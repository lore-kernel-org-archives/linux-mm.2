Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2623FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 21:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49FA6B0005; Tue, 14 Jul 2026 17:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA566B0088; Tue, 14 Jul 2026 17:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED1B6B008C; Tue, 14 Jul 2026 17:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 624DB6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:14:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5B04A0511
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:14:44 +0000 (UTC)
X-FDA: 84988636488.12.E312080
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf17.hostedemail.com (Postfix) with ESMTP id 093A940002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:14:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784063683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKvOJNMobO+mlVKUT3NgXi3Acbt8uKLISzEEa0TKkJE=;
	b=QfNSgCk8HuNmKZu7DhYV9njHPoYa0PEE1XEgeMHwUryn0P7ZJEjkwlEfD2vZdaLdXZTdde
	nWK++aop6xmbi/7U5Dcl5euc8w3pWF+b/2dKjWANnxiXp2UYnh/05S7bUiKiQIQaK7eLAZ
	tGTheT9VLoU8KkGU6YyLmT74Lzw/EsE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784063683;
	b=KQxrdsvAbS6OVzcOv+EaU4/PDGjzsyHtJqt9S2uIWRf5feT230etB8kwbnYZyk+4zKMIyI
	i55Eo0IaE1erJhBLlu7HBTtposH80cJ9MjeGW4vj5babRnSZjl5IgEG5+g8+l8kc2qIHYB
	YrHyTMNZLu9oHx4TyD3KAUacCDLT87A=
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AA0440522;
	Tue, 14 Jul 2026 21:14:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 15C226000D;
	Tue, 14 Jul 2026 21:14:35 +0000 (UTC)
Date: Tue, 14 Jul 2026 17:14:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, x86@kernel.org, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 08/13] mm/kwatch: add hardware breakpoint backend
Message-ID: <20260714171438.226faf7b@gandalf.local.home>
In-Reply-To: <20260714183206.12688-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
	<20260714183206.12688-1-wangjinchao600@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/+jUG/wma6bXPaXNDDF4uPI966CzmydeA=
X-HE-Meta: U2FsdGVkX1+BwHjks+RcUuzIPHfbSeUChRislj0v1kLLaY98NAKF6cdZylAtqcI59w4fbE1UaMDFXzng8xvt0r2W54B6xPwD9aR33+AJde3xxYHmB3Xqy97uhwKNAjrEFHbwMYr8N+8lsjMIeaRezBQgyf4EPvq0NQyxCRRifw46VeA3PQuB85l2wH4sIawolc51TlXnBbIf/t6zg2PpDxpQ0xONaCpVs5SuoR/zHifYoqD66Sr0/ekUURTsxJf3+xmOBWatOhJM00GlJgkk1ANhdqTl8Jgjzp1LQGeDovN3/JPet+YhwAnTHMWlMR4NDTHuDFZrVnyepQjaQfBPmFF0Dc8n1a0i
X-Rspamd-Queue-Id: 093A940002
X-Stat-Signature: ofukrydpoaufx6f8q8s6anx3wj8ecikd
X-Rspam-User: 
X-HE-Tag-Orig: 1784063675-113700
X-Rspamd-Server: rspam12
X-HE-Tag: 1784063682-640300
X-HE-Meta: U2FsdGVkX1+wcnw1v5wNIfyBYe/OSsSGoLnYttckGrjIkZiQBKeyadKlYwGrJ2A7dOhPhSeSsucJEGsTxrW8sMksgvT8tYWVEStJpq/a22UuSd9iJupO4UCBMPdHfYi7O5FdUUBhvUWeHfGtzbdiVQkQklqFYe5474sHPmG4s7RPPZwoBzzxNxV4I4vNkx+SG3dtc9zeFh0evjsn5GoFWdGUOefcViYG+l3H/r+Nbw7kBGF+a6c1fcjWsB7fVg2RdZSu1GRmHvnLdpk1GAKi+dmYFn0GwnaHZmzuDzgclyNkTQiNMhj9NftVwZYYyZ3GD+mYjUqto1IwFrjkkvFEoFaLfzrdkpZkB0nxQUWqvXPhkMZM0MhQji7K9yrI5VTwTHiQ8XPrKHsw3WwMlYF49LkOkpPHw1Gq6nIj74GeSL+Kg6SHuO2pmoWE0VK6R3PgZK/ZfTJUhYjLfakNv3sYckoQ1wORSJ/JybovKYEP8YpcS3nL5b2MxYcOSjlzX9WrojBfvnU2w5Qed4oo4yygW0ZTidm8QVZvvjCME976mULIGnRsHaEs4IAbK8oGFyBgvxxtcJ3qI8+XBBtcyYs1vRTqDlv5fwVTiuFWtmKo/g5EznS4GZ9FsKxunTF57SMJrNgPm+egAAbMQ7w+kKwJ3Nlc/6nJhWMoFMfQ0z/CnMqB0sSIEtL+VzQ9aoSrgTHIhmmlS8IronHHATE2Lu9J0U+crknQBFQ6BubtLy/0RYmZSlhTeHi3X9vgcK28LUau1KZcC07wywXzQ6aEgdsF+c5Eu9Sj8TsF57rqXdWtbAUXo625IyOfPgEaHePT72cz0d5okBnHQJN9MjUguXociOlbEDzUsr0+yxykBdtke+e3CboMk9VswzGhNtLpAsgw9e0T7LTgRu8YdYoo30+wPkZLKwGvopEd+C3EUVUbsKDM/Zo/4+leJxv0B5Mv/Dbrxjw41sPvsg38YN/8i52
 9kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 02:32:06 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> --- /dev/null
> +++ b/include/trace/events/kwatch.h
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kwatch
> +
> +#if !defined(_TRACE_KWATCH_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_KWATCH_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/ptrace.h>
> +
> +#define KWATCH_STACK_DEPTH 8
> +
> +struct trace_seq;
> +const char *kwatch_trace_print_stack(struct trace_seq *p,
> +				     const unsigned long *stack,
> +				     unsigned int nr);
> +
> +TRACE_EVENT(kwatch_hit,
> +	TP_PROTO(unsigned long ip, unsigned long sp, unsigned long addr,
> +		 u64 time_ns,
> +		 unsigned long *stack_entries, unsigned int stack_nr),
> +	TP_ARGS(ip, sp, addr, time_ns, stack_entries, stack_nr),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, ip)
> +		__field(unsigned long, sp)
> +		__field(unsigned long, addr)
> +		__field(u64, time_ns)

Move the time_ns to the first field, as unsigned long on 32 bit
architectures is 4 bytes, and this will make 4 byte "hole" in the event.


> +		__field(unsigned int, stack_nr)

Make stack_nr the last element for the same reason.

> +		__array(unsigned long, stack, KWATCH_STACK_DEPTH)

Make the above a dynamic array based on stack entries.

		__dynamic_array(unsigned long, stack, min_t(unsigned int, stack_nr,
			  KWATCH_STACK_DEPTH);


> +	),
> +
> +	TP_fast_assign(
> +		unsigned int i;
		unsigned long *stack = __get_dynamic_array(stack);
> +
> +		__entry->ip = ip;
> +		__entry->sp = sp;
> +		__entry->addr = addr;
> +		__entry->time_ns = time_ns;
> +		__entry->stack_nr = min_t(unsigned int, stack_nr,
> +					  KWATCH_STACK_DEPTH);
> +		for (i = 0; i < __entry->stack_nr; i++)
> +			__entry->stack[i] = stack_entries[i];

			stack[i] = stack_entries[i];

> +	),
> +
> +	TP_printk("KWatch HIT: time=%llu.%06lu ip=%pS addr=0x%lx%s",
> +		  __entry->time_ns / 1000000000ULL,
> +		  (unsigned long)((__entry->time_ns / 1000ULL) % 1000000ULL),
> +		  (void *)__entry->ip, __entry->addr,
> +		  kwatch_trace_print_stack(p, __entry->stack,

		  kwatch_trace_print_stack(p, __get_dynamic_array(stack),

> +					   __entry->stack_nr))
> +);
> +

-- Steve

