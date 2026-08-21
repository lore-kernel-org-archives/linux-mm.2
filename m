Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAE4C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B136B0095; Fri, 21 Aug 2026 10:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972726B009B; Fri, 21 Aug 2026 10:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862136B009F; Fri, 21 Aug 2026 10:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C75F6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:18:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C61DB140150
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:18:30 +0000 (UTC)
X-FDA: 85125481980.16.C3A1E9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 12C7740006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:18:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7kjw09V;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCzpH+AkCY0aeIXoDOfaDvPOR2Q5CwIwfkAmh6a+U3A=;
	b=h+zfEnkv8X0YPLsmMquXKEGHXKNfD5z+GLGK5W4y+ffnKwWesTux3/qhRQF7J5hJl0EZOn
	DXuFNt4+m9PWAINFjrUG+M7F+KZE2BxRO/7G2mmiaOYp9iMC/aWYrrFkBy273CeuI/W/4r
	27kgSM8AsGHQBSfrKE8Qf9dvwXeBJ1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321909;
	b=fCCxtkTl0gOsxgwQFrq8QAn9nXFxyA8IyMeXmMKQyuc5eFGz1eQdO+WOKSCQa96PwNM7dH
	NQuB77jRXKCjLV16MGrwBVeVabjbdsVt04PMwm8kIh0r/mFEllX0+8FXCHj7DOPGzKkIyG
	ku6w3/f9HpuXz7MoNS9pqTQT8hiz4Dk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7kjw09V;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EE856001D;
	Fri, 21 Aug 2026 14:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F71F000E9;
	Fri, 21 Aug 2026 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787321908;
	bh=GCzpH+AkCY0aeIXoDOfaDvPOR2Q5CwIwfkAmh6a+U3A=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=L7kjw09VgZa7fNcZgNUg45LTk4MaCo7uJlNzZyYyGZoptUJTMEMqkd59WinlTzTab
	 a2rH/NDJUMr8KNppsYDuNXhpQXNkP4gns6May87olh1mnEhRPOPhfqo3IhcgR5j8Nd
	 k7IU2HBwGcyJXEzXboUYXxOfQM8zkaca1r6DWZugDFxgcrQ67gwDku/tlB88i/sUpI
	 dHnGyH0TmiLA/Q0uVJZftozjtk62ZbhFOxGSbCHXMYfWEhdLaK3cZMbF4syKc67Bq4
	 RGoxDkLU60YT9DvWKukOdkwbaqK60n8uSpejwEhJsdTo1AECVidsGwXcz07K5aka5O
	 qkQ+/iESsp6Xg==
Message-ID: <06f5eea7-c6e7-49ed-8f45-0c6c86a04c26@kernel.org>
Date: Fri, 21 Aug 2026 16:18:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
To: Ferran Duarri <ferran.duarri@me.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260820190825.221308-1-ferran.duarri@me.com>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260820190825.221308-1-ferran.duarri@me.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: uyzwn47p9oq6td85si6r97ffhrnuqufb
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12C7740006
X-HE-Tag: 1787321908-838124
X-HE-Meta: U2FsdGVkX19MQyB4Ts61IsAs2ARye8paivPSyE1OStbfZs+nj3JqjZ8lD1QTIXdxHVsaKIUef/TQszEDqxC7jz0tmFeD5YmCOpWF53c1XTjnRqKGnb9Y43ezJ03WkX9dVqbVVnaLG4lbyq+Ol28rnRKGrwev2d43pVTsbW1vvLcrXu/zuO2VdNriQA/aUVO9/slKj5J/CcICM6ulPTaMkDgwnuX8KVZOTp/LdDuB4Frp41p+UcxEvM2FO1vPx7IhU/gyKYbLTVJ/IZEH6u8sEJYH6wzWcHhUrLQNQ39PxYVpDLUixet3r1bUYJ2MMJweOdxJRFl3n0YUjuCjjhHsZKR9LXnmYrzlw12fUoiZdzCpV+F2IinjR6dEj+lyxWqVXg3zemId0+YF6T87lfrxN7goNL3Sk2M/xyxRRirvZmiqn1cnuD/FcICgzJmoc68gAeOJt8KmhFRXAOXPadDoEKieP3yZNdHK2K98epBpXLgEpTDR9s6KHau9f6qJeKx2dvbCB1dVPIHyKh+Rw00Y738zf5QB6zeNCFOAE0tqSjoqpa50QrEBugafkSHiakcHgIqj52X05ZUaECeFMV2VFPpZVVg6BuWNnhYaNtWNAYKSRcCa9HYoP4cVEfT99UKY4o2C/r8M2vMCVbAgXce9j4RphRCM2hHxydV3skB8CrfNRRMdHdaiGVWwvKV+hGM4zAri2DKOlh1ZHYBEnWnO2kN98LYFlwey8abYSE9qyr+mP6hjaY9NpDVBPzaNZDMvBDZHfaeGf5oAaFJNjL0e24K5BxBQcto/xyJdrgRV1wC4zB80BVbUHyixZiCL0ZwxrLjVNF0KYVKV5EpJtMKvXGpWYmpXIymbJWYbqR0vH0UG0I+0cJ/aANXpPhr5LRiEbyZ8JqSJMXcrIcmhwFM+KYPljN5r/+9BvbHqwT4UaYWK9qJ5s8H7u1TZxvQ4KjKgoQXefClI7+N8UCcNJ8I
 HV1N4yAk
 Y5PalsMAKJt7cGIZISXQasmlfe4lNyYV+CdYbz1EbNASWv5p7m4SxGvdJ3tmivuBvktDn0C6lXl0yIN2T8pr90h6RSxpc0v4AU4ty3J9/Kba7QIOb/q5D71mpgwvTTXomikO5UCqik6B8UABUvQsk2KZKv+SWyqBi7n3qVzjh4JhG7qYR9S9rXsVUZVgsfoN7G1uceuEfMDYAz4ipuY95UEaCPdl3wY15CaHHIFFIIcCSiqhVRPEOgw8lk5lpkk6uZoUVpuVsRaDro79624u1+fpcJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 21:08, Ferran Duarri wrote:
> transparent_hugepage_flags unconditionally sets
> TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
> is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
> ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
> THP is applied by default; they do not express a preference about how
> hard the allocator should work to produce a huge page, yet the defrag
> default is pinned as if they did.
> 
> In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
> compaction in the fault path. Paired with transparent_hugepage=madvise
> that is a bounded cost, since only regions that asked for it are
> affected. Paired with transparent_hugepage=always every anonymous fault
> becomes eligible, and under memory pressure the faulting thread can
> stall in compaction.
> 
> "defer+madvise" keeps the same set of regions eligible for huge pages
> and the same allocation attempt, but on failure it wakes kswapd and
> khugepaged to compact in the background instead of doing it inline. The
> fault proceeds with small pages and the region is collapsed later. This
> is the configuration long recommended to users running THP=always with
> large anonymous working sets, and it is a strictly weaker stall
> guarantee to make the default.
> 
> This changes only the compiled-in default;
> /sys/kernel/mm/transparent_hugepage/defrag continues to accept every
> existing mode, including the current "madvise" behaviour.
> 
> No stall measurement is offered with this patch. On the machine that
> prompted it the fault path never reaches direct compaction at all:
> thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
> is 0, because memory has stayed abundant enough that no huge-page
> allocation has had to fall back. That makes the box unable to testify
> either way, and a number gathered under those conditions would measure
> nothing. The argument above is a correctness one about which knob the
> Kconfig choice is entitled to set, and it should be judged on that.
> 
> Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b118bcd392cb..749f669cca56 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
>  	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
>  #endif
> -	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
> +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
>  

Why are such defaults not better changed in the distributions or by the users in
their boot system config? Why is there a need for us to change the default in
the kernel?

-- 
Cheers,

David


