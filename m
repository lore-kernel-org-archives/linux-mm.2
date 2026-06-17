Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0D8CD98F3
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2506B0005; Wed, 17 Jun 2026 14:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597AA6B0088; Wed, 17 Jun 2026 14:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F066B008C; Wed, 17 Jun 2026 14:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1824B6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:19:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8269EC2139
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:19:05 +0000 (UTC)
X-FDA: 84890216250.09.DEED3F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BBED212000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:19:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQOFWsva;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781720343;
	b=txv9CkLZ7gAjYhJqRnEvbXIIvuidcFOiRniAUrHh8+LOV5ipJw8MPOjHjQGM9mXdSIrT6a
	XfzOjieZCXxR5+mlVsD+sZmQsfA1t7WZeaRprhVi9tkYvOfH4BEXOUQBbBqjgMYdQC2mHp
	9FMvqkSL2d54qD/N8l15TYFVi/A3NTg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQOFWsva;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781720343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65QRkQSPu45itKPZo5VCpczhZ2orHwojKEIsve8RGCg=;
	b=X0WGSGey5esWeTPdYrAt7FLyxrg7lEnWNTKMivX+iEiaioXSPT//ff8FQwrhZTtA1s5Mna
	/GLI4Gopg7Um5JDSieT8m8BaH9dyIKMBfjm/sZxt0jKdDSYRtxE/gFN0rl7bvUwvhSM4+5
	+W8h8HAKn5PM03y2OTc3Vzpd3iNWO2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15BBB60052;
	Wed, 17 Jun 2026 18:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A411F000E9;
	Wed, 17 Jun 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781720342;
	bh=65QRkQSPu45itKPZo5VCpczhZ2orHwojKEIsve8RGCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TQOFWsvacBh/H+QKfWlTUHQpbcJy5i705DeADqJ8QDA0XtY3ARIdOD4G6U5MHBQf9
	 vG/WIIoc5axb9rFBefsHIpYzWZ+N0hbwQEQNBL5u5417hBCwUg/PmGGbvX1WoZnpy5
	 6IaE+eGmciTr4YBs51A4NNr0nND7U3r7mN2OIi6MjOy6ICb35H2mQUe4ktcbJAiMKv
	 zLWuYTbAOrPcb+eylcCF+g2mQ0ixJTmucUj09gNZTiDWpYWS/ZriQuLhB7nXR9ae0U
	 s2pzK5PRzngFjmUbwJlVh/A16KcVmlmdYYgcWC34c2cfWEjXxAlrxS/qJanH7u9y29
	 xjgguslc/s0Jw==
Message-ID: <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
Date: Wed, 17 Jun 2026 20:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org, willy@infradead.org,
 usama.arif@linux.dev, akpm@linux-foundation.org, mhocko@suse.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
 <ajK1YsIJmD2ImbAk@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ajK1YsIJmD2ImbAk@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBED212000A
X-Rspam-User: 
X-Stat-Signature: 13ig7oyn59f4ytybxy6rmeyyup1gp5t3
X-HE-Tag: 1781720343-232056
X-HE-Meta: U2FsdGVkX1+UdJpJfEWckOaa2FtihipSn8uOY4D0i90ZduCBz93wYHwzSNh4T5U/iFPdJ6zn5jp7H+tTec/iP2v6MGi41GLOYLWaUvnE+dtkuHD/DZPWOQlk/1wgYKe55F02ZQSY6izUj/uE7ar/I4dVyqNLhwCDWNFs/N1l3wLuT+0O46sfXk/htY5Sav1y01UadXXXn2BqzWfD2sk91EUxoso4htcIXBu2chcC/xWyf6NV1BLdj80cLgo9BCoP0DSKSXo3Z41zn6gz9WD+B5llwhOlzZjeaxVN+Qm2w9IrQBds36xjkaX4ROnO4urFgzsKDMfgOL2KHrNy0G+Hf2vDOuHH8jEmtIdfy6dVX9m2bV5v40JtL5NcvbxRvHYU/HEGRFMxQCYfek/X7zGbqRBD30xoH89n2WxDN71lUPRuQ8Tu3V3LcrneerW5B/9GxKztrQ8NRBjj8LDVyle4fG45srqXkm2jLMt5CkM5eEAAJ/SJe57+ip4vr0JVf1D7/hxmu7Z6r9mj2K/cXtHHSpi+HCYMDIUaDKiRaNmM0/UjxujJm+j7aGrs9MEmwvSnD0/lj+FgB3k/mdCKDq1Icq4+glIeiQ651YOZk/AYMxdhLFr7Eby3tcRPqCLsPb8HMRS6/dIzKAPUFyqY4/b6GUvBRHaUZz436kWy1+M8jiL9XWs5Gi2UsJDlwsWmqP/E8pgJjZjsrm+GBxFGFrgabgJBatlBB1ncrQ7B8EdDzt5Y6m9bjbw6KAm+mmrUKFtQ1RMzHav/pvR3kJ6DaXeyVKjXkVst9yH5WTEFVqDie8VVTE+7IaSw5IC+Ez3Tz6Z3Xn/pdtrCjfpQ8+n8ynz0hn/Lim5Gt5LdSbGABzhelwqHRThYLWV1fTgkBbZwoUH/klYQ/05b6kzrdBfssLn8OjQAjsnUGGeu2E8gP59kYorDdf208cMewkAB4GrHFNU2MT+8z5X6QYcPHwWHlGZ
 RhTUfrYG
 Lbl+yd+aR7xhdXqP/Mlg6PhLdIb9CwG5RVph/DtJSH+vf1Cnqp3cLHRMFd66piBBVZiOD6tQyoNhFmyVBn22yWbUApLxh+qoP5+kDY8GPzbo7np1HncTJUEvwrSU6zs9QgBpl47p3GGFN08WXoTTbeEf68qar3slg3lpmkc4l9Eqa5ADCqIH1m2VG70+2C+nDIUmvu+q4UIU+95+G2PRLZ8lbIkzOrOjW4COSw1eSGjmavllV9USWrZ5YlBrbqgVyy55J7FkDGebXVTGTyfLGzMQWUcnFiAkZsmgf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 17:03, Shakeel Butt wrote:
> On Wed, Jun 17, 2026 at 01:11:16PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/10/26 21:52, JP Kobryn wrote:
>> > LRU add batches can be drained before they reach capacity. This can be a
>> > source of LRU lock contention, but it is not currently possible to
>> > attribute these drains to callers with existing tracepoints.
>> > 
>> > Add mm_lru_add_drain to report the CPU and lru_add batch count when an
>> > lru_add batch is drained. This allows tracing to distinguish full drains
>> > from partial drains and attribute them to the calling stack.
>> > 
>> > Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
>> > whether they set the force flag for all CPUs. The tracepoint resembles
>> > the signature of the enclosing function, but is needed because of
>> > potential inlining.
>> > 
>> > Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>> > ---
>> >  include/trace/events/pagemap.h | 37 ++++++++++++++++++++++++++++++++++
>> >  mm/swap.c                      |  7 ++++++-
>> >  2 files changed, 43 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
>> > index 171524d3526d..ff3da07ccb40 100644
>> > --- a/include/trace/events/pagemap.h
>> > +++ b/include/trace/events/pagemap.h
>> > @@ -77,6 +77,43 @@ TRACE_EVENT(mm_lru_activate,
>> >  	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
>> >  );
>> >  
>> > +TRACE_EVENT(mm_lru_add_drain,
>> > +
>> > +	TP_PROTO(int cpu, unsigned int nr),
>> > +
>> > +	TP_ARGS(cpu, nr),
>> > +
>> > +	TP_STRUCT__entry(
>> > +		__field(int,		cpu	)
>> > +		__field(unsigned int,	nr	)
>> > +	),
>> > +
>> > +	TP_fast_assign(
>> > +		__entry->cpu	= cpu;
>> > +		__entry->nr	= nr;
>> > +	),
>> > +
>> > +	TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
>> > +);
>> > +
>> > +TRACE_EVENT(mm_lru_add_drain_all,
>> > +
>> > +	TP_PROTO(bool force_all_cpus),
>> > +
>> > +	TP_ARGS(force_all_cpus),
>> > +
>> > +	TP_STRUCT__entry(
>> > +		__field(bool,	force_all_cpus	)
>> > +	),
>> > +
>> > +	TP_fast_assign(
>> > +		__entry->force_all_cpus	= force_all_cpus;
>> > +	),
>> > +
>> > +	TP_printk("force_all_cpus=%s",
>> > +		__entry->force_all_cpus ? "true" : "false")
>> > +);
>> > +
>> >  #endif /* _TRACE_PAGEMAP_H */
>> >  
>> >  /* This part must be outside protection */
>> > diff --git a/mm/swap.c b/mm/swap.c
>> > index 588f50d8f1a8..e14b7612f896 100644
>> > --- a/mm/swap.c
>> > +++ b/mm/swap.c
>> > @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
>> >  {
>> >  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>> >  	struct folio_batch *fbatch = &fbatches->lru_add;
>> > +	unsigned int nr_folios_add = folio_batch_count(fbatch);
>> >  
>> > -	if (folio_batch_count(fbatch))
>> > +	if (nr_folios_add) {
>> >  		folio_batch_move_lru(fbatch, lru_add);
>> > +		trace_mm_lru_add_drain(cpu, nr_folios_add);
>> > +	}
>> >  
>> >  	fbatch = &fbatches->lru_move_tail;
>> >  	/* Disabling interrupts below acts as a compiler barrier. */
>> > @@ -869,6 +872,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
>> >  	if (WARN_ON(!mm_percpu_wq))
>> >  		return;
>> >  
>> > +	trace_mm_lru_add_drain_all(force_all_cpus);
>> > +
>> >  	/*
>> >  	 * Guarantee folio_batch counter stores visible by this CPU
>> >  	 * are visible to other CPUs before loading the current drain
>> 
>> Given that trace events can quickly become stable ABI [1], are we really sure we
>> want to add this?
> 
> Yes, I think so as this is useful to get insights into lru cache draining.
> Trace events being stable or not is secondary IMHO. If in future we rearchitect
> the lru page handling where there is no cache draining anymore, we can make
> these a noops.

Yeah and I don't recall ever that a change to a mm tracepoint would ever
break someone who'd complain and we'd have to revert it. These are niche
enough. So I think the risk is low.

>> 
>> [1] https://lore.kernel.org/r/20260603130006.7d2c4a62@gandalf.local.home
>> 
>> -- 
>> Cheers,
>> 
>> David


