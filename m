Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3242FCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CCB6B00A2; Wed, 13 May 2026 14:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014256B00A3; Wed, 13 May 2026 14:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E930B6B00A5; Wed, 13 May 2026 14:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7D096B00A2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:07:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 802491C033B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:07:33 +0000 (UTC)
X-FDA: 84763179186.20.F3381BB
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id B429420007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:07:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778695651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=93ZVFisl0sHYyeZ6JmOZrDyCUtNRv5fbe4cpxg98fT0=;
	b=oRck3SL2St5hWFmp6BcGAGtNpHBSRzUEbF0SlF/0pnEinU24jppQHcGVCU8hV3GZx1g29n
	jv3XM3wgQH3258ivpii19NvBJklAGBx6kKFGNOjmT5XeDeXTERhBJl1Zt6e4eKMkmqxBHP
	YkdCHsfeeL+bI1lHDdOSTP2w8hVmefk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778695651; a=rsa-sha256;
	cv=none;
	b=Ubgx4tOpQtyP+SqESM3r9DpjW36OJhE+eeqFdMvEsranTWzLCmNJk+uRh5PPC84qaVlsDh
	3eWxtOfVi169u/w/JK5rrrE1412tFHATghqpnJMcjhxJYJwiHh8kK3xELAac9qevYlSwMU
	YhH70bxspF+is64djv7XDAR1El4EGoI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8304B4041D;
	Wed, 13 May 2026 18:07:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 9F6C220029;
	Wed, 13 May 2026 18:07:28 +0000 (UTC)
Date: Wed, 13 May 2026 14:07:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 18/28] mm/damon: trace probe_hits
Message-ID: <20260513140732.2320c563@gandalf.local.home>
In-Reply-To: <20260512143645.113201-19-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
	<20260512143645.113201-19-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+XR4QBARvilo/iw685qO7EjLUbgY33/3Y=
X-HE-Meta: U2FsdGVkX1+ztHJmbfencz8xskODMPGeCvM+5KKPEYCOFkZBK3DuVA72UQFXfLA2XiaCC1Lrd1TX827gLdPa0yRorEbvVLdnpgaP2F6PcYA57+G4DIsUo7ibScB41ACkwFPSMhmAucYTH00cudknJWH82uLgSDwtPpeXU/Pj4tC+S2F9GUC+0Mv+7Ta3YfAIhlYEMpS0vOK/oevVn/aRifCol3JS+mYZCoMZETyhMcyLWwaV5oT8PfG6LVCWLAHVKsG2gBZvSvI+/RzaE3AkdWg1hUsxpeVQfdTpEWUS0oQwAc84hFbgw8SZW3sCglk3BduJb90ng6hopBuHSDsK1pjZFYjAOl8d
X-Rspam-User: 
X-Rspamd-Queue-Id: B429420007
X-HE-Tag-Orig: 1778695648-519701
X-Rspamd-Server: rspam04
X-Stat-Signature: mao6a4r3ner7pq5kmhwxoum93sxri37m
X-HE-Tag: 1778695651-345644
X-HE-Meta: U2FsdGVkX1/B8tDpc1SA0exiR/karo+d1wng57ehsLDiVE0WZfPROH3ZUPwPlwHYfoFT/j0heoo0v4u+I2dLDd4q2gEce74RfcVaZx0lLRyRdog5ObUbspO6c4RHHWTiBSfsU8QES+urDmt7IY9NQg3IcvAhao2+FndDuhrCW3F3f5th7IEKJeqAPXV9AIE3DF01TyBB/pYQ5spJYEMZaUCzb7wDofy1w+GzxSMQKA6LEEflmIfFuNMqcFiMXwDOPhcPq8rZ4edoa7xs2SQnwz7pTZ1IHYai3QtYJJmblFvx4rEr7t+s1SjCYY9t9fGeZZKGb9ak2nW1PWxGQGDMUBmOfwVjbJmZXcLcnmgKqdmkjZWxxnvVqG1fT/dWbdjbi+Hw3WvzQ5ApbAYftOCG2MgETvuIISyuNZAkEoJWPJIi2cp5U4oVKbpzcTxbvfFVMVIQXONzJUtCydMXxCfrbmu5ltjESc430M+rZiy4wlQZaLsSNTr2Z/gYVrsb8SYi7xLyCLHRI25eyXyOw2KrLhBo+gJiQpjhTZW3rGrc4o0zUFU6Ax0/77ufFUrefIYAmr90YCYntY+pedupYFqfaSYDxs9tsfOIEZMWicSt/BQB9A8km7eV4n0lnIBQQgFDfTG3yMeJ4IMGMy5WgmMN4K1sTuq/+ORawc0sqcIs/P8lw+iWVKrsLEDdx1qNzqjrqw3WsNwwGLmIdP6tYnmg6g1ev8ICGqcQ9e1TmLuYFF8V6vsCW3hs4S0LUCxxyByxm2GqIezQY4Rymm8dTj9j64y6uzUvW59UEMmZvb/Fow1d3C2NXMSiSzDcojk2PnVxjjlJ9ELbJgFL/OYVAOB783EKK33jTP/uLYHWAKA91Alql6KkmPFuQU1s3Rim3u5U4mJNzEqPT8RZDOlNL3lgJFSGlLvNWQgydSrrgTLThnUCZCHw7WPsfJ8AEtS1JL7JDixKgrDjFQB62/zNqNu
 mwFXYNFb
 GN09J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 07:36:33 -0700
SeongJae Park <sj@kernel.org> wrote:

> Introduce a new tracepoint for exposing the per-region per-probe
> positive sample count via tracefs.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/trace/events/damon.h | 36 ++++++++++++++++++++++++++++++++++++
>  mm/damon/core.c              |  7 +++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> index 7e25f4469b81b..d7b94c7640217 100644
> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -130,6 +130,42 @@ TRACE_EVENT(damon_monitor_intervals_tune,
>  	TP_printk("sample_us=%lu", __entry->sample_us)
>  );
>  
> +TRACE_EVENT(damon_aggregated_v2,
> +
> +	TP_PROTO(unsigned int target_id, struct damon_region *r,
> +		unsigned int nr_regions, unsigned int nr_probes),
> +
> +	TP_ARGS(target_id, r, nr_regions, nr_probes),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, target_id)
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +		__field(unsigned int, nr_regions)
> +		__field(unsigned int, nr_accesses)
> +		__field(unsigned int, age)
> +		__dynamic_array(unsigned char, probe_hits, nr_probes)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->target_id = target_id;
> +		__entry->start = r->ar.start;
> +		__entry->end = r->ar.end;
> +		__entry->nr_regions = nr_regions;
> +		__entry->nr_accesses = r->nr_accesses;
> +		__entry->age = r->age;
> +		memcpy(__get_dynamic_array(probe_hits), r->probe_hits,
> +			sizeof(*r->probe_hits) * nr_probes);
> +	),
> +
> +	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u probe_hits=%s",
> +			__entry->target_id, __entry->nr_regions,
> +			__entry->start, __entry->end,
> +			__entry->nr_accesses, __entry->age,
> +			__print_hex(__get_dynamic_array(probe_hits),
> +				__get_dynamic_array_len(probe_hits)))
> +);
> +
>  TRACE_EVENT(damon_aggregated,
>  
>  	TP_PROTO(unsigned int target_id, struct damon_region *r,
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index fe6c789f2cecb..14b15c9876516 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1905,6 +1905,11 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
>  {
>  	struct damon_target *t;
>  	unsigned int ti = 0;	/* target's index */
> +	unsigned int nr_probes = 0;
> +	struct damon_probe *probe;
> +
> +	damon_for_each_probe(probe, c)
> +		nr_probes++;

Is the above logic needed when the tracepoint isn't enabled? If not, then you could add:

	if (trace_damon_aggregated_v2_enabled()) {
		damon_for_each_probe(probe, c)
			nr_probes++;
	}

And change the tracepoint to be a conditional tracepoint:

TRACE_EVENT_CONDITION(damon_aggregated_v2,

	TP_PROTO(..),

	TP_ARGS(..),

	TP_CONDITION(nr_probes > 0),

	[..]

And then the tracepoint is only triggered if nr_probes is greater than zero
(to handle races between the tracepoint being enabled in between the above
check and where it triggers).

-- Steve

>  
>  	damon_for_each_target(t, c) {
>  		struct damon_region *r;
> @@ -1913,6 +1918,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
>  			int i;
>  
>  			trace_damon_aggregated(ti, r, damon_nr_regions(t));
> +			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t),
> +					nr_probes);
>  			damon_warn_fix_nr_accesses_corruption(r);
>  			r->last_nr_accesses = r->nr_accesses;
>  			r->nr_accesses = 0;


