Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18297C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161626B00B5; Fri, 11 Sep 2026 15:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139136B00B6; Fri, 11 Sep 2026 15:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076AF6B00B7; Fri, 11 Sep 2026 15:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D33406B00B5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:45:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4503A8014B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:45:28 +0000 (UTC)
X-FDA: 85202510736.24.5805480
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A29574000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:45:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i64kGb/3";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK4p93/u6AanIHtu5vXzEzaRXDt40DQgX7Ravxuqpxw=;
	b=4BRiBV2HLZgRrl1eWFX5MX3nemjPaN7HWguQp0xaJUCvZ5VCHLnqw6hvYe/WCvHNCN682j
	BILrxenkHx/GEtvnPinrVWfzFRMd3xZokHcRaez5Puoe4b8Mf/Kjnv0YLcGd+AuSSBaToL
	5/fIyWFUoecuXzGXOXmB/1w3Ajtttso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155926;
	b=SB/IgFxH6C7HubfCUaeHRkshpr4O9J5WTtkkKW23yBEjrGSyPDpPeLWyPPpeUIteezGmZ4
	Gs0bYhzcTgWMuigwcUCRrIbLeWOj4Zg/qZXhjHkjHScYukiejyUn9TSOhvsOlPQJJ9IgfY
	Ftt9G6fNNRhD4jflEMJ0aabTn5pS+T8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="i64kGb/3";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 261C260008;
	Fri, 11 Sep 2026 19:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC71F00898;
	Fri, 11 Sep 2026 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155925;
	bh=fK4p93/u6AanIHtu5vXzEzaRXDt40DQgX7Ravxuqpxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i64kGb/3X9BQVjACRQTmztK6UN9vfAAH0CDAv2AoWhz2hBGqmDrBgVd3MhMcWzXNO
	 1ctBcxLoO6M9eaVjGcglS+1j6O97tmY2YcHWzkHZDPcEu7r6Y8h604/6HNvNd7InFA
	 bRAtyHJ36NibHuSvj9NC2CeNsn3mDxPZTkAgEAwY/baM1XygvBqU4jWnV+4kWZFiKn
	 UhnfZgglAgptZjfXFwyoojUDhs9WKgwBsVhvuhWJsrFQ9C04ew4ZUCHEesEgIq+SvN
	 uOvRQbnj7fd65dbi5C+7gavgD16qrtTA9Ge0gMxyAh5un2EXZSnXzk/2AmXm/6Eh+2
	 kgp4njV5imiZQ==
Date: Fri, 11 Sep 2026 20:45:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <aqRaONEiklcnblwQ@gremlin>
References: <20260911194145.1781926-1-surenb@google.com>
 <20260911194145.1781926-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911194145.1781926-5-surenb@google.com>
X-Stat-Signature: shhkm8rkfnamrhszky3ckgyjs3s4etgk
X-Rspam-User: 
X-Rspamd-Queue-Id: A29574000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789155926-628260
X-HE-Meta: U2FsdGVkX19yuxcBPh/BNjrsFP5eFBvbFSruwg8PCJyduucdn2xYNuaZbO+sPpfo4jEi86VzFeKocwNasYi8BLgl98CIN49bHJzej8QO7s3rQ7jpv3yG4xkwPpp+RwztrJQcck21g/tZcpvYgm9CXeb1iisjUvzzBtLuy2AQXqECc5ZeSvk8Hmx6ifozyHPRXFtpF1fv7YwWOmGj2BWs0jhG5lZMwFcLaQhiNdeCycHqoXjQA3sIxhq42nwVy+AWDNXtzY7JE/CLDt5/cV45QRGZ8bz4fHLh78kc0Nu+o4I2xtv6h6DAZZ7A7kzEdgsu+jmg+FA7I0/ak7DZv8h6epPeJwrzdz9P5dv9bWCtzDoHUvqjTwlcVMQyYfb8oYULKBniowF0OjSzSlb/HnNTopPwfExfgVZuctYXLnPPC9GPDKdXKQO3HM7ZP+LaAe8mbrHMslazcm6Y+KWq+RCoB0ShcjOb/VQ9/GKgj5KfU3FmzQ2WMwD0OARJUVZMVl2WxdmimMITSZUCfhMu6mNdrneVBc4S3EFs6Dj/Vj3nc+luyXLvXkEKwwRlo3wnh/EorXHL+/loe3f2iMQhmCFBr++/Aunn6iOQx0YY4QzyX3VjIFtOJ0n8aPMUCOhF873TtLIHNjJ8rwtK5YKXPCGniwoFqlvAhFbCoC77wkIJknho5w8LTSvO5o87ud4/uOQwJ2dUlCJ/UdEP2iOZWl86KFkjgV3UrFgrWMsYhVwwT8dyDxQVkDPWbIoHSt1HLeLoGLkl9QQf/JUBwmMllBNwXOo6ebBQ8FRlQsETNsQzA0zxsgxSRNKHF2Z6e4cGB+u8yyz/C1FVuKeWR6WSYoNiYCrzMFW3A53VA4xB507tdDKjc0U9Lji7+aRuTwyXoovbqT2xRoCQCx8GCQ/5QwNo9fXSxwOvJKzvojt7kiGSkJTeOtvtxF7/RMCtERdYt9HM6Mz2qsXXuqybk9+JJr2
 5TNwv/35
 es03nhofKa5QLtAVEIQrmCBrS31m4CPCnUNhox/i9Snk832Fo1UJ9tGxtGOT0iETlQNIv14jQ8IT7Wy/cdgYFCisXmAAGlyAA7g1Ta1Ado649A2LdK6MWRuJHwcOYjICHeHJIRs0mCSqBXZ/dB5dGVoUO85nQuvkDcp3Ngh7aU5DMy1h9RzNqOJED83qykI6u//Bns3//YiVJvJrJMeJ+7WTREkHhi4j+5WwwOO7kfdlVuwlrYBRg5SOCdNHLQPfhcUN9WdMclRjb/4K6O8jNRyCHGy0D6bwtrni5yu2QK7amJW8hKoUEaa6pl9EJMtFDOKF48nAtbuPEk7eO8znwIdPZW3kOY/S5WJv4UlYJ84uU6uK63lekaJOVaW1W82N9RuqYPI2cs9NagTqs9Ds3rH8363WApoFEtX59YQBzK3w1vSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:41:42PM -0700, Suren Baghdasaryan wrote:
> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> when it's set to 0. Eliminate this special interpretation and provide two
> separate functions for a partial and complete VMA walk.
>
> Since smap_gather_stats() operates within a single VMA, we can replace
> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> which is simpler and also can be called while holding per-VMA lock.
>
> No functional change intended.
>
> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 52 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 35 insertions(+), 17 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 0e53eb065a3e..a6026ffd07f1 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1246,20 +1246,26 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_shmem_walk_vma_lock_ops;
>  }
>
> -/*
> - * Gather mem stats from @vma with the indicated beginning
> - * address @start, and keep them in @mss.
> +/**
> + * smap_gather_stats_range() - Gather mem stats from a portion of the @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA to gather stats for.
> + * @mss: The accumulated stats.
> + * @start: The address from which to start.
>   *
> - * Use vm_start of @vma as the beginning address if @start is 0.
> + * This gathers stats for the portion of the VMA starting at the @start
> + * address.
>   */
> -static void smap_gather_stats(struct proc_maps_private *priv,
> -			      struct vm_area_struct *vma,
> -			      struct mem_size_stats *mss, unsigned long start)
> +static void smap_gather_stats_range(struct proc_maps_private *priv,
> +		struct vm_area_struct *vma,
> +		struct mem_size_stats *mss,
> +		unsigned long start)
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
> @@ -1278,20 +1284,31 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>  		const unsigned long shmem_swapped = shmem_swap_usage(vma);
>  		const bool is_cow = vma_is_cow_mapping(vma);
>
> -		if (start || (shmem_swapped && is_cow))
> +		if (is_partial || (shmem_swapped && is_cow))
>  			ops = get_smaps_shmem_walk_ops(priv);
>  		else
>  			mss->swap += shmem_swapped;
>  	}
>
> -	if (!start)
> -		walk_page_vma(vma, ops, mss);
> -	else
> -		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
>
>  	reacquire_rcu(priv);
>  }
>
> +/**
> + * smap_gather_stats() - Gather mem stats from the entire @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA to gather stats for.
> + * @mss: The accumulated stats.
> + *
> + * This gathers stats for the whole of the VMA.
> + */
> +static void smap_gather_stats(struct proc_maps_private *priv,
> +		struct vm_area_struct *vma, struct mem_size_stats *mss)
> +{
> +	smap_gather_stats_range(priv, vma, mss, vma->vm_start);
> +}
> +
>  #define SEQ_PUT_DEC(str, val) \
>  		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
>
> @@ -1342,7 +1359,7 @@ static int show_smap(struct seq_file *m, void *v)
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
>
> -	smap_gather_stats(priv, vma, &mss, 0);
> +	smap_gather_stats(priv, vma, &mss);
>
>  	show_map_vma(m, vma);
>
> @@ -1395,7 +1412,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  	vma_start = vma->vm_start;
>  	do {
> -		smap_gather_stats(priv, vma, &mss, 0);
> +		smap_gather_stats(priv, vma, &mss);
>  		last_vma_end = vma->vm_end;
>
>  		/*
> @@ -1454,14 +1471,15 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  			/* Case 1 and 2 above */
>  			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, 0);
> +				smap_gather_stats(priv, vma, &mss);
>  				last_vma_end = vma->vm_end;
>  				continue;
>  			}
>
>  			/* Case 4 above */
>  			if (vma->vm_end > last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, last_vma_end);
> +				smap_gather_stats_range(priv, vma, &mss,
> +							last_vma_end);
>  				last_vma_end = vma->vm_end;
>  			}
>  		}
> --
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

