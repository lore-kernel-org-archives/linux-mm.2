Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A07D65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8906B0005; Wed, 17 Dec 2025 17:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A2E6B0089; Wed, 17 Dec 2025 17:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4686B008A; Wed, 17 Dec 2025 17:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58C786B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:47:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07EBA16045C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:47:20 +0000 (UTC)
X-FDA: 84230450640.20.2033489
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4B92F180015
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:47:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766011638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJ20VAm0ZocttgsIVJSJRMWB7qVCgPAPdEPz1ZCLiMA=;
	b=uG82Bcq+DzM3m/xOdE82ouPfx4X5g3jAHVx/4ByTfnGFSHTKalCw1ZdMW2DW6jOz8l26TO
	8E0j+LivDXT6zSUFzJ+IEf/0riguXoByUfE7AT4N3MV/60sbZy3TYwqNuzksqYrn9puhKk
	a9OggrknvRDycoOVw8UrqifBS/U8dvU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766011638; a=rsa-sha256;
	cv=none;
	b=MYUkybQo/b6cnJPklD/KhOT1qb6KG3oNwCd0pmpZH3AD7RZi4BLIeuxfK+/BxY6Fgmm0A3
	r2pxANTFSE0YdRHZN219EtjtJMY1QvcrMKBmAV5AmMKCO8G/NLd0OyQamEtDJOtPB4KSa5
	GVMzl6BDdef5s4ZGxOHD8h1yRTWlyN4=
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E185CC0B70;
	Wed, 17 Dec 2025 22:47:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id DF9666000F;
	Wed, 17 Dec 2025 22:47:14 +0000 (UTC)
Date: Wed, 17 Dec 2025 17:48:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/damon/core: add trace point for damos stat per
 apply interval
Message-ID: <20251217174851.28e7c4e5@gandalf.local.home>
In-Reply-To: <20251216080128.42991-13-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
	<20251216080128.42991-13-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+bc+vDXAMiNWjhwd8WTXdVmvD70vBch1k=
X-HE-Meta: U2FsdGVkX18mvS6jbpgv0E5a2gSLRq6NLU55D3C9EWyncyzvoX0mKuL02jKKo58zakJhkQ7o+AgV+P5jmb12/3c/lY5m6m6FGYrY7atlrnNtuwsAcQ7S0+o0dQ1OZxpyJ9k6vfRrgo4LQt6/BrfpvgRSiuBlJD+NdEgJ2vIEJrfzJok/dmnmxPR9jd2xuL/yM2kQmlaEzfRr/X5L0k4X4YYDeYV6CGFV4YXKHaiG9w+yEfcACHcD6/A96nfysseo8oQwFEmE3EkYLl5PhxIOALv3zw+osDvuBsPzil6CNXu2gxTuzMU4qSIrVBABNFzFUElPx4vM21qw5OigF3Jtd5SWOA9znJQ3gBlVxrnHcv+revjO1HKrG6B8ax0JQwjFCapC7uqtCyALpyv/K88TKQ==
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B92F180015
X-Stat-Signature: 31nyrdsgbyo3jc4qijpnjctk1ajppz5e
X-HE-Tag-Orig: 1766011634-141987
X-HE-Tag: 1766011638-247946
X-HE-Meta: U2FsdGVkX1+qzV4dQBuxHePoa1nucwfosDn1nwgWPRNpa2DnKkGQ34Yy4LxsfgTTlMUxRdUxU22oUBCCsaNDeGLcSTHLYRg2nTMGtu63UOn2/3RQI5GaKoO/7XeLHJOyWepkCiy5iV0UBoYBDzyVR18b67Fm9/5lsxIFzLpKk46eDT5h/+LAy6jfMDD9KuVXXdUQulkkUTNw5kLG3UAlvbn5bpaf1GWGIdj7gLKRyWGP+OFmQX7f103gBIJMU3umELBjg3r090WfFqyex08XfQGWAi2DdUO55dIr1+7kue4+xD/0p1YNCBb0W3xoJ3f/9ICxA2nBKPICMM/vjGMMsOkw+bEXJwDAtz5F+nliU+X4iHaDo1kKAz6fXDNPfZtKuFFArILghenFEWaNmLXyNr6FOSg3fDZpetlRNt5ZPZgmUCAOq5q6nD76s6aPsvkuWbKlRnsw1S+xOsuB9t4asFRyIdrgu9W0KU9DW6ckkFLgdjde8Z5ApznOQPB4CMvSmhAwpONbW9pkf0K253tQb2z2S2iH5IZN3K7HYQKKDXW97sE1DZ+jQpPJrBTErfmlGLrxfOul1+SyQECGNDaTeM9vUVLqXojJfcGzYwrvOfHpeyFPqKBGSIfVGbhUP9JDZFXK3uOI7ni/aBsMFqC4/3owQYF5sJjbC2HfA+kMXW3hkO6yzQ+qZD8r/Zx0Q8ABqF9B888I4PSdCgRcu4iujQwjHXO6xFjyMv+1TXdOYLk6OAdChtO6eGTDbXy8wV6e6EYCy3o/xfVI5j8fYPS3KG296PjjgulW+DrKnw9yrIsKfxDIPa/EXZisYBgubTgm/Rb8MIigjxpoJ4izbKfQPbnMFnOSayP3R2KO5tmxa1elFo6YfAab5XnkFShJO4XRdrP0n85FkmrX081hzWnj5CfGAeZnPkRDzMyreYjbL7rYbJGWCY8pDMoqB19QshsKHGr9tuz3yrNE2rgiIMx
 0moMOPJN
 NXc3rwaHDig/GSuhVlNZ07kpCKpOtfWSHkUck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 00:01:25 -0800
SeongJae Park <sj@kernel.org> wrote:

> +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> +			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> +			"qt_exceeds=%lu nr_snapshots=%lu",

Nit, but it's been stated that strings should not be broken up because of
the column limit.

> +			__entry->context_idx, __entry->scheme_idx,
> +			__entry->nr_tried, __entry->sz_tried,
> +			__entry->nr_applied, __entry->sz_applied,
> +			__entry->sz_ops_filter_passed, __entry->qt_exceeds,
> +			__entry->nr_snapshots)
> +);
> +
>  TRACE_EVENT(damos_esz,
>  
>  	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8908aec6670f..68dd2f7acba2 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2256,6 +2256,22 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	quota->min_score = score;
>  }
>  
> +static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
> +{
> +	unsigned int cidx = 0, sidx = 0;
> +	struct damos *siter;
> +
> +	if (!trace_damos_stat_after_apply_interval_enabled())
> +		return;

Other than that, from a tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> +
> +	damon_for_each_scheme(siter, c) {
> +		if (siter == s)
> +			break;
> +		sidx++;
> +	}
> +	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
> +}
> +
>  static void kdamond_apply_schemes(struct damon_ctx *c)
>  {
>  	struct damon_target *t;
> @@ -2297,6 +2313,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  			(s->apply_interval_us ? s->apply_interval_us :
>  			 c->attrs.aggr_interval) / sample_interval;
>  		s->last_applied = NULL;
> +		damos_trace_stat(c, s);
>  	}
>  	mutex_unlock(&c->walk_control_lock);
>  }

