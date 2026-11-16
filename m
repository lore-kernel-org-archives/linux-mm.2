Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AA1606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0jw9fXxI
Received: by kanga.kvack.org (Postfix)
	id 098426B05B2; Mon, 16 Nov 2026 11:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BB26B05B3; Mon, 16 Nov 2026 11:24:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD476B05B4; Mon, 16 Nov 2026 11:24:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0EB86B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:24:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AA821C0941
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:24:15 +0000 (UTC)
X-FDA: 85441504470.22.72FE5AC
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C60814000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:24:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0jw9fXxI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794846253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNVIeOzB69ilTH3ioRuYQN+cPyApe99ydTzfT+pQ3J8=;
	b=7kLVT1N1dj4cA+S7IDW8SymFZMXHNTUheenGnDKQqF+5clmzEF6TMfgo6u1doFtH/gFIpM
	Dx0MurQovt8SZG4j8FSbF45LjTKMipoAd5ERKMOb86Z2evH73H0hJ/XOEiUsZMFP+cum+U
	x+W87n1/oUsclJnxmjbHloFb9ad1eik=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0jw9fXxI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794846253;
	b=GBrbv1eaS0S1cxnLMa1jKIgsgQZ6oOtmhyu9K/nqgLD8f/aoCymtTQdCsyzZLckoFmuBDZ
	4wOO9actT4ZAU7Lo4jPMxyFs+PxPsF/lroQ6u/u5Mlz/fKoS94jPCqDD6NYqJSAlXoV0vK
	Rz4er8gVjrISAL0jm5WkKG5LlWCKLdM=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cddac941ed1so1689857a12.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794846252; x=1795451052; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BNVIeOzB69ilTH3ioRuYQN+cPyApe99ydTzfT+pQ3J8=;
        b=0jw9fXxIExss6BiwYLTXXNkFzYtytWuL6p3X8kKkhwjtgrp8dAoib7XR+wyY30wNcE
         Ol8FNZfzacPEzxcbjc7HjGKvWuGg/GDXGZxdtQIvGv/pcFGJueN0/E52Z03YV+kdk6C7
         niC04KYm+na5cXs3FclRDzZyb0jJ/ZwORWmQhk+ffy54WvlG/wMpDPZeLD1mge6hxaWW
         9q9U8aX4bc0cANb89tyy61RHAYRy68jcPWNeTgBECksdTYZurvxSdFWRPcnRpOKvQqwu
         fZX5sXSYj7ciTX0M9YmHD9uIyf29NFUnaynNB9AF36Y1xFHA978XXHV/sxVkS1WVBTQN
         ZGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794846252; x=1795451052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BNVIeOzB69ilTH3ioRuYQN+cPyApe99ydTzfT+pQ3J8=;
        b=XXE/zxASprrdnGR+PYQu5VXbtPkZeN6Vd3suTOFtdMI5aqxnW4gcr3BCxfrht2pXCe
         dYrzkR9rqfeVhcl41YrjUkrbDE+iEm4fKYfTBYkR+m7+SHc6GeFl3xOyV6dXA6sQwsKn
         2rnT0yI6cFn+Mq4oI/NdNp1D7F9TuAVXrv1zUUf0lFdIgK4tYed5O3GDZmBqFmH+janL
         gr8c3KeOQoQe+EjdezjwCdqJw8kqF+yX4mEtf83WojFHzBzSiKiERna8YLlJERfvAj12
         YWz3C8JMzISdto6zvrNpDwbmsJzEGpG7sGQoCIoOMMOr2EVzNaxPkx9gAVX3QHhxL7qX
         4M6Q==
X-Gm-Message-State: APuU4Z/bs/An1z4dzfvq+7MfyQ4hb7ldD3wy8CtlR7teA+8pg57zooE0
	6q2KJEHomKh4ZxCwoI2HtjmhTl9rFa9tDyj4wUp5dFUOgKYiQfWJrh76U3nHEjuvi0s=
X-Gm-Gg: AZFdTZd3z7Sj0YubfUKzBWdEUTe28pbwixDCMgau24fxY6XRxJuwpyTKuo9lddspu9p
	p7KiZHRon787ZioPYFcCddFQlPHae2t59MECa8kFqACKhwlEGbDl1WHoCmsbRoKn9adzkJFQg22
	B9hw5BZBtW1k1fdD3y+nuxR8maaSUcrfOiotrA2n9QSTTP3gKhwYXo2hcFIIuL0y1FpEubvnC1N
	baZK5KnidWDFct+/C+x8Fm4qbN0wyVwWCOW5k8Du+smKs6btqEplHTpCZIFUgxbdlUjTm2Yc7Xc
	zoBsNFLBXcQht4sBqPrK3hN3alXvBtyIkNI4Ev/yXGNMwoJklQ1MBTTjHaUQOnknT+f+ofz58OS
	DzPkACgtXNgCgA+sSm5HeSh5A48n+Ndeh+/rMgKQWyWeD+nJumyGqqA5Lc/RKGiVfPHw+8Au/5X
	QXxXKCw9MFYWViPWNjJ9ChrXCCwg1aQnujNucVr/DNhIf5WkKmdnYM7BzjHTtcYfpe7MMErODS8
	BFqVVqLnBm8AK0PnpfEVGk8U7WibmsKq20luNRKuwqW6DsdSLBSz2AlQ+EC7Sw9RmLJ8dTnakV4
	V+yqNo84DSrGBalZROstWOQF10HCBYIkLrKfQIccBiiuCSvin4vdv2hxEEUCGuUwog==
X-Received: by 2002:a17:90b:274a:b0:3ac:8ee5:e007 with SMTP id 98e67ed59e1d1-3b1b0a0c4a3mr8941458a91.20.1794846252089;
        Mon, 16 Nov 2026 08:24:12 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d27cf1sm23490049a91.12.2026.11.16.08.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:24:11 -0800 (PST)
Date: Tue, 17 Nov 2026 00:24:03 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v3 2/4] mm/mglru: add PUD-level Bloom filter state and
 generic helpers
Message-ID: <avq-hc6E4Urpf6x4@KASONG-MC4>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-3-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113084953.412919-3-baoquan.he@linux.dev>
X-Rspamd-Queue-Id: 6C60814000B
X-Rspam-User: 
X-Stat-Signature: 7phfb9pbkwxxhwye795siespyrehw4zb
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794846253-714774
X-HE-Meta: U2FsdGVkX194rOcXum/+OWfSjmvdPuXM4qvEy4tdSSz3WXzQEAQVO7LhfEZvbdKIJtJ9cWKhs2LP5ynqOwnTtjxulJbFBe/W1mRnJXWGHnC24D2HekwEYq7XgTeGQQu05vfNN5YySFFE4RQ4cd2anEuzaAtclzoQ/Tny/Xb2UfERza3T4lR/C5zK3PsKMWgqzzrx6N+4s2uRKqFCBMMNdvWFcsdiFiQKGJ2+TeVHcWA4qZjD8bWsgeixixNjkms/JEP6Nd9u92Dc5UbpH+uaUkIR6tV6PnA8eBFhx6pOrNqxBjc7M5ikVQtr3EJCMQH3A1R8Ewwa4BR367RopbXmfjbcRIAR8CKaQ3HtQvCOcIMKnO6zuT7AlBodMq6dc01QQ/JgrqFrIs/VOCub5nwFeY2pAOXgJX4m50jiTbsw1gCh0YJmeKSbfNWc+MHHBWiJ4ZrsiEBBkjZR/3BOhVQb8c4Oiw9yDJErl2wwoAaxDo8/unnVv/fMkh53Ei9c2seHAF4gbSdAUUy3hir8EkZmehBPsJbT8J0suD/PNQY8xIK5LP4MEihPd1TjmJ7wzV+qbbcRG+S3rsNV8dxl2I9UIchJPPGSrm9f4HhuUCiyaPF8tY+RQLa60Tx3/IKyT4dygUo8qApXy646q+QtgK1qJpNYqzUOp7l7EY1sYlErc6nx7CquJtKZxV+hqebgv2RhWBF3pjXDZARt+Xy3OfBH6BPFLBhYKkrQC7Xk7xarDZgyH0eB0OAUL28Cy6qUFFf4TYm9ksp5gEHOBvH3mXR7Ox5lb6zWMltqdFhEaFPoA6SxF+yXGXOuYJRNDW8zGpPKgrWxbTuivyN8Zi/bVQBLtsshnBiGTJu9HUYM8/gLcagglLeswygQ/KzLnnkh8Ddt/JmhfdSn1i6546LlCXqKM9p+K0L5/az0ho9XyPxvtB5QAU/QEzcbG2IxMIuYsQGcB4JRoRrAnjyRTp+Ryxi
 qR90f0aj
 1Y3qS034Eb0xRE8KEgu16LpVgae18ejGcYGUhmyH6/8pYL4rFhKo/CAVaN929z2Rbuotihx5PU2mSRBlfWr7XKFwevwnc3MTr6opBbicnege3My1NjqEJNZPftqIIu9RfwkOhzrQLpEviVLlyRljVO/c6NNjjbySYjVKHn0k0yVblkBpTNyjAOtP1Hz6tV2Fg/G1byyb662r/3ct9CPZjTSX3xzDI4yF1pJ5gLVKzGXG5whKo6tnoq5ZGY/we+/3unDI5jIGbovPsigIqZkejRsduhcUbSjsFPxWmDbDi6yAi0VGO8TPbOeNY5RLgkdIOmqkeW4e49Ct22AxXmlH2+uWaagVVRQR8fQgKR5OxCj1r2uJHYbgn4YPZmBttURUcV+6j1JUAkarHHaYjZ1xdrODnxXgUb0fFonIg6JOBVbjJ3MATWHf7kBtlBqM+5vBvVZGDNnqoEUMVnXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 04:49:51PM +0800, Baoquan He wrote:
> From: Baoquan He <hebaoquan@kylinos.cn>
> 
> Generalize the Bloom filter state and helpers so that another filter
> level can reuse the same hash, double-buffering and reset logic.
> 
> Replace the PMD-level filter array with a two-dimensional filters array
> indexed by level, and add BLOOM_FILTER_PUD and BLOOM_FILTER_PMD. The
> PUD-level filters operate at PUD granularity and generalize the
> suppression one level up: when all PMDs under a PUD fail the PMD-level
> filter, the whole PMD iteration can be skipped. Cross-node empty walks
> are the most visible case: a foreign mm's PUDs have no young entries for
> this lruvec, so the entire PMD iteration is pure waste.
> 
> The existing PMD-level code now goes through the generic
> test/update/reset_bloom_filter() helpers.
> 
> No behavior change yet; the PUD-level filters are populated and used by
> the next patch.
> 
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

...

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 98037a562ab6..9dbb3f477d7d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2798,6 +2798,10 @@ static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
>   * walk_pmd_range(); the eviction also report them when walking the rmap
>   * in lru_gen_look_around().
>   *

Not a problem for this patch, but the comment above may want an update
in the next commit. This describes things only at the PMD level, while
the PUD level, the ~1/5 and ~1/2 FP figures still hold for (same m, k
and n). But the PMD false positive only causes a wasted PTE walk if
the PUD gate also passes, so the effective FP rate is weighted by
the PUD part too.  The PUD filter has its own FP, which is rarer but
costs a whole 1 GiB subtree, so maybe the 4 KiB bitmap for PUD
is not that obviously oversized (despite the PUD number are much
lower than PMD we are using same sized bitmaps).

> + * A second, coarser pair of filters sits one level up. The filters are
> + * indexed by level: BLOOM_FILTER_PMD for the PMD-level filters above, and
> + * BLOOM_FILTER_PUD for the PUD-level pair.
> + *
>   * For future optimizations:
>   * 1. It's not necessary to keep both filters all the time. The spare one can be
>   *    freed after the RCU grace period and reallocated if needed again.

Still not a problem but this optimization is more important now. We have a
extra 8KB peak overhead per lruvec if I did the math right, not too bad
as there won't be too many of them, even on large machines (memcg number
is currently hard limited to 64k and they are lazily allocated). But
worth mentioning and optimized later.

> @@ -2823,14 +2827,13 @@ static void get_item_key(void *item, int *key)
>  	key[1] = hash >> BLOOM_FILTER_SHIFT;
>  }
>  
> -static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> -			      void *item)
> +static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)

There is only one caller of this (test_bloom_filter), do we really
need the __ version?

>  {
>  	int key[2];
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = READ_ONCE(mm_state->filters[gen]);
> +	filter = READ_ONCE(filters[gen]);
>  	if (!filter)
>  		return true;
>  
> @@ -2839,14 +2842,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
>  	return test_bit(key[0], filter) && test_bit(key[1], filter);
>  }
>  
> -static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> -				void *item)
> +static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)

Also this one, only one caller, the __ intermediate layer seems unnecessary.

>  {
>  	int key[2];
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = READ_ONCE(mm_state->filters[gen]);
> +	filter = READ_ONCE(filters[gen]);
>  	if (!filter)
>  		return;
>  
> @@ -2858,12 +2860,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
>  		set_bit(key[1], filter);
>  }
>  
> -static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
> +static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
>  {
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = mm_state->filters[gen];
> +	filter = filters[gen];
>  	if (filter) {
>  		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
>  		return;
> @@ -2871,7 +2873,25 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
>  
>  	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
>  			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
> -	WRITE_ONCE(mm_state->filters[gen], filter);
> +	WRITE_ONCE(filters[gen], filter);
> +}
> +
> +static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> +			      unsigned long seq, void *item)
> +{
> +	return __test_bloom_filter(mm_state->filters[level], seq, item);
> +}
> +
> +static void update_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> +				unsigned long seq, void *item)
> +{
> +	__update_bloom_filter(mm_state->filters[level], seq, item);
> +}
> +
> +static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, int level,
> +			       unsigned long seq)
> +{
> +	__reset_bloom_filter(mm_state->filters[level], seq);
>  }
>  
>  /******************************************************************************
> @@ -3114,7 +3134,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>  	spin_unlock(&mm_list->lock);
>  
>  	if (mm && first)
> -		reset_bloom_filter(mm_state, walk->seq + 1);
> +		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
>  
>  	if (*iter)
>  		mmdrop(*iter);
> @@ -3771,7 +3791,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
>  			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
>  		}
>  
> -		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
> +		if (!walk->force_scan &&
> +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq, pmd + i))

This looks nice.

>  			continue;
>  
>  		walk->mm_stats[MM_NONLEAF_FOUND]++;
> @@ -3782,7 +3803,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
>  		walk->mm_stats[MM_NONLEAF_ADDED]++;
>  
>  		/* carry over to the next generation */
> -		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
> +		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
>  	}
>  
>  	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
> @@ -4417,8 +4438,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  
>  	/* feedback from rmap walkers to page table walkers */
>  	if (mm_state && suitable_to_scan(i, young))
> -		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> -				    pvmw->pmd);
> +		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
> +				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
>  
>  	mem_cgroup_put(memcg);
>  
> @@ -5981,6 +6002,7 @@ void lru_gen_init_memcg(struct mem_cgroup *memcg)
>  void lru_gen_exit_memcg(struct mem_cgroup *memcg)
>  {
>  	int i;
> +	int level;
>  	int nid;
>  	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
>  
> @@ -5998,9 +6020,11 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
>  		if (!mm_state)
>  			continue;
>  
> -		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
> -			bitmap_free(mm_state->filters[i]);
> -			mm_state->filters[i] = NULL;
> +		for (level = 0; level < BLOOM_FILTER_LEVELS; level++) {
> +			for (i = 0; i < NR_BLOOM_FILTERS; i++) {
> +				bitmap_free(mm_state->filters[level][i]);
> +				mm_state->filters[level][i] = NULL;
> +			}

So just a few nit style and comment issue from me, rest looks good, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

