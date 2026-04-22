Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9ABBF94CB8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17316B0005; Tue, 21 Apr 2026 20:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8FD6B0088; Tue, 21 Apr 2026 20:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7326B0089; Tue, 21 Apr 2026 20:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867956B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:04:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3545E5EA51
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:04:24 +0000 (UTC)
X-FDA: 84684244848.01.8CE4FDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67D1B18000F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:04:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBKpq4Ri;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776816262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyFXOnQJD+SE1aXmmpG0tFwtlVbifztAnMEy8oM1Qdk=;
	b=mLnoI1kPvrHOTOOnMgdJeYpQRLGU1FvOnzQdnJJF1hZQKgcHfG4wkPPKbZZdchSpGSqPq7
	xOWbCe2TFNHBHmnmkng42pR8/240oG9l8UsNDnF2VKKTh62EvFWnYxIz6gRq1+WViYP1qq
	F+/wf/y8hxE8eXbv92E9Oc3xbJpSkbM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBKpq4Ri;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776816262; a=rsa-sha256;
	cv=none;
	b=2MmTyYANjrSsW6U7OzqYVg/P/wahMBUM/T2C0tVrRK5Z1kEpc7OBFolANb4rJfZ8MoJblK
	ogjGcfiKN0A9TZ924XS7gZ8TUOE2nfBA6fDvgrwsF6ZHCdMiAkJ3pWSXaBmNVVanf+kIJX
	4e30L556YvEXKFKKzyhf+RLEn8iWXcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B3E44333A;
	Wed, 22 Apr 2026 00:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0DBC2BCB0;
	Wed, 22 Apr 2026 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776816261;
	bh=9ekNMYG1ueA6DRKcP2+h190TCk2iD3f7GbOIq6R0Rx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBKpq4Ri8DnC2nEpT43E5G1QGKx9IwTmWUpLqLt1Zk0fbc9m0tAKHCVFd8Jlrj5Yl
	 eR3lU25f8ufT9WVqbi/Xdap79sa7Crhoo0ghFk2EZ2JO22L6ml96mmYWu2WCHYBr1Z
	 JM2Ya3lXweqpAlwVK2rs6xUd4B5umt3HO39yoSYTc0lJpKbVaBaKoXrg/3lYikt9Ih
	 iW2VFh3M9Xs+bm2i5M4L6H64sSWCHVprbEO1ZZgJJTB0RT22npXjbezKHMlN5sMPLC
	 uYcBh+udE9pu3Pbsi4uHRBN87wKn9u+I/WrkoogNx/YhpQ5mPTJXqb44JkHaqFJFjw
	 unMzfm49Pel/g==
Date: Tue, 21 Apr 2026 17:04:19 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: tj@kernel.org, cl@gentwo.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v3 3/3] percpu: Fix hint invariant breakage
Message-ID: <aegQgyf3KuIZMK9x@palisades.local>
References: <20260410174417.1450834-1-joonwonkang@google.com>
 <20260410174417.1450834-3-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410174417.1450834-3-joonwonkang@google.com>
X-Stat-Signature: o757hf5rkxkiczw834fhjhdeosecj7ub
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67D1B18000F
X-HE-Tag: 1776816262-243009
X-HE-Meta: U2FsdGVkX1+iFIGqRqam+v7CRWXKI2YVLa/qkmU5k11w83sx+VfZgA5A8qrhpj5UoAQM6SBiZ695WZkkVOgAsynEXY6OCzbeM7e1ZTBk2sdqoUh+CZOB/fOmq954QV/bk+xkgZ+3TKc83Ug2gjaP+Q4NiRPfH21EiRFyrgrXhalMSsMjw0xXGNp+L0QqM3aAHh4bg36sH2APrnNDc4eb38JZcrXiliyO+0YDgyvThm4LxVWISRUSGSvWPfk91p0+dUrGB2ESeQs4GRIn3ngwDiBkJgtdn8XtiK668dPfOKO3f8GFdhwFbmfTZ5cbhvOrbuZiIEN/B4AeFw3cEsmY/jA2Erkg88SdX2SEhmB76ezQSus0CQG8KxfER8nIElHaqgY+flFZRu3T5G7JCDTU6naeK5eCVFuKZw0mv9+eY3NnqRveXAIrAEm6XH8gCCtqB/r6qZSK/wfcJgE70JxvqM8AkjH1Bg+2IT8OZUWuE6ikALvQ6bp31OOzCFYLjnq+J7bWO8wIPOxycNk468jhNDWKtknaPPI32II9gqrJ3zhMeK79oVFvaaUMxjnuFu0Z4ag6rEvlDgCzoPtJfTVKwvWWvcmJ9nUh/HV4qP6uEpFr1iV3X1kahwVo338U1K8XDQu5mV4tbJBNAcgdPxXPKbIIBd7TgYSc6/psZsHcRY6JqIZPJX0SrOJ50nq3yvrbHP0h9U1PLLw/dNVN2EdyNkeQjVPbBL42EEiNi1xkGoPVEQA+ghlk9Sgi2Ve34b2/onppfuNE7/H+MZ//k8lh4O/rJdaxcgBoflFpWMcBBl6mNpfUyh71cgJFeNeD430HP2O7h8l08RKG071TUhK/5B1cOM7lvdYMQhTR51wI7DO5weJ9eFkOWREcp2cQ0eOHzqPZXq4KInDfDJtAh1l32RgX8UxpUpJvUYURZmxHgq6mfnawXXbHoux4k8gcP51ph2tW89pEuTCwnD9scju
 lJbAm9aV
 /L5N6YLaPIqYyNqbDHp8aMxKneYaEEFwLddm1t36qOGjvABzH6g/YBBIAkXMso31CirQSoFkbvAeckZR0HfXV4Mxwt+nbdJ2HJ87bwF/osKesBURfxtr8rjgrtD5qwpULCgujwTR4SUolL1t7vt2Rvqhm8vdjkfXOW9uENlXqvH+mpFbVgN6dT8m+g74bTzGOXIS0sKrjdl4FCb7CjxSyKemiC0zoHn9CcVaDKi57O1CupFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 05:44:17PM +0000, Joonwon Kang wrote:
> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 
>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping the old value.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be not updated to the new contig.
> 
> This commit mainly fixes this invariant breakage and includes more:
> 
>   - Refactor the percpu block update code to make it more visible on
>     what to consider, e.g. when the new contig overlaps with the old
>     contig_hint or scan_hint.
> 

Could you please split this up between the fixing the scan_hint issues
and then refactoring. That way this commit isn't doing too much.

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
> v2 -> v3: Merge the new contig with other hints when it overlaps with
>   them and treat it as a whole free region instead of a separate small
>   region.
> 
> v1 -> v2: Consider cases where the new contig overlaps with the existing
>   contig_hint or scan_hint.
> 
>  mm/percpu.c | 130 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 90 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index f16533ed4a49..d5b0b4863ffe 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -629,7 +629,27 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
>   */
>  static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  {
> -	int contig = end - start;
> +	int contig;
> +	int scan_hint_cand_1 = 0;
> +	int scan_hint_cand_1_start = 0;
> +	int scan_hint_cand_2 = 0;
> +	int scan_hint_cand_2_start = 0;

I'm not really a fan of this cand_1 and cand_2. Re-reading all this
code. I think I really should have introduced something like:

struct pcpu_region {
    int start;
    int size;
}

It's really easy to mix contig_hint and contig_hint_start. If you don't
mind, it would be ideal if we could introduce it but it might be a
non-trivial amount of refactor.

I'd say the shortest path forward would be to do just to fix the
scan_hint issues.

> +	bool overlap_with_contig_hint = pcpu_region_overlap(start, end,
> +		block->contig_hint_start,
> +		block->contig_hint_start + block->contig_hint);
> +	bool overlap_with_scan_hint = pcpu_region_overlap(start, end,
> +		block->scan_hint_start,
> +		block->scan_hint_start + block->scan_hint);
> +

This one isn't used again so we should probably just inline it.

> +	if (block->contig_hint && overlap_with_contig_hint) {
> +		start = min(start, block->contig_hint_start);
> +		end = max(end, block->contig_hint_start + block->contig_hint);
> +	}
> +	if (block->scan_hint && overlap_with_scan_hint) {
> +		start = min(start, block->scan_hint_start);
> +		end = max(end, block->scan_hint_start + block->scan_hint);
> +	}
> +	contig = end - start;
>  
>  	block->first_free = min(block->first_free, start);
>  	if (start == 0)
> @@ -646,56 +666,86 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  	}
>  
>  	if (contig > block->contig_hint) {
> -		/* promote the old contig_hint to be the new scan_hint */
> -		if (start > block->contig_hint_start) {
> -			if (block->contig_hint > block->scan_hint) {
> -				block->scan_hint_start =
> -					block->contig_hint_start;
> -				block->scan_hint = block->contig_hint;
> -			} else if (start < block->scan_hint_start) {
> -				/*
> -				 * The old contig_hint == scan_hint.  But, the
> -				 * new contig is larger so hold the invariant
> -				 * scan_hint_start < contig_hint_start.
> -				 */
> -				block->scan_hint = 0;
> -			}
> -		} else {
> -			block->scan_hint = 0;
> +		if (!overlap_with_contig_hint) {
> +			scan_hint_cand_1 = block->contig_hint;
> +			scan_hint_cand_1_start = block->contig_hint_start;
>  		}
> -		block->contig_hint_start = start;
> +
>  		block->contig_hint = contig;
> +		block->contig_hint_start = start;
>  	} else if (contig == block->contig_hint) {
>  		if (block->contig_hint_start &&
>  		    (!start ||
>  		     __ffs(start) > __ffs(block->contig_hint_start))) {
> -			/* start has a better alignment so use it */
> +			scan_hint_cand_1 = block->contig_hint;
> +			scan_hint_cand_1_start = block->contig_hint_start;
> +
> +			/* Start has a better alignment so use it. */
>  			block->contig_hint_start = start;
> -			if (start < block->scan_hint_start &&
> -			    block->contig_hint > block->scan_hint)
> -				block->scan_hint = 0;
> -		} else if (start > block->scan_hint_start ||
> -			   block->contig_hint > block->scan_hint) {
> -			/*
> -			 * Knowing contig == contig_hint, update the scan_hint
> -			 * if it is farther than or larger than the current
> -			 * scan_hint.
> -			 */
> -			block->scan_hint_start = start;
> -			block->scan_hint = contig;
> +		} else {
> +			if (!overlap_with_contig_hint) {
> +				scan_hint_cand_1 = contig;
> +				scan_hint_cand_1_start = start;
> +			}
>  		}
>  	} else {
>  		/*
> -		 * The region is smaller than the contig_hint.  So only update
> -		 * the scan_hint if it is larger than or equal and farther than
> -		 * the current scan_hint.
> +		 * Consider only when the new contig is larger than or equal to
> +		 * the old scan hint.
>  		 */
> -		if ((start < block->contig_hint_start &&
> -		     (contig > block->scan_hint ||
> -		      (contig == block->scan_hint &&
> -		       start > block->scan_hint_start)))) {
> -			block->scan_hint_start = start;
> -			block->scan_hint = contig;
> +		if (contig >= block->scan_hint) {
> +			scan_hint_cand_1 = contig;
> +			scan_hint_cand_1_start = start;
> +		}
> +	}
> +
> +	if (block->scan_hint &&
> +	    !pcpu_region_overlap(start, end, block->scan_hint_start,
> +				 block->scan_hint_start + block->scan_hint)) {
> +		scan_hint_cand_2 = block->scan_hint;
> +		scan_hint_cand_2_start = block->scan_hint_start;
> +	}
> +
> +	/* Make scan_hint_cand_1 be the best candidate for the new scan hint. */
> +	if ((scan_hint_cand_2 > scan_hint_cand_1) ||
> +	    (scan_hint_cand_2 == scan_hint_cand_1 &&
> +	     scan_hint_cand_2_start > scan_hint_cand_1_start)) {
> +		int tmp_hint = scan_hint_cand_1;
> +		int tmp_hint_start = scan_hint_cand_1_start;
> +
> +		scan_hint_cand_1 = scan_hint_cand_2;
> +		scan_hint_cand_1_start = scan_hint_cand_2_start;
> +		scan_hint_cand_2 = tmp_hint;
> +		scan_hint_cand_2_start = tmp_hint_start;
> +	}
> +
> +	/*
> +	 * At this point, it is guaranteed that none of the scan hint
> +	 * candidates overlaps with the new contig hint while they may overlap
> +	 * with the old scan hint, and that the first candidate is larger in
> +	 * size or, it equal, farther than the second one.
> +	 */
> +
> +	if (block->contig_hint > scan_hint_cand_1) {
> +		if (scan_hint_cand_1_start < block->contig_hint_start) {
> +			block->scan_hint = scan_hint_cand_1;
> +			block->scan_hint_start = scan_hint_cand_1_start;
> +		} else if (scan_hint_cand_2_start < block->contig_hint_start) {
> +			block->scan_hint = scan_hint_cand_2;
> +			block->scan_hint_start = scan_hint_cand_2_start;
> +		} else {
> +			block->scan_hint = 0;
> +		}
> +	} else if (block->contig_hint == scan_hint_cand_1) {
> +		if (scan_hint_cand_1_start > block->contig_hint_start) {
> +			block->scan_hint = scan_hint_cand_1;
> +			block->scan_hint_start = scan_hint_cand_1_start;
> +		} else if (scan_hint_cand_2 < block->contig_hint &&
> +			   scan_hint_cand_2_start < scan_hint_cand_1_start) {
> +			block->scan_hint = scan_hint_cand_2;
> +			block->scan_hint_start = scan_hint_cand_2_start;
> +		} else {
> +			block->scan_hint = 0;
>  		}


This seems easier to invert and do something like this:

Probably something like:

bool overlap_contig_hint = pcpu_region_overlap(new_region, scan_hint);
bool overlap_scan_hint = pcpu_region_overlap(new_region, scan_hint);

if (overlap_scan_hint) {
    scan_hint = 0;
}

if (overlap_contig_hint) {
    contig_hint = new_region;
    return;
}

// Now the new_region is distinct from the contig_hint and then can do
// the standard logic here.

if (new_region > contig_hint) { }
else if (new_region == contig_hint) {}
else {}

What do you think? I think makes cand_1 and cand_2 not necessary.

>  	}
>  }
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 

Thanks,
Dennis

