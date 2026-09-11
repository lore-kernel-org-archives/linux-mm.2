Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1BFC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52246B0092; Fri, 11 Sep 2026 12:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02E56B0093; Fri, 11 Sep 2026 12:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18ED6B0095; Fri, 11 Sep 2026 12:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE966B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:39:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65735802E1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:39:37 +0000 (UTC)
X-FDA: 85202042394.15.30C3A71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CB16718000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:39:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGl9I60x;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789144775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkTP2UvkR9L4UOg/cpBiigVG7rpJsSBTG6KbmpAnG+o=;
	b=M4Y0BJ+Afi1vtNcrKAjtLgGpFBEdqpXeeSd/9dplganE3VJp2oMp2zs+hrsQfB2gQtdR41
	Kjdn/R+unMayv6kTzI++hdPY7rNY64cGJmoFfdo8mBXjKFU9UhY1/PXt3QrnFBlW0IK41h
	IixKP0hEG3RWxcQS7GWcIWPFK1dr3Dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789144775;
	b=v6YEpNuQbNYBK6rQIY50XaIj9mtpij/b41PSuurRl2YzdF3xQf6a2b3q3jRxO+5bWLR/aL
	P5VxQiP86hushq+RWHZEtnWNXe4M9Uc/cuBrb6/H2xTOIZQkOtiWu5iioAUuJvFWGZjaYC
	En1baDX+jG1DDReNXQBR3GwNS9jmiwo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGl9I60x;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E326360008;
	Fri, 11 Sep 2026 16:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEF91F000FF;
	Fri, 11 Sep 2026 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789144774;
	bh=OkTP2UvkR9L4UOg/cpBiigVG7rpJsSBTG6KbmpAnG+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MGl9I60xY3Z2sFqyyRhad6HQLSNPVGaSdlpegFKSLHpF3B3rGo1tqdouOTEkjKNip
	 alC0sHkDBVQbR5AEBqEpVXXiaUDQ8piArAQN5p42Uf1l1mEGXfrtfdPkLcc8DWVFHd
	 uxS1/6MHrVb2aPWYKFqB25mTgla33/lPHoIXtpv+R5dEuU8fMbmQDpBzQdyMHTIgLR
	 ALkurPnDO51TkRfpCizQmi+qxoWpwbCM+Hq/OSW+ug31KUDVs44DDpIXjCG2ElxENH
	 1ciplIL2LP9dQiie4EW5MnBVvWvk7S/EMinDR/7sok2kQu9Vsord0jwYfSmqNZPT/N
	 iV4NFGY3TFsVg==
Date: Fri, 11 Sep 2026 17:39:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <aqQsWNfrBSp4DY_N@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234737.1340642-5-surenb@google.com>
X-Stat-Signature: s8knsotksx1hudgz73pmnk95b9qw6zi9
X-Rspam-User: 
X-Rspamd-Queue-Id: CB16718000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789144775-653969
X-HE-Meta: U2FsdGVkX1+jWaCR0ODr6e0LX3Xcwz0BplGrhQK+vD/MAqHIfHYf3mopPMftH3io+53Dp4XOqr7AtEA2LqwywhjH28jXYJa1ByimdZMWTonJr9qfgG/B8eoAoOc5GY2xfQ00OlDEdwUEvwkH8vnzEsMglyvcUGjrI9e+SxetzfJBtvskDhhzbAzlV5OFknddlMylRmaD9TdnIXyp8AyYn9ecMt+ceowYvjl+Fwfzvj+tXRQgg8yhU/e6soWj1CF/B2Bo71z1y7l/8AuF/N8X48WLMuzinhoXYFmabWIJDnil/M/++H7Kk17LxBarfwYVA8OmQqvOOk4K1kyp8Pehvju2XUAG69RE2rXcZmO7q9/K63UgRY5CwGHXyA+25n54vWWhVq+kpfW3xfAWBCG8JwM51etcpGUmCfpvK/J+3la9NAT4Nswskaf4m1q2Lli1TXI+mumBAC/c7O3DK96ukMqUmTlO+SXQa1jQAWBQHoKJLN2l2y4JWZ57eccvNawhkf+oOV2MD0VEA/feRmbqxumIu+G1ou0DIrqgmQcUj0pWNxWndboPyadtGL9atqtRj4JkR8/DqbGQWicuV8t+iS3yEY4iupud5eB8FF3IQqdBFv0WhdT4rhUuUX/PNuZWKWNUm9ZBVuozQBLEBgLx5B13D/ZRY8psYt8OkHWtAJBLFmgbKtC0iMvOhu05RU61lH1J/XUC0GUzs8fxIdgRvChMZb8+FPDvUyeJNwiztBamziYThPphHVGsc2UAfeQROuYfBcsdq5yeCnhiSVTFR0NGaFFPPUB4Y8LS//d5Oe4Tb+X9Gd0XKvN0wURmj5XhYTz1VHaquGXVni+Jf8EJELJZ+BrrgRotVZm5csD8uiN29H1kVheS4tY3iL0EEM9MRG1G/pZiKOPaAIeDk7kF8FD0Q3o2FLUzXYJt0bzbsianlHLrjb4U/qb1wtltBxfiiaULVb47DuSANHvmx9v
 yyaPD031
 fHH+FcAZ/t+I8SV+h1Utaabp4orghrKU8vCxUDhzbNjJlArRCMt5R2AScKukraa/r0qHBgoTqWW6eHHgQ/As/NYBtNjTTfI8OdNQJ4KAXWHNe0RizGlmBdx/xWg8dZe9v0AaCXpsY6XaBnDt1ZYDTRLbcHsm317Dyw3HXFmqWzI6XxpHgZP2HblGDCi6PcCyCavvpFTDS9eZQDDwjRozMtevgIe8t+u2Iz1leg7QP2/o/I+Q/3udgAMX/QcBWX++LkPW88zVDW6eyug7LvP9PktzXnoZglaQh8ohv5f2OFvXlqk2tdTcQSlPP+soUnh7K8T7WLtn+rotXjm8+QpZ/QYZpJd8Dc0PswpYNQwKNsFxdllWaBjRISejj53TXCpruzEZVX1zz3c2hOLIdCgSOezqhitcZzWhnwSoHb4jGHR4Vbb6A4MWKjm0xO5DKNg8Vh/qJ0tF2IsUcMlM4E+PvK7FQxp/BPph/clKH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:47:34PM -0700, Suren Baghdasaryan wrote:
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

Hmm did I? Where did I suggest this?... I guess a while ago?

I mean I also happen to suggest it in the previous patch review :) but that was
sent after you sent this...

> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

I don't love hacking a hack for a patch and then unhack it in the next in a
slightly roundabout way.

Feels like this should be squashed. And a wrapper function for
start=vma->vm_start should be used rather than duplicating that param
constantly.

> ---
>  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 3c40c9cbb9c9..ecce7ce116cb 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
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

This seems to be describing what callers do not what the function does unless
I'm missing something? So that's really the wrong place for it.

I think the description of why it might be a partial walk belongs to the bit of
code that actually tries to do a partial walk.

Anyway as per below I think separate partial/full functions make sense and there
it can simply be described as walking either the full or part of the VMA.

>   */
>  static void smap_gather_stats(struct proc_maps_private *priv,
>  			      struct vm_area_struct *vma,
> -			      struct mem_size_stats *mss, unsigned long start)
> +			      struct mem_size_stats *mss,
> +			      unsigned long start)
>  {
>  	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
>  	const bool is_partial = start > vma->vm_start;
>
>  	/* Invalid start */
> -	if (start >= vma->vm_end)
> +	if (start < vma->vm_start || start >= vma->vm_end)
>  		return;
>
>  	if (vma == get_gate_vma(priv->lock_ctx.mm))
> @@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>  			mss->swap += shmem_swapped;
>  	}
>
> -	if (!start)
> -		walk_page_vma(vma, ops, mss);
> -	else
> -		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);

I mean obviously am in favour of this as I suggested it in the last patch :)

>
>  	reacquire_rcu(priv);
>  }
> @@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void *v)
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
>
> -	smap_gather_stats(priv, vma, &mss, 0);
> +	smap_gather_stats(priv, vma, &mss, vma->vm_start);
>
>  	show_map_vma(m, vma);
>
> @@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  	vma_start = vma->vm_start;
>  	do {
> -		smap_gather_stats(priv, vma, &mss, 0);
> +		smap_gather_stats(priv, vma, &mss, vma->vm_start);
>  		last_vma_end = vma->vm_end;
>
>  		/*
> @@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>
>  			/* Case 1 and 2 above */
>  			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, 0);
> +				smap_gather_stats(priv, vma, &mss, vma->vm_start);

I mean this is all horrible, having to pass vma->vm_start explicitly.

Although better than the hack that gets compounded in patch 3.

There 4 invocations of smap_gather_stats(), only one of them passes a
non-vma->vm_start start.

So it'd make more sense to just make smap_gather_stats() lose its 3rd param and
have it call smap_gather_stats_range(), then have 1 invocation of
smaps_gather_stats_range() directly, as per suggestion in last patch.

Or something similar to that.


>  				last_vma_end = vma->vm_end;
>  				continue;
>  			}
> --
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

