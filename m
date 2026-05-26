Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4068CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591046B008A; Tue, 26 May 2026 04:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5688A6B008C; Tue, 26 May 2026 04:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5AB6B0093; Tue, 26 May 2026 04:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 394286B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:16:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D090EC164E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:16:01 +0000 (UTC)
X-FDA: 84808862922.12.5E670A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3A12F120006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:16:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKy1A6qK;
	spf=pass (imf29.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779783360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hzo6GX5rRcFHtufIaLcjVCgaMJcIIBZ6kRK4mZklQ4=;
	b=lfE6UIkJZ2tLIHtP72X/Kndec4TFll3L7tcPSl0cgiU8tH/6Yb6soDVl/kNJJh/+uuo7jf
	8ifAh5JZoL3bV7NrfOOCIImKM1kasuqXJriG4qpXD0xOWVw17tOK8dcvxIpSHoHMnCYKhE
	+WmnFF63RgSXyb4zW1h6gka1P0IgQlI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKy1A6qK;
	spf=pass (imf29.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779783360; a=rsa-sha256;
	cv=none;
	b=DtH3v9KD0xHbdgg3bPZAyYM3vsz/jn5djBkUgsQj0Jy4sl4KV9r0NdU0iaCCi1rSMb1Gxo
	kDOJvOakejRFBz0yU0JrVmdcda8LjPZ29m2jm7Bt+s7N2VP8ktVnxlr2oV+KbMHIiZDjTF
	CjcdeHdHohPB2faCRsC/5VQRc7ImeoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C236A6008A;
	Tue, 26 May 2026 08:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11381F00A3A;
	Tue, 26 May 2026 08:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779783359;
	bh=7Hzo6GX5rRcFHtufIaLcjVCgaMJcIIBZ6kRK4mZklQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YKy1A6qKr/MAK+OQQIzxC4g3/trgj36f3drcYO59Bd2584pSZICG0sQM41vyPxTtX
	 nAmYjxXi5BvJxiFNUQqhj7nV326aQ/KWQ9kHFce1OlVXohO2er0TyOR5himQUMQ0Ui
	 I588dQ73RfiZIrCZ2dQ+0guBplOqXBFreN69hiEP4v0FUxICwhkZHjBdmzN5zPFptq
	 HPOlQasMFs5udrXd6/MOkTQHQQrReMonMzxK+pMXVU1OQ9whG00JR9LOm8N3CeGx9n
	 pW8yePugtqFIcKI6YLXCCHOmPG65O3rCJBr3IdkuU+35fT2/Aw9Hqpx5wjUdj4UHTz
	 JI/Sfg8LUh85Q==
Date: Tue, 26 May 2026 10:15:55 +0200
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: tj@kernel.org, cl@gentwo.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v6 4/4] percpu: Fix hint invariant breakage
Message-ID: <ahVWu38ymnSeLnv3@palisades.local>
References: <20260513085117.1024175-1-joonwonkang@google.com>
 <20260513085117.1024175-4-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085117.1024175-4-joonwonkang@google.com>
X-Stat-Signature: npaazg3qq34y95hzy84uksnffydrk14w
X-Rspamd-Queue-Id: 3A12F120006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779783360-441718
X-HE-Meta: U2FsdGVkX1/kf93iVZ098gMfO5dpF47nMwUBaV7NQvTJL8Zigf7k4zn35vgcvB5hVlU8GhrTukc9HS5Se2VoxMkSmy0Re5CS3HJu91KX64csy1VrLs3/E0vly+kh34/E8saC+E6Wc/IuebmaZB0BFcqT1y8VHUcTBOHEXHv1UBKxib/EMKpjmWyS0dmTqRg09UIxTsN0pTc9SyuNzEVFa2Yfg6Ub6OXVpfrJX2dBfsiSi6tlKr2SfQZe4AniUk5iUe9SHV2tHVzziGKLTERbKTCA76BYOCOIWyEoWUBCX130D//oJaDCfwrEAmEtW9t2+LMve+2vyNmQGJLhquz+GfvspCcWAendxtxwbBTC+ftvBzLxOxcUuTvPaysNyxIFNNWfLLS/9YrHUvpTAuVKrMplUYuUKq3ihEIB6JmXVZ4MfTsUznjAbUQwXtAAvKTlz4jupo2IhBq5HF/mEafwDnABVmlP2lEdC+LdN2cMu10nPRr+jdTpEitVJASzcE34stGM7BsUJFabiBJBaNXanklNGscURh2Bsux+KuNvOahJ/xhVcHQyhiS4DkbR8Z/Sep2FlAgszgUcQN8rrp6ug4XVfQRUwEnkqB+HIHVxwASvtRJ2yv3/juXkqmCJzRbpbL2ytUSxcv6gk9QbOuRJRbwnPCG7L/KIUPdx73iSQir6zUXCx+TL/hQsTgqIPSf2UzNdxgwV2q6wltFPr8dGH6fPSqj0+aKmKC7DiaOlAoPaRyoFRX76UgNX5WGJIvVoZPVVpMhNTglRX4GHbombocDGNeB3yKmz8yfFhD35ySS70fIK/URwmsg/8iADm/Vp3RZx/LF0a8ijctuWy1vvUrbtdmsDLjeOb15dgiY/+XLtEHC8CAZdDiIznkfUHUh/0MEVvi+79WB+0pFlyOUS6MwRWRVMwhzNXcV1FfXWbywTwkz9+Gmfu3Yl4GoFD2XGChj2xEkSkQqgrQUZ+IR
 +cOkPC6M
 8B0IC8Vt2JNXtkpN4LLvvQUaKs18OZ7fIiUN1dvpaTR+M2UZ38L2ElNkt+3ABD2cM5LYNw+eHxGIKkRsOqhE4bO3sS63/ub6L589/3ET2x6AcSMoOxMUMKWp5My76Rwxm+R+us5HDsfHohwKNcfuFgKLd1DPrZfu6XU0ZmCRV7d/KLwV+cesQOHIiFUhxybaCjS05CP6w9GF42moKO2McnXylFvJC4JmyBjXqjMCJJxs1OTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:51:16AM +0000, Joonwon Kang wrote:
> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 
>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping the old value.

I think keeping scan_hint should be fine here? I guess what's the harm,
I'm seeing a setup like:

[old_contig_hint, ..., scan_hint, .... , contig_hint]

The large scan_hint just says we should try to bin pack, we use
first_free rather than jumping past it. See pcpu_next_hint().

> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be not updated to the new contig.

Similar to the above, the goal is just to say hey we should scan from
first_free.

> 
> This commit mainly fixes this invariant breakage and includes more:
> 
>   - Handle the cases where the new contig overlaps with the contig_hint
>     or with scan_hint.
> 
>   - Merge the new contig with other hints when it overlaps with them and
>     treat it as a whole free region instead of a separate small region.
> 
>   - Fix the invariant breakage and also optimizes scan_hint further.
>     Some of the optimization cases when no overlap occurs are:
> 
>     - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
>       contig start < contig_hint_start), then keep scan_hint instead of
>       invalidating it.
> 
>     - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
>       new contig start < scan_hint_start), then update scan_hint to the
>       old contig_hint instead of invalidating it.
> 
>     - if (new contig == contig_hint > scan_hint) && (new contig start <
>       contig_hint_start) && the new contig is to become a new contig_hint
>       due to its better alignment, then update scan_hint to the old
>       contig_hint instead of invalidating or keeping it.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v6: Diverge more when the new contig size is the same as the old
>     contig_hint size but greater than the old scan_hint, does not become a
>     new contig_hint and is before the old contig_hint.
> v5: No change.
> v4: Refactor code by removing the scan_hint candidates and handle the
>     overlapping cases where the new contig meets with the hints on the
>     border.
> v3: Merge the new contig with other hints when it overlaps with them and
>     treat it as a whole free region instead of a separate small region.
> v2: Consider the cases where the new contig overlaps with the existing
>     contig_hint or scan_hint. Introduce the scan_hint candidates to
>     calculate new scan_hint.
> v1: Initial version.
> 
>  mm/percpu.c | 118 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 93 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 89b7f33500cf..1a0e1e84d92a 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -616,6 +616,20 @@ static inline bool pcpu_region_overlap(struct pcpu_region a,
>  	return (a.start < b.start + b.size) && (b.start < a.start + a.size);
>  }
>  
> +/*
> + * pcpu_region_concat - determines if two regions meet on the border
> + * @a: first region
> + * @b: second region
> + *
> + * This is used to determine if the hint region [a.start, a.start + a.size)
> + * meets with the allocated region [b.start, b.start + b.size) on the border.
> + */
> +static inline bool pcpu_region_concat(struct pcpu_region a,
> +				      struct pcpu_region b)

Can we name this something like pcpu_region_adjacent(). concat is a bit
confusing as I think of string concat.

> +{
> +	return (a.start == b.start + b.size) || (b.start == a.start + a.size);
> +}
> +
>  /**
>   * pcpu_block_update - updates a block given a free area
>   * @block: block of interest
> @@ -629,6 +643,40 @@ static inline bool pcpu_region_overlap(struct pcpu_region a,
>  static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  {
>  	struct pcpu_region free = { .start = start, .size = end - start };
> +	bool overlap_with_contig_hint =
> +		block->contig_hint.size &&
> +		(pcpu_region_overlap(block->contig_hint, free) ||
> +		 pcpu_region_concat(block->contig_hint, free));
> +
> +	if (block->scan_hint.size &&
> +	    (pcpu_region_overlap(block->scan_hint, free) ||
> +	     pcpu_region_concat(block->scan_hint, free))) {
> +		start = min(start, block->scan_hint.start);
> +		end = max(end, block->scan_hint.start + block->scan_hint.size);
> +		free = (struct pcpu_region){
> +			.start = start,
> +			.size = end - start,
> +		};
> +
> +		block->scan_hint.size = 0;
> +	}
> +
> +	if (overlap_with_contig_hint) {
> +		start = min(start, block->contig_hint.start);
> +		end = max(end,
> +			  block->contig_hint.start + block->contig_hint.size);
> +		free = (struct pcpu_region){
> +			.start = start,
> +			.size = end - start,
> +		};

It seems like you want a function more like:

struct pcpu_region pcpu_merge_regions(struct pcpu_region a,
    struct pcpu_region b);

Then earlier we can call:
pcpu_merge_regions(free, scan_hint);
pcpu_merge_regions(free, contig_hint);

and then avoid introducing pcpu_region_concat().

> +
> +		if (block->scan_hint.size &&
> +		    free.size > block->scan_hint.size &&
> +		    block->scan_hint.start > free.start)
> +			block->scan_hint.size = 0;
> +
> +		block->contig_hint = free;
> +	}
>  
>  	block->first_free = min(block->first_free, free.start);
>  	if (free.start == 0)
> @@ -637,23 +685,24 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  	if (free.start + free.size == block->nr_bits)
>  		block->right_free = free.size;
>  
> +	if (overlap_with_contig_hint)
> +		return;
> +
> +	/*
> +	 * At this point, it is guaranteed that the new contig does neither
> +	 * overlap with contig_hint nor with scan_hint.
> +	 */
> +

nit: ^ remove the extra new line here.

>  	if (free.size > block->contig_hint.size) {
>  		/* promote the old contig_hint to be the new scan_hint */
>  		if (block->contig_hint.size &&
>  		    free.start > block->contig_hint.start) {
> -			if (block->contig_hint.size > block->scan_hint.size) {
> +			if (block->contig_hint.size > block->scan_hint.size ||
> +			    free.start < block->scan_hint.start)

I don't think this condition matters? Wouldn't we want to always promote
here.

>  				block->scan_hint = block->contig_hint;
> -			} else if (block->scan_hint.size &&
> -				   free.start < block->scan_hint.start) {
> -				/*
> -				 * The old contig_hint.size == scan_hint.size.
> -				 * But, the new contig is larger so hold the
> -				 * invariant scan_hint.start <
> -				 * contig_hint.start.
> -				 */
> -				block->scan_hint.size = 0;
> -			}
> -		} else {
> +		} else if (!block->contig_hint.size ||
> +			   (block->scan_hint.size &&
> +			    free.start < block->scan_hint.start)) {
>  			block->scan_hint.size = 0;
>  		}
>  		block->contig_hint = free;
> @@ -661,21 +710,40 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  		if (block->contig_hint.start &&
>  		    (!free.start ||
>  		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
> +			if (block->contig_hint.size > block->scan_hint.size) {
> +				if (free.start < block->contig_hint.start)
> +					block->scan_hint = block->contig_hint;
> +			} else if (free.start > block->scan_hint.start) {
> +				/*
> +				 * old contig_hint.size == old scan_hint.size
> +				 * == new contig size. But, the new contig is
> +				 * farther than the old scan_hint so hold the
> +				 * invariant scan_hint.start > contig_hint.start
> +				 * iff scan_hint.size == contig_hint.size.
> +				 */
> +				block->scan_hint.size = 0;

I think this is the one I disagreed with in the commit message.

> +			}
> +
>  			/* new start has a better alignment so use it */
>  			block->contig_hint.start = free.start;
> -			if (block->scan_hint.size &&
> -			    free.start < block->scan_hint.start &&
> -			    block->contig_hint.size > block->scan_hint.size)
> -				block->scan_hint.size = 0;
> -		} else if ((block->scan_hint.size &&
> -			    free.start > block->scan_hint.start) ||
> -			   block->contig_hint.size > block->scan_hint.size) {
> -			/*
> -			 * Knowing new contig size == contig_hint.size, update
> -			 * the scan_hint if it is farther than or larger than
> -			 * the current scan_hint.
> -			 */
> -			block->scan_hint = free;
> +		} else {
> +			if (block->contig_hint.size > block->scan_hint.size) {
> +				if (free.start > block->contig_hint.start) {
> +					block->scan_hint = free;
> +				} else if (block->scan_hint.size &&
> +					   free.start < block->scan_hint.start) {
> +					/*
> +					 * old scan_hint.size < new contig size
> +					 * == old contig_hint.size. But, the new
> +					 * contig is before the old scan_hint
> +					 * so invalidate the scan_hint to
> +					 * protect the contig_hint.
> +					 */
> +					block->scan_hint.size = 0;

Why would we not take scan_hint = free here?

> +				}
> +			} else if (free.start > block->scan_hint.start) {
> +				block->scan_hint = free;
> +			}
>  		}
>  	} else {
>  		/*
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

I think I'm struggling a bit between what changes are correctness
related vs optimizations vs code readability.

Maybe when you address the comments, it might be good to split this
commit up.

Thanks,
Dennis

