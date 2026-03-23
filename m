Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2070CF4612A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A366B0092; Mon, 23 Mar 2026 10:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB426B0093; Mon, 23 Mar 2026 10:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5008B6B0095; Mon, 23 Mar 2026 10:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 415A36B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:24:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0A67160B3E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:24:52 +0000 (UTC)
X-FDA: 84577549224.16.B4DD14D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4B78114000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:24:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nc2xbqHk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774275891; a=rsa-sha256;
	cv=none;
	b=x9/YDvOFwjQQNygQFBNf0tDN8d2hJnPkhfWKW8uXlNRTlUs7J0LCaClYHnflVjM3HIzvTH
	11VvpnLnwKUL8nKc5cFYrGmfCEphL3vfJjTjgzX1nJZHwJqO/J9TEQ8SfObfau/BMzIOtM
	9j9pqUY1FZJ/wdC72psmjSCaUhUyTz0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nc2xbqHk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0T0sgKP5o8IPZNV/l+zSJvLFCO8tfRrBsb859TcLf0A=;
	b=tuhTri8logBlpsAX3/4jBP/2Licx3Tpexj9T9zChYFpGs35GYx7qhNfYQADDrgSLPemkxv
	3YDmwDG2UhKAVf59PfkiCPq7qLWDg1X+xAhLKLjTf9PRJbu4DyRf1kS87Okrsow6xmaGKm
	+nMw0FHbOtXrzY+MEVJ05qNrU8QenA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8E346013A;
	Mon, 23 Mar 2026 14:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165FC2BCB3;
	Mon, 23 Mar 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275890;
	bh=rTqgpDnt0qQkQ9guIM0ry/510C08X23SWvqG4dhtjcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nc2xbqHki8lYHqbiGG1zpRlQULbvR/jTCM+o7ZbtdqOWE3Y+KX0lHC+TuDg0BiRRL
	 S22zdohVSX7SmKljYangFO8cK8KodjbKEdFBA5k8ZWHmLdcWwCOntxoOCYaJwWYcH2
	 QtZLa3GdEIfc6wn6UyJJBmfxgMHlj9gST5SJIm5mTaGR+gSoXvulWbl7M9QH7qZVtR
	 p96ka1U64DYCnbOwbq9tZ8eox5tKNPc3HGHZxuRDn0MroITCUGpBjlvsMWfr8lUviQ
	 pldwGUMEScD+3Ywxtsmcj+blom93pOzGY9xaI6X5lQw+2VeK3MO+MEEMDIEYDHPDeN
	 eH0a3WCsx36SQ==
Message-ID: <c635acc2-d41b-4f7d-8244-75a117721da3@kernel.org>
Date: Mon, 23 Mar 2026 15:24:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall warning
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B78114000E
X-Stat-Signature: wceo1webi7i9thgn1md9ixgjntwddr9m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774275891-897833
X-HE-Meta: U2FsdGVkX191d48mp9rAQgegzuMLgkfyDtwsv3EYK6S0LdFl5I3xtsWawTFvmgWUjcHI8QT1r7Y1VXc1V0UvPcO+e9dH7BmCIezIwOaLCT+4XFObvjbjDrVF1JHoSrcDOBvKT1IuGEmUWiDvWFLJESchL4RdMaO2kclw0QHPAPkYH+kig7V4MH9BjwtwvbuCVYJRKUs0a949BukoHi4x2Vn3qlPPp2steDdmr6tAW/XfXQXGCo5m/GBMTwbPaC6u6d5iwQ01TtnkSTwinDplRz2MqaMsioj6XJ/REcgpXKIlTSnk4sVYQ8K3IbsgaPYZhz5OkVy5wbu6rUT0X8m/KSs06ySv4Uz/XvM0XlFrJFp9gwEiIZhyb2xWDW/nHJG4p5x2cEdbviDJ5ZeNGZ57KDPjvK0AeZcZV7t+VUR0jNeVf9LJEM+HK39jgbyoVlyGzQAjCeKO8UoV9gymDDXRk7Uas3+RlkrJvygYvmpJ5m9tFuCsysKsiRki7580pVJHzW3L21lrSWyiX35l/5LgOR3oMa3MjiS937tKr+NsQdvpTqMVmnCDvg2WqyPgduUzNn91pkcrnrVYSjSRV6u38MloH/A2WRgTtPLztK94iOriCU3GaM4F37IrTiC76750WmPLDJtcW0YRwP4irqxV06QqhH2U8Zwnp42paKBlS/MYUfcVqwewDjt8AKyrQxQvEPj9euHfY4Msj/Ye7bJCMVnGxeWMV9DDMujLT639ZNh6Jo53k0H+fywrJmt+xcGShC2UuuFjc4YTPG9feVuI1qT798buaf0sjVH6HDx1g0F0aaxb0acRvLz2Q0mf+AjW4yB9gnUpkXJ6SauuMb086HEVJfsAoSiS4kzhu59ws+5jZT7KPGAxvDqJncsa9EO7g2KtVYXVMMC6n3KWG5uYade327RhOZXHXLRHNTBZJNJQSKUdKSc84r91HK+N/NZa9kKL9cljwkiY/Mf+e/m
 qEuoKh25
 tVVfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/22/26 4:03 AM, David Rientjes wrote:
> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") but for reasons
> unrelated to the warning itself.
> 
> Page allocation stalls in excess of 10 seconds are always useful to debug
> because they can result in severe userspace unresponsiveness.  Adding
> this artifact can be used to correlate with userspace going out to lunch
> and to understand the state of memory at the time.
> 
> There should be a reasonable expectation that this warning will never
> trigger given it is very passive, it starts with a 10 second floor to
> begin with.  If it does trigger, this reveals an issue that should be
> fixed: a single page allocation should never loop for more than 10
> seconds without oom killing to make memory available.
> 
> Unlike the original implementation, this implementation only reports
> stalls that are at least a second longer than the longest stall reported
> thus far.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

I think, why not, if it's useful and we can reintroduce it without the
issues it had.
Maybe instead of requiring the stall time to increase by a second, we
could just limit the stall reports to once per 10 second. If there are
multiple ones in progress, one of them will win that report slot
randomly. This would also cover a stall that's so long it reports itself
multiple times (as in the original commit).

> ---
>  mm/page_alloc.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4706,6 +4706,36 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>  
> +static unsigned long max_alloc_stall_warn_msecs = 10 * 1000L;
> +
> +static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +				   unsigned int order, unsigned long alloc_start_time)
> +{
> +	static DEFINE_SPINLOCK(max_alloc_stall_lock);
> +	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
> +	unsigned long flags;
> +
> +	if (likely(stall_msecs <= READ_ONCE(max_alloc_stall_warn_msecs)))
> +		return;

This check without lock is while I'm not worried about calling this
liberally (as you discuss in your self-reply).

> +	if (gfp_mask & __GFP_NOWARN)
> +		return;
> +
> +	spin_lock_irqsave(&max_alloc_stall_lock, flags);

This could make parallel stallers spin for no good reason while one that
has the lock is printing. I think we could use trylock here, and if it
fails, do nothing. Then it also shouldn't be necessary to disable irqs.

> +	if (stall_msecs > max_alloc_stall_warn_msecs) {
> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
> +			nodemask_pr_args(nodemask));
> +		cpuset_print_current_mems_allowed();
> +		pr_cont("\n");
> +		dump_stack();
> +		warn_alloc_show_mem(gfp_mask, nodemask);
> +
> +		/* Only print future stalls that are more than a second longer */
> +		WRITE_ONCE(max_alloc_stall_warn_msecs, stall_msecs + MSEC_PER_SEC);
> +	}
> +	spin_unlock_irqrestore(&max_alloc_stall_lock, flags);
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
> @@ -4726,6 +4756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  	bool compact_first = false;
>  	bool can_retry_reserves = true;
> +	unsigned long alloc_start_time = jiffies;
>  
>  	if (unlikely(nofail)) {
>  		/*
> @@ -4990,6 +5021,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);

But placed here it defeats the purpose to some extent, no? We'll only
learn about a stall that ended. With the shared 10s rate-limit, we
should be able to do it in the repeat loop for stalls in progress, as
the original commit did.

>  	return page;
>  }
>  


