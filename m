Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F9FCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A18C6B0006; Mon, 24 Nov 2025 10:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079626B0010; Mon, 24 Nov 2025 10:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED10B6B002A; Mon, 24 Nov 2025 10:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7C436B0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:15:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83CABC02E9
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:15:09 +0000 (UTC)
X-FDA: 84145848738.10.6FD7B5C
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACDE5C001F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:15:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763997307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6EhJZJdW5iHOgf7cM76HxMq4qtuClKsaC2pJ2nzhbUs=;
	b=zPc7mxkiBj0tIJTW/JxjpdVyWdL9VSu+3cJLwxuii+RfHTPcn40jDhQLc2J/OIlG//bPuB
	mpbn5cuHuMULKXf7ZTxAjBtQnoQOXB6oeGHDbzyh+b3givF2do78QNtPZwU8yZSwMUZfXK
	J1OAau0br+YYtG+KlFU44RL+2Gowpbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763997307; a=rsa-sha256;
	cv=none;
	b=QBJdInJKGhcr+zcoXtBojx31TABYSAfB0SiOMHW8VZ+/fncDvC8Cpof644AvFOkEOiYUBd
	5wCnAIwY7jwpQP0DQJeOoBMz8Rv2tQhKUihpA4o+d/nsDvyB8Z3AzIBSSxz+MwZaJOA5Tq
	uTi3F0nTulTquNFhpnaS4QjUU8sQO1A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D7021305FE;
	Mon, 24 Nov 2025 15:15:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 916DB2001C;
	Mon, 24 Nov 2025 15:15:04 +0000 (UTC)
Date: Mon, 24 Nov 2025 10:15:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/12] mm/damon/core: add trace point for damos stat
 per apply interval
Message-ID: <20251124101545.0250445c@gandalf.local.home>
In-Reply-To: <20251123184329.85287-13-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
	<20251123184329.85287-13-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18mhiH+8yhU3rLNz0uC4XgLk5UTtfo2JA0=
X-HE-Meta: U2FsdGVkX1+nRZEW3e6XwJCJw6tJDlTKHwyHh7MykKmgcEJOcruyi41RFB+KBqDeklnJ8td/Dao+47YI27tMFW18xY7bwX7sLkzK1IIT689x9RsrYeGaP3UUFuTL04sSMlYXa+Ce41PehX79Q2WGOMbgNtPvvxOoMp44prXMClJZ/utaM5/rtQ+wkE6fnJrcCI9aEnee8FIgEtEENWxsH5teOKLh3CVKGD/PL3jKQqaWrRw7umcNDuXejN0GQqre+e1tsMIxI05twQiF+lCh0mdon2sr4k8AasnaZvGoSJwdgQPnGF5WkCU20LW7Ab7EQAjo9K9647YCoQYb7jX9ckSn+MjKVbGw
X-Stat-Signature: amgdopewak89z9b311nn95u1tetxutom
X-Rspam-User: 
X-Rspamd-Queue-Id: ACDE5C001F
X-Rspamd-Server: rspam10
X-HE-Tag-Orig: 1763997304-799272
X-HE-Tag: 1763997307-91139
X-HE-Meta: U2FsdGVkX1/mARTz4+aCE4d6+Es4/gyTHzyhe+d53/wv9bK6/tIJt/qcGrTMiAXBSFAr1NIB3VRG0C5B+7jsjXIiDycL6R0assRlMpmcDIp02CUAyObz9w53xSQqMEPzK+LFmkE+KjA27FBqdO7fB8UBIWMJcqyayT9AoxDftI/pntr50iW1PSu7Xz+sduNEtYagdCCXJDPxQ9lKltAjHKR48BP5WrtFEU6nylmfyX//vhsh7HH7hhwf06cdg0n7OFGDwpbatMzVqOoxFuVAfaZ/kxK95FExjW0POHygHCJgy4+9AQ0NQgU1Phx2h4tsKi0ouESErHUzQqO67yVgtEzOF4udRhohhyn/o0YERS909uyXkgrkcm5ADoJZKNAXL55oRv6RaWxTpsnRTPp+9p9kzut0oOQIu9hPiY566Y/PHCZitZHKmqgPXG+CL+xOqO4lFhwJHHntjKnt6vddJUHU/9Sq+7XIcaWR/KDgc5aW+6wJmccmC70WTHE5SBUHS1wr7LxYwI8rY8+jJpA2ytcvV9oeVKxf8YKFSoT97jRxm+XZKEtjrxv1GlIKIF9kwWhGohoO/nYfm34tJrBnFYHdTwctK+1PU+KxsydZB7L0VCE59B5rl/knlPnaJ0i5/kU9XzD+koJVXcdH9dFIgsfT8fcD/r8eTeh+cGl9v6G2otXJ+BwrjT4uNNFeMI8LLDzAovNZ6yKAFKgYmIGsN5dAi0tSvqcRjZ7NpKhx0x7yUI+2r3upPnDoedz8j6RXvnoSs5MV7qWri7JBPKib4f5MRH3d2+AFoUr4PRVJq99hJG2DnaeQRa1miGRLHonU72ixbPNS2KMZ9dioRw5S7CGt1WAl+2t8exaC4RZdvDzjvw5arMbcfKPwcijyENqxJ0w7A0aKONVoEcniImLflTFr0/KW4M3WK+ltGTkBW6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Nov 2025 10:43:26 -0800
SeongJae Park <sj@kernel.org> wrote:

> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2256,6 +2256,19 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	quota->min_score = score;
>  }
>  
> +static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
> +{
> +	unsigned int cidx = 0, sidx = 0;
> +	struct damos *siter;
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
> @@ -2294,6 +2307,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  			(s->apply_interval_us ? s->apply_interval_us :
>  			 c->attrs.aggr_interval) / sample_interval;
>  		s->last_applied = NULL;
> +		if (trace_damos_stat_after_apply_interval_enabled())
> +			damos_trace_stat(c, s);
>  	}
>  	mutex_unlock(&c->walk_control_lock);
>  }


I wonder if the above would look better (and still produce good assembly)
if it was:

static inline void damos_trace_stat(struct damon_ctx *c, struct damos *s)
{
	unsigned int cidx = 0, sidx = 0;
	struct damos *siter;

	if (!trace_damos_stat_after_apply_interval_enabled())
		return;

	damon_for_each_scheme(siter, c) {
		if (siter == s)
			break;
		sidx++;
	}
	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
}

static void kdamond_apply_schemes(struct damon_ctx *c)
{
	struct damon_target *t;
> @@ -2294,6 +2307,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
			(s->apply_interval_us ? s->apply_interval_us :
			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
		damos_trace_stat(c, s);
	}
	mutex_unlock(&c->walk_control_lock);
}


I have no real preference. I just think keeping the "if ()" statement out
of the main code as a more aesthetic look. But the above should be
equivalent in actual functionality.

-- Steve

