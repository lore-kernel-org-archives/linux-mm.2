Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B16CC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE426B00A3; Thu, 30 Jul 2026 05:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F466B00A6; Thu, 30 Jul 2026 05:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537316B00A7; Thu, 30 Jul 2026 05:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCAA6B00A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:22:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FDC01408E5
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:22:19 +0000 (UTC)
X-FDA: 85044901998.13.B9E8A6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B75171C0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:22:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GX8vXUoM;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tG6cmXvm95wjXcqB8dvCOqPznntDpzBFT2+tmIJffq4=;
	b=iNleAe+dCUupPMI2EFt4SE+7fA7Nu7CQD0GWKi0es/qIOeruopRhJ1oDWFeMUMEIzzTNeB
	bwIxPc6gLjgVvSfFEmEKzDgsqw1aRhlNw+aNnOGKlrNQMNxtv9LPfZMex6SUNf9S0Vz/5H
	wMLbafn4VgLJSsJkn7j1k/9DD5Cdnao=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GX8vXUoM;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785403337;
	b=PqfbffQmwD7b2T2rcRqN2yR4UZnGA82l6QV7Suvydy3trNIe6r/n7Wm21LCdpJCDrZ1ZeQ
	j8u85IWbMjcyej4r4799SXJ/OVFayMjNGGaOeJsA2UtddYQoocCtqN3serX/LKEM+BwANp
	AKaIvHgr270xBJNYgIcDfRBbnzKQ6Ms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3820400C3;
	Thu, 30 Jul 2026 09:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4731F000E9;
	Thu, 30 Jul 2026 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785403336;
	bh=tG6cmXvm95wjXcqB8dvCOqPznntDpzBFT2+tmIJffq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GX8vXUoMPS74Qq8B+Tq0b69jgz1uhRRrIyHKabEiUKKHoZ3ViacaCkpqYYKZxIznj
	 qKZujjl4n7lvWZvgjgYibkx1/Q6L1sJivWDRu9PqF3gpRocIh3EfbVSQiv42bW3l8Z
	 H6cQ6UXiyy3c+DwXRrc21ng5ngJkQm7p2lN89KowbtQNAUA3kxIGG5At/zQx1P4Y5p
	 hMSTe1AjsBHgikiEWt5QFdZjCvbmTZNg3IwjkZia+m9H40VM8RNB10KIzgPRPTcAMh
	 WIoAmUZQen4gm8AKrSCNKIMRyxdx374WRlzA7z6xPR9p120jYLbXl20S/OZPoVTImi
	 LC6oeUUSdNBiA==
Message-ID: <25d560df-6d7e-462a-a987-60a8695793ba@kernel.org>
Date: Thu, 30 Jul 2026 11:22:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes 2/2] mm/huge_memory: fix huge_zero_pfn race
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>,
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B75171C0003
X-Rspamd-Server: rspam01
X-Stat-Signature: hokebsxuk7mceymw7h75h3riuaz3o38p
X-HE-Tag: 1785403337-664618
X-HE-Meta: U2FsdGVkX19cPsP9Pcg/hZ7rPgodyBpFIVP3KaxkD/6FkOH5qNscAFVxixUc3RMMVaE/jLAzZ8h1/zxt+I+hDa0NmMlp21/Jq2py9bARRV/e72GlyTvF34SviU2x7X+V1z82Dz6HQ5blSLf0o0E/Mh95ICIgiDFVX0fZhO3E/Hqh4EifB1LH1exVJw6ewWDk4wRg7RqhAebVrZ+cae2eizMU8FzYMmDaO/RnK0Jra8cqzMOXRQvL0aPqPGX89tc77ng785pRLv7DLeRX+KHgMx711My/iZUX4TH+bM6zVVyRsRlObYF/VKe+411affBWyhBF+Y9z1AnALO4Da49f0kDvscez8uKGhtcJ7b4t1GROow5dD7ZGOymFsgxyiop8Ol7C565xtS6PU0PSKNFiAiO7Cz2QEUnASC1Fwhd0TJlrSUFaRZ5Rz8HVDaX12em9jVWpnfehf7X3NCHSnMFZo7IKpYhvh2i6hKXAfnGo0mjVZ7wMtD0leVQEACD3P+bC1W4qmlZMtSRQAdmQPgz59/ubBPNUilElWs2Oa9dUK1o3MAW8dPp/fcy4KiYBJ8eHiiCJmUXKe+XDVDWl7JzUJQGMTjlcxeUZzdteKwSB6Oq7RDbgcKchgmU85Ir23l1zg5fUHo5Vbilk1E2eatqo6TqPppOXekRzyv8jWVqZX95HeOHavVXqKvkl7a4pikmeTMhjtXmVu1fszq3EW1fLgW9Xv0jmUW2snKMRBMhMmQsWrBNwPxFt4F0uDz1WuOJBnVLxDBb8pxJjYolPVYt22TEVNMGjGCdn1Y3SRmgXkyRe7YSgOaFltuR/nuOI14A3EXqoEBDVWWF0LfJsSblWOc9g0QMLvuulmHJ8hGhDF1frph4kZ9FSykid4/oaf+CZgoTwU6GKQ6CWd8HiXk+Mm4kSAHZVHP99+Fyy3wCQqdmSJX4CdUunLgb958yqnwcBF8NZjUaeq++8kV7YZqh
 qIH7GycA
 VK2EXTLjxCzCovWZ9P9fZdM9hfkb4w+Tg62lj2F/9NLVLPnnV8UqVQc8GC0LoyBC3bqdfzgk9ZqZrYhAABP7VP2z9KSbF7zE2izKM+Ud6YM14eq/kegHMxm+tgRJYAsEv8G+zFC/lW8dSG8at1BYPK/hY6NsU0l2slR5gg3CYDFi9ujTatqqZ4mnaD/ggFUtsNkuSa7Yv5ghinAq4WKwuUJ+Ay6n/EvJjvPic4s96fZoHcqM4AEvLMF8S8RQhBZD8tD9tTG8CrsYX/ewXdTLtE58vieAt0ScTys0cbwswpIyVX6aCslBT8lxdlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> So invariants are required - huge_zero_refcount MUST:
> 
> * Only be set in the huge_zero_lock critical section to ensure
>   serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
>   writes.
> 
> * Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
>   so installation of the huge zero folio on read page fault ensures
>   concurrent is_huge_zero_*() calls correctly identify the huge zero folio.
> 
> * Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
>   respectively, and atomically.
> 
> Establish these by:
> 
> * Only updating huge_zero_refcount in the huge_zero_lock critical section
>   in get_huge_zero_folio() and shrink_huge_zero_folio_scan().

That is imprecise. huge_zero_refcount is updated (incremented) outside of
huge_zero_lock in get_huge_zero_folio().

> 
> * Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
>   after huge_zero_[pfn, folio] are set. This is paired with
>   atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
>   non-zero value if huge_zero_[pfn, folio] are set.

That makes sense, yes.

> 
> * Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() to ensure that it
>   is set zero only when equal to 1 and set atomically.

What we already do, yes.

> 
> * atomic_cmpxchg() being fully ordered ensures this is done prior to
>   huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.

Which is always the case for atomic_cmpxchg() I think, yes.

[...]

>  
> @@ -270,7 +272,8 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
>  static bool get_huge_zero_folio(void)
>  {
>  	struct folio *zero_folio;
> -retry:
> +
> +	/* Paired with atomic_set_release(). */
>  	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
>  		return true;
>  
> @@ -278,17 +281,21 @@ static bool get_huge_zero_folio(void)
>  	if (unlikely(!zero_folio))
>  		return false;
>  
> -	preempt_disable();
> -	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
> -		preempt_enable();
> +	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
> +	spin_lock(&huge_zero_lock);
> +	if (huge_zero_folio) {
> +		/* Somebody else already installed it. */
> +		atomic_inc(&huge_zero_refcount);

You replace the retry loop by an atomic_inc() here.

That works now by moving the atomic_cmpxchg() in shrink_huge_zero_folio_scan()
under the lock as well, so it cannot go away concurrently.

Worth spelling that out in the patch description (unless I missed it).

> +		spin_unlock(&huge_zero_lock);
>  		folio_put(zero_folio);
> -		goto retry;
> +		return true;
>  	}
> +	WRITE_ONCE(huge_zero_folio, zero_folio);
>  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
> +	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
> +	atomic_set_release(&huge_zero_refcount, 2);

Ah, that must now go into the lock as well, otherwise the concurrent
atomic_inc() would be problematic as well.

> +	spin_unlock(&huge_zero_lock);
>  
> -	/* We take additional reference here. It will be put back by shrinker */
> -	atomic_set(&huge_zero_refcount, 2);
> -	preempt_enable();
>  	count_vm_event(THP_ZERO_PAGE_ALLOC);
>  	return true;
>  }
> @@ -312,15 +319,22 @@ static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
>  static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  						 struct shrink_control *sc)
>  {
> -	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> -		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> -		BUG_ON(zero_folio == NULL);
> +	struct folio *zero_folio;
> +
> +	/* Paired with critical section in get_huge_zero_folio(). */
> +	scoped_guard(spinlock, &huge_zero_lock) {
> +		/* Paired with atomic_inc_not_zero() in get_huge_zero_folio(). */
> +		if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1)
> +			return 0;
> +
> +		zero_folio = huge_zero_folio;
> +		VM_WARN_ON_ONCE(!huge_zero_folio);
> +		WRITE_ONCE(huge_zero_folio, NULL);
>  		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
> -		folio_put(zero_folio);
> -		return HPAGE_PMD_NR;
>  	}

One important point: The folio can't get freed and reallocated before we updated
huge_zero_folio/huge_zero_pfn I think.

The folio_put() should involve a full memory barrier (atomic RMW) and not get
reordered.

So we cannot misclassify the folio in new context as still being the zero folio.

LGTM, thanks!

-- 
Cheers,

David

