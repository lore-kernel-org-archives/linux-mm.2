Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0115FFF4933
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 03:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C016B0098; Sun, 29 Mar 2026 23:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6537B6B0099; Sun, 29 Mar 2026 23:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590FA6B009B; Sun, 29 Mar 2026 23:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4910F6B0098
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:17:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D994613B619
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:17:37 +0000 (UTC)
X-FDA: 84601269354.27.518542A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DC2F740011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:17:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1bk7XnxG;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774840656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPyaGyWA+pNSydeA8lwZ4hXFpTvqr5X8HbL4jLEApks=;
	b=lw4prtDstuNoZy10lCiEUhmVVHznGPFecFcBCOZf2rimyD0v/1UjPokDhDowoCNI3HAu8c
	beQnL7XCQkT8MRyKjnIsF3MJInbtFguuWQ/CMFcQY0iUrsKBCMm6rDy9g2IKN4aVK07RM7
	BVtzhDM/hL8qC8nGImYe7FBViASp5Mg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1bk7XnxG;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774840656; a=rsa-sha256;
	cv=none;
	b=hYf5Eaz4TNgf2LWsqqpfbCw3/kz/QymJsDOEdyptqeHcixThRKZ3eUxc7nJ9morG+qYQKT
	RHh4HwJ8jBF24m4R/evIAQBQ6XElU5Y3UJu34weUmvt8kgIB8QzibY1zaA+N6e3pDCEdFG
	XaQLhgjiTZGCFglVfeyXZReAJ2UEAmw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B03AE43DCF;
	Mon, 30 Mar 2026 03:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EADFC116C6;
	Mon, 30 Mar 2026 03:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774840654;
	bh=leCGs2E2/RYWvyxtjIdMHYtCcR5huYLaLndiJf5ULzs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1bk7XnxGiZBM4qXQX8H4y4Uggw4oKnzOUa5CWw4GSnkRwZrp/KsrsbRJiyv1bNvOF
	 VRlvL10CW/oVS9fJU7CWkJqdrBZFk1q+ws1HooWh+Ppuj+JP8jJN5y8QujkesbFQiU
	 aGbjpVbhyxr1w5OhDzpa8mPSU1XLe9T/6FYvQUNA=
Date: Sun, 29 Mar 2026 20:17:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall
 warning
Message-Id: <20260329201733.6a4647ade4751e761034b9b9@linux-foundation.org>
In-Reply-To: <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
	<231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DC2F740011
X-Stat-Signature: w7hiz6it8qrdfs3rx8k3rffzp7sfea1h
X-Rspamd-Server: rspam06
X-HE-Tag: 1774840655-16832
X-HE-Meta: U2FsdGVkX191rGDFfzcmKkMH4dhOnTbQUXX4z1Ux9AEvIZUvEu/vAlduTaV/gla2G+FfQhjtzNFQB1BYFdA2yKgOXZQGmADgrrAIauupUcYr3lgPnbz7uxZz+HtH9oQ6xBu20zzTB5lo/x7przLiBgOFwh3dGGC0XPCeG5x0L689XKTTdXq3YcIAykMxiSYyy/RUqRxtXwFJPHxVHzQaovJm8CxPZUlcQQXUuvyO2VdWsh/+GF3rpn7DhHaakhiacf7hEVHZ/Y3A7PIdlTToNyBoEWcoP1uORoauudR2yipK15m+a61IUevbm1NJyHJ28X/1dQNBDOb3AXnBqyJYP63SlOjbInlhDP8kr3FFw7ANPqlxvRykm0cfWcBOQvZgPkdd0V/lVbfm78X+rQmrJX3AD78V5qxT0dyccJLLtS4VCQoWlFdmTMJWdZqfPIWQvcY/4wQpvT1PrYYACViSMR4FzyZginof+glFkfYw1FBRGgUFFcyF1/0EkGam6n9HgNHxgfeL1MoELsiHI71xEPYM+UObSwwr8sNvwJ2znNZgKKITnDlY1XwvBU58B4gwJQBYrw7GOcfnc6h8PQ0P3xWZOMaZnESwFVe/OdXAVw+pf6ssVEzlkCCG2Q6fnkAY9a0O34zB1o8O4JmgRSnQG6dhCRUtGVIShW0uIAM4CU3VMMpfx6u6CG7KyXDvpY0FsBApshfZsvM8jLZViBWVCksU6P7BkSldECKxw68phwMpaoYpxGn/4TfcJIjr9W8LWwpwILtNuxYXW7f11h5c1CjaTn7HNKrOgrN5btjF1AmQIGlVe6AxCsGY0K1xztMr6AvU3g4y8Rt/YteZACI7tJhpo2a6HTb2LO/Cw0aM8dX4OF8HpvimZF6P15+gJw2h0Fdrrtb3TO6EPYguee3jk27l/f0ATYyMTC2JTDq7LblZ2VYFsC4DJu5ksex32YGvNvIRtU5OQXe7Fh24VPi
 2JSYGztN
 ZDUa52ji0h1ZBoT6OYIATIB0qXpgppXCnA4bNeJfbCciBOMvnW0XheQP++QOkTJNPkAo0ilLJE8ELMWYcskzqGuV49uof0BVlN/oaOzH/3dA5RVIkkbAjjWluWWkxDpbGvF/RuEPZRMi4F6Jr0LzfXli+aaspkunlisREgd3Wmqah0TtMi1rnGb5HTaG+o88tPXIp29IrrXy6bZBSLTicpfGm3Qfr8Dld3JfODa3Cx10AY1pmezKx3VXAjA6JEYPZUzkEtNYhEI0AiETz7lAqVwFqSWiCQpupzQdIle5SSpO53sI3K14HeiELAqQdhPZqStRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 18:08:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

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
> ...
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
> +		WRITE_ONCE(alloc_stall_warn_jiffies,
> +			   jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
> +		spin_unlock(&alloc_stall_lock);
> +
> +		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
> +			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
> +			nodemask_pr_args(nodemask));

Snould we use dump_page() in here?  It prints more info, does the
snapshotting thing.

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


