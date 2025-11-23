Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0450CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 17:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F526B0024; Sun, 23 Nov 2025 12:49:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF956B0030; Sun, 23 Nov 2025 12:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6978C6B00A6; Sun, 23 Nov 2025 12:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 543916B0024
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:49:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAA3114016A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:49:22 +0000 (UTC)
X-FDA: 84142608564.02.933EA02
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id DEC82C000B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:49:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aDJuG8h3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763920160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lLgXKdZ+zTDTzgdon+lya5F7bzs0gv5/kPgOiRFpQ8=;
	b=uMfbodzdMthxMretjmC7dCyJJR2SwpQ/h5p5+h7cQZJofFlu9pL4oSJ0Fh25bSkEFknbXS
	XB6L+cAezQUqZh+sa1RIB/QpU7u7ivxiUqVllLB/XW4p21AD+6UpF8aDuAjen3V0hHinBR
	a1phMWZ77EnDZu3yTJPwsHo5wjefJ6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763920160; a=rsa-sha256;
	cv=none;
	b=0VItqmv4ChYKmJfJBJFwNwqM/pXwmFzNARM4J0XQd0rZ/b3G5IGuxm3yAN+ivO8wxmhfCt
	8IPXciJE/SIQghbK143qRCq4/J++2nruoxG39SzxCNT+2P4AKeaGAZ4Gb3g4Gawap9wKd0
	pP/58niSbd83XToEf8uHGrar2XEQVbs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aDJuG8h3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7815092cd0bso32923647b3.2
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763920160; x=1764524960; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lLgXKdZ+zTDTzgdon+lya5F7bzs0gv5/kPgOiRFpQ8=;
        b=aDJuG8h31o+kSGyO9UYl0mDs6dkm75un7np5NRwbWnSdr7I935/PCuJze3gkl7hDkE
         bYwFn1eQLrUgnlLAkt/HHcbLAwpLCEges17Zn42FqqbrysI5rGq9LmzqUc2oTW7eCTID
         iNFEOnxKtUA5uui8smiCRFoBH1nmLhSzgTE53uBFVCpUExJSqd3Mn+e4nZMcRHlQ1eif
         e5JDHGJfsuXZem1e15o95r5gl3Kqpz8xeeZYiPlDwG1m2LaTZlSQEn+k0aEHhWSNB3RH
         /6O53arZfuPy4aWelV00314u4BC3/Nxu8D1nsJxbLMpq+XKkGomgsD8AtofQsxZpaw4y
         E/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763920160; x=1764524960;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5lLgXKdZ+zTDTzgdon+lya5F7bzs0gv5/kPgOiRFpQ8=;
        b=UM25PRzFJtoz1+cgjeCyG2B98p8gbxGZN1BKSdnaznGD1tln+gjKjOla0j8SVPvPNW
         Ka0UIoEL/INE4tdkIdYqLc7vJnIGArX9OoHe4RC0Gqs1AQwvgcJJStbvAd7Q5An2vbxg
         aA1LEMtketSJ07hyysYKZYK6U5mucyWsVUnayl26s4R8BLFeYpskKIBSkb72QrIVzwiz
         6sxjtLt17bdTOQ7S6raSaYZuzbNoPsQCIVYzrH2CT6Ot+IVbS5okyP0ha8hTmFszGdvb
         lZbbcMCzhtIb9S59SfNcGEn1h3OF9qGIYZ+d3wtdSCysMMsivczbrU9nbEbf3W47MSFf
         4hhA==
X-Forwarded-Encrypted: i=1; AJvYcCU6aKoUug0lxpIGLI8ZcBprfjTp+zp88S9cbY3l0RN/IvPzvTaQNXIxwgs5Mq20a0SObFBEC/QFDA==@kvack.org
X-Gm-Message-State: AOJu0YylJZ9Y7IhfcWFi79Pyzd3nzojfOAnIqsUUaXcHgJmmuTeR21Hh
	n3vBWXEQIFBsb6KWQ5AAJEqhll5+3Q9qM8SU5/PJhjxAoejepQNi7LPtLK1muLRlUw==
X-Gm-Gg: ASbGncv9t7BJULy6qdaQkOqkwC6/lmkCtlXATIqID7YMslu3nwkjzmxocktO0HxcSaw
	R56X/2rNoVN0fr9VB+EXgJLnB0zu3duVANy5pjHQnEPOxx+qbv8K7u+vY885sktg6P5XG/w8589
	3ixeLOWQutaJMGafj2g0eBoWUt4Zu3CmOro1D+iS3xPo1ljTJUoLLkpCl9yDh6kRfvlR6WEOtMF
	PrfWVHe9jXArwvmLcpDcdSO875WsQDXwCRfVz74fk/+9z1rrN2Kn8VnAILMu86PqhMmR8DBArwZ
	/C2gcftdiWlvRMta6Ex/ouY8QSM35/30D60s+HcX/ahiBVddbBr9QEB0wYV3Yl+5bnJbKEzBfkO
	8sItiQeEgsUZbhuRKZmCbto8lwX2WJ4jNLsUGt9ICB9EAoq/3g5s91f7nYYi9dZpPYw9hQYjanN
	bxSrJUUJGMKoRekyipwK3Z+FhjQIRFb/kad1Au8ItAjoMZGL5EYqGZqS14rDW1Rxz2qJ5/Aq4=
X-Google-Smtp-Source: AGHT+IGbDSkHYRbM7lgco7/onahBlAGpTDd64qpGSNVB0DFL/YhCO2ClP1ZFOcTnwsTgOv51dJxnIw==
X-Received: by 2002:a05:690c:34ca:b0:786:4459:cb84 with SMTP id 00721157ae682-78a8b4c5749mr154845607b3.29.1763920159658;
        Sun, 23 Nov 2025 09:49:19 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-642f71ae739sm4009148d50.25.2025.11.23.09.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 09:49:18 -0800 (PST)
Date: Sun, 23 Nov 2025 09:49:08 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
    Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
In-Reply-To: <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
Message-ID: <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de> <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com> <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: nne94m86azwf64ojsp9ddnn7bfi8kq3b
X-Rspam-User: 
X-Rspamd-Queue-Id: DEC82C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763920160-974094
X-HE-Meta: U2FsdGVkX19AhvMLfPOS+/8sCb6pkkjDgSczfvmzeBgrc99qQ8JzD9APb1pkjq7JKRBHUIbJa0U4HoiCNsfsG392JW0jamXLcl7ecdAE1PFqNCXP5Nb4QUV7chKlzNjAaQ84niTBvIevM2JZZGoYiKLR/jGNAD475MYzqvzGI1P+Sgleh0dH+xwdplj9jp0td0qbPwlw4yGOs7M643uU9TPae9GyczOIE5RHdJ1Lf8A2vZuz0xUYVZMob4nUW8ZrVQ3jVp1z7qvzNTLACwPL+dR5zdZBL6rkH4uTTBRS13eZsOs+Umh9ggb73JEBdK5p/jjabltCkG71aZE52grC9/DK05KsuKQr8KyUfMbt6bXhCtTMJt7g4uM8IfiaH66LnmxLtMrzkQkR+ICCP2a+9zQNUA+IA/md2wTJ9Kb4txzGU5eIrOwc2e6YWIBeCKlObD0MAI9Rk+zQiedGCE99i14/6er8EMAauce0WZFrFRqu/j+cdIo7aStHYgoawldf/VUccqeWSIzJjauQLARMqbdaSL6gmAqGcrNyCrxnaIIvgYwNTovjwPJ+/hnxQj7Xc2wGxLJHPllkjXcnWwQJRqkDv5QXHv+d7/ieFM5PMb4/kcl+5gGqk6Pc5Xv8KzgfzPUXv5qf4cpoMx19eYJOPbY9HxNKbEBF0gkuyCBVN0//Uftm/D2gE0Mk2eMrgPKSZc8jBIRio5Cblccy6HstfO5nZMyecKMdkKXOYYX5+08DaILGt1mnWxAPU+2DLP/OuZL3hrXGz97TpbO7l6gSu85nPE+/H6P5HgEvPSJr8bKZMDm94eZ2R/k6I9RJgAPDua+XppUnvx5tvfqZCaM/ACbmzo8d5EC7nnqCyZ9qzmInh4nK0154cDozsNpd95AsDVEdU9YRlDYCxb3vAkArY1OkKs9rfyVMxSOHAdGC8eHQ6cuuiUfkvTeofecGKgOxGRsPpmCSQV2TqF8V6E5
 BlOg53tx
 iJPpG9yXYl4/4y4EQg7caEyLU5n01u3O6+2piKe5zsHWqcPQ/3MymMANrn4ZT5c46Kbbg+2D3NtJjlHShXEJGX0csBYu8JMKmHf71HPQqzigPjktQ3SjplOunjdZpblfpP6jBF1+EtDmz6TJg2ZzrE8510Bo2gc/WfVFdHtvSVp2LvvnVG+c5lf5U9uVRYmGS1jEAGXJWBLhQtenrmBLZilHlkv4EZa5jd23ET1MYqabgSdDdHqMDFc7bXzd10/meeq8iEL9oUbNYDAgEQsNylqYH+DLlTHO8W+7phnbpGttu5E1hgk9ZaT+VR6xbPd/yXiZaVAm0J+zON4RKW/EUEEe/QG5exz5TcNqVIVSItnDkIfJJavTCng+eSGFDNX80WC+xygHvmCvklbOb1tPxTKFxZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Nov 2025, Vlastimil Babka wrote:
> On 11/23/25 04:42, Hugh Dickins wrote:
> > On Thu, 13 Nov 2025, Christoph Hellwig wrote:
> > 
> >> Add a helper for the mempool_alloc slowpath to better separate it from the
> >> fast path, and also use it to implement mempool_alloc_preallocated which
> >> shares the same logic.
> >> 
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> ---
> > ...
> >> @@ -413,8 +457,6 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
> >>  {
> >>  	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
> >>  	void *element;
> >> -	unsigned long flags;
> >> -	wait_queue_entry_t wait;
> >>  
> >>  	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
> >>  	might_alloc(gfp_mask);
> >> @@ -428,53 +470,22 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
> >>  		element = pool->alloc(gfp_temp, pool->pool_data);
> >>  	}
> >>  
> >> -	if (likely(element))
> >> -		return element;
> >> -
> >> -	spin_lock_irqsave(&pool->lock, flags);
> >> -	if (likely(pool->curr_nr)) {
> >> -		element = remove_element(pool);
> >> -		spin_unlock_irqrestore(&pool->lock, flags);
> >> -		/* paired with rmb in mempool_free(), read comment there */
> >> -		smp_wmb();
> >> +	if (unlikely(!element)) {
> >>  		/*
> >> -		 * Update the allocation stack trace as this is more useful
> >> -		 * for debugging.
> >> +		 * Try to allocate an element from the pool.
> >> +		 *
> >> +		 * The first pass won't have __GFP_DIRECT_RECLAIM and won't
> >> +		 * sleep in mempool_alloc_from_pool.  Retry the allocation
> >> +		 * with all flags set in that case.
> >>  		 */
> >> -		kmemleak_update_trace(element);
> >> -		return element;
> >> -	}
> >> -
> >> -	/*
> >> -	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
> >> -	 * alloc failed with that and @pool was empty, retry immediately.
> >> -	 */
> >> -	if (gfp_temp != gfp_mask) {
> >> -		spin_unlock_irqrestore(&pool->lock, flags);
> >> -		gfp_temp = gfp_mask;
> >> -		goto repeat_alloc;
> >> -	}
> >> -
> >> -	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
> >> -	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
> >> -		spin_unlock_irqrestore(&pool->lock, flags);
> >> -		return NULL;
> >> +		element = mempool_alloc_from_pool(pool, gfp_mask);
> >> +		if (!element && gfp_temp != gfp_mask) {
> > 
> > No, that is wrong, it breaks the mempool promise: linux-next oopses
> > in swap_writepage_bdev_async(), which relies on bio_alloc(,,,GFP_NOIO)
> > to return a good bio.
> > 
> > The refactoring makes it hard to see, but the old version always used
> > to go back to repeat_alloc at the end, if __GFP_DIRECT_RECLAIM,
> > whereas here it only does so the first time, when gfp_temp != gfp_mask.
> > 
> > After bisecting to here, I changed that "gfp_temp != gfp_mask" to
> > "(gfp & __GFP_DIRECT_RECLAIM)", and it worked again.  But other patches
> > have come in on top, so below is a patch to the final mm/mempool.c...
> 
> Thanks a lot Hugh and sorry for the trouble.
> 
> Looking closer I noticed we're also not doing as the comment says about
> passing the limited flags to mempool_alloc_from_pool() on the first attempt.
> 
> I would also rather keep distinguishing the "retry with full flags" and
> "retry because we can sleep" for now, in case there are callers that can't
> sleep, but can benefit from memalloc context. It's hypothetical and I haven't
> made an audit, but we can clean that up deliberately later and not as part
> of a refactor patch.
> 
> So I'd amend this patch with:
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index c28087a3b8a9..224a4dead239 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -478,10 +478,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
>                  * with all flags set in that case.
>                  */
> -               element = mempool_alloc_from_pool(pool, gfp_mask);
> -               if (!element && gfp_temp != gfp_mask) {
> -                       gfp_temp = gfp_mask;
> -                       goto repeat_alloc;
> +               element = mempool_alloc_from_pool(pool, gfp_temp);

Haha, no.

I had got excited when I too thought that should be gfp_temp not gfp_mask,
but (a) it didn't fix the bug and (b) I then came to see that gfp_mask
there is correct.

It's looking ahead to what will be tried next: mempool_alloc_from_pool()
is trying to alloc from mempool, and then, if it will be allowed to wait,
waiting a suitable length of time, before letting the caller try again.
If you substitute gfp_temp there, then it just does the same pool->alloc,
alloc from mempool sequence twice in a row with no delay between (because
gfp_temp does not at first allow waiting).

I agree it's confusing, and calls into question whether that was a good
refactoring.  Maybe there's a form of words for the comment above which
will make it clearer.  Perhaps mempool_alloc_from_pool() is better split
into two functions.  Maybe gfp_temp could be named better.  Etc etc: I
preferred not to mess around further with how Christoph did it, not now.

(I also wondered if it's right to pool->alloc before alloc from mempool
after the wait was for a mempool element to be freed: but that's how it
was before, and I expect it's been proved in the past that a strict
pool->alloc before alloc from mempool is the best strategy.)

> +               if (!element) {
> +                       if (gfp_temp != gfp_mask) {
> +                               gfp_temp = gfp_mask;
> +                               goto repeat_alloc;
> +                       }
> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
> +                               goto repeat_alloc;
> +                       }

I still prefer what I posted.

Hugh

>                 }
>         }
> 
> 
> With the followup commit fixed up during rebase, the diff of the whole
> branch before/after is:
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 5953fe801395..bb596cac57ff 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -555,10 +555,14 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
>                  * with all flags set in that case.
>                  */
> -               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
> -                   gfp_temp != gfp_mask) {
> -                       gfp_temp = gfp_mask;
> -                       goto repeat_alloc;
> +               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_temp)) {
> +                       if (gfp_temp != gfp_mask) {
> +                               gfp_temp = gfp_mask;
> +                               goto repeat_alloc;
> +                       }
> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
> +                               goto repeat_alloc;
> +                       }
>                 }
>         }
> 

