Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B92C9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 03:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68C86B0005; Fri, 16 Jan 2026 22:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D163E6B0088; Fri, 16 Jan 2026 22:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C225F6B0089; Fri, 16 Jan 2026 22:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAE116B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:15:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AC1F58436
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:15:52 +0000 (UTC)
X-FDA: 84339991344.05.F0071E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5ECBB1C0002
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:15:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BVfXgtUB;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768619750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8muqpblyb9wBHPxtgUcyGu6MsHvGVYNBs28LVydPIU=;
	b=tbgAVRbpdgQo9yZjF/+5ivwml6fYMPcLrUuf3RxRotWGYjDNTsOWamjFDqpzfjo1M10/5O
	VX1EKrwwB06Y8ph8A9STq3kGcxQ/C9jtOS91ljtTWawdf5982JpXCNdpJrb0gvF+Zs1g9u
	PFQ7MMka8bS29Ddte23XUA2u0TqBc38=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BVfXgtUB;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768619750; a=rsa-sha256;
	cv=none;
	b=Yqy6PnVQrTdpyoKBetwJUjQheCjAaaKV/UX5xx4RpL6QyUp4RfHXbQA2mMAax6z8RBOnXp
	Wnxqv8X/LkdRXwf5xEmw/8EHVzx/e3S8L8lSR1yORU7+gqp9iPCHEOAwgVOqpgVJIkLFs3
	jIfDwk54tCiF7qC0xRahzNIt7A3FkIs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09CD4418B0;
	Sat, 17 Jan 2026 03:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8721C4CEF7;
	Sat, 17 Jan 2026 03:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619748;
	bh=AEuJsBZga2sgQ+YUwrhip4kmR5jp2K/1ez8pEZNQrrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BVfXgtUB5tysAneIN4Zzd6wIPIyNQu4pnN56U+tajD4nhDBBMhmTbCliACzR62xm4
	 E6JmCg7a84DEOdSiQRrqlDSz1ucw2pMDCtY3XxE+9eFQi06BMEXGjmUAadgUQ2qgQs
	 fFF8p8rm0iTtJCxOg29SKShvO6myIcGfCRmWY7Kw=
Date: Fri, 16 Jan 2026 19:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Chris Mason
 <clm@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] percpu: add basic double free check
Message-Id: <20260116191548.7df814c2a9eea1a9fa3c4cb5@linux-foundation.org>
In-Reply-To: <20260116023216.14515-1-dennis@kernel.org>
References: <20260116023216.14515-1-dennis@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6s91xdp4i3zmn4yrr4qmxgcrx6s8zbf6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ECBB1C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768619750-961339
X-HE-Meta: U2FsdGVkX1/GCt+9O1G9kgC6payFXc5Z+7OqK0wtAbhk6y73h4WX7Qm2vnrty1GAANzSqMSNmM9w3zRDEIrfu+mjwATA8KkJxe38Cj+pZw49sc6O/LpjRWGy8a2lnMDX0tSHxI8m9aXH/S2Lp5P4xJ5sHLU0weyo59BvbT8FUTOGajdNhZWe2RqjWbRuLkd2NKHrD5ta+dRug7Oi3/7bn4/0q7khykx6+Jdx0PYIG72bKF2UTVsSqb2cnodKGhlAKXI0/GaJo/Y4oGHvDqeD17gg4FE/nj+YmLzrBXPWzyomaT6TNtD46plOQaaPLF3IGwmFuK+5YycPG/uTqU9G/g5825dhYxvQEQmA3Cknz5LX0PNBCLxQ/hP2Jmr5SbEIbgxA8Awb1FdbyzgGUL+ChT72r69DoSJ93b3mvR831d2OsfQpz24AT0QzSfGvK8KKQJIVxxp7vQUqKjNe1kjoKbJ58EJ5qoPhnL0d1WbzynmtO4+K2iDyhufXFe4z/vwu8bE6SSuAzZQ9WoVMLd6ZmgzhDf6BgVkKUUNasHRw584iPdFlo9SrIQixldGoB3QyqGyOf6X/E7kfQzlkgvMceRg/4rw9Ed9wbBxlPnxjx4QVi9EoNCaMxPnzMZaSXmMzgmT+GWSx1zJtIL+ITlGZhf5YskfrKIlT2BPY+cZiNhGmKMYa/0bJLBK2kavRW8NjRlOmjRZjGB5nsWyTk262GK1FR23LFdvzV9L+fTwOCIXb2vBBF7RoAX0e04V4NJKBmo8ZGLIncGscNf4eTC3b5Yjk5054KMxQXAX+WtqOmwUGGEMltbajUyEKRpB7FZraCCHPjz/dhCnawIaKatYa3wxXe8EgH2kRpMAZkoeyts+2mizw7cla0GoXy5UKJf/T5zcezkOIE7/dsu8Ur9KK9PdCXVNfkYOoRgWfk86UVcvZv501YPQv+05HPCv/O2WTpUVv0QnIewhzq5pHIiI
 B611hpkH
 nwGLtpw0an1eaTTXmsICZxaxBTcOPNq97KkorFjt09TSrG6aJSgDsPhFQCzXGK6OMrlZrNxuZLbp0HpST/A75dnqbjdRICQkAxiNHCIduB4K6JWf0QEuoloyelCM06GHE5ic7kkP8ljpwqb23HAmvYQur0+uh2JpTPKZSvhzOjWQG8lK46rk8gu+9BelSh9KHKT7BuHBdKnumboZqEOXe7SQoTLQjA0C8s+w63RPzBA9d2YUt9Zc421O6O5UxzqW+HEf42Rpj7czqDJP3YikPdX6Zmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 18:32:16 -0800 Dennis Zhou <dennis@kernel.org> wrote:

> This adds a basic double free check by validating the first bit of the
> allocation in alloc_map and bound_map are set. If the alloc_map bit is
> not set, then this means the area is currently unallocated. If the
> bound_map bit is not set, then we are not freeing from the beginning of
> the allocation.
> 
> This is a respin of [1] adding the requested changes from me and
> Christoph.
> 
> ...
>
> @@ -1276,18 +1277,24 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
>  static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>  {
>  	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
> +	int region_bits = pcpu_chunk_map_bits(chunk);
>  	int bit_off, bits, end, oslot, freed;
>  
>  	lockdep_assert_held(&pcpu_lock);
> -	pcpu_stats_area_dealloc(chunk);
>  
>  	oslot = pcpu_chunk_slot(chunk);
>  
>  	bit_off = off / PCPU_MIN_ALLOC_SIZE;
> +	if (unlikely(bit_off < 0 || bit_off >= region_bits))
> +		return 0;

This (which looks sensible) wasn't changelogged?

> @@ -2242,6 +2252,13 @@ void free_percpu(void __percpu *ptr)
>  
>  	spin_lock_irqsave(&pcpu_lock, flags);
>  	size = pcpu_free_area(chunk, off);
> +	if (size == 0) {
> +		spin_unlock_irqrestore(&pcpu_lock, flags);
> +
> +		if (__ratelimit(&_rs))
> +			WARN(1, "percpu double free or bad ptr\n");

Is ratelimiting really needed?  A WARN_ON_ONCE is enough to tell people
that this kernel is wrecked?

> +		return;
> +	}

The patch does appear to do that which it set out to do.  But do we
want to do it?  Is there a history of callers double-freeing percpu
memory?  Was there some bug which would have been more rapidly and
easily solved had this change been in place?


