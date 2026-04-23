Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCCAFAD41F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE37F6B0005; Thu, 23 Apr 2026 02:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A947D6B008A; Thu, 23 Apr 2026 02:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA5D6B008C; Thu, 23 Apr 2026 02:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 865576B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:48:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28BA714023A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:48:36 +0000 (UTC)
X-FDA: 84688892232.02.0D16F96
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F4761A0012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:48:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7xECMZv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776926914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfQ0BP8bxZNhW0WWowaJNPXXEznxugFE1UvBF9a3FSc=;
	b=bGMaQgeUF0a+RkCEftMVfDPDsj07ElyaNICvYMWX3FySP4hVoYcmLvnFnSZTOgtCKdue6W
	gtDX055ULlxGtUORTpa+0vCFAT2hMXT2gejPcFoZ+cc84/e6VCcCTw9I/W7PEkbWBi0agw
	tZeCJMCtZdBRJucwLZc+RiLfOtAHsRo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7xECMZv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776926914; a=rsa-sha256;
	cv=none;
	b=VcVl8TLNaHQBSIc8gQ2IrA2dBUWQO6FXYsgPspRLELeq707Qgnjm0LDY/V8LiTfcTH8GFM
	oIOoZpl/r181+Sgf/WXFCB0rG7mEO74IL1C8XHsMQAlVKE1QSMwYsDqtmbZSXQIZwEpmcm
	3p9HZDvur1vCA7RyUI/bN0eVQ5tn1HE=
Date: Thu, 23 Apr 2026 14:47:40 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776926908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OfQ0BP8bxZNhW0WWowaJNPXXEznxugFE1UvBF9a3FSc=;
	b=R7xECMZvCC3ODtyYh1A/Qi30nx4BJEa5+bmX6WspJraOKq4XwS37NN9qd1qNgvDFqOzqf7
	s82mbS1F1EfzvxlYFmMlWcbimhH03fidLLmWbDb3nqhbMWrk05ihIj/cchzL8sa//osT97
	DAIDZuHlYDDKXE5PkrrR7Jk++KFB0jk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	hu.shengming@zte.com.cn, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH RFC] mm, slab: add an optimistic
 __slab_try_return_freelist()
Message-ID: <aldjcfy4b5dnifqfnzrleyoeizz33fxscnrdxnitnf5zfdeuqs@v4n2vf6ywy2c>
References: <20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org>
 <qfxtirtpoxcuzhnohm7cbo62z3ob3tiknlss6xenjlrjossmpu@pp4wwry3jad4>
 <d0510c1f-4930-4424-97b1-b9c9028eddb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0510c1f-4930-4424-97b1-b9c9028eddb5@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9F4761A0012
X-Stat-Signature: txz8hci8z1owf4sjdfiinh83zfbi44g3
X-Rspam-User: 
X-HE-Tag: 1776926912-175810
X-HE-Meta: U2FsdGVkX1/+Ga10MmzpCOrpgVoHW84C1Hc4x01G0eOSL0Thw/ShFVaKZVUtcsZNzrLLdSwNQLBtNTSkzUMk03QNI2uCD7Iy/6oW3xUeqtlU+Ok75xpEF4ukSH84wL0yddcMRRGtUzMA5ityCHqU4a0SUhnww71UZo4byj17cJl50tJGav4iatx5bWVOEZdUNvOPA43LfzwzQ9bGFVvJT1AwKMMVisimLrAPFRMeZ0QsR6TixsYR38IA1dWftr8TvRrXqTXRDDVZZQm2vuEZuk+ggIvRW9Xj2ee/2lGC++WvtKwx3jTgNvupKTC7Rh0aDkaV1eabdyanBwZsZ6C4bN2X8DOjqw3RhXFkRzdNI0jrry+hIKNMK/yri+Uf5FpCzDg1Id7c/WU2KTGCzLBronqD0ejNWBLOFzNMu5Grph1bVCUI2tCJTWtECTIkLwiMlv56bdypOgWehSkKUiNXdbAJX9vs3dCq5/k6zF1mV8l9Z6r8FReEkSx/CN82bwDcmTHv7+EKuIDt+pc/P2XOuAGGCsxLdpydYgIWDmtLiFVyMuDpCfDVqFK4SalQ6A+GtniFxte9DqsS29zQp5zxPODvWjaZT5uzvjVcuqFEyZpLpOVwO36oCpVXplKQ4yWbbYetE3m7no5QY9U/DjzhvwxuPL+45HZGtESxTcz4yz7mSpZj97JYivHFay5shp3Spd1iX8bHFKiUIoTEwgknrMfcEl7ndt/GL4RVp7IRgMaaOlmTjyUxBXm3mw3mPfEkddiQZkLvgS69E4nsLqvnij0PvqjdsBy5k3xKLNtH8Rt+VJKNim9+UpZZYY1WqDA3gc3uhCdycnBFhSPOoROwDlv4I07sg0qnR1mfsrLPPL0zr5n6IfnEjNnA8cZYKWypHA+ZvKVU3dAPTDGhsCdDj5qpyRXS7K6L88O9NxHmaYt83rwN20AO3yImOOkBduLjxwvwR6WOaLEmzI3/SlE
 um0YVcms
 QvplyGrbDrMxHeNcKJuvqhIHyPJurjSWvaK1uJZBHESNx8YHEiTjji+SvzN61ZiOQrjYKyP+2N8t7CK60gEJxXnQI8nMuBbEUO6EaNQI8qIjY+5FyKyNVhlhkpP98lYkkO7hXPWTp24yB8XUsC3HkCTYQV2eha8cLbo4+u2jyzIKvPgx3QvwGNpdhOTXXtyCwPZjinEegTTTW6S8ENc4L3cdV0G6RoKr0qmQgm8pKMoq1RjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:55:09PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/22/26 09:09, Hao Li wrote:
> > On Tue, Apr 21, 2026 at 04:49:52PM +0200, Vlastimil Babka (SUSE) wrote:
> >> When we end up returning extraneous objects during refill to a slab
> >> where we just did a get_freelist_nofreeze(), it is likely no other CPU
> >> has freed objects to it meanwhile. We can then reattach the remainder of
> >> the freelist without having to walk the (potentially cache cold)
> >> freelist to to find its tail to connect slab->freelist to it.
> > 
> > this approach is clever!
> 
> Thanks!
> 
> > 
> > I was just brainstorming a bit here: what if we only try calling
> > slab_update_freelist without grabbing the lock or touching the partial list at
> > all?
> > Instead, we could just toss the slab right back into pc.slabs. That way,
> > we can let the downstream logic for handling "leftover slabs" take care of this
> > slab together. It could save us a whole lock/unlock pair.
> 
> Great suggestion, thanks! Indeed it should not be necessary to reattach the
> freelist and return the slab to the partial list at the same moment, AFAICS.
> Makes the code simpler. Here's a pre-v2:

Thanks for ack and working on this!

> 
> From 6f56844b79fcca5d1dd4203b879af7daa11d09e5 Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Tue, 21 Apr 2026 16:28:01 +0200
> Subject: [PATCH RFC] mm, slab: add an optimistic __slab_try_return_freelist()
> 
> When we end up returning extraneous objects during refill to a slab
> where we just did a get_freelist_nofreeze(), it is likely no other CPU
> has freed objects to it meanwhile. We can then reattach the remainder of
> the freelist without having to walk the (potentially cache cold)
> freelist to to find its tail to connect slab->freelist to it.
> 
> Add a __slab_try_return_freelist() function that does that. As suggested
> by Hao Li, it doesn't need to also return the slab to the partial list,
> because there's code in __refill_objects_node() that already does that
> for any slabs where we don't detach the freelist.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 54 insertions(+), 9 deletions(-)

Looks good to me.

Reviewed-by: Hao Li <hao.li@linux.dev>

> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 35b6cd0efc3b..95e4289671b3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -373,6 +373,8 @@ enum stat_item {
>  	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
>  	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
>  	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
> +	REFILL_RETURN_FAST,
> +	REFILL_RETURN_SLOW,
>  	NR_SLUB_STAT_ITEMS
>  };
>  
> @@ -4323,7 +4325,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
>   * Assumes this is performed only for caches without debugging so we
>   * don't need to worry about adding the slab to the full list.
>   */
> -static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
> +static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
> +					  unsigned int *count)
>  {
>  	struct freelist_counters old, new;
>  
> @@ -4339,6 +4342,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
>  
>  	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
>  
> +	*count = old.objects - old.inuse;
>  	return old.freelist;
>  }
>  
> @@ -5502,6 +5506,35 @@ static noinline void free_to_partial_list(
>  	}
>  }
>  
> +/*
> + * Try returning (remainder of) the freelist that we just detached from the
> + * slab.  Optimistically assume the slab is still full, so we don't need to find
> + * the tail of the detached freelist.
> + *
> + * Fail if the slab isn't full anymore due to a cocurrent free.
> + */
> +static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
> +				       void *head, int cnt)
> +{
> +	struct freelist_counters old, new;
> +
> +	old.freelist = slab->freelist;
> +	old.counters = slab->counters;
> +
> +	if (old.freelist)
> +		return false;
> +
> +	new.freelist = head;
> +	new.counters = old.counters;
> +	new.inuse -= cnt;
> +
> +	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
> +		return false;
> +
> +	stat(s, REFILL_RETURN_FAST);
> +	return true;
> +}
> +
>  /*
>   * Slow path handling. This may still be called frequently since objects
>   * have a longer lifetime than the cpu slabs in most processing loads.
> @@ -7113,34 +7146,42 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
> +		unsigned int count;
> +
>  		list_del(&slab->slab_list);
>  
> -		object = get_freelist_nofreeze(s, slab);
> +		object = get_freelist_nofreeze(s, slab, &count);
>  
> -		while (object && refilled < max) {
> +		while (count && refilled < max) {
>  			p[refilled] = object;
>  			object = get_freepointer(s, object);
>  			maybe_wipe_obj_freeptr(s, p[refilled]);
>  
>  			refilled++;
> +			count--;
>  		}
>  
>  		/*
>  		 * Freelist had more objects than we can accommodate, we need to
> -		 * free them back. We can treat it like a detached freelist, just
> -		 * need to find the tail object.
> +		 * free them back. First we try to be optimistic and assume the
> +		 * slab is stil full since we just detached its freelist.
> +		 * Otherwise we must need to find the tail object.
>  		 */
> -		if (unlikely(object)) {
> +		if (unlikely(count)) {
>  			void *head = object;
>  			void *tail;
> -			int cnt = 0;
> +
> +			if (__slab_try_return_freelist(s, slab, head, count)) {
> +				list_add(&slab->slab_list, &pc.slabs);
> +				break;
> +			}
>  
>  			do {
>  				tail = object;
> -				cnt++;
>  				object = get_freepointer(s, object);
>  			} while (object);
> -			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +			__slab_free(s, slab, head, tail, count, _RET_IP_);
> +			stat(s, REFILL_RETURN_SLOW);
>  		}
>  
>  		if (refilled >= max)
> @@ -9366,6 +9407,8 @@ STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
>  STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
>  STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
>  STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
> +STAT_ATTR(REFILL_RETURN_FAST, refill_return_fast);
> +STAT_ATTR(REFILL_RETURN_SLOW, refill_return_slow);
>  #endif	/* CONFIG_SLUB_STATS */
>  
>  #ifdef CONFIG_KFENCE
> @@ -9454,6 +9497,8 @@ static const struct attribute *const slab_attrs[] = {
>  	&sheaf_prefill_oversize_attr.attr,
>  	&sheaf_return_fast_attr.attr,
>  	&sheaf_return_slow_attr.attr,
> +	&refill_return_fast_attr.attr,
> +	&refill_return_slow_attr.attr,
>  #endif
>  #ifdef CONFIG_FAILSLAB
>  	&failslab_attr.attr,
> -- 
> 2.53.0
> 
> 

-- 
Thanks,
Hao

