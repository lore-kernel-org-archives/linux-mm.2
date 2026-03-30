Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7911A1061B07
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00516B0095; Mon, 30 Mar 2026 11:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB11F6B0096; Mon, 30 Mar 2026 11:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEA06B0098; Mon, 30 Mar 2026 11:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEBC26B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:00:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82AD214058C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:00:30 +0000 (UTC)
X-FDA: 84603040620.18.A8DD257
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1197E140022
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:00:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxba+iSI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774882828; a=rsa-sha256;
	cv=none;
	b=fWLC/QLzQucQ/c73hyh6CjDJO2OnciKiLZnfFUHnrJrEBPn5Bu2pvbcKz7uM9o5XIxyFst
	mibSzolPdyskY1r8l9EiwDAgbhsW9IGhFKQfRSMCTrrgdD3bCFztNohWwSBEfBTfXs6BJu
	QO88XjjEj4KRE8MgUW9yJ2mXEgdqRIU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxba+iSI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774882828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYUU1KvU8lLb0i6Ow26Om7j+lc5VGCWK6zWWACZlhzI=;
	b=2vg3t9uBK+JRfaECdStSNXZhnPn+A6ZQHuKW/aHTIboYUP1aMYpSbOzj22ihwinpCRb8og
	8C8uqDTlzx4rCEykip/9Ec93qdQAERu9W0pzxyhgbEzBrkzhN/ir1iPuhYGYk65wKUT4EF
	4kTd9hJhgfP7QmF52UAKFIVbiGVpt3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34AFD600AE;
	Mon, 30 Mar 2026 15:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD4AC4CEF7;
	Mon, 30 Mar 2026 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882826;
	bh=ALCW94wbuSogxnAbtTw+nxjhUDLVX0cRyoDJHU2dn20=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dxba+iSISY7aFU2yWaJ9zsY2iRii8l9TgsJux0sFGh5ImuoDNY9Pw6dMlA6kKsxwB
	 CNx8ajzJlX3bT18xXFfCLDgd3XvubqCdyNPpFQvOsDdvhLVGlPjCxlLO/nvreiXoP2
	 HHYZhVDJV8KUkQxXentQIO+5nUyemfVbEZAm9PBSZpSSbgy1QCDJ15jFLnd+r8fmO/
	 ZIasr6HDHUq56pp4i4VpkpunGVeVNlV9hEFT7xMRs6BjOyAfnd3EY+TtexwkxnjxCc
	 TfU4lj81sWZ/+R6WdGEbZ3+K4u2G6V6Yc0lLZ+bnI2VNFKJ4wA8PD4gCDqsnT0nXpM
	 qObUQXgBwSd7Q==
Message-ID: <bc146b2b-8d34-466a-84e6-d49eac9b66cf@kernel.org>
Date: Mon, 30 Mar 2026 17:00:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall warning
Content-Language: en-US
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1197E140022
X-Stat-Signature: ip1oru339tgab44z3foxrytk7xht4784
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774882827-287352
X-HE-Meta: U2FsdGVkX18uQ06DTbMuac3lJNXWh8w66Z804RlmVGDNl8biB2SD8pHrr5hMTFLrJ1xpInpogDQSHIwgYGNriwZv0hEVM67jIgzR/BNYagdPyKb9Kuq16r5aTD9Zz/asA/xrTCiVgiFJBOp8WgdTp4TiT0J7ylTnpP9q4pA0NNXeBsn/CFJhliK4TlMMYSrEXE1kpYjxAlSql2JyHXauPF7ZNAcRR4OPkox6ZHittHHOJuxzQIg/Y40nzHiLImigjAAg+PkheZwav7JmhMz1XrW1m1DeXEeCVnQfDEA9mmPwgIm8VvU679guwbO3Z+xCrFp/psbcYD1VAzCbeSlQgbWDBUrnUM5UjgTwEunJ+AzaftBxBDw5I/VxsNTsaZC9CRSYP02INL76DRXi4Fn0c3ztQ5QOFfsdckAiA2fPfbISRqObh7YGCZnFQ193edb1qY8SEs+sCkJ2wxcROZoiN9Vb/WXwV7JEgHYckid6K50FyUEFYqBxLIrRZ35jPG/wkIvoKWZT/FJ9CUQr4Y8+YH2MfAgdK6HO1C7aSMFJe5qOw3q7PevKZKGMwXr4Xv1UwpUliaKETn6IfTvErIfs4yf0BxcmeNfGzukpNioVIKy90CLAc565azl5EVxj+VQtx23GeaEEa12pLLxp7rV8grzI1bnf8vcBE+hyMXk9XlQjsKLF6/g56FKa60hRA1ab4ySej/GAU0uScmOKEIWX70yFJXi0wiKTXlM8tOCT1sNgATZaOQ2rVhZHxOyiVTgQwdNbHcR0bVvD/I8NMk0+/tCzyoUI5r7/bYK3dZWJdcoCP1urzXq/lXoc+4x07gNvmpGD2GTOOxcBKdyPD/6giXxcnwTbxRykgpP59zwF5Us01/54WlxLVpf4MUvXal9lOfy05inJQiBl6IxO5vqhEj3Nozo9H0IZgBLX7J5fzZd3tGw2foFX+gWV4+nhteMwcdx3HqUKv4S6LTG5yBr
 J3lEv2kx
 Fel8izzgIr207qR7QMT9jJNH9YQX4ZJo5HshzelWDwwpi3uPI64juozUUkEKIt8yJpkzLPAQexwLv9yt+Ty3nVbFspOQbR3cIkCcLVu6hR0EpSFQhW0KhhsogysGj3I843gvUTvRVYBYTld7NGO9QZAZzG+LhAk0XNuH9Lymnyry0D0x6NC1Dldpmu7uKZuUcuUIw/6wbIvHzw+1U+2nkJOoIhuyYTHfhIrS23dW1hFZLymjy4Kr5IJyAHu32Kn3wxCJNu08M9CEbNRXplN0Qwy3eiHh7eTzOjkDfYQsVe2ZW1xecWmfxWECmyTqam790tfUxFDl7/2MU24Y3Vf/Scszv6Kb7ZqnzrGLe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 03:08, David Rientjes wrote:
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
> trigger given it is very passive, it will only be emitted when a page
> allocation takes longer than 10 seconds.  If it does trigger, this
> reveals an issue that should be fixed: a single page allocation should
> never loop for more than 10 seconds without oom killing to make memory
> available.
> 
> Unlike the original implementation, this implementation only reports
> stalls once for the system every 10 seconds.  Otherwise, many concurrent
> reclaimers could spam the kernel log unnecessarily.  Stalls are only
> reported when calling into direct reclaim.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit below:

> ---
>  mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -316,6 +316,14 @@ EXPORT_SYMBOL(nr_node_ids);
>  EXPORT_SYMBOL(nr_online_nodes);
>  #endif
>  
> +/*
> + * When page allocations stall for longer than a threshold,
> + * ALLOC_STALL_WARN_MSECS, leave a warning in the kernel log.  Only one warning
> + * will be printed during this duration for the entire system.
> + */
> +#define ALLOC_STALL_WARN_MSECS (10 * 1000UL)
> +static unsigned long alloc_stall_warn_jiffies;
> +
>  static bool page_contains_unaccepted(struct page *page, unsigned int order);
>  static bool cond_accept_memory(struct zone *zone, unsigned int order,
>  			       int alloc_flags);
> @@ -4706,6 +4714,40 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>  
> +static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +				unsigned int order, unsigned long alloc_start_time)
> +{
> +	static DEFINE_SPINLOCK(alloc_stall_lock);
> +	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
> +
> +	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
> +		return;
> +	if (time_before(jiffies, READ_ONCE(alloc_stall_warn_jiffies)))
> +		return;
> +	if (gfp_mask & __GFP_NOWARN)
> +		return;
> +
> +	if (!spin_trylock(&alloc_stall_lock))
> +		return;
> +
> +	if (time_after_eq(jiffies, alloc_stall_warn_jiffies)) {

This could also be an unlock+return if the opposite (time_before()) is true,
reducing the indentation for the actual warning code.

> +		WRITE_ONCE(alloc_stall_warn_jiffies,
> +			   jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
> +		spin_unlock(&alloc_stall_lock);
> +
> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
> +			nodemask_pr_args(nodemask));
> +		cpuset_print_current_mems_allowed();
> +		pr_cont("\n");
> +		dump_stack();
> +		warn_alloc_show_mem(gfp_mask, nodemask);
> +		return;
> +	}
> +
> +	spin_unlock(&alloc_stall_lock);
> +}
> +

