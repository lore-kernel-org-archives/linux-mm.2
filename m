Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7774C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A896B0092; Wed,  9 Sep 2026 13:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1956B009E; Wed,  9 Sep 2026 13:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9CD6B009F; Wed,  9 Sep 2026 13:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40FC06B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:16:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCB82A4307
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:16:35 +0000 (UTC)
X-FDA: 85194877950.26.15A6EC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1BAD420008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:16:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUt3fl8h;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974194;
	b=RDcPuFK5aQZoxoQqH51QEWxF2tTXK0vb2uDEH01wPZLlPk6ucKcpExIF1WD2tU8wcttCr3
	obTHzU045CElyejaEP06gSQA8l3md5L7msCoVXaftpA25C6FFTUPt35W1je9grhZDKjUrl
	gPsbvx6NIibsbbZ+Rjaq/g68ZzOjMxo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUt3fl8h;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCNfdPry0qx3z3EYS25Xgw7tSBbwgBT8RyM8ger6/hk=;
	b=mu4kiWyK+lHx4LxxHqtGELe8xcFs9MatIwAlk1qG3WBC90shNGsglix1IAOrFr2pYXWMaF
	hxPqah6ARKZQ7+dyEod5u4E1fR1++K3XOKU+3KVME/ShG3PnRLKBSK1JC6ygTGejugjrFg
	NKemAIhVHXzcmhbLi+ca5HNGBzx36H8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AC01600CB;
	Wed,  9 Sep 2026 17:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47FF1F000FF;
	Wed,  9 Sep 2026 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974193;
	bh=RCNfdPry0qx3z3EYS25Xgw7tSBbwgBT8RyM8ger6/hk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HUt3fl8hAt44QPj6lykLIlkMzZu/kNaIu+7I/sN0voLfwcLf510ppqfYbRl7KcDEv
	 SKMb9cs5xZcJvNsUF9CfDYxSGPCxcA75at/RjGWUvZvZIqRpjlfaZUpBy/mia5YSt3
	 sehhohY8y6vO3d67rfo9cAcMO7HGnh2faq6EX9fAVC6Jx/gddHiPTEpB42PKbZ2aWu
	 h8hZN4jNdr1qjMzrwpguqChT6cJC/Ib/QTQ3YnwXC5T5iEmIcstljUzYY3YwY4FdC/
	 di7xHiCt0w25A7uOe6ykp7TiT06K256QLU4eLUfv4lHS2ZitzlHqsYdVTzbeoEb7tN
	 KyEZApAl6QaDQ==
Message-ID: <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
Date: Wed, 9 Sep 2026 19:16:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907063918.3432401-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BAD420008
X-Stat-Signature: yrzbzfx8fk8q9o4fnpqt5xrkkhwrgpfc
X-Rspam-User: 
X-HE-Tag: 1788974193-309669
X-HE-Meta: U2FsdGVkX1/nbCZbXENnBLyvW5sIyw0ReReoZjKrwS6BULZJoSiw9vrRIUJ0as0RXKxrUGmhQI2keDgv7EcvzNHBh8T0w4wKqw6XyPxf3I6rnns/n7/nk6MdL+xDt7vc1GPrbDWerZx3gDroc1RKa6eKjV+NTUorfSLr4NQSioV0M+5/dmMERy829z3P0INvjf6sTbRG5RaS8DdOclftznGvFIrYfQcQ6uDa9Jsb6HucXgtO5ipzp3iYTuQZRQy/BZyT7Lo3uYoJG+kzW4l90Ylh/5GttXPJHZmlrNa6dQBCLzrU5bbwAhI0/4Z3lQ1+WYSUGJpRkjllYzQXXrRhGpUPuS/V3NrAofiGohcUNlh42qxpbHHOGsKBaHpEXEGSLfLwpWHD97i2ws7FTUwBw/etRiqCAbgVbyl0U5XqNScUOOZzN2mqOVeHLs74LHRJexbcCDieE0+5lnhGNy3abMMx8z3d4yuQYOkMSEdqR15scR5WVLsEHfI+jeHImdz8iFubkGYcdfQKV9s300uC+SxCqtZRoT22baFP8hCZ/B7aHvJ/B4QojrY7+PEAls0Twp133L3pLjBHe4QCfuhlBlWNToxNuq0o6T8D8TeDpFF2YLjALjo2qG7W0E8nsNHlAfZaRrYmfxEQQo0mi7DbD52N9SM+5qNVut6RViZ/VNzhADKgiGpxoP7G24YyR7gwQxKnR9DH333Adpi7sr8Q/VRv3bC+Uwz03ZMD9qjOMiZYLRvXALLyF647vAuiB+IE46Fyd1Sqw3eMyEXTxUbk1Z/QOs3tg3TCC9YYZ9CQNyxDgJdCFoVKp0hlJRTAlKUc5AoLNSX25cO+gvb2GEsq06HBheQU1qHKcUuN3AkHQKexorDef2toKv2tZ3tOUqrlgSSP0C7zqxf2KvChM4tw9qnke1xQACJ2VX7LlyL0bvF8f+Ey1yeIcHKrAV5cxvZCuAfzyNKqvri0HlhhmBZ
 EOTyzKm2
 Uyq7mha1bPM892Z+OxxG4Wn1jIoZWfVlLZitLYMloHUgV3u5rgFrhN/h/HLU96mQGOu00EIa0QilZqI4AkHt15nB2EEi7r5wKkn/8lJbyqqXPXCKWabFxv61nraFRVIlXlarFKjR+YOxbXixb4zl/0CosyCDxFcoC3muXmhHs4g0+Kse3JD9R5AT92qZfPs1uKwkcz+Bx4F9T58lfoOFnMLrQCgElXOdwv/Q6Lx0t+wY69koNt3ZHpdiX/1rA8jePyyY4XsXAcXaF3XpNgG3ADdyp0+NH3Q6kmvHoZRkAJjesuXhmy7t781qTPjI6qCe6FPB4Bo1R9icSqHJFJd7OvdHyrtPQxQ1o/DH1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:39, Suren Baghdasaryan wrote:
> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> when it's set to 0. Eliminate this special interpretation and pass
> vma->vm_start explicitly when needed.
> 
> Since smap_gather_stats() operates within a single VMA, we can replace
> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> which is simpler and also can be called while holding per-VMA lock.
> 
> No functional change intended.
> 
> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 9908ba32f180..3351decd1172 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_shmem_walk_vma_lock_ops;
>  }
>  
> -/*
> - * Gather mem stats from @vma with the indicated beginning
> - * address @start, and keep them in @mss.
> +/**
> + * smap_gather_stats() - Gather mem stats from @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA to gather stats for.
> + * @mss: The accumulated stats.
> + * @start: The address from which to start.
>   *
> - * Use vm_start of @vma as the beginning address if @start is 0.
> + * This gathers stats for the whole of the VMA unless the lock was dropped
> + * and VMA grew or got merged and we found it again, in which case we only
> + * gather stats for the remainder of the VMA range.
>   */
>  static void smap_gather_stats(struct proc_maps_private *priv,
>  			      struct vm_area_struct *vma,
> -			      struct mem_size_stats *mss, unsigned long start)
> +			      struct mem_size_stats *mss,
> +			      unsigned long start)
>  {
>  	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> +	const bool is_partial = start > vma->vm_start;
>  
>  	/* Invalid start */
> -	if (start >= vma->vm_end)
> +	if (start < vma->vm_start || start >= vma->vm_end)
>  		return;
>  
>  	if (vma == get_gate_vma(priv->lock_ctx.mm))
> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>  		 * Unless we know that the shmem object (or the part mapped by
>  		 * our VMA) has no swapped out pages at all.
>  		 */
> -		unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
> +					  !vma_test(vma, VMA_WRITE_BIT);
>  
> -		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> -					!(vma->vm_flags & VM_WRITE))) {
> +		if (!is_partial && (!shmem_swapped || shared_or_ro))
>  			mss->swap += shmem_swapped;
> -		} else {
> +		else
>  			ops = get_smaps_shmem_walk_ops(priv);
> -		}

Horrible, horrible code, really. But not your fault :)

I think we can just make the shared_or_ro less odd by just checking for cow
mappings (as described in the comment).

	const bool is_cow = vma_is_cow_mapping(vma);

...

	if (is_partial || (shmem_swapped && is_cow))
		ops = get_smaps_shmem_walk_ops(priv);
	else
		mss->swap += shmem_swapped;

That's almost in a form that I could understand what's happening.

-- 
Cheers,

David

