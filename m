Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A78C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3039D6B0095; Thu, 30 Jul 2026 05:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBDD6B0096; Thu, 30 Jul 2026 05:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A4A6B009B; Thu, 30 Jul 2026 05:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE1AB6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:55:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90FDA160905
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:55:55 +0000 (UTC)
X-FDA: 85044986670.27.9D17649
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E08A11C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:55:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iQAxh5/2";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785405354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmFHZYjYEhR9L2M0IZ+yGiKhRvSdesMu7mGYmAquCHA=;
	b=gNyQUhi66+tarSo14ZubD+Bb36ZKmi69eIfDRkPQoUsHURk32s0S8yF7DrDiYEEgtJLnwh
	A+BjF4dRBKPxJqkjXPwOc41A6fsM/bn9+KeyKelePjkRJsO1ZZx9diFNkysMF4RjNJvhA1
	awLVe3k+8sORadE23TeMeQg1oCIdnzY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iQAxh5/2";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785405354;
	b=HnDvQSiCZSAgJ5kTYTrLpMWM5NaOMPnVt1MoRyFwifOaH3Tc94RhVOAVoAw8c9KRwOHj6c
	YS9iBYo+KWpjF2oQ3dRMw7sVveKNQDeDCbKCE4BrChQc6s/f5f2Qv0MrtAXJeywjZy+OtL
	z1gmXRe8DWA2xzoDkA480GQIhUSD2/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 145A543558;
	Thu, 30 Jul 2026 09:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E3E1F000E9;
	Thu, 30 Jul 2026 09:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785405353;
	bh=LmFHZYjYEhR9L2M0IZ+yGiKhRvSdesMu7mGYmAquCHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iQAxh5/2Z1A09Gu12kg0ZxT+ocYlRgFAurgIufhDqIRNwShR9zznJWDPoCBPOv+vY
	 3osgeFo9Er+RIAO09ZwPAu+62IbwmuwFLeuO06yi2lL2eJcTPzzit4DmNIZok7ga3/
	 lZZs/jNQ7aAiHqCodLRmOvC2gte1hqztTLjiKY3z7yI77J3iLf5IdBqQqQuDsx1iSS
	 EkVxnAqk7tCnATlIy9l/0mWLXqybx0E5cufxhggGNWsUxyS5+lcZ0hYXgTXD55H8fr
	 7NJsmksSobGQTpbDfRcX0sD2KMCFjwG/gCyFmGsawE209FcTcSBr6ngfhybS2rUe47
	 PwFVTE+2bXSpg==
Date: Thu, 30 Jul 2026 10:55:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 2/2] mm/huge_memory: fix huge_zero_pfn race
Message-ID: <amsch6HvEH5IJjfM@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
 <25d560df-6d7e-462a-a987-60a8695793ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25d560df-6d7e-462a-a987-60a8695793ba@kernel.org>
X-Rspamd-Queue-Id: E08A11C0009
X-Rspam-User: 
X-Stat-Signature: k5ckrz8a5qy4dbunyhruaukypr9udukb
X-Rspamd-Server: rspam04
X-HE-Tag: 1785405353-119518
X-HE-Meta: U2FsdGVkX1/HIMK76Yl7kZuYe9USzBmKCH/L4dWshJre9D0e4/Wlryb1RWsZjlYpzRSCzQNDfKtnXLURyX1FRbIiO1tolHMvSx+OoPsy1ufNZ30ZEm4zcZQpSx5qWYY8UfDonjPwUaG2PyOL+qb/+dMhtHXx3WZmXXGrEDL6hcpSr3zMZ1x0Xr8T4QKt7m14KOu+89b0CDGQlA/NpmykH8spCDMCZjEiW5ocLQE4Yr02FA8K+1tNwLKpsHyxUGf/o+eYlIo/x0emLo1c1gZd0eJd7xGjcSvkmC8QvDoPE6J6hlwZN//5nrabZtsb5lSmPz/W8DQHZlbU2bB+vnmxO1D0jkV5Kg7wNr78W9RWZoFjs33BI8caV0ZJUDMTRpgtGesdTaENXzpoweB2ZHj6RBoJfY1ZtxV/18fdnmQpWPi9NW6I1Xg1Tfx3nuXxCfpf/DEk6NBzNwH/O1ZZVz7oA3OQEdIr2EtltMP3t3PpKNU9eYnnKe8vGiTsRXBcX1bC66Z0kzYeEG2SPMOut+iPFw/M9XlsYYR9zh+mNpZfRiyb1NoRSC80YtyT6t6nVqxs8MydgEtVFe5wNWotNv8/6J6IaKhYnxGIfbrbAnRDnxBZp8x86fj91X6UOYNtlCFbENjuNspeoA1pIYLALpxKdAzYkraGzrMl2RJ2wExKKh93BPVw6bx2eSTxL18c4HHtBm+uXtlZwnzJcgToebjKYx2tm+dcI9KqYfwvz9hV34JPwGrAL2gh+owxGAvMAx8Fv3lvKciy/55WzFUPo4L/hf4dXb3qi7esqsGOWZEwsLDPUhoww0zoka1mns96u8CFVgFLk1VJWy+N+rLC66BupYHkCnd3yn+ItbjoG4Yfh2ZjzWyCCKRoAf1+B6Yh3y0zb30xksNfFwjSI3DxIt4S8OmCzY5lTFfvTvNtxhob9qYJkkdmT73q/Z/7Gt9DyUGiLhA3VvHoU2s5DOgEgZI
 ErJuTEP5
 iIrxUejPa3MFyW4o1iFAWYh8Rb3XP6S1WRPPbgmQaBDNzKOFsIpv0iE9xha9fJ+sOASQ1TcJTadtR+cHmwyScdJ5ia5mZXRnkZdzEXxGzMIOgZwpFx01rpMkg7x1VPskIMBu33d1iwP83hLv2/ztoniu5gsnDU4z7heNzMszloCiPxXg+qPhZKeNOsda+1Cbwx+Xjsk/0aRaKqRMV19FLfTTwciJQWBrngfBHg/0Mxaxd3V72JiJv7xE4Utf8Iykn6IKcR7CeTBisTw9dskxnBfNObIgvCAERTZiXoXyAWSHn7Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 11:22:09AM +0200, David Hildenbrand (Arm) wrote:
> [...]
>
> > So invariants are required - huge_zero_refcount MUST:
> >
> > * Only be set in the huge_zero_lock critical section to ensure
> >   serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
> >   writes.
> >
> > * Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
> >   so installation of the huge zero folio on read page fault ensures
> >   concurrent is_huge_zero_*() calls correctly identify the huge zero folio.
> >
> > * Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
> >   respectively, and atomically.
> >
> > Establish these by:
> >
> > * Only updating huge_zero_refcount in the huge_zero_lock critical section
> >   in get_huge_zero_folio() and shrink_huge_zero_folio_scan().
>
> That is imprecise. huge_zero_refcount is updated (incremented) outside of
> huge_zero_lock in get_huge_zero_folio().

You're right.

->

* Only setting huge_zero_refcount to zero or an absolute value in the
  huge_zero_lock critical section in get_huge_zero_folio() and
  shrink_huge_zero_folio_scan() and updating atomically elsewhere.

Seems better?

>
> >
> > * Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
> >   after huge_zero_[pfn, folio] are set. This is paired with
> >   atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
> >   non-zero value if huge_zero_[pfn, folio] are set.
>
> That makes sense, yes.
>
> >
> > * Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() to ensure that it
> >   is set zero only when equal to 1 and set atomically.
>
> What we already do, yes.

Yup, point is it's part of why the invariant holds.

>
> >
> > * atomic_cmpxchg() being fully ordered ensures this is done prior to
> >   huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.
>
> Which is always the case for atomic_cmpxchg() I think, yes.

Yup.

>
> [...]
>
> >
> > @@ -270,7 +272,8 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
> >  static bool get_huge_zero_folio(void)
> >  {
> >  	struct folio *zero_folio;
> > -retry:
> > +
> > +	/* Paired with atomic_set_release(). */
> >  	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> >  		return true;
> >
> > @@ -278,17 +281,21 @@ static bool get_huge_zero_folio(void)
> >  	if (unlikely(!zero_folio))
> >  		return false;
> >
> > -	preempt_disable();
> > -	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
> > -		preempt_enable();
> > +	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
> > +	spin_lock(&huge_zero_lock);
> > +	if (huge_zero_folio) {
> > +		/* Somebody else already installed it. */
> > +		atomic_inc(&huge_zero_refcount);
>
> You replace the retry loop by an atomic_inc() here.
>
> That works now by moving the atomic_cmpxchg() in shrink_huge_zero_folio_scan()
> under the lock as well, so it cannot go away concurrently.

Yup. The retry logic in general would be silly now.

>
> Worth spelling that out in the patch description (unless I missed it).

OK.

>
> > +		spin_unlock(&huge_zero_lock);
> >  		folio_put(zero_folio);
> > -		goto retry;
> > +		return true;
> >  	}
> > +	WRITE_ONCE(huge_zero_folio, zero_folio);
> >  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
> > +	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
> > +	atomic_set_release(&huge_zero_refcount, 2);
>
> Ah, that must now go into the lock as well, otherwise the concurrent
> atomic_inc() would be problematic as well.

Yup. It's all very delicate.

>
> > +	spin_unlock(&huge_zero_lock);
> >
> > -	/* We take additional reference here. It will be put back by shrinker */
> > -	atomic_set(&huge_zero_refcount, 2);
> > -	preempt_enable();
> >  	count_vm_event(THP_ZERO_PAGE_ALLOC);
> >  	return true;
> >  }
> > @@ -312,15 +319,22 @@ static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
> >  static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
> >  						 struct shrink_control *sc)
> >  {
> > -	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> > -		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> > -		BUG_ON(zero_folio == NULL);
> > +	struct folio *zero_folio;
> > +
> > +	/* Paired with critical section in get_huge_zero_folio(). */
> > +	scoped_guard(spinlock, &huge_zero_lock) {
> > +		/* Paired with atomic_inc_not_zero() in get_huge_zero_folio(). */
> > +		if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1)
> > +			return 0;
> > +
> > +		zero_folio = huge_zero_folio;
> > +		VM_WARN_ON_ONCE(!huge_zero_folio);
> > +		WRITE_ONCE(huge_zero_folio, NULL);
> >  		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
> > -		folio_put(zero_folio);
> > -		return HPAGE_PMD_NR;
> >  	}
>
> One important point: The folio can't get freed and reallocated before we updated
> huge_zero_folio/huge_zero_pfn I think.

It's non-LRU + set not-rmappable so there's nothing that would do that AFAICT.

>
> The folio_put() should involve a full memory barrier (atomic RMW) and not get
> reordered.

Yeah will mention in commit msg.

>
> So we cannot misclassify the folio in new context as still being the zero folio.
>
> LGTM, thanks!

Thanks!

>
> --
> Cheers,
>
> David

CHeers, Lorenzo

