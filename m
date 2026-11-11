Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BAD606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6kuST3N
Received: by kanga.kvack.org (Postfix)
	id C12636B05B1; Wed, 11 Nov 2026 08:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA886B05B2; Wed, 11 Nov 2026 08:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B024F6B05B3; Wed, 11 Nov 2026 08:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89AC46B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:08:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 132641602B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:08:47 +0000 (UTC)
X-FDA: 85422867894.03.4777DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 455021C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:08:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6kuST3N;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794402525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpSt5JkGUaHCP8XlikkEOI4qJddO1S2MUXWY1pm1gq8=;
	b=ZiM1NlkjEym8GeXLLj2mQeecfMZ/BvFH+API3W1jmwjjMqkXBGmJYOv1M2YN/Hkiaigd7T
	TL+ZRH68JdLtVGVEZLd/iS34QHuHoHt4Zkv8QT4RKW1z/z0cuR1IdR9oX6iDXftlgT7VOz
	bulZh3SQSNGivi5vva6/qI0Gx4bkaQU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6kuST3N;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794402525;
	b=xGEicaABlhXvk89smMSmCUkx7e/ZdiK8cJRcj8vsUpIuGQIUOkhLCyrFuDBxQpEc5zhCkM
	QWiIpT9atNUtLwTXxabx8waFNDjxIID4DEF2ZhoXx4gN5zukUR6vBv+/suSBDhefHO8+5I
	0Ne7cEJSEUj/5iIcu2NsqgSX+SpZpeQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E9F640C04;
	Wed, 11 Nov 2026 13:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536EF1F00A05;
	Wed, 11 Nov 2026 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402524;
	bh=tpSt5JkGUaHCP8XlikkEOI4qJddO1S2MUXWY1pm1gq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W6kuST3NNP4zzA9PqmXm/bYJ6yoRhEgKl5fNUQn6dha9mMZiyvNhUUICtqwe3+ArG
	 jrSjuVs6BfBQGx22OPJQDQ77+zIoHH2HjoU2ZvMA72U2kcHSkaIJPXdd7WX8Q6lU23
	 BvsgBMhjHnKrtcDHA0gHVEVcKkuv7cyNUTCCbadw4goRnxkbFWPRAj5QxKya1CySU1
	 vhoM+ye5tViT7u0sZFpSC8q3yi9BbrZSS0jKAptLmf2YYRwMsQ1ePzHf2uCedCXW4f
	 /KreGp+leeCIRPhMfpge9Ms4JosjH+/kYUEU1/2xKHMyvkoAXWxY72zws1fLN5KnlT
	 mk5wUibYF1QZg==
Message-ID: <e2d1dc9f-59ff-4dfb-8ca4-35c584d14b35@kernel.org>
Date: Wed, 11 Nov 2026 14:08:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: don't set SLAB_MAY_ACCOUNT for
 KMALLOC_PARTITION_CACHES
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>
References: <20261111125628.375624-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261111125628.375624-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rrq37kuc9bx3o8d8eepfpz64ug9xp9b3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 455021C0007
X-HE-Tag: 1794402525-86416
X-HE-Meta: U2FsdGVkX1//MtIV9a5WY3f9HPJkk/JtkLEll37/JmrpG1+OcodPy3hKbL31K3b97+/hCKjIoW2dpodKmxQGqFO/8t2hmJugjGjvcqRHfUmJR92uyrqnLhsg4UHnU/HOCujfAt9zfHYLqIL8O5ee7Q3J1lU9dPzNvrJ8kxSPWMdA2e+caD4uqbX61pQxFhyza6tkURZy1wlCF412kodjTdcAoToZv9lihI1k4GjvScD0/w9W9cYs1Es1SnMJyVG5RwUtRQLqbpdTc7rNMa+fl82ZIJG8L3aQpuJN50Smd89GQ1nWuA1LXxx4scN21o1yp6+XsTp5YdCEL2wzhpMneeSgljjnWqzzwGAa6hUNxNVUzbRnRpbrpZbDnqLrayp+RxX2lRrSO1Fch+cJC71+ic7yfaU2Jhh0vWf3RMLfFowMk5GLpBGliMsX9szlfp4VwZlTqwNsyha2HR6y9d50HrtJ5gOedysZF0Xd0yh5xAXb7sZRRwULPYQ71FV00BxYCum1hDlAaBmZMtBckFJSdtM5dbWm7b9xgYwUrMF8TSTFKmnUn85YK9yHLGHWCE+2sC6Zod6OLwGkTNgNKMkw5btA6bHJQY14YT9nAvEDf8H7X/ZM1CUzQAtjjIkGDg5ivLNY+RYWIF8cvVAEP6S/dodWtg5z27XznY0stuQl8IV4VFSe6RijwQ9nOCm8IfK64IufSyLL2XNeWV2z0i7y2BQvVd31yuwDvKKZ8XSwYSjvaNLZnRzNrwzskUS4FHJjznz07WrfNrvy1LmV9wzgwV0tKAj3sfAj7vcJFvl5XONi18yl2/HUGpi5F4KUrJreh3+o/dNrL0zazMdBBcnmShIM6dqV1TYxkmCzh98PsaoBhHy5BdEDlFv+ZYdxG3O/pLCl3wXLjyeXpAR9utTuzyhjCzyYfWk+wddCO2arBszWPkI11KLDVjYr6PWRLYBPU8Ajl+YNKZOfnz21wmD
 5mh1K9hZ
 KL1lBhBtxxiT3KZHSbkEQC/R6X9BCvRhYZeK0zuZpiS3OxmWM9XMEEP6lfSAVZ6mSrb1H1oBoRzWOHr9wgTJwSIMe9wgh8qdR6c2ZTucwoYyJsQUklHCICjvD9/varkRVvhRUCEtZVnj51T0bM4NX1NlbVEhgwmCXQ6ZQ0KcxXyTdzw9Hn8YLRBU3xZ+BPtQ5b8EHzfSOuCpzgqdSc73qLRO1SU7J3mlgfQRGFKm7e3+kdGhdB8Ggz61H7AxpdmZxsBmHkxhsMZN8maFxdOIzw0pZL/p7RKRE+gLHhQqTzWHzJ7r7uQT31C1LYefneHMzp50/bqmLZ5+sdFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 13:49, Hao Li wrote:
> An allocation with __GFP_ACCOUNT set (without __GFP_DMA or
> __GFP_RECLAIMABLE) is redirected to KMALLOC_CGROUP and will never hit
> KMALLOC_NORMAL or KMALLOC_PARTITION_CACHES. Consequently, neither of
> these caches requires objcg slots in obj_exts.
> 
> While KMALLOC_NORMAL already skips setting SLAB_MAY_ACCOUNT,
> KMALLOC_PARTITION_CACHES still carries it unnecessarily.
> 
> Extend the check to skip KMALLOC_PARTITION_CACHES as well, saving
> unnecessary objcg slots in obj_exts.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> This doesn't seem like a real bug to me, just a small waste of memory, so I
> didn't add a Fixes tag.

Hmm I'd add
Fixes: 7def2e8549e5 ("mm/slab: add cache_ and slab_needs_objcg() helpers")

The question is whether cc stable as well. 7.3 LTS will be used for Android
and IIRC they have memory allocation profiling enabled. Not sure about
kmalloc partitions. Cc'ing Suren.

> ---
>  mm/slab_common.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 2befd24b4d09..f0ea1fa178e7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1000,16 +1000,18 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  #endif
>  
>  	/*
> -	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
> -	 * aliased with any other type, make sure it's never merged with any other
> -	 * cache.
> +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL or
> +	 * KMALLOC_PARTITION_CACHES cache and not aliased with any other type,
> +	 * make sure it's never merged with any other cache.
>  	 *
>  	 * In other cases the kmalloc cache may end up being used for a
>  	 * __GFP_ACCOUNT allocation so mark it as such. The exception is a
>  	 * KMALLOC_NO_OBJ_EXT cache.
>  	 */
>  	if (!mem_cgroup_kmem_disabled()) {
> -		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> +		if (type >= KMALLOC_PARTITION_START &&
> +		    type <= KMALLOC_PARTITION_END &&
> +		    KMALLOC_RECLAIM != KMALLOC_NORMAL)
>  			flags |= SLAB_NO_MERGE;
>  		else if (!(flags & SLAB_NO_OBJ_EXT))
>  			flags |= SLAB_MAY_ACCOUNT;


