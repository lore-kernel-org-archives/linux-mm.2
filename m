Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA5DC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08BF6B0095; Fri,  4 Sep 2026 12:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE25B6B0096; Fri,  4 Sep 2026 12:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6BE6B0098; Fri,  4 Sep 2026 12:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB3826B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:04:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C5F880126
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:32 +0000 (UTC)
X-FDA: 85176552384.01.2B5FFA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 82EE980012
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKLd9aDj;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788537870;
	b=PIeIuJCD2TgPyptOIxaYexPkboW2DVrv9ZbIHQRjPgtRfoUhzWRItbXQugWbb87kgMjdpy
	DutDMBsjcRyhdJ3v/hxKc87BxZrysIpj1/WDAlrY5wYaZisFke83U1iQraxrPH6LXweda3
	xw40VkFU1omcoRmN7/qkWGv2BID6oqs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKLd9aDj;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788537870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfO05etABMv82BXz4+vLRRcFamVzSGusRFH1mdkPthE=;
	b=DScuQLLhOiVDSOzsoZb6QbY33t9EAMvEkotfz0+rgBLqA9Amxd4PIikO4ztZdL6cXG98OQ
	NPQGLXPC/qxQOEJ+allBBY/eXQTZCWz0vee1q/2EZpn5Fv/1oq0jh+7NL6t0gI3QPxomHj
	SLGS/zdHIfMrAcMNu/mjjb4L0PWlkGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A66BE4168A;
	Fri,  4 Sep 2026 16:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B2D1F00A3D;
	Fri,  4 Sep 2026 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788537869;
	bh=kfO05etABMv82BXz4+vLRRcFamVzSGusRFH1mdkPthE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YKLd9aDjjzXaQ4SfS3x8Hrp3POL1gK2WdY77i3qp+ramm5iyO91UoC/iFAsMbwNnq
	 3RAnVVfnLjNjOv+8Sj1IwZT0Kp77cCf/Iim7UBGVSQVFt+9tlobHceHzhgMbS8XypL
	 Ks0y4rW62Zfjrwc/uSzqErFGK8OkezAc4VreJyl3DQ7yzYtHKSG5aw3Nt9ENi4aHF8
	 Gl6JBit9umqQFGaVMR3re/TRFPoJIRHPU3DZIz6CQIcXE85atIZ/7C/U6RDSin45m+
	 Y9zzZCv6MGim/GrcPxnbPt2+q8Et9Ew9HW8d3MmVh5cu2ObIMVyXcwwK1BuCfCZBoj
	 vOgdB3e/7s+iw==
Message-ID: <b81e9fba-9567-4bd4-ad9a-08c8f03dbb14@kernel.org>
Date: Fri, 4 Sep 2026 18:04:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/slub: make the case handling in __slab_free()
 easier to follow
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260824122513.3829-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82EE980012
X-Stat-Signature: wauk1m5u9zrfjnqqc6gs8fhx4yg8mics
X-Rspam-User: 
X-HE-Tag: 1788537870-143174
X-HE-Meta: U2FsdGVkX1+BNM+zwIfc3KEEa/LCr9kpEpC6zX3k6kA6mSx9LV2Y0VO9o1+DOHmRpcXwe2Ld3pEMaU7orMF/oGvTszLWTGB0bvWKiIpsEBKal9UtpqpbwwFKHRDJnCQcpq/JL9eDuwow7FaM40rhRk3D4ch9ZmvkSlJwToxLDOhmVuEF4uerPRH3GdsFA5k3SC3cccgQNX1cginc775V6nkXHCFZJy8wJiMNbr0Zwk9KDFjFCEcq20VGbAarbXpazjuS/WohmMc5LLShxj7ZpOZUy43+Iq9h3QlGazVqLxXQU9W/luVWrBly9haTd/Vsn0LTQKTeAVrW9rDy1CaDmP1m80nA6zDi206AtnHR9Qwk2AegChFAbN3gMyZYYKUwfeVTOUcZO+/FiE1K3oWhrBWJmqWfUUWFmHJfdbq92CgffI/i8qPFge3/Zn+PqL+TKBiq9msU2iZwWhhBRYdDSmq9ZUFHahQOhCgbLmI9i1ui6PmjmXQBms4D/ONzCkvtei5Gy+khdKY6ZY3ZVx/T9t7DeNMtPIkyjaKKhy/S13pH1xf2cTGl+QJxVQrmBlfpj9Xpp8sT6aeTh/5Isb4LzjYkVTJxRUzLfSjrLIfyuqHrwMiWeA5K98WeItsJ6pQHulVzw6SF//UwfE300H3XcTiICt/E47QdY4RBex3i5BqprNDET3sYk1pED45+3EsBXzSEhKm1MZeWt6VBo365Gh/+Qix9mrFhjnwuf+TCAcmRlbRbbHQZz3CrzbkZL0K65HuhRCgfv354tjFrh787fwyJJIUx4Eb4QSPFrVVFhkUGBngc4d7zOavWl0HJIxWhtXIaM+84uDtminQcP8n4l+gl/VSu1DNbbVN6iereFMYUCP+Vqktm8PGXh5NFL2S8vq3bKz7J6YtH5HjL1/K82qN0few1IvIMsLVPMw3MXwO/C5mZ9GugrSHF/JfZ4p92f+ocAWG9RYBVpLBsFFP
 XgziYsoN
 hP75y4u17QQLKwHM77tuMV3lnqqc0yr9zUl6abxk/KzmBodHieHLHg4xQX99M4/Rxmz4m3YtWIdy0PzxL22aehUApf0oqHYbdReUKL34+er8ZA2hoOb0fo2GcRso8NJRKTXZrauXz3q6E7/tgVUoUwrY1ItDVQH/3Fp7sqqQkw6jqZZKeaiJ9FshxH4szeIykWFqkkFZAEYw8JOLdGQ5Hp5piIrkOAJI4LcMrSFH+8vBtWuaEK6vPLtCk69tAvXpGSKxSAG9DDP12A6nJXumz8FDE8q3I8Lw2DQWKC2ChNfuhlvxSCGVNNk3ym4O4bMc1MQ4atZ8uX6PG1So=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 14:25, Hao Li wrote:
> There are 7 possible transitions in __slab_free():
> 
>   a. partial->partial

maybe add "(offlist/onlist doesn't matter)"

>   b. partial->empty, offlist
>   c. partial->empty, onlist, exceeding min_partial
>   d. partial->empty, onlist, not exceeding min_partial
>   e. full->empty, exceeding min_partial
>   f. full->empty, not exceeding min_partial
>   g. full->partial
> 
> (There is no offlist variant of e, f and g as a full slab is on no
> list.)
> 
> Clarify which case each branch handles, and replace the goto with a
> return at the end of the skipped block so that every branch explicitly
> states its coverage.
> 
> Case 'a' is the only path that needs neither list_lock nor list
> handling. Give it an early continue: handling it upfront is much clearer
> than forcing every other case into a nested block.
> 
> Also, read SL_partial once after the loop right where it is used, rather
> than re-reading it on every iteration.
> 
> No functional change.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> ---
>  mm/slub.c | 95 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 49 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b0cd0572e2f2..e20375307770 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5748,76 +5748,79 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>  		new.inuse -= cnt;
>  
>  		/*
> -		 * Might need to be taken off (due to becoming empty) or added
> -		 * to (due to not being full anymore) the partial list.
> -		 * Unless it's frozen.
> +		 * partial->partial: the slab was on the node partial list and
> +		 * stays there, so we need no list handling and no list_lock.

I think more accurate is "if the slab was on the node partial list, it stays
there, and if it was off, it stays off, so we need no..." ?

> +		 *
> +		 * Note that continue in a do-while goes on to evaluate the
> +		 * condition below, so we do perform the freelist update.
>  		 */
> -		if (!new.inuse || was_full) {
> -
> -			n = get_node(s, slab_nid(slab));
> -			/*
> -			 * Speculatively acquire the list_lock.
> -			 * If the cmpxchg does not succeed then we may
> -			 * drop the list_lock without any processing.
> -			 *
> -			 * Otherwise the list_lock will synchronize with
> -			 * other processors updating the list of slabs.
> -			 */
> -			spin_lock_irqsave(&n->list_lock, flags);
> +		if (!was_full && new.inuse)
> +			continue;
>  
> -			on_node_partial = slab_test_node_partial(slab);
> -		}
> +		/*
> +		 * The slab might need to be taken off (due to becoming empty)
> +		 * or added to (due to not being full anymore) the partial
> +		 * list.
> +		 *
> +		 * Speculatively acquire list_lock before calling cmpxchg(), as
> +		 * performing cmpxchg() prior to lock acquisition races with
> +		 * concurrent paths, such as the shrinker.
> +		 *
> +		 * If the cmpxchg does not succeed then we will drop the
> +		 * list_lock and retry.
> +		 */
> +		n = get_node(s, slab_nid(slab));
> +		spin_lock_irqsave(&n->list_lock, flags);
>  
>  	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
>  
>  	if (likely(!n)) {
> +		/* partial->partial: we didn't take the list_lock */
> +		return;
> +	}
> +
> +	on_node_partial = slab_test_node_partial(slab);
> +
> +	if (!was_full && !on_node_partial) {
>  		/*
> -		 * We didn't take the list_lock because the slab was already on
> -		 * the partial list and will remain there.
> +		 * partial->empty, offlist: a bulk refill has taken the slab
> +		 * off the partial list and will put it back, so its list
> +		 * handling is not ours to do.
>  		 */
> +		spin_unlock_irqrestore(&n->list_lock, flags);
>  		return;
>  	}
>  
> -	/*
> -	 * This slab was partially empty but not on the per-node partial list,
> -	 * in which case we shouldn't manipulate its list, just return.
> -	 */
> -	if (!was_full && !on_node_partial) {
> +	/* full/partial->empty, exceed: we have enough partial slabs already */
> +	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
> +		/* partial->empty, onlist, exceed */
> +		if (likely(!was_full)) {
> +			remove_partial(n, slab);
> +			stat(s, FREE_REMOVE_PARTIAL);
> +		}
> +		/* full->empty, exceed: it is on no list to remove from */
> +
>  		spin_unlock_irqrestore(&n->list_lock, flags);
> +		stat(s, FREE_SLAB);
> +		discard_slab(s, slab);
>  		return;
>  	}
>  
>  	/*
> -	 * If slab became empty, should we add/keep it on the partial list or we
> -	 * have enough?
> +	 * At this point, only three cases remain:
> +	 *   full->partial
> +	 *   full->empty, not exceed
> +	 *   partial->empty, onlist, not exceed
>  	 */
> -	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
> -		goto slab_empty;
>  
> -	/*
> -	 * Objects left in the slab. If it was not on the partial list before
> -	 * then add it.
> -	 */
> +	/* full->partial; full->empty, not exceed */
>  	if (unlikely(was_full)) {
>  		add_partial(n, slab, ADD_TO_TAIL);
>  		stat(s, FREE_ADD_PARTIAL);
>  	}
> -	spin_unlock_irqrestore(&n->list_lock, flags);
> -	return;
> -
> -slab_empty:
> -	/*
> -	 * The slab could have a single object and thus go from full to empty in
> -	 * a single free, but more likely it was on the partial list. Remove it.
> -	 */
> -	if (likely(!was_full)) {
> -		remove_partial(n, slab);
> -		stat(s, FREE_REMOVE_PARTIAL);
> -	}
> +	/* partial->empty, onlist, not exceed: it stays where it is */
>  
>  	spin_unlock_irqrestore(&n->list_lock, flags);
> -	stat(s, FREE_SLAB);
> -	discard_slab(s, slab);
>  }
>  
>  /*


