Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAA5CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB356B0012; Sat, 22 Nov 2025 22:43:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93156B0022; Sat, 22 Nov 2025 22:43:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFA86B00A5; Sat, 22 Nov 2025 22:43:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABDA16B0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:43:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 607E51A0A46
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:43:09 +0000 (UTC)
X-FDA: 84140476098.24.6CF007A
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 876A7160008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:43:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=syNwRJDt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763869387; a=rsa-sha256;
	cv=none;
	b=yU67w3mOMwB4WBEC1OhSHA/Nmgrc6vegw5W6FgU0/Z+nyIZ3zxVLxybZbsgXkCYeIyp6nN
	mU41Wh4unSxemroCWDCeLPeBO0/GkkWTdM3Tehb4Rhdb+OPl9T2kchJxx9FUFKKSmDF01a
	FkTPXbWpoZfyBiIZjQZmUicURAYJwp0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=syNwRJDt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763869387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atGl1KFG9w/JBAL4HGSSXZEw0hkrZacc8aGE0xS3SqE=;
	b=4v84P4O+kV6VQqzA4Nr9ghmVK/7zB6xVq8jDkOwayr6QpRlJSvmoYwEK5GlZnBa+Z6iUNB
	QTzCTK+G1R5o5vZlVZjcaXBba+3s0IGtr84ZtpWf8Q87KklIulhlDWffvJs9FcuBlYkQ0q
	YE8jEXD0V2/2AixQ2MbmRw/xkKxTKB8=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6430834244aso775550d50.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763869386; x=1764474186; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=atGl1KFG9w/JBAL4HGSSXZEw0hkrZacc8aGE0xS3SqE=;
        b=syNwRJDtPTCPIekmJYs3IFAwM9f/zSbJOI6S9zRvkFfQzLoyKxrJNIaDIhHrSvpZdb
         5GJII9lXrWJi7ifmm/VRElh0dQc04r7A/qrJfGEchqKaX7ySy/vMrNyb9Ad/Zv93sqMl
         HGSzRYEQA1Qkv+tqBGRXpDlnKCdtJSdZUVMjY5tt4PlRLKbgFP5GwwUmRBN9EU3P+kUL
         eXczvX6LFnfYBXmNBzAYd6OMsmyQrbxeAmnNspzg+pQDxJFptnb++XpkG49mELA9afM6
         dDVNVzqKXAen+NjSiGGP2BQSCXP/iWlgqXUDy+DGqTPbpKZ+J9HWkfMOie+7/PQYssFE
         5IKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763869386; x=1764474186;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=atGl1KFG9w/JBAL4HGSSXZEw0hkrZacc8aGE0xS3SqE=;
        b=VjLZIe4+Fo+j8ePlBrNmBgYFrr9sa7y3+ARawX8JXVfjyDIJ6DBA9zS6vSTavJz4Kh
         +8fRvcdat1ipVkNE6cAE7I3btjj15INFqFjwXw8S9CGJ7ggCJNWMtD/VrtkgvfKBgO1D
         GZoMYVwjl9dYMkKTtHDLgeeGJUrYQqOsDPaDhTA7Y6SaRkhlnkZgVb1mK3Jiy2DNc9Ml
         e5hPwMFsGk/UfSsF3qFWzgxSJi22mUWuilkABR7heIui0VgxvQroBYbpyqO+nVPrj+1l
         lnYKuP5DvkWcpO0p2a+eF7OnxsMIbdgijFfjum/K+7NUoOzoiGpzOLMbSUa960aVrQYM
         f32Q==
X-Forwarded-Encrypted: i=1; AJvYcCVw2xRJeXfi91CrcRM0FseaqbaCMNJTnAu8nQDQ5nsvWpd5XVTMtYenGkskmwTYk+QmnzySU9JCKg==@kvack.org
X-Gm-Message-State: AOJu0YzQ9QJfRXkiFi9/wdHQaYXy6fZYkJTc3xEBdrGMXc0Aqhqbh7Gh
	nkGgUuxfzxSe/8IBt4oQrt0SHrk9gl6/XYTr7BZacU7g0aJV4+TZQzj6ilPw5Idr2g==
X-Gm-Gg: ASbGncsMW250I98ObF4EC1fiRmxZQn2T3Obl+5VXzFe5A74yTa+kqv1AzO1CTnRKtQl
	F6LP70wDYeO8KhF1SzYycx9S+ZKCgohAGK1yIwN6AJqwmYSzGqqex9FgV2EQ+jcOZ9I2A8E80/J
	91aWyjfKuHcmCVegHePaleH1v9CoCP8C3lBXbexBFuchedBdr1syDqAVTapEcdxwArb8LevRSWW
	vH51Ofhfz+imMUmZqNZ16eh2MJs/zHC35aJM/V22WCLYYHYei1xhPjnF6ybAUfsujVcIBg74IWI
	uK+O6EwoRP2kwGKCTH3X1RB2SS0aQ3LSYIVCD8sn0L9LT7iC85zqQXl8UpdCTOI0egAXsZPZgCg
	h9PePRYxA2x/BrpH7e4QypE1AsBJ4iJ7UJxOrvlOohkKSBztOkQ5qLcOMKROwlel91Mc4atr5Er
	TQlfaTr5n2YOWnAmMz5keE1eUToiYgt78ujXeizLiknB+d2gx5JI1Hj2HzmZ0c4ZCZU4FUloU=
X-Google-Smtp-Source: AGHT+IGxGBlznVg0SJDf4cRndAQ7Zg95tSoW1YUzecdZ7j9X7Q+uJQzQQ08yWuk+41zaU5qKqnuE3g==
X-Received: by 2002:a05:690c:4a05:b0:786:57f5:b49a with SMTP id 00721157ae682-78a8b4d4018mr62168257b3.29.1763869386403;
        Sat, 22 Nov 2025 19:43:06 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79953584sm30955797b3.49.2025.11.22.19.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 19:43:05 -0800 (PST)
Date: Sat, 22 Nov 2025 19:42:51 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
    Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
In-Reply-To: <20251113084022.1255121-7-hch@lst.de>
Message-ID: <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 876A7160008
X-Stat-Signature: cpysanmkmmu3wbx4ru3x41y8i3jdy3sh
X-HE-Tag: 1763869387-454261
X-HE-Meta: U2FsdGVkX18VnS5r6qmQlNkEYi9uPiRM17Mh+s9rRonVb0G/6/kDg1dQLnDdVFtUO6W9bb4bjdmsMiaPHyaFHz97pkAz0foKaZeYg1ZWvrOGITwbRDSjoze8dZYvOtjcF5532z8G9rdpbzyRf8bM6uJKcZq8A7WMGWos9/J3YIrz/M8Pydz6CQGelNX5FK2ayd8MBBsZrPOhmkXr2mGnGR90YHzJrCB+P5WCNUk9KVZzJk9jQ3qX1sq8m1EAOyqfy5VFn38GmQzxOWqkqz4f8xlMnqQK/F7CrA/r2gBDWmoSotfDpMU8wnVwtO2S98v3W3WnJT4bo6xA65VUq2KfWYxWW3PqeDu/NbQg6X1G+bXCtsdWbh10mxSfZjHEsOwDWQPfd4ZIdNNLRhEVAFp+oSjJW0u2L2nK2B9GqE0+N/W+VjDxET0AFmvfAsTd6KCGAIPAZ8oPF2YhgAhH2LjcTAqBszfYPXFhkFIt20okomkn7lX41/iTNooFtpA0BZQYzrfIhBrP4vuMU2yJ4qv+3yj1DCYdKrakwEB/N0+RZ72YTRkPhkXgOh5VYlp5Lj52qb5cZFR+QgDx6IB+Hrf9VYsHaow4btlqZWChePcxs6y+khuSKJZN7pzvkdJLgDVq63QyBMMRL1sppTMJ3kiZt6zUbfiFBGw3bjXyZ1pzsRkdORoMHAUMM5YDjwBc7T+xIcz+duRxCHMDm8cHnEHSjDeuB+0JXWH+AGGndUKPyI1il1nRiTxN2KIGYhrbE67lYFP8gJJeQLz4w/2z1keXVPwYlqGz/09VfJTJpS8EDkAOdfNV7Y+vSOEsOOgdK9ZNLMZ/GtRI4FLtHNnBd38nWCxti/FmHYUVjLmZL/d6n47mqNpe3Ex3Ld9BG/zkAk3DdLIhRfBqsAcWD8JE416KnTEPZaaqhgW7ckPwRK4eGFzfAMRJ9vbxRD47ThJE5nB2qJzU7H2KsU/cMKyxwyq
 mFiLxExU
 FV/pCU5TzWvo+8prXLiQl8QpfsqYAQ2fIJyR6b/l90W+/1wEw1Xh7jlz9oH+L7EXOaTjI1acwMDJ+RZCva+bkGXDQlx4HQL+D8zuUYyW8JQSWoPiY+sLRBUvt6ksaYJjLlApiqkqG/ekabpjaTKZIvRBa21BOryJHKDx05huIX/jkP0lm4nY0B4FHJVH5itKffocbufol10cmXW9kShRHTe9KbPfMRkoRbD3FFs2So38ac02QIZtu/HFCtCXMB1QQwnLapCIHa5pN7qsC+tv0KIt9RbzyDVYeeONXAVEdqYJ+Tx3dP+F0JRmCpT9VicSTUxRrVFRMKTD8fUKbBEoWjh1EMrp8CIMdYlfGhHIPPayC+IobOzdfrEPoJeDV8zrOwt/6sUwaneOSIPOIrR8BhrYhiDpnWeQrxw2F7cPzuhIDQ/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025, Christoph Hellwig wrote:

> Add a helper for the mempool_alloc slowpath to better separate it from the
> fast path, and also use it to implement mempool_alloc_preallocated which
> shares the same logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
...
> @@ -413,8 +457,6 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>  {
>  	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
>  	void *element;
> -	unsigned long flags;
> -	wait_queue_entry_t wait;
>  
>  	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
>  	might_alloc(gfp_mask);
> @@ -428,53 +470,22 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>  		element = pool->alloc(gfp_temp, pool->pool_data);
>  	}
>  
> -	if (likely(element))
> -		return element;
> -
> -	spin_lock_irqsave(&pool->lock, flags);
> -	if (likely(pool->curr_nr)) {
> -		element = remove_element(pool);
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -		/* paired with rmb in mempool_free(), read comment there */
> -		smp_wmb();
> +	if (unlikely(!element)) {
>  		/*
> -		 * Update the allocation stack trace as this is more useful
> -		 * for debugging.
> +		 * Try to allocate an element from the pool.
> +		 *
> +		 * The first pass won't have __GFP_DIRECT_RECLAIM and won't
> +		 * sleep in mempool_alloc_from_pool.  Retry the allocation
> +		 * with all flags set in that case.
>  		 */
> -		kmemleak_update_trace(element);
> -		return element;
> -	}
> -
> -	/*
> -	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
> -	 * alloc failed with that and @pool was empty, retry immediately.
> -	 */
> -	if (gfp_temp != gfp_mask) {
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -		gfp_temp = gfp_mask;
> -		goto repeat_alloc;
> -	}
> -
> -	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
> -	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> -		spin_unlock_irqrestore(&pool->lock, flags);
> -		return NULL;
> +		element = mempool_alloc_from_pool(pool, gfp_mask);
> +		if (!element && gfp_temp != gfp_mask) {

No, that is wrong, it breaks the mempool promise: linux-next oopses
in swap_writepage_bdev_async(), which relies on bio_alloc(,,,GFP_NOIO)
to return a good bio.

The refactoring makes it hard to see, but the old version always used
to go back to repeat_alloc at the end, if __GFP_DIRECT_RECLAIM,
whereas here it only does so the first time, when gfp_temp != gfp_mask.

After bisecting to here, I changed that "gfp_temp != gfp_mask" to
"(gfp & __GFP_DIRECT_RECLAIM)", and it worked again.  But other patches
have come in on top, so below is a patch to the final mm/mempool.c...

> +			gfp_temp = gfp_mask;
> +			goto repeat_alloc;
> +		}
>  	}
>  
> -	/* Let's wait for someone else to return an element to @pool */
> -	init_wait(&wait);
> -	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> -
> -	spin_unlock_irqrestore(&pool->lock, flags);
> -
> -	/*
> -	 * FIXME: this should be io_schedule().  The timeout is there as a
> -	 * workaround for some DM problems in 2.6.18.
> -	 */
> -	io_schedule_timeout(5*HZ);
> -
> -	finish_wait(&pool->wait, &wait);
> -	goto repeat_alloc;
> +	return element;
>  }
>  EXPORT_SYMBOL(mempool_alloc_noprof);
...

[PATCH] mempool: fix NULL from mempool_alloc_noprof()

mempool_alloc_noprof() with __GFP_DIRECT_RECLAIM used to loop until it
had allocated an element, but recently regressed to returning NULL when
pool->alloc and mempool_alloc_from_pool() have both failed twice, causing
oops in __swap_writepage() (and presumably others relying on mempool).

Fixes: 1d091d2c5bf3 ("mempool: factor out a mempool_alloc_from_pool helper")
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mempool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1558601600ba..dc9f2a1dc35f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -576,7 +576,7 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
 		 * with all flags set in that case.
 		 */
 		if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
-		    gfp_temp != gfp_mask) {
+		    (gfp_mask & __GFP_DIRECT_RECLAIM)) {
 			gfp_temp = gfp_mask;
 			goto repeat_alloc;
 		}
-- 
2.51.0

