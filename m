Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A49CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815446B0095; Wed, 17 Jun 2026 11:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED1E6B00A1; Wed, 17 Jun 2026 11:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE166B00AB; Wed, 17 Jun 2026 11:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 434D06B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:04:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C56D48DEA3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:04:54 +0000 (UTC)
X-FDA: 84889726908.22.AB199C5
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id BB0A520016
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:04:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WOme3iZk;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781708693;
	b=rUWIatIW/11TxjhI54EnbPPefD1Wwcjwd4nEp1k4G2Vq4H6u7qbmfD2pZQ4UxH2IFbc/ot
	RY6tOcTjRySL349vQAYKRY0jF0rH/8fgUHfCEjVY2P3jiapzi5sFJc+cyu+V/9zctC0JA5
	xCrWBPwWqmGYoL+GtSIfN8adPwzBC1I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WOme3iZk;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbMKVIg1ugQqoGUC2QorVo8Wp1VDG1veyx0si63uoJ8=;
	b=7Z3beMIVfOLW8EXZI5llcs9rj0nLdlOcvW5B5sqXlav4apHqRJ6Tr0gum1Xo1UlW0EYZJb
	Iti1MAO/DeBPZUprj08ClCjgPh9eHtydQQMtjFDC/f4WzQ+U4tjmY7ZoJME/p3FQdtN6ly
	VnwLf2mCs6ncUesfG4SqdEewynq3wvs=
Date: Wed, 17 Jun 2026 08:03:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781708690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbMKVIg1ugQqoGUC2QorVo8Wp1VDG1veyx0si63uoJ8=;
	b=WOme3iZkjUstaFqsR8e6YxV33RE+tvJbmRG1dpljlqB6A5YYNHRMCwbcBkoSFlTB09aSpx
	1xBF1TWLDlHCOuNbPGqY0IUI8kKBcsZWGQ4X9q+Bth+V+yf6nv2NcW16PSjDKtJlpQLce3
	P4vtaBa/qoHNwZCasMMHzt9mdM2ZR8M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org, 
	willy@infradead.org, usama.arif@linux.dev, akpm@linux-foundation.org, 
	vbabka@kernel.org, mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
Message-ID: <ajK1YsIJmD2ImbAk@linux.dev>
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB0A520016
X-Rspam-User: 
X-Stat-Signature: tctubcup9kcxq59ky9cdf5e1hpt8j7bm
X-HE-Tag: 1781708692-889595
X-HE-Meta: U2FsdGVkX1/S51gHqbNtunevzvn1zUayjcZI48eBybgth3YE4bWozLR2jdH3qRqads1YGitJc6COtXd4xfGuz6eQuATYP2FgeQKAEYAs/OT98ISqqxVnbswtXCWTx+460UcD/+BOTgxJJmiGkNQcFJki2maZWhGiDvQGGwX1vateJjZFQ93KV3vRhkpD023woip7svRmWuwFhYuMJFDwnkKu/GeIUifmqoW9Qzx3iY2sAtdoywyJIUCaFNh3zuCeJw0dGi2CdLktUjbua/mp3rz7Tr/Kg652NNiJsPVVOXbdZaYeltPBJQIBo8RJWQyiI11Zuw6LUdArwvAaFtqF0f6P2bgh+itqmjhxIKsulvuuK8wlVd5ozePcIR4VxTyCNAH0IjX8Zt9ra519opDWO3i0wA8GFtEGgPSotJWO4lbR30eX3DOsTQovcqMEoUM4HD/Z/HO2WXCGTVJx4n+EO7+YHJGNenfCxA0vzPLfAPc7BNTFSp5f0wngfZx2QQ+7QOzXNRYdyrvqgYukyclGS9I3vH3m3SIuUBN2IvQ36KrV1UyRjcE3W3pXG0GZ5v4zkEhr0l1il/t2qu5fB5P8MBFABJ/8YoAbA/15ueOTKqfwNx3SGwnVGUG/o6C5+QTxTQ7YmhCDoY9Ji8A+N9AlC83IvHT2FlfeIeOD2bBEfUyLAclluSVX+T78j74qgLPaymM16XmbacDgEHLfVCIJaogs4ePU/ZyeATHEFS4ipvePykyoIoFylij0aDbo++0KCaGnZwIUVwnbp+LVGRGIRxjGNamCeO2RX/8dmS0HrG18Bi4p5y04p3HIlNwMN7ah/d/R0aWw+k2nYOD16OMUXdGDPwEZuffUAHePtg0vi8VEoDu251mEqQDUbDFGQzvvilUtT2laBV/jT88kLhiGzqgftFmQxDGfVML2f5t3IPL49I7Mxemdnt/vF5DjMSeNe7lf61E47kO6oSYtIur
 J9UkQQMZ
 GAi47VTSDc3dAPEkPScaTW9Ys4ZQB6gbiCsPauhAhDks48tZyEx/XSnte7/XMXYl2yUtIjpbt55skiDwmmu1DJGDWaBfQPFoHGnLhbjuFkHXVZMAYO7xOlT51KeG7hN5+0whBE732u3VnKKQ0aVGiYq4Kqj5JpHUq2//MlEP+yW8IpFtWdKn2FpuTgiQu2OTScyI0b5d69we2RdzExNlLdC9uZvJML7Teb9CNWZ17PEEPrP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:11:16PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 21:52, JP Kobryn wrote:
> > LRU add batches can be drained before they reach capacity. This can be a
> > source of LRU lock contention, but it is not currently possible to
> > attribute these drains to callers with existing tracepoints.
> > 
> > Add mm_lru_add_drain to report the CPU and lru_add batch count when an
> > lru_add batch is drained. This allows tracing to distinguish full drains
> > from partial drains and attribute them to the calling stack.
> > 
> > Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
> > whether they set the force flag for all CPUs. The tracepoint resembles
> > the signature of the enclosing function, but is needed because of
> > potential inlining.
> > 
> > Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> > ---
> >  include/trace/events/pagemap.h | 37 ++++++++++++++++++++++++++++++++++
> >  mm/swap.c                      |  7 ++++++-
> >  2 files changed, 43 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
> > index 171524d3526d..ff3da07ccb40 100644
> > --- a/include/trace/events/pagemap.h
> > +++ b/include/trace/events/pagemap.h
> > @@ -77,6 +77,43 @@ TRACE_EVENT(mm_lru_activate,
> >  	TP_printk("folio=%p pfn=0x%lx", __entry->folio, __entry->pfn)
> >  );
> >  
> > +TRACE_EVENT(mm_lru_add_drain,
> > +
> > +	TP_PROTO(int cpu, unsigned int nr),
> > +
> > +	TP_ARGS(cpu, nr),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(int,		cpu	)
> > +		__field(unsigned int,	nr	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->cpu	= cpu;
> > +		__entry->nr	= nr;
> > +	),
> > +
> > +	TP_printk("cpu=%d nr=%u", __entry->cpu, __entry->nr)
> > +);
> > +
> > +TRACE_EVENT(mm_lru_add_drain_all,
> > +
> > +	TP_PROTO(bool force_all_cpus),
> > +
> > +	TP_ARGS(force_all_cpus),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(bool,	force_all_cpus	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->force_all_cpus	= force_all_cpus;
> > +	),
> > +
> > +	TP_printk("force_all_cpus=%s",
> > +		__entry->force_all_cpus ? "true" : "false")
> > +);
> > +
> >  #endif /* _TRACE_PAGEMAP_H */
> >  
> >  /* This part must be outside protection */
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 588f50d8f1a8..e14b7612f896 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -694,9 +694,12 @@ void lru_add_drain_cpu(int cpu)
> >  {
> >  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> >  	struct folio_batch *fbatch = &fbatches->lru_add;
> > +	unsigned int nr_folios_add = folio_batch_count(fbatch);
> >  
> > -	if (folio_batch_count(fbatch))
> > +	if (nr_folios_add) {
> >  		folio_batch_move_lru(fbatch, lru_add);
> > +		trace_mm_lru_add_drain(cpu, nr_folios_add);
> > +	}
> >  
> >  	fbatch = &fbatches->lru_move_tail;
> >  	/* Disabling interrupts below acts as a compiler barrier. */
> > @@ -869,6 +872,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
> >  	if (WARN_ON(!mm_percpu_wq))
> >  		return;
> >  
> > +	trace_mm_lru_add_drain_all(force_all_cpus);
> > +
> >  	/*
> >  	 * Guarantee folio_batch counter stores visible by this CPU
> >  	 * are visible to other CPUs before loading the current drain
> 
> Given that trace events can quickly become stable ABI [1], are we really sure we
> want to add this?

Yes, I think so as this is useful to get insights into lru cache draining.
Trace events being stable or not is secondary IMHO. If in future we rearchitect
the lru page handling where there is no cache draining anymore, we can make
these a noops.

> 
> [1] https://lore.kernel.org/r/20260603130006.7d2c4a62@gandalf.local.home
> 
> -- 
> Cheers,
> 
> David

