Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488CDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D1D6B00AC; Wed,  1 Jul 2026 10:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424586B00AD; Wed,  1 Jul 2026 10:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313FA6B00AE; Wed,  1 Jul 2026 10:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4DD6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:19:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8601F403D1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:19:36 +0000 (UTC)
X-FDA: 84940415952.24.27BFC7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C74994000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:19:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2KINf3V;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782915574;
	b=SYlGmnRPCRTmD7UuqVAxaFnx+jL78iIkgx6fCbp5I2vfS0KI4uArGRLRRV3HT+g8GuXdy3
	gSikrQ1dPfMKDO6WTUTLhDa6FrXH5FtnqFsRfsWxrW1tcaoyP6DyIGSvv2E1LrJ5x2GelU
	Dxt+YKpJTWyDnvMhdW9vjVYg8VmxbdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782915574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOUkswbMpitaC9XqYtHuhGX0wM7bLzU8hELdL4wIQ6Y=;
	b=5tpN7ce5fAdaElo9qB0mVveivLSl56E7+sieGxa63D7UfghIWXfriYMgWipwuBr3MDknak
	Vmx8d+CgSl3eyikBwvMXrdO2RJO6r4AXnDgL7Ctq2fPd9Bj8FPmxWGI6X5uwOpjfOpOTKo
	tWvt+2m1Ux3o1VTEAOwrKXj/+u56AUg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2KINf3V;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C8A9601DE;
	Wed,  1 Jul 2026 14:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FD01F000E9;
	Wed,  1 Jul 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782915573;
	bh=EOUkswbMpitaC9XqYtHuhGX0wM7bLzU8hELdL4wIQ6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R2KINf3VwgEUuNEE4lwK7hn22uFbqQ+VVBAhaGY52+ZgQGMrf1uGFdx9bHlH0kFg+
	 2ZwsuKLEZ34AHZpZi2FBUvI0237rVsgP45ULis7AN8Mfi3fUoV7UW8QGcJdFSqKJz4
	 EMv6RFzPfqDOgbfsbindi3TuE4MIG7XdbK2puwLUGF0tEFmwFg1CNe8luBjNq8O6Ph
	 UXhI6Y7o7gqxSIl0My6qxVDWCy9eg/hqIaYKoxIY7c5wkFZM2qYtqw5+4vDif0tMFl
	 T9ojQXvZfkkzLryK6IxnGc1P8lQp6qtavyDwWTyJ+aCvrWoxO86yEy0WRyjP3NDwxZ
	 yUrgBINkTXLrw==
Message-ID: <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
Date: Wed, 1 Jul 2026 16:19:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626182215.1107966-3-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7mwt9sjsmadsjjh4xtxwjykxgppfz386
X-Rspam-User: 
X-Rspamd-Queue-Id: C74994000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1782915574-947824
X-HE-Meta: U2FsdGVkX18Bti+AkzAhQTZs/9j9cRM1esYG3yjYVkvtUJHSDtuWd5iHRTq7CH4RmPiuj7DzZl8zUrCWTF3wWNYLsq68HgqerD6zWYAo/5UIbbgNrpbJ2bK4a5xWS8zpEjYW9lXeSNAgbtiNlM+xOKRaEviUwoAcPr5aC8uyHIjkoZo6F3x63K8Co67iBfH7CVWTIk9eZHSERsk9JzMuIkH7K2+CFgBB4prfDmw+UbwPUPLbHYwpjMouH75M1G23vvo+5iIwHd4Y0VkuaBZQdcNHDmodHlYIUvgGVZDVvJUzXnvn92M25UoQEYo0elOSm3AHqTq1Xqm2rgHEG/jZa0RhfwcILwCNASexjivH+tB3mqkbgeRu3uQa+SPwgm6JXpSH8ERRoybu9+o/a0+rXGzfP3KxtwQmDwL/vQvYRNaJL4LsxkeDt8Ui0NouyVmxSl5IaavnJHWxYj6deVkNZVomcc6VqksKH437wM5s3JOJ4RwCgU2+VKUm90SCEWrZv8eI7Q69hJJRpjoNaj6Ry+gPveQLi80bTqQY6uUoff082PFyWIpVfeJPyHjOPW/CqHzdMmlGkBrj6htVdpiH9sJUpDshEwo/rMd6JnIrA9s3d+27gs4rPq2b/X3sdsHwECduKBeNQg7b4yzXIOtKMfvwUR7cMMK8BKdzeva6ylc1lW18D5LqBOHoqRs30xA38enMUNDR5PkCWIW4eJG1WEmdJzdi0K1Fn5oa6unV5QwiE7X5mFrz846Fol29RcyLGm8QKrn4n13dm+iE8oE+jt9eloHxVQqN5ApwMZwEYC4jZgPMFMWcwl5/I2Thi4qXIL1CDq4BTGUjYlcssNoFvcLijDSWyhzF/dlbV92tjrEziIDsCZQ+eeFaVV0IXgDx80DaGCEKscEFaR2pypyyr3o0NOHeOsViMMLFEV3vS2dXUeUOo+ZP1owRzmix0LnsyfnDmczsajuTC7Q6kQ6
 aOAfNumE
 wzkOTE+EjUd1+DmsMC44WXqolzs2Lw46Ot6USq9nhGZS9mZFXVKH7YK/qQlNdUDDppDNRqq9W8mNJJFtzNGXUY0SDthSy5YLIzVaheqC0PG5Pnr2jMk53cscJFyL2ZW/gwk5X7vMWaO9Nqhov/xQexWrgocw2dU1f+lmULVWZGcPMt/np90ppxVEDbSqswgkYDvrFdCvQsHu1XRaM1Zd14RJGqOdHCZGZscXEkw6PNEtjviUxQG9VyqmWngITR1mGJKrmGLRpbqgMbcG7TgFx8S3UfTEO7cYY3AdLc3IF0iuo7kzRj0c2zTSiM63A/EGHd/fbjKWWrKbujSoL9KOngZP4Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 20:21, Johannes Weiner wrote:
> While trying to fix a reclaim storm in defrag_mode, I noticed that
> non-movable direct compaction is extremely inefficient.
> 
> When searching for space to evacuate, compaction only allows blocks of
> the same type as the incoming request. This is to prevent migratetype
> pollution, where a small non-movable request frees space in a movable
> block and provokes the allocator to fall back and pollute it.
> 
> This protection is reasonable on one hand, but the downside is that it
> makes non-movable direct compaction nearly useless: if we get the type
> annotations right, by definition there aren't any movable pages inside
> the non-movable blocks it is allowed to scan.
> 
> With defrag_mode, the goal is the production of whole blocks, which
> are essentially type neutral: __rmqueue_claim() will convert them
> wholesale on alloc. This makes type mixing and pollution a non-issue.
> 
> Fix the pollution gates to take the requested order into account, and
> allow whole-block requests to scan blocks of other types.
> 
> The only exception is CMA blocks. That type is sticky and these blocks
> cannot be claimed to other types. Continue to be strict with them, and
> allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

A suggestion:

> ---
>  mm/compaction.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f08765ade014..7df3a85d43af 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1381,12 +1381,33 @@ static bool suitable_migration_source(struct compact_control *cc,
>  	if (pageblock_skip_persistent(page))
>  		return false;
>  
> -	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
> +	/*
> +	 * Background compaction produces blocks for the zone at
> +	 * large, with no particular allocation context. Allow all
> +	 * block types, including CMA.
> +	 */
> +	if (!cc->direct_compaction)
>  		return true;
>  
>  	block_mt = get_pageblock_migratetype(page);
>  
> -	if (cc->migratetype == MIGRATE_MOVABLE)
> +	/*
> +	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
> +	 * else, vacating a CMA block consumes free pages the caller
> +	 * could have used, and produces free pages it cannot.
> +	 */
> +	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
> +		return false;
> +
> +	if (cc->mode != MIGRATE_ASYNC)
> +		return true;

This now stands out as uncommented. Can we come up with a rationale? :)

> +
> +	/*
> +	 * Prevent small unmovable/reclaimable requests from polluting
> +	 * movable blocks through fallbacks. Whole-block production is
> +	 * exempt as the allocator claims and converts these.
> +	 */
> +	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
>  		return is_migrate_movable(block_mt);
>  	else
>  		return block_mt == cc->migratetype;
> @@ -1974,12 +1995,12 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  		return pfn;
>  
>  	/*
> -	 * Only allow kcompactd and direct requests for movable pages to
> -	 * quickly clear out a MOVABLE pageblock for allocation. This
> -	 * reduces the risk that a large movable pageblock is freed for
> -	 * an unmovable/reclaimable small allocation.
> +	 * Prevent small unmovable/reclaimable requests from polluting
> +	 * movable blocks through fallbacks. Whole-block production is
> +	 * exempt as the allocator claims and converts these.
>  	 */
> -	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
> +	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE &&
> +	    cc->order < pageblock_order)
>  		return pfn;
>  
>  	/*


