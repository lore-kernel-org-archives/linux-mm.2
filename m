Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA8E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iB0RPjE+
Received: by kanga.kvack.org (Postfix)
	id CA3556B0A49; Wed, 25 Nov 2026 10:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54806B0A4B; Wed, 25 Nov 2026 10:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A716B0A4C; Wed, 25 Nov 2026 10:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4D76B0A49
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:13:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E9C3C0F4D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:13:10 +0000 (UTC)
X-FDA: 85473984540.29.437A397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 46294100012
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:13:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB0RPjE+;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795619588;
	b=Ncp/O3wghKFWdgjhs0ogSEUt1pKstaraDH7u2VY0+XfFW/pveVFNkQZq0hj/wpRsH7TTr3
	9v7bzey5ivO7B9cwb4TQG4nA+asUm9f1r1dPO1ASi04SahW1a1GXQ5hwqeO5w/ADTvfMUy
	2mbs3PibWuEFkBEjvypPolvEuy74qOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795619588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grCglpvS1lmgRAOWz2fgR+PrAXF3N9/tLLxd6ICUxy4=;
	b=QVCR897ZE2iqMFwGIZJ7zpZ0tYGAv21idR1ajhcg8Ha+a893TqP2XjRq8eDQiQVXudAOLR
	6c/qoQrAd7duJG7INmlUuAz6lw7y0FsL1Pls0R0uKqYEXGhFWu92xbqjhEwKpFKBVxPkxy
	jQHzYgnndte5mJRHVuaSO3Edak2SX3U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB0RPjE+;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80B6843639;
	Wed, 25 Nov 2026 15:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61781F000CA;
	Wed, 25 Nov 2026 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619587;
	bh=grCglpvS1lmgRAOWz2fgR+PrAXF3N9/tLLxd6ICUxy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iB0RPjE++rgwjZ78MftirKMEilvmJDSVplUkjMjsFliZsNlVhz6LHbMtmfxYfW/Nj
	 F2kcGN3/AuXODAtuxNeGHGbdpk+63bx44lMEcnrQNBIKjqpf6iSzOl1YqdnVUEGetn
	 OKiqemMdcV7N4q8ABQ0nDKD79HzpSNSW9fOsBTNectISbm/KEHpcSl1czMhDqGCoJS
	 X+CupyitUx2Bnea12XiUCZbF2o0D650hluaLFO2B/OPwUsgi85tLRbLy6/px3fo4Id
	 HuRQ9/IqTVAaYq1e6Y9lQCnayy6qWKMjYSDk2p5GA2nqdjVMfOp4ExBIn4kJfauyN5
	 a9HmxBEOgmsmQ==
Date: Wed, 25 Nov 2026 15:13:05 +0000
From: Harry Yoo <harry@kernel.org>
To: Takuo Koguchi <takuo.koguchi@gmail.com>
Cc: cip-dev@lists.cip-project.org, Steven Rostedt <rostedt@goodmis.org>, 
	Takuo Koguchi <takuo.koguchi.sw@hitachi.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] memcontrol: protect drain_local_stock() with
 get_cpu_var()
Message-ID: <awb6bJ1-_8zeyTYQ@thinkstation>
References: <20261125043900.3618611-1-takuo.koguchi.sw@hitachi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125043900.3618611-1-takuo.koguchi.sw@hitachi.com>
X-Rspam-User:
X-Rspamd-Queue-Id: 46294100012
X-Stat-Signature: wdg45nywraf8yd7urz6wih4pds9gzkg8
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795619588-852767
X-HE-Meta: U2FsdGVkX198s7eiTeHxsBoBehFCan5+eOkTnIXgsK+rpksoasLBXPx7nlCJAVbzMTXmWs+uWdcM9+C0ZajKaxXaDdvOuyI+lj0jWNtav4HcTEJdJ9FhyZz+PvdyXLhMQ501ihdfVfqywtNosG83+/tXF0VjV8deaMsz7Lhs48J7VR8aRyT5DqkpkyWiqZvSA6zhvDrlq6wsvtWVOLH/DjLT6IKeGGI59lccJrMs4S8ezyGa/xi2QSPBFWEJZRDYNZXLxvkhuAwBsy7sqiM2dyrrsuNqK2EDTsKoNqhw47nYqbHsdGHR6LrH3aKQVuNrJRqnHwEbN2/yMvUIDe+HTS858w2lp8El1J1sahJ3hT61+3vJA1xly4uTJPSWLCjpeD8uX3IiYsr2bRd+/IAw3YiGgXkOJBbdyfK96TkCftf3356T+niTPawf+EUEMtFy7V7V9SVJOx4hG6SWNqEdy38D4FT3HjxU1+PG8ip/rXxcCyloGm8mVqm4VOkjQrR7vVvoSUobWGrBscNtUChJ7kYt23Z1e5VlWj2XHNxSGu7kLc3Vqv1dGkX3FcsxKzkjScH2bRZG+rOhCFWfbpUIQ3SlDMx+mGQpZxa5fsMGoRqJEA893YbUv7r4W3ZF//j70W7p7stlSqbFCbpGp4mJ8ajpMujXbhG9OhWqPKdDiz724AvxtYRj9ILWTR9YVnYFzDObul/MBf12Cn6Jga4zsG4vQsaOepM+caPoOfdi2kBCWrG5TLT9EaoPkQQ+OLVCBaIBvQCct5Ng+kNMzmcS03KN5rScT9ajwfb8PuS4SuNh/0mN6I0NyCRsXSXtsHFb21dFu0A35CJUfn0fjTSorx/fcmTGfMgLO+4CF4WzHfaMHFcN/jPEg1ThjqS3tBG94vPego+ArdH0TJ/bfbnlnOGT0fqqFe3sJ1yqAtNGdHueki09LMMlCT1Igbjc6OgSCeUu92+5g2Zq1/qPj5O
 K9M5ZRxk
 JMRCZQkfdKtf0K65fiBpz/mD/k+rInPFeRTZNjVv5LvUAn+XPCSSIvWbZfGPwZ8OKLzNscuvFSNhPm3lA6Cevpzcn0oQqiwnsC4OnzMELS91bnAkMdP/9ALD9Xj6wohpgKfdtGX2t6yqQt4sgiZ0221oV3xbyHl7rtAXZjkPGf1W5Cv8M16tQIFSxnWXTIiMDIR4sC6MQ2+baHdr2yrMUAy2CNEbf9dmfW670YYgJkdw90qJTHtB2JWg2YzNX6XCo5IueHWNUnYzQpFrE3gvNwG3xBLnGQRbOf0rq3n9+e6ERMYVxQq8w6rwDcuei6W3e2YiToLvIc+dYTPS9cLvXtGuuLvzKuw15ev2L5i+47q5jc67BB3rIDHO8smoK23ahM1iS9vTf//zAslCmJqXbZzq9F6rIFqOLQXi7Q+KIZChS+ZqgCtKFCirbv6BFkCP4EWAHFYnCpcnJE+DHst01JFfJ1bRHlth9EY6yC3s87J6IwAiSsrZ7ORzfrWlwCHXj8B9NLkY1LBsoSLBphhwclHlDE0xWf12+jQemS5Eo6Ie8PJaAoc97ShyQ6s6mNychdRaU85vM6c11acn4FWGVV/EQizBJ7ITNgeXx9Bv5UCrd47DtESMT9Ygzjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[+Cc PREEMPT_RT and MEMCG folks properly ]

This doesn't look like a patch for the latest mainline.
Which kernel version is it based onto?

On Wed, Nov 25, 2026 at 01:39:00PM +0900, Takuo Koguchi wrote:
> On PREEMPT_RT, drain_local_stock() accesses the per-cpu memcg_stock
> via this_cpu_ptr() without disabling preemption.
>
> Accesses to memcg_stock from consume_stock() and refill_stock() are
> already serialized using get_cpu_var()/put_cpu_var(). However,
> drain_local_stock() still accesses the same per-cpu state without
> equivalent protection.
> 
> As a result, drain_local_stock() may be preempted while operating on
> memcg_stock, allowing another task running on the same CPU to observe
> or modify the same per-cpu stock concurrently. This may result in
> inconsistent updates of cached charges and stock counts.
> 
> Failures were observed as divergence between memcg accounting and
> actual memory consumption. The divergence occurred in both positive
> and negative directions, indicating corruption of accounting state
> rather than a simple charge leak.
> 
> Under stress testing, the accounting divergence was reproducible and
> was frequently accompanied by oops storms. Protecting
> drain_local_stock() with get_cpu_var()/put_cpu_var() eliminated the
> accounting divergence and the associated stability issues.
> 
> Use get_cpu_var()/put_cpu_var() in drain_local_stock() to serialize
> accesses to the per-cpu memcg stock and make its protection consistent
> with the other memcg stock users.
> 
> Signed-off-by: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>
> ---
>  mm/memcontrol.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f9d80952723c..9b298ce10a7a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1933,14 +1933,21 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  }
>  
>  /*
> - * This must be called under preempt disabled or must be called by
> - * a thread which is pinned to local cpu.
> + * Drain this cpu's stock.  Called directly by drain_all_stock() for the
> + * local cpu and as a work item for the other cpus.  Preemption is
> + * disabled here because neither caller guarantees it on PREEMPT_RT:
> + * drain_all_stock() only holds get_cpu_light(), which is a plain
> + * barrier() without CONFIG_SMP, and the work item runs in a preemptible
> + * kworker.  consume_stock() and refill_stock() run with preemption
> + * disabled, so this keeps every user of the per-cpu stock serialized.
>   */
>  static void drain_local_stock(struct work_struct *dummy)
>  {
> -	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> +	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
> +
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
> +	put_cpu_var(memcg_stock);
>  }
>  
>  /*
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon

