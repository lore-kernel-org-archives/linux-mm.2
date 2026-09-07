Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A16CC79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A836B00A0; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251DB6B009F; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6226B00A2; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D49496B009F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:55:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CB6DC0608
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:25 +0000 (UTC)
X-FDA: 85185450210.28.DB797C7
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3ED6780006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJdBNTEj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788749723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+iUkUxgaSWtiw9iQ5P17wcBLkBN7HFLYpLdyQUKQKE=;
	b=FTQMcOpsaiZc0qkFX7PXXKXalFUEtC1WUtAILFnMSdNemG0JPsXP0QSuL5exeT8qQv+pKu
	KXlMP8Eqgd2jwHf7KNO8C56PaNszMhtj3SvxkRoKqxRvoa7pl92J1spr6QVoMO4zNOmxn1
	Q1iMMMmArtRilWR0pyJ1xPlcvugMjCM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJdBNTEj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788749723;
	b=TeR9dPD0mYPehCW6mPtGWXpcQ8tn5P+EInH52Lgzs5GDAx3qn0FxUM2DEEr/OUr151qCM3
	fkSBoiB76g8D7Y5eFh/kCM7IcMRWJs9I022In3ZkUX5gyKcKBmzj4nwYnPLTXtn2INvooh
	FIzQbJsZybAt3epgwZmDLm437d4ewM0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YvblxpY6vkq4OCD00FIjqN1K66OMC+qJBIhUOND8BwU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788749721; v=1; x=1789354521;
 b=rJdBNTEjgkmBQG/DMXokTwK42VRIBZIv6Ffv+tld34JEYeicpV0iS68hTRZi7Xo6zgVe8zHL
 3Xa2nwL8PxbkoCp1vR9gN33lpCqPbiyGB2xMIsP0FNgebDDjWmuH+pqlavGyyt9ADvSqmUpUzoi
 lIZv/F0uc3tCPjnq+XkLMngU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4eb2748bc5b24aff;
	Mon, 07 Sep 2026 02:55:15 +0000
X-Mizu-Trace-ID: 4eb2748bc5b24aff
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 10:55:10 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: harry@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm/slub: make the case handling in __slab_free()
 easier to follow
Message-ID: <ap4mTkqFJsIwXBEO@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <b81e9fba-9567-4bd4-ad9a-08c8f03dbb14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b81e9fba-9567-4bd4-ad9a-08c8f03dbb14@kernel.org>
X-Stat-Signature: ggyy4fe73eh3sddxk8roy1cpmnebe65n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3ED6780006
X-Rspam-User: 
X-HE-Tag: 1788749723-173226
X-HE-Meta: U2FsdGVkX19PH7Ctavy9VzriAqkaAnzSGi6rVz2mXG0C20+MCRDrKEwD386xTy8w+y22dSBb0gHWn2fY/KR+FiXzbuC8eSF1K4DyluLDwPsWu1/WRKw/YaU3ZNU6gdlZM23+Rimuqqeph+UsyYR6PabgpI1pYpC7WY73qmpmZTposIyNCnCHiZ01vC+8+CfdZ6+LOMHP2uiKa2RDn7v0R/9ykW80OXygINT4IO6vaRscXExeH8fqf19Ad+6XFuawW5zx7QHj5pDXlmL7pcJR4WuNic5dcArhJ6CL3vVWyw5BZ+wy58hUa39of3xwdU2lieIcDYqVaUEbCbt1aM9gbCaTEH3wySY4A/fEyyHeUqleSNPy+pzeE3VBDdg4vmnkfHISmyy9CAmrSBjbQiKkpTHmMPPY2QRBhy6WfpvEJ+5HvRZEIVsxr0jlyAyaCTsQQU6R5x7ldzdfwvjN60xWQm++BRVpE/Y7cbcCFbs7bXZn6C/a7Mq58APlNiesatGXtZQ3f9EOkoVQlODvoIgd78yH0VZ+kIX1dLstRFEGkRQdx3mcx/kpettZZANTtu4Nkxf/nN/WCmjLmThAe5XMzDCOV4BAc1qI4NHjm2rXK4YIXv2ohujOfONRK2W1Txy0KDuk844RPSShEbdGL8pjzcDIRy+CJeh2A4aq8OVovAtUtEUDsxslCYn/ZWbTzUkYo7nn4JUUyxiXAVdVLYgxiEu/cVrdM3bIqwx39gjzhYrZT+owDq2Z9HIO5APxgVlq/BmX63Ct4vuxBxdHB8dgLdS2HXx9XrGMcvVtmxSMklgByuD1ODK0RjZXnNjuGugTOXamI0BSRQV1rCK8c1J1aca/Pmzz/3vInWI2FNVTdFm0bJX8kyIpaOGgZ6IhPWzA9HTRBmOOFj7+xDTwvl4j29rACTH65GqKTAj0MQSXQ2sVVPSdd2drBkOP0Q1bghzaYaAjs5B6gytVUglHYSC
 vcMhTpCQ
 xy64BYgU/pkDuEk+G3LJnaNlgvwXCUh92siuJu7IGUPNyr//MgGhQQm36kbXm86mZsbsN/qBauoqCHjM5YTtFc3WDT6D1cVHbzmkaR896ddhXNW/1LfPt5vqa9TfjwYaW+n/oRuhWYjmhd8VnLG8IvKS2emW7wCaj40Cv/KexXF0bJ0W7iwk3m5mzAKiadieHUiDruGzWO3iRSrrmA3QPqC4M4WSjtfo0HIViVmYAUmuySk45bx9lmpN6xC0JIXOR5wItlJ5oEntrFA6+FKAznoZt0cXxXZGjEMwQcs6NsZ8MTMlGWo1nz+FaQMGe3Vq/BrztWRDxumzSu19xlPPJ3X5cvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 06:04:25PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/24/26 14:25, Hao Li wrote:
> > There are 7 possible transitions in __slab_free():
> > 
> >   a. partial->partial
> 
> maybe add "(offlist/onlist doesn't matter)"

Exactly, this should be split into two subcases. will do.

> 
> >   b. partial->empty, offlist
> >   c. partial->empty, onlist, exceeding min_partial
> >   d. partial->empty, onlist, not exceeding min_partial
> >   e. full->empty, exceeding min_partial
> >   f. full->empty, not exceeding min_partial
> >   g. full->partial
> > 
> > (There is no offlist variant of e, f and g as a full slab is on no
> > list.)
> > 
> > Clarify which case each branch handles, and replace the goto with a
> > return at the end of the skipped block so that every branch explicitly
> > states its coverage.
> > 
> > Case 'a' is the only path that needs neither list_lock nor list
> > handling. Give it an early continue: handling it upfront is much clearer
> > than forcing every other case into a nested block.
> > 
> > Also, read SL_partial once after the loop right where it is used, rather
> > than re-reading it on every iteration.
> > 
> > No functional change.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> 
> Nit:
> 
> > ---
> >  mm/slub.c | 95 ++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 49 insertions(+), 46 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index b0cd0572e2f2..e20375307770 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5748,76 +5748,79 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
> >  		new.inuse -= cnt;
> >  
> >  		/*
> > -		 * Might need to be taken off (due to becoming empty) or added
> > -		 * to (due to not being full anymore) the partial list.
> > -		 * Unless it's frozen.
> > +		 * partial->partial: the slab was on the node partial list and
> > +		 * stays there, so we need no list handling and no list_lock.
> 
> I think more accurate is "if the slab was on the node partial list, it stays
> there, and if it was off, it stays off, so we need no..." ?

Yes, this is clearer, will do!

> 
> > +		 *
> > +		 * Note that continue in a do-while goes on to evaluate the
> > +		 * condition below, so we do perform the freelist update.
> >  		 */
> > -		if (!new.inuse || was_full) {
> > -
> > -			n = get_node(s, slab_nid(slab));
> > -			/*
> > -			 * Speculatively acquire the list_lock.
> > -			 * If the cmpxchg does not succeed then we may
> > -			 * drop the list_lock without any processing.
> > -			 *
> > -			 * Otherwise the list_lock will synchronize with
> > -			 * other processors updating the list of slabs.
> > -			 */
> > -			spin_lock_irqsave(&n->list_lock, flags);
> > +		if (!was_full && new.inuse)
> > +			continue;
> >  
> > -			on_node_partial = slab_test_node_partial(slab);
> > -		}
> > +		/*
> > +		 * The slab might need to be taken off (due to becoming empty)
> > +		 * or added to (due to not being full anymore) the partial
> > +		 * list.
> > +		 *
> > +		 * Speculatively acquire list_lock before calling cmpxchg(), as
> > +		 * performing cmpxchg() prior to lock acquisition races with
> > +		 * concurrent paths, such as the shrinker.
> > +		 *
> > +		 * If the cmpxchg does not succeed then we will drop the
> > +		 * list_lock and retry.
> > +		 */
> > +		n = get_node(s, slab_nid(slab));
> > +		spin_lock_irqsave(&n->list_lock, flags);
> >  
> >  	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
> >  
> >  	if (likely(!n)) {
> > +		/* partial->partial: we didn't take the list_lock */
> > +		return;
> > +	}
> > +
> > +	on_node_partial = slab_test_node_partial(slab);
> > +
> > +	if (!was_full && !on_node_partial) {
> >  		/*
> > -		 * We didn't take the list_lock because the slab was already on
> > -		 * the partial list and will remain there.
> > +		 * partial->empty, offlist: a bulk refill has taken the slab
> > +		 * off the partial list and will put it back, so its list
> > +		 * handling is not ours to do.
> >  		 */
> > +		spin_unlock_irqrestore(&n->list_lock, flags);
> >  		return;
> >  	}
> >  
> > -	/*
> > -	 * This slab was partially empty but not on the per-node partial list,
> > -	 * in which case we shouldn't manipulate its list, just return.
> > -	 */
> > -	if (!was_full && !on_node_partial) {
> > +	/* full/partial->empty, exceed: we have enough partial slabs already */
> > +	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
> > +		/* partial->empty, onlist, exceed */
> > +		if (likely(!was_full)) {
> > +			remove_partial(n, slab);
> > +			stat(s, FREE_REMOVE_PARTIAL);
> > +		}
> > +		/* full->empty, exceed: it is on no list to remove from */
> > +
> >  		spin_unlock_irqrestore(&n->list_lock, flags);
> > +		stat(s, FREE_SLAB);
> > +		discard_slab(s, slab);
> >  		return;
> >  	}
> >  
> >  	/*
> > -	 * If slab became empty, should we add/keep it on the partial list or we
> > -	 * have enough?
> > +	 * At this point, only three cases remain:
> > +	 *   full->partial
> > +	 *   full->empty, not exceed
> > +	 *   partial->empty, onlist, not exceed
> >  	 */
> > -	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
> > -		goto slab_empty;
> >  
> > -	/*
> > -	 * Objects left in the slab. If it was not on the partial list before
> > -	 * then add it.
> > -	 */
> > +	/* full->partial; full->empty, not exceed */
> >  	if (unlikely(was_full)) {
> >  		add_partial(n, slab, ADD_TO_TAIL);
> >  		stat(s, FREE_ADD_PARTIAL);
> >  	}
> > -	spin_unlock_irqrestore(&n->list_lock, flags);
> > -	return;
> > -
> > -slab_empty:
> > -	/*
> > -	 * The slab could have a single object and thus go from full to empty in
> > -	 * a single free, but more likely it was on the partial list. Remove it.
> > -	 */
> > -	if (likely(!was_full)) {
> > -		remove_partial(n, slab);
> > -		stat(s, FREE_REMOVE_PARTIAL);
> > -	}
> > +	/* partial->empty, onlist, not exceed: it stays where it is */
> >  
> >  	spin_unlock_irqrestore(&n->list_lock, flags);
> > -	stat(s, FREE_SLAB);
> > -	discard_slab(s, slab);
> >  }
> >  
> >  /*
> 

-- 
Thanks,
Hao

